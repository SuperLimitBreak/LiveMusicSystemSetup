FROM superlimitbreak/displaytrigger:latest

RUN \
    sed -i '/subscriptionserver_bridge/d' /etc/nginx/nginx.conf && \
    sed -i '/mediainfoservice/d'          /etc/nginx/nginx.conf && \
    sed -i '/stageorchestration/d'        /etc/nginx/nginx.conf && \
true
