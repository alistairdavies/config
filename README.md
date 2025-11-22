# Config

Configuration files for a consistent development environment.

## Quick Setup (macOS)

```bash
git clone git@github.com:alistairdavies/config.git ~/.config
~/.config/scripts/setup.sh
```

## Manual Setup

1. Clone this repository into `~/.config`.
2. Install the following tools:
    - [Neovim](https://neovim.io/)
    - [Fish shell](https://fishshell.com/)
    - [Kitty terminal](https://sw.kovidgoyal.net/kitty/)
    - [SauceCodePro Nerd Font](https://www.nerdfonts.com/font-downloads)
    - [ripgrep](https://github.com/BurntSushi/ripgrep)
    - [fd](https://github.com/sharkdp/fd)
3. Make fish the default shell:
```bash
echo $(which fish) | sudo tee -a /etc/shells
chsh -s $(which fish)
```
4. Start Neovim. On first launch Lazy will automatically install the required plugins.
```bash
nvim
```
