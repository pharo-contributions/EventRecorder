"
I know how to compress files using an external script.
I use a Bash script, ZIP and some other Linux commands.

"
Class {
	#name : #EREventRecorderExternalZipScript,
	#superclass : #Object,
	#category : #'EventRecorder-Server'
}

{ #category : #public }
EREventRecorderExternalZipScript >> compress: aFileReference [ 
	"Compress aFileReference directory and return ZIP file name."
	| command |
	command := 'gt-compress-category.sh {1}' format: { aFileReference basename asString }.
	self system: command.
	^ 'gt-events-', aFileReference basename asString, '.zip'
]

{ #category : #accessing }
EREventRecorderExternalZipScript >> script [
	"This is an expected gt-compress-category.sh content."
'
#!/bin/bash
# Compress a directory for a given category-name that indicates a subdirectory in ~/gt/events directory.
# USAGE: gt-compress-category.sh <category-name>

CATEGORY_NAME="$1"
if [ -z "$CATEGORY_NAME" ] ; then
    exit 1;
fi

# Where category directories start
ROOT_GT_EVENTS="gt/events"
# Category directory that should be compressed
CATEGORY_DIR="${ROOT_GT_EVENTS}/${CATEGORY_NAME}"
# Temporary ZIP filename that is used for the compression
TMP_ZIP_FILE="$HOME/gc_www_root/gt-events-${CATEGORY_NAME}-tmp.zip"
# ZIP filename to which CATEGORY_DIR is compressed
ZIP_FILE="$HOME/gc_www_root/gt-events-${CATEGORY_NAME}.zip"

# remove duplicated files
# Fdupes -q -r -d -N ~/gt

# remove old temporary file, if it exists
rm -f "$TMP_ZIP_FILE"
# compress to the temporary file, then move to the ZIP_FILE on success
cd "$HOME" \
    && zip -uqr "$TMP_ZIP_FILE" "$CATEGORY_DIR" \
    && mv "$TMP_ZIP_FILE" "$ZIP_FILE"
'
]

{ #category : #private }
EREventRecorderExternalZipScript >> system: command [
	"Call external command."
	^ self ffiCall: #(#int #system #(#char #* #command)) module: LibC
]
