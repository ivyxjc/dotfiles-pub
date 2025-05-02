FROM ivyxjc/devcontainer:base

ARG PYTHON_VERSION=3.12

RUN sudo apt-get update \
    && sudo apt-get install -y build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
    && sudo rm -rf /var/lib/apt/lists/*

COPY --chown=dev:dev . /home/dev/dotfiles


RUN curl https://pyenv.run | bash \
    && export PYENV_ROOT="$HOME/.pyenv" \
    && export PATH="$PYENV_ROOT/bin:$PATH" \
    && eval "$(pyenv init - bash)" \
    && pyenv install $PYTHON_VERSION \
    && pyenv global $PYTHON_VERSION \
    && rm -rf /tmp/*