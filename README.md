# voidlily dotfiles

## new mac bootstrap

1. install desired mac apps like firefox, ghostty, etc
1. install git/xcode devtools - `sudo xcode-select --install`
1. install determinate nix
1. `git clone` this repo
1. copy `systems/aarch64-darwin` to new system matching the hostname
1. edit username as necessary
1. `nix run "nixpkgs#nh" darwin switch`
1. `jj git init` - we're set up
