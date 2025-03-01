#!/bin/bash

PBXPROJ_FILE="MusicPlayer.xcodeproj/project.pbxproj"

extract_version_and_build() {
    if [ -f "$PBXPROJ_FILE" ]; then
        CURRENT_VERSION=$(grep -m 1 "MARKETING_VERSION" "$PBXPROJ_FILE" | sed -E 's/.* = (.*);/\1/')
        CURRENT_BUILD_NUMBER=$(grep -m 1 "CURRENT_PROJECT_VERSION" "$PBXPROJ_FILE" | sed -E 's/.* = (.*);/\1/')
        echo "Current version: $CURRENT_VERSION"
        echo "Current build number: $CURRENT_BUILD_NUMBER"
    else
        echo "Error: $PBXPROJ_FILE not found."
        exit 1
    fi
}

update_version_and_build() {
    echo "Enter the new version (e.g., 1.2.3):"
    read -r NEW_VERSION
    echo "Enter the new build number:"
    read -r NEW_BUILD_NUMBER

    sed -i '' -E "s/(MARKETING_VERSION = ).*;/\1$NEW_VERSION;/" "$PBXPROJ_FILE"

    sed -i '' -E "s/(CURRENT_PROJECT_VERSION = ).*;/\1$NEW_BUILD_NUMBER;/" "$PBXPROJ_FILE"

    echo "Updated version to $NEW_VERSION and build number to $NEW_BUILD_NUMBER in $PBXPROJ_FILE."
}

commit_and_push() {
    git add "$PBXPROJ_FILE"
    git commit -m "Build version $NEW_VERSION ($NEW_BUILD_NUMBER)"
    git push origin main
}

create_and_push_tag() {
    TAG_NAME="build/v$NEW_VERSION/$NEW_BUILD_NUMBER"
    git tag "$TAG_NAME"
    git push origin "$TAG_NAME"
    echo "Tag $TAG_NAME created and pushed."
}

extract_version_and_build
update_version_and_build
commit_and_push
create_and_push_tag

echo "Build tag creation and push completed successfully."