FROM ubuntu:xenial
WORKDIR /root
ADD . /root/.dotfiles
ENV TERM=xterm
