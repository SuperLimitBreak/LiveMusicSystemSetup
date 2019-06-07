Development History
===================

These tools evolved from a few simple requirements for a small hobby band project.
The tools have continually evolved into a fairly complex tech stack.
This document chronicles the changes and thought process's that have lead to current system.


Stage 0 - Initial problem - 2013
--------------------------------

### Problem
* A live music performance with interactive video game/music
* Requirement to trigger a video in sync with our live music (A holographic singer)

### Solution
* Spacebar at the same time on two computers
    * Cuebase
    * vlc

### Performance
* Ayacon July 2013
* BarCamp Canterbury June 2014
    * [VoteBattle](https://github.com/superLimitBreak/voteBattle/tree/38f058fbb3f221429e9e6967b79543067747d6ce)
    * [Pentatonic Hero](https://github.com/superLimitBreak/pentatonicHero/tree/bd6a873eaaf00717be0ddb58a12eb3cd687c866d)


Stage 1 - October 2014 to September 2015
----------------------------------------

### Problem
* Don't trigger things by human interaction. Trigger them automatically.
* Could we trigger/drive stage lights in time to our music without a lighting engineer?

If we could setup a virtual midi port that then `trigger`'s a message to be sent over a network to `display` a video on another machine that is listening.

### Solution
* [displayTrigger](https://github.com/superLimitBreak/displayTrigger/tree/01028f2c435d3f30d7884c1ee1651c9ca4c790d7)
    * Commandline pygame MIDI `trigger` listened to a midi port and send a [json message](https://github.com/superLimitBreak/displayTrigger/blob/7d4d2ffc3f74f2c16dc96fc0d0ec9da9deb00e87/client/event_map.json#L13)
        * Test javascript [web trigger](https://github.com/superLimitBreak/displayTrigger/blob/7d4d2ffc3f74f2c16dc96fc0d0ec9da9deb00e87/server/displaytrigger/static/control/control.html#L23) used for manual control
    * `display` was a HTML5/javascript [webapp](https://github.com/superLimitBreak/displayTrigger/blob/7d4d2ffc3f74f2c16dc96fc0d0ec9da9deb00e87/server/displaytrigger/static/projector/projector.js#L54)
* [lightingAutomation](https://github.com/superLimitBreak/stageOrchestration/releases/tag/v0.1) v0.1
    * Send UDP Artnet3 DMX packets
    * Lights described in `yaml`
        * [sequences](https://github.com/superLimitBreak/stageOrchestration/blob/v0.1/data/sequences/miku_2.yaml)
        * [scenes](https://github.com/superLimitBreak/stageOrchestration/blob/v0.1/data/scenes/miku/miku_bc_fill_coutin.yaml)
    * Lights visualized by pygame [DMXSimulator](https://github.com/superLimitBreak/stageOrchestration/blob/f98acd044f0fc037b36ebaaf95db5ed911e8c074/DMXSimulator.py) abstract representation that rendered DMX packets
        * `display` played an audio file with seek bar to send absolute time to `lightingAutomation` across websocket bridge
    * Real-time control of lights with physical MIDI-Mixer controller with HTML5/js app
* [pentatonicHero](https://twitter.com/calaldees/status/601659707762319360) HTML5/js visuals and real-time control of lights

### Use
* Gulbenkian September 2015
    * We could trigger videos, images, sliding text animations, iframes (for other interactive content)
    * Basic DMX lights
        * `pentatonicHero` realtime lights


Stage 1.5 - October 2015 to July 2016
-------------------------------------

### Problem
* pygame MIDI `trigger` was a pain to constantly deploy to the music (Cuebase) machine (as it had no internet connection)
* Single message bus for all `displays`. All messages went to every connected device.
* If connections dropped we had to have access to computers/terminals to fix it

### Solution
* Deprecate pygame MIDI `trigger` -> javascript web `trigger` through Chrome MIDI
* `multisocketClient` self-healing network connections for websocket and tcp
* `multisocketServer` - SubscriptionServer
    * Network bus routing to route messages to specific/multiple listeners/displays
* Floor prompt subtitle `display`
    * RaspberyPi 2 with WiFi + Floor Screen

### Use
* Minami March 2016
* [Amecon July 2016](https://youtu.be/UqLNA3NVLhE?t=40)
    * Ultra short throw projector mounted on lighting rig


Stage 2 - July 2016 to November 2019
------------------------------------

### Problems
* `lightingAutomation` scripting extremely limited
    * Could only tween entire lighting rig state to another state
    * Overly complex nested anonymous function complexity every frame (too complex to test/debug properly)
* `lightingAutomation`:`DMXSimulator` visualization was insufficient
    * Visualizing what was on the `display` and what pygame  lights were doing was an exercise in abstract thinking
    * Clunky, fragile and unusable by anyone other than a linux wizard
* Needed each `display` to have a separate browser instance.
    * Could we have multiple displays in a single instance of a browser?
* Cubase/music machine had lots of MIDI triggers that took a long time to setup.
    * Some tracks had 10 + triggers. Total we had 60+ triggers
    * Constant Cuebase manual maintenance was not committable to repo

### Solution
* [stageOrchestration](https://github.com/superLimitBreak/stageOrchestration) - rename of `lightingAutomation`
    * Lighting is scripted in `python` and compiled down to binary frames on disk
        * Live reload/render on change
    * Media triggers (eventline)
        * media trigger in same script as lighting
    * Separate realtime-renderer process takes binary frames off disk + send over network
        * Testable segmented architecture
    * [ObjectRelationalMapper](https://github.com/superLimitBreak/stageOrchestration/tree/master/stageOrchestration/lighting/model/devices) for lights
    * Generic `python` [timeline.py](https://github.com/calaldees/libs/blob/master/python3/calaldees/animation/timeline.py)  - Powerful programmatic animation framework
        * Inspired by other animation frameworks
            * [GreenSock](https://greensock.com/examples-showcases)
        * Overload mathematical operators
            * `+`
            * `&`
            * `*`
            * `/` (`split` in progress)
* [displayTrigger](https://github.com/superLimitBreak/displayTrigger)
    * rewritten in `es6`, `webpack`
    * Multiple displays in one browser instance
        * `display` be bound to arbitrary `div`s
* [stageViewer](https://github.com/superLimitBreak/stageViewer) - (two `es6` components)
    * 3D Stage representation
        * [three.js](https://threejs.org/) css3d component
        * 3D stage, lights, screens
            * Uses `display` library bound to screens/divs in 3D scene
    * timeline
        * `react` component
        * Visual representation of lights
* [systemSetup](https://github.com/superLimitBreak/systemSetup)
    * Containerized/Segmented architecture
        * Published [DockerHub](https://cloud.docker.com/u/superlimitbreak/repository/list) containers
    * Sub component repos
        * [multisocketServer](https://github.com/superLimitBreak/multisocketServer) subscription/routing server + self healing clients for `python`/`js`
        * [mediatimelineRenderer](https://github.com/superLimitBreak/mediaTimelineRenderer) WIP video thumbnails for timeline
        * [mediaInfoService](https://github.com/superLimitBreak/mediaInfoService) REST API for metadata of media
        * [calaldees/libs](https://github.com/calaldees/libs)

### Use
* `displayTrigger` used at [Hibannacon 2018](https://twitter.com/SuperLimitBreak/status/1059123513578135552)
* Tech preview demoed in [BarCamp 2019](http://barcampcanterbury.com) June
* Planned [Hibanacon 2019](https://www.hibanacon.co.uk/) November
