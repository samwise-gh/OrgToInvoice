# OrgToInvoice

[![GitLab Release](https://img.shields.io/gitlab/v/release/32486008?sort=semver&style=flat-square)](https://gitlab.com/samwise_i/orgtoinvoice/-/releases)
[![C++ standard](https://img.shields.io/badge/standard-C%2B%2B20-blue?logo=c%2B%2B&style=flat-square)](https://en.cppreference.com/w/cpp/compiler_support/20)
[![pipeline status](https://gitlab.com/samwise_i/orgtoinvoice/badges/main/pipeline.svg?style=flat-square)](https://gitlab.com/samwise_i/orgtoinvoice/-/commits/main)

A command line utility to convert [Org](https://orgmode.org) files to customizable [LaTeX](https://www.latex-project.org) invoice and work logs.

All time entries from the **_.org_** file shall have the following format:

    CLOCK: [2017-02-14 Tue 13:16]--[2017-02-14 Tue 15:22] =>  2:06
    ...
    CLOCK: [2017-02-14 Tue 17:14]--[2017-02-14 Tue 18:15] =>  1:01
    ` Worked with Elon on creating a release candidate and running the torture test.

The **CLOCK:** lines are auto generated by org-mode using the built-in clock functionality. There may be one or more of these clock lines per comment describing what was done for that period(s). Note, comment lines must start with **`** and follow one or more valid clock lines.

Work days can be entered in any order since they are sorted when read.

All comments are required to start with one of the following:

    `   Normal work
    ~   Meeting (Not implemented)
    ^   Travel  (Not implemented)

# Configuration

An **_.ini_** file must be created containing provider and client information:

    [PROVIDER]
        Company = "Awesome Engineering, Inc."
        Address1 = "10 Where stuff gets done circle"
        City = "TheCity"
        State =  "CA"
        ZIP =  "94103"
        Phone = "415.555.1212"

    [CLIENT]
        Company = "ACME Systems, Inc."
        Address1 = "18 Cool Project Street"
        City = "Utopia"
        State =  "TX"
        ZIP =  "78653"
        Phone = "520.555.1212"
        PO = "12345"
        Rate = "167.26"

    # Comment 
    [INVOICE]
        Footer = "Thank you for your business:)"
        Terms = "Net 14"

    [LOG]
        Orientation = "Landscape"

# Usage

Running the application is fairly straightforward. Once the application is built move to the **_bin/_** directory of the project and execute **_./orgtoinv ...options..._**.

You MUST provide :

    -t [input file name] of .org
    -c [input file name] of .ini or NOT needed if .ini has the same base name as the .org file e.g. (customer.org, customer.ini)
    -i [invoice number]
    -m [month]
    -p [Pay period] OR -b [day] and -e [day]

Here are the supported options:

    --time     | -t [input file]           .org input file with time data
    --config   | -c [input file]           .ini configuration file, defaults to same filename as time data if not specified
    --month    | -m [month]                Month 1-12 
    --year     | -y [year]                 Year, defaults to current year is NOT specified
    --bday     | -b [day of month]         Start day of pay period, NOT used if pay period specified
    --eday     | -e [day of month]         End day of pay period, NOT used if pay period specified
    --period   | -p [Pay period]           Pay period either 1 or 2
    --PO       | -o [PO number]            Purchase order number, if NOT specied none will be printed
    --rate     | -r [dollars/hour]         Hourly rate, this OVERRIEDES the config.ini
    --ledger   | -l                        Generate a ledger entry
    --help     | -h                        This output
    --verbose  | -v                        Verbose output

The followng is a ypical usage example :

    └> ./orgtoinv --PO 314159 --invoice 42 --month 02 --period 1 --year 2017 --time  ../example-data/customer.org -v

    2017-02-01     2.95 Fixed a table problem, product issue 232
    2017-02-06     1.22 Tested FPGA firmware on various Mac setups looking for black SOD
    2017-02-07     7.45 Looking at failure to be recognized on Cray restart, customer AlwaysPaysOnTime problem 
    2017-02-08     1.92 Did some prelim analysis of the Mac restart issue, worked JimBob and CutAndPasteHero testing new firmware
    2017-02-09     7.55 FPGA ver issue and Cray restart issue, tested possible fix for restart issues
    2017-02-10     8.97 Fixed issue with updater locking, UniqueID tweak
    2017-02-14     3.12 Worked with Elon on creating a release candidate and running the torture test
         Total    33.18

    Output written to :customer-0042.Feb-1-14-2017

This produces two files:

    customer-0042.Feb-1-14-2021.tex
    customer-0042.Feb-1-14-2021.log.tex
    
# Converting to PDF

The invoice and log files are in LaTeX format and will likely need to be converted to pdf or some other document format. On Linux systems the **_texi2pdf_** utility from [texinfo](https://www.gnu.org/software/texinfo/) can be used to generate the pdfs.

    texi2pdf customer-0042.Feb-1-14-2021.log.tex

A [Ledger](https://plaintextaccounting.org) file is also produced for use with the Ledger plain text accounting system.

    customer-0042.Feb-1-14-2021.leg

# Examples

The **_example-data_** directory contains an example run. The reports were generated by running **_test.sh_**, and then converting the **_.tex_** files to pdfs using **_texi2pdf_**.


# Customization

The reports are somewhat customizable by editing **_invoice-color.tex_** and **_worklog-color.tex_** found in the examples directory. Currently, this requires some knowlege of LaTeX. 

# Building

OrgToInvoice has the following dependencies:
- A C++20 compatible compiler either GCC 11 or Clang 13 or newer
- [CMake](https://cmake.org/) version 3.15 or newer. 

To build:

    git clone git@gitlab.com:samwise_i/orgtoinvoice.git
    cd orgtoinvoice
    mkdir build
    cd build
    cmake ..
    make

The build artifact will be placed in the project local **_bin/_** directory.


# License

This project is licensed under the [GNU General Public License v3.0](https://www.gnu.org/licenses/).

