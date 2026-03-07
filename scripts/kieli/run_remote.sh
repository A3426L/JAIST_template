#!/bin/bash

# ------------------------------------------------
CMD="python3 test.py"
LOG="log/output.log"
# ------------------------------------------------

NOTIFY="$(dirname "$0")/notify.sh"

# ログディレクトリを事前に作成
mkdir -p log

# notify.sh に丸投げしてバックグラウンドへ
chmod +x "${NOTIFY}"
nohup "${NOTIFY}" "${CMD}" "${LOG}" > /dev/null 2>&1 &

echo ">>> リモートで '${CMD}' の実行を開始しました。"
echo ">>> ログは ${LOG} に記録され、終了時に通知が飛びます。"
