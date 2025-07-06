#!/usr/bin/env python3

import os
import sys
import inspect
from pprint import pprint
from pdfminer.high_level import extract_text
import sys

from print_python_color             import *    # import  {py_xxx}, e.g. {py_green}, {py_end}
from customized_common_function     import *    # import  addPath2Env
from print_current_callstack        import *

python_script_i()
# print(f'{py_green}+++++++++ loading {inspect.stack()[0][1]}:{inspect.stack()[0][2]}{py_end}')
# pprint(sys.path)

"""
PDF to Text Converter
This script converts PDF files to text format using pdfminer.six.
It will automatically install pdfminer.six if not already installed.
"""

import os
import sys
import subprocess
import pkg_resources
from pdfminer.high_level import extract_text

def check_and_install_pdfminer():
    """
    Check if pdfminer.six is installed, if not install it
    Returns:
        bool: True if installation is successful or package is already installed
    """
    try:
        pkg_resources.require('pdfminer.six')
        return True
    except (pkg_resources.DistributionNotFound, pkg_resources.VersionConflict):
        print("Installing pdfminer.six...")
        try:
            subprocess.check_call([sys.executable, "-m", "pip", "install", "--user", "pdfminer.six"])
            print("Successfully installed pdfminer.six")
            return True
        except subprocess.CalledProcessError as e:
            print(f"Error installing pdfminer.six: {str(e)}", file=sys.stderr)
            return False

def check_file_exists(file_path):
    """
    Check if a file exists and is a PDF
    Args:
        file_path (str): Path to the file to check
    Returns:
        bool: True if file exists and is PDF, False otherwise
    """
    return os.path.exists(file_path) and file_path.lower().endswith('.pdf')

def get_output_path(pdf_path):
    """
    Generate output text file path from PDF path
    Args:
        pdf_path (str): Path to input PDF file
    Returns:
        str: Path for output text file
    """
    base_path = os.path.splitext(pdf_path)[0]
    return f"{base_path}.txt"

def write_text_file(output_path, text):
    """
    Write text to file with proper encoding handling
    Args:
        output_path (str): Path to output file
        text (str): Text content to write
    """
    # Try writing with different encodings
    encodings = ['utf-8', 'utf-16', 'latin-1', 'ascii']
    
    for encoding in encodings:
        try:
            with open(output_path, 'w', encoding=encoding) as f:
                f.write(text)
            return
        except UnicodeEncodeError:
            continue
    
    # If all encodings fail, use utf-8 with error handling
    with open(output_path, 'w', encoding='utf-8', errors='replace') as f:
        f.write(text)

def convert_pdf_to_text(pdf_path, output_path=None):
    """
    Convert PDF file to text and save to output file
    Args:
        pdf_path (str): Path to input PDF file
        output_path (str, optional): Path to output text file. If None, will be generated from pdf_path
    Raises:
        FileNotFoundError: If input PDF file does not exist
        ValueError: If input file is not a PDF
        Exception: For other conversion errors
    """
    if not os.path.exists(pdf_path):
        raise FileNotFoundError(f"Input file not found: {pdf_path}")
    
    if not pdf_path.lower().endswith('.pdf'):
        raise ValueError(f"Input file is not a PDF: {pdf_path}")

    # If no output path provided, generate one
    if output_path is None:
        output_path = get_output_path(pdf_path)

    try:
        # Extract text from PDF
        text = extract_text(pdf_path)
        
        # Write text to output file with encoding handling
        write_text_file(output_path, text)
            
        print(f"Successfully converted {pdf_path} to {output_path}")
        
    except Exception as e:
        print(f"Error converting PDF: {str(e)}", file=sys.stderr)
        sys.exit(1)

def main():
    """
    Main function to handle command line arguments and run the conversion
    """
    if len(sys.argv) < 2 or len(sys.argv) > 3:
        print("Usage: python pdf2txt.py <input_pdf> [output_txt]", file=sys.stderr)
        sys.exit(1)
        
    pdf_path = sys.argv[1]
    output_path = sys.argv[2] if len(sys.argv) == 3 else None
    
    # Check if pdfminer.six is installed
    if not check_and_install_pdfminer():
        print("Failed to install required package pdfminer.six", file=sys.stderr)
        sys.exit(1)
    
    convert_pdf_to_text(pdf_path, output_path)

if __name__ == "__main__":
    main() 

# print(f'{py_green}{inspect.stack()[0][1]}:{inspect.stack()[0][2]}{py_end}')
python_script_o()