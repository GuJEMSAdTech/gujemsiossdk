To publish a new version of the SDK as Cocoa Pod:

- create a branch named with the desired version number, e.g. '3.0.5'
- update version number in gujemsiossdk.podspec
- push the new branch to origin
- call "pod trunk push gujemsiossdk.podspec --use-libraries --allow-warnings" on the command line
- you might need to register your account for the CocoaPods Trunk first: https://guides.cocoapods.org/making/getting-setup-with-trunk.html
- make sure you were added as a contributor by one of the developers



To verify the podspec:

pod lib lint --verbose --use-libraries --allow-warnings
(we have a lot of dpecations due to our own update process for the SDK from 2.x to 3.0)