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
        iwd
    
    # Audio
    sudo pacman -S --needed --noconfirm \
        pipewire \
        pipewire-alsa \
        pipewire-jack \
        pipewire-pulse \
        wireplumber \
        libpulse \
        gst-plugin-pipewire
    
    # Bluetooth
    sudo pacman -S --needed --noconfirm \
        bluez \
        bluez-utils
    
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
    sudo pacman -S --needed --noconfirm \
        stow
    
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
        opencode \
        superfile \
        ttf-jetbrains-mono-nerd
    
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
    
    for package in ghostty hypr lazygit opencode superfile gh; do
        if [ -d "$DOTFILES_DIR/$package" ]; then
            stow -t ~ "$package" --restow
            success "Deployed $package"
        else
            warn "Package $package not found, skipping"
        fi
    done
    
    success "Dotfiles deployed"
}

# Section 6: Limine configuration
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
    
    if confirm "Configure Limine bootloader?"; then
        configure_limine
    fi
    
    echo
    success "Installation complete!"
}

main "$@"
