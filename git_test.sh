#!/bin/bash
# 项目所在目录
PROJECT_DIR="/home/yao/test"

# Git 仓库 URL
REPO_URL="git@github.com:gotbelieve/test.git"

# 激活 Anaconda 环境的命令
CONDA_ENV="aginlp-3.8"
CONDA_PATH="/home/yao/anaconda3"

# 切换到项目目录
cd $PROJECT_DIR || { echo "Failed to change directory to $PROJECT_DIR"; exit 1; }

# 获取当前分支
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# 检查远程分支是否存在
REMOTE_BRANCH=$(git ls-remote --heads $REPO_URL $CURRENT_BRANCH)

if [ -z "$REMOTE_BRANCH" ]; then
    echo "Remote branch '$CURRENT_BRANCH' does not exist. Fetching and deploying..."

    # 保存本地未提交的修改
    echo "Stashing local changes..."
    git stash

    # 拉取最新代码
    echo "Pulling latest changes from GitHub..."
    git pull $REPO_URL $CURRENT_BRANCH || { echo "Failed to pull changes"; exit 1; }

    # 恢复本地未提交的修改
    echo "Applying stashed changes..."
    git stash pop || echo "No local changes to apply."

    # 激活 Anaconda 环境并执行部署
    echo "Activating Anaconda environment..."
    source $CONDA_PATH/bin/activate $CONDA_ENV

    # 执行部署命令
    echo "Running deployment steps..."
    sh /home/yao/aginlp/utils/shell_run/run.sh || { echo "Deployment steps failed"; exit 1; }

    echo "Deployment complete!"
else
    echo "Local branch '$CURRENT_BRANCH' exists and is up to date. No pull needed."
fi
