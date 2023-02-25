#!/bin/bash
chmod +x issue_startCMD.sh
echo "starting backend-flask"

./issue_startCMD.sh

retVal=$?
if [ $retVal -ne 0 ]; then
    echo "ERROR, port is already in use!!"
fi
exit $retVal
