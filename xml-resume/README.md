xml-resume
==========

A Résumé XML vocabulary with XML stylesheets for web and print.

**NOTE:** The print stylesheet is currently pretty poor. It is a mutilated
version of [XML Résumé Library](http://xmlresume.sourceforge.net/) and has
not been completely smoothed over (it wasn't smooth in the first place). For
now, the best looking prints will from the HTML output (which includes print
media styles).

##Usage

Validate a resume instance document against the schema

    xmllint --noout --schema schema/resume.xsd /path/to/resume.xml

Generate a responsive HTML5 view of the resume

    ./xml2html.sh /path/to/resume.xml

BUG: the html must be viewed through a webserver because it uses
scheme-relative paths to assets (Bootstrap). The simplest way to
get around this is to use `python -m SimpleHTTPServer` and visit
http://localhost:8000/resume.html

Generate a printable PDF document

    ./xml2pdf.sh /path/to/resume.xml

##Why use this instead of XML Résumé Library?

The schema is simplified and focused. It is using a (more) modern W3C XML Schema
(XSD) instead of a DTD. It is streamlined to allow for maximal readability and
maintainability.

The HTML output is also modern, HTML5 with responsive styling à la Bootstrap.

GitHub is better than SourceForge.
