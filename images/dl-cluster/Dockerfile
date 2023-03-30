# Base image
ARG DL_BASE_IMAGE
FROM ${DL_BASE_IMAGE}
# Use root as working directory
WORKDIR /

# Create runtime directory for SSH server
RUN mkdir -p /var/run/sshd
# Update packages and install dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get full-upgrade -y --no-install-recommends && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        # Utilities
        ca-certificates curl wget git tmux nano vim iproute2 \
        # SSH
        openssh-client openssh-server \
        # Compilers and build tools
        gcc g++ make cmake automake autoconf autotools-dev pkg-config build-essential
# Remove SSH keys
RUN rm /etc/ssh/ssh_host_ecdsa_key \
	/etc/ssh/ssh_host_ed25519_key \
	/etc/ssh/ssh_host_rsa_key
# Remove home directory
RUN rm -r /root

# Copy command wrappers
COPY det-python /usr/local/bin
COPY jupyter /usr/local/bin
# Copy pre-start hook script
COPY pre-start-hook.bash /tmp

# Run pre-start hook before entrypoint script
ENV BASH_ENV="/tmp/pre-start-hook.bash"
