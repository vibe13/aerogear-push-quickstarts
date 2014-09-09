# contacts-mobile-proxy: Example Application Using JAX-RS Technologies
---------
Author: Daniel Bevenius  
Level: Beginner  
Technologies: REST  
Summary: A basic example of CRUD operations that are proxied to a backend system.  
Target Product: JBoss Mobile Add-On  
Product Versions: 1.0.0  
Source: <https://github.com/aerogear/aerogear-push-quickstarts/tree/master/server/contacts-mobile-proxy>  

## What is it?
It's a deployable Maven 3 project to help you get started in developing ```proxied web applications``` with Java EE 6 on JBoss.

_So what is a ```proxied web application```?_  
The need of a proxied web application arises when you have a backend system that is not allowed to be exposed to direct traffic from the internet, but there is a service in this backend system that needs to be exposed, without jeopardizing the whole backend system (backend systems would most often be protected by a firewall).

A proxied web application would be deployed on a server on the other side of that firewall (on a server that is safe to expose to direct traffic from the internet), and would proxy its request to the exposed service in this backend system.

## How do I use it?

###0. System Requirements
* [Java 6](http://www.oracle.com/technetwork/java/javase/downloads/index.html)
* [Maven 3.0](http://maven.apache.org) or later
* Red Hat JBoss Enterprise Application Platform (EAP) 6.1.


###1. Prepare Maven Libraries
This quickstart is designed to be built with Maven. You must [Configure Maven](../../README.md#configure-maven) before testing the quickstarts.

###2. Start the JBoss EAP Server
This quickstart requires three instances of JBoss EAP running with the following quickstart deployed:
```contacts-mobile-picketlink-secured```, ```contacts-mobile-webapp```, and ```contacts-mobile-proxy```

If you have previously deployed the above quickstart then please undeploy them so we start from a clean state. Then follow
the instructions below to startup the server with the correct ports and also to deploy the quickstart to the correct
servers.

1. Open a command line and navigate to the root of the JBoss EAP directory.
2. Start the server instance that will host the ```contacts-mobile-picketlink-secured``` quickstart
```shell
For Linux:   EAP_HOME/bin/standalone.sh
For Windows: EAP_HOME\bin\standalone.bat
```
3. Start the server instance that will host the ```contacts-mobile-webapp``` quickstart
```shell
For Linux:   EAP_HOME/bin/standalone.sh -Djboss.socket.binding.port-offset=100
For Windows: EAP_HOME\bin\standalone.bat -Djboss.socket.binding.port-offset=100
```
4. Start the server instance that will host the ```contacts-mobile-proxy quickstart``` quickstart
```shell
For Linux:   EAP_HOME/bin/standalone.sh -Djboss.socket.binding.port-offset=200
For Windows: EAP_HOME\bin\standalone.bat -Djboss.socket.binding.port-offset=200
```

**Note:** Adding "-b 0.0.0.0" to the above commands will allow external clients (phones, tablets, desktops, etc...) to connect through your local network.

For example
```shell
For Linux:   EAP_HOME/bin/standalone.sh -b 0.0.0.0
For Windows: EAP_HOME\bin\standalone.bat -b 0.0.0.0
```

###3. Configure contacts-mobile-webapp
By default the ```contacts-mobile-webapp``` is set up to work directly against ```contacts-mobile-picketlink-secured``` as its backend. For this quickstart we will instead have ```contacts-mobile_webapp``` work against ```contacts-mobile-proxy```. This requires a change to ```contacts-mobile-webapp/src/main/webapp/js/app.js```.  

Please open for edit  ```contacts-mobile-webapp/src/main/webapp/js/app.js``` and update the ```CONTACTS.app.serverURL``` variable to:
```java
CONTACTS.app.serverUrl = "http://localhost:8280/jboss-contacts-mobile-proxy";
```

###4. Build and Deploy the Quickstart
1. Make sure you have started the JBoss EAP servers as described above.
2. Open a command line and navigate to the root directory of this quickstart.
3. From the ```contacts-mobile-picketlink-secured``` directory run the following command to deploy the quickstart:
```shell
mvn clean package jboss-as:deploy
```
4. From the ```contacts-mobile-webapp``` directory run the following command to deploy the quickstart:
```shell
mvn clean package jboss-as:deploy -Djboss-as.port=10099
```
5. From the ```contacts-mobile-proxy``` directory run the following command to deploy the quickstart:
```shell
mvn clean package jboss-as:deploy -Djboss-as.port=10199
```

The reason why we need the servers to be started before deploying is that since all server are using the same configuration file, ```standalone.xml```, all deployments are persisted to this file. This means that if you restart the server all three quickstart will be deployed which is not desirable. You can either undeploy each quickstart or edit ```standalone/configuration/standalone.xml``` and remove the ```deployments``` element.

###5. Test Application
Access the running client application in a browser at the following URL: <http://localhost:8180/jboss-contacts-mobile-webapp/#signin-page>.  
Please refer to the documentation for [contacts-mobile-webapp](../../client/contacts-mobile-webapp) for details about testing these quickstarts.


###6. Undeploy the Quickstart

1. Make sure you have started the JBoss EAP server as described above.
2. Open a command line and navigate to the root directory of this quickstart
3. From the ```contacts-mobile-webapp``` directory run the following command to undeploy the quickstart:
```shell
mvn jboss-as:undeploy
```
4. From the ```contacts-mobile-proxy``` directory run the following command to undeploy the quickstart:
```shell
mvn jboss-as:undeploy
```
5. From the ```contacts-mobile-picketlink-secured``` directory run the following command to undeploy the quickstart:
```shell
mvn jboss-as:undeploy
```

## FAQ
How do I configure the proxy application?

By default there is nothing to configure in this quickstart. But you might be interested in how the proxy is configured. The rules for the proxy can be found in
[proxy-gateway-config.json](./src/main/webapp/WEB-INF/proxy-gateway-config.json).

This JSON file defines the mapping of URLs that the proxy can handle. You can define as many rules are you like; the basic single rule looks like this:
```javascript
{ "rule": "/rest/contacts", "to": "http://localhost:9080/jboss-contacts-mobile-picketlink-secured/rest/contacts"}
```
The above can be read as: any request with a request URI of ```/rest/contacts``` should be sent to the URI of ```to```.  
You can also have path parameters in your rules. For example, we have the following rule in addition to the one above exists in this quickstart:
```javascript
{ "rule": "/rest/contacts/{id}", "to": "http://localhost:9080/jboss-contacts-mobile-picketlink-secured/rest/contacts{id}"}
```

With this rule, any request URI in the format ```/rest/contacts/10001``` will be proxied to the URI of ```to```.

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
