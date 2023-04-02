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

# Initialize user data directory
if [ ! -e "${DL_USER_DATA_DIR}" ]; then
    # Copy user skeleton directory
    cp -r /etc/skel "${DL_USER_DATA_DIR}"
    # Use user data directory as home directory
    ln -s "${DL_USER_DATA_DIR}" "${HOME}"
    # Create link to shared data directory
    ln -s "${DL_SHARED_DIR}/data/shared" "${HOME}/shared"

    # Persistently initialize Conda for interactive shells
    conda init
    # Display short environment prompt
    conda config --set env_prompt '({name}) '
else
    ln -s "${DL_USER_DATA_DIR}" "${HOME}"
fi
# Create user environments directory
mkdir -p "${DL_USER_ENVS_DIR}"

# Switch to home directory except for experiments
if [ "${DET_TASK_TYPE}" != "TRIAL" ]; then
    cd "${HOME}"
fi

# Activate cluster environment
source /opt/conda/bin/activate dl-cluster
