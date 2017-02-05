# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'FBSnapshotsViewer' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod 'SwiftFSWatcher', :git=>'https://github.com/Antondomashnev/SwiftFSWatcher.git', :branch=>'master'

  target 'FBSnapshotsViewerTests' do
    inherit! :search_paths
    pod 'Quick', '~> 1.0'
    pod 'Nimble', '~> 5.0'
  end
end
