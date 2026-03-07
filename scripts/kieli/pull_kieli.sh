#!/bin/bash
# ---------------------------------------------------------
# KIELI (Ubuntu) 同期・成果物取得スクリプト
# ---------------------------------------------------------

# 同じ scripts フォルダ内の .env から設定を読み込む
ENV_FILE="$(dirname "$0")/../.env"
if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
fi

# デフォルト設定
REMOTE_HOST="${KIELI_HOST:-kieli}"

# プロジェクトのディレクトリ名を自動取得
PROJECT_NAME=$(basename "$(cd "$(dirname "$0")/../.." && pwd)")
REMOTE_DIR="~/${PROJECT_NAME}"

# 同期から除外
EXCLUDES=("--exclude=.git" "--exclude=__pycache__" "--exclude=.venv" "--exclude=.vscode" "--exclude=.DS_Store")

set -e

# 引数に --dry-run が含まれているかチェック
DRY_RUN_FLAG=""
if [[ "$*" == *"--dry-run"* ]]; then
    DRY_RUN_FLAG="--dry-run"
    echo "!!! DRY-RUN MODE: 実際には同期されません。同期対象の確認のみ行います。 !!!"
fi

echo ">>> KIELI (Ubuntu) からファイルをローカルに同期（Pull）しています... [${REMOTE_DIR}]"

# --delete を追加し、リモートにないファイルはローカルからも削除する
# -u (--update) と --delete は併用可能ですが、--delete の方が強力です
rsync -avzu --delete ${DRY_RUN_FLAG} "${EXCLUDES[@]}" "${REMOTE_HOST}:${REMOTE_DIR}/" "$(dirname "$0")/../../"

echo ">>> 完了しました。"
