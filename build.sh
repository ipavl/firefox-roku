# default to nightly branding
BRANDING="nightly"

# get the commandline options
while getopts ":b:m:n:" opt; do
  case $opt in
    b)
      BRANDING=$OPTARG
      ;;
    m)
      MAJOR_VER=$OPTARG
      ;;
    n)
      MINOR_VER=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

echo "BRANDING = $BRANDING"
echo "MAJOR_VER = $MAJOR_VER"
echo "MINOR_VER = $MINOR_VER"

# if we don't have the right options, we show usage and exit
if [  ! -n "$BRANDING" -o ! -n "$MAJOR_VER" -o ! -n "$MINOR_VER" ]; then
  echo "Usage: $0 -b <nightly | release> -m <major_ver> -n <minor_ver>" 1>&2; exit 1;
fi

# clear and create the staging folder
rm -rf stage
mkdir -p stage

# copy the app source into the stage area
cp -r app/* stage

# copy branding assets and set the branding strings
if [ $BRANDING = "release" ]; then
  cp branding/release/* stage/images
  APP_NAME="Firefox"
  PACKAGE=firefox-roku-release.zip
else
  cp branding/nightly/* stage/images
  APP_NAME="Firefox Nightly"
  PACKAGE=firefox-roku-nightly.zip
fi

# prepare the package output folder
mkdir -p bin
rm -f bin/$PACKAGE

pushd stage

# replace strings
sed -i "s/__APP_NAME__/$APP_NAME/" ./manifest
sed -i "s/__MAJOR_VER__/$MAJOR_VER/" ./manifest
sed -i "s/__MINOR_VER__/$MINOR_VER/" ./manifest

# build the package zip
zip ../bin/$PACKAGE -r .

popd
