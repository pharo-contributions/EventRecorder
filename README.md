# EventRecorder
I'm a little framework to collect data (user actions, status, systems...) from Pharo and its tools and publish it on server.

This framework has been developed by the GT team (probably T. Girba, A. Chis and others). 
Since this is a cool framework to support user experiences and collect information that for tool builders
can use to write nice research articles, I decided to invest in it and repackage it to avoid to have everything in a single package.

This is the legacy version (the original developed version of GT EventRecorder)

## Installation

Load in a Pharo 8 with:
~~~
Metacello new 
  repository: 'github://pharo-contributions/EventRecorder:legacy';
  baseline: 'EventRecorder'; 
  load.
~~~
