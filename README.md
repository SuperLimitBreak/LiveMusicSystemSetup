systemSetup
===========

A repo to build and run the [superLimtBreak.uk](http://superlimitbreak.uk) tech stack.

Used for:
* `local` development/simulation environment
* `production` display server

* [github.com/superLimitBreak](https://github.com/superLimitBreak)
* [hub.docker.com/superlimitbreak](https://hub.docker.com/u/superlimitbreak/dashboard/)


OSX and Linux
-------------

```bash
    make build
```


Windows
-------

```cmd
     cmd /V /C "set PATH_HOST_media=C:\Users\username\syncthing\superLimitBreak\assets\visuals\&& docker-compose up"
```


`PATH_HOST_media` Folder Structure
----------------------------------

* `displayTriggerEventMap`
    * `my_eventmap.json` (example)
* `stageOrchestrationSequences`
    * `light_sequence.py` (example)
* `test_image.png` (example)
* `test_video.mp4` (example)
