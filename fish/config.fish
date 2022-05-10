set -x GOPATH $HOME/go

set -g DOCKER_BUILDKIT 1
set -g COMPOSE_DOCKER_CLI_BUILD 1
status --is-interactive; and source (pyenv init -|psub)


# make pip explode if attempting to install packages globally
set -x PIP_REQUIRE_VIRTUALENV 1

function gpip
  PIP_REQUIRE_VIRTUALENV="" pip $argv
end

set -x EDITOR nvim
set -x VISUAL nvim

# Created by `pipx` on 2021-09-13 09:39:19
set PATH $PATH /Users/alidav01/.local/bin

# Created by `pipx` on 2021-09-13 09:39:23
set PATH $PATH /Users/alidav01/Library/Python/3.9/bin
fish_add_path /usr/local/opt/llvm/bin
fish_add_path //Users/alidav01/.cargo/bin
