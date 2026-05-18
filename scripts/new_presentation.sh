#!/usr/bin/env bash
# Usage: ./scripts/new_presentation.sh <directory-name> [--type Talk|Demo|Workshop]
# Creates a new presentation directory with the shared-theme structure.
set -euo pipefail

PRES="${1:-}"
TYPE="${2:-Talk}"

if [[ -z "$PRES" ]]; then
  echo "Usage: $0 <directory-name> [Talk|Demo|Workshop]"
  exit 1
fi
if [[ -d "$PRES" ]]; then
  echo "Error: '$PRES' already exists"
  exit 1
fi

# Slugify the name for display (replace hyphens/underscores with spaces, title-case)
TITLE=$(echo "$PRES" | sed 's/[-_]/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1')

mkdir -p "$PRES/_slides" "$PRES/graphics"

cat > "$PRES/_config.yml" <<EOF
title: "${TITLE}"
description: "A short description of this presentation"
type: ${TYPE}
author: Samuel Farrens
EOF

cat > "$PRES/_slides/slide_01.md" <<EOF
---
layout: title
title: "${TITLE}"
subtitle: "Subtitle"
event_date: "Date"
location: "Location"
---
EOF

cat > "$PRES/_slides/slide_02.md" <<'EOF'
---
layout: slide
title: "Slide Title"
---

Content goes here.

+ Fragment item 1
+ Fragment item 2
EOF

echo "Created '$PRES/' with the following structure:"
find "$PRES" -type f | sort
echo ""
echo "Next steps:"
echo "  1. Edit $PRES/_config.yml"
echo "  2. Edit slides in $PRES/_slides/"
echo "  3. Add figures to $PRES/graphics/"
echo "  4. Run: ./scripts/serve.sh $PRES"
