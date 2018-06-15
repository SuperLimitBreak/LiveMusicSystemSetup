FROM python:3
#FROM python:3.7-rc-stretch
RUN pip3 install --upgrade pip setuptools virtualenv
#RUN apt-get update && apt-get install -y \
#    python3-dev \
# && apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt
COPY stageOrchestration.pip requirements.pip
RUN pip3 install -r requirements.pip
