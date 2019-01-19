#!/bin/bash
set -e
set -u
set -o pipefail
if test -d ./zips
then 
    rm -r ./zips
fi
if test -d ./unzips
then
    rm -r ./unzips
fi
if test -d ./ToUpload
then
    rm -r ./ToUpload
fi
if test -e ./BatchWorksheet.xlxs
then
    rm BatchWorksheet.xlxs
fi
if test -e ./torename.txt
then
    rm torename.txt
fi
