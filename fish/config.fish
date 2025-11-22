set -g DOCKER_BUILDKIT 1
set -g COMPOSE_DOCKER_CLI_BUILD 1
status --is-interactive

fish_add_path ~/.local/bin

if command -q mise
    mise activate fish | source
else
    echo "Warning: mise not found. Install from https://mise.jdx.dev"
end

# make pip explode if attempting to install packages globally
set -x PIP_REQUIRE_VIRTUALENV 1

function gpip
  PIP_REQUIRE_VIRTUALENV="" pip $argv
end

set -x EDITOR nvim
set -x VISUAL nvim

