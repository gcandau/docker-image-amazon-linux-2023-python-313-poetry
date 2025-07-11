FROM amazonlinux:2023

# Install Poetry package manager
ENV POETRY_VERSION="2.1.2"
ENV POETRY_HOME=/opt/poetry
ENV POETRY_VENV=/opt/poetry-venv
ENV POETRY_CACHE_DIR=/opt/.cache

# Install dependencies
RUN yum groupinstall "Development Tools" -y \
    && yum erase openssl-devel -y \
    && yum install openssl openssl-devel  libffi-devel bzip2-devel wget -y


# Install Python 3.13
RUN wget https://www.python.org/ftp/python/3.13.5/Python-3.13.5.tgz \
    && tar -xvf Python-3.13.5.tgz \
    && cd Python-3.13.5 \
    && ./configure --enable-optimizations --prefix=/usr/local --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib" \
    && make altinstall \
    && cd .. \
    && rm -rf Python-3.13.5.tgz Python-3.13.5

# Install poetry separated from system interpreter
RUN python3.13 -m venv $POETRY_VENV \
    && $POETRY_VENV/bin/pip install -U pip setuptools \
    && $POETRY_VENV/bin/pip install poetry==${POETRY_VERSION}

# Add `poetry` to PATH
ENV PATH="${PATH}:${POETRY_VENV}/bin"
