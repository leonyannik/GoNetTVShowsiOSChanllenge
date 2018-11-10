# Tv Shows Challenge

This Challenge was submitted to GoNet

## Arquitecture

Mostly, the app is writen in the MVC protocol, if the app would became more complicated, and the need to reuse data across the views should pop, then I would try to use MVVM instead.
I decided to use a storyboard, due to the simpleness of the app

### Frameworks

To show that i can use third party libraries, a library that displays banners when clicking favorite is used.
intalled with cocoapods

### Persistance

CoreData was used, to save the favorite shows, and i decided to use NSURLSession instead of a thirdparty library to show that i undestand networking.

### MoreTime

With more time, i would ensure the app stability, manage better the model to avoid having Show and ShowS, make the cache more efitient and try to simulate the infinit scrolling, also, i would redesign the detail page. to make it fancier.
