<?xml version="1.0" encoding="UTF-8"?>

<!--
fo.xsl
Transform XML resume into XSL-FO, for formatting into PDF.

Copyright (c) 2000-2002 Sean Kelly
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the
   distribution.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS
BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

$Id: fo.xsl,v 1.15 2002/11/10 20:48:58 brandondoyle Exp $
-->

<!-- modified for the namespace http://bmats.co/xml-resume/0 -->
<!-- specialized for the (US) english and letter-sized paper -->

<xsl:stylesheet version="1.0"
                xmlns:r="http://bmats.co/xml-resume/0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format">

    <xsl:output method="xml" encoding="UTF-8"
                omit-xml-declaration="no" indent="yes"/>

    <xsl:strip-space elements="*"/>

    <!--xsl:include href="../params.xsl"/-->
    <!-- page size -->
    <xsl:param name="page.height">11in</xsl:param>
    <xsl:param name="page.width">8.5in</xsl:param>

    <!-- page margins -->
    <xsl:param name="margin.top">0.75in</xsl:param>
    <xsl:param name="margin.left">0.6in</xsl:param>
    <xsl:param name="margin.right">0.6in</xsl:param>
    <xsl:param name="margin.bottom">0.6in</xsl:param>

    <!-- text indent -->
    <xsl:param name="body.indent">.5in</xsl:param>
    <xsl:param name="heading.indent">0in</xsl:param>

    <!-- Margins for the header box. It would be nice to just specify a width
    attribute for the header block, but neither FOP nor XEP use it. Instead, we
    force the width using these two properties. To center the header box, they
    should each be:
      ($page.width - $margin.left - $margin.right - [desired header width]) div 2
    We can't do that using an XPath expression because the numbers have associated
    units. Grrr. There has to be a better way to do this.
    -->
    <xsl:param name="header.margin-left">1.65in</xsl:param>
    <xsl:param name="header.margin-right" select="$header.margin-left"/>

    <!--xsl:include href="../lib/common.xsl"/-->
    <!--xsl:include href="../lib/string.xsl"/-->

    <!-- fo layout params -->
    <!-- Settings for lines around the header of the print resume -->
    <xsl:param name="header.line.pattern">rule</xsl:param>
    <xsl:param name="header.line.thickness">1pt</xsl:param>

    <!-- Space betwixt paragraphs -->
    <xsl:param name="para.break.space">0.750em</xsl:param>

    <!-- Half space; for anywhere line spacing is needed but should be less -->
    <!-- than a full paragraph break; between comma-separated skills lists, -->
    <!-- between job header and description/achievements. -->
    <xsl:param name="half.space">0.4em</xsl:param>

    <!-- Bullet Symbol -->
    <xsl:param name="bullet.glyph">&#x2022;</xsl:param>
    <!-- Space between bullet and its text in bulleted item -->
    <xsl:param name="bullet.space">1.0em</xsl:param>

    <xsl:param name="header.name.font.style">normal</xsl:param>
    <xsl:param name="header.name.font.weight">bold</xsl:param>
    <xsl:param name="header.name.font.size" select="$body.font.size"/>

    <xsl:param name="header.item.font.style">italic</xsl:param>

    <xsl:param name="body.font.size">10pt</xsl:param>
    <xsl:param name="body.font.family">serif</xsl:param>

    <xsl:param name="footer.font.size">8pt</xsl:param>
    <xsl:param name="footer.font.family">serif</xsl:param>

    <xsl:param name="heading.font.size">10pt</xsl:param>
    <xsl:param name="heading.font.family">sans-serif</xsl:param>
    <xsl:param name="heading.font.weight">bold</xsl:param>
    <xsl:param name="heading.border.bottom.style">none</xsl:param>
    <xsl:param name="heading.border.bottom.width">thin</xsl:param>

    <!-- Used for copyright notice and "last modified" date -->
    <xsl:param name="fineprint.font.size">8pt</xsl:param>

    <xsl:param name="emphasis.font.weight">bold</xsl:param>
    <xsl:param name="citation.font.style">italic</xsl:param>
    <xsl:param name="url.font.family">monospace</xsl:param>

    <xsl:param name="jobtitle.font.style">normal</xsl:param>
    <xsl:param name="jobtitle.font.weight">bold</xsl:param>

    <!-- Used on degree major and level -->
    <xsl:param name="degree.font.style">normal</xsl:param>
    <xsl:param name="degree.font.weight">bold</xsl:param>

    <xsl:param name="referee-name.font.style">italic</xsl:param>
    <xsl:param name="referee-name.font.weight">normal</xsl:param>

    <xsl:param name="employer.font.style">italic</xsl:param>
    <xsl:param name="employer.font.weight">normal</xsl:param>

    <xsl:param name="job-period.font.style">italic</xsl:param>
    <xsl:param name="job-period.font.weight">normal</xsl:param>

    <!-- Used for "Projects" and "Achievements" -->
    <xsl:param name="job-subheading.font.style">italic</xsl:param>
    <xsl:param name="job-subheading.font.weight">normal</xsl:param>

    <xsl:param name="skillset-title.font.style">italic</xsl:param>
    <xsl:param name="skillset-title.font.weight">normal</xsl:param>

    <xsl:param name="degrees-note.font.style">italic</xsl:param>
    <xsl:param name="degrees-note.font.weight">normal</xsl:param>

    <xsl:param name="clearance-level.font.style">italic</xsl:param>
    <xsl:param name="clearance-level.font.weight">normal</xsl:param>

    <!-- Used on "*Overall GPA*: 3.0" -->
    <xsl:param name="gpa-preamble.font.style">italic</xsl:param>
    <xsl:param name="gpa-preamble.font.weight">normal</xsl:param>


    <!-- Format the document. -->
    <xsl:template match="/">
        <fo:root>
            <fo:layout-master-set>
                <fo:simple-page-master master-name="resume-page"
                                       margin-top="{$margin.top}" margin-bottom="{$margin.bottom}"
                                       margin-left="{$margin.left}" margin-right="{$margin.right}"
                                       page-width="{$page.width}" page-height="{$page.height}">

                    <!-- FIXME: should be error-if-overflow, but fop0.20.3 doesn't support it -->
                    <fo:region-body overflow="hidden" margin-bottom="{$margin.bottom}"/>

                    <!-- FIXME: should be error-if-overflow, but fop0.20.3 doesn't support it -->
                    <fo:region-after overflow="hidden" extent="{$margin.bottom}"/>
                </fo:simple-page-master>
            </fo:layout-master-set>
            <fo:page-sequence master-reference="resume-page">
                <!-- Running footer with person's name and page number. -->
                <fo:static-content flow-name="xsl-region-after">
                    <fo:block text-align="start"
                              font-size="{$footer.font.size}"
                              font-family="{$footer.font.family}">
                        <xsl:apply-templates select="r:resume/r:header/r:name"/>
                    </fo:block>
                </fo:static-content>

                <fo:flow flow-name="xsl-region-body">
                    <!-- Main text is indented from start side. -->
                    <fo:block start-indent="{$body.indent}"
                              font-family="{$body.font.family}"
                              font-size="{$body.font.size}">
                        <xsl:apply-templates select="r:resume"/>
                    </fo:block>
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>

    <xsl:template match="r:resume">
        <xsl:apply-templates select="r:header" mode="standard"/>
        <xsl:apply-templates select="r:objective"/>
        <xsl:call-template name="skills"/>
        <xsl:call-template name="interests"/>
        <xsl:apply-templates select="r:history"/>
    </xsl:template>

    <!-- Callable template to format a heading: -->
    <!--
      Call "heading" with parameter "text" being the text of the heading.
      GH: As heading.indent is less than body.indent, this is a hanging
          indent of the heading.
    -->
    <xsl:template name="heading">
        <xsl:param name="text">Heading Not Defined</xsl:param>
        <fo:block start-indent="{$heading.indent}"
                  font-size="{$heading.font.size}"
                  font-family="{$heading.font.family}"
                  font-weight="{$heading.font.weight}"
                  space-before="{$para.break.space}"
                  space-after="{$para.break.space}"
                  border-bottom-style="{$heading.border.bottom.style}"
                  border-bottom-width="{$heading.border.bottom.width}"
                  keep-with-next="always">
            <xsl:value-of select="$text"/>
        </fo:block>
    </xsl:template>

    <!-- Header information -->
    <xsl:template match="r:header" mode="standard">
        <fo:block space-after="{$para.break.space}">
            <fo:block font-style="{$header.name.font.style}"
                      font-weight="{$header.name.font.weight}"
                      font-size="{$header.name.font.size}">
                <xsl:apply-templates select="r:name"/>
            </fo:block>
            <xsl:apply-templates select="r:address" mode="italian"/>
            <fo:block space-before="{$half.space}">
                <xsl:apply-templates select="r:contact"/>
            </fo:block>
        </fo:block>
    </xsl:template>

    <xsl:template match="r:header" mode="centered">
        <fo:block space-after="{$para.break.space}"
                  start-indent="{$header.margin-left}"
                  end-indent="{$header.margin-right}">
            <fo:leader leader-length="100%"
                       leader-pattern="{$header.line.pattern}"
                       rule-thickness="{$header.line.thickness}"/>
            <fo:block font-style="{$header.name.font.style}"
                      font-weight="{$header.name.font.weight}"
                      font-size="{$header.name.font.size}">
                <xsl:apply-templates select="r:name"/>
            </fo:block>

            <!-- FIXME this is fucked up. Totally ruins the style. Needs multi-column -->
            <xsl:apply-templates select="r:address"/>

            <fo:block space-before="{$half.space}">
                <xsl:apply-templates select="r:contact"/>
            </fo:block>
            <fo:leader leader-length="100%"
                       leader-pattern="{$header.line.pattern}"
                       rule-thickness="{$header.line.thickness}"/>
        </fo:block>
    </xsl:template>

    <xsl:template match="r:address">
        <fo:block>
            <xsl:for-each select="r:street">
                <fo:block><xsl:value-of select="text()"/></fo:block>
            </xsl:for-each>
            <fo:block>
                <xsl:apply-templates select="r:locality"/>
                <xsl:if test="r:region">
                    <xsl:text>, </xsl:text><xsl:apply-templates select="r:region"/>
                    <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:if test="r:postcode">
                    <xsl:apply-templates select="r:postcode"/><xsl:text> </xsl:text>
                </xsl:if>
            </fo:block>
            <xsl:if test="r:country">
                <fo:block>
                    <xsl:apply-templates select="r:country"/>
                </fo:block>
            </xsl:if>
        </fo:block>
    </xsl:template>

    <!-- Preserve line breaks within a free format address -->
    <!--xsl:template match="r:address//text()">
        <xsl:call-template name="String-Replace">
            <xsl:with-param name="Text" select="."/>
            <xsl:with-param name="Search-For">
                <xsl:text>&#xA;</xsl:text>
            </xsl:with-param>
            <xsl:with-param name="Replace-With">
                <fo:block/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template-->



    <!-- Named template to format a single contact field *SE* -->
    <!-- Don't print the label if the field value is empty *SE* -->
    <xsl:template name="contact">
        <xsl:param name="label"/>
        <xsl:param name="field"/>
        <xsl:if test="string-length($field) > 0">
            <fo:block>
                <fo:inline font-style="{$header.item.font.style}"><xsl:value-of select="$label"/>:</fo:inline>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$field"/>
            </fo:block>
        </xsl:if>
    </xsl:template>

    <!-- Format contact information. -->

    <xsl:template match="r:contact/r:phone">
        <xsl:call-template name="contact">
            <xsl:with-param name="label">
                Phone
                <!--xsl:call-template name="PhoneLocation">
                    <xsl:with-param name="Location" select="@location"/>
                </xsl:call-template-->
            </xsl:with-param>
            <xsl:with-param name="field">
                <xsl:apply-templates/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="r:contact/r:fax">
        <xsl:call-template name="contact">
            <xsl:with-param name="label">
                <xsl:call-template name="FaxLocation">
                    <xsl:with-param name="Location" select="@location"/>
                </xsl:call-template>
            </xsl:with-param>
            <xsl:with-param name="field">
                <xsl:apply-templates/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="r:contact/r:pager">
        <xsl:call-template name="contact">
            <xsl:with-param name="label">
                <xsl:value-of select="$pager.word"/>
            </xsl:with-param>
            <xsl:with-param name="field">
                <xsl:apply-templates/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="r:contact/r:email">
        <xsl:call-template name="contact">
            <xsl:with-param name="label">
                Email
            </xsl:with-param>
            <xsl:with-param name="field">
                <xsl:apply-templates/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="r:contact/r:link">
        <xsl:call-template name="contact">
            <xsl:with-param name="label"><xsl:value-of select="text()"/></xsl:with-param>
            <xsl:with-param name="field"><xsl:value-of select="@href"/></xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Format the objective with the heading "Professional Objective." -->
    <xsl:template match="r:objective">
        <xsl:call-template name="heading">
            <xsl:with-param name="text">Objective</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>

    <!-- Format the history with the heading "Employment History". -->
    <!--xsl:template match="r:history">
        <xsl:call-template name="heading">
            <xsl:with-param name="text"><xsl:value-of select="$history.word"/></xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template-->

    <xsl:template match="r:location">
        <xsl:value-of select="$location.start"/>
        <xsl:apply-templates/>
        <xsl:value-of select="$location.end"/>
    </xsl:template>

    <!-- Format a single job. -->
    <xsl:template match="r:job">
        <fo:block>
            <fo:block space-after="{$half.space}" keep-with-next="always">
                <fo:block
                        keep-with-next="always"
                        font-style="{$jobtitle.font.style}"
                        font-weight="{$jobtitle.font.weight}">
                    <xsl:apply-templates select="r:jobtitle"/>
                </fo:block>
                <fo:block keep-with-next="always">
                    <fo:inline
                            font-style="{$employer.font.style}"
                            font-weight="{$employer.font.weight}">
                        <xsl:apply-templates select="r:employer"/>
                    </fo:inline>
                    <xsl:apply-templates select="r:location"/>
                </fo:block>
                <fo:block
                        font-style="{$job-period.font.style}"
                        font-weight="{$job-period.font.weight}">
                    <xsl:apply-templates select="r:date|r:period"/>
                </fo:block>
            </fo:block>
            <xsl:if test="r:description">
                <fo:block
                        provisional-distance-between-starts="0.5em">
                    <xsl:apply-templates select="r:description"/>
                </fo:block>
            </xsl:if>
            <xsl:if test="r:projects/r:project">
                <fo:block>
                    <fo:block
                            keep-with-next="always"
                            font-style="{$job-subheading.font.style}"
                            font-weight="{$job-subheading.font.weight}">
                        <xsl:value-of select="$projects.word"/>
                    </fo:block>
                    <xsl:apply-templates select="r:projects"/>
                </fo:block>
            </xsl:if>
            <xsl:if test="r:achievements/r:achievement">
                <fo:block>
                    <fo:block
                            keep-with-next="always"
                            font-style="{$job-subheading.font.style}"
                            font-weight="{$job-subheading.font.weight}">
                        <xsl:value-of select="$achievements.word"/>
                    </fo:block>
                    <xsl:apply-templates select="r:achievements"/>
                </fo:block>
            </xsl:if>
        </fo:block>
    </xsl:template>

    <!-- Format the projects section -->
    <xsl:template match="r:projects">
        <fo:list-block space-after="{$para.break.space}"
                       provisional-distance-between-starts="{$para.break.space}"
                       provisional-label-separation="{$bullet.space}">
            <xsl:apply-templates select="r:project"/>
        </fo:list-block>
    </xsl:template>

    <!-- Format a single project as a bullet -->
    <xsl:template match="r:project">
        <xsl:call-template name="bulletListItem">
            <xsl:with-param name="text">
                <xsl:if test="@title">
                    <xsl:value-of select="@title"/>
                    <xsl:value-of select="$title.separator"/>
                </xsl:if>
                <xsl:apply-templates/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Format the achievements section as a bullet list *SE* -->
    <xsl:template match="r:achievements">
        <fo:list-block space-after="{$para.break.space}"
                       provisional-distance-between-starts="{$para.break.space}"
                       provisional-label-separation="{$bullet.space}">
            <xsl:for-each select="r:achievement">
                <xsl:call-template name="bulletListItem"/>
            </xsl:for-each>
        </fo:list-block>
    </xsl:template>

    <!-- Format academics -->
    <xsl:template match="r:academics">
        <xsl:call-template name="heading">
            <xsl:with-param name="text">
                <xsl:value-of select="$academics.word"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates select="r:degrees"/>
        <fo:block font-weight="{$degrees-note.font.weight}"
                  font-style="{$degrees-note.font.style}">
            <xsl:apply-templates select="r:note"/>
        </fo:block>
    </xsl:template>

    <!-- Format a single degree -->
    <xsl:template match="r:degree">
        <fo:block space-after="{$para.break.space}">
            <fo:block keep-with-next="always">
                <fo:inline font-style="{$degree.font.style}"
                           font-weight="{$degree.font.weight}">
                    <xsl:apply-templates select="r:level"/>
                    <xsl:if test="r:major">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$in.word"/>
                        <xsl:text> </xsl:text>
                        <xsl:apply-templates select="r:major"/>
                    </xsl:if>
                </fo:inline>
                <xsl:apply-templates select="r:minor"/>
                <xsl:if test="r:date|r:period">
                    <xsl:text>, </xsl:text>
                    <xsl:apply-templates select="r:date|r:period"/>
                </xsl:if>
                <xsl:if test="r:annotation">
                    <xsl:text>. </xsl:text>
                    <xsl:apply-templates select="r:annotation"/>
                </xsl:if>
            </fo:block>
            <fo:block>
                <xsl:apply-templates select="r:institution"/>
                <xsl:apply-templates select="r:location"/>
            </fo:block>
            <xsl:apply-templates select="r:gpa"/>
            <xsl:if test="r:subjects/r:subject">
                <fo:block space-before="{$half.space}">
                    <xsl:apply-templates select="r:subjects"/>
                </fo:block>
            </xsl:if>
            <xsl:if test="r:projects/r:project">
                <fo:block space-before="{$half.space}">
                    <xsl:apply-templates select="r:projects"/>
                </fo:block>
            </xsl:if>
        </fo:block>

    </xsl:template>

    <!-- Format a GPA -->
    <xsl:template match="r:gpa">
        <fo:block space-before="{$half.space}">
            <fo:inline font-weight="{$gpa-preamble.font.weight}"
                       font-style="{$gpa-preamble.font.style}">
                <xsl:choose>
                    <xsl:when test="@type = 'major'">
                        <xsl:value-of select="$major-gpa.word"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$overall-gpa.word"/>
                    </xsl:otherwise>
                </xsl:choose>
            </fo:inline>

            <xsl:text>: </xsl:text>

            <xsl:apply-templates select="r:score"/>

            <xsl:if test="r:possible">
                <xsl:value-of select="$out-of.word"/>
                <xsl:apply-templates select="r:possible"/>
            </xsl:if>

            <xsl:if test="r:note">
                <xsl:text>. </xsl:text>
                <xsl:apply-templates select="r:note"/>
            </xsl:if>
        </fo:block>
    </xsl:template>

    <xsl:template match="r:subjects" mode="comma">
        <fo:inline font-style="{$job-subheading.font.style}">
            <xsl:value-of select="$subjects.word"/>
            <xsl:value-of select="$title.separator"/>
        </fo:inline>
        <xsl:apply-templates select="r:subject" mode="comma"/>
        <xsl:value-of select="$subjects.suffix"/>
    </xsl:template>

    <xsl:template match="r:subject" mode="comma">
        <xsl:apply-templates select="r:title"/>
        <xsl:if test="$subjects.result.display = 1">
            <xsl:if test="r:result">
                <xsl:value-of select="$subjects.result.start"/>
                <xsl:value-of select="normalize-space(r:result)"/>
                <xsl:value-of select="$subjects.result.end"/>
            </xsl:if>
        </xsl:if>
        <xsl:if test="following-sibling::*">
            <xsl:value-of select="$subjects.separator"/>
        </xsl:if>
    </xsl:template>

    <!-- Format the subjects section as a list-block -->
    <xsl:template match="r:subjects" mode="table">
        <fo:inline font-style="{$job-subheading.font.style}">
            <xsl:value-of select="$subjects.word"/>
            <xsl:value-of select="$title.separator"/>
        </fo:inline>
        <fo:list-block start-indent="1.5in"
                       provisional-distance-between-starts="150pt"
                       provisional-label-separation="0.5em">
            <xsl:for-each select="r:subject">
                <fo:list-item>
                    <fo:list-item-label end-indent="label-end()">
                        <fo:block>
                            <xsl:apply-templates select="r:title"/>
                        </fo:block>
                    </fo:list-item-label>
                    <fo:list-item-body start-indent="body-start()">
                        <fo:block>
                            <xsl:apply-templates select="r:result"/>
                            <fo:leader leader-pattern="space" leader-length="2em"/>
                        </fo:block>
                    </fo:list-item-body>
                </fo:list-item>
            </xsl:for-each>
        </fo:list-block>
    </xsl:template>

    <xsl:template name="skills">
        <xsl:call-template name="heading">
            <xsl:with-param name="text">Skills</xsl:with-param>
        </xsl:call-template>
        <xsl:for-each select="r:skills">
            <xsl:if test="count(@category) != 0">
                <xsl:choose>
                    <xsl:when test="position() != 0">
                        <fo:block space-before="{$half.space}"
                                  font-style="{$header.name.font.style}"
                                  font-weight="{$header.name.font.weight}"
                                  font-size="{$header.name.font.size}">
                            <xsl:value-of select="@category"/>
                        </fo:block>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:block font-style="{$header.name.font.style}"
                                  font-weight="{$header.name.font.weight}"
                                  font-size="{$header.name.font.size}">
                            <xsl:value-of select="@category"/>
                        </fo:block>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <fo:block space-before="{$half.space}">
                <fo:block>
                    <xsl:for-each select="r:skill">
                        <xsl:value-of select="."/>
                        <xsl:if test="position() != last()">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </fo:block>
            </fo:block>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="interests">
        <xsl:call-template name="heading">
            <xsl:with-param name="text">Interests</xsl:with-param>
        </xsl:call-template>
        <xsl:for-each select="r:interests">
            <xsl:if test="count(@category) != 0">
                <xsl:choose>
                    <xsl:when test="position() != 0">
                        <fo:block space-before="{$half.space}"
                                  font-style="{$header.name.font.style}"
                                  font-weight="{$header.name.font.weight}"
                                  font-size="{$header.name.font.size}">
                            <xsl:value-of select="@category"/>
                        </fo:block>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:block font-style="{$header.name.font.style}"
                                  font-weight="{$header.name.font.weight}"
                                  font-size="{$header.name.font.size}">
                            <xsl:value-of select="@category"/>
                        </fo:block>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <fo:block space-before="{$half.space}">
                <fo:block>
                    <xsl:for-each select="r:interest">
                        <xsl:value-of select="."/>
                        <xsl:if test="position() != last()">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </fo:block>
            </fo:block>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="r:dates">
        <fo:block font-style="italic">
            <!-- XXX parens commented out until this can be 'floated right' -->
            <!--xsl:text>(</xsl:text-->
            <xsl:value-of select="@from"/>
            <xsl:text> - </xsl:text>
            <xsl:value-of select="@to"/>
            <!--xsl:text>)</xsl:text-->
        </fo:block>
    </xsl:template>

    <xsl:template match="r:history">
        <xsl:call-template name="heading">
            <xsl:with-param name="text">Employment</xsl:with-param>
        </xsl:call-template>
        <xsl:for-each select="r:employment">
            <xsl:choose>
                <xsl:when test="position() != 0">
                    <fo:block space-before="{$half.space}"
                              font-style="{$header.name.font.style}"
                              font-weight="{$header.name.font.weight}"
                              font-size="{$header.name.font.size}">
                        <xsl:value-of select="r:position"/>
                    </fo:block>
                </xsl:when>
                <xsl:otherwise>
                    <fo:block font-style="{$header.name.font.style}"
                              font-weight="{$header.name.font.weight}"
                              font-size="{$header.name.font.size}">
                        <xsl:value-of select="r:position"/>
                    </fo:block>
                </xsl:otherwise>
            </xsl:choose>
            <fo:block font-style="italic">
                <xsl:value-of select="r:employer"/>
            </fo:block>
            <xsl:apply-templates select="r:dates"/>
            <xsl:apply-templates select="r:description"/>
        </xsl:for-each>

        <xsl:call-template name="heading">
            <xsl:with-param name="text">Academic</xsl:with-param>
        </xsl:call-template>
            <xsl:for-each select="r:academic">
                <xsl:choose>
                    <xsl:when test="position() != 0">
                        <fo:block space-before="{$half.space}"
                                  font-style="{$header.name.font.style}"
                                  font-weight="{$header.name.font.weight}"
                                  font-size="{$header.name.font.size}">
                            <xsl:value-of select="r:institution"/>
                        </fo:block>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:block font-style="{$header.name.font.style}"
                                  font-weight="{$header.name.font.weight}"
                                  font-size="{$header.name.font.size}">
                            <xsl:value-of select="r:institution"/>
                        </fo:block>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:apply-templates select="r:dates"/>
                <xsl:for-each select="r:concentration">
                    <fo:block>
                        <xsl:value-of select="r:degree"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="r:subject"/>
                        <xsl:if test="count(r:degree) = 0">
                            <xsl:text> </xsl:text>
                            (<xsl:value-of select="@type"/>)
                        </xsl:if>
                    </fo:block>
                </xsl:for-each>
            </xsl:for-each>
    </xsl:template>

    <!-- Format the publications section. -->
    <xsl:template match="r:pubs">
        <xsl:call-template name="heading">
            <xsl:with-param name="text"><xsl:value-of select="$publications.word"/></xsl:with-param>
        </xsl:call-template>
        <fo:list-block space-after="{$para.break.space}"
                       provisional-distance-between-starts="{$para.break.space}"
                       provisional-label-separation="{$bullet.space}">
            <xsl:apply-templates select="r:pub"/>
        </fo:list-block>
    </xsl:template>

    <!-- Format a single publication -->
    <xsl:template match="r:pub">
        <fo:list-item>
            <fo:list-item-label start-indent="{$body.indent}"
                                end-indent="label-end()">
                <fo:block><xsl:value-of select="$bullet.glyph"/></fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
                <fo:block>
                    <xsl:call-template name="FormatPub"/>
                </fo:block>
            </fo:list-item-body>
        </fo:list-item>
    </xsl:template>

    <!-- Title of book -->
    <xsl:template match="r:bookTitle" priority="1">
        <fo:inline font-style="{$citation.font.style}"><xsl:apply-templates/></fo:inline><xsl:value-of select="$pub.item.separator"/>
    </xsl:template>

    <!-- Format memberships. -->
    <xsl:template match="r:memberships">
        <xsl:call-template name="heading">
            <xsl:with-param name="text"><xsl:apply-templates select="r:title"/></xsl:with-param>
        </xsl:call-template>

        <xsl:apply-templates select="r:membership"/>
    </xsl:template>

    <!-- Format membership. -->
    <xsl:template match="r:membership">
        <fo:block space-after="{$half.space}" keep-with-next="always">
            <fo:block font-weight="{$jobtitle.font.weight}"
                      font-style="{$jobtitle.font.style}">
                <xsl:apply-templates select="r:title"/>
            </fo:block>
            <xsl:if test="r:organization">
                <fo:block keep-with-next="always">
                    <xsl:apply-templates select="r:organization"/>
                    <xsl:apply-templates select="r:location"/>
                </fo:block>
            </xsl:if>
            <xsl:if test="r:date|r:period">
                <fo:block keep-with-next="always">
                    <xsl:apply-templates select="r:date|r:period"/>
                </fo:block>
            </xsl:if>
        </fo:block>
        <xsl:apply-templates select="r:description"/>
    </xsl:template>

    <!-- Format security clearance section. -->
    <xsl:template match="r:clearances">
        <!-- Heading -->
        <xsl:call-template name="heading">
            <xsl:with-param name="text">
                <xsl:call-template name="Title">
                    <xsl:with-param name="Title" select="$security-clearances.word"/>
                </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>

        <!-- Clearances -->
        <fo:list-block space-after="{$para.break.space}"
                       provisional-distance-between-starts="{$para.break.space}"
                       provisional-label-separation="{$bullet.space}">

            <xsl:apply-templates select="r:clearance"/>

        </fo:list-block>
    </xsl:template>

    <!-- Format a single security clearance. -->
    <xsl:template match="r:clearance">
        <xsl:call-template name="bulletListItem">
            <xsl:with-param name="text">
                <fo:inline font-weight="{$clearance-level.font.weight}"
                           font-style="{$clearance-level.font.style}">
                    <xsl:apply-templates select="r:level"/>
                </fo:inline>
                <xsl:if test="r:organization">
                    <xsl:text>, </xsl:text>
                    <xsl:apply-templates select="r:organization"/>
                </xsl:if>
                <xsl:if test="r:date|r:period">
                    <xsl:text>, </xsl:text>
                    <xsl:apply-templates select="r:date|r:period"/>
                </xsl:if>
                <xsl:if test="r:note">
                    <xsl:text>. </xsl:text>
                    <xsl:apply-templates select="r:note"/>
                </xsl:if>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Format awards. -->
    <xsl:template match="r:awards">
        <!-- Heading -->
        <xsl:call-template name="heading">
            <xsl:with-param name="text">
                <xsl:call-template name="Title">
                    <xsl:with-param name="Title" select="$awards.word"/>
                </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>
        <fo:list-block space-after="{$para.break.space}"
                       provisional-distance-between-starts="{$para.break.space}"
                       provisional-label-separation="{$bullet.space}">
            <xsl:apply-templates select="r:award"/>
        </fo:list-block>
    </xsl:template>

    <!-- Format a single award. -->
    <xsl:template match="r:award">
        <xsl:call-template name="bulletListItem">
            <xsl:with-param name="text">
                <fo:inline font-weight="{$emphasis.font.weight}">
                    <xsl:apply-templates select="r:title"/>
                </fo:inline>
                <xsl:if test="r:organization"><xsl:text>, </xsl:text></xsl:if>
                <xsl:apply-templates select="r:organization"/>
                <xsl:if test="r:date|r:period"><xsl:text>, </xsl:text></xsl:if>
                <xsl:apply-templates select="r:date|r:period"/>
                <xsl:apply-templates select="r:description"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Format miscellaneous information with "Miscellany" as the heading. -->
    <xsl:template match="r:misc">
        <xsl:call-template name="heading">
            <xsl:with-param name="text"><xsl:value-of select="$miscellany.word"/></xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>

    <!-- Format the "last modified" date -->
    <xsl:template match="r:lastModified">
        <fo:block start-indent="{$heading.indent}"
                  space-before="{$para.break.space}"
                  space-after="{$para.break.space}"
                  font-size="{$fineprint.font.size}">
            <xsl:value-of select="$last-modified.phrase"/>
            <xsl:text> </xsl:text>
            <xsl:apply-templates/>
            <xsl:text>.</xsl:text>
        </fo:block>
    </xsl:template>

    <!-- Format legalese. -->
    <xsl:template match="r:copyright">
        <fo:block start-indent="{$heading.indent}"
                  font-size="{$fineprint.font.size}">
            <fo:block keep-with-next="always">
                <xsl:value-of select="$copyright.word"/>
                <xsl:text> </xsl:text>
                <xsl:apply-templates select="r:year"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$by.word"/>
                <xsl:text> </xsl:text>
                <xsl:if test="r:name">
                    <xsl:apply-templates select="r:name"/>
                </xsl:if>
                <xsl:if test="not(r:name)">
                    <xsl:apply-templates select="/r:resume/r:header/r:name"/>
                </xsl:if>
                <xsl:text>. </xsl:text>
            </fo:block>
            <xsl:apply-templates select="r:legalnotice"/>
        </fo:block>
    </xsl:template>

    <!-- Format para's as block objects with 10pt space after them. -->
    <xsl:template match="r:para">
        <fo:block space-after="{$para.break.space}">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <!-- Format emphasized words in bold. -->
    <xsl:template match="r:emphasis">
        <fo:inline font-weight="{$emphasis.font.weight}">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <!-- Format citations to other works. -->
    <xsl:template match="r:citation">
        <fo:inline font-style="{$citation.font.style}">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <!-- Format a URL. -->
    <xsl:template match="r:url" name="FormatUrl">
        <fo:inline font-family="{$url.font.family}">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <!-- Format a period. -->
    <xsl:template match="r:period">
        <xsl:apply-templates select="r:from"/>&#x2013;<xsl:apply-templates select="r:to"/>
    </xsl:template>

    <!-- Format a date. -->
    <xsl:template match="r:date" name="FormatDate">
        <xsl:if test="r:dayOfMonth">
            <xsl:apply-templates select="r:dayOfMonth"/>
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:if test="r:month">
            <xsl:apply-templates select="r:month"/>
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:apply-templates select="r:year"/>
    </xsl:template>

    <!-- In a date with just "present", format it as the word "present". -->
    <!--xsl:template match="r:present"><xsl:value-of select="$present.word"/></xsl:template-->

    <!-- Suppress items not needed for print presentation -->
    <xsl:template match="r:keywords"/>

    <!-- Format the referees -->
    <!--xsl:template match="r:referees">
        <xsl:call-template name="heading">
            <xsl:with-param name="text"><xsl:value-of select="$referees.word"/></xsl:with-param>
        </xsl:call-template>
        <xsl:choose>
            <xsl:when test="$referees.display = 1">
                <xsl:choose>
                    <xsl:when test="$referees.layout = 'compact'">
                        <fo:table table-layout="fixed" width="90%">
                            <fo:table-column width="40%"/>
                            <fo:table-column width="40%"/>
                            <fo:table-body>
                                <xsl:apply-templates select="r:referee" mode="compact"/>
                            </fo:table-body>
                        </fo:table>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="r:referee" mode="standard"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <fo:block space-after="{$para.break.space}">
                    <xsl:value-of select="$referees.hidden.phrase"/>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template-->

    <!-- Format a referee with the name, title, organiation in the 
         left column and the address in the right column -->
    <!--xsl:template match="r:referee" mode="compact">
        <fo:table-row>
            <fo:table-cell padding-bottom="{$half.space}">
                <fo:block font-style="{$referee-name.font.style}"
                          font-weight="{$referee-name.font.weight}">
                    <xsl:apply-templates select="r:name"/>
                </fo:block>
                <fo:block>
                    <xsl:apply-templates select="r:title"/>
                    <xsl:if test="r:title and r:organization">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                    <xsl:apply-templates select="r:organization"/>
                </fo:block>
                <xsl:if test="r:contact">
                    <fo:block>
                        <xsl:apply-templates select="r:contact"/>
                    </fo:block>
                </xsl:if>
            </fo:table-cell>
            <fo:table-cell padding-bottom=".5em">
                <xsl:if test="r:address">
                    <fo:block>
                        <xsl:apply-templates select="r:address"/>
                    </fo:block>
                </xsl:if>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template-->

    <!-- Format a referee as a block element -->
    <!--xsl:template match="r:referee" mode="standard">
        <fo:block space-after="{$para.break.space}">
            <fo:block space-after="{$half.space}">
                <fo:block keep-with-next="always"
                          font-style="{$referee-name.font.style}"
                          font-weight="{$referee-name.font.weight}">
                    <xsl:apply-templates select="r:name"/>
                </fo:block>
                <fo:block>
                    <xsl:apply-templates select="r:title"/>
                    <xsl:if test="r:title and r:organization">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                    <xsl:apply-templates select="r:organization"/>
                </fo:block>
            </fo:block>
            <xsl:if test="r:address">
                <fo:block space-after="{$half.space}">
                    <xsl:apply-templates select="r:address"/>
                </fo:block>
            </xsl:if>
            <xsl:if test="r:contact">
                <fo:block space-after="{$half.space}">
                    <xsl:apply-templates select="r:contact"/>
                </fo:block>
            </xsl:if>
        </fo:block>
    </xsl:template-->

</xsl:stylesheet>
