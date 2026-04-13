#!/bin/bash
# ---------------------------------------------------------
# HAKUSAN用 通知マネージャー
# ---------------------------------------------------------

# 自身のディレクトリの一つ上にある .env から設定を読み込む
ENV_FILE="$(dirname "$0")/../.env"
if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
fi

EXIT_CODE=$1
CMD=$2
WEBHOOK_URL="${HAKUSAN_WEBHOOK_URL}"

STATUS="Success"
[ "$EXIT_CODE" -ne 0 ] && STATUS="Failed (Code: $EXIT_CODE)"

MSG="[HAKUSAN Job Notification]
**Status**: ${STATUS}
**Command**: \`${CMD}\`
**Finish Time**: $(date)"

ESCAPED_PAYLOAD=$(echo "${MSG}" | sed ':a;N;$!ba;s/\n/\\n/g')

if [ -n "$WEBHOOK_URL" ]; then
    curl -s -X POST -H 'Content-type: application/json' \
         --data "{\"content\":\"${ESCAPED_PAYLOAD}\"}" \
         "${WEBHOOK_URL}" > /dev/null
    echo ">>> Notification sent from HAKUSAN."
fi
