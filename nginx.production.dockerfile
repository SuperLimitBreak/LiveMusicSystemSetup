FROM nginx:mainline-alpine

# The 'build context' for this dockerfile should have all static files for serving built in a particular folder structure for serving - There should be support scripts to do this
# docker build -t displaytrigger --file .\nginx.production.dockerfile %PATH_BUILD%
# docker run --rm -it -p 80:80 displaytrigger

COPY . /srv/

# Data - should be mounted dynamically
# ${PATH_HOST_eventmap} -> ${PATH_CONTAINER_eventmap}
# ${PATH_HOST_media} -> ${PATH_CONTAINER_media}
RUN DIR=/srv/eventmap/ && mkdir -p ${DIR} && echo "${DIR} should be mounted here" >> ${DIR}/readme.txt
RUN DIR=/srv/media/ && mkdir -p ${DIR} && echo "${DIR} should be mounted here" >> ${DIR}/readme.txt

COPY ./nginx.conf /etc/nginx/nginx.conf
#RUN /bin/sh -c "DOLLAR='$$' envsubst < /srv/nginx.conf > /etc/nginx/nginx.conf"

CMD nginx -g 'daemon off;'
