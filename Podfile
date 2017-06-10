# Uncomment the next line to define a global platform for your project
platform :osx, '10.12'

target 'FBSnapshotsViewer' do
  use_frameworks!
  pod 'KZFileWatchers', '~> 1.0'
  pod 'Sourcery', '~> 0.5'
  pod 'SwiftGen', '~> 4.2'
  pod 'SwiftLint', '~> 0.16'
  pod 'Sparkle', '~> 1.17'
  target 'FBSnapshotsViewerTests' do
    inherit! :search_paths
    pod 'Quick', '~> 1.0'
    pod 'Nimble', '~> 7.0'
  end
end
