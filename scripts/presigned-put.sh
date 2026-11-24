#!/bin/sh
# Read a private Uploader response via stdin and send only reviewed headers.
set -eu
response=$(cat)
intent_header=x-amz-meta-x-amzn-meta-upload-intent-id
url=$(printf '%s' "$response" | jq -er '.url | strings | select(test("^https://[^/@?#[:space:]]+(/[^#[:space:]]*)?$"))') ||
  { printf '%s\n' "Destino de upload inválido." >&2; exit 1; }
content_type=$2
set -- "$1"
if printf '%s' "$response" | jq -e 'has("upload_headers")' >/dev/null; then
  content_type=$(printf '%s' "$response" | jq -er --arg key "$intent_header" '
    .upload_headers | select(type=="object" and (keys|sort)==(["Content-Type",$key]|sort)) |
    .["Content-Type"] | strings | select(test("^[^\\r\\n]+$"))') ||
    { printf '%s\n' "Headers assinados de upload inválidos." >&2; exit 1; }
  intent=$(printf '%s' "$response" | jq -er --arg key "$intent_header" '
    .upload_headers[$key] | strings | select(test("^[a-f0-9]{32}$"))') || exit 1
  signed=$(printf '%s' "$url" | sed -n 's/.*[?&]X-Amz-SignedHeaders=\([^&]*\).*/\1/p')
  signed=$(printf '%s' "$signed" | sed 's/%3[Bb]/;/g')
  case ";$signed;" in *";$intent_header;"*) ;; *) exit 1 ;; esac
  case ";$signed;" in *";content-type;"*) ;; *) exit 1 ;; esac
  set -- "$1" --header "$intent_header: $intent"
fi
archive=$1
shift
status=$(curl --silent --proto '=https' --request PUT --output /dev/null --write-out '%{http_code}' \
  --header "Content-Type: $content_type" "$@" --upload-file "$archive" --url "$url") ||
  { printf '%s\n' "Falha de transporte no upload." >&2; exit 1; }
case "$status" in
  2[0-9][0-9]) ;;
  403) printf '%s\n' "Upload recusado ou expirado (HTTP 403). Solicite outra autorização." >&2; exit 1 ;;
  *) printf '%s\n' "Falha no upload (HTTP $status)." >&2; exit 1 ;;
esac
