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

# Cluster shared directory
ARG DL_SHARED_DIR
# Link pip shared cache
RUN mkdir -p /root/.cache && \
    ln -s "${DL_SHARED_DIR}/cache/pip" /root/.cache/pip
# Link Jupyter 
RUN ln -s "${DL_SHARED_DIR}/conda/envs/determined/bin/jupyter" /usr/local/bin/jupyter
# Link shared data directory
RUN ln -s "${DL_SHARED_DIR}/data" /data

# Add Conda to path
ENV PATH="${DL_SHARED_DIR}/conda/bin:${PATH}"
# Conda container environments path
ENV CONDA_ENVS_PATH="${DL_SHARED_DIR}/envs"

# Jupyter directories
ENV JUPYTER_CONFIG_DIR=/run/determined/jupyter/config
ENV JUPYTER_DATA_DIR=/run/determined/jupyter/data
ENV JUPYTER_RUNTIME_DIR=/run/determined/jupyter/runtime
# Determined entrypoint settings
ENV DET_SKIP_PIP_INSTALL=1
ENV DET_PYTHON_EXECUTABLE="${DL_SHARED_DIR}/conda/envs/determined/bin/python"
