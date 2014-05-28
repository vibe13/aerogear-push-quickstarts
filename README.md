contacts-mobile-proxy: Example Application Using JAX-RS Technologies
=========================================================================================================
Author: Daniel Bevenius  
Level: Beginner  
Technologies: REST  
Summary: A basic example of CRUD operations that are proxied to a backend system.  
Target Product: WFK  
Product Versions: EAP 6.1, EAP 6.2, WFK 2.5  
Source: <https://github.com/jboss-developer/jboss-wfk-quickstarts>  

What is it?
-----------
It's a deployable Maven 3 project to help you get your foot in the door developing proxied web applications with Java EE 6 on JBoss.

_So what is a proxied web application?_  
The idea here is that you have a backend system that is not allowed to be exposed to direct traffic from the internet.
Yet, there is a service in this backend system that needs to be exposed but without jeopardizing the whole backend system.

The backend system would most often be protected by a firewall, and this projects application would be
deployed on a server on the other side of that firewall, on a server that is safe to expose to the world.

System requirements
-------------------

The application this project produces is designed to be run on Red Hat JBoss Enterprise Application Platform (EAP) 6.1 or 
later with the  Red Hat JBoss Web Framework Kit (WFK) 2.5.

All you need to build this project is Java 6.0 (Java SDK 1.6) or later, Maven 3.0 or later.

With the prerequisites out of the way, you're ready to build and deploy.


Configure Maven
---------------

If you have not yet done so, you must [Configure Maven](../README.md#configure-maven) before testing the quickstarts.


Start the JBoss EAP Server
-----------------------
This quickstart requires three instances of JBoss EAP running with the following quickstart deployed:
```contacts-mobile-picketlink-secured```, ```contacts-mobild-webapp```, and ```contacts-mobile-proxy```

If you have previously deployed the above quickstart then please undeploy them so we start from a clean slate. Then follow
the instructions below to startup the server with the correct ports and also to deploy the quickstart to the correct
servers.

1. Open a command line and navigate to the root of the JBoss EAP directory.
2. The following shows the command line to start the servers with the server instance that will host the
contacts-mobile-picketlink-secured quickstart

        For Linux:   EAP_HOME/bin/standalone.sh
        For Windows: EAP_HOME\bin\standalone.bat

3. The following shows the command line to start the servers with the server instance that will host the
contacts-mobile-webapp quickstart

        For Linux:   EAP_HOME/bin/standalone.sh -Djboss.socket.binding.port-offset=100
        For Windows: EAP_HOME\bin\standalone.bat -Djboss.socket.binding.port-offset=100

4. The following shows the command line to start the servers with the server instance that will host the
contacts-mobile-webapp quickstart

        For Linux:   EAP_HOME/bin/standalone.sh -Djboss.socket.binding.port-offset=200
        For Windows: EAP_HOME\bin\standalone.bat -Djboss.socket.binding.port-offset=200


   Note: Adding "-b 0.0.0.0" to the above commands will allow external clients (phones, tablets, desktops, etc...) connect through your local network.

   For example

        For Linux:   EAP_HOME/bin/standalone.sh -b 0.0.0.0
        For Windows: EAP_HOME\bin\standalone.bat -b 0.0.0.0

Configure contacts-mobile-webapp
--------------------------------
By default the _contacts-mobile-webapp_ is set up to work directly against _contacts-mobile-picketlink-secured_ as
its backend. For this quickstart we will instead have _contacts-mobile_webapp_ work against _contacts-mobile-proxy_. This
requires a change to ```contacts-mobile-webapp/src/main/webapp/js/app.js```. Please open ```app.js``` and update
the ```CONTACTS.app.serverURL``` variable to:

    CONTACTS.app.serverUrl = "http://localhost:8280/jboss-contacts-mobile-proxy";


Build and Deploy the Quickstarts
--------------------------------

1. Make sure you have started the JBoss EAP servers as described above.
2. Open a command line and navigate to the root directory of this quickstart.
3. From the ```contacts-mobile-picketlink-secured``` directory run the following command to deploy the quickstart:

        mvn clean package jboss-as:deploy
4. From the ```contacts-mobile-webapp``` directory run the following command to deploy the quickstart:

        mvn clean package jboss-as:deploy -Djboss-as.port=10099
5. From the ```contacts-mobile-proxy``` directory run the following command to deploy the quickstart:

        mvn clean package jboss-as:deploy -Djboss-as.port=10199

The reason why we need the servers to be started before deploying is that since all server are using the same configuration
file, _standalone.xml_, all deployments are persisted to this file. This means that if you restart the server
all three quickstart will be deployed which is not desirable. You can either undeploy each quickstart or edit
```standalone/configuration/standalone.xml``` and remove the ```deployments``` element.

Access the application
----------------------
Access the running client application in a browser at the following URL: <http://localhost:8180/jboss-contacts-mobile-webapp/#signin-page>.

Configure the proxy application
-------------------------------
By default there is nothing to configure in this quickstart. But you might be interested in how the proxy
is configured. The rules for the proxy can be found in
[proxy-gateway-config.json](https://github.com/danbev/jboss-wfk-quickstarts/blob/proxy-quickstart/contacts-mobile-proxy/src/main/webapp/WEB-INF/proxy-gateway-config.json).

This JSON file defines the mapping of URLs that the proxy can handle. You can define as many rules are you like and the
basic single rule looks like this:

    { "rule": "/rest/contacts", "to": "http://localhost:9080/jboss-contacts-mobile-picketlink-secured/rest/contacts"}

The can be read as: any request with a request URI of ```/rest/contacts``` should be sent to the URI of ```to```.
You can also have path parameters in your rules. For example, we have the following rule in addition to the one above
exists in this quickstart:

    { "rule": "/rest/contacts/{id}", "to": "http://localhost:9080/jboss-contacts-mobile-picketlink-secured/rest/contacts{id}"}

With this rule, any request URI in the format ```/rest/contacts/10001``` will be proxied to the URI of ```to```.


Build and Deploy the Quickstart
-------------------------------

1. Make sure you have started the JBoss EAP server as described above.
2. Open a command line and navigate to the root directory of this quickstart.
3. Type this command to build and deploy the archive:

        mvn clean package jboss-as:deploy

4. This deploys `target/jboss-contacts-mobile-proxy.war` to the running instance of the server.





Undeploy the Archive
--------------------

1. Make sure you have started the JBoss EAP server as described above.
2. Open a command line and navigate to the root directory of this quickstart.
3. When you are finished testing, type this command to undeploy the archive:

        mvn jboss-as:undeploy


Run the Quickstart in JBoss Developer Studio or Eclipse
-------------------------------------

You can also start the server and deploy the quickstarts from Eclipse using JBoss tools. For more information, 
see [Use JBoss Developer Studio or Eclipse to Run the Quickstarts](../README.md#use-jboss-developer-studio-or-eclipse-to-run-the-quickstarts) 


### Deploying to OpenShift

You can also deploy the application directly to OpenShift, Red Hat's cloud based PaaS offering, follow the 
instructions [here](https://community.jboss.org/wiki/DeployingHTML5ApplicationsToOpenshift)

Import the Project into an IDE
=================================

If you created the project using the Maven archetype wizard in your IDE (Eclipse, NetBeans or IntelliJ IDEA), then there 
is nothing to do. You should already have an IDE project.

Detailed instructions for using Eclipse / JBoss Tools with are provided in the 
[Get Started Developing Applications](http://www.jboss.org/jdf/quickstarts/jboss-as-quickstart/guide/Introduction/ "Get Started Developing Applications").

If you created the project from the command line using archetype:generate, then you need to import the project into your IDE. 
If you are using NetBeans 6.8 or IntelliJ IDEA 9, then all you have to do is open the project as an existing project. 
Both of these IDEs recognize Maven projects natively.

Debug the Application
=============================

If you want to be able to debug into the source code or look at the Javadocs of any library in the project, you can run 
either of the following two commands to pull them into your local repository. The IDE should then detect them.

    mvn dependency:sources
    mvn dependency:resolve -Dclassifier=javadoc
