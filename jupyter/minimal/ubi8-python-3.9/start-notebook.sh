#!/bin/bash

# Load bash libraries
SCRIPT_DIR=/opt/app-root/bin
source ${SCRIPT_DIR}/utils/process.sh

if [ -f "${SCRIPT_DIR}/utils/setup-elyra.sh" ]; then
  source ${SCRIPT_DIR}/utils/setup-elyra.sh
fi

# Initialize notebooks arguments variable
NOTEBOOK_PROGRAM_ARGS=""

# Set default NotebookApp.port value if NOTEBOOK_PORT variable is defined
if [ -n "${JUPYTER_NOTEBOOK_PORT}" ]; then
    NOTEBOOK_PROGRAM_ARGS+="--NotebookApp.port=${JUPYTER_NOTEBOOK_PORT} "
fi

# Set default NotebookApp.base_url value if NOTEBOOK_BASE_URL variable is defined
if [ -n "${NOTEBOOK_BASE_URL}" ]; then
    NOTEBOOK_PROGRAM_ARGS+="--NotebookApp.base_url=${NOTEBOOK_BASE_URL} "
fi

# Set default NotebookApp.root_dir value if NOTEBOOK_ROOT_DIR variable is defined
if [ -n "${NOTEBOOK_ROOT_DIR}" ]; then
    NOTEBOOK_PROGRAM_ARGS+="--NotebookApp.notebook_dir=${NOTEBOOK_ROOT_DIR} "
else
    NOTEBOOK_PROGRAM_ARGS+="--NotebookApp.notebook_dir=${HOME} "
fi

# Add custom password through a token
if [ -n "${NOTEBOOK_ACCESS_TOKEN}" ]; then
    NOTEBOOK_PROGRAM_ARGS+="--NotebookApp.password=${NOTEBOOK_ACCESS_TOKEN} "
fi

# Configure the IOPub data limit
if [ -n "${IOPUB_DATA_LIMIT}" ]; then
    NOTEBOOK_PROGRAM_ARGS+="--NotebookApp.iopub_data_rate_limit=${IOPUB_DATA_LIMIT} "
fi

# Add additional arguments if NOTEBOOK_ARGS variable is defined
if [ -n "${NOTEBOOK_ARGS}" ]; then
    NOTEBOOK_PROGRAM_ARGS+=${NOTEBOOK_ARGS}
fi

# Start the JupyterLab notebook
start_process jupyter notebook ${NOTEBOOK_PROGRAM_ARGS} \
    --NotebookApp.ip=0.0.0.0 \
    --NotebookApp.allow_origin="*" \
    --NotebookApp.open_browser=False \
