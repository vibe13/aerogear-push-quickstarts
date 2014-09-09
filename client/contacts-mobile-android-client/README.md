# quickstart-push-android: CRUD Mobile Application showing the AeroGear Push feature on Android
---------
Author: Daniel Passos (dpassos)  
Level: Beginner  
Technologies: Java, Android  
Summary: A Contacts CRUD mobile application with Push notification integration.  
Target Product: JBoss Mobile Add-On  
Product Versions: 1.0.0  
Source: <https://github.com/aerogear/aerogear-push-quickstarts/tree/master/client/contacts-mobile-android-client>  

## What is it?

This project is an Android mobile front-end to the [Contacts](https://github.com/aerogear/aerogear-push-quickstarts/contacts-mobile-picketlink-secured) server application found in the [quickstarts](https://github.com/aerogear/aerogear-push-quickstarts) of the Red Hat [AeroGear](http://www.aerogear.org). All CRUD features are supported, as well as integration with the Push notification mechanism to instantly retrieve a new Contact when it is created on the server. A video demonstrating the application 'in-action' can be found [here](https://vimeo.com/97464515).

## How do I run it?

###0. System requirements
* [Java 7](http://www.oracle.com/technetwork/java/javase/downloads/index.html)
* [Maven 3.1.1](http://maven.apache.org)
* Latest [Android SDK](https://developer.android.com/sdk/index.html) and [Platform version 19](http://developer.android.com/tools/revisions/platforms.html)
* Latest [Android Support Library](http://developer.android.com/tools/support-library/index.html) and [Google Play Services](http://developer.android.com/google/play-services/index.html)

###1. Prepare Maven Libraries
This quickstart is designed to be built with Maven.

Google does not ship all the required libraries to Maven Central so you must deploy them locally with the helper utility [maven-android-sdk-deployer](https://github.com/mosabua/maven-android-sdk-deployer) as detailed here.

1. Checkout maven-android-sdk-deployer
```shell
$ git clone git://github.com/mosabua/maven-android-sdk-deployer.git
```
2. Set up the environment variable ```ANDROID_HOME``` to contain the Android SDK path
3. Install Maven version of Android platform 19
```shell
$ cd /path/to/maven-android-sdk-deployer/platforms/android-19
$ mvn install -N
```
4. Install Maven version of google-play-services
```shell
$ cd /path/to/maven-android-sdk-deployer/extras/google-play-services
$ mvn install -N
```
5. Install Maven version of compatibility-v4
```shell
$ cd /path/to/maven-android-sdk-deployer/extras/compatibility-v4
$ mvn install -N
```
6. Install Maven version of compatibility-v7-appcompat
```shell
$ cd /path/to/maven-android-sdk-deployer/extras/compatibility-v7-appcompat
$ mvn install -N
```

###2. Register Application with Push Services
First, you must register the application with Google Cloud Messaging for Android and enable access to the Google Cloud Messaging for Android APIs and Google APIs. This ensures access to the APIs by the UnifiedPush Server when it routes push notification requests from the application to the GCM. Registering an application with GCM requires that you have a Google account. For information on setting your Google account to use Google’s services, follow the [Google Setup Guide](http://aerogear.org/docs/unifiedpush/aerogear-push-android/google-setup/).

Second, you must register the application and an Android variant of the application with the UnifiedPush Server. This requires a running AeroGear UnifiedPush Server instance and uses the unique metadata assigned to the application by GCM. For information on installing the AeroGear UnifiedPush Server, see the README distributed with the AeroGear UnifiedPush Server or the [UPS guide](http://aerogear.org/docs/unifiedpush/ups_userguide/).

1. Log into the UnifiedPush Server console.
2. In the ```Applications``` view, click ```Create Application```.
3. In the ```Name``` and ```Description``` fields, type values for the application and click ```Create```.
4. When created, under the application click ```No variants```.
5. Click ```Add Variant```.
6. In the ```Name``` and ```Description``` fields, type values for the Android application variant.
7. Click ```Android``` and in the ```Google Cloud Messaging Key``` and ```Project Number``` fields type the values assigned to the project by GCM.
8. Click ```Add```.
9. When created, expand the variant name and make note of the ```Server URL```, ```Variant ID```, and ```Secret```.

###3. Customize and Build Application
The project source code must be customized with the unique metadata assigned to the application variant by the UnifiedPush Server and GCM. 

1. Open ```/path/to/contacts-mobile/client/contacts-mobile-android-client/src/org/jboss/aerogear/unifiedpush/quickstart/Constants.java``` for editing.
2. Enter the application variant values allocated by the UnifiedPush Server and GCM for the following constants:
```java
String UNIFIED_PUSH_URL = "";
String VARIANT_ID = "";
String SECRET = "";
String GCM_SENDER_ID = "";
```
3. Save the file.
4. Build the application
```shell
$ cd /path/to/contacts-mobile/client/android/contacts-mobile-android-client
$ mvn compile
```

###4. Test Application

####0. Prerequisities
1. The UnifiedPush Server must be running before the application is deployed to ensure that the device successfully registers with the UnifiedPush Server on application deployment.
2. The ```mobile-contacts/server/contacts-mobile-picketlink-secured``` and ```mobile-contacts/server/contacts-mobile-proxy``` applications must be running before attempting to log into the mobile client application to ensure successful login. For more information, see the READMEs distributed with the server applications.

####1. Deploy for Testing
The application can be tested on physical Android devices only; push notifications are not available for Android emulators. To deploy, run and debug the application on an Android device attached to your system, on the command line enter the following:
```shell
$ cd /path/to/contacts-mobile/client/android/contacts-mobile-android-client
$ mvn clean package android:deploy android:run
```

Application output is displayed in the command line window.

####2. Log In
When the application is deployed to an Android device, you can log into it and begin using the CRUD functionality. Note that access to the application is restricted to users registered with the server-side application and to assist you in getting started a number of default users are preconfigured.

1. Launch the application on the Android device.
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

