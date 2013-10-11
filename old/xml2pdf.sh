#!/bin/bash

xsltproc resume-1_5_1/xsl/output/us-letter.xsl resume.xml > resume.fo
fop -fo resume.fo -pdf resume.pdf
open resume.pdf 
