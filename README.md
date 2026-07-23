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

Dotfiles are built fresh in this repository and will be integrated with GNU Stow once the configuration is finalized.

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

## Next Steps

- [ ] Configure Limine bootloader
- [ ] Set up shell environment (zsh, prompt, aliases)
- [ ] Configure Neovim
- [ ] Add more development tools as needed
- [ ] Integrate dotfiles with stow
