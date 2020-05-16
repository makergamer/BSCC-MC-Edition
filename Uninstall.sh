#!/usr/bin/env bash

INSTALL_LOC=/opt/BSCC
BIN_LOC=/usr/bin/BSCC

# Make sure we run with root privileges
if [[ $UID != 0 ]]; then
# not root, use sudo
  echo "This script needs root privileges, rerun it using sudo"
  exit 1
fi

echo "This will completely remove $INSTALL_LOC (having minecraft server too) and $BIN_LOC.

Type 'yes' to continue. Anything else will abort"
read junkvar

[[ "$junkvar" != 'yes' ]] \
&& echo "Aborting removal" \
|| {
  rm -f $BIN_LOC
  rm -rf $INSTALL_LOC
  echo "$INSTALL_LOC and $BIN_LOC have been removed"
}
