# Ensure hook is only called once
unset BASH_ENV

# User data and environment directories
DL_USER_DATA_DIR="${DL_SHARED_DIR}/data/users/${DET_USER}"
DL_USER_ENVS_DIR="${DL_SHARED_DIR}/envs/users/${DET_USER}"

# Cache directories
export CONDA_PKGS_DIRS="${DL_SHARED_DIR}/cache/conda"
export PIP_CACHE_DIR="${DL_SHARED_DIR}/cache/pip"
# Conda environments directories
export CONDA_ENVS_PATH="${DL_USER_ENVS_DIR}:${DL_SHARED_DIR}/envs/shared"

# Link user data directory
if [ -e "${DL_USER_DATA_DIR}" ]; then
    ln -s "${DL_USER_DATA_DIR}" "${HOME}"
# Initialize user data directory
else
    # Copy user skeleton directory
    cp -r /etc/skel "${DL_USER_DATA_DIR}"
    # Link user data directory
    ln -s "${DL_USER_DATA_DIR}" "${HOME}"
    # Create link to shared data directory
    ln -s "${DL_SHARED_DIR}/data/shared" "${HOME}/shared"

    # Persistently initialize Conda for interactive shells
    conda init
fi
# Create user environments directory
mkdir -p "${DL_USER_ENVS_DIR}"

# Notebook task
if [ "${DET_TASK_TYPE}" = "NOTEBOOK" ]; then
    alias jupyter="det-jupyter-wrapper"
fi

# Switch to given working directory
# (Unlike `workdir` option, this allows switching to home and its
# sub-directories, as switching happens after linking)
if [ -n "${DL_WORKDIR}" ]; then
    cd "${DL_WORKDIR}"
fi
# Activate Conda environment
# (Cluster environment by default)
. /opt/conda/bin/activate "${DL_CONDA_ENV:-dl-cluster}"
