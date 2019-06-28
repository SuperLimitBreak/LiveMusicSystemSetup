superLimitBreakSetup
====================

A repo to build and run the [superLimtBreak.uk](http://superlimitbreak.uk) tech stack.

Used for:
* `local` development/simulation environment
* `production` display server

* [github.com/superLimitBreak](https://github.com/superLimitBreak)
* [hub.docker.com/superlimitbreak](https://hub.docker.com/u/superlimitbreak/dashboard/)


OSX and Linux
-------------

### Run Local

```bash
    # TODO: PATH_HOST_media_example is not complete
    export PATH_HOST_media="$(pwd)/PATH_HOST_media_example"
    docker-compose up
    python3 -m webbrowser -t "http://localhost"
```

### Run Production

```bash
    docker-compose --file docker-compose.production.yml up
```

### Build

```bash
    make build
```

`docker-compose build` cannot be used (yet) because some of the repos `Makefile`s copy some files about. (I think it's only one repo now. I hope we can remove reliance on make at somepoint. This will make building windows compatible too)


Windows
-------

### Run

```cmd
     cmd /V /C "set PATH_HOST_media=C:\Users\username\media\&& docker-compose up"
```


`PATH_HOST_media` Folder Structure
----------------------------------

* `displayTriggerEventMap`
    * `my_eventmap.json` (example)
* `stageOrchestrationSequences`
    * `light_sequence.py` (example)
* `test_image.png` (example)
* `test_video.mp4` (example)
