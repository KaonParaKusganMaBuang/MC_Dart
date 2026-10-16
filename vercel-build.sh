#!/usr/bin/env bash
set -euo pipefail

export FLUTTER_ROOT="${FLUTTER_ROOT:-$HOME/flutter}"
export PATH="$FLUTTER_ROOT/bin:$PATH"

if [ ! -d "$FLUTTER_ROOT/bin" ]; then
  git clone https://github.com/flutter/flutter.git -b stable --depth 1 "$FLUTTER_ROOT"
fi

flutter --version
flutter config --enable-web
flutter pub get
flutter build web --release
