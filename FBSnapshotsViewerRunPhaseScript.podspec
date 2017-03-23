Pod::Spec.new do |s|

  s.name         = "FBSnapshotsViewerRunPhaseScript"
  s.version      = "0.1.0"
  s.summary      = "Helper script to use along with the FBSnapshotsViewer."

  s.description  = <<-DESC
                   Helper script to use along with the FBSnapshotsViewer.
                   It helps the app to recognize new failing snapshot tests
                   DESC

  s.homepage     = "https://github.com/Antondomashnev/FBSnapshotsViewer"
  s.license      = 'MIT'
  s.author       = { "Anton Domashnev" => "antondomashnev@gmail.com" }
  s.social_media_url = "https://twitter.com/antondomashnev"

  s.source       = { :http => "https://github.com/Antondomashnev/FBSnapshotsViewer/releases/download/#{s.version}/FBSnapshotsViewerRunPhaseScript-#{s.version}.zip" }
  s.preserve_paths = '*'

end
