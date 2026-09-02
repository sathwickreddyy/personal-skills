#!/usr/bin/env bash
# Regenerate skills/visual-companion/references/*.png from examples/*.html
# Run after editing any example so the reference images stay in sync.
set -euo pipefail

CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
[ -x "$CHROME" ] || { echo "Chrome not found. Set CHROME=/path/to/chrome" >&2; exit 1; }

DIR="$(cd "$(dirname "$0")/.." && pwd)/skills/visual-companion"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

render() { # <example-name> <light|dark> <output.png>
  sed "s|<title>|<script>document.documentElement.dataset.theme='$2'</script><title>|" \
    "$DIR/examples/$1.html" > "$TMP/$1-$2.html"
  "$CHROME" --headless=new --disable-gpu --hide-scrollbars --force-color-profile=srgb \
    --virtual-time-budget=4000 --window-size=1860,1460 \
    --screenshot="$DIR/references/$3" "file://$TMP/$1-$2.html" 2>/dev/null
  echo "  $3"
}

# One reference image only — every extra PNG costs ~2.5k tokens each time the
# skill is used. The examples/*.html sources cover the rest, read on demand.
echo "rendering →"
render video-upload-architecture light video-upload-architecture.png
