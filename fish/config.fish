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
