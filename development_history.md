Development History
===================

These tools evolved from a few simple requirements for a small hobby band project.
The tools have continually evolved into a fairly complex tech stack.
This document chronicles the changes and thought process's that have lead to current system.


Stage 0 - Initial problem - July 2014
-------------------------------------

### Problem
* An live music performance with interactive video game/music
* Trigger a video in sync with our live music (Holographic singer)

### Solution
* Spacebar at the same time
    * Cuebase
    * vlc
* [VoteBattle](https://github.com/superLimitBreak/voteBattle/tree/38f058fbb3f221429e9e6967b79543067747d6ce)
* [Pentatonic Hero](https://github.com/superLimitBreak/pentatonicHero/tree/bd6a873eaaf00717be0ddb58a12eb3cd687c866d)

### Performance
* Ayacon July 2013
* BarCamp Canterbury June 2014


Stage 1 - October 2014 to September 2015
----------------------------------------

### Problem
* Don't trigger things by human interaction. Trigger them automatically.
* Could we trigger/drive stage lights in time to our music without a lighting engineer?

If we could setup a virtual midi port that then `trigger`'s a message to be sent over a network to `display` a video on another machine that is listening.

### Solution
* [displayTrigger](https://github.com/superLimitBreak/displayTrigger/tree/01028f2c435d3f30d7884c1ee1651c9ca4c790d7)
    * PyGame MIDI `trigger` listened to a midi port and sendt a [json packet](https://github.com/superLimitBreak/displayTrigger/blob/7d4d2ffc3f74f2c16dc96fc0d0ec9da9deb00e87/client/event_map.json#L13)
        * Test [javascript webapp trigger](https://github.com/superLimitBreak/displayTrigger/blob/7d4d2ffc3f74f2c16dc96fc0d0ec9da9deb00e87/server/displaytrigger/static/control/control.html#L23) used for manual control
    * HTML5 `display` was a [javascript webapp](https://github.com/superLimitBreak/displayTrigger/blob/7d4d2ffc3f74f2c16dc96fc0d0ec9da9deb00e87/server/displaytrigger/static/projector/projector.js#L54) running in Chrome
* [lightingAutomation](https://github.com/superLimitBreak/stageOrchestration/releases/tag/v0.1) v0.1
    * Send UDP Artnet3 DMX packets
    * Lights described in `yaml`
        * [sequences](https://github.com/superLimitBreak/stageOrchestration/blob/v0.1/data/sequences/miku_2.yaml)
        * [scenes](https://github.com/superLimitBreak/stageOrchestration/blob/v0.1/data/scenes/miku/miku_bc_fill_coutin.yaml)
    * Lights visulised by PyGame abstract representation that rendered DMX packets
* [pentatonicHero](https://twitter.com/calaldees/status/601659707762319360) visuals

### Use
* Gulbenkian September 2015
    * We could trigger videos, images, sliding text animations, iframes (for other interactive content)
    * Basic DMX lights


Stage 1.5 - October 2015 to July 2016
-------------------------------------

### Problem
* PyGame MIDI `trigger` was a pain to constantly deploy to the music (Cuebase) machine (as it had no internet connection)
* We wanted multiple `display` support. Could we drive a rear screen? side screens? subtitle screen (for vocal prompts)
* If connections dropped we had to have access to computers/terminals to fix it

### Solution
* Deprecate PyGame MIDI `trigger` -> Javascript web `trigger` through Chrome MIDI
* Self-Healing network connections
* Network bus routing to route to multiple listeners/displays
* Floor prompt subtitle `display`

### Use
* Minami March 2016
* [Amecon July 2016](https://youtu.be/UqLNA3NVLhE?t=40)
    * Ultra short throw projector mounted on lighting rig


Stage 2 - July 2016 to November 2019
------------------------------------

### Problems
* Lighting limited
    * Could only tween entire lighting rig state to another state
    * Lots of calculations every frame (too complex to test/debug properly)
* Visualizing what was on the `display` and what `lightingAutomation` were doing was an exercise in abstract thinking
* Needed each `display` to have a separate Chome instance.
    *Could we have multiple displays in a single instance of a browser?
* Cubase music machine had lots of MIDI triggers that took a long time to setup and some tracks had 10 + triggers. Constant manual maintenance that was not committable to repo

### Solution
* `lightingAutomation` renamed to [stageOrchestration](https://github.com/superLimitBreak/stageOrchestration)
    * Has an eventline (sub triggers timed with lights)
    * Lighting is scripted in `python` and compiled down to binary frames on disk
        * Live reload/render on change
    * Separate timer/renderer process takes binary frames and sends over network
        * Testable segmented architecture
    * Powerful/composable programmatic expression of lights
        * Inspired by other animation frameworks
            * [GreenSock](https://greensock.com/examples-showcases)
        * Overload mathmatical operators
            * `+`
            * `&`
            * `*`
            * `/` (`split` in progress)
* [displayTrigger](https://github.com/superLimitBreak/displayTrigger)
    * rewritten in `es6`, `webpack`
    * Multiple displays in one browser instance
        * `display` be bound to arbitrary `div`
* [stageViewer](https://github.com/superLimitBreak/stageViewer)
    * 3D Stage representation with screens and lights [three.js](https://threejs.org/) CSS3D
    * Uses `displayTrigger` library to bind screens to 3D scene
    * `react` timeline with representation of lights
* [systemSetup](https://github.com/superLimitBreak/systemSetup)
    * Segmented architecture
        * Published [DockerHub](https://cloud.docker.com/u/superlimitbreak/repository/list) containers
    * Sub component repos
        * [multisocketServer](https://github.com/superLimitBreak/multisocketServer)
        * [mediatimelineRenderer](https://github.com/superLimitBreak/mediaTimelineRenderer)
        * [mediaInfoService](https://github.com/superLimitBreak/mediaInfoService)
        * [calaldees/libs](https://github.com/calaldees/libs)

### Use
* `displayTrigger` used at [Hibannacon 2018](https://twitter.com/SuperLimitBreak/status/1059123513578135552)
* Tech preview demoed in [BarCamp 2019](http://barcampcanterbury.com) June
* Planned [Hibanacon 2019](https://www.hibanacon.co.uk/) November
