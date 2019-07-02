#!/bin/bash

# inspired by: 
#   https://superuser.com/questions/293856/reducing-pdf-file-size
#   https://www.ghostscript.com/doc/current/Use.htm#File_output

usage() {
    cat<<EOF
Usage:
    ${0} <input file> <output file> [screen|ebook|printer|prepress]

EOF
}
# Examples:
# Note: Ghostscript must be installed on your system
# Note that <n> represents the number of pages in the original document;

#     * Only split file to pages; no range available -
#         \$ ${0} someFile.pdf
#       will create the following single page files:
#         someFile_page_0001.pdf, someFile_page_0002.pdf someFile_page_0003.pdf, someFile_page_000<n>.pdf

#     * Split page to custom output file name -
#         \$ ${0} someFile.pdf newFileName_pageNumer_%2d.pdf
#       will create the following single page files:
#         newFileName_pageNumer_01.pdf, newFileName_pageNumer_02.pdf, newFileName_pageNumer_03.pdf, newFileName_pageNumer_0<n>.pdf

#     * Only reduce quality of pdf file !without! splitting -
#         \$ ${0} someFile.pdf newFileName.pdf ebook
#       will create the following single file: newFileName.pdf with reduced quality
    
#     * Reduce quality !and! split pdf to single pages -
#         \$ ${0} someFile.pdf newFileName_%2d.pdf ebook
#       will create the following single page files, with lower qualuty
#         newFileName_page_01.pdf, newFileName_page_02.pdf, newFileName_page_03.pdf, newFileName_page_0<n>.pdf

### main ###
DEFAULT_QUALITY="printer"
numberOfArguments=$#

case $numberOfArguments in
	1)
        # only split the file
        fileNameInput=$1
        fileNameOutput="${fileNameInput}_page_%04d.pdf"
        pdfSettings=$DEFAULT_QUALITY
        ;;
	2)
        # user supplied input and output files
        fileNameInput=$1
        fileNameOutput=$2
        pdfSettings=$DEFAULT_QUALITY
        ;;
    3)
        # user supplied input and output files
        fileNameInput=$1
        fileNameOutput=$2
        pdfSettings=$3
        ;;
	*)
		# incorrect syntax print usage and exit
        echo "Error: Illegal number of parameters."
        usage
        exit 1
		;;
  esac

if [[ ! -f $fileNameInput ]]; then
    echo "Error: ${fileNameInput} not found!"
    exit 2
fi

if ! which gs > /dev/null 2>&1; then
    echo "Error: Looks like the Ghostscript package is not installed on your system."
    exit 3
fi

cmdToExecute="gs -sDEVICE=pdfwrite -dNOPAUSE -dQUIET -dBATCH \
    -dPDFSETTINGS=/$pdfSettings -dCompatibilityLevel=1.4 \
    -sOutputFile=$fileNameOutput $fileNameInput"

echo -e "Executing:\n    "$cmdToExecute

$cmdToExecute
