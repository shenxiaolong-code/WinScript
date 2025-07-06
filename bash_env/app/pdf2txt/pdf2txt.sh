bash_script_i
# dumpcmdline
# Manual installation command (uncomment if needed)
# /home/utils/Python-3.9.1/bin/pip3 install --user pdfminer.six

# Check if input file is provided
if [ $# -lt 1 ]; then
    dumpinfo "Usage: source ${BASH_SOURCE[0]} <input_pdf> [output_txt]"
    dumpinfo "Example usage:"
    echo "# source ${BASH_SOURCE[0]} ${BASH_DIR}/doc/linux_CShellScripts.pdf ${BASH_DIR}/doc/linux_CShellScripts.txt"
    echo "# /home/utils/Python-3.9.1/bin/python3 ${BASH_SOURCE[0]%/*}/pdf2txt.py ${BASH_DIR}/doc/linux_CShellScripts.pdf ${BASH_DIR}/doc/linux_CShellScripts.txt"
    return 1
fi

pdf_input_file=$1
txt_output_file=$2

# Check if input file exists and is a PDF
if [[ ! -f "$pdf_input_file" || ! "$pdf_input_file" =~ \.pdf$ ]]; then
    dumpinfo "Error: invalid pdf input file: $pdf_input_file"
    dumpinfo "[ $# parameters ] source ${BASH_SOURCE[0]} $*"
    return 2
fi

# If output file is not provided, generate it from input file
if [[ -z "$txt_output_file" ]]; then
    txt_output_file="${pdf_input_file%.pdf}.txt"
fi
[[ -f "${txt_output_file}" ]] && rm -f "${txt_output_file}"

dumpinfo "Converting PDF to text..."
dumpkey pdf_input_file
dumpkey txt_output_file
dumpcmd "/home/utils/Python-3.9.1/bin/python3 ${BASH_SOURCE[0]%/*}/pdf2txt.py \"$pdf_input_file\" \"$txt_output_file\""
/home/utils/Python-3.9.1/bin/python3 ${BASH_SOURCE[0]%/*}/pdf2txt.py "$pdf_input_file" "$txt_output_file"

bash_script_o