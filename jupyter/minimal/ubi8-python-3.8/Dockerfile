#ARG BASE_IMAGE
FROM registry.access.redhat.com/ubi8/python-39:1-130

#LABEL name="odh-notebook-jupyter-minimal-ubi8-python-3.8" \
#    summary="Minimal Jupyter notebook image for ODH notebooks" \
#    description="Minimal Jupyter notebook image with base Python 3.8 builder image based on UBI8 for ODH notebooks" \
#    io.k8s.display-name="Minimal Jupyter notebook image for ODH notebooks" \
#    io.k8s.description="Minimal Jupyter notebook image with base Python 3.8 builder image based on UBI8 for ODH notebooks" \
#    authoritative-source-url="https://github.com/opendatahub-io/notebooks" \
#    io.openshift.build.commit.ref="main" \
#    io.openshift.build.source-location="https://github.com/opendatahub-io/notebooks/tree/main/jupyter/minimal/ubi8-python-3.8" \
#    io.openshift.build.image="quay.io/opendatahub/workbench-images:jupyter-minimal-ubi8-python-3.8"

WORKDIR /opt/app-root/bin

COPY utils utils/

COPY Pipfile.lock start-notebook.sh ./

# Install Python dependencies from Pipfile.lock file

RUN pip install micropipenv
RUN echo "Installing softwares and packages" && micropipenv install && rm -f ./Pipfile.lock

# Fix permissions to support pip in Openshift environments
RUN chmod -R g+w /opt/app-root/lib/python3.9/site-packages && \
      fix-permissions /opt/app-root -P

WORKDIR /opt/app-root/src

# Replace Notebook's launcher, "(ipykernel)" with Python's version 3.x.y
RUN sed -i -e "s/Python.*/$(python --version | cut -d '.' -f-2)\",/" /opt/app-root/share/jupyter/kernels/python3/kernel.json

RUN curl https://pyenv.run | bash

ENV PYENV_ROOT="$HOME/.pyenv"
ENV PATH="$PYENV_ROOT/bin:$PATH"

RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc && \
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc

RUN eval "$(pyenv init -)" && source ~/.bashrc

RUN pyenv install 3.10 && pyenv virtualenv 3.10 python3.10 && pyenv install 3.11 && pyenv virtualenv 3.11 python3.11

RUN git clone https://github.com/aiguofer/pyenv-jupyter-kernel $(pyenv root)/plugins/pyenv-jupyter-kernel

RUN pyenv register-kernel 3.11 
RUN pyenv register-kernel 3.10

ENTRYPOINT ["start-notebook.sh"]


