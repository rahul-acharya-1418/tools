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

  # Use npm view to check if the package exists
  npm view "$package" > /dev/null 2>&1

  if [ $? -ne 0 ]; then
    echo "$package"
  fi
done < "$file"
