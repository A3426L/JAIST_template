#!/bin/bash
# ---------------------------------------------------------
# KAGAYAKI 同期・成果物取得スクリプト
# ---------------------------------------------------------

# 同じ scripts フォルダ内の .env から設定を読み込む
ENV_FILE="$(dirname "$0")/../.env"
if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
fi

# デフォルト設定
REMOTE_HOST="${KAGAYAKI_HOST:-kagayaki}"

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

echo ">>> KAGAYAKIからファイルをローカルに同期（Pull）しています... [${REMOTE_DIR}]"

# --delete を追加し、リモートにないファイルはローカルからも削除する
rsync -avzu --delete ${DRY_RUN_FLAG} "${EXCLUDES[@]}" "${REMOTE_HOST}:${REMOTE_DIR}/" "$(dirname "$0")/../../"

echo ">>> 完了しました。"
