# Build and Install the App with Xcode

Open the project with [Xcode](https://developer.apple.com/xcode/) and
click on the "Play" button to run the application in the simulator or select a connected
physical device to install the app on the device.

# Install the IPA on a Device

If you don't have Xcode or a Mac you can install the relased IPA using Cydia Impactor.

Download Cydia Impactor for your platform from [http://www.cydiaimpactor.com/](http://www.cydiaimpactor.com/), uncompress the archive and run Cydia Impactor.

Make sure your device is listed and selected in Cydia Impactor, then:

* Select Device > Install Package...
* Select the WheresMyBrowser.ipa file
* You will be prompted for an icloud account and its password. The account is used to sign the application. If you don't have a developer account, the signature will be valid for 7 days.

Once installed, you need to trust the developer on the device:

 * Select Settings > General > Profiles
 * Select the "Developer App" profile corresponding to your Apple user
 * Select "Verify App", then Verify (This requires Internet connectivity from the phone)

You should now be able to launch the Where's My Browser app.
