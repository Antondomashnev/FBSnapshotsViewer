fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## Mac
### mac generate_colors
```
fastlane mac generate_colors
```
Generate colors with SwiftGen
### mac sanity_check
```
fastlane mac sanity_check
```
Sanity check for the fastfile issues
### mac build_app
```
fastlane mac build_app
```
Create a new build of FBSnapshotsViewer
### mac build_app_zip
```
fastlane mac build_app_zip
```
Create a new build of FBSnapshotsViewer
### mac test
```
fastlane mac test
```
Run test of FBSnapshotsViewer
### mac release
```
fastlane mac release
```
Release a new version of the FBSnapshotsViewer. Uploading a new release to a GitHub and CocoaPods trunk

Before doing so don't forget to follow all steps in RELEASING.md
### mac sparkle_add_version
```
fastlane mac sparkle_add_version
```
Updates sparkle RSS file
### mac project_version_changelog
```
fastlane mac project_version_changelog
```
Returns the changelog for the given version from CHANGELOG.md

####Options

* **`version`** - version to get changelog for

* **`convert_to_html`** - whether the changelog result must be converted into HTML
### mac project_get_human_version
```
fastlane mac project_get_human_version
```
Returns the human readable project version
### mac project_get_machine_version
```
fastlane mac project_get_machine_version
```
Returns the machine project version
### mac github_set_or_update_release
```
fastlane mac github_set_or_update_release
```
Creates or updates github release.

####Options

* **`release_name`** - release name

* **`description`** - release description

* **`repository_name`** - repositiry name in format 'Antondomashnev/FBSnapshotsViewer'

* **`tag_name`** - tag name

* **`api_token`** - github api token

* **`upload_assets`** - array of paths to files to be uploaded and attached to the release
### mac git_add_or_update_tag
```
fastlane mac git_add_or_update_tag
```
Create or update tag with the given name.

####Options

* **`tag_name`** - tag name to be used
### mac github_create_release_assets
```
fastlane mac github_create_release_assets
```
Create assets to be uploaded as a github release

####Options

* **`release_version`** - releave version to be used as a part of name of asset
### mac github_create_app_release_assets
```
fastlane mac github_create_app_release_assets
```
Create app asset to be uploaded as a github release

####Options

* **`release_version`** - releave version to be used as a part of name of asset

####Return

Path to the asset
### mac git_branch_exists_on_remote
```
fastlane mac git_branch_exists_on_remote
```
Checks if the given 'branch' exists on the 'remote'.

####Options

* **`remote`** - git remote in format git@github.com:conichiGMBH/ios-fastlane.git

* **`branch`** - branch name



----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
