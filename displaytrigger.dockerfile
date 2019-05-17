# Pre-requestits
# Context should contain hard folders for
#   libs
#   displayTrigger
#   stageViewer
#   webMidiTools

# Reference
# https://medium.com/@tonistiigi/advanced-multi-stage-build-patterns-6f741b852fae

FROM node:alpine as node
# https://github.com/moby/moby/issues/37345#issuecomment-400250849
ARG PATH_BUILD_DISPLAY=display
ARG PATH_BUILD_TRIGGER=trigger
ARG PATH_BUILD_STAGEVIEWER=stageViewer
ARG PATH_BUILD_SRV=srv
RUN apk add --no-cache git python3 make


FROM node as display
#ENV NPM_CONFIG_PREFIX=build/display/
COPY displayTrigger/display/package.json build/displayTrigger/display/package.json
RUN npm install --prefix=build/displayTrigger/display/ && npm cache clean --prefix=build/displayTrigger/display/ --force
COPY libs/ build/libs/
#RUN npm link build/libs/
COPY displayTrigger/display/ build/displayTrigger/display/
RUN npm run build --prefix=build/displayTrigger/display/


FROM node as trigger
COPY libs/es6 libs/es6
COPY displayTrigger/trigger/ build/trigger/
RUN make install --directory build/trigger/


FROM display as stageViewer
COPY stageViewer/package.json build/stageViewer/package.json
RUN npm install --prefix=build/stageViewer/ && npm cache clean --prefix=build/stageViewer/ --force
COPY stageViewer/ build/stageViewer/
RUN npm link build/libs/ --prefix=build/stageViewer/
RUN npm link build/displayTrigger/display/ --prefix=build/stageViewer/
RUN npm run build --prefix=build/stageViewer/


FROM nginx:alpine
RUN DIR=${PATH_BUILD_SRV}/eventmap/ && mkdir -p ${DIR} && echo "${DIR} should be mounted here" >> ${DIR}/readme.txt
RUN DIR=${PATH_BUILD_SRV}/media/ && mkdir -p ${DIR} && echo "${DIR} should be mounted here" >> ${DIR}/readme.txt

COPY displayTrigger/server/nginx.conf /etc/nginx/nginx.conf
COPY displayTrigger/server/root     ${PATH_BUILD_SRV}/root
COPY displayTrigger/displayconfig   ${PATH_BUILD_SRV}/displayconfig
COPY stageViewer/stageconfig        ${PATH_BUILD_SRV}/stageconfig
COPY webMidiTools                   ${PATH_BUILD_SRV}/webMidiTools

COPY --from=trigger     build/trigger/static/                 ${PATH_BUILD_SRV}/trigger/
COPY --from=display     build/displayTrigger/display/static/  ${PATH_BUILD_SRV}/display/
COPY --from=stageViewer build/stageViewer/static/             ${PATH_BUILD_SRV}/stageViewer/
