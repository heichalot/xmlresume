<?xml version="1.0" encoding="UTF-8"?>

<!--
common.xsl
Defines some common templates shared by all the stylesheets. 

Copyright (c) 2002 Sean Kelley and contributors
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

$Id$
-->

<xsl:stylesheet version="1.0"
  xmlns:r="http://xmlresume.sourceforge.net/resume/0.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:include href="deprecated.xsl"/>
  <xsl:include href="address.xsl"/>
  <xsl:include href="pub.xsl"/>

  <xsl:include href="string.xsl"/>

  <!-- Outputs the text to use as a title. -->
  <!-- Uses <title> child element if present, otherwise $Default. -->
  <xsl:template name="Title">
    <xsl:param name="Default">NO DEFAULT TITLE DEFINED</xsl:param>

    <xsl:choose>
      <xsl:when test="r:title">
        <xsl:apply-templates select="r:title"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$Default"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- CONTACTS =========================================================== -->
  <!-- Outputs the word for a contact location ("Home", "Work", etc.), followed
  by a space. -->
  <xsl:template match="r:contact/r:phone/@location | r:contact/r:fax/@location">
    <xsl:choose>
      <xsl:when test=". = 'home'">
        <xsl:value-of select="$home.word"/>
        <xsl:text> </xsl:text>
      </xsl:when>
      <xsl:when test=". = 'work'">
        <xsl:value-of select="$work.word"/>
        <xsl:text> </xsl:text>
      </xsl:when>
      <xsl:when test=". = 'mobile'">
        <xsl:value-of select="$mobile.word"/>
        <xsl:text> </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>***UNKNOWN CONTACT LOCATION: '</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>'*** </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="IMServiceName">
    <xsl:param name="Service"/>

    <xsl:choose>
      <xsl:when test="$Service = 'aim'">
        <xsl:value-of select="$im.aim.service"/>
      </xsl:when>
      <xsl:when test="$Service = 'icq'">
        <xsl:value-of select="$im.icq.service"/>
      </xsl:when>
      <xsl:when test="$Service = 'irc'">
        <xsl:value-of select="$im.irc.service"/>
      </xsl:when>
      <xsl:when test="$Service = 'jabber'">
        <xsl:value-of select="$im.jabber.service"/>
      </xsl:when>
      <xsl:when test="$Service = 'msn'">
        <xsl:value-of select="$im.msn.service"/>
      </xsl:when>
      <xsl:when test="$Service = 'yahoo'">
        <xsl:value-of select="$im.yahoo.service"/>
      </xsl:when>
      <xsl:when test="string-length($Service) > 0">
        <xsl:message>
          <xsl:text>***** WARNING: Unknown instantMessage service: '</xsl:text>
          <xsl:value-of select="$Service"/>
          <xsl:text>' (inserting literally into output)</xsl:text>
        </xsl:message>
        <xsl:value-of select="$Service"/>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- HEADER ============================================================= -->
  <!-- Call header template in appropriate mode -->
  <xsl:template match="r:header">
    <xsl:choose>
      <xsl:when test="$header.format = 'centered'">
        <xsl:apply-templates select="." mode="centered"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="standard"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- DEGREE ============================================================= -->
  <!-- Format a major -->
  <xsl:template match="r:major">
    <xsl:apply-templates/>

    <xsl:choose>
      <xsl:when test="count(following-sibling::r:major) > 1">
        <xsl:text>, </xsl:text>
      </xsl:when>
      <xsl:when test="count(following-sibling::r:major) = 1">
        <xsl:if test="count(preceding-sibling::r:major) > 1">
          <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$and.word"/>
        <xsl:text> </xsl:text>
      </xsl:when>
    </xsl:choose>

  </xsl:template>

  <!-- Format a minor -->
  <xsl:template match="r:minor">
    <xsl:if test="position() = 1">
      <xsl:choose>
        <xsl:when test="count(following-sibling::r:minor) > 0">
          <xsl:text> (</xsl:text>
          <xsl:value-of select="$minors.word"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text> (</xsl:text>
          <xsl:value-of select="$minor.word"/>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:text> </xsl:text>
      <xsl:value-of select="$in.word"/>
      <xsl:text> </xsl:text>
    </xsl:if>

    <xsl:apply-templates/>

    <xsl:choose>
      <xsl:when test="count(following-sibling::r:minor) > 1">
        <xsl:text>, </xsl:text>
      </xsl:when>
      <xsl:when test="count(following-sibling::r:minor) = 1">
        <xsl:if test="count(preceding-sibling::r:minor) > 1">
          <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$and.word"/>
        <xsl:text> </xsl:text>
      </xsl:when>
      <xsl:when test="count(following-sibling::r:minor) = 0">
        <xsl:text>)</xsl:text>
      </xsl:when>
    </xsl:choose>

  </xsl:template>

  <!-- SKILLS ============================================================= -->
  <!-- Normalize space in skills, but preserve descendant elements. This
  replaced the following code in the r:skill template:
  
  <xsl:variable name="Text">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:value-of select="normalize-space($Text)"/>

  The problem with the above code is that if a skill contains other elements
  (for example, a <link>), the normalize-space call removes those elements. This
  solution avoids that problem.
  -->
  <xsl:template match="r:skill//text()">
    <xsl:value-of select="normalize-space(.)"/>

    <!-- This part's a bit complicated. It basically says to output a space IF:
      1. This text node is followed by an element or another text node.
      2. AND This element has trailing whitespace.
    We can't ignore the second requirement, or else we format input like this:
      "<skill>Apache (<url>www.apache.org</url>)</skill>"
    As:
      "Apache ( www.apache.org)"
    Our more complicated rule yields the correct output:
      "Apache (www.apache.org)"
    -->
    <xsl:if test="following-sibling::* or following-sibling::text()">

      <xsl:variable name="TrailingWS">
        <xsl:call-template name="TrailingSpace">
          <xsl:with-param name="Text">
            <xsl:value-of select="."/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:variable>

      <xsl:if test="string-length($TrailingWS)">
        <xsl:text> </xsl:text>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- LOCATION =========================================================== -->
  <!-- Location sub-elements -->
  <xsl:template match="r:location/*">
    <xsl:apply-templates/>
    <xsl:if test="following-sibling::*">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
