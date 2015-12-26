# LiveMusicSystemSetup

Documentation to setup live music central projection system.

A repo to collect scripts to setup the live music battlefortress of tech.
Setup should be (idealy) completly automated.


## TODO

* Graphics Setup
  * Drivers for graphics cards
  * One large display
* Install WAP
  * DNS
    * known computers could be given known names 'server', 'projector', 'cuebase', 'synth'
    * All unknown names map to server's ip
  * DCHP
    * Known MAC address's -> ip's
    * Differnt subnet for wireless devices?
  * nginx
    * Rewrite host
    * Serve event assets
* Install DisplayTrigger
* Install VoteServer
* Install LightingAutomation
* Startup
  * Fullscreen Chrome over all displays
* Import assets from known source?