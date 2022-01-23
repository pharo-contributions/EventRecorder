# EventRecorder [![Build Status](https://travis-ci.org/pharo-contributions/EventRecorder.png)](http://travis-ci.org/pharo-contributions/EventRecorder)

I'm a little framework to collect data (user actions, status, systems...) from Pharo and its tools and publish it on server.

This framework has been developed by the GT team (probably T. Girba, A. Chis and others). 
Since this is a cool framework to support user experiences and collect information that for tool builders
can use to write nice research articles, I decided to invest in it and repackage it to avoid to have everything in a single package.

Migration steps done:

- ported the client part to Pharo8
- ported the server part from smalltalkhub to github
- renamed classes (GT* to ER*) and packages to avoid clash
- added a little spec2 UI to avoid dependency with the old brick widget
- rescued tests (removed duplicated tests some were already included into System-Identification-Tests)
- split packages to have better structure
.. EventRecorder
.. EventRecorder-Inspector
.. EventRecorder-Fuel
.. EventRecorder-Server 
.. EventRecorder-Help

## Installation

Load in a Pharo 8 with:
~~~
Metacello new 
  baseline: 'EventRecorder'; 
  repository: 'github://Pharo-XP-Tools/EventRecorder/';
  load.
~~~
