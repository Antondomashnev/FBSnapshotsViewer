# Releasing FBSnapshotsViewer

There're no hard rules about when to release FBSnapshotsViewer. Release bug fixes frequently, features not so frequently and breaking API changes rarely.

### Release

Install bundle, run tests, check that all tests succeed locally and prepare the build.

```
bundle install
bundle exec pod install
bundle exec fastlane mac test
bundle exec fastlane mac build_app_zip
```

Check that the last build succeeded in [Travis CI](https://travis-ci.org/Antondomashnev/FBSnapshotsViewer) for all supported platforms.

Set release date for the version as today.

```
### 0.5.2 (24/03/2017)
```

Remove the line with "* Your contribution here.", since there will be no more contributions to this release.

```
git add CHANGELOG.md
```

Update Sparkle.

```
bundle exec fastlane mac sparkle_add_version
git add Sparkle.xml
```

Commit changes.

```
git commit -m "Preparing for release 0.5.2."
git push origin master
```

Release.

```
$ bundle exec fastlane mac release
```

### Prepare for the Next Version

Increment the version and build number in the project.

Following the [Semantic Versioning](http://semver.org/):
*  Increment the third number if the release has bug fixes and/or very minor features with backward compatibility, only (eg. change `0.5.1` to `0.5.2`).
*  Increment the second number if the release contains major features or breaking API changes (eg. change `0.5.1` to `0.6.0`).

Create a new version and mark it as Next in [CHANGELOG.md](CHANGELOG.md).

```
### 0.5.3 (Next)

* Your contribution here.
```

Commit your changes.

```
git add CHANGELOG.md
git commit -m "Preparing for next development iteration, 0.5.3."
git push origin master
```
