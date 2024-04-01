#!/usr/bin/env bash

set -e

pack_scheme=$1
pack_configuration=$2

# Archive
# The same as `Xcode -> Product -> Archive`
archive_path=./ios/build/archive.xcarchive

mkdir -p ios/build
rm -rf $archive_path

# Since RN-0.60，Pods is required and we can only use workspace to archive app
# Remember: .xcodeproj dirtory is useless once .xcworkspace dirtory exists
set +e
workspace=$(ls ios | grep '.xcworkspace')
project=$(ls ios | grep '.xcodeproj')
set -e

if [ -n "$workspace" ]
then
  echo "Find workspace: $workspace"
  project_name=$(echo $workspace | cut -d. -f1)
  [ -z "$pack_scheme" ] && pack_scheme=$project_name

  xcodebuild clean \
    -workspace "./ios/$workspace" \
    -scheme "$pack_scheme"

  xcodebuild archive \
    -workspace "./ios/$workspace" \
    -scheme "$pack_scheme" \
    -configuration "$pack_configuration" \
    -archivePath "$archive_path" \
    -allowProvisioningUpdates \
    -showBuildTimingSummary
elif [ -n "$project" ]
then
  echo "Find xcodeproj: $project"
  project_name=$(echo $project | cut -d. -f1)
  [ -z "$pack_scheme" ] && pack_scheme=$project_name

  xcodebuild clean \
    -project "./ios/$project" \
    -scheme "$pack_scheme"

  xcodebuild archive \
    -project "./ios/$project" \
    -scheme "$pack_scheme" \
    -configuration "$pack_configuration" \
    -archivePath "$archive_path" \
    -allowProvisioningUpdates \
    -showBuildTimingSummary
else
  echo "\n\033[31mNeither workspace nor xcodeproj is found, it may be invalid ios project.\033[0m\n"
  exit 1
fi
