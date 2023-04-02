# Base image
ARG DL_BASE_IMAGE
FROM ${DL_BASE_IMAGE}

# Create runtime directory for SSH server
RUN mkdir -p /var/run/sshd
# Update packages and install dependencies
ARG DL_SYS_PACKAGES
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get full-upgrade -y --no-install-recommends && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ${DL_SYS_PACKAGES}
# Remove SSH keys
RUN rm /etc/ssh/ssh_host_*_key

# Create cluster environment from specification
ARG DL_CLUSTER_ENV_SPEC
COPY ${DL_CLUSTER_ENV_SPEC} /tmp/cluster-env-spec.yml
RUN PIP_NO_CACHE_DIR=0 conda env create -f /tmp/cluster-env-spec.yml -n dl-cluster && \
    conda clean -a -y && \
    rm -r /tmp/cluster-env-spec.yml

# Remove home directory
RUN rm -r /root
# Copy command wrappers
COPY det-jupyter-wrapper /usr/local/bin/det-jupyter-wrapper
# Copy pre-start hook script
RUN mkdir -p /usr/local/share/dl-cluster
COPY pre-start-hook.bash /usr/local/share/dl-cluster

# Jupyter directories
ENV JUPYTER_CONFIG_DIR=/run/determined/jupyter/config
ENV JUPYTER_DATA_DIR=/run/determined/jupyter/data
ENV JUPYTER_RUNTIME_DIR=/run/determined/jupyter/runtime
# Determined settings
ENV DET_SKIP_PIP_INSTALL=1
# NCCL settings
ENV NCCL_SOCKET_NTHREADS=2
ENV NCCL_NSOCKS_PERTHREAD=6

# Run pre-start hook before entrypoint script
ENV BASH_ENV=/usr/local/share/dl-cluster/pre-start-hook.bash
