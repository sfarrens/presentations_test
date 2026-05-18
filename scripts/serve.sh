#!/usr/bin/env bash
# Usage: ./serve.sh <presentation-name>
# Serves a presentation locally. Presentations with their own _layouts/ are
# served as-is; others are assembled from _theme/ and served from .build/.
set -euo pipefail

PRES="${1:-}"
if [[ -z "$PRES" ]]; then
  echo "Usage: $0 <presentation-name>"
  exit 1
fi
if [[ ! -d "$PRES" ]]; then
  echo "Error: directory '$PRES' not found"
  exit 1
fi

# Presentations with their own theme
if [[ -d "$PRES/_layouts" ]]; then
  echo "Serving '$PRES' with its own theme..."
  bundle exec jekyll serve \
    --source "$PRES" \
    --destination "_site/$PRES" \
    --baseurl "" \
    --livereload --watch
  exit
fi

# Ensure reveal.js is available (cloned once, reused across presentations)
if [[ ! -d "reveal.js" ]]; then
  echo "Cloning reveal.js 3.7.0..."
  git clone --quiet --depth 1 --branch 3.7.0 https://github.com/hakimel/reveal.js.git reveal.js
fi

# Shared-theme presentation — assemble into .build/<name>/
echo "Serving '$PRES' with shared theme..."

BUILD=".build/$PRES"
mkdir -p "$BUILD"

assemble() {
  rsync -a --delete _theme/ "$BUILD/"
  [[ -d "$PRES/_slides" ]]  && rsync -a "$PRES/_slides/"  "$BUILD/_slides/"  || true
  [[ -d "$PRES/graphics" ]] && rsync -a "$PRES/graphics/" "$BUILD/graphics/" || true
  if [[ -d "reveal.js" ]]; then
    rsync -a --delete reveal.js/ "$BUILD/reveal.js/"
  fi
}

assemble

# Background watcher: re-sync source changes into the build dir every second
# so Jekyll's own --watch picks them up.
(
  while true; do
    sleep 1
    rsync -aq --update _theme/ "$BUILD/" 2>/dev/null || true
    [[ -d "$PRES/_slides" ]]  && rsync -aq --update "$PRES/_slides/"  "$BUILD/_slides/"  2>/dev/null || true
    [[ -d "$PRES/graphics" ]] && rsync -aq --update "$PRES/graphics/" "$BUILD/graphics/" 2>/dev/null || true
  done
) &
WATCHER=$!
trap "kill $WATCHER 2>/dev/null; exit" INT TERM EXIT

bundle exec jekyll serve \
  --source "$BUILD" \
  --destination "_site/$PRES" \
  --baseurl "" \
  --config "_base_config.yml,$PRES/_config.yml" \
  --livereload --watch
