#!/usr/bin/env bash
# Gera o build web do Atlas One na Vercel.
# Usado pelo "buildCommand" do vercel.json.
set -euo pipefail

# Endereço público da Atlas API (ex.: https://atlas-api.vercel.app),
# definido em Settings > Environment Variables do projeto na Vercel.
if [ -z "${API_BASE_URL:-}" ]; then
  echo "Erro: a variável de ambiente API_BASE_URL não foi definida na Vercel." >&2
  exit 1
fi

flutter/bin/flutter build web --release --dart-define=API_BASE_URL="$API_BASE_URL"
