LiveMusicSystemSetup
====================

Documentation to setup live music central projection system.

A collection of scripts to setup the SuperLimtBreak tech stack for a live performance.

This sets up the main projection machine to boot with the following services:

* displayTrigger
    * server: A central core bus system to route messgages via TCP or Websockets to the correct destination
    * python client: A system to send triggers
    * projector: html5 client to respond to triggers
* lightingAutomation
    * Programatically control beatmatched lighting for songs (triggered by a displayTrigger client)
    * Provide real time control of lights via displayTrigger bus
* voteBattle:
    * Interacive audience participation. Activated via the displayTrigger system
* Chrome
    * The html5 displayTrigger client is developed with the featureset of Chrome.
    * Chrome should be started full screen at system startup and load the html5 client

Setup should be (idealy) completly automated.


Running Services Manually
-------------------------

    cd displayTrigger/server; make run
    cd lightingAutomation ; make run
    cd voteBattle/server; make run
    chrome --noerrdialogs --ignore-certificate-errors --kiosk --disable-plugins --disable-extensions --no-first-run --disable-overlay-scrollbar 'http://localhost:6543/static/projector/projector.html?deviceid=main'


WIP Notes
---------

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