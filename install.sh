#!/bin/bash
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Helper functions
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

confirm() {
    read -p "$1 [y/N]: " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

# Section 1: Pacman packages
install_pacman_packages() {
    info "Installing official packages from pacman..."
    
    # Base system
    sudo pacman -S --needed --noconfirm \
        base \
        base-devel \
        btrfs-progs \
        efibootmgr \
        intel-ucode \
        linux \
        linux-firmware \
        mkinitcpio \
        sudo
    
    # Networking
    sudo pacman -S --needed --noconfirm \
        networkmanager \
        iwd \
        wireless-regdb
    
    # Audio
    sudo pacman -S --needed --noconfirm \
        pipewire \
        pipewire-alsa \
        pipewire-jack \
        pipewire-pulse \
        wireplumber \
        libpulse \
        gst-plugin-pipewire \
        wiremix \
        rtkit
    
    # Bluetooth
    sudo pacman -S --needed --noconfirm \
        bluez \
        bluez-utils \
        bluetui
    
    # Printing
    sudo pacman -S --needed --noconfirm \
        cups \
        cups-pk-helper \
        system-config-printer
    
    # Window manager & terminal
    sudo pacman -S --needed --noconfirm \
        hyprland \
        ghostty
    
    # Power management
    sudo pacman -S --needed --noconfirm \
        power-profiles-daemon \
        zram-generator
    
    # Development tools
    sudo pacman -S --needed --noconfirm \
        git \
        github-cli \
        lazygit \
        neovim
    
    # Utilities
    pacman -S --needed --noconfirm \
        stow \
        terminus-font \
        ttf-jetbrains-mono-nerd \
        opencode \
        superfile \
        fuzzel \
        papirus-icon-theme \
        noto-fonts-emoji \
        gsettings-backend
    
    success "Pacman packages installed"
}

# Section 2: YAY installation
install_yay() {
    if command -v yay &> /dev/null; then
        success "YAY is already installed"
        return 0
    fi
    
    info "Installing YAY from AUR..."
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
    
    success "YAY installed successfully"
}

# Section 3: AUR packages
install_aur_packages() {
    if ! command -v yay &> /dev/null; then
        error "YAY is not installed. Run section 2 first."
        return 1
    fi
    
    info "Installing AUR packages..."
    yay -S --needed --noconfirm \
        brave-bin \
        wlctl-bin \
        broadcom-bt-firmware
    
    success "AUR packages installed"
}

# Section 4: Git configuration
configure_git() {
    if [ -f ~/.gitconfig ]; then
        warn "~/.gitconfig already exists, skipping"
        return 0
    fi
    
    info "Configuring git..."
    git config --global user.name "gilpe"
    git config --global user.email "javier.gil.perez@outlook.es"
    git config --global credential.https://github.com.helper '!/usr/bin/gh auth git-credential'
    git config --global credential.https://gist.github.com.helper '!/usr/bin/gh auth git-credential'
    
    success "Git configured"
}

# Section 5: Deploy dotfiles
deploy_dotfiles() {
    if ! command -v stow &> /dev/null; then
        error "stow is not installed. Run section 1 first."
        return 1
    fi
    
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    DOTFILES_DIR="$SCRIPT_DIR/dotfiles"
    
    if [ ! -d "$DOTFILES_DIR" ]; then
        error "Dotfiles directory not found at $DOTFILES_DIR"
        return 1
    fi
    
    info "Deploying dotfiles with stow..."
    
    for package in ghostty hypr lazygit nvim opencode superfile gh wiremix wlctl bluetui fuzzel; do
        if [ -d "$DOTFILES_DIR/$package" ]; then
            stow -t ~ "$package" --restow
            success "Deployed $package"
        else
            warn "Package $package not found, skipping"
        fi
    done
    
    success "Dotfiles deployed"
}

# Section 6: Display manager (ly)
configure_display_manager() {
    if systemctl is-active --quiet ly@tty2.service; then
        success "ly display manager is already active"
        return 0
    fi

    info "Installing ly display manager..."
    sudo pacman -S --needed --noconfirm ly

    info "Enabling ly@tty2.service..."
    sudo systemctl enable ly@tty2.service

    info "Configuring ly with Hyprland as default session..."
    if [ -f /etc/ly/config.ini ]; then
        warn "/etc/ly/config.ini already exists, backing up to /etc/ly/config.ini.bak"
        sudo cp /etc/ly/config.ini /etc/ly/config.ini.bak
    fi

    sudo tee /etc/ly/config.ini > /dev/null << 'EOF'
# ly display manager configuration
# Default session set to Hyprland
default_session = Hyprland
EOF

    success "ly display manager configured on tty2"
}

# Section 7: Configure TTY font
configure_tty_font() {
    if [ ! -f /etc/vconsole.conf ]; then
        error "/etc/vconsole.conf not found"
        return 1
    fi

    info "Configuring TTY font..."
    
    if grep -q "FONT=ter-132n" /etc/vconsole.conf; then
        success "TTY font already configured as ter-132n"
        return 0
    fi

    if [ -f /etc/vconsole.conf ]; then
        warn "Backing up /etc/vconsole.conf to /etc/vconsole.conf.bak"
        sudo cp /etc/vconsole.conf /etc/vconsole.conf.bak
    fi

    sudo sed -i 's/^FONT=.*/FONT=ter-132n/' /etc/vconsole.conf
    
    info "Rebuilding initramfs..."
    sudo mkinitcpio -P
    
    success "TTY font configured (ter-132n). Reboot to apply."
}

# Section 8: Configure wireless regulatory domain
configure_wireless_regdom() {
    if [ -f /etc/conf.d/wireless-regdom ]; then
        if grep -q "WIRELESS_REGDOM=ES" /etc/conf.d/wireless-regdom; then
            success "Wireless regulatory domain already configured for ES (Spain)"
            return 0
        fi
    fi

    info "Configuring wireless regulatory domain..."
    
    sudo tee /etc/conf.d/wireless-regdom > /dev/null << 'EOF'
# Wireless regulatory domain configuration
# Set your country code (e.g., ES for Spain, US for United States)
WIRELESS_REGDOM=ES
EOF

    success "Wireless regulatory domain configured for ES (Spain)"
}

# Section 9: Quiet console log level
configure_quiet_console() {
    if [ -f /etc/sysctl.d/99-quiet-console.conf ]; then
        if grep -q "kernel.printk = 3 4 1 3" /etc/sysctl.d/99-quiet-console.conf; then
            success "Console log level already configured"
            return 0
        fi
    fi

    info "Setting quiet console log level to prevent kernel warnings on TTY..."
    
    sudo tee /etc/sysctl.d/99-quiet-console.conf > /dev/null << 'EOF'
# Quiet kernel console messages
# Prevents kernel warnings from cluttering TTY/login screens
# Messages are still logged to journal (journalctl -k)
# kernel.printk format: console_loglevel default_message_loglevel minimum_console_loglevel default_console_loglevel
# Setting console_loglevel to 3 means only errors (level 0-2) print to TTY
# Warnings (level 3) and above are suppressed from console but still logged
kernel.printk = 3 4 1 3
EOF

    sudo sysctl -p /etc/sysctl.d/99-quiet-console.conf
    
    success "Console log level set to quiet"
}

# Section 10: Configure dark theme
configure_dark_theme() {
    if ! command -v gsettings &> /dev/null; then
        error "gsettings is not installed. Run section 1 first."
        return 1
    fi

    current_scheme=$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null)
    if [ "$current_scheme" = "'prefer-dark'" ]; then
        success "Dark theme already configured"
        return 0
    fi

    info "Setting system theme preference to dark..."
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    
    success "Dark theme configured"
}

# Section 12: Configure Bluetooth stability
configure_bluetooth_stability() {
    if [ ! -f /etc/bluetooth/main.conf ]; then
        error "/etc/bluetooth/main.conf not found"
        return 1
    fi

    if grep -q "^FastConnectable = true" /etc/bluetooth/main.conf && \
       grep -q "^ControllerMode = bredr" /etc/bluetooth/main.conf; then
        success "Bluetooth stability already configured"
        return 0
    fi

    info "Configuring Bluetooth stability for audio devices..."
    
    if [ -f /etc/bluetooth/main.conf ]; then
        warn "Backing up /etc/bluetooth/main.conf to /etc/bluetooth/main.conf.bak"
        sudo cp /etc/bluetooth/main.conf /etc/bluetooth/main.conf.bak
    fi

    sudo tee -a /etc/bluetooth/main.conf > /dev/null << 'EOF'

# Bluetooth stability configuration (for AirPods Pro and similar devices)
# FastConnectable reduces connection drops by allowing faster reconnections
FastConnectable = true
# ControllerMode bredr is more stable for audio-only devices
ControllerMode = bredr
EOF

    info "Restarting bluetooth service..."
    sudo systemctl restart bluetooth
    
    success "Bluetooth stability configured. Restart audio services or reboot to apply."
}

# Section 11: Configure pacman (ILoveCandy + VerbosePkgLists)
configure_pacman() {
    if [ ! -f /etc/pacman.conf ]; then
        error "/etc/pacman.conf not found"
        return 1
    fi

    if grep -q "^ILoveCandy" /etc/pacman.conf; then
        success "Pacman already configured with ILoveCandy"
        return 0
    fi

    info "Configuring pacman with ILoveCandy and VerbosePkgLists..."
    
    if [ -f /etc/pacman.conf ]; then
        warn "Backing up /etc/pacman.conf to /etc/pacman.conf.bak"
        sudo cp /etc/pacman.conf /etc/pacman.conf.bak
    fi

    sudo sed -i '/^Color$/a ILoveCandy' /etc/pacman.conf
    sudo sed -i 's/^#VerbosePkgLists$/VerbosePkgLists/' /etc/pacman.conf
    
    success "Pacman configured with ILoveCandy and VerbosePkgLists"
}

# Section 12: Limine configuration
configure_limine() {
    warn "Limine configuration not yet implemented"
    # TODO: Add limine configuration when ready
    # cp limine.conf /boot/limine.conf
    # limine bios-install /dev/sdX
}

# Main execution
main() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  Workstation Build Installation Script${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo
    
    if confirm "Install pacman packages?"; then
        install_pacman_packages
    fi
    
    echo
    
    if confirm "Install YAY (AUR helper)?"; then
        install_yay
    fi
    
    echo
    
    if confirm "Install AUR packages?"; then
        install_aur_packages
    fi
    
    echo
    
    if confirm "Configure git?"; then
        configure_git
    fi
    
    echo
    
    if confirm "Deploy dotfiles?"; then
        deploy_dotfiles
    fi
    
    echo
    
    if confirm "Configure display manager (ly)?"; then
        configure_display_manager
    fi

    echo

    if confirm "Configure TTY font (ter-132n for QHD+)?"; then
        configure_tty_font
    fi

    echo

    if confirm "Configure wireless regulatory domain (ES)?"; then
        configure_wireless_regdom
    fi

    echo

    if confirm "Set quiet console log level (prevents kernel warnings on TTY)?"; then
        configure_quiet_console
    fi

    echo

    if confirm "Configure dark theme (system-wide preference)?"; then
        configure_dark_theme
    fi

    echo

    if confirm "Configure Bluetooth stability (fixes AirPods Pro disconnections)?"; then
        configure_bluetooth_stability
    fi

    echo

    if confirm "Configure pacman (ILoveCandy + VerbosePkgLists)?"; then
        configure_pacman
    fi

    echo

    if confirm "Configure Limine bootloader?"; then
        configure_limine
    fi
    
    echo
    success "Installation complete!"
}

main "$@"
