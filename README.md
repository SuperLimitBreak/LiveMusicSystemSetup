systemSetup
===========

A collection of scripts to setup the [SuperLimtBreak.uk](http://superlimitbreak.uk) tech stack for a live performance.

This repo assists with setup of the main projection machine to boot with the following services:

* [displayTrigger](https://github.com/SuperLimitBreak/displayTrigger)
    * `server`: A central core bus system to route messgages via TCP or Websockets to the correct destination
    * `triggerWeb` A system to send triggers
    * `display`: html5 client to respond to triggers
* [lightingAutomation](https://github.com/SuperLimitBreak/lightingAutomation)
    * Programatically control beatmatched lighting for songs (triggered by a displayTrigger client)
    * Provide real time control of lights via displayTrigger bus
* [voteBattle](https://github.com/SuperLimitBreak/voteBattle):
    * Interacive audience participation. Activated via the displayTrigger system
* [pentatonicHero](https://github.com/SuperLimitBreak/pentatonicHero):
    * Install plugins for realtime lighting and html5 visulisation
* Chrome
    * The html5 displayTrigger client is developed with the featureset of Chrome.
    * Chrome should be started full screen at system startup and load the html5 client

Setup should be (idealy) completly automated.

Note: This repo does *NOT* install the required event asset media that is paired with the example `displayTrigger/eventMap/xxx.json` file.


Example demo local use
----------------------

    make install
    # setup displayTrigger/server/production.inidiff to point at absolute eventassets folder
    make start
    python -m webbrowser -t "http://localhost:6543/display/display.html?deviceid=main"
    python -m webbrowser -t "http://localhost:6543/trigger/trigger.html"
    python -m webbrowser -t "http://localhost:6543/ext/lightingRemoteControl.html"
    cd lightingAutomation && make pygame && make run_simulator
    # Click on triggers
    make stop


hardwareSetup Notes
-------------------

Some elements of the hardware setup are currently in a separate repo networkSetup.
This loosely covers

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
  * Fullscreen Chrome over all displays


Systemd notes
-------------

Requirements: python3-dbus, dbus-user-session

Install the systemd units via `make systemd`.
Use the .Xinitrc to setup your Xsession.

