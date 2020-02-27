#!/bin/bash
# Copy your app to appname/relative/path/to/appname.app
# Use create_package.sh appname "relative/path/to/appname"
# e.g. create_package.sh GarageBand "Applications/GarageBand"

diru=""
diru=$(unset CDPATH && cd "$(dirname "$0")" && echo $PWD)

mkdir -p "$diru"/old
mkdir -p "$diru"/plists
#rm -rf "$diru"/old/*.pkg
rm -rf "$diru"/plists/*.plist
mv "$diru"/*.pkg "$diru"/old 2> /dev/null


/bin/chmod -R o+r "${diru}/$1/"
/usr/bin/find "${diru}/$1" -name .DS_Store -delete
/usr/bin/pkgbuild --analyze --root /dev/null "${diru}/plists/$1-component.plist" >/dev/null
/usr/libexec/PlistBuddy -c "Add :Dict:BundleIsRelocatable bool false" -c "Add :0:RootRelativeBundlePath string ${2}.app" "${diru}/plists/$1-component.plist"
/usr/bin/pkgbuild --root "${diru}/$1" \
        --component-plist "${diru}/plists/$1-component.plist" \
        "${diru}/$1-1.0.pkg"
echo "finished $1-1.0.pkg"
/bin/rm "${diru}/plists/$1-component.plist"
