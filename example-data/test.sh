#!/bin/bash

# Run a report for pay Feb 2017 pay period 1 (1-14)

../bin/orgtoinv timeproc --PO 314159 --invoice 42 --month 02 --period 1 --year 2017 --time  ./customer.org -v

