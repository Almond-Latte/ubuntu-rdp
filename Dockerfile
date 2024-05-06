# Description: Dockerfile for Ubuntu 22.04 with xrdp
FROM ubuntu:24.04

# set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo

# install basic tools
RUN apt -y update
RUN apt -y upgrade
RUN apt install -y build-essential
RUN apt install -y python3 python3-pip python3-dev python3-venv
RUN apt install -y curl git man unzip vim wget sudo
RUN apt install -y ubuntu-desktop

# arguments
ARG user_name
ARG user_password
ARG container_port

# make a user
RUN useradd -m -s /bin/bash ${user_name}
RUN gpasswd -a ${user_name} sudo
RUN echo ${user_name}:${user_password} | chpasswd

# install xrdp
RUN apt install -y xrdp
RUN adduser xrdp ssl-cert

# xrdp setting
RUN sed -i '3 a echo "\
export GNOME_SHELL_SESSION_MODE=ubuntu\\n\
export XDG_SESSION_TYPE=x11\\n\
export XDG_GURRENT_DESKTOP=ubuntu:GNOME\\n\
export XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu:/etc/xdg\\n\
" > ~/.xsessionrc' /etc/xrdp/startwm.sh

# open xrdp port
EXPOSE ${container_port}
CMD service dbus start; /usr/lib/systemd/systemd-logind & service xrdp start ; bash
# CMD service xrdp start ; bash