# Base image
ARG DL_BASE_IMAGE
FROM ${DL_BASE_IMAGE}

# Create runtime directory for SSH server
RUN mkdir -p /var/run/sshd
# Install dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    # Utilities
    busybox ca-certificates curl git tmux vim wget \
    # SSH
    openssh-client openssh-server \
    # Compilers and build tools
    gcc g++ make cmake automake autoconf autotools-dev
# Remove SSH keys
RUN rm /etc/ssh/ssh_host_ecdsa_key \
	/etc/ssh/ssh_host_ed25519_key \
	/etc/ssh/ssh_host_rsa_key

# Copy command wrappers
COPY det-python /usr/local/bin
COPY det-jupyter /usr/local/bin
# Copy pre-start hook to image
COPY pre-start-hook.sh /root

# Run pre-start hook before entrypoint script
ENV BASH_ENV="/root/pre-start-hook.sh"
