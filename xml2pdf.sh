#!/bin/bash

XML_SRC=$1
if [ -z "$XML_SRC" ]; then
    XML_SRC="example/resume.xml"
fi

xsltproc `dirname $0`/xsl/letter.xsl "$XML_SRC" > resume.fo
fop -fo resume.fo -pdf resume.pdf
open resume.pdf 
