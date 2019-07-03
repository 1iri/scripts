#!/bin/bash
if [ -d "./bigscript-dl" ]; then
	rm ./bigscript-dl/*.exe
	rm ./bigscript-dl/*.zip
	rm ./bigscript-dl/*.7z
fi

if [ ! -d "./bigscript-dl" ]; then
	mkdir ./bigscript-dl
fi

clear
echo

read -p "download Smart Notebook full MSI installer (2GB) at the end of the script (y/n)?" choiceoff
echo

startscript=$(date +%s.%N)

echo "downloading Google Chrome browser..."
wget -q --show-progress -P ./bigscript-dl https://dl.google.com/chrome/install/GoogleChromeEnterpriseBundle64.zip
echo

echo "downloading Google Earth Pro..."
wget -q --show-progress -P ./bigscript-dl https://dl.google.com/dl/earth/client/advanced/current/googleearthprowin.exe
echo

echo "downloading Firefox ESR browser..."
wget -q --show-progress --trust-server-names -P ./bigscript-dl 'https://download.mozilla.org/?product=firefox-esr-latest&os=win64&lang=en-US'
echo

echo "downloading VLC player..."
vlc_url=`/usr/bin/curl -s https://www.videolan.org/vlc/ | /usr/bin/grep 'win64' | head -1 | /usr/bin/awk -F "\"" '{ print $4 }'`
vlc_url="http:${vlc_url}"
wget -q --show-progress -P ./bigscript-dl $vlc_url
echo

echo "downloading Skype desktop..."
wget -q --show-progress --trust-server-names -P ./bigscript-dl https://go.skype.com/windows.desktop.download
echo

echo "downloading 7zip..."
zip_url=`/usr/bin/curl -s https://www.7-zip.org/ | /usr/bin/grep 'x64' | head -1 | awk -F'"' '{print $6}'`
zip_url="https://www.7-zip.org/${zip_url}"
wget -q --show-progress -P ./bigscript-dl $zip_url
echo

echo "downloading WinRAR..."
rar_url=`/usr/bin/curl -s https://rarlab.com/download.htm | /usr/bin/grep x64 | /usr/bin/head -1 | /usr/bin/awk -F "\"" '{ print $2 }'`
rar_url="https://rarlab.com/${rar_url}"
wget -q --show-progress -P ./bigscript-dl $rar_url
echo

echo "downloading Far Manager..."
far_url=`/usr/bin/curl -s https://farmanager.com/download.php?l=en | /usr/bin/grep 'x64' | /usr/bin/head -3 | /usr/bin/awk -F "\"" '{ print $4 }' | /usr/bin/grep 7z`
far_url="https://farmanager.com/${far_url}"
wget -q --show-progress -P ./bigscript-dl $far_url
echo

echo "downloading PDFCreator..."
wget -q --show-progress --trust-server-names -P ./bigscript-dl 'http://download.pdfforge.org/download/pdfcreator/PDFCreator-stable?download'
echo

echo "downloading Any Video Converter..."
wget -q --show-progress -P ./bigscript-dl https://www.any-video-converter.com/avc-free.exe
echo

echo "downloading QuickTime player..."
wget -q --show-progress -P ./bigscript-dl https://secure-appldnld.apple.com/QuickTime/031-43075-20160107-C0844134-B3CD-11E5-B1C0-43CA8D551951/QuickTimeInstaller.exe
echo

echo "downloading iTunes..."
wget -q --show-progress --trust-server-names -P ./bigscript-dl https://www.apple.com/itunes/download/win64
itunes_ver=`/usr/bin/curl -s -L -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.1.2 Safari/605.1.15" https://support.apple.com/en-us/HT201222 | grep 'iTunes' | grep 'Windows' | head -1 | /usr/bin/awk -F "iTunes " '{ print $2 }' | cut -d' ' -f1-1 | sed 's/\./_/g'`
mv bigscript-dl/`ls bigscript-dl/ | grep -i itunes` bigscript-dl/`ls bigscript-dl/ | grep -i itunes | sed 's/\.exe.*$//'`_${itunes_ver}.exe
echo

echo "downloading Scratch Desktop..."
scratch_url=`curl -s https://scratch.mit.edu/js/download.bundle.js | grep -Eo "/Scratch|Desktop\/?.*/" |grep -Eo "(http|https)://[a-zA-Z0-9\%./?=_-]*" | head -1`
wget -q --show-progress -P ./bigscript-dl $scratch_url
echo

echo "downloading Java 32 & 64bit..."
java32=`/usr/bin/curl -s -L -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/535.6.2 (KHTML, like Gecko) Version/5.2 Safari/535.6.2" https://www.java.com/en/download/manual.jsp | /usr/bin/grep "Download Java software for Windows Offline" | /usr/bin/head -1 | /usr/bin/awk -F "\"" '{ print $4 }'`
java64=`/usr/bin/curl -s -L -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/535.6.2 (KHTML, like Gecko) Version/5.2 Safari/535.6.2" https://www.java.com/en/download/manual.jsp | /usr/bin/grep "Download Java software for Windows (64-bit)" | /usr/bin/head -1 | /usr/bin/awk -F "\"" '{ print $4 }'`
wget -q --show-progress --trust-server-names -P ./bigscript-dl $java32
wget -q --show-progress --trust-server-names -P ./bigscript-dl $java64
sedu=`ls ./bigscript-dl/jre*586* | sed 's/ *?.*//'`
mv ./bigscript-dl/jre*586* $sedu
sedu=`ls ./bigscript-dl/jre*x64* | sed 's/ *?.*//'`
mv ./bigscript-dl/jre*x64* $sedu
echo

echo "downloading Silverlight..."
silverlight_ver=`/usr/bin/curl -s -L -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.1.2 Safari/605.1.15" https://www.microsoft.com/getsilverlight/locale/en-us/html/Microsoft%20Silverlight%20Release%20History.htm | sed -n 's/.* Build \([^ ]*\).*/\1/p' | head -1 | sed 's/\./_/g'`
wget -q --show-progress --trust-server-names -P ./bigscript-dl http://go.microsoft.com/fwlink/?LinkID=229321
mv ./bigscript-dl/Silverlight_x64.exe ./bigscript-dl/Silverlight_x64_${silverlight_ver}.exe
echo

echo "downloading Adobe Air..."
air_ver=`/usr/bin/curl -s -L -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/535.6.2 (KHTML, like Gecko) Version/5.2 Safari/535.6.2" https://get.adobe.com/air | grep "<strong>Version" | /usr/bin/sed -e 's/<[^>][^>]*>//g' | /usr/bin/awk '{print $2}' | sed 's/\./_/g'`
wget -q --show-progress -P ./bigscript-dl http://airdownload.adobe.com/air/win/download/latest/AdobeAIRInstaller.exe
mv ./bigscript-dl/AdobeAIRInstaller.exe ./bigscript-dl/AdobeAIRInstaller_${air_ver}.exe
echo

echo "downloading Adobe Reader DC..."
reader_url=`/usr/bin/curl -s -L -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.1.2 Safari/605.1.15" https://get.adobe.com/reader/ | grep "<strong>Version" | /usr/bin/sed -e 's/<[^>][^>]*>//g' | /usr/bin/awk '{print $2}' | sed -e 's/[.]//g' -e 's/20//'`
reader_url="http://ardownload.adobe.com/pub/adobe/reader/win/AcrobatDC/${reader_url}/AcroRdrDC${reader_url}_en_US.exe"
wget -q --show-progress -P ./bigscript-dl $reader_url
echo

echo "downloading Adobe Flash ActiveX, NPAPI & PPAPI..."
flash_ver=`/usr/bin/curl -s -L -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/535.6.2 (KHTML, like Gecko) Version/5.2 Safari/535.6.2" https://get.adobe.com/flashplayer | grep "<strong>Version" | /usr/bin/sed -e 's/<[^>][^>]*>//g' | /usr/bin/awk '{print $2}'`
flash_url="https://fpdownload.adobe.com/pub/flashplayer/pdc/${flash_ver}/install_flash_player_ax.exe"
wget -q --show-progress -P ./bigscript-dl $flash_url
flash_url="https://fpdownload.adobe.com/pub/flashplayer/pdc/${flash_ver}/install_flash_player.exe"
wget -q --show-progress -P ./bigscript-dl $flash_url
flash_url="https://fpdownload.adobe.com/pub/flashplayer/pdc/${flash_ver}/install_flash_player_ppapi.exe"
wget -q --show-progress -P ./bigscript-dl $flash_url
flash_ver=`echo ${flash_ver} | sed 's/\./_/g'`
for file in ./bigscript-dl/install_flash_player*; do
	mv ${file} `echo $file | sed 's/\.exe.*$//'`_${flash_ver}.exe
done
echo

case "$choiceoff" in 
	  y|Y ) wget -q --show-progress -P ./bigscript-dl `curl -s 'https://education.smarttech.com/smart_api/notebookdownloads/software' -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"CurrentDownloads":true}' | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*" | grep "admin.zip" | head -1`; echo;
esac

endscript=$(date +%s.%N)
echo "script finished running in $(python -c "print '%u minutes and %02u seconds' % ((${endscript} - ${startscript})/60, (${endscript} - ${startscript})%60)")"
echo
