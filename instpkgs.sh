#!/bin/bash
#If use "./instpkgs.sh" without parameter, will install all packages in current directory and subdirs
#If use "./instpkgs.sh directoryname" will install all packages in currentdirectory/directoryname and subdirs

justme=""
justme=$(unset CDPATH && cd "$(dirname "$0")" && echo $PWD)
if [ -z ${1+x} ]; then :; else justme="$justme/$1"; fi

cnt="0"
cntpkgs=`find $justme -iname "*.pkg" -type f | wc -l`
#cnt=$((i+1))

startscript=$(python -c 'import time; print repr(time.time())')

find $justme -iname "*.pkg" | while read pkg
do
	cnt=$((++cnt))
	echo installing ${cnt} of $cntpkgs: ${pkg} ...
	sudo /usr/sbin/installer -pkg "$pkg" -allowUntrusted -target / > /dev/null
done

endscript=$(python -c 'import time; print repr(time.time())')

echo
echo "packages installed in $(python -c "print '%u minutes and %02u seconds' % ((${endscript} - ${startscript})/60, (${endscript} - ${startscript})%60)")"
