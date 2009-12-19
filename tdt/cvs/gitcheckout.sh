#!/bin/sh

echo ""
echo ""
echo "###############################################"

BASE=`pwd`
GITSOURCE="$BASE/gitOut/teamducktales.git"

GITCHECKOUT="$BASE/gitCheckout"

mkdir $GITCHECKOUT/
git clone $GITSOURCE $GITCHECKOUT/co

echo "Finished"
