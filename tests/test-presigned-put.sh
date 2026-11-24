#!/bin/sh
set -eu
helper=$1
tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' EXIT
export MOCK_ARGS="$tmp/args"
cat > "$tmp/curl" <<'MOCK'
#!/bin/sh
printf '%s\n' "$@" > "$MOCK_ARGS"
printf '%s' "${MOCK_STATUS:-200}"
MOCK
chmod 700 "$tmp/curl"
export PATH="$tmp:$PATH"
ref=x-amz-meta-x-amzn-meta-upload-intent-id
intent=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
url="https://bucket.s3.sa-east-1.amazonaws.com/key?X-Amz-SignedHeaders=content-type%3Bhost%3B$ref"
response=$(jq -nc --arg url "$url" --arg ref "$ref" --arg intent "$intent" '{url:$url,upload_headers:{"Content-Type":"application/x-tar",($ref):$intent}}')
printf '%s' "$response" | sh "$helper" file.tar application/zip
grep -Fx "Content-Type: application/x-tar" "$MOCK_ARGS"
grep -Fx "$ref: $intent" "$MOCK_ARGS"
! grep -i 'authorization:' "$MOCK_ARGS"
printf '%s' '{"url":"https://bucket.example/file"}' | sh "$helper" file.zip application/zip
grep -Fx "Content-Type: application/zip" "$MOCK_ARGS"
! grep -i 'meta-x-amzn' "$MOCK_ARGS"
if printf '%s' "$response" | MOCK_STATUS=403 sh "$helper" file.tar application/zip 2>"$tmp/error"; then exit 1; fi
grep -Fq 'HTTP 403' "$tmp/error"
if printf '%s' "$response" | jq '.upload_headers.Authorization="synthetic"' | sh "$helper" file.tar application/zip; then exit 1; fi
printf '%s\n' '4 presigned upload contract scenarios passed'
