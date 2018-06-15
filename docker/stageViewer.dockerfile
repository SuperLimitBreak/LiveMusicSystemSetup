FROM node:9-alpine

# NOTE: /stageViewer/node_modules must be mounted
COPY stageViewer.package.json /stageViewer/package.json
WORKDIR /stageViewer
RUN npm install
