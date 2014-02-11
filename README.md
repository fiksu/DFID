# DFID for iOS
# Copyright (c) 2014 Fiksu Inc., Released under the MIT License

##Synopsis
DFID is a Digital Fingerprinting library for iOS.  This is a native DF library and will only work for producing identifiers in iOS apps, not on the web.

##FAQ

###What can I do with this?
Digital Fingerprints can be used for many purposes in Digital Advertising.  The primary use of the DFID is to track conversions.  A typical process is to record a click on an ad for an app with a particular DFID.  Later when a user launches the app you can compute the same DFID, make the match, and presume that the click led to the installation of the app.

### How accurate is it?
If you are looking inside a few day conversion window to match a click to conversion, this will likely have a very high level of accuracy and precision.  We are still conducting real-world tests to measure the actual false positives and negatives.  We suspect that it has a very, ver high level of accuracy due to the large number of discriminating factors availible in a native app.

### Don't these identifiers change when a user changes their configuations or upgrades?
Yes, the DFID is only "semi-stable".  Upgrade your OS and you will get a new id.  DFID strikes a balance between stability of the identifier and providing enough features to make a great fingerprint.

### What *can't* I do with this?
Do not use this for identifying, or reidentifying, individual users of your app: there will be collisions.  You should use some other identifier (like identifierForVendor) or generate a random UUID and store it in userpreferences, iCloud, etc.

### Should you use this in a production system yet? 
No, it is an R+D project of Fiksu Inc. and is open for the purposes of discussion.

##Building the library
* Select "Universal Build -> iOS Device
* Build it
* You should find the universal build in something like: 
* /Users/yourname/Library/Developer/Xcode/DerivedData/aoi-csguuzeedepqimeoefdmyhpvhehh/Build/Products/Debug-universal/libaoi.a
* Drag the .a and .h into your project
* Include the following frameworks: MessageUI, CoreTelephony in your app.
* Get the ID using: [DFID dfid]

## Rejected feature ideas
* GPS: requires permissions
* Accelerometer, compass: changes all the time
* advertisingTrackingEnabled: requires the ADSupport.framework
* UDID, MAC: deprecated
* UIPasteBoard: per app now

## Credits
Inspiration taken from Yann Lechelle's "OpenIDFA": https://github.com/ylechelle/OpenIDFA But this one is open source and uses a larger set of fingerprinting techniques.  DFIDs are also not time limited.
