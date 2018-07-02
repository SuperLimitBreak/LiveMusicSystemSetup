REM Variables ------------------------------------------------------------------
SET PATH_REPOS=..
SET PATH_BUILD=.\_build

SET PATH_HOST_server=%PATH_REPOS%\displayTrigger\server
SET PATH_HOST_trigger=%PATH_REPOS%\displayTrigger\trigger\static
SET PATH_HOST_display=%PATH_REPOS%\displayTrigger\display\static
SET PATH_HOST_displayconfig=%PATH_REPOS%\displayTrigger\displayconfig
SET PATH_HOST_stageViewer=%PATH_REPOS%\stageViewer\static
SET PATH_HOST_stageOrchestration=%PATH_REPOS%\stageOrchestration\web\static
SET PATH_HOST_webMidiTools=%PATH_REPOS%\webMidiTools

SET PATH_CONTAINER_server=%PATH_BUILD%\root
SET PATH_CONTAINER_eventmap=%PATH_BUILD%\eventmap
SET PATH_CONTAINER_displayconfig=%PATH_BUILD%\displayconfig
SET PATH_CONTAINER_trigger=%PATH_BUILD%\trigger
SET PATH_CONTAINER_display=%PATH_BUILD%\display
SET PATH_CONTAINER_stageViewer=%PATH_BUILD%\stageViewer
SET PATH_CONTAINER_stageOrchestration=%PATH_BUILD%\stageOrchestration
SET PATH_CONTAINER_webMidiTools=%PATH_BUILD%\webMidiTools
REM SET PATH_CONTAINER_media=%PATH_BUILD%\media\


REM Build ----------------------------------------------------------------------
REM CMD \C npm run build --prefix ../displayTrigger/display
REM CMD \C npm run build --prefix ../stageViewer/
REM TODO: build `trigger` with windows

REM Copy -----------------------------------------------------------------------
rd /s /q %PATH_BUILD%
md %PATH_BUILD%

COPY %PATH_HOST_server%\nginx.conf %PATH_BUILD%\
robocopy %PATH_HOST_server%\root %PATH_CONTAINER_server%
robocopy %PATH_HOST_trigger% %PATH_CONTAINER_trigger%
robocopy %PATH_HOST_display% %PATH_CONTAINER_display%
robocopy %PATH_HOST_displayconfig% %PATH_CONTAINER_displayconfig%

robocopy %PATH_HOST_stageViewer% %PATH_CONTAINER_stageViewer%
robocopy %PATH_HOST_stageOrchestration% %PATH_CONTAINER_stageOrchestration%
robocopy %PATH_HOST_webMidiTools%\webMidiMultiplexer.html %PATH_CONTAINER_webMidiTools%

docker build -t superlimitbreak/displaytrigger:latest --file .\displaytrigger.dockerfile %PATH_BUILD%
REM docker push superlimitbreak/displaytrigger:latest


goto comment
:comment

