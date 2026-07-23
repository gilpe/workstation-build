# Workstation Build

A multipurpose Arch Linux workstation built iteratively. This repository documents the installation process, configuration, and tools used to create a powerful development and productivity environment.

## System Information

- **OS:** Arch Linux
- **Kernel:** 7.1.4.arch1-1
- **Bootloader:** Limine
- **Window Manager:** Hyprland 0.56.0-2
- **Terminal:** Ghostty 1.3.1-2
- **Shell:** Zsh (configured separately)
- **Editor:** Neovim 0.12.4-1

## Workflow

This project follows an iterative approach:
1. Start with a specific need or tool
2. Install and configure it
3. Document everything in these files
4. Move to the next requirement as it arises

Dotfiles are managed with GNU Stow. Configuration files are stored in `dotfiles/` and symlinked to `~/.config/`.

## Installed Packages

### Base System
- base
- base-devel
- btrfs-progs
- efibootmgr
- intel-ucode
- linux
- linux-firmware
- mkinitcpio
- sudo

### Networking
- networkmanager
- iwd

### Audio
- pipewire
- pipewire-alsa
- pipewire-jack
- pipewire-pulse
- wireplumber
- libpulse
- gst-plugin-pipewire

### Bluetooth
- bluez
- bluez-utils

### Printing
- cups
- cups-pk-helper
- system-config-printer

### Window Manager & Terminal
- hyprland
- ghostty

### Power Management
- power-profiles-daemon
- zram-generator

### Development Tools
- git
- github-cli
- lazygit
- neovim

### Utilities
- stow
- superfile

### Fonts
- ttf-jetbrains-mono-nerd

### AUR Packages (via yay)
- yay
- brave-bin
- opencode
- superfile
- ttf-jetbrains-mono-nerd

## Configuration

### Git
- User: gilpe
- Email: javier.gil.perez@outlook.es
- Credential helper: GitHub CLI (gh)

### YAY
- Version: 13.0.1
- Installed from AUR

## Dotfiles

Managed with GNU Stow. Structure:

```
dotfiles/
  ghostty/
    .config/ghostty/config.ghostty
  hypr/
    .config/hypr/hyprland.lua
  lazygit/
    .config/lazygit/config.yml
  opencode/
    .config/opencode/opencode.jsonc
  superfile/
    .config/superfile/config.toml
    .config/superfile/hotkeys.toml
    .config/superfile/theme/*.toml
  gh/
    .config/gh/config.yml
```

Each package mirrors the home directory structure. Deploy with:
```bash
cd ~/workstation-build/dotfiles
stow -t ~ ghostty hypr lazygit opencode superfile gh
```

**Note:** `gh/hosts.yml` is not tracked (contains OAuth tokens).

## Next Steps

- [ ] Configure Limine bootloader
- [ ] Set up shell environment (zsh, prompt, aliases)
- [ ] Configure Neovim
- [ ] Add more development tools as needed
