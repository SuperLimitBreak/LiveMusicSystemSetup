# Pre-requestits
# Context should contain hard folders for
#   libs
#   displayTrigger
#   stageViewer
#   webMidiTools

# Reference
# https://medium.com/@tonistiigi/advanced-multi-stage-build-patterns-6f741b852fae

FROM node:alpine as base
RUN apk add --no-cache git python3 make
# https://github.com/moby/moby/issues/37345#issuecomment-400250849
ARG PATH_BUILD_TRIGGER=build/displayTrigger/trigger
ENV PATH_BUILD_TRIGGER=${PATH_BUILD_TRIGGER}
ARG PATH_BUILD_DISPLAY=build/displayTrigger/display
ENV PATH_BUILD_DISPLAY=${PATH_BUILD_DISPLAY}
ARG PATH_BUILD_STAGEVIEWER=build/stageViewer
ENV PATH_BUILD_STAGEVIEWER=${PATH_BUILD_STAGEVIEWER}

FROM node:alpine as build
COPY multisocketServer/package.json build/multisocketServer/package.json
COPY multisocketServer/clients/     build/multisocketServer/clients/
COPY libs/package.json  build/libs/package.json
COPY libs/es6/          build/libs/es6/

FROM base as trigger
COPY --from=build build build
COPY displayTrigger/trigger/ ${PATH_BUILD_TRIGGER}
RUN make install --directory ${PATH_BUILD_TRIGGER}

FROM base as base_display
COPY displayTrigger/display/package.json ${PATH_BUILD_DISPLAY}/package.json
RUN npm install --prefix=${PATH_BUILD_DISPLAY} && npm cache clean --prefix=${PATH_BUILD_DISPLAY} --force
COPY --from=build build build
RUN npm link build/multisocketServer/ --prefix=${PATH_BUILD_DISPLAY}
RUN npm link build/libs/              --prefix=${PATH_BUILD_DISPLAY}

FROM base as base_stageViewer
COPY stageViewer/package.json ${PATH_BUILD_STAGEVIEWER}/package.json
RUN npm install --prefix=${PATH_BUILD_STAGEVIEWER} && npm cache clean --prefix=${PATH_BUILD_STAGEVIEWER} --force
COPY --from=build build build
RUN npm link build/multisocketServer/ --prefix=${PATH_BUILD_STAGEVIEWER}
RUN npm link build/libs/              --prefix=${PATH_BUILD_STAGEVIEWER}


FROM base_display as display
COPY displayTrigger/display/ ${PATH_BUILD_DISPLAY}
RUN npm run build --prefix=${PATH_BUILD_DISPLAY}

FROM base_stageViewer as stageViewer
# humm .. can we not just copy display/static/?
COPY --from=display ${PATH_BUILD_DISPLAY} ${PATH_BUILD_DISPLAY}
#RUN rm -rf ${PATH_BUILD_DISPLAY}/node_modules
#RUN npm link ${PATH_BUILD_DISPLAY} --prefix=${PATH_BUILD_STAGEVIEWER}
RUN \
    ln -s /${PATH_BUILD_DISPLAY} /${PATH_BUILD_STAGEVIEWER}/lib/node_modules/displayTrigger &&\
    ln -s ../lib/node_modules/displayTrigger /${PATH_BUILD_STAGEVIEWER}/node_modules/displayTrigger
COPY stageViewer/ ${PATH_BUILD_STAGEVIEWER}
RUN npm run build --prefix=${PATH_BUILD_STAGEVIEWER}

#---

FROM nginx:alpine
ARG PATH_BUILD_SRV=srv
RUN DIR=${PATH_BUILD_SRV}/eventmap/ && mkdir -p ${DIR} && echo "${DIR} should be mounted here" >> ${DIR}/readme.txt
RUN DIR=${PATH_BUILD_SRV}/media/ && mkdir -p ${DIR} && echo "${DIR} should be mounted here" >> ${DIR}/readme.txt

COPY displayTrigger/server/nginx.conf /etc/nginx/nginx.conf
COPY displayTrigger/server/root     ${PATH_BUILD_SRV}/root
COPY displayTrigger/displayconfig   ${PATH_BUILD_SRV}/displayconfig
COPY stageViewer/stageconfig        ${PATH_BUILD_SRV}/stageconfig
COPY webMidiTools                   ${PATH_BUILD_SRV}/webMidiTools

COPY --from=trigger     build/displayTrigger/trigger/static/  ${PATH_BUILD_SRV}/trigger/
COPY --from=display     build/displayTrigger/display/static/  ${PATH_BUILD_SRV}/display/
COPY --from=stageViewer build/stageViewer/static/             ${PATH_BUILD_SRV}/stageViewer/
