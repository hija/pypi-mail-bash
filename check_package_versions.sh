#!/bin/bash

set -e

VERSION_FILE_PATH="versions.json"

# Function to get the latest version of a package from PyPI
get_latest_package_version() {
  PACKAGE_NAME=$1
  curl -s "https://pypi.org/pypi/${PACKAGE_NAME}/json" | jq -r '.info.version'
}

# Function to read the last versions from the versions file
read_last_versions() {
  if [ -f "$VERSION_FILE_PATH" ]; then
    cat "$VERSION_FILE_PATH"
  else
    echo '{"versions":{}}'
  fi
}

# Function to write versions to the versions file
write_versions() {
  echo "$1" | jq '.' > "$VERSION_FILE_PATH"
}

# Function to send an email
send_email() {
  SUBJECT=$1
  BODY=$2
  echo "$BODY" | mail -s "$SUBJECT" -r "$EMAIL_USER" "$RECIPIENT_EMAIL"
}

# Main script
VERSION_STORE=$(read_last_versions)
VERSION_STORE=$(echo "$VERSION_STORE" | jq '.')

CHANGES=()
UPDATES=()

PACKAGE_NAMES=$(echo "$VERSION_STORE" | jq -r '.versions | keys[]')

for PACKAGE_NAME in $PACKAGE_NAMES; do
  LATEST_VERSION=$(get_latest_package_version "$PACKAGE_NAME")
  OLD_VERSION=$(echo "$VERSION_STORE" | jq -r ".versions[\"$PACKAGE_NAME\"]")

  if [ "$OLD_VERSION" != "$LATEST_VERSION" ]; then
    echo "Version for package '$PACKAGE_NAME' has changed! Old: $OLD_VERSION, New: $LATEST_VERSION"
    CHANGES+=("Package '$PACKAGE_NAME' has been updated from $OLD_VERSION to $LATEST_VERSION.")
    UPDATES+=("{\"package_name\":\"$PACKAGE_NAME\",\"latest_version\":\"$LATEST_VERSION\"}")
  else
    echo "Version for package '$PACKAGE_NAME' has not changed. Current version: $LATEST_VERSION"
  fi
done

for UPDATE in "${UPDATES[@]}"; do
  PACKAGE_NAME=$(echo "$UPDATE" | jq -r '.package_name')
  LATEST_VERSION=$(echo "$UPDATE" | jq -r '.latest_version')
  VERSION_STORE=$(echo "$VERSION_STORE" | jq ".versions[\"$PACKAGE_NAME\"]=\"$LATEST_VERSION\"")
done

write_versions "$VERSION_STORE"

if [ ${#CHANGES[@]} -ne 0 ]; then
  SUBJECT="Package Version Updates"
  BODY=$(printf "%s\n" "${CHANGES[@]}")
  send_email "$SUBJECT" "$BODY"
fi
