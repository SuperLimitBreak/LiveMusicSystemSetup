FROM python:3
RUN pip install --upgrade pip
COPY requirements.pip /tmp/
RUN pip install -r /tmp/requirements.pip
