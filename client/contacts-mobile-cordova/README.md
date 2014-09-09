# quickstart-push-cordova: CRUD contact Mobile Application showing the AeroGear Push feature 
---------
Author: Erik Jan de Wit (edewit)  
Level: Beginner  
Technologies: JavaScript Cordova   
Summary: A crud mobile app with push integrated  
Target Product: JBoss Mobile Add-On  
Product Versions: 1.0.0  
Source: <https://github.com/aerogear/aerogear-push-quickstarts/tree/master/client/contacts-mobile-cordova>  

## What is it?

The ```mobile-contacts-cordova``` project demonstrates how to develop more advanced Cordova push applications, centered around a CRUD contacts application.

This client-side Cordova project must be used in conjunction with the ```mobile-contacts/server/contacts-mobile-picketlink-secured``` and ```mobile-contacts/server/contacts-mobile-proxy``` applications, which provide the accompanying server-side functionality for the application. 

When the client application is deployed to an Android or iOS device, the push functionality enables the device to register with the running AeroGear UnifiedPush Server instance and receive push notifications. The server-side application provides login authentication for the client application and sends push notification requests to the UnifiedPush Server in response to new contacts being created. Push notifications received by the Android or iOS device contain details of newly added contacts.


## How do I run it?

###0. System requirements
The Cordova command line tooling is based on node.js so first you'll need to [install node](http://nodejs.org/download/), then you can install Cordova by executing:
```shell
npm install -g Cordova
```

To deploy on iOS you need to install the ios-deploy package as well
```shell
npm install -g ios-deploy
```

#### iOS
For iOS you'll need a valid provisioning profile as you will need to test on an actual device (push notification is not available when using a simulator).
Replace the bundleId with your bundleId (the one associated with your certificate), by editing the config.xml at the root of this project, change the id attribute of the ```widget``` node. After that run a ```cordova platform rm ios``` followed by ```cordova platform add ios``` to change the Xcode project template.

If you want to change your bundleId later on, you will still have to run a ```cordova platform rm ios``` followed by ```cordova platform add ios``` to change the Xcode project template.

#### Android
To deploy and run Cordova applications on Android the Apache Ant tool needs to be [installed](http://ant.apache.org/manual/install.html).

###1. Register Application with Push Services

For the configuration and registration of Android or iOS Applications with PushServices, please refer to the specific guides inside *quickstart-push-android* and *quickstart-push-ios* quickstarts.

###2. Customize and Build Application

There are 2 examples for Cordova; one is built using [jquery mobile](jqm) and one with [angular](angular). The READMEs located in these directories will direct you to the settings you'll need to change to setup push notifications.

###3. Install platforms

After changing the push configuration you can install the platforms you want on the Cordova app. AeroGear Cordova PushPlugin currently supports Android and iOS.
```shell
cordova platform add <android or ios>
```

###4. Test Application

####0. Prerequisities
1. The UnifiedPush Server must be running before the application is deployed to ensure that the device successfully registers with the UnifiedPush Server on application deployment.
2. The ```mobile-contacts/server/contacts-mobile-picketlink-secured``` and ```mobile-contacts/server/contacts-mobile-proxy``` applications must be running before attempting to log into the mobile client application to ensure successful login. For more information, see the READMEs distributed with the server applications.

####1. Deploy for Testing
The application can be tested on physical Android or iOS devices only; push notifications are not available for Android emulators nor iOS simulators. 

To add the plugin to your Application, on the command line enter the following:
```shell
cordova plugin add org.jboss.aerogear.cordova.push
```

To deploy, run and debug the application on an Android or iOS device attached to your system, on the command line enter the following:
```shell
cordova run <android or ios>
```
####2. Log In
For the _Log In_ procedure on Android or iOS devices, please refer to the specific guides inside *quickstart-push-android* and *quickstart-push-ios* quickstarts.

####3. Send a Push Message
For the _Send a Push Message_ procedure on Android or iOS devices, please refer to the specific guides inside *quickstart-push-android* and *quickstart-push-ios* quickstarts.


Run the Quickstart in JBoss Developer Studio or Eclipse
-------------------------------------------------------

Import the generated project into JBDS  
![import](doc/import.png)

Select the project location and project  
![import-helloworld](doc/import-helloworld.png)

When prompted accept the plugin installation  
![add plugin](doc/plugin_restore.png)

Run the project on a device  
![run](doc/run.png)

Debug the Application
=====================

Start a browser Chrome for Android or Safari for iOS

iOS
* Develop -> &lt;device name> -> index.html

Android
* Menu -> Tools -> Inspect Devices -> inspect

