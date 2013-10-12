<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:r="urn:resume">

    <xsl:output method="html" encoding="utf-8" indent="yes"/>

    <!-- An html5 shell for all instance document content -->
    <xsl:template match="/">
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
        <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                <title>Resume</title>
                <link rel="stylesheet" media="screen" href="//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css"/>
                <!-- FIXME this asset ref is too dependent on path to resume (inline <style>?) -->
                <link rel="stylesheet" href="assets/css/jumbotron-narrow.css"/>
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
        <div class="header">
            <ul class="nav nav-pills pull-right">
                <xsl:for-each select="r:link">
                    <li class="row">
                        <a href="{@href}"><xsl:value-of select="."/></a>
                    </li>
                </xsl:for-each>
            </ul>
            <h2><xsl:value-of select="r:name"/></h2>
            <div class="row marketing">
                <div class="pull-right">
                    <xsl:value-of select="r:contact/r:email"/><br/>
                    <xsl:value-of select="r:contact/r:phone"/>
                </div>
                <xsl:apply-templates select="r:contact/r:address"/>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="r:address">
        <div>
            <xsl:for-each select="r:streetAddress">
                <xsl:value-of select="."/><br/>
            </xsl:for-each>
            <xsl:value-of select="r:locality"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="r:region"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="r:postalCode"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="r:country"/>
        </div>
    </xsl:template>

    <xsl:template match="r:objective">
        <div class="row marketing">
            <h3>Objective</h3>
        </div>
        <div class="row marketing">
            <xsl:for-each select="r:para">
                <p><xsl:value-of select="."/></p>
            </xsl:for-each>
        </div>
    </xsl:template>

    <xsl:template name="skills">
        <div class="row marketing">
            <h3>Skills</h3>
        </div>
        <xsl:for-each select="r:skills">
            <div class="row marketing list category">
                <xsl:if test="count(@category) != 0">
                    <strong><xsl:value-of select="@category"/></strong>
                </xsl:if>
            </div>
            <div class="row marketing list">
                <xsl:for-each select="r:skill">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </div>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="interests">
        <div class="row marketing">
            <h3>Interests</h3>
        </div>
        <xsl:for-each select="r:interests">
            <div class="row marketing list category">
                <xsl:if test="count(@category) != 0">
                    <strong><xsl:value-of select="@category"/></strong>
                </xsl:if>
            </div>
            <div class="row marketing list">
                <xsl:for-each select="r:interest">
                    <span><xsl:value-of select="."/></span>
                    <xsl:if test="position() != last()">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </div>
        </xsl:for-each>
    </xsl:template>

    <!-- TODO parameterized CSV list generator for skills/interests -->

    <xsl:template match="r:history">
        <div class="row marketing">
            <h3>Employment</h3>
        </div>
        <xsl:for-each select="r:employment">
            <div class="row marketing">
                <span><strong><xsl:value-of select="r:employer"/></strong></span>
                <span class="pull-right"><xsl:apply-templates select="r:dates"/></span>
            </div>
            <div class="row marketing">
                <xsl:for-each select="r:description/r:para">
                    <p><xsl:value-of select="."/></p>
                </xsl:for-each>
            </div>
        </xsl:for-each>

        <div class="row marketing">
            <h3>Academic</h3>
        </div>
        <xsl:for-each select="r:academic">
            <div class="row marketing">
                <span><strong><xsl:value-of select="r:institution"/></strong></span>
                <span class="pull-right"><xsl:apply-templates select="r:dates"/></span>
                <ul>
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
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="r:dates">
        <i>(<xsl:value-of select="@from"/> - <xsl:value-of select="@to"/>)</i>
    </xsl:template>
</xsl:stylesheet>
