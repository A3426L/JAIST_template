#!/bin/bash
# ---------------------------------------------------------
# KIELI用 実行 ＆ 通知マネージャー
# ---------------------------------------------------------

# 自身のディレクトリの一つ上にある .env から設定を読み込む
ENV_FILE="$(dirname "$0")/../.env"
if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
fi

CMD=$1
LOG=$2
WEBHOOK_URL="${KIELI_WEBHOOK_URL}"

# 1. コマンドの実行
if [ -n "$CMD" ]; then
    echo ">>> Running: ${CMD}"
    eval "${CMD}" > "${LOG}" 2>&1
    EXIT_CODE=$?
else
    echo "Error: No command provided."
    exit 1
fi

# 2. 通知メッセージの作成
STATUS="Success"
[ $EXIT_CODE -ne 0 ] && STATUS="Failed (Code: $EXIT_CODE)"

MSG="[KIELI Job Notification]
**Status**: ${STATUS}
**Command**: \`${CMD}\`
**Finish Time**: $(date)"

ESCAPED_PAYLOAD=$(echo "${MSG}" | sed ':a;N;$!ba;s/\n/\\n/g')

# 3. Discordへ通知
if [ -n "$WEBHOOK_URL" ]; then
    curl -s -X POST -H 'Content-type: application/json' \
         --data "{\"content\":\"${ESCAPED_PAYLOAD}\"}" \
         "${WEBHOOK_URL}" > /dev/null
    echo ">>> Notification sent from KIELI."
fi
