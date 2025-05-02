FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y sudo

RUN useradd -m dev && \
    echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER dev

RUN sudo apt-get update \
    && sudo apt-get install -y git curl wget locales vim python3 python3-pip zsh lua5.4 liblua5.4-dev\
    && sudo localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

ENV LANG=en_US.utf8

COPY --chown=dev:dev . /home/dev/dotfiles

WORKDIR /home/dev/dotfiles/script

RUN chmod +x -R .

RUN ./install-zsh.sh

WORKDIR /home/dev/dotfiles

RUN ./install

RUN zsh -c "source ~/.zshrc"

RUN sudo chsh -s $(which zsh)

CMD ["zsh"]