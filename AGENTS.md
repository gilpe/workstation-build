# AGENTS.md - Workstation Build Project

## Project Overview

This is an iterative Arch Linux workstation build project. The goal is to create a powerful multipurpose development and productivity environment, documenting every step along the way.

**Key principle:** Build incrementally as needs arise, not all at once.

## File Structure

- **README.md** - Living documentation of the workstation: what it is, what's installed, current state
- **install.sh** - Interactive installation script with all packages and configurations
- **AGENTS.md** - This file. Instructions for AI agents working on this project

## Current State

### What's Done
- Fresh Arch Linux installation
- Base packages installed (see README.md for full list)
- YAY AUR helper installed
- Git configured (user: gilpe, email: javier.gil.perez@outlook.es)
- Hyprland window manager
- Ghostty terminal
- Neovim editor
- Audio stack (PipeWire)
- Bluetooth, printing, networking configured
- GitHub CLI for authentication

### What's Pending
- Limine bootloader configuration (TODO in install.sh)
- Shell environment (zsh config, prompt, aliases)
- Neovim configuration
- Additional development tools as needed
- Dotfiles integration with stow (later, when config is finalized)

## Conventions

### When Adding New Software/Configuration

1. **Update all three files:**
   - Add package to `install.sh` in the appropriate section
   - Document in `README.md` under the right category
   - Update `AGENTS.md` current state if significant

2. **install.sh structure:**
   - Each major category is a separate function
   - Each function has a y/n prompt before running
   - Check if already installed/configured before overwriting
   - Use `pacman -S --needed` for pacman packages
   - Use `yay -S --needed` for AUR packages
   - Group related packages together with comments

3. **README.md organization:**
   - Keep packages grouped by category
   - Update "Next Steps" checklist
   - Add new sections if needed (e.g., "Docker Setup", "Programming Languages")

4. **Configuration files:**
   - Build fresh configs in this repository
   - Don't use existing ~/dotfiles/ yet
   - Will integrate with stow later when finalized

### Code Style

- Use helper functions in install.sh (info, success, warn, error, confirm)
- Color output for better readability
- Check before overwriting existing configs
- Use `set -e` for error handling
- Add comments to explain non-obvious configurations

## Instructions for Future Sessions

### When Continuing This Project

1. **Read all three files first** to understand current state
2. **Ask the user what they want to work on next** (don't assume)
3. **Follow the iterative approach** - one thing at a time
4. **Test installations** before marking as complete
5. **Update all three files** after each addition

### Common Tasks

**Adding a new package:**
1. Add to install.sh in the appropriate section (or create new section)
2. Add to README.md under the right category
3. Run the install.sh section to verify it works

**Adding a new configuration:**
1. Create the config file in the repository
2. Add installation/copy command to install.sh
3. Document in README.md
4. Check if config file exists before overwriting

**Adding a new tool category:**
1. Create new function in install.sh
2. Add new section in README.md
3. Update this AGENTS.md if it's a major category

### Important Notes

- The user prefers a **fluid, iterative approach** - don't try to do everything at once
- **Dotfiles are separate** - we're building fresh configs, will integrate with stow later
- **Interactive prompts** in install.sh - user confirms each section
- **Check before overwriting** - don't destroy existing configs
- **Document everything** - if it's not in the files, it didn't happen

## Workflow Example

User: "I need Docker"

Agent:
1. Add docker and docker-compose to install.sh (new section or add to dev tools)
2. Add docker to README.md
3. Run the installation
4. Verify docker works
5. Update AGENTS.md current state

## Contact

For questions about this project structure or conventions, refer to this AGENTS.md file.
