FROM ubuntu:22.04

# Install systemd and required tools
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    systemd \
    systemd-sysv \
    bash \
    util-linux \
    coreutils \
    findutils \
    sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Remove systemd units that prevent container startup
RUN cd /lib/systemd/system/sysinit.target.wants/ && \
    ls | grep -v systemd-tmpfiles-setup | xargs rm -f && \
    rm -f /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/basic.target.wants/* \
    /lib/systemd/system/anaconda.target.wants/* \
    /lib/systemd/system/plymouth* \
    /lib/systemd/system/systemd-update-utmp*

# Create working directory
WORKDIR /task28_tests

# Copy test environment
COPY . /task28_tests/

# Make scripts executable
RUN chmod +x /task28_tests/*.sh \
    /task28_tests/R1/*.sh \
    /task28_tests/R2/*.sh 2>/dev/null || true

# Create outputs directories
RUN mkdir -p /task28_tests/outputs/R1 /task28_tests/outputs/R2

# Set up systemd environment
ENV container=docker
STOPSIGNAL SIGRTMIN+3

# Expose systemd
VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]

# Run systemd as PID 1
CMD ["/lib/systemd/systemd"]
