# Salesforce JavaScript Demo

This was meant as a demonstration of the capabilities of JavaScript within the Salesforce.com platform. We provide examples of JavaScript Remote Actions, DOM Manipulation, Libraries to make design and development considerably easier. These examples are shown in the context of a custom VisualForce page as well as a being integrated into a standard Salesforce page.

The overall goal of the demonstration is to quickly add products to an opportunity. This is **not** production ready. The intention is to just give a developer some guidance and real world examples of how you can leverage JavaScript and RemoteActions in Salesforce.

##File Explanations
* [pages/oppProductQuickAdd.page](http://github.com/mtetlow/SFDC.JS.Demo/blob/master/src/pages/oppProductQuickAdd.page) - This is a VisualForce page where we display and edit the products assigned to an opportunity. This is currently setup to be used in the standard opportunity page layout, however it can be easily converted to a standalone VF page by defining the opportunity record Id on line 15.
* [classes/oppProductQuickAdd.cls](http://github.com/mtetlow/SFDC.JS.Demo/blob/master/src/classes/oppProductQuickAdd.cls)  - This is the Apex class where will house all of our server sided logic. Notice the VF Page references this controller as an extension, while using the standard opportunity controller.
* [staticresources/oppProductQuickAdd_js.resource](http://github.com/mtetlow/SFDC.JS.Demo/blob/master/src/staticresources/oppProductQuickAdd_js.resource) - This is the main JavaScript file for the demo. This file performs all of the DOM Manipulation, Remote Action calls, and actions which take place within the UI.
* [staticresources/oppProductQuickAdd_css.resource](http://github.com/mtetlow/SFDC.JS.Demo/blob/master/src/staticresources/oppProductQuickAdd_css.resource) - This CSS file contains some custom styles used within the UI.
* [staticresources/jsplugins.resource](http://github.com/mtetlow/SFDC.JS.Demo/blob/master/src/staticresources/jsplugins.resource) - This zip file contains all of the JavaScript / CSS Libraries we are using. It's contents can be easily viewed [here](http://github.com/mtetlow/SFDC.JS.Demo/tree/master/resource-bundles/jsplugins.resource)
* [staticresources/home_page_component_injection.js](http://github.com/mtetlow/SFDC.JS.Demo/blob/master/src/staticresources/home_page_component_injection.js) - This JavaScript is injected into the standard Salesforce page by using a home page component added into the Sidebar layout.

##Creating this demo in your own dev org
* First you have to deploy these files using your favorite method. Eclipse IDE, MavensMate, or plain ole copy pasting into the Setup UI.
* 
