#!/bin/bash
set -exu
#set -o pipefail

# Whether python3 has been installed on the system
PYTHON_INSTALLED=true

# If Python has been installed, then we need to know whether Python is provided
# by the system, or you have already installed Python under your HOME.
SYSTEM_PYTHON=true

# If SYSTEM_PYTHON is false, we need to decide whether to install
# Anaconda (INSTALL_ANACONDA=true) or Miniconda (INSTALL_ANACONDA=false)
INSTALL_ANACONDA=false

# Whether to add the path of the installed executables to system PATH
ADD_TO_SYSTEM_PATH=true

# select which shell we are using
USE_ZSH_SHELL=true
USE_BASH_SHELL=false

if [[ ! -d "$HOME/packages/" ]]; then
    mkdir -p "$HOME/packages/"
fi

if [[ ! -d "$HOME/tools/" ]]; then
    mkdir -p "$HOME/tools/"
fi

#######################################################################
#                    Anaconda or miniconda install                    #
#######################################################################
if [[ "$INSTALL_ANACONDA" = true ]]; then
    CONDA_DIR=$HOME/tools/anaconda
    CONDA_NAME=Anaconda.sh
    CONDA_LINK="https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-2021.11-Linux-x86_64.sh"
else
    CONDA_DIR=$HOME/tools/miniconda
    CONDA_NAME=Miniconda.sh
    CONDA_LINK="https://repo.anaconda.com/miniconda/Miniconda3-py310_22.11.1-1-Linux-x86_64.sh"
fi

if [[ ! "$PYTHON_INSTALLED" = true ]]; then
    echo "Installing Python in user HOME"

    SYSTEM_PYTHON=false

    echo "Downloading and installing conda"

    if [[ ! -f "$HOME/packages/$CONDA_NAME" ]]; then
        curl -Lo "$HOME/packages/$CONDA_NAME" $CONDA_LINK
    fi

    # Install conda silently
    if [[ -d $CONDA_DIR ]]; then
        rm -rf "$CONDA_DIR"
    fi
    bash "$HOME/packages/$CONDA_NAME" -b -p "$CONDA_DIR"

    # Setting up environment variables
    if [[ "$ADD_TO_SYSTEM_PATH" = true ]] && [[ "$USE_BASH_SHELL" = true ]]; then
        echo "export PATH=\"$CONDA_DIR/bin:\$PATH\"" >> "$HOME/.bash_profile"
    fi
else
    echo "Python is already installed. Skip installing it."
fi

# Install some Python packages used by Nvim plugins.
echo "Installing Python packages"
declare -a PY_PACKAGES=("pynvim" "python-lsp-server[all]" "black" "vim-vint" "pyls-isort" "pylsp-mypy")

if [[ "$SYSTEM_PYTHON" = true ]]; then
    echo "Using system Python to install $(PY_PACKAGES)"

    # If we use system Python, we need to install these Python packages under
    # user HOME, since we do not have permissions to install them under system
    # directories.
    for p in "${PY_PACKAGES[@]}"; do
        pip install --user "$p"
    done
else
    echo "Using custom Python to install $(PY_PACKAGES)"
    for p in "${PY_PACKAGES[@]}"; do
        "$CONDA_DIR/bin/pip" install "$p"
    done
fi
