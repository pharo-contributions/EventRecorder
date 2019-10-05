# EventRecorder
I'm a little framework to collect data from Pharo and publish it on server.

This framework has been developed by the GT team (probably T. Girba, A. Chis and others). 
Since this is a cool framework to support user experiences and collect that for tool builders, I decided to invest in it and repackage it to avoid to have everything in a single package.

The vision is to have several packages. 

- EventRecorder
- EventRecorderInspector
- EventRecorderFuel
- EventRecorderSTON
- EventRecorderServer (should be migrated from SmalltalkHub -- See below) 
- EventRecorderHelp

and eventually adding tests


http://smalltalkhub.com/#!/~Moose/GToolkit repository, 
package GT-EventRecorder-Server, or load it using the following configuration:
	
	Gofer it
		smalltalkhubUser: #Moose project: #GToolkit;
		configurationOf: #GTEventRecorderServer;
		loadStable.
    
    
For now the repository contains the package as it was in Pharo80 from Pharo 8.0.0
Build information: Pharo-8.0.0+build.832.sha.5bf8ad62745116525adb12aaf7d6b31418304788 (64 Bit)
