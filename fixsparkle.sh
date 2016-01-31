#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' 
 
mdfind "kMDItemKind == 'Application'" |grep -vi xcode | grep -vi xamarin | while read line ; do 
	domain="$line/Contents/Info.plist"
    if [ ! -f "$domain" ]
	then
  		continue;
	fi
	
    sparkelUrl=$(defaults read $domain SUFeedURL 2>/dev/null)
    if [ -z "$sparkelUrl" ]; then
    	continue
	fi
	echo "Found $domain using sparkle"
	if [[ $sparkelUrl =~ ^https ]]; then
		echo -e "${GREEN}Using secure $sparkelUrl${NC}"
		continue
	fi
	echo -e "${RED}Using insecure $sparkelUrl${NC} Attempting to Patch..."
	httpsLink=${sparkelUrl/http:/https:}
	$(curl -I $httpsLink &>/dev/null)
	if [ $? -ne 0 ]; then
		echo -e "${RED}Cannot patch contact developer${NC}"
		continue
	fi 
	echo "Patching..."
	echo "defaults write $domain SUFeedURL $sparkelUrl" >> revert.sh
	defaults write $domain SUFeedURL $httpsLink
	if [ $? -ne 0 ]; then
		echo "${RED}Something went tits up"
		continue
	fi
	$(codesign -dv $line &>/dev/null)
	if [ $? -ne 0 ]; then
		echo "${RED}Something went tits up"
		continue
	fi 
	echo -e "${GREEN} Patched${NC}"
done