# contacts-mobile-picketlink-secured: Example Application JAX-RS Technologies & Push
---------
Author: Joshua Wilson, Pedro Igor, Erik Jan De Wit, Daniel Bevenius  
Level: Beginner  
Technologies: REST, UnifiedPush Java Client, PicketLink  
Summary: A PicketLink secured example of CRUD REST endpoints.  
Target Product: JBoss Mobile Add-On  
Product Versions: 1.0.0  
Source: <https://github.com/aerogear/aerogear-push-quickstarts/tree/master/server/contacts-mobile-picketlink-secured>  

## What is it?
The ```contacts-mobile-picketlink-secured``` project demonstrates how to develop secured server-side applications with push functionality, centered around a CRUD contacts application. It creates a PicketLink secured Java EE 6 application using JAX-RS, CDI 1.0, EJB 3.1, JPA 2.0 and Bean Validation 1.0.

When the ```contacts-mobile-picketlink-secured``` application is deployed, the push functionality enables the application to register with the running AeroGear  UnifiedPush Server instance and send it push notification requests. The server-side application rest endpoints are secured with PicketLink and can only be accessed by client applications with authenticated users.

When contacts are created with the client contacts-mobile application, the contact information is relayed to the ```contacts-mobile-picketlink-secured``` application. On receiving the contact infomation, this backend application sends a push notification request to the AeroGear UnifiedPush Server. The AeroGear UnifiedPush Server then routes a push notification containing details of the newly added contact to devices that are registered with the AeroGear UnifiedPush Server for the specific client application. 

**Note:** This quickstart uses the following Jackson libraries that are a part of the JBoss EAP private API.

* *org.codehaus.jackson.jackson-core-asl*
* *org.codehaus.jackson.jackson-mapper-asl*

A public API will become available in a future EAP release and the private classes will be deprecated, but these classes continue to be maintained and available for the duration of the EAP 6.x release cycle.

## How do I use it?

###0. System Requirements
* [Java 6](http://www.oracle.com/technetwork/java/javase/downloads/index.html)
* [Maven 3.0](http://maven.apache.org) or later
* Red Hat JBoss Enterprise Application Platform (EAP) 6.1

###1. Prepare Maven Libraries
This quickstart is designed to be built with Maven. You must [Configure Maven](../../README.md#configure-maven) before testing the quickstarts.

###2. Register Application with Push Services
You must register the application with the AeroGear UnifiedPush Server. This requires a running AeroGear UnifiedPush Server instance. For information on installing the AeroGear UnifiedPush Server, see the README distributed with the AeroGear UnifiedPush Server or [UPS guide](http://aerogear.org/docs/unifiedpush/ups_userguide/).

1. Log into the UnifiedPush Server console.
2. In the ```Applications``` view, click ```Create Application```.
3. In the ```Name``` and ```Description``` fields, type values for the application and click ```Create```.
4. When created, click the application name and make note of the ```Server URL```, ```Application ID```, and ```Master Secret```.

###3. Customize AeroGear UnifiedPush Java Sender and Build Application
The project source code must be customized with the unique metadata assigned to the application by the AeroGear UnifiedPush Server. 

1. Open ```[quickstarts-config.json](./src/main/resources/META-INF/quickstarts-config.json) configuration file.``` for editing.
2. Enter the ``` serverUrl ```,  ``` pushApplicationId ``` and ``` masterSecret ``` parameters.
3. Save the file.
4. Build the application
```shell
$ cd /path/to/contacts-mobile/server/contacts-mobile-picketlink-secured
$ mvn clean package
```

###4. Test Application

####0. Prerequisities
The UnifiedPush Server must be running before the application is deployed to ensure that it successfully registers with the UnifiedPush Server on deployment.

####1. Deploy for Testing

1. Start JBoss EAP
```shell
For Linux:   EAP_HOME/bin/standalone.sh
For Windows: EAP_HOME\bin\standalone.bat
```
2. Build and deploy the packaged application
```shell
$ cd /path/to/contacts-mobile/server/contacts-mobile-picketlink-secured
$ mvn clean package jboss-as:deploy
```
This deploys ```/path/to/contacts-mobile/server/contacts-mobile-picketlink-secured/target/jboss-contacts-mobile-picketlink-secured.war``` to the running instance of the server.

**Note:** Adding "-b 0.0.0.0" to the above commands will allow external clients (phones, tablets, desktops, etc...) to connect through your local network.
For example
```shell
For Linux:   EAP_HOME/bin/standalone.sh -b 0.0.0.0
For Windows: EAP_HOME\bin\standalone.bat -b 0.0.0.0
```

####2. Access the application and Create a new Contact
You can create a new contact using any of the client applications.  
Please follow the ```Build and Deploy the Quickstart``` instructions in [contacts-mobile-webapp](../../client/contacts-mobile-webapp) which describe how to build, deploy, and access the web application.  
For information on building and deploying any of the client application variants, see the READMEs distributed with these applications.  

####3. Undeploy the Quickstart

1. Make sure you have started the JBoss EAP server as described above.
2. When you are finished testing, type this command to undeploy the archive:
```shell
$ cd /path/to/contacts-mobile/server/contacts-mobile-picketlink-secured
$ mvn jboss-as:undeploy
```

## FAQ
Why cannot I enter a date in the birthdate field?

* Chrome has a [bug](https://code.google.com/p/chromium/issues/detail?id=232296) in it.
    * Use the arrow keys to change the date: up arrow key, tab to day, up arrow key, tab to year, up arrow key.
    * Use the date picker: a large black down arrow between the up/down arrows and the big X on the right side.
* Firefox, IE, and Safari require strict formatting of YYYY-DD-MM, *Note:* It must be a dash and not a slash.

## Run the Arquillian tests
By default, tests are configured to be skipped. The reason is that the sample test is an Arquillian test, which requires
the use of a container. You can activate this test by selecting one of the container configuration provided for JBoss.

To run the test in JBoss, first start the container instance. Then, run the test goal with the following profile activated:
```shell
$ mvn clean test -Parq-jbossas-remote
```
## Deploying to OpenShift
You can also deploy the application directly to OpenShift, Red Hat's cloud based PaaS offering, follow the instructions [here](https://community.jboss.org/wiki/DeployingHTML5ApplicationsToOpenshift)


## Use the Project with an IDE
You can import this project into an IDE (JBoss Developer Studio, NetBeans or IntelliJ IDEA). If you are using JBoss Developer Studio you must import the project as a Maven project. If you are using NetBeans 6.8 or IntelliJ IDEA 9, then you can open the project as an existing project as both of these IDEs recognize Maven projects natively.

You can also start the server and deploy the quickstarts from JBoss Developer Studio. For more information, see [Use JBoss Developer Studio to Run the Quickstarts](../../README.md#use-jboss-developer-studio-or-eclipse-to-run-the-quickstarts)

If you want to be able to debug into the source code or look at the Javadocs of any library in the project, you can run either of the following two commands to pull them into your local repository. The IDE should then detect them.

```shell
$ mvn dependency:sources
$ mvn dependency:resolve -Dclassifier=javadoc
```
