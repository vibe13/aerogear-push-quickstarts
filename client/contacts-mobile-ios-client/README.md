# quickstart-push-ios: CRUD Mobile Application showing the AeroGear Push feature on iOS
---------
Author: Christos Vasilakis (cvasilak)  
Level: Beginner  
Technologies: Objective-C, iOS  
Summary: A Contacts CRUD mobile application with Push notification integration.  
Target Product: JBoss Mobile Add-On  
Product Versions: 1.0.0  
Source: <https://github.com/aerogear/aerogear-push-quickstarts/tree/master/client/contacts-mobile-ios-client>  

## What is it?

This project is an iOS mobile front-end to the [Contacts](https://github.com/aerogear/aerogear-push-quickstarts/contacts-mobile-picketlink-secured) server application found in the [quickstarts](https://github.com/aerogear/aerogear-push-quickstarts) of the Red Hat [AeroGear](http://www.aerogear.org). All CRUD features are supported, as well as integration with the Push notification mechanism to instantly retrieve a new Contact when it is created on the server. A video demonstrating the application 'in-action' can be found [here](https://vimeo.com/96095487).

## How do I run it?

###0. System requirements
* iOS 7.X
* Xcode version 5.1.X

###1. Configuration

Before being able to use Push Notifications on your iOS Application, a few steps are required. You need to:

* Create a certificate Signing Request
* Create a new Apple App ID and a SSL certificate for APNs
* Create a Provisioning Profile

For information on these steps, see the AeroGear documentation: [Apple App ID and SSL Certificate for APNs](http://aerogear.org/docs/unifiedpush/aerogear-push-ios/app-id-ssl-certificate-apns) and [Apple Provisioning Profile](http://aerogear.org/docs/unifiedpush/aerogear-push-ios/provisioning-profiles).
  
###2. Register Application with Push Services

You must register the application and an iOS variant of the application with the AeroGear UnifiedPush Server. This requires a running AeroGear UnifiedPush Server instance and uses the unique metadata assigned to the application by APNS. For information on installing the AeroGear UnifiedPush Server, see the README distributed with the AeroGear UnifiedPush Server or the [UPS guide](http://aerogear.org/docs/unifiedpush/ups_userguide/).

1. Log into the AeroGear UnifiedPush Server console.
2. In the ```Applications``` view, click ```Create Application```.
3. In the ```Name``` and ```Description``` fields, type values for the application and click ```Create```.
4. When created, under the application click ```No variants```.
5. Click ```Add Variant```.
6. In the ```Name``` and ```Description``` fields, type values for the iOS application variant.
7. Click ```iOS``` and type the values assigned to the project by APNS (you will have to upload your Developer or Production Certificate)
8. Click ```Add```.
9. When created, expand the variant name and make note of the ```Server URL```, ```Variant ID```, and ```Secret```.

###3. Customize and Build Application

Replace the bundleId with your bundleId (the one associated with your certificate).
Click on the ```Contacts target -> General``` and modify the _Bundle Identifier_:

![change contacts bundle](doc/change-contacts-bundle.png)

Ensure the Apple _Provisioning profile_ is correctly set:

![change provisioning profile](doc/change-provisioning-profile.png)
  
The project source code must be customized with the unique metadata assigned to the application variant by the UnifiedPush Server and APNS.  

1. Open ```/path/to/contacts-mobile/client/contacts-mobile-ios-client/Contacts/Controllers/AGLoginViewController.m``` for editing.
2. Modify the URL, variant and secret to match the values allocated by the UnifiedPush Server and APNS for the following constants:
```objective-c
AGDeviceRegistration *registration = [[AGDeviceRegistration alloc] initWithServerURL:[NSURL URLWithString:@"<# URL of the running UnifiedPush Server #>"]];
...
[clientInfo setVariantID:@"<# Variant Id #>"];
[clientInfo setVariantSecret:@"<# Variant Secret #>"];
```
**Note:** You can also copy/paste these settings from your UnifiedPush Server console
3. Save the file.
4. Open ```/path/to/contacts-mobile/client/contacts-mobile-ios-client/Contacts/Networking/AGContactsNetworker.m``` for editing.
5. Modify the URL to match the path to the Contacts server backend:
```objective-c
static NSString * const kAPIBaseURLString = @"<# URL of the Contacts application backend #>";
```
6. Save the file.
7. Build the application

###4. Test Application

####0. Prerequisities
1. The UnifiedPush Server must be running before the application is deployed to ensure that the device successfully registers with the UnifiedPush Server on application deployment.
2. The ```mobile-contacts/server/contacts-mobile-picketlink-secured``` and ```mobile-contacts/server/contacts-mobile-proxy``` applications must be running before attempting to log into the mobile client application to ensure successful login. For more information, see the READMEs distributed with the server applications.

####1. Deploy for Testing
The application can be tested on physical iOS devices only; push notifications are not available for iOS simulators. 

####2. Log In
When the application is deployed to an iOS device, you can log into it and begin using the CRUD functionality. Note that access to the application is restricted to users registered with the server-side application and to assist you in getting started a number of default users are preconfigured.

1. Launch the application on the iOS device.
2. Log into the application using one of the default user credentials ('_maria:maria_','_dan:dan_', or '_john:john_').

	After successful login, you are presented with a list of existing Contacts residing on the server.

    ![contacts list home screen](doc/contacts-list.png)

3. Click a contact to open the Edit screen where you can modify the contact's details.

    ![contact details](doc/contact-details.png)

####3. Send a Push Message
You can send a push notification to your device using the ```mobile-contacts/client/contacts-mobile-webapp``` application by completing the following steps:

1. Open the web interface of the ```mobile-contacts/client/contacts-mobile-webapp``` application.
2. Add a new Contact.

This automatically triggers a push notification request to the UnifiedPush Server and subsequently the push notification displays on the mobile device.

![contact details](doc/notification.png)

## 'Content-Available'

Instead of the regular ```didReceiveRemoteNotification``` callback invoked when a new notification is received, the application utilizes the 'silent' push feature (offered by iOS 7 and later), so the application can be instructed to fetch the new content even if background (and possible suspended). Thus when the user opens up the app, the content is already available to be viewed. Take a look at the ```didReceiveRemoteNotification``` notification callback method inside the file ```/path/to/contacts-mobile/client/contacts-mobile-ios-client/Contacts/AGAppDelegate.m``` for the implementation details.

```objective-c
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
- ...
}
```


FAQ
---
* Which iOS version is supported by JBoss Mobile CRUD mobile app?

JBoss Mobile Add-On supports iOS 7.0 and later.

Debug the Application
=====================

Set a break point in Xcode.

