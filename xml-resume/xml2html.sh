#!/bin/bash

XML_SRC=$1
if [ -z "$XML_SRC" ]; then
    XML_SRC="example/resume.xml"
fi

xsltproc `dirname $0`/xsl/html.xsl "$XML_SRC" > resume.html
