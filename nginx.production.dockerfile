FROM nginx:mainline-alpine

# The 'build context' for this dockerfile should have all the superLimitBreak repos 'cloned' and 'built'

ARG PATH_HOST_server=displayTrigger/server
ARG PATH_HOST_trigger=displayTrigger/trigger/static
ARG PATH_HOST_display=displayTrigger/display/static
ARG PATH_HOST_displayconfig=displayTrigger/display/display_configs
ARG PATH_HOST_stageViewer=stageViewer/static
ARG PATH_HOST_stageOrchestration=stageOrchestration/web/static
ARG PATH_HOST_webMidiTools=webMidiTools

ENV \
    PATH_CONTAINER_server=/srv/root/ \
    PATH_CONTAINER_eventmap=/srv/eventmap/ \
    PATH_CONTAINER_displayconfig=/srv/displayconfig/ \
    PATH_CONTAINER_trigger=/srv/trigger/ \
    PATH_CONTAINER_display=/srv/display/ \
    PATH_CONTAINER_stageViewer=/srv/stageViewer/ \
    PATH_CONTAINER_stageOrchestration=/srv/stageOrchestration/ \
    PATH_CONTAINER_webMidiTools=/srv/webMidiTools/ \
    PATH_CONTAINER_media=/srv/media/

COPY ${PATH_HOST_server}/nginx.conf /tmp/nginx.conf
RUN /bin/sh -c "DOLLAR='$$' envsubst < /tmp/nginx.conf > /etc/nginx/nginx.conf"

COPY ${PATH_HOST_server}/root ${PATH_CONTAINER_server}
# Code - Must be built already by HOST
# all of the dynamicly mounted `volumes` in docker-compose.yml need to be COPYed
COPY ${PATH_HOST_webMidiTools} ${PATH_CONTAINER_webMidiTools}
COPY ${PATH_HOST_trigger} ${PATH_CONTAINER_trigger}
COPY ${PATH_HOST_display} ${PATH_CONTAINER_display}
COPY ${PATH_HOST_stageViewer} ${PATH_CONTAINER_stageViewer}
COPY ${PATH_HOST_stageOrchestration} ${PATH_CONTAINER_stageOrchestration}

# Data
COPY ${PATH_HOST_displayconfig} ${PATH_CONTAINER_displayconfig}

# Data - should be mounted dynamically
# ${PATH_HOST_eventmap} -> ${PATH_CONTAINER_eventmap}
# ${PATH_HOST_media} -> ${PATH_CONTAINER_media}
RUN echo "eventmaps should be mounted here" > ${PATH_CONTAINER_eventmap}/readme.txt
RUN echo "media should be mounted here" > ${PATH_CONTAINER_media}/readme.txt

CMD nginx -g 'daemon off;'
