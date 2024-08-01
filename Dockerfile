FROM debian:latest

RUN apt-get update && apt-get install -y \
    live-build make qemu-utils whois grub-common

RUN mkdir -p /workspace

CMD ["/bin/bash"]
