#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <package-list-file>"
  exit 1
fi

file=$1

while read -r package; do
  # Skip empty lines and comments
  if [[ -z "$package" || "$package" =~ ^# ]]; then
    continue
  fi

  status_code=$(curl -s -o /dev/null -w "%{http_code}" "https://registry.npmjs.org/$package")

  if [[ "$status_code" == "404" ]]; then
    echo "$package"
  fi
done < "$file"
