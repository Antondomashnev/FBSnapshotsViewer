# Contributing to FBSnapshotsViewer

This project is work of [many contributors](https://github.com/Antondomashnev/FBSnapshotsViewer/graphs/contributors).

You're encouraged to submit [pull requests](https://github.com/Antondomashnev/FBSnapshotsViewer/pulls), [propose features and discuss issues](https://github.com/Antondomashnev/FBSnapshotsViewer/issues).

In the examples below, substitute your Github username for `contributor` in URLs.

### Fork the Project

Fork the [project on Github](https://github.com/Antondomashnev/FBSnapshotsViewer) and check out your copy.

```
git clone https://github.com/Antondomashnev/FBSnapshotsViewer.git
cd FBSnapshotsViewer
git remote add upstream https://github.com/Antondomashnev/FBSnapshotsViewer.git
```

### Bundle Install and Test

Install [Bundler](http://bundler.io) if you have not previously done so on your development machine.

```
gem install bundler
```

Ensure that you can build the project and run tests.

```
bundle install
bundle exec pod install
bundle exec fastlane mac test
```

## Contribute Code

### Create a Topic Branch

Make sure your fork is up-to-date and create a topic branch for your feature or bug fix.

```
git checkout master
git pull upstream master
git checkout -b my-feature-branch
```

### Write Tests

Try to write a test that reproduces the problem you're trying to fix or describes a feature that you want to build. Add tests to [FBSnapshotsViewerTests](FBSnapshotsViewerTests).

We definitely appreciate pull requests that highlight or reproduce a problem, even without a fix.

### Write Code

Implement your feature or bug fix.

Swift style is enforced with [SwiftLint](https://github.com/realm/SwiftLint). The check is done on every compile via run phase. You can check the configuration [here](FBSnapshotsViewer/.swiftlint.yml).

Make sure that `bundle exec fastlane osx build_app` completes without errors.

### Write Documentation

Document any external behavior in the [README](README.md).

### Update Changelog

Add a line to [CHANGELOG](CHANGELOG.md) under *Next Release*. Don't remove *Your contribution here*.

Make it look like every other line, including a link to the issue being fixed, your name and link to your Github account.

### Commit Changes

Make sure git knows your name and email address:

```
git config --global user.name "Your Name"
git config --global user.email "contributor@example.com"
```

Writing good commit logs is important. A commit log should describe what changed and why.

```
git add ...
git commit
```

### Push

```
git push origin my-feature-branch
```

### Make a Pull Request

Go to https://github.com/contributor/FBSnapshotsViewer and select your feature branch. Click the 'Pull Request' button and fill out the form. Pull requests are usually reviewed within a few days.

### Update CHANGELOG Again

Update the [CHANGELOG](CHANGELOG.md) with the pull request number. A typical entry looks as follows.

```
* [#42](https://github.com/Antondomashnev/FBSnapshotsViewer/pull/42): Add action to open images in preview - [@contributor](https://github.com/contributor).
```

Amend your previous commit and force push the changes.

```
git commit --amend
git push origin my-feature-branch -f
```

### Rebase

If you've been working on a change for a while, rebase with upstream/master.

```
git fetch upstream
git rebase upstream/master
git push origin my-feature-branch -f
```

### Check on Your Pull Request

Go back to your pull request after a few minutes and see whether it passed master with Travis-CI. Everything should look green, otherwise fix issues and amend your commit as described above.

### Be Patient

It's likely that your change will not be merged and that the nitpicky maintainers will ask you to do more, or fix seemingly benign problems. Hang on there!

## Thank You

Please do know that we really appreciate and value your time and work. We love you, really.
