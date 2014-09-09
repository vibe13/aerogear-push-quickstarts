aerogear-push-quickstarts
=========================

* ```client/contacts-mobile-android-client```, ```client/contacts-mobile-ios-client```, and ```client/contacts-mobile-cordova-client``` are implementations of the same client application for different mobile APIs. When the client application is deployed to a mobile device, the push functionality enables the device to register with the AeroGear UnifiedPush Server and receive push notifications when new contacts are created. The client applications are secured and authentication managed by ```contacts-mobile-picketlink-secured```. Additionally, all contact data for the client applications is sourced from the server-side application.

* ```client/contacts-mobile-webapp``` is an implementation of the client application for deployment to a server rather than a mobile device. Like the mobile client applications, this application requires authentication to view and manage contacts. But this application has no push functionality; it does not register with the AeroGear UnifiedPush Server on deployment and it does not receive push notifications when contacts are created by other client applications.


## Default Users 

By default the 'Contacts' backend creates a list of default employees:  

(loginName / password ) 

* dan / dan
* maria / maria
* john / john 
