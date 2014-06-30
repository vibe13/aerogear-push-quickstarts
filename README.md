aerogear-push-quickstarts
=========================

UnifiedPush Quickstart Examples


* server
  * contacts-mobile-picketlink-secured
  * contacts-mobile-proxy
* client
  * android
  * cordova
  * ios
  * contacts-mobile-webapp


Configure Maven
---------------

### Configure Maven to Build and Deploy the Quickstarts

The quickstarts use artifacts located in the JBoss GA and Early Access repositories. You must configure Maven to use these repositories before you build and deploy the quickstarts.

_Note: These instructions assume you are working with a released version of the quickstarts. If you are working with the quickstarts located in the GitHub master branch, follow the instructions located in the [Contributing Guide](CONTRIBUTING.md#configure-maven)._

1. Locate the Maven install directory for your operating system. It is usually installed in `${user.home}/.m2/`.

            For Linux or Mac:   ~/.m2/
            For Windows: "\Documents and Settings\USER_NAME\.m2\"  -or-  "\Users\USER_NAME\.m2\"

2. If you have an existing `settings.xml` file, rename it so you can restore it later.

            For Linux or Mac:  mv ~/.m2/settings.xml ~/.m2/settings-backup.xml
            For Windows: ren "\Documents and Settings\USER_NAME\.m2\settings.xml" settings-backup.xml
                    -or- ren "\Users\USER_NAME\.m2\settings.xml" settings-backup.xml

3. If you have an existing `repository/` directory, rename it so you can restore it later. For example

            For Linux or Mac:  mv ~/.m2/repository/ ~/.m2/repository-backup/
            For Windows: ren "\Documents and Settings\USER_NAME\.m2\repository\" repository-backup
                    -or- ren "\Users\USER_NAME\.m2\repository\" repository-backup
4. Copy the `settings.xml` file from the root of the quickstarts directory to your Maven install directory.

            For Linux or Mac:  cp QUICKSTART_HOME/settings.xml  ~/.m2/settings.xml
            For Windows: copy QUICKSTART_HOME/settings.xml "\Documents and Settings\USER_NAME\.m2\settings.xml"
                    -or- copy QUICKSTART_HOME/settings.xml "\Users\USER_NAME\.m2\settings.xml"

_Note:_ If you do not wish to configure the Maven settings, you must pass the configuration setting on every Maven command as follows: ` -s QUICKSTART_HOME/settings.xml`

### Restore Your Maven Configuration When You Finish Testing the Quickstarts

1. Locate the Maven install directory for your operating system. It is usually installed in `${user.home}/.m2/`.

            For Linux or Mac:   ~/.m2/
            For Windows: "\Documents and Settings\USER_NAME\.m2\"  -or-  "\Users\USER_NAME\.m2\"

2. Restore the `settings.xml` file/

            For Linux or Mac:  mv ~/.m2/settings-backup.xml ~/.m2/settings.xml
            For Windows: ren "\Documents and Settings\USER_NAME\.m2\settings-backup.xml" settings.xml
                    -or- ren "\Users\USER_NAME\.m2\settings-backup.xml" settings.xml

3. Restore the `repository/` directory

            For Linux or Mac:  mv ~/.m2/repository-backup/ ~/.m2/repository/
            For Windows: ren "\Documents and Settings\USER_NAME\.m2\repository-backup\" repository
                    -or- ren "\Users\USER_NAME\.m2\repository-backup\" repository


### Maven Profiles

Profiles are used by Maven to customize the build environment. The `pom.xml` in the root of the quickstart directory defines the following profiles:

* The `default` profile defines the list of modules or quickstarts that require nothing but JBoss Enterprise Application Platform.
* The `non-maven` profile lists quickstarts that do not require Maven, for example, quickstarts that use other Frameworks or technologies.
* The `functional-tests` profile lists quickstarts that provide functional tests.


Use JBoss Developer Studio or Eclipse to Run the Quickstarts
------------------------------------------------------------

You can also deploy the quickstarts from Eclipse using JBoss tools. For more information on how to set up Maven and the JBoss tools, refer to the [JBoss Enterprise Application Platform Development Guide](https://access.redhat.com/site/documentation/JBoss_Enterprise_Application_Platform/) or [Get Started Developing Applications](http://www.jboss.org/jdf/quickstarts/jboss-as-quickstart/guide/Introduction/ "Get Started Developing Applications").

### Run the Arquillian Tests
----------------------------

Some of the quickstarts provide Arquillian tests. By default, these tests are configured to be skipped, as Arquillian tests an application on a real server, not just in a mocked environment.

You can either start the server yourself or let Arquillian manage its lifecycle during the testing. The individual quickstart README should tell you what to expect in the console output and the server log when you run the test.


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

