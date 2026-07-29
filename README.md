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
- wireless-regdb

### Wireless Configuration
- **Config file:** `/etc/conf.d/wireless-regdom`
- **Current setting:** `WIRELESS_REGDOM=ES` (Spain)
- **Purpose:** Sets the regulatory domain for WiFi to comply with local regulations
- **To change country:** Edit `/etc/conf.d/wireless-regdom` and change `WIRELESS_REGDOM=` value
- **Common codes:** ES (Spain), US (United States), DE (Germany), FR (France)
- **Note:** Resolves "Process '/usr/bin/set-wireless-regdom' failed with exit code 1" error

### Console Log Level
- **Config file:** `/etc/sysctl.d/99-quiet-console.conf`
- **Setting:** `kernel.printk = 3 4 1 3`
- **Purpose:** Prevents kernel warnings from cluttering TTY/login screens
- **Note:** Messages are still logged to journal (`journalctl -k`). Only affects console output, not functionality.

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

### Display Manager
- ly

### Display Manager Configuration
- **Service:** `ly@tty2.service` (enabled via systemd)
- **Config:** `/etc/ly/config.ini` (default_session = Hyprland)
- **Access:** Ctrl+Alt+F2 to reach ly login screen
- **Note:** ly remembers last session selection (save = true)

### Console/TTY Configuration
- **Config file:** `/etc/vconsole.conf`
- **Current font:** `ter-132n` (16x32px for QHD+)
- **Keymap:** es (Spanish)
- **To apply font changes:**
  1. Edit `/etc/vconsole.conf` and change `FONT=` value
  2. Rebuild initramfs: `sudo mkinitcpio -P`
  3. Reboot to apply
- **Note:** Only affects TTY (ly login screen, raw terminals). Does not affect Hyprland or GUI apps.
- **Available terminus fonts:** `ter-112n` to `ter-132n` (increasing sizes)

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
- opencode
- superfile
- bemenu

### Fonts
- ttf-jetbrains-mono-nerd
- terminus-font

### AUR Packages (via yay)
- yay
- brave-bin

## Configuration

### Git
- User: gilpe
- Email: javier.gil.perez@outlook.es
- Credential helper: GitHub CLI (gh)

### Ghostty
- **Padding:** 0 (content fills available space, top-left aligned)

### Hyprland
- **Keyboard layout:** ES (Spanish)
- **SUPER + Enter:** Opens terminal (ghostty)
- **SUPER + Esc:** Close window
- **SUPER + E:** Opens file manager (superfile in ghostty)
- **SUPER + Space:** Opens launcher (bemenu)
- **Animations:** Lightweight (fade disabled, faster speeds)
- **Smart gaps:** Enabled (no gaps when single window)
- **Gaps:** 3px inner, 10px outer
- **Resize on border:** Enabled
- **Logo/wallpaper:** Disabled
- **Dwindle layout:** preserve_split = true (default behavior)

### Neovim
- **Config:** Modular Lua configuration
- **Leader key:** Space
- **Indentation:** 4 spaces (2 for lua/vim/sh/bash/zsh)
- **Features:** Line numbers, mouse support, system clipboard, persistent undo
- **Keybindings:** VSCode-like (Ctrl+S → `<leader>s`, Ctrl+P → `<leader>p`, etc.)
- **Theme:** Uses terminal colors (matches Ghostty's Atom One Dark)
- **Structure:**
  - `init.lua` - Entry point
  - `lua/config/options.lua` - Editor options
  - `lua/config/keymaps.lua` - VSCode-like keybindings
  - `lua/config/autocmds.lua` - Autocommands (highlight on yank, restore cursor position, auto-reload)

### YAY
- Version: 13.0.1
- Installed from AUR

## Dotfiles

Managed with GNU Stow. Structure:

```
dotfiles/
  ghostty/
    .config/ghostty/config
  hypr/
    .config/hypr/hyprland.lua      (main entry - requires sub-modules)
    .config/hypr/monitor.lua       (monitor configuration)
    .config/hypr/input.lua         (keyboard ES layout, mouse, touchpad)
    .config/hypr/decoration.lua    (borders, shadows, blur, smart gaps)
    .config/hypr/animations.lua    (lightweight animations)
    .config/hypr/bindings.lua      (keybinds)
    .config/hypr/windowrules.lua   (window/workspace rules)
    .config/hypr/misc.lua          (env vars, autostart, misc settings)
  lazygit/
    .config/lazygit/config.yml
  nvim/
    .config/nvim/init.lua          (entry point)
    .config/nvim/lua/config/options.lua
    .config/nvim/lua/config/keymaps.lua
    .config/nvim/lua/config/autocmds.lua
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
stow -t ~ ghostty hypr lazygit nvim opencode superfile gh
```

**Note:** `gh/hosts.yml` is not tracked (contains OAuth tokens).

## Next Steps

- [x] Configure display manager (ly with Hyprland)
- [x] Configure TTY font for better readability
- [x] Configure wireless regulatory domain
- [x] Configure Neovim (base config with VSCode-like keybindings)
- [ ] Configure Limine bootloader
- [ ] Set up shell environment (zsh, prompt, aliases)
- [ ] Add more development tools as needed
