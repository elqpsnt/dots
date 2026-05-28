#!/usr/bin/env bash

# ╔══════════════════════════════════════════════════════════════╗
# ║             🖼️  PDF TO IMAGE CONVERTER                       ║
# ║   Converts PDF pages into high-speed, crisp JPEG images      ║
# ╚══════════════════════════════════════════════════════════════╝

# Validate that the input argument was provided
if [ -z "$1" ]; then
	echo "Error: Need to provide an input PDF file on command line." >&2 && exit 1
fi

# Validate that the file actually exists and is a regular file
if [ ! -f "$1" ]; then
	echo "Error: File '$1' does not exist or is a directory." >&2 && exit 1
fi

pdf_input="$1"

# Strip the extension to get a clean base name for output files
pdf_basename=${1%%.pdf}

# Execute pdftoppm using the correct version-compliant JPEG syntax
pdftoppm -jpeg -jpegopt quality=80 -r 150 "$pdf_input" "${pdf_basename}_page"

# Check execution success and notify the user
if [ "$?" -eq 0 ]; then
	echo "Successfully converted '${pdf_input}' into JPEG images!"
	echo "Look for files named: ${pdf_basename}_page-1.jpg, etc."
	exit 0
else
	echo "Failed to convert PDF to images." >&2  && exit 2
fi
