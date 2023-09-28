ARG MICROMAMBA_VERSION=1.5.1
FROM  mambaorg/micromamba:${MICROMAMBA_VERSION}
LABEL maintainer="xcube-team@brockmann-consult.de"
LABEL name="xcube-testbed19"
LABEL description="xcube OGC Testbed 19 server"

# Activate the conda environment during docker build, so we can
# use micromamba-installed git.
ARG MAMBA_DOCKERFILE_ACTIVATE=1

RUN micromamba install --yes --name base --channel conda-forge \
    git \
    pip && \
    git clone https://github.com/dcs4cop/xcube.git && \
    cd xcube && \
    git checkout c1e0b760bfd9 && \
    micromamba install --yes --name base --file environment.yml && \
    pip install --no-deps --verbose --editable . && \
    micromamba clean --yes --all --force-pkgs-dirs

WORKDIR /home/$MAMBA_USER

# The micromamba entrypoint.
# Allows us to run container as an executable with
# base environment activated.
ENTRYPOINT ["/usr/local/bin/_entrypoint.sh"]

# Default command (shell form)
CMD xcube --help
