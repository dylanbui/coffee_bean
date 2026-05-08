#!/bin/bash
set -e

# --- 1. Default Configuration ---
ENV="dev"
OS="android"
CLEAN_BUILD=false
SHOULD_NOTIFY=false
STATUS_ANDROID="skipped"
STATUS_IOS="skipped"
LARK_WEBHOOK="https://open.larksuite.com/open-apis/bot/v2/hook/60654dca-af10-482b-a075-487f1196a87e"


# Automatically determine the Project Root
# Script is located in 'scripts/', so root is the parent directory.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Change to project root to execute flutter/git commands
cd "$PROJECT_ROOT"

# --- 2. Parse Arguments ---
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -e|--env) ENV="$2"; shift ;;
        -o|--os) OS="$2"; shift ;;
        -c|--clean) CLEAN_BUILD=true ;;
        -n|--notify) SHOULD_NOTIFY=true ;; # Only enable if -n or --notify flag is present
    esac
    shift
done

ENV=${ENV:-dev}
OS=${OS:-all}

# --- GLOBAL CONFIGURATION ---
RELEASE_NOTE_FILE="release-notes.txt"
MANUAL_NOTE_FILE="scripts/manual_notes.txt"

# --- UTILITY FUNCTIONS ---

# 1. Function to initialize Header for Release Notes
prepare_header() {
    local branch=$(git branch --show-current)
    local full_version=$(grep 'version:' pubspec.yaml | sed 's/version: //' | xargs)
    local version_name=$(echo $full_version | cut -d'+' -f1)
    local build_number=$(echo $full_version | cut -d'+' -f2)

    echo "🚀 COFFEE BEAN BUILD INFO" > $RELEASE_NOTE_FILE
    echo "Branch: $branch | Version: $version_name | Build: $build_number" >> $RELEASE_NOTE_FILE
    echo "Date: $(date '+%Y-%m-%d %H:%M')" >> $RELEASE_NOTE_FILE
    echo "--------------------------------" >> $RELEASE_NOTE_FILE
}

flutter_clean_and_build() {
    echo "🧹 Executing flutter clean..."
    flutter clean
    echo "📦 Executing flutter pub get..."
    flutter pub get
    # Only run build_runner if your project uses code generation (like Bloc or RIBs)
    echo "🛠 Executing build_runner..."
    flutter packages pub run build_runner build --delete-conflicting-outputs
}

# 2. Function to get manual notes from file (Manual way)
add_manual_notes() {
    if [ -s "$MANUAL_NOTE_FILE" ]; then
        echo -e "📝 MANUAL NOTES:" >> $RELEASE_NOTE_FILE
        cat $MANUAL_NOTE_FILE >> $RELEASE_NOTE_FILE
        # Optional: Clear content after reading to avoid duplication next time
        # > $MANUAL_NOTE_FILE
    fi
}

# 3. Function to get last N commits (Method A)
add_git_recent_commits() {
    local num_commits=${1:-5} # Default to 5 if no parameter passed
    echo -e "\n🛠 RECENT CHANGES (Last $num_commits):" >> $RELEASE_NOTE_FILE
    git log -n $num_commits --pretty=format:"- %s (%an)" >> $RELEASE_NOTE_FILE
    echo "" >> $RELEASE_NOTE_FILE
}

# 4. Function to get changes since last Tag (Method B)
add_git_changes_since_tag() {
    local latest_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "")

    if [ -z "$latest_tag" ]; then
        add_git_recent_commits 10
    else
        echo -e "\n🆕 CHANGES SINCE $latest_tag:" >> $RELEASE_NOTE_FILE
        git log $latest_tag..HEAD --pretty=format:"- %s (%an)" >> $RELEASE_NOTE_FILE
        echo "" >> $RELEASE_NOTE_FILE
    fi
}

# --- GRADLE CLEANUP FUNCTION ---
# This function kills running Gradle Daemons to free Metaspace
# and ensure new RAM configurations in gradle.properties are applied.
check_and_clean_android() {
    # Check if CLEAN_BUILD flag is on OR running on Jenkins
    if [ "$CLEAN_BUILD" == "true" ] || [ -n "$JENKINS_HOME" ]; then
        echo "🧹 Cleaning Gradle Daemon to load new configuration..."

        # Check android directory before entering
        if [ -d "android" ]; then
            cd android
            # Use || true so script doesn't stop if stop command fails (e.g., no daemon running)
            ./gradlew --stop || echo "⚠️ No active Daemon found."
            cd ..
        else
            echo "❌ Android directory not found for Gradle cleanup."
        fi
    else
        echo "⏭️ Skipping Gradle cleanup (Fast build mode)."
    fi
}

# --- IOS CLEANUP FUNCTION ---
# Clean DerivedData and reinstall Pods to ensure a clean build environment.
check_and_clean_ios() {
    if [ "$CLEAN_BUILD" == "true" ] || [ -n "$JENKINS_HOME" ]; then
        echo "🍎 Cleaning iOS environment (Hybrid Clean)..."

        if [ -d "ios" ]; then
            cd ios

            # 1. Clean DerivedData and Build Cache
            xcodebuild clean -workspace Runner.xcworkspace -scheme $ENV || echo "⚠️ Skip xcodebuild clean."

            # 2. Check if using CocoaPods
            if [ -f "Podfile" ]; then
                echo "📦 Cleaning CocoaPods..."
                rm -rf Pods
                rm -rf Podfile.lock
                pod install || pod install --repo-update
            fi

            # 3. Check if using Swift Package Manager (SPM)
            # SPM stores cache in DerivedData, but sometimes manual package reset is needed
            if [ -d ".swiftpm" ] || [ -f "Package.swift" ]; then
                echo "🚀 Cleaning Swift Package Manager Cache..."
                xcodebuild -resolvePackageDependencies
            fi

            cd ..
        else
            echo "❌ iOS directory not found."
        fi
    else
        echo "⏭️ Skipping iOS cleanup."
    fi
}

# --- MAIN EXECUTION ---
echo "---------------------------------------------------------------------------"
echo "🚀 ---- START BUILD - COFFEE BEAN FLUTTER PROJECT - make by TMLABS's Team"
echo "---------------------------------------------------------------------------"
echo ""
# --- 1. Update Code and Build Info ---
BRANCH_NAME=$(git branch --show-current)
echo "🔄 Updating code from Git Branch: $BRANCH_NAME"
# git pull # Dont use

# Prepare basic info
prepare_header

# Choose note-taking method (comment/uncomment as needed)
add_manual_notes           # Always prioritize manual notes if available
# add_git_changes_since_tag  # Automatically get changes since previous release

echo "" >> $RELEASE_NOTE_FILE
echo "--------------------------------" >> $RELEASE_NOTE_FILE

# --- 2. Clean environment (Important for Jenkins) needs --clean option
if [ "$OS" == "android" ] || [ "$OS" == "all" ]; then
    check_and_clean_android
fi

if [ "$OS" == "ios" ] || [ "$OS" == "all" ]; then
    check_and_clean_ios
fi

# --- 3. Build Flutter ---
# flutter_clean_and_build

# Save a separate release notes log by environment (optional)
# cp release-notes.txt "${ENV}.release-notes.txt"

# --- 4. Execute Fastlane ---
build_android() {
    echo "🤖 Building Android for environment $ENV..."
    # Ensure release-notes.txt is available in android folder for Fastlane to read via '../'
    cp release-notes.txt android/release-notes.txt
    cd android
#    bundle exec fastlane deploy env:$ENV notify:$SHOULD_NOTIFY
    # Run fastlane but do NOT let it send Lark notification internally
    if bundle exec fastlane deploy env:$ENV notify:false; then
        STATUS_ANDROID="success"
    else
        STATUS_ANDROID="failed"
    fi
    cd ..
}

build_ios() {
    echo "🍏 Building iOS for environment $ENV..."
    cp release-notes.txt ios/release-notes.txt
    cd ios
#    bundle exec fastlane deploy env:$ENV notify:$SHOULD_NOTIFY
    if bundle exec fastlane deploy env:$ENV notify:false; then
        STATUS_IOS="success"
    else
        STATUS_IOS="failed"
    fi
    cd ..
}

# Dispatch build based on OS parameter
if [ "$OS" == "android" ]; then
    build_android
elif [ "$OS" == "ios" ]; then
    build_ios
elif [ "$OS" == "all" ]; then
    build_android
    build_ios
else
    echo "Invalid OS (choose android, ios, or all)."
    exit 1
fi

# --- 4. Send consolidated notification (Send once only) ---
if [ "$SHOULD_NOTIFY" == "true" ] || [ "$STATUS_ANDROID" == "failed" ] || [ "$STATUS_IOS" == "failed" ]; then
    echo "🔔 Sending consolidated notification to Lark..."
    ruby scripts/send_lark.rb "$ENV" "$STATUS_ANDROID" "$STATUS_IOS" "release-notes.txt" "$LARK_WEBHOOK"
fi

echo "✅ Build process completed successfully!"

# For User
# Set permission:
# chmod +x scripts/build_app.sh
# Build Android (Dev environment):
# ./scripts/build_app.sh --env dev --os android --notify
# Build Android (UAT environment):
# ./scripts/build_app.sh --env uat --os android --notify
# Build Android (Production environment):
# ./scripts/build_app.sh --env production --os android --notify
# Build both OS (Production environment):
# ./scripts/build_app.sh --env production --os all --notify
