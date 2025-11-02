#!/bin/bash
set -e
CURRENT_VERSION=$(cat VERSION 2>/dev/null || echo "0.0.0")
echo "📌 Version actuelle: v$CURRENT_VERSION"
increment_version() {
    local version=$1
    local type=$2
    IFS='.' read -ra V <<< "$version"
    case $type in
        major) echo "$((V[0]+1)).0.0";;
        minor) echo "${V[0]}.$((V[1]+1)).0";;
        patch) echo "${V[0]}.${V[1]}.$((V[2]+1))";;
    esac
}
VERSION_TYPE=$1
DESC=$2
[ -z "$VERSION_TYPE" ] && read -p "Type [patch/minor/major]: " VERSION_TYPE
[ -z "$DESC" ] && read -p "Description: " DESC
NEW_VERSION=$(increment_version "$CURRENT_VERSION" "$VERSION_TYPE")
echo "📦 Nouvelle version: v$NEW_VERSION"
read -p "Confirmer? [y/N]: " CONFIRM
[[ ! $CONFIRM =~ ^[Yy]$ ]] && exit 1
echo "$NEW_VERSION" > VERSION
DATE=$(date +%Y-%m-%d)
awk -v e="## [$NEW_VERSION] - $DATE\n\n### $DESC\n" '/## \[Unreleased\]/{print;while(getline&&$0!~/^## \[/)print;print e;print $0;next}{print}' CHANGELOG.md > CHANGELOG.tmp && mv CHANGELOG.tmp CHANGELOG.md
git add VERSION CHANGELOG.md
git commit -m "Release v$NEW_VERSION: $DESC"
git tag -a "v$NEW_VERSION" -m "Version $NEW_VERSION: $DESC"
echo "✅ Version créée!"
echo "Commandes:"
echo "  git push origin main"
echo "  git push origin v$NEW_VERSION"
