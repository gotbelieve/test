#!/bin/bash

# Git 仓库 URL
#REPO_URL="git@github.com:Applied-General-Intelligence-Inc/aginlp.git"
# 激活 Anaconda 环境的命令
CONDA_ENV="aginlp-3.8"
CONDA_PATH="/home/yao/anaconda3"

cd /home/yao/test
BRANCH=master

git fetch --all

LOCAL=$(git log $BRANCH -n 1 --pretty=format:"%H")
REMOTE=$(git log remotes/origin/$BRANCH -n 1 --pretty=format:"%H")

echo $LOCAL
echo $REMOTE
if [ $LOCAL = $REMOTE ]; then
    echo "Up-to-date"
else
    echo "Need update"
   # 拉取最新代码
    echo "Pulling latest changes from GitHub..."
    git pull origin $BRANCH || { echo "Failed to pull changes"; exit 1; }
    # 激活 Anaconda 环境并执行部署
    echo "Activating Anaconda environment..."
    source $CONDA_PATH/bin/activate
    conda activate $CONDA_ENV
    sh    /home/yao/test/run.sh
    echo "test update success"
fi