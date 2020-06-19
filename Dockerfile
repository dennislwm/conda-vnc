FROM dennislwm/alpine-vnc
#
# repo https://repo.anaconda.com/miniconda/ (no spyder)
ARG CONDA_REPO="http://repo.continuum.io/miniconda/Miniconda3-"
ARG CONDA_VERSION="py38_4.8.3"
ARG CONDA_MD5="d63adf39f2c220950a063e0529d4ff74"
#
# repo https://repo.anaconda.com/archive (includes spyder but does NOT work)
#ARG CONDA_REPO="https://repo.anaconda.com/archive/Anaconda3-"
#ARG CONDA_VERSION="2020.02"
#ARG CONDA_MD5="17600d1f12b2b047b62763221f29f2bc"
#
ARG CONDA_DIR="/opt/conda"

ENV PATH="$CONDA_DIR/bin:$PATH"
ENV PYTHONDONTWRITEBYTECODE=1

# Install conda
RUN echo "**** install dev packages ****" && \
    apk add --no-cache --virtual .build-dependencies bash ca-certificates wget && \
    \
    echo "**** get Miniconda ****" && \
    mkdir -p "$CONDA_DIR" && \
    wget "${CONDA_REPO}${CONDA_VERSION}-Linux-x86_64.sh" -O miniconda.sh && \
    echo "$CONDA_MD5  miniconda.sh" | md5sum -c && \
    \
    echo "**** install Miniconda ****" && \
    bash miniconda.sh -f -b -p "$CONDA_DIR" && \
    echo "export PATH=$CONDA_DIR/bin:\$PATH" > /etc/profile.d/conda.sh && \
    \
    echo "**** setup Miniconda ****" && \
    conda update --all --yes && \
    conda config --set auto_update_conda False && \
    \
    echo "**** cleanup ****" && \
    apk del --purge .build-dependencies && \
    rm -f miniconda.sh && \
    conda clean --all --force-pkgs-dirs --yes && \
    find "$CONDA_DIR" -follow -type f \( -iname '*.a' -o -iname '*.pyc' -o -iname '*.js.map' \) -delete && \
    \
    echo "**** finalize ****" && \
    mkdir -p "$CONDA_DIR/locks" && \
    chmod 777 "$CONDA_DIR/locks"
