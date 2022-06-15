# Ensure hook is only called once
unset BASH_ENV

# Save current directory as shared directory
export DL_SHARED_DIR="${PWD}"
# Set cluster environment name
export DL_CLUSTER_ENV="cluster"

# User data and environment directories
DL_USER_DATA_DIR="${DL_SHARED_DIR}/data/users/${DET_USER}"
DL_USER_ENVS_DIR="${DL_SHARED_DIR}/envs/users/${DET_USER}"

# Cache directories
export CONDA_PKGS_DIRS="${DL_SHARED_DIR}/cache/conda"
export PIP_CACHE_DIR="${DL_SHARED_DIR}/cache/pip"
# Conda environments directories
export CONDA_ENVS_PATH="${DL_USER_ENVS_DIR}:${DL_SHARED_DIR}/envs/templates"

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
mkdir -p "${DL_USER_DATA_DIR}" "${DL_USER_ENVS_DIR}"
# Change working directory
cd "${DL_USER_DATA_DIR}"
# Create link to shared data directory
if [ ! -e "./shared" ]; then
    ln -s ../../shared ./
fi

# Initialize Conda for current shell
eval "$(${DL_SHARED_DIR}/conda/bin/conda shell.bash hook)"
# Initialize Conda for interactive shells
conda init
