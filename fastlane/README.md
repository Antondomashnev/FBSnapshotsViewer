fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

## Choose your installation method:

<table width="100%" >
<tr>
<th width="33%"><a href="http://brew.sh">Homebrew</a></td>
<th width="33%">Installer Script</td>
<th width="33%">Rubygems</td>
</tr>
<tr>
<td width="33%" align="center">macOS</td>
<td width="33%" align="center">macOS</td>
<td width="33%" align="center">macOS or Linux with Ruby 2.0.0 or above</td>
</tr>
<tr>
<td width="33%"><code>brew cask install fastlane</code></td>
<td width="33%"><a href="https://download.fastlane.tools">Download the zip file</a>. Then double click on the <code>install</code> script (or run it in a terminal window).</td>
<td width="33%"><code>sudo gem install fastlane -NV</code></td>
</tr>
</table>
# Available Actions
## osx
### osx sanity_check
```
fastlane osx sanity_check
```
Sanity check for the fastfile issues
### osx build_run_phase_script
```
fastlane osx build_run_phase_script
```
Create a new build of FBSnapshotsViewerRunPhaseScript
### osx build_app
```
fastlane osx build_app
```
Create a new build of FBSnapshotsViewerRunPhaseScript
### osx test
```
fastlane osx test
```
Run test of FBSnapshotsViewer
### osx release
```
fastlane osx release
```
Release a new version of the FBSnapshotsViewer. Uploading a new release to a GitHub and CocoaPods trunk

Before doing so don't forget to move the next version of Changelog to released as well as update FBSnapshotsViewerRunPhaseScript.podspec

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
