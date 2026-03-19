#!/bin/bash
cd ~/mkdocs-kb || exit 1
git add -A
if ! git diff --cached --quiet; then
    git commit -m "auto: $(date '+%Y-%m-%d %H:%M')"
    git push
fi
