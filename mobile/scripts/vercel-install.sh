#!/usr/bin/env bash
# Instala o Flutter no ambiente de build da Vercel (que não vem com o SDK).
# Usado pelo "installCommand" do vercel.json.
set -euo pipefail

FLUTTER_VERSION="3.41.4"

if [ ! -x flutter/bin/flutter ]; then
  git clone https://github.com/flutter/flutter.git --depth 1 --branch "$FLUTTER_VERSION" flutter
fi

flutter/bin/flutter config --no-analytics --enable-web
flutter/bin/flutter pub get
