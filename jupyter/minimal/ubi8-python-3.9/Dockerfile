ARG BASE_IMAGE
# BASE_IMAGE=registry.access.redhat.com/ubi8/python-39:1-130
FROM ${BASE_IMAGE}

RUN curl https://pyenv.run | bash

WORKDIR /opt/app-root/bin

ARG REDHAT_USERNAME
ARG REDHAT_PASSWORD

USER root

# install required dependencies
RUN sed -i 's/\(def in_container():\)/\1\n    return False/g' /usr/lib64/python*/*-packages/rhsm/config.py && \
    # Replace default shell for user 1001 (default)
    sed -i '/^default/s:/sbin/nologin:/bin/bash:' /etc/passwd && \
    # In order to install packages inside container must disable subscription manager in_container check
    subscription-manager register --force --username  ${REDHAT_USERNAME} --password ${REDHAT_PASSWORD} && \
    # Packages required for pyenv
    dnf install -y ncurses-devel readline-devel && \
    # Some commands required by pyenv which needed to be inserted to global profile
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc && \
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc && \
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc 

USER default

# So the shell opened in the jupyter is bash and not sh as by default
ENV SHELL=/bin/bash

# To disable problematic python venv
ENV BASH_ENV=
ENV ENV=
ENV PROMPT_COMMAND=

# Container build runs on sh so adding the pyenv to the PATH is required 
ENV PYENV_ROOT="$HOME/.pyenv"
ENV PATH="$PYENV_ROOT/bin:$PATH"

COPY utils utils/

COPY Pipfile.lock start-notebook.sh ./

# Install basic Python dependencies for notebooks from Pipfile.lock file

RUN pip install pipenv micropipenv virtualenvwrapper && \
    micropipenv install && rm -f ./Pipfile.lock && \ 
    # Fix permissions to support pip in Openshift environments
    chmod -R g+w /opt/app-root/lib/python3.9/site-packages && \
    fix-permissions /opt/app-root -P && \
    # Replace Notebook's launcher, "(ipykernel)" with Python's version 3.x.y
    sed -i -e "s/Python.*/$(python --version | cut -d '.' -f-2)\",/" /opt/app-root/share/jupyter/kernels/python3/kernel.json

WORKDIR /opt/app-root/src

# Install multiple Python versions
RUN pyenv install 3.10 && \
    pyenv install 3.11 && \
    # Configure virtual env for each Python version
    pyenv virtualenv 3.10 python3.10 && \
    pyenv virtualenv 3.11 python3.11 && \
    # Install nbextensions
    jupyter contrib nbextension install --user && \
    # Sourcing the pyenv init before installation leads to permission denied upon installation of new python versions 
    source ~/.bashrc && \
    # Make global the installed versions so pip3.10 and pip3.11 are available
    pyenv global python3.10 python3.11 && \
    # Install ipykernel in each new version so kernel is available
    pip3.10 install ipykernel && \
    pip3.11 install ipykernel

# Copy the kernels to the container so there will be 3 kernels available each pointing to the correct python version
COPY kernels/python3.10 /opt/app-root/share/jupyter/kernels/python3.10
COPY kernels/python3.11 /opt/app-root/share/jupyter/kernels/python3.11

ENTRYPOINT ["start-notebook.sh"]