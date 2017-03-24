# FBSnapshotsViewer

[![Build Status](https://travis-ci.org/Antondomashnev/FBSnapshotsViewer.svg?branch=master)](https://travis-ci.org/Antondomashnev/FBSnapshotsViewer)
[![codebeat badge](https://codebeat.co/badges/f21f5fd8-5b7e-4cec-bc3e-8ce719300ed7)](https://codebeat.co/projects/github-com-antondomashnev-fbsnapshotsviewer)
[![codecov](https://codecov.io/gh/Antondomashnev/FBSnapshotsViewer/branch/master/graph/badge.svg)](https://codecov.io/gh/Antondomashnev/FBSnapshotsViewer)

A mac os application that shows the failing snapshot tests from [FBSnapshotTestCase](https://github.com/facebook/ios-snapshot-test-case) because it's a pain to parse the console logs by myself.

## Why FBSnapshotsViewer?

I've been using an amazing [plugin](https://github.com/orta/Snapshots) to check the failing test's snapshots, but unfortunately, with Xcode 8 the plugins are not officially supported anymore, so I've decided to build an app which will work regardless Apple's decisions about Xcode and plugins ecosystem.

There are some benefits using it:
* Real-time feedback about failed snapshot test.
* Clear output with reference | diff | failed image

![Example](Resources/Example.png)

## How it works?

The idea behind the job is quite tricky, but the overall concept is straightforward:
1. The app listens for the notification from your target when the tests are running.
2. When the app receives notification, it starts listening for changes in the snapshot images folder.
3. Whenever it finds any failing snapshot test, it parses it and a user can check it.

## Installation

### FBSnapshotsViewer application

At the moment there is only one option to install the app:
Navigate to [releases](https://github.com/Antondomashnev/FBSnapshotsViewer/releases) and download the latest `FBSnapshotsViewer-xyz.app.zip` release.

### FBSnapshotsViewerRunPhaseScript script

There are two ways to install the helper run script to tell the `FBSnapshotsViewer` that your app is currently running tests:

<details>
<summary>Binary form</summary>
1. Navigate to [releases](https://github.com/Antondomashnev/FBSnapshotsViewer/releases) and just grab a newest `FBSnapshotsViewerRunPhaseScript-xyz.zip`.
2. Extract the archive and copy `FBSnapshotsViewerRunPhaseScript` into your project.
3. Add `Path_To_Folder_With_Extracted_Script/FBSnapshotsViewerRunPhaseScript <OPTIONAL_IMAGE_DIFF_DIR>` in your test target's Script Build Phases.
</details>

<details>
<summary>Via CocoaPods</summary>
1. Add pod 'FBSnapshotsViewerRunPhaseScript' to your Podfile.
2. Add run phase for your test target `$PODS_ROOT/FBSnapshotsViewerRunPhaseScript/FBSnapshotsViewerRunPhaseScript <OPTIONAL_IMAGE_DIFF_DIR>` in your test target's Script Build Phases.
</details>

## Usage

As simple as just run the app and run tests in your app 🎉

## Contribution

Contributions to FBSnapshotsViewer are welcomed and encouraged!
Please see the [Contributing guide](CONTRIBUTING.md) for more details.

## License

FBSnapshotsViewer is available under the MIT license. See [LICENSE](LICENSE) for more information.
