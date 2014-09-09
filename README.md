[![Build Status](https://api.travis-ci.org/aerogear/aerogear-push-quickstarts.png?branch=master)](https://travis-ci.org/aerogear/aerogear-push-quickstarts)

aerogear-push-quickstarts
=========================

This project contains the AeroGear ```mobile-contacts``` quickstart. It demonstrates how to develop a more advanced push example, centered around a CRUD contacts application.

The quickstart consists of individual applications, a number of which must be deployed simultaneously to achieve a fully working example. Users can view, create and manage contacts through either applications on their mobile devices or a web application. On the creation of new contacts from any one of these applications, the AeroGear UnifiedPush Server sends push notifications containing details of newly added contacts to devices that are registered with the AeroGear UnifiedPush Server for the mobile contacts application.

The individual applications contribute to the example as follows:

* ```server/contacts-mobile-picketlink-secured``` is the core server-side application and fundamental to the example. It manages the contacts data, receiving the details of new contacts as they are created in the client applications and storing the details in a server-side database. It also sends push notification requests to the AeroGear UnifiedPush Server when new contacts are created to initiate the sending of push notifications to registered devices. The server-side application rest endpoints are secured with PicketLink and can only be accessed by client applications with authenticated users. This application has no user interface.

* ```server/contacts-mobile-proxy``` layers ```contacts-mobile-picketlink-secured``` and it can only be used in conjunction with the latter. It is intended to be used when ```contacts-mobile-picketlink-secured``` must be deployed on a server that is protected behind a firewall. If the client applications trying to interface with the core server-side application are outside the firewall then it would prevent their access. So ```contacts-mobile-proxy``` is deployed on a server outside the firewall to act as a proxy or router application. This application has an accessible user interface, in which contacts can be viewed and managed as in the client applications. Note that this application has no push functionality. 

* ```client/contacts-mobile-android-client```, ```client/contacts-mobile-ios-client```, and ```client/contacts-mobile-cordova-client``` are implementations of the same client application for different mobile APIs. When the client application is deployed to a mobile device, the push functionality enables the device to register with the AeroGear UnifiedPush Server and receive push notifications when new contacts are created. The client applications are secured and authentication managed by ```contacts-mobile-picketlink-secured```. Additionally, all contact data for the client applications is sourced from the server-side application.

* ```client/contacts-mobile-webapp``` is an implementation of the client application for deployment to a server rather than a mobile device. Like the mobile client applications, this application requires authentication to view and manage contacts. But this application has no push functionality; it does not register with the AeroGear UnifiedPush Server on deployment and it does not receive push notifications when contacts are created by other client applications.


Configure Maven
---------------

### Configure Maven to Build and Deploy the Quickstarts

The quickstarts use artifacts located in the JBoss GA and Early Access repositories. You must configure Maven to use these repositories before you build and deploy the quickstarts.

_Note: These instructions assume you are working with a released version of the quickstarts. If you are working with the quickstarts located in the GitHub master branch, follow the instructions located in the [Contributing Guide](http://aerogear.org/docs/guides/Contributing/)._


1. Clone the repository
`git clone git@github.com:aerogear/aerogear-push-quickstarts.git`

2. `cd aerogear-push-quickstarts`

3. Run

`mvn clean install`

### Maven Profiles

Profiles are used by Maven to customize the build environment. The `pom.xml` in the root of the quickstart directory defines the following profiles:

* The `default` profile defines the list of modules or quickstarts that require nothing but JBoss Enterprise Application Platform.
* The `android` profile lists Android quickstarts.
* The `non-maven` profile lists quickstarts that do not require Maven, for example, quickstarts that use other Frameworks or technologies.
* The `functional-tests` profile lists quickstarts that provide functional tests.


Use JBoss Developer Studio or Eclipse to Run the Quickstarts
------------------------------------------------------------

You can also deploy the quickstarts from Eclipse using JBoss tools. For more information on how to set up Maven and the JBoss tools, see the [JBoss Enterprise Application Platform Documentation](https://access.redhat.com/documentation/en-US/JBoss_Enterprise_Application_Platform/) or [Get Started with JBoss Developer Studio](http://www.jboss.org/products/devstudio/get-started/).

### Run the Arquillian Tests
----------------------------

Some of the quickstarts provide Arquillian tests. By default, these tests are configured to be skipped, as Arquillian tests an application on a real server, not just in a mocked environment.

You can either start the server yourself or let Arquillian manage its lifecycle during the testing. The individual quickstart README should tell you what to expect in the console output and the server log when you run the test. Note you would need to build quickstarts first before you can run `functional-tests` profile and even if you enable this profile, you still need to select container runtime via `arq-jbossas-remote` or `arq-jbossas-managed` profile.


1. Test the quickstart on a remote server
    * Arquillian's remote container adapter expects a JBoss EAP server instance to be already started prior to the test execution. You must [Start the JBoss EAP server](#start-the-jboss-eap-server) as described in the quickstart README file.
    * If you need to run the tests on a JBoss EAP server running on a machine other than localhost, you can configure this, along with other options, in the `src/test/resources/arquillian.xml` file using the following properties:

            <container qualifier="jboss" default="true">
                <configuration>
                    <property name="managementAddress">myhost.example.com</property>
                    <property name="managementPort">9999</property>
                    <property name="username">customAdminUser</property>
                    <property name="password">myPassword</property>
                </configuration>
            </container>
    * Run the test goal with the following profile activated:

            mvn clean test -Parq-jbossas-remote
2. Test the quickstart on a managed server

    Arquillian's managed container adapter requires that your server is not running as it will start the container for you. However, you must first let it know where to find the JBoss EAP directory. The simplest way to do this is to set the `JBOSS_HOME` environment variable to the full path to your JBoss EAP directory. Alternatively, you can set the path in the `jbossHome` property in the Arquillian configuration file.
    * Open the `src/test/resources/arquillian.xml` file located in the quickstart directory.
    * Find the configuration for the JBoss container. It should look like this:

            <!-- Example configuration for a managed/remote JBoss EAP instance -->
            <container qualifier="jboss" default="true">
                <!-- If you want to use the JBOSS_HOME environment variable, just delete the jbossHome property -->
                <!--<configuration> -->
                <!--<property name="jbossHome">/path/to/jboss/as</property> -->
                <!--</configuration> -->
            </container>
    * Uncomment the `configuration` element, find the `jbossHome` property and replace the "/path/to/jboss/as" value with the actual path to your JBoss EAP server.
    * Run the test goal with the following profile activated:

            mvn clean test -Parq-jbossas-managed

