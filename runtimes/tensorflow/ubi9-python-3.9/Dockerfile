ARG BASE_IMAGE
FROM ${BASE_IMAGE}

LABEL name="odh-notebook-cuda-runtime-tensorflow-ubi9-python-3.9" \
    summary="Runtime CUDA tensorflow notebook image for ODH notebooks" \
    description="Runtime CUDA tensorflow notebook image with base Python 3.9 builder image based on UBI9 for ODH notebooks" \
    io.k8s.display-name="Runtime CUDA tensorflow notebook image for ODH notebooks" \
    io.k8s.description="Runtime CUDA tensorflow notebook image with base Python 3.9 builder image based on UBI9 for ODH notebooks" \
    authoritative-source-url="https://github.com/opendatahub-io/notebooks" \
    io.openshift.build.commit.ref="main" \
    io.openshift.build.source-location="https://github.com/opendatahub-io/notebooks/tree/main/runtimes/tensorflow/ubi8-python-3.9" \
    io.openshift.build.image="quay.io/opendatahub/workbench-images:cuda-runtime-tensorflow-ubi9-python-3.9"

# Install Python packages from Pipfile.lock
COPY Pipfile.lock ./

RUN echo "Installing softwares and packages" && \
    micropipenv install && \
    rm -f ./Pipfile.lock && \
    # Fix permissions to support pip in Openshift environments \
    chmod -R g+w /opt/app-root/lib/python3.9/site-packages && \
    fix-permissions /opt/app-root -P
