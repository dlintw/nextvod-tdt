CURDIR=$1
BASEDIR=$CURDIR/../..

echo "Checking if pad exists ($CURDIR/pad)..."
if [ ! -e $CURDIR/pad ]; then
  echo "pad is missing, trying to compile it..."
  cd $CURDIR/pad.src
  $CURDIR/pad.src/compile.sh
  mv $CURDIR/pad.src/pad $CURDIR/pad
  cd $CURDIR
  if [ ! -e $CURDIR/pad ]; then
    echo "Compiling failed! Exiting..."
    exit 3
  else
    echo "Compiling successfull"
  fi
fi
