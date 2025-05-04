FROM ivyxjc/devcontainer:base

RUN sudo apt-get update \
    && sudo apt-get install -y build-essential cppcheck valgrind clang lldb llvm gdb \
    && sudo rm -rf /var/lib/apt/lists/*

COPY --chown=dev:dev . /home/dev/dotfiles

WORKDIR /home/dev/dotfiles/script

RUN chmod +x -R .

RUN ./cmake.sh

WORKDIR /home/dev

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && . "$HOME/.cargo/env" \
    && rustup update \
    && rustup component add rust-src