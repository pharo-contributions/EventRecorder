# EventRecorder
I'm a little framework to collect data from Pharo and publish it on server.

This framework has been developed by the GT team (probably T. Girba, A. Chis and others). 
Since this is a cool framework to support user experiences and collect information that for tool builders
can use to write nice research articles, I decided to invest in it and repackage it to avoid to have everything in a single package.

Here is what I did 

- ported to Pharo8 (still 3 tests failing)
- ported the server part from smalltalkhub to github
- renamed classes and packages to avoid clash
- added a little spec2 UI to avoid dependency with the old brick widget
- rescued tests (removed duplicated tests some were already included into System-Identification-Tests)
- split packages to have better structure
-- EventRecorder
-- EventRecorder-Inspector
-- EventRecorder-Fuel
- EventRecorder-Server 
- EventRecorder-Help
