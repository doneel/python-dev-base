# This dockerfile should be built from the main project directory to pick up the requirements file(s) 
#   The file (and additional resources like the tmuxinator config) can sit in a subdirectory (like 
#   development-environment) to not clog the project base directory, docker just requires that we build from 
#   the base directory if we want access to the requirements file(s) or other project resources
ARG BASE_TAG=latest
FROM danieloneel/python-dev-base:latest
# author of file
LABEL maintainer=”danieloneel@gmail.com”


########## PYTHON DEPENDENCIES ########## 
# For projects with a single requirements.txt, replace this with a simple
# COPY requirements.txt /app/requirements.txt
ADD requirements /app/requirements/
WORKDIR /app

# Install all the project requirements into the runtime environment.
RUN pip install --user -r /app/requirements/default.txt
RUN pip install --user -r /app/requirements/test.txt


########## TMUXINATOR ########## 
# Configure tmuxinator to set up the default workflow. This is optional.
# Tmuxinator is useful cof configuring a development window, starting and monitoring an application, etc.
RUN sudo apt-get install -y tmuxinator
COPY ./dev-env/webapp.yml /tmp/webapp.yml
RUN mkdir ~/.config/tmuxinator && cat /tmp/webapp.yml > ~/.config/tmuxinator/webapp.yml && sudo rm /tmp/webapp.yml
ENV TERM xterm-256color

ENTRYPOINT ["tmuxinator", "start", "webapp"]
