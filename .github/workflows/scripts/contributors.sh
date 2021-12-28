#!/bin/bash
declare -a contributors=()

while read -r repo; do 
    echo "Repository: $repo"
    while read -r contributor; do
        echo "- Contributor: $contributor"
        contributors+=($contributor)
    done <<<$(curl -s -u $GITHUB_TOKEN:x-oauth-basic "https://api.github.com/repos/Project-Embr/$repo/contributors" | jq -r '.[].login')
done <<<$(curl -s -u $GITHUB_TOKEN:x-oauth-basic "https://api.github.com/orgs/Project-Embr/repos" | jq -r '.[].name')

uniques=($(echo "${contributors[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

current="$(curl -s -L https://github.com/Project-Embr/.github/releases/download/data/contributors.txt | jq -r '.message')"

if test "${#uniques[@]}" == "$current"; then
  echo "::set-output name=update::false"
  exit
else
  echo "::set-output name=update::true"
fi

echo "{
  \"schemaVersion\": 1,
  \"label\": \"Contributors\",
  \"message\": \"${#uniques[@]}\",
  \"color\": \"orange\"
}" > contributors.txt
