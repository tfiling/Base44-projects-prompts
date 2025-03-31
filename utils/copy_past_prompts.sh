#!/bin/bash
# Change to the directory where the script is located
cd "$(dirname "$0")"

TEMP_FILE=$(mktemp)
PREFIX_FILE="prefix.txt"
POSTFIX_FILE="postfix.txt"

# Function to display usage information
show_usage() {
    echo "Usage: $0"
    echo "If no directory path is provided, the current directory will be used."
}

# Check if help is requested
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    show_usage
    exit 0
fi

# Function to select a directory from a target location
select_directory() {
    local TARGET_DIR="$1"

    # Verify the target directory exists
    if [ ! -d "$TARGET_DIR" ]; then
        echo "Error: '$TARGET_DIR' is not a valid directory."
        exit 1
    fi

    # Get all directories in the target location, excluding those that start with a dot
    # and specific directories we want to filter out
    local EXCLUDE_PATTERN='/(node_modules|utils)$'
    mapfile -t DIRECTORIES < <(find "$TARGET_DIR" -maxdepth 1 -type d -not -path "$TARGET_DIR" -not -name ".*" | grep -v -E "$EXCLUDE_PATTERN" | sort)

    # Check if any directories were found
    if [ ${#DIRECTORIES[@]} -eq 0 ]; then
        echo "No directories found in '$TARGET_DIR'."
        exit 0
    fi

    # Display the directories with numbers
    echo "Directories in '$TARGET_DIR':"
    echo "----------------------------"
    for i in "${!DIRECTORIES[@]}"; do
        # Extract the directory name without the path
        DIR_NAME=$(basename "${DIRECTORIES[$i]}")
        echo "[$((i+1))] $DIR_NAME"
    done

    # Prompt user to select a directory
    echo ""
    echo "Enter the number of the directory you want to select (1-${#DIRECTORIES[@]}),"
    echo "or press 'q' to quit:"

    # Read user input
    read -r SELECTION

    # Check if user wants to quit
    if [[ "$SELECTION" == "q" || "$SELECTION" == "Q" ]]; then
        echo "Exiting without selection."
        exit 0
    fi

    # Validate the selection
    if ! [[ "$SELECTION" =~ ^[0-9]+$ ]]; then
        echo "Error: Invalid input. Please enter a number."
        exit 1
    fi

    if [ "$SELECTION" -lt 1 ] || [ "$SELECTION" -gt "${#DIRECTORIES[@]}" ]; then
        echo "Error: Selection out of range."
        exit 1
    fi

    # Get the selected directory
    SELECTED_DIR="${DIRECTORIES[$((SELECTION-1))]}"
    echo ""
    echo "You selected: $SELECTED_DIR"
}

copy_past_prompts() {
    FILE_COUNT=0
    EXCLUDE_FILES=("TODO.txt" "formulation.txt")
    FIND_CMD="find $SELECTED_DIR -type f"
    for EXCLUDE_FILE in "${EXCLUDE_FILES[@]}"; do
        FIND_CMD+=" ! -name ${EXCLUDE_FILE}"
    done
    FIND_CMD+=" -print0"

    # Add prefix file contents if it exists
    if [ -f "$PREFIX_FILE" ]; then
        cat "$PREFIX_FILE" > "$TEMP_FILE"
        echo "" >> "$TEMP_FILE"
    fi

    # Execute find command, sort files, and write the contents to the temporary file
    eval "$FIND_CMD" | sort -z | while IFS= read -r -d $'\0' file; do
        # Check if file is non-empty
        if [ -s "$file" ]; then
            echo "File: $file"
            echo "$(basename "$file"):" >> "$TEMP_FILE"
            cat "$file" >> "$TEMP_FILE"
            echo "" >> "$TEMP_FILE"
            echo "" >> "$TEMP_FILE"
            ((FILE_COUNT++))
        fi
    done

    # Add postfix file contents if it exists
    if [ -f "$POSTFIX_FILE" ]; then
        cat "$POSTFIX_FILE" >> "$TEMP_FILE"
        echo "" >> "$TEMP_FILE"
    fi


    echo "Copied $FILE_COUNT files to clipboard"
    
    # Copy the contents to the clipboard
    xclip -selection clipboard < "$TEMP_FILE"
}

# Call the function with the default target directory and save the result
# TODO - use when there is a second project
# select_directory ".."
SELECTED_DIR="../recipe_ai"
copy_past_prompts

# Clean up the temporary file
rm "$TEMP_FILE"

# Change back to the original directory
cd - > /dev/null || exit 1
