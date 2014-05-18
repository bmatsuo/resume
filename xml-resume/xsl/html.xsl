<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:r="http://bmatsuo.github.io/xml-resume/0.3">

    <xsl:output method="html" encoding="utf-8" indent="yes"/>

    <!-- http://getbootstrap.com/examples/jumbotron-narrow/ -->
    <xsl:variable name="jumbotron-narrow-css">
        /* Space out content a bit */
        body {
            padding-top: 20px;
            padding-bottom: 20px;
        }

        /* Everything but the jumbotron gets side spacing for mobile first views */
        .header,
        .marketing,
        .footer {
            padding-left: 15px;
            padding-right: 15px;
        }

        /* Custom page header */
        .header { border-bottom: 1px solid #e5e5e5; }
        /* Make the masthead heading the same height as the navigation */
        .header h3 {
            margin-top: 0;
            margin-bottom: 0;
            line-height: 40px;
            padding-bottom: 19px;
        }

        /* Custom page footer */
        .footer {
            padding-top: 19px;
            color: #777;
            border-top: 1px solid #e5e5e5;
        }

        /* Customize container */
        @media (min-width: 768px) {
            .container {
                max-width: 730px;
            }
        }
        .container-narrow &gt; hr { margin: 30px 0; }

        /* Main marketing message and sign up button */
        .jumbotron {
            text-align: center;
            border-bottom: 1px solid #e5e5e5;
        }
        .jumbotron .btn {
            font-size: 21px;
            padding: 14px 24px;
        }

        /* Supporting marketing content */
        .marketing { margin: 40px 0; }
        .marketing p + h4 { margin-top: 28px; }

        /* Responsive: Portrait tablets and up */
        @media screen and (min-width: 768px) {
            /* Remove the padding we set earlier */
            .header,
            .marketing,
            .footer {
                padding-left: 0;
                padding-right: 0;
            }
            /* Space out the masthead */
            .header { margin-bottom: 30px; }

            /* Remove the bottom border on the jumbotron for visual effect */
            .jumbotron { border-bottom: 0; }
        }
    </xsl:variable>

    <xsl:variable name="resume-css">
        .row { margin-bottom: 15px; }

        .section .header {
            border-bottom: 0px;
            margin-bottom: 5px;
        }

        .section .header h4 {
            border-bottom: 0px;
            padding-bottom: 0px;
            padding-bottom: 0px;
            margin-top: 0px;
            margin-bottom: 2px;
        }

        .header .list-unstyled {
            margin-top: 10px;
        }

        .list-inline.dates {
            margin-bottom: 0px;
        }

        .list-inline.dates li {
            padding-left: 2px;
            padding-right: 2px;
        }

        .header h2 {
            margin-top: 10px;
            margin-bottom: 5px;
        }

        .section p { margin-bottom: 5px; }

        .section .item p { margin-top: 0px; }

        .section .item .header { margin-bottom: 5px; }

        .section .item .header h3 {
            padding-bottom: 5px;
            margin-bottom: 5px;
        }

        .section .row {
            margin-top: 3px;
            padding-top: 0px;
            margin-bottom: 0px;
        }

        .section .list .category { margin-bottom: 3px; }

        .section .list .items { margin-bottom: 3px; }

        .print {
            display: none;
        }

        @media print {
            body {
                padding-top: 0px;
                padding-bottom: 0px;
                font-size: 10pt;
            }

            span, .marketing, .header {
                padding-left: 0px;
                padding-right: 0px;
            }

            .noprint {
                display: none;
            }

            .print {
                display: block;
            }
        }
    </xsl:variable>

    <!-- An html5 shell for all instance document content -->
    <xsl:template match="/">
        <!-- Output DOCTYPE when possible -->
        <xsl:choose>
            <xsl:when test="system-property('xsl:vendor')='Transformiix'"/>
            <xsl:otherwise>
                <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                <title>Resume</title>
                <link rel="stylesheet" media="screen" href="//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css"/>
                <link rel="stylesheet" type="text/css" media="print" href="//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css"/>
                <style type="text/css">
                    <xsl:value-of select="$jumbotron-narrow-css"/>
                    <xsl:value-of select="$resume-css"/>
                </style>
            </head>
            <body>
                <div class="container">
                    <xsl:apply-templates select="r:resume"/>
                </div>
                <script src="//code.jquery.com/jquery.js"></script>
                <script src="//netdna.bootstrapcdn.com/bootstrap/3.0.0/js/bootstrap.min.js"></script>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="r:resume">
        <xsl:apply-templates select="r:header"/>
        <xsl:apply-templates select="r:objective"/>
        <xsl:call-template name="skills"/>
        <xsl:call-template name="interests"/>
        <xsl:apply-templates select="r:history"/>
    </xsl:template>

    <xsl:template match="r:header">
        <div class="row header">
            <span class="col-xs-7 col-sm-7 col-md-7 col-lg-7">
                <h2><xsl:value-of select="r:name"/></h2>
                <strong><xsl:value-of select="r:contact/r:email"/></strong>
            </span>
            <span class="col-xs-5 col-sm-5 col-md-5 col-lg-5 col-xs-3 col-sm-1 offset-md-1 offset-lg-1">
                <xsl:apply-templates select="r:contact"/>
            </span>
        </div>
    </xsl:template>

    <xsl:template match="r:contact">
        <ul class="noprint list-unstyled">
            <li><xsl:value-of select="r:phone"/></li>
            <xsl:for-each select="r:address">
                <li><xsl:apply-templates select="."/></li>
            </xsl:for-each>
            <xsl:for-each select="r:link">
                <li class="hidden-xs"><xsl:apply-templates select="." mode="standard"/></li>
                <li class="visible-xs">
                    <xsl:apply-templates select="." mode="mobile"/>
                </li>
            </xsl:for-each>
        </ul>
        <ul class="print list-unstyled">
            <li><xsl:value-of select="r:phone"/></li>
            <xsl:for-each select="r:address">
                <li><xsl:apply-templates select="."/></li>
            </xsl:for-each>
            <xsl:for-each select="r:link">
                <li><xsl:apply-templates select="." mode="print"/></li>
            </xsl:for-each>
        </ul>
    </xsl:template>

    <xsl:template match="r:address">
        <div>
            <xsl:for-each select="r:street">
                <xsl:value-of select="."/><br/>
            </xsl:for-each>
            <xsl:value-of select="r:locality"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="r:region"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="r:postcode"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="r:country"/>
        </div>
    </xsl:template>

    <xsl:template match="r:link" mode="standard">
        <a href="{@href}" title="{.}"><xsl:value-of select="@href"/></a>
    </xsl:template>

    <xsl:template match="r:link" mode="mobile">
        <a href="{@href}" title="{.}"><xsl:value-of select="."/></a>
    </xsl:template>

    <xsl:template match="r:link" mode="print">
        <xsl:value-of select="@href"/>
    </xsl:template>

    <xsl:template match="r:objective">
        <div class="section">
            <div class="row marketing header">
                <h4 class="compact">Objective</h4>
            </div>
            <div class="row marketing">
                <div class="row marketing"><!-- this redundancy kind of sucks -->
                    <xsl:for-each select="r:para">
                        <p><xsl:value-of select="."/></p>
                    </xsl:for-each>
                </div>
            </div>
        </div>
    </xsl:template>

    <xsl:template name="skills">
        <div class="section">
            <div class="row marketing header">
                <h4>Skills</h4>
            </div>
            <div class="row marketing list">
                <xsl:for-each select="r:skills">
                    <xsl:if test="count(@category) != 0">
                        <div class="row marketing category">
                            <strong><xsl:value-of select="@category"/></strong>
                        </div>
                    </xsl:if>
                    <div class="row marketing items">
                        <xsl:for-each select="r:skill">
                            <xsl:value-of select="."/>
                            <xsl:if test="position() != last()">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </div>
                </xsl:for-each>
            </div>
        </div>
    </xsl:template>

    <xsl:template name="interests">
        <div class="section">
            <div class="row marketing section header">
                <h4>Interests</h4>
            </div>
            <div class="row marketing list">
                <xsl:for-each select="r:interests">
                    <xsl:if test="count(@category) != 0">
                        <div class="row marketing category">
                            <strong><xsl:value-of select="@category"/></strong>
                        </div>
                    </xsl:if>
                    <div class="row marketing items">
                        <xsl:for-each select="r:interest">
                            <xsl:value-of select="."/>
                            <xsl:if test="position() != last()">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </div>
                </xsl:for-each>
            </div>
        </div>
    </xsl:template>

    <!-- TODO parameterized CSV list generator for skills/interests -->

    <xsl:template match="r:history">
        <div class="section">
            <div class="row marketing section header">
                <h4>Employment</h4>
            </div>
            <xsl:for-each select="r:employment">
                <div class="row marketing item">
                    <div class="row header">
                        <div class="col-sm-8 col-md-8 col-lg-8">
                            <strong><xsl:value-of select="r:position"/></strong>
                        </div>
                        <span class="col-xs-7 col-sm-8 col-md-8 col-lg-8">
                            <xsl:value-of select="r:employer"/>
                        </span>
                        <span class="col-xs-5 col-sm-4 col-md-4 col-lg-4 offset-md-1 offset-md-1">
                            <xsl:apply-templates select="r:dates"/>
                        </span>
                    </div>
                    <div class="row marketing">
                        <xsl:for-each select="r:description/r:para">
                            <p><xsl:value-of select="."/></p>
                        </xsl:for-each>
                    </div>
                </div>
            </xsl:for-each>
        </div>

        <div class="section">
            <div class="row marketing section header">
                <h4>Academic</h4>
            </div>
            <xsl:for-each select="r:academic">
                <div class="row marketing item">
                    <div class="row header">
                        <span class="col-xs-7 col-sm-8 col-md-8 col-lg-8">
                            <strong><xsl:value-of select="r:institution"/></strong>
                        </span>
                        <span class="col-xs-5 col-sm-4 col-md-4 col-lg-4 offset-md-1 offset-md-1">
                            <xsl:apply-templates select="r:dates"/>
                        </span>
                    </div>
                    <div class="row marketing">
                        <ul class="list-unstyled">
                            <xsl:for-each select="r:concentration">
                                <li>
                                    <xsl:value-of select="r:degree"/>
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="r:subject"/>
                                    <xsl:if test="count(r:degree) = 0">
                                        <xsl:text> </xsl:text>
                                        (<xsl:value-of select="@type"/>)
                                    </xsl:if>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </div>
                </div>
            </xsl:for-each>
        </div>
    </xsl:template>

    <xsl:template match="r:dates">
        <ul class="list-inline dates">
            <li><i><xsl:value-of select="@from"/></i></li>
            <li>-</li>
            <li><i><xsl:value-of select="@to"/></i></li>
        </ul>
    </xsl:template>
</xsl:stylesheet>
