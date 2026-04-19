#!/usr/bin/env bash
# New-machine bootstrap for ntdkhang's dotfiles.
#
# Run this AFTER cloning the repo to ~/.config:
#   git clone git@github.com:ntdkhang/config.git ~/.config
#   cd ~/.config && ./setup.sh
#
# Idempotent: safe to re-run. Prints [skip] when a step is already done.
# macOS only (uses Homebrew, yabai, skhd, sketchybar, karabiner).

set -euo pipefail

DOTFILES="$HOME/.config"
log()  { printf "\033[1;34m==>\033[0m %s\n" "$*"; }
skip() { printf "\033[1;33m[skip]\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[warn]\033[0m %s\n" "$*" >&2; }
die()  { printf "\033[1;31m[err]\033[0m %s\n" "$*" >&2; exit 1; }

have() { command -v "$1" >/dev/null 2>&1; }

[[ "$(uname -s)" == "Darwin" ]] || die "This script is macOS-only."
[[ -d "$DOTFILES/.git" ]] || die "Expected dotfiles repo at $DOTFILES (run: git clone git@github.com:ntdkhang/config.git ~/.config)."

# -----------------------------------------------------------------------------
# 1. Xcode Command Line Tools
# -----------------------------------------------------------------------------
if xcode-select -p >/dev/null 2>&1; then
    skip "Xcode Command Line Tools already installed"
else
    log "Installing Xcode Command Line Tools (follow the GUI prompt)"
    xcode-select --install || true
    read -rp "Press enter once Xcode CLT installation finishes... "
fi

# -----------------------------------------------------------------------------
# 2. Homebrew
# -----------------------------------------------------------------------------
if have brew; then
    skip "Homebrew already installed"
else
    log "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

# -----------------------------------------------------------------------------
# 3. Brew formulas (CLI tools)
# -----------------------------------------------------------------------------
log "Installing CLI tools via brew"
BREW_FORMULAS=(
    # Core dev
    git gh lazygit git-delta just
    # Search / nav
    ripgrep fd fzf bat eza tree
    # Editor + terminal multiplexer
    neovim tmux
    # Languages / runtimes (rust has its own installer below)
    go node pnpm
    # Window mgmt / keyboard (author was koekeishiya, now asmvik)
    asmvik/formulae/yabai
    asmvik/formulae/skhd
    FelixKratz/formulae/sketchybar
    # Nerd font
    font-symbols-only-nerd-font
)
for f in "${BREW_FORMULAS[@]}"; do
    if brew list --formula --versions "${f##*/}" >/dev/null 2>&1; then
        skip "brew: ${f##*/}"
    else
        brew install "$f" || warn "brew install $f failed"
    fi
done

# -----------------------------------------------------------------------------
# 4. Brew casks (GUI apps)
# -----------------------------------------------------------------------------
log "Installing GUI apps via brew cask"
BREW_CASKS=(
    alacritty
    karabiner-elements
    lunar
    font-jetbrains-mono-nerd-font
    font-hack-nerd-font
)
for c in "${BREW_CASKS[@]}"; do
    if brew list --cask --versions "$c" >/dev/null 2>&1; then
        skip "cask: $c"
    else
        brew install --cask "$c" || warn "brew install --cask $c failed"
    fi
done

# -----------------------------------------------------------------------------
# 5. Rust (rustup)
# -----------------------------------------------------------------------------
if [[ -f "$HOME/.cargo/env" ]]; then
    skip "Rust toolchain already installed"
else
    log "Installing Rust via rustup"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi

# -----------------------------------------------------------------------------
# 6. oh-my-zsh + plugins
# -----------------------------------------------------------------------------
if [[ -d "$HOME/.oh-my-zsh" ]]; then
    skip "oh-my-zsh already installed"
else
    log "Installing oh-my-zsh"
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
    skip "zsh-autosuggestions"
else
    log "Installing zsh-autosuggestions"
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi
if [[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
    skip "zsh-syntax-highlighting"
else
    log "Installing zsh-syntax-highlighting"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# -----------------------------------------------------------------------------
# 7. nvm + node
# -----------------------------------------------------------------------------
if [[ -d "$HOME/.nvm" ]]; then
    skip "nvm already installed"
else
    log "Installing nvm"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

# -----------------------------------------------------------------------------
# 8. Home-dir symlinks
# -----------------------------------------------------------------------------
link() {
    local src="$1" dst="$2"
    if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
        skip "symlink $dst -> $src"
    elif [[ -e "$dst" || -L "$dst" ]]; then
        warn "$dst exists and is not the expected symlink; moving to $dst.bak"
        mv "$dst" "$dst.bak"
        ln -s "$src" "$dst"
        log "linked $dst -> $src"
    else
        ln -s "$src" "$dst"
        log "linked $dst -> $src"
    fi
}
link "$DOTFILES/.zshrc"   "$HOME/.zshrc"
link "$DOTFILES/.zshenv"  "$HOME/.zshenv"

# Expose nvim helper scripts on PATH (~/.local/bin is already on PATH via .zshrc)
mkdir -p "$HOME/.local/bin"
chmod +x "$DOTFILES/nvim/scripts/open-in-nvim"
link "$DOTFILES/nvim/scripts/open-in-nvim" "$HOME/.local/bin/open-in-nvim"

# Register local opencode TUI plugins globally so they show up in every
# opencode session, not just inside ~/.config/. Writes ~/.config/opencode/tui.json,
# which we don't track because the spec contains an absolute path.
# We `cd /tmp` because opencode treats the cwd as a project — running from
# ~/.config would create a project-local install instead of a global one.
if command -v opencode >/dev/null 2>&1; then
    for plugin_dir in "$DOTFILES/opencode/plugin"/*/; do
        if [[ -f "$plugin_dir/package.json" ]]; then
            log "Registering opencode plugin (global): $plugin_dir"
            (cd /tmp && opencode plugin --global --force "${plugin_dir%/}") \
                || warn "opencode plugin register failed: $plugin_dir"
        fi
    done
else
    skip "opencode plugin registration (opencode not on PATH)"
fi

# -----------------------------------------------------------------------------
# 9. Vendored clones (gitignored, fetched fresh per-machine)
# -----------------------------------------------------------------------------
clone_if_missing() {
    local url="$1" dst="$2"
    if [[ -d "$dst/.git" ]]; then
        skip "clone: $dst"
    else
        log "Cloning $url -> $dst"
        git clone "$url" "$dst"
    fi
}
clone_if_missing https://github.com/alacritty/alacritty-theme "$DOTFILES/alacritty/themes"
clone_if_missing https://github.com/tmux-plugins/tpm           "$HOME/.tmux/plugins/tpm"

# Optional: Kinesis Advantage360 Pro ZMK fork (keymap lives in adv360-keymap/).
# Uncomment if you build firmware on this machine.
# clone_if_missing https://github.com/ntdkhang/Adv360-Pro-ZMK "$DOTFILES/Adv360-Pro-ZMK"

# -----------------------------------------------------------------------------
# 10. Neovim plugin bootstrap (lazy.nvim auto-installs on first launch)
# -----------------------------------------------------------------------------
if have nvim; then
    log "Bootstrapping Neovim plugins (lazy sync, headless)"
    nvim --headless "+Lazy! sync" +qa || warn "nvim plugin sync failed (run :Lazy sync manually)"
fi

# -----------------------------------------------------------------------------
# 11. tmux plugins (tpm)
# -----------------------------------------------------------------------------
if [[ -x "$HOME/.tmux/plugins/tpm/bin/install_plugins" ]]; then
    log "Installing tmux plugins via tpm"
    "$HOME/.tmux/plugins/tpm/bin/install_plugins" || warn "tpm install_plugins failed"
fi

# -----------------------------------------------------------------------------
# 12. Start window-manager services
# -----------------------------------------------------------------------------
log "Starting yabai, skhd, sketchybar (grant Accessibility/ScreenRecording perms when prompted)"
brew services start yabai      || warn "yabai service failed to start"
brew services start skhd       || warn "skhd service failed to start"
brew services start sketchybar || warn "sketchybar service failed to start"

cat <<'EOF'

============================================================
Setup complete. Manual follow-ups:
  1. Grant Accessibility + ScreenRecording perms to yabai/skhd/Karabiner in System Settings > Privacy & Security.
  2. Open Karabiner-Elements once so it picks up ~/.config/karabiner/karabiner.json.
  3. Sign in: gh auth login, then `gh auth token` powers GITHUB_PERSONAL_ACCESS_TOKEN in .zshrc.
  4. (Optional) Load a Node version: `nvm install --lts`.
  5. Restart the shell: `exec zsh`.
============================================================
EOF
