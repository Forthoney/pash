#!/bin/bash

set -ex

# Placeholder for CI
REPORT_DIR=../../reports
C=5

trim() {
  awk 'length > 40{$0 = substr($0, 1, 37) "..."} {print $0}' 
}

## TODO: We have to remove the sudo from the install script 
##       to be able to run it.
install() {
  scripts/install.sh
}

tests() {
  cd compiler 
  ./test_evaluation_scripts.sh
  cd ../
}

run () {
  git pull

  #all this runs after pull
  REV=$(git rev-parse --short HEAD)
  MSG="$(git log -1 --pretty=%B | trim)"

  RF=$REPORT_DIR/$REV
  SF=$REPORT_DIR/summary
  PASS="fail"
  TIME="0s"
  echo $(date '+%F %T') "Start CI" > $RF
  echo "Lots of tests"   >> $RF
  tests >> $RF
  echo $(date '+%F %T') "End CI"  >> $RF

  FORMAT="%s  %s  %-40s  %s  %s\n"
  SUM="$(printf "$FORMAT" "$(date '+%F;%T')" "$REV" "$MSG" "$PASS" "$TIME")"
  echo "$SUM" >> $SF
}

run
