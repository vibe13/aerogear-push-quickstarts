quickstart-push-cordova: CRUD contact Mobile Application showing the AeroGear Push feature 
==========================================================================================
Author: Erik Jan de Wit (edewit)
Level: Beginner  
Technologies: JavaScript Cordova
Summary: A crud mobile app with push integrated
Target Product: Mobile  
Product Versions: EAP 6.1, EAP 6.2, EAP 6.3  
Source: https://github.com/aerogear/aerogear-push-quickstarts/cordova

What is it?
-----------

This project is a very crud application where you can manage contacts integrated push notifications. When a new Contact is created a notification is send to all the users.

System requirements
-------------------

What is needed for Android / iOS / Cordova:

install cordova
```
npm install -g cordova
```

To deploy on ios you need to install the ios-deploy package as well
```
npm install -g ios-deploy
```

Configure Cordova
-----------------

If you have not yet done so, you must [Configure Maven](../README.md#configure-maven) before testing the quickstarts.

Build and Deploy the HelloWorld
-------------------------------

## Change Push Configuration

In www/js/app.js find the pushConfig (at the bottom) and change the server url to your openshift instance alias and variant/secret:

```javascript
var pushConfig = {
   pushServerURL: "<pushServerURL e.g http(s)//host:port/context >",
   android: {
      senderID: "<senderID e.g Google Project ID only for android>",
      variantID: "<variantID e.g. 1234456-234320>",
      variantSecret: "<variantSecret e.g. 1234456-234320>"
   },
   ios: {
      variantID: "<variantID e.g. 1234456-234320>",
      variantSecret: "<variantSecret e.g. 1234456-234320>"
   }
};

```
You can also copy/paste these settings from your UnifiedPush console

You'll also need to install the war file and add the url of your jboss to the www/js/app.js file. Be sure that it must be reachable from your device so start jboss-as with `-b 0.0.0.0` and use and ip or hostname and not `localhost`

```javascript
//app.js    
CONTACTS.app.baseUrl = "< backend URL e.g http(s)//host:port >";

```

Install platforms
```
cordova platform add ios android
```

Add the plugin
```
cordova plugin add org.jboss.aerogear.cordova.push
```

### iOS
For iOS you'll need a valid provisioning profile as you will need to test on device (push notification not available on simulator)
Replace the bundleId with your bundleId (the one associated of your certificate), by editing the config.xml in the root of this project change the id attribute of the `widget` node. After that run a `cordova platform rm ios` followed by `cordova platform add ios` to change the xcode project template. 

Run the application on a device
```
cordova run <android or ios>
```

Application Flow
----------------------

## Sign up
When you first launch the application sign up as a new user. Username should be an email address, after signing up you can sign in with your created username and password. Now you'll see some 'dummy' users. To test that you can receive push notifications go to the UnifiedPush server console and choose 'Compose message' type a message and see that it's received on the device.



FAQ
--------------------



Run the HelloWorld in JBoss Developer Studio or Eclipse
-------------------------------------------------------

Import the generated project into JBDS
![import](doc/import.png)

Select the project location and project
![import-helloworld](doc/import-helloworld.png)

Add the plugin
![add plugin](doc/plugin-add.png)

Run the project on a device
![run](doc/run.png)

Debug the Application
=====================

Start a browser chrome for android or safari for iOS

iOS 
* Develop -> <device name> -> index.html

Android
* Menu -> Tools -> Inspect Devices -> inspect
