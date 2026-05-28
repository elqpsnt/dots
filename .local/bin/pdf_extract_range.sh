#!/usr/bin/env bash

# ╔══════════════════════════════════════════════════════════════╗
# ║             📄  PDF PAGE RANGE EXTRACTOR                     ║
# ║   Extracts a custom range of pages into a brand new PDF      ║
# ╚══════════════════════════════════════════════════════════════╝

# Validate that the input PDF file argument was provided
if [ -z "$1" ]; then
	echo "Need to provide an input PDF file on command line." >&2 && exit 1
fi
pdf_input="$1"

# Validate that the page range argument was provided (e.g., 2-5)
if [ -z "$2" ]; then
	echo "Need to provide PDF range input on command line e.g 2, or 3-15." >&2 && exit 2
fi
range="$2"

# Strip the extension and construct the output filename
pdf_basename=${1%%.pdf}
pdf_output="${pdf_basename}_p${range}.pdf"

# Execute pdftk to slice the PDF based on the given range
pdftk "$pdf_input" cat $range output "$pdf_output"

# Check execution success and notify the user
if [ "$?" -eq 0 ]; then
	echo "Extracted range ${range} to a new file: ${pdf_output}"
else
	echo "Failed to extract range from input PDF." >&2  && exit 2
fi
