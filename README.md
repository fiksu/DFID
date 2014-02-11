# DFID for iOS
# Copyright (c) 2014 Fiksu Inc., Released under the MIT License

##Synopsis
DFID is a Digital Fingerprinting library for iOS.  This is a native DF library and will only work for producing identifiers in iOS apps, not on the web.

##FAQ

###What can I do with this?
Digital Fingerprints can be used for many purposes in Digital Advertising.  The primary use of the DFID is to track conversions.  A typical process is to record a click on an ad for an app with a particular DFID.  Later when a user launches the app you can compute the same DFID, make the match, and presume that the click led to the installation of the app.

### How does a digital fingerprint work?
A digital fingerprint is a combination of a number of *features* that help disambiguate one device (or user) from another.  They are generally not able to **uniquely** identify a person, but they may still be extremely accurate when used in certain contexts.  A good academic starting point is Latanya Sweeney's k-anonymity work.

### What makes a good feature?
It all depends on how you will use the fingerprint as there is a balance between *stability* (how quickly the fingerprint changes) and *uniqueness* (how discriminating the feature is in a large population).  DFID is tuned for conversion tracking: connecting a click to a launch of an app.  So DFID should be relatively stable over a period of approximately a week, but be able to discriminate one ad clicker from another.

### Why did you pick these features?
The features currently in DFID are chosen based on several factors.  First, they must be accessible without extra permissions (like GPS).  Second, they should be somewhat uncorrelated, or at least not 100% correlated with other features.  Third, they should be relatively stable. (in the extreme you can see that a compass reading is identifying, but not stable).

### Why not use more apps with canOpenURL?
It is absolutely true that including more custom URL schemes to check for app installs will lead to better discrimination.  But there are two downsides to including more: 1) The more apps included the less stable the identifier will be.  If a user installs any of those apps between the click on an ad and the launch of the target app, the fingerprint will have changed.  2) Any of the apps included will not be able to use DFID for tracking their own conversions.  The can still support DFID from the ad publishing side, but necessarily if a user clicks on an ad for one of those apps and then launches the app, the fingerprint will *always* change.  That said, it is up for debate wether DFID should use more apps, but the ones currently chosen are less likely to need DFID to track their own conversions, they are likely installed on a large portion of devices (and also *not* installed), and they are likely to be installed previously and never uninstalled.
 
### How accurate is DFID?
If you are looking inside a few day conversion window to match a click to conversion, this will likely have a very high level of accuracy and precision.  We are still conducting real-world tests to measure the actual false positives and negatives.  We suspect that it has a very, very high level of accuracy due to the large number of discriminating factors available in a native app.

### Don't these identifiers change when a user changes their configurations or upgrades?
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
