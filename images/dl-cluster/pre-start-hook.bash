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

# Determined settings
export DET_SKIP_PIP_INSTALL=1
export DET_PYTHON_EXECUTABLE="det-python"

# Jupyter directories
export JUPYTER_CONFIG_DIR=/run/determined/jupyter/config
export JUPYTER_DATA_DIR=/run/determined/jupyter/data
export JUPYTER_RUNTIME_DIR=/run/determined/jupyter/runtime

# NCCL settings
export NCCL_SOCKET_NTHREADS=2
export NCCL_NSOCKS_PERTHREAD=6

# Initialize user directories
if [ ! -e "${DL_USER_DATA_DIR}" ]; then
    cp -r /etc/skel "${DL_USER_DATA_DIR}"
fi
mkdir -p "${DL_USER_ENVS_DIR}"
# Use user data directory as home directory
ln -s "${DL_USER_DATA_DIR}" "${HOME}"
# Create link to shared data directory
if [ ! -e "${HOME}/shared" ]; then
    ln -s "${DL_SHARED_DIR}/data/shared" "${HOME}/shared"
fi
# Switch to home directory except for experiments
if [ "${DET_TASK_TYPE}" != "TRIAL" ]; then
    cd "${HOME}"
fi

# Initialize Conda for current shell
eval "$(${DL_SHARED_DIR}/conda/bin/conda shell.bash hook)"
# Persistently initialize Conda for interactive shells
conda init
# Display short environment prompt
conda config --set env_prompt '({name}) '
