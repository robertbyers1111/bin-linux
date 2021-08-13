!/bin/bash
# Copyright 2020 iRobot Corporation (Unpublished). All Rights Reserved.
#
# Script: Lint RABBIT
# Point of Contact: Leif Grosswiler (lgrosswiler@irobot.com)
# Description: Lints all of the directories and files that contain RABBIT source code, while ignoring those that don't.
# The ignored subdirectories of the project are exempt from our style guidelines and do not need to be linted. For
# pylint and pycodestyle they are specified along with the command, while for pydocstyle they are specified in
# setup.cfg in the root directory.
#
# BEFORE USING THIS SCRIPT: Make sure to run the RABBIT setup script and enter the virtual environment.

usage() {
    echo "Usage: lint_rabbit.sh"
    exit
}

IGNORED_PATHS=config,docs,mhparser,refs,venv,vital_stats,SqliteReader.py

#ABBIT_HOME=${RABBIT_HOME}/tests/unit/utility_tests
RABBIT_HOME=${RABBIT_HOME}/lib/post_processing/evaluators

echo -e "\n\nLinting RABBIT. This tool runs pylint, pydocstyle, and pycodestyle. There should ideally be no output."
echo -e "\n\nRunning pylint... \n\n"
pylint ${RABBIT_HOME} --ignore $IGNORED_PATHS
echo -e "\n\nRunning pydocstyle... \n\n"
pydocstyle ${RABBIT_HOME} --match='(?!test_|mh).*\.py'
echo -e "\n\nRunning pycodestyle... \n\n"
pycodestyle ${RABBIT_HOME} --exclude $IGNORED_PATHS

