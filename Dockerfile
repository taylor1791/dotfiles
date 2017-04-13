FROM ubuntu:xenial
WORKDIR /root
ADD . /root/.dotfiles
ENV HOME=/root TERM=vt220

