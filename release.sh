#!/bin/bash

# 1. Fetch tags from remote to ensure we have the latest
git fetch --tags

# 2. Get the latest tag, default to v1.0.0 if none exists
LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "v1.0.0")

# 3. Parse version (v1.0.5 -> 1.0.5)
VERSION=${LATEST_TAG#v}
IFS='.' read -r MAJOR MINOR PATCH <<< "$VERSION"

# 4. Increment the patch number
NEW_PATCH=$((PATCH + 1))
NEW_TAG="v$MAJOR.$MINOR.$NEW_PATCH"

echo "Current version: $LATEST_TAG"
echo "Bumping to: $NEW_TAG"

# 5. Create the tag and push to GitHub
git tag -a "$NEW_TAG" -m "Release $NEW_TAG"
git push origin "$NEW_TAG"

echo "Done! GitHub Action will now start building for $NEW_TAG"