#!/bin/bash

cd ~/dev

for dir in */; do
  if [ -d "$dir/.git" ]; then
    echo "🔍  Checking $dir"
    cd "$dir"

    if [ -n "$(git status --porcelain)" ]; then
      echo "⚠️   Changes found in $dir"
    else
      echo "✅  Clean"
    fi

    cd ..
  fi
done

