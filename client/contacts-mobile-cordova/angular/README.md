###3. Customize and Build Application for Angular

Please first refer to the Cordova guide located in this [README](../README.md)

* In ```www/js/controllers.js``` find the _pushConfig_ (at the top) and change _pushServerURL_ with the url of your UnifiedPush Server instance. You also need to change _senderID_, _variantID_ and _variantSecret_ with the values assigned by UnifiedPush Server and GCM or APNS:

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
**Note:** You can also copy/paste these settings from your UnifiedPush Server console

* In ```www/js/app.js``` change the value of _BACKEND_URL_ with the url of your UnifiedPush Server instance. Use ```ip``` or ```hostname``` and not ```localhost``` for the ```host``` value:

```javascript
//app.js    
.constant('BACKEND_URL','< backend URL e.g http(s)//host:port >/jboss-contacts-mobile-picketlink-secured/')
```

**Important:** Make sure that the UnifiedPush Server instance can be reached from your device (start the JBoss EAP server with the parameters ```-b 0.0.0.0```).
