# Flutter
Flutter is the front-end application for Food Toxicity Scanner. It will run on both Android and iOS. It has been tested on Android, however, since I do not have a Apple Developer account I am unable to test iOS. You can find the compiled Android apk in the [releases page](https://github.com/NathanKolbas/FoodToxicityScanner/releases).

## Structure
The project structer follows the typical Flutter layout.
* `/lib`  
The main code for the project. This is where you will find the .dart files with logic and layout. main.dart is what is first ran when the application starts. Here are the subfloders and what they are for (mainly for orginization):  

  * `/components`  
  Used for flutter widgets that are used in multiple places throught the application.

  * `/controllers`  
  Controllers are for the controllers (wow suprizing). It contains the api which is a library for communicating with the Ruby on Rails API.

  * `/models`  
  Models are classes for how the data is structered (i.e. user).

  * `/screens`  
  This is where you can find the different screens that the user can navigate to.

* `/assets`  
Assets such as the icon, images, and vectors.

  * `/ic_launcher`  
  The launcher icon.

  * `/icons`  
  SVG and vector icons.

  * `/Images `  
  Used to store images such as jpgs or pngs.

* `/android`  
Android specific code.

* `/ios`  
iOS specific code.

* `/test`  
TODO: For testing dart code.



## Things to Note
There is a quite a few things that can be cleaned up. Some of the screen constraints are from following online tutorials which is no longer needed. The camera screen should be plit into its own files. Testing **NEEDS** to be added. Since I did not have a lot of time for this project, testing was overlooked...
