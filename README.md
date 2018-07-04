systemSetup
===========

A collection of scripts to setup the [superLimtBreak.uk](http://superlimitbreak.uk) tech stack.

Can setup
* local development/simulation enviroment
* production display server

The system uses [docker](https://www.docker.com/) prebuilt containers.
The code for all of the containers can be found at [github.com/superLimitBreak](https://github.com/superLimitBreak)

[hub.docker.com/superlimitbreak](https://hub.docker.com/u/superlimitbreak/dashboard/)

Windows
-------

     cmd /V /C "set PATH_HOST_media=C:\Users\username\syncthing\superLimitBreak\assets\visuals\&& docker-compose up"


`PATH_HOST_media` Folder Structure
----------------------------------

Required folders

* `displayTriggerEventMap`
    * `my_eventmap.json` (example)
* `stageOrchestrationSequences`
    * `light_sequence.py` (example)
* `test_image.png` (example)
* `test_video.mp4` (example)
