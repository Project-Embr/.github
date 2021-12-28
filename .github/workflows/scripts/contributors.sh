#!/bin/bash
declare -a contributors=()

while read -r repo; do 
    echo "Repository: $repo"
    while read -r contributor; do
        echo "- Found $contributor"
        contributors+=($contributor)
    done <<<$(curl -s -u $GITHUB_TOKEN:x-oauth-basic "https://api.github.com/repos/Project-Embr/$repo/contributors" | jq -r '.[].login')
done <<<$(curl -s -u $GITHUB_TOKEN:x-oauth-basic "https://api.github.com/orgs/Project-Embr/repos" | jq -r '.[].name')

uniques=($(for v in "${contributors[@]}"; do echo "$v";done| sort -u))

echo "{
  \"schemaVersion\": 1,
  \"label\": \"Contributors\",
  \"message\": \"${#uniques[@]}\",
  \"color\": \"orange\"
}" > contributors.txt
