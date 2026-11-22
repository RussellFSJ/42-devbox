#!/usr/bin/env bash

set -euo pipefail

NORMINETTE_VERSION="${1:?Pass the Norminette version}"
VENV_DIR="/opt/norminette"

echo "Installing Norminette ${NORMINETTE_VERSION}..."

python3 -m venv "${VENV_DIR}"

"${VENV_DIR}/bin/python" -m pip install \
    --no-cache-dir \
    "norminette==${NORMINETTE_VERSION}"

ln -sf \
    "${VENV_DIR}/bin/norminette" \
    /usr/local/bin/norminette

echo "Installation complete."

python3 --version
norminette --version
