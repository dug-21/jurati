#!/usr/bin/env bash
set -euo pipefail

# Make nvm-installed node/npm available in this non-login shell
export NVM_DIR=/usr/local/share/nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Node deps
# npm install

# Build toolchain + JSON tooling: native pip/npm builds, compiled POCs, evidence extraction
sudo apt-get update
sudo apt-get install -y --no-install-recommends build-essential jq
sudo rm -rf /var/lib/apt/lists/*

# yq (mikefarah) — YAML evidence parsing
YQ_VERSION="v4.44.3"
sudo curl -fsSL "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_$(dpkg --print-architecture)" \
  -o /usr/local/bin/yq
sudo chmod +x /usr/local/bin/yq

# uv — fast, disposable Python envs per POC
curl -LsSf https://astral.sh/uv/install.sh | sh

# Claude CLI
curl -fsSL https://claude.ai/install.sh | bash

# Convenience aliases
if ! grep -qF 'alias dsp=' ~/.bashrc; then
  {
    echo 'export PATH="$HOME/.local/bin:$PATH"'
    echo "alias dsp='claude --dangerously-skip-permissions'"
    echo "alias dspc='claude --dangerously-skip-permissions -c'"
  } >> ~/.bashrc
fi
