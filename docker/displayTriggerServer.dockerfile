FROM python:3.7-rc-stretch
RUN pip3 install --upgrade pip setuptools virtualenv
COPY displayTriggerServer.pip requirements.pip
RUN pip3 install -r requirements.pip
