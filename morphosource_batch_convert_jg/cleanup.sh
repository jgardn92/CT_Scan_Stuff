#!/bin/bash
set -e
set -u
set -o pipefail
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
