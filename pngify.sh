#!/bin/bash
##
## Created by Michael Vosseller on 10/01/14.
## Copyright (c) 2014 MPV Software, LLC. All rights reserved.
##
## This script quickly converts all PDF images (under a given directory) to 
## PNGs at @1X, @2X, and @3X scale.
##
## This may be useful for sharing image assets between iOS and Android apps 
## where the iOS app uses PDF assets but the Android app uses PNG assets. 
## 
## This script requires bash, ImageMagick, Ghostscript, and XQuartz
##
## For ImageMagick and Ghostscript I use the second and third installers here:
## http://cactuslab.com/imagemagick/
##
## The XQuartz installer can be found here:
## http://xquartz.macosforge.org/
##

# configuration
scalevalues="1 2 3"
dpi=72

## command line args
lastarg="${@: -1}"

## which directory to process
rootdir=$lastarg
if [ "$rootdir" == "" ]; then
    rootdir="."
fi

## find all PDF files under rootdir
for pdffile in `find $rootdir -name "*.[p,P][d,D][f,F]"`; do
    
    path=$(dirname ${pdffile})
    filename=$(basename "$pdffile")
    basename="${filename%.*}"
    
    echo "Processing: $pdffile"
    
    ## for each scale value 
    for scale in $scalevalues; do
	
	## scalestr like "@2x" and "@3x"
	scalestr="";
	if [ $scale -gt 1 ]; then
	    scalestr="@${scale}x"
	fi

	## density value like 72, 144, 216
	density=$(($dpi*$scale));

	pngfile="$path/$basename$scalestr.png"
	echo "Creating: $pngfile"

	## convert -density 144 image.pdf image@2x.png
	convert -density $density $pdffile $pngfile

    done

done


