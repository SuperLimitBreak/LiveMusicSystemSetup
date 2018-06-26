FROM nginx:mainline-alpine

# all of the dynamicly mounted `volumes` in docker-compose.yml need to be COPYed

COPY ./nginx.conf /tmp/nginx.conf
COPY /root ${PATH_CONTAINER_ROOT}

# Code - Must be build already by HOST
COPY ${PATH_HOST_webMidiTools} ${PATH_CONTAINER_webMidiTools}
COPY ${PATH_HOST_trigger} ${PATH_CONTAINER_trigger}
COPY ${PATH_HOST_display} ${PATH_CONTAINER_display}
COPY ${PATH_HOST_stageViewer} ${PATH_CONTAINER_stageViewer}
COPY ${PATH_HOST_stageOrchestration} ${PATH_CONTAINER_stageOrchestration}

# Data
COPY ${PATH_HOST_displayconfig} ${PATH_CONTAINER_displayconfig}
# Data - should be mounted dynamically
#COPY ${PATH_HOST_eventmap} ${PATH_CONTAINER_eventmap}
#COPY media

# Launch
CMD /bin/sh -c "DOLLAR='$$' envsubst < /tmp/nginx.conf > /etc/nginx/nginx.conf && nginx -g 'daemon off;'"
