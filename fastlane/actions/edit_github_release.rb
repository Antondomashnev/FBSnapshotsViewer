module Fastlane
  module Actions
    module SharedValues
      UPDATE_GITHUB_RELEASE_INFO = :UPDATE_GITHUB_RELEASE_INFO
    end

    # To share this integration with the other fastlane users:
    # - Fork https://github.com/KrauseFx/fastlane
    # - Clone the forked repository
    # - Move this integration into lib/fastlane/actions
    # - Commit, push and submit the pull request

    class EditGithubReleaseAction < Action
      def self.run(params)

        require 'net/http'
        require 'net/https'
        require 'json'
        require 'base64'

        begin
          release_id = params[:id]
          repo_name = params[:repository_name]
          api_token = params[:api_token]
          server_url = "https://api.github.com"

          dict = Hash.new
          dict["draft"] = params[:draft] != nil ? params[:draft] : false
          dict["prerelease"] = params[:prerelease] != nil ? params[:prerelease] : false
          dict["body"] = params[:description] if params[:description]
          dict["tag_name"] = params[:tag_name] if params[:tag_name]
          dict["name"] = params[:name] if params[:name]
          body = JSON.dump(dict)

          response = self.call_releases_endpoint("patch", server_url, repo_name, "/releases/#{release_id}", api_token, body)
        rescue StandardError => e
          UI.message "HTTP Request failed (#{e.message})".red
        end

        case response[:status]
          when 200
          UI.success("Successfully updated release at tag \"#{params[:tag_name]}\" on GitHub")
          body = JSON.parse(response.body)
          html_url = body['html_url']
          release_id = body['id']
          UI.important("See release at \"#{html_url}\"")
          Actions.lane_context[SharedValues::UPDATE_GITHUB_RELEASE_INFO] = body

          assets = params[:upload_assets]
          if assets && assets.count > 0
            self.delete_assets(body['assets'], server_url, repo_name, api_token)
            self.upload_assets(assets, body['upload_url'], api_token)

            # fetch the release again, so that it contains the uploaded assets
            get_response = self.call_releases_endpoint("get", server_url, repo_name, "/releases/#{release_id}", api_token, nil)
            if get_response[:status] != 200
              UI.error("GitHub responded with #{response[:status]}:#{response[:body]}")
              UI.user_error!("Failed to fetch the newly created release, but it *has been created* successfully.")
            end

            get_body = JSON.parse(get_response.body)
            Actions.lane_context[SharedValues::UPDATE_GITHUB_RELEASE_INFO] = get_body
            UI.success("Successfully uploaded assets #{assets} to release \"#{html_url}\"")
            return get_body
          else
            return body
          end
          when 400..499
          json = JSON.parse(res.body)
          raise "Error Updating Github Release (#{res.code}): #{json["message"]}".red
          else
          UI.error "Status Code: #{res.code} Body: #{res.body}"
          raise "Error Updating Github Release".red
        end
      end

      def self.delete_assets(assets, server, repo, api_token)
        assets.each do |asset|
          UI.important("Deleting #{asset['name']}")
          endpoint = "/releases/assets/#{asset['id']}"
          self.call_releases_endpoint("delete", server, repo, endpoint, api_token, nil)
        end
      end

      def self.upload_assets(assets, upload_url_template, api_token)
        assets.each do |asset|
          self.upload(asset, upload_url_template, api_token)
        end
      end

      def self.upload(asset_path, upload_url_template, api_token)
        # if it's a directory, zip it first in a temp directory, because we can only upload binary files
        absolute_path = File.absolute_path(asset_path)

        # check that the asset even exists
        UI.user_error!("Asset #{absolute_path} doesn't exist") unless File.exist?(absolute_path)

        name = File.basename(absolute_path)
        response = nil
        if File.directory?(absolute_path)
          Dir.mktmpdir do |dir|
            tmpzip = File.join(dir, File.basename(absolute_path) + '.zip')
            name = File.basename(tmpzip)
            sh "cd \"#{File.dirname(absolute_path)}\"; zip -r --symlinks \"#{tmpzip}\" \"#{File.basename(absolute_path)}\" 2>&1 >/dev/null"
            response = self.upload_file(tmpzip, upload_url_template, api_token)
          end
        else
          response = self.upload_file(absolute_path, upload_url_template, api_token)
        end
        return response
      end

      def self.upload_file(file, url_template, api_token)
        require 'addressable/template'
        name = File.basename(file)
        expanded_url = Addressable::Template.new(url_template).expand(name: name).to_s
        headers = self.headers(api_token)
        headers['Content-Type'] = 'application/zip' # how do we detect other types e.g. other binary files? file extensions?

        UI.important("Uploading #{name}")
        response = self.call_endpoint(expanded_url, "post", headers, File.read(file))

        # inspect the response
        case response.status
        when 201
          # all good in the hood
          UI.success("Successfully uploaded #{name}.")
        else
          UI.error("GitHub responded with #{response[:status]}:#{response[:body]}")
          UI.user_error!("Failed to upload asset #{name} to GitHub.")
        end
      end

      def self.call_endpoint(url, method, headers, body)
        require 'excon'
        case method
        when "patch"
          response = Excon.patch(url, headers: headers, body: body)
        when "post"
          response = Excon.post(url, headers: headers, body: body)
        when "get"
          response = Excon.get(url, headers: headers, body: body)
        when "delete"
          response = Excon.delete(url, headers: headers)
        else
          UI.user_error!("Unsupported method #{method}")
        end
        return response
      end

      def self.call_releases_endpoint(method, server, repo, endpoint, api_token, body)
        url = "#{server}/repos/#{repo}#{endpoint}"
        self.call_endpoint(url, method, self.headers(api_token), body)
      end

      def self.headers(api_token)
        require 'base64'
        headers = { 'User-Agent' => 'fastlane-edit_github_release' }
        headers['Authorization'] = "Basic #{Base64.strict_encode64(api_token)}" if api_token
        headers
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Edit a Github Release"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :owner,
                                       env_name: "GITHUB_OWNER",
                                       description: "The Github Owner",
                                       is_string:true,
                                       optional:false),
           FastlaneCore::ConfigItem.new(key: :repository_name,
                                        env_name: "GITHUB_REPOSITORY",
                                        description: "The Github Repository",
                                        is_string:true,
                                        optional:false),
          FastlaneCore::ConfigItem.new(key: :id,
                                       env_name: "GITHUB_RELEASE_ID",
                                       description: "The Github Release ID",
                                       is_string:true,
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :api_token,
                                       env_name: "GITHUB_API_TOKEN",
                                       description: "Personal API Token for GitHub - generate one at https://github.com/settings/tokens",
                                       is_string: true,
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :tag_name,
                                       env_name: "GITHUB_RELEASE_TAG_NAME",
                                       description: "Pass in the tag name",
                                       is_string: true,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :target_commitish,
                                       env_name: "GITHUB_TARGET_COMMITISH",
                                       description: "Specifies the commitish value that determines where the Git tag is created from. Can be any branch or commit SHA. Unused if the Git tag already exists",
                                       is_string: true,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :name,
                                       env_name: "GITHUB_RELEASE_NAME",
                                       description: "The name of the release",
                                       is_string: true,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :description,
                                       env_name: "GITHUB_RELEASE_BODY",
                                       description: "Text describing the contents of the tag",
                                       is_string: true,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :draft,
                                       env_name: "GITHUB_RELEASE_DRAFT",
                                       description: "true to create a draft (unpublished) release, false to create a published one",
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :prerelease,
                                       env_name: "GITHUB_RELEASE_PRERELEASE",
                                       description: "true to identify the release as a prerelease. false to identify the release as a full release",
                                       is_string: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :upload_assets,
                                       env_name: "FL_SET_GITHUB_RELEASE_UPLOAD_ASSETS",
                                       description: "Path to assets to be uploaded with the release",
                                       optional: true,
                                       is_string: false,
                                       verify_block: proc do |value|
                                         UI.user_error!("upload_assets must be an Array of paths to assets") unless value.kind_of? Array
                                       end)
        ]
      end

      def self.output
        [
          ['UPDATE_GITHUB_RELEASE_INFO', 'Contains all the information about updated release'],
        ]
      end

      def self.return_value
        "The Hash representing the API response"
      end

      def self.authors
        ["antondomashnev"]
      end

      def self.is_supported?(platform)
        return true
      end
    end
  end
end
