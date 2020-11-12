#!/bin/bash
justme=""
justme=$(unset CDPATH && cd "$(dirname "$0")" && echo $PWD)
mkdir -p "$justme"/pkgs
mkdir -p "$justme"/old
mkdir -p "$justme"/plists
#rm -rf "$justme"/old/*.pkg
rm -rf "$justme"/plists/*.plist
mv "$justme"/*.pkg "$justme"/old 2> /dev/null

echo
read -p "Download Office 2016 at the end of the script (y/n)?" choiceoff
echo

create_package() {
diru=""
diru=$(unset CDPATH && cd "$(dirname "$0")" && echo $PWD)
/bin/chmod -R o+r "${diru}/$1/"
/usr/bin/find "${diru}/$1" -name .DS_Store -delete
/usr/bin/pkgbuild --analyze --root /dev/null "${diru}/plists/$1-component.plist" >/dev/null
/usr/libexec/PlistBuddy -c "Add :Dict:BundleIsRelocatable bool false" -c "Add :0:RootRelativeBundlePath string ${2}.app" "${diru}/plists/$1-component.plist"
/usr/bin/pkgbuild --root "${diru}/$1" \
	--component-plist "${diru}/plists/$1-component.plist" \
	"${diru}/$1-1.0.pkg" >/dev/null
echo "finished $1-1.0.pkg"
/bin/rm "${diru}/plists/$1-component.plist"
}

startscript=$(date +%s)

#Adobe Reader DC Latest Version
#ardclv=`/usr/bin/curl -s -L -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.1.2 Safari/605.1.15" https://get.adobe.com/reader/ | grep "<strong>Version" | /usr/bin/sed -e 's/<[^>][^>]*>//g' | /usr/bin/awk '{print $2}' | sed -e 's/[.]//g' -e 's/20//'`
ardclv=`/usr/bin/curl -s -L -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.1.2 Safari/605.1.15" https://get2.adobe.com/reader/ | grep "for_Mac_Intel" | grep -Eo '[0-9]+' | xargs | sed 's/ //g' | cut -c 3-`
url_ardclv="http://ardownload.adobe.com/pub/adobe/reader/mac/AcrobatDC/${ardclv}/AcroRdrDC_${ardclv}_MUI.dmg"
echo downloading Adobe Reader DC...
/usr/bin/curl -# -o /tmp/reader.dmg ${url_ardclv}
/usr/bin/hdiutil attach /tmp/reader.dmg -nobrowse -quiet
cp /Volumes/AcroRdrDC_${ardclv}_MUI/AcroRdrDC_${ardclv}_MUI.pkg $justme/AdobeAcrobatReaderDC-1.0.pkg
/usr/bin/hdiutil detach $(/bin/df | /usr/bin/grep AcroRdrDC | awk '{print $1}') -quiet
rm /tmp/reader.dmg
echo "finished AdobeAcrobatReaderDC-1.0.pkg"
echo

#Adobe Flash npapi & ppapi
aflv=`/usr/bin/curl -s -L -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/535.6.2 (KHTML, like Gecko) Version/5.2 Safari/535.6.2" https://get.adobe.com/flashplayer | grep "<strong>Version" | /usr/bin/sed -e 's/<[^>][^>]*>//g' | /usr/bin/awk '{print $2}'`
url_aflv_npapi="https://fpdownload.adobe.com/get/flashplayer/pdc/${aflv}/install_flash_player_osx.dmg"
url_aflv_ppapi="https://fpdownload.adobe.com/get/flashplayer/pdc/${aflv}/install_flash_player_osx_ppapi.dmg"
echo "downloading Flash NPAPI & PPAPI..."
/usr/bin/curl -# -o /tmp/flash_npapi.dmg ${url_aflv_npapi}
/usr/bin/hdiutil attach /tmp/flash_npapi.dmg -nobrowse -quiet
cp /Volumes/Flash\ Player/Install\ Adobe\ Flash\ Player.app/Contents/Resources/Adobe\ Flash\ Player.pkg $justme/Flashnpapi-1.0.pkg
/usr/bin/hdiutil detach $(/bin/df | /usr/bin/grep Flash | awk '{print $1}') -quiet
/bin/rm /tmp/flash_npapi.dmg
/usr/bin/curl -# -o /tmp/flash_ppapi.dmg ${url_aflv_ppapi}
/usr/bin/hdiutil attach /tmp/flash_ppapi.dmg -nobrowse -quiet
cp /Volumes/Flash\ Player/Install\ Adobe\ Pepper\ Flash\ Player.app/Contents/Resources/Adobe\ Flash\ Player.pkg $justme/Flashppapi-1.0.pkg
/usr/bin/hdiutil detach $(/bin/df | /usr/bin/grep Flash | awk '{print $1}') -quiet
/bin/rm /tmp/flash_ppapi.dmg
echo "finished Flash_npapi-1.0.pkg"
echo "finished Flash_ppapi-1.0.pkg"
echo

#Java
jlv=`/usr/bin/curl -s -L -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/535.6.2 (KHTML, like Gecko) Version/5.2 Safari/535.6.2" https://www.java.com/en/download/manual.jsp | /usr/bin/grep "Download Java for Mac OS X" | /usr/bin/head -1 | /usr/bin/awk -F "\"" '{ print $4 }'`
echo downloading Java...
/usr/bin/curl -# -o /tmp/java.dmg -J -L ${jlv}
/bin/mkdir /tmp/Java
/usr/bin/hdiutil attach /tmp/java.dmg -mountpoint /tmp/Java -nobrowse -quiet
cp "$(find /tmp/Java/*.app -name "JavaAppletPlugin.pkg")" $justme/Java-1.0.pkg
/usr/bin/hdiutil detach /tmp/Java -quiet
/bin/rm -rf /tmp/Java
/bin/rm -rf /tmp/java.dmg
echo "finished Java-1.0.pkg"
echo

#Shockwave
slv="http://fpdownload.macromedia.com/get/shockwave/default/english/macosx/latest/Shockwave_Installer_Full_64bit.dmg"
echo downloading Shockwave...
/usr/bin/curl -# -o /tmp/shockwave.dmg -J -L ${slv}
/usr/bin/hdiutil attach /tmp/shockwave.dmg -nobrowse -quiet
cp /Volumes/Adobe\ Shockwave\ 12/Shockwave_Installer_Full.pkg $justme/Shockwave-1.0.pkg
/usr/bin/hdiutil detach $(/bin/df | /usr/bin/grep Shockwave | awk '{print $1}') -quiet
/bin/rm /tmp/shockwave.dmg
echo "finished Shockwave-1.0.pkg"
echo

#Silverlight
slv_url="http://go.microsoft.com/fwlink/?LinkID=229322"
echo downloading Silverlight...
/usr/bin/curl -# -o /tmp/silverlight.dmg -J -L ${slv_url}
/usr/bin/hdiutil attach /tmp/silverlight.dmg -nobrowse -quiet
cp /Volumes/Silverlight/silverlight.pkg $justme/Silverlight-1.0.pkg
/usr/bin/hdiutil detach $(/bin/df | /usr/bin/grep Silverlight | awk '{print $1}') -quiet
/bin/rm /tmp/silverlight.dmg
echo "finished Silverlight-1.0.pkg"
echo

#VLC
vlv=`/usr/bin/curl -s https://www.videolan.org/vlc/download-macosx.html | grep -Eo "get.videolan.org/vlc[a-zA-Z0-9\%./?=_-]*" | head -1`
vlv="https://{$vlv}"
echo downloading VLC...
/usr/bin/curl -# -o /tmp/vlc.dmg -J -L ${vlv}
/usr/bin/hdiutil attach /tmp/vlc.dmg -nobrowse -quiet
ditto -rsrc /Volumes/VLC\ media\ player/VLC.app $justme/VLC/Applications/VLC.app
/usr/bin/hdiutil detach $(/bin/df | /usr/bin/grep VLC | awk '{print $1}') -quiet
/bin/rm /tmp/vlc.dmg
create_package VLC "Applications/VLC"
/bin/rm -rf $justme/VLC
echo

#Google Chrome
echo downloading Google Chrome...
/usr/bin/curl -# -o /tmp/chrome.dmg -J -L https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg
/bin/mkdir /tmp/Chrome
/usr/bin/hdiutil attach /tmp/chrome.dmg -mountpoint /tmp/Chrome -nobrowse -quiet
ditto -rsrc /tmp/Chrome/Google\ Chrome.app "$justme/GoogleChrome/Applications/Google Chrome.app"
/usr/bin/hdiutil detach /tmp/Chrome -quiet
/bin/rm -rf /tmp/Chrome
/bin/rm -rf /tmp/chrome.dmg
create_package GoogleChrome "Applications/Google Chrome"
/bin/rm -rf $justme/GoogleChrome
echo

#Adobe AIR
airlv=`/usr/bin/curl -s -L -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/535.6.2 (KHTML, like Gecko) Version/5.2 Safari/535.6.2" https://get.adobe.com/air | grep "<strong>Version" | /usr/bin/sed -e 's/<[^>][^>]*>//g' | /usr/bin/awk '{print $2}'`
airlv_url="https://airdownload.adobe.com/air/mac/download/${airlv}/AdobeAIR.dmg"
echo downloading Adobe AIR...
/usr/bin/curl -# -o /tmp/adobeair.dmg ${airlv_url}
/bin/mkdir /tmp/AdobeAIR
/usr/bin/hdiutil attach /tmp/adobeair.dmg -mountpoint /tmp/AdobeAIR -nobrowse -quiet
ditto /tmp/AdobeAIR/Adobe\ AIR\ Installer.app "$justme/AdobeAIR/tmp/Adobe AIR Installer.app"
/usr/bin/hdiutil detach /tmp/AdobeAIR -quiet
/bin/rm -rf /tmp/AdobeAIR
/bin/rm -rf /tmp/adobeair.dmg
create_package AdobeAIR "tmp/Adobe AIR Installer"
/bin/rm -rf $justme/AdobeAIR
echo

#Firefox
echo downloading Firfeox
/usr/bin/curl -# -o /tmp/firefox.dmg -J -L "https://download.mozilla.org/?product=firefox-esr-latest&os=osx&lang=en-US"
/bin/mkdir /tmp/Firefox
/usr/bin/hdiutil attach /tmp/firefox.dmg -mountpoint /tmp/Firefox -nobrowse -quiet
ditto -rsrc /tmp/Firefox/Firefox.app "$justme/Firefox/Applications/Firefox.app"
/usr/bin/hdiutil detach /tmp/Firefox -quiet
/bin/rm -rf /tmp/Firefox
/bin/rm -rf /tmp/firefox.dmg
create_package Firefox "Applications/Firefox"
/bin/rm -rf $justme/Firefox
echo

#Office 2016
case "$choiceoff" in 
  y|Y ) echo downloading Office 2016...; curl -# -o "$justme/MSOffice-1.0.pkg" -J -L "https://go.microsoft.com/fwlink/?linkid=525133";echo "finished MSOffice-1.0.pkg";
esac
echo

/bin/rm -rf "$justme"/plists
/bin/mv "$justme"/*.pkg "$justme"/pkgs

endscript=$(date +%s)

echo "script finished running in $(python -c "print '%u minutes and %02u seconds' % ((${endscript} - ${startscript})/60, (${endscript} - ${startscript})%60)")"
echo
echo "your downloaded packages are in the <pkgs> directory"
echo
