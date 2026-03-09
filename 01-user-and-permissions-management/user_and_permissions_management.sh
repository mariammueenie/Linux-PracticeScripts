#!/bin/bash

# =========================================================
# File: user_permissions_lab.sh
# Purpose:
# Practice basic Linux directory creation, file creation,
# permissions, copying, wildcard listing, prompt changes,
# and cleanup operations.
#
# =========================================================

set -u

# -----------------------------
# Variables
# -----------------------------
HOME_DIR="$HOME"
DOCS_DIR="$HOME_DIR/documents"
SHEETS_DIR="$DOCS_DIR/spreadsheets"
DATAINFO_HOME="$HOME_DIR/datainfo"
DATAINFO_SHEETS="$SHEETS_DIR/datainfo"
MYINFO_FILE="$SHEETS_DIR/myinfo"
DATADATA_FILE="$SHEETS_DIR/datadata"
SECURE_DIR="$HOME_DIR/secure"

# -----------------------------
# Step 1
# Create documents and spreadsheets directories
# -----------------------------
echo "== Step 1: Creating directories =="
mkdir -p "$SHEETS_DIR"

echo "Absolute path for spreadsheets directory:"
pwd_before=$(pwd)
cd "$SHEETS_DIR" || exit 1
pwd
cd "$pwd_before" || exit 1
echo

# -----------------------------
# Step 2
# Inferred from screenshot:
# Create datainfo in home directory with sample values
# and copy it into spreadsheets
# -----------------------------
echo "== Step 2: Creating datainfo file =="
cat > "$DATAINFO_HOME" <<EOF
144
288
EOF

echo "Contents of $DATAINFO_HOME:"
cat "$DATAINFO_HOME"
echo

cp "$DATAINFO_HOME" "$SHEETS_DIR/"
echo "Copied datainfo to $SHEETS_DIR"
ls "$SHEETS_DIR"
echo

# -----------------------------
# Step 3
# Set permissions so owner/group/others can read + execute
# Keep write as default for owner only if already present
# chmod 755 gives:
# owner = rwx, group = r-x, others = r-x
# -----------------------------
echo "== Step 3: Setting permissions on datainfo =="
chmod 755 "$DATAINFO_HOME"

echo "Permissions for $DATAINFO_HOME:"
ls -l "$DATAINFO_HOME"
echo

# -----------------------------
# Step 4
# Append current month's calendar to datainfo
# Then copy interactively over old version in spreadsheets
# -----------------------------
echo "== Step 4: Appending calendar and copying interactively =="
cal >> "$DATAINFO_HOME"

echo "Updated contents of $DATAINFO_HOME:"
cat "$DATAINFO_HOME"
echo

cp -i "$DATAINFO_HOME" "$DATAINFO_SHEETS"

echo "Verifying copied file in spreadsheets:"
cat "$DATAINFO_SHEETS"
echo

# -----------------------------
# Step 5
# Work inside spreadsheets, make copies, use wildcard
# to list files with 'ata' as 2nd, 3rd, 4th chars
# Pattern: ?ata*
# -----------------------------
echo "== Step 5: Making copies and using wildcard matching =="
cd "$SHEETS_DIR" || exit 1

cp datainfo myinfo
cp datainfo datadata

echo "Files in spreadsheets:"
ls
echo

echo "Files with 'ata' as 2nd, 3rd, and 4th characters:"
ls ?ata*
echo

cd "$HOME_DIR" || exit 1

# -----------------------------
# Step 6
# Change shell prompt temporarily so it shows current
# working directory followed by an exclamation mark
# -----------------------------
echo "== Step 6: Temporary prompt change =="
export PS1='\w! '
echo "Prompt updated for current shell session."
echo "Example prompt format now uses current directory + !"
echo

# -----------------------------
# Step 7
# Try removing non-empty spreadsheets directory using rmdir
# -----------------------------
echo "== Step 7: Trying rmdir on non-empty directory =="
rmdir "$SHEETS_DIR" 2>/dev/null

if [ -d "$SHEETS_DIR" ]; then
    echo "rmdir failed because the directory is not empty."
else
    echo "Directory removed."
fi
echo

# -----------------------------
# Step 8
# Delete datainfo files, myinfo, and datadata
# -----------------------------
echo "== Step 8: Deleting files =="
rm -f "$DATAINFO_HOME"
rm -f "$DATAINFO_SHEETS"
rm -f "$MYINFO_FILE"
rm -f "$DATADATA_FILE"

echo "Remaining contents of spreadsheets directory:"
ls -la "$SHEETS_DIR"
echo

# -----------------------------
# Step 9
# Delete spreadsheets and documents directories
# -----------------------------
echo "== Step 9: Removing directories =="
rmdir "$SHEETS_DIR"
rmdir "$DOCS_DIR"

echo "Directories removed."
echo

# -----------------------------
# Step 10
# Create secure directory and assign octal permissions
# so only owner has full access
# -----------------------------
echo "== Step 10: Creating secure directory with 700 permissions =="
mkdir -p "$SECURE_DIR"
chmod 700 "$SECURE_DIR"

echo "Permissions for secure directory:"
ls -ld "$SECURE_DIR"
echo

echo "Lab script completed."