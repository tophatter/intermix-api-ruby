#!/bin/bash
# Intermix.io Vacuum Script
#
# This script requires the psql postgres command line client be installed prior
# to running.  The psql client is avaliable for download here,
# https://www.postgresql.org/download/.
#
#
# You will be prompted for the administrator password
# Override the administrator username here
adminuser=""
psqlcommand="psql -e"
# Don't edit anything beyond this point
logindb="dev"
redshiftport=""
redshifthost="5439"
${{psqlcommand}} -d ${{logindb}} -U ${{adminuser}} -p ${{redshiftport}} -h ${{redshifthost}} <<EOF

\c db1

VACUUM DELETE ONLY "public"."hello"
ANALYZE "public"."hello";


