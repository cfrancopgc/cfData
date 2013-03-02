#!/bin/bash


#Êset -x
PWD=$(pwd)

dirf=$(dirname "$1")
cd $dirf
of=$(basename "$1")

	# Standarize some names
	case $of in
		DctrEnAlbm*)  nf=$(echo $of | sed 's/DctrEnAlbm/Doctora en Alabama/') ;;
		HwFv*)  nf=$(echo $of | sed 's/HwFv/Hawaii 5.0/') ;;
		CSILsVgs*)  nf=$(echo $of | sed 's/CSILsVgs/CSI Las Vegas/') ;;
		LsRglsDlJg*)  nf=$(echo $of | sed 's/LsRglsDlJg/Las Reglas del Juego/') ;;
		TnWlf*)  nf=$(echo $of | sed 's/TnWlf/Teen Wolf/') ;;
		LsSmpsns*)  nf=$(echo $of | sed 's/LsSmpsns/Los Simpsons/') ;;
		Rvng*)  nf=$(echo $of | sed 's/Rvng/Revenge/') ;;
		BlBlds*)  nf=$(echo $of | sed 's/BlBlds/Blue Bloods/') ;;
    	*) nf=$(echo $of);;
  	esac
  	
  	# Get the Extension and Filename
	Extf=$(echo $nf | sed 's/.*\.//')
	nf=$(echo $nf | sed 's/\.[^.]*$//')

	# Lowercase
	nf=$(echo $nf | awk '{print tolower($0)}')

	nf=$(echo $nf | sed -e 's/temporada \([0-9]\).*\[cap\.\([0-9]\)\([0-9][0-9]\)\]/ \2x\3 /')
	nf=$(echo $nf | sed -e 's/temp \([0-9]\).*\[cap\.\([0-9]\)\([0-9][0-9]\)\]/ \2x\3 /')
	nf=$(echo $nf | sed -e 's/temp.\([0-9]\).(\([0-9]\)\(.*\))/ \1x0\2 /')

	# Replace .-_ with space
	nf=$(echo $nf | sed -e 's/\./ /g;s/\_/ /g;s/  / /g;s/  / /g;s/  / /g')

  	# Erase All inside brackets
	nf=$(echo $nf | sed -e 's/\[[^][]*\]//g;s/([^()]*)//g')
	
	# change spanish characters
	nf=$(echo $nf | sed 's/‡/a/g;s/Ž/e/g;s/’/i/g;s/—/o/g;s/œ/u/g;s/–/n/g;s/Ÿ/u/g')

	# Replace Some Patterns

	
	# Erase some crap
	for c in 'hdtv' '720p' 'pdtv' 'ws' 'dsrip' 'xvid' '\-lol' '\-2hd' '\-aaf' '\-0tv' '\-dot' '\-fqm' \
		'x264' 'lol' 'by especiales' 'jesusitocd' 'hdrip' 'by eugen' 'por xtrapeque' \
	 	'by annaa' 'by clavi' 'por r2d2' 'by preto' 'by elzeta' 'm4ripos4' 'por marc27'\
	 	'by kanyo' 'www.newpct.com' 'dimension'\
		'dvd rip' 'dvd-rip' 'hditunes' 'ac3' 'mp3'
	do 
		nf=$(echo $nf | sed -e "s/$c//g")
	done
	
	# Process Season and Episode
	nf=$(echo $nf | sed 's/\(.*\) [Ss]\([0-9][0-9]\)[EeXx]\([0-9][0-9]\)\(.*\)/\1 - \2x\3 - \4/' | sed 's/\- 0/- /')
	nf=$(echo $nf | sed 's/\(.*\) \([0-9]\)[Xx]\([0-9][0-9]\)\(.*\)/\1 - \2x\3 - \4/' | sed 's/- -/-/g')
	
	nf=$(echo $nf | sed -e 's/  / /g' | sed -e 's/ -$//;s/ -$//;s/- -/-/g')		

	# Title Case
	nf=$(echo $nf | perl -pe 's/(\w+)/\u\L$&/g')	

	echo mv "$of" "$nf"."$Extf"
	mv "$of" "$nf"."$Extf"

	cd $PWD
	# /usr/local/bin/tvnamer --config=/Users/admin/Dropbox/App/cfg/mytvnamerconfig.es.json "$nf"