<?xml version="1.0" encoding="UTF-8"?>

<!--
html.xsl
Transform XML resume into HTML.

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

$Id$
-->

<xsl:stylesheet version="1.0"
  exclude-result-prefixes="r"
  xmlns:r="http://xmlresume.sourceforge.net/resume/0.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" omit-xml-declaration="yes" indent="no"
    encoding="UTF-8"
    doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/strict.dtd"
    />
  <xsl:strip-space elements="*"/>

  <xsl:include href="params.xsl"/>
  <xsl:include href="common.xsl"/>
  <xsl:include href="address.xsl"/>
  <xsl:include href="pubs.xsl"/>
  <xsl:include href="interests.xsl"/>
  <xsl:include href="awards.xsl"/>
  <xsl:include href="deprecated.xsl"/>
  <xsl:include href="contact.xsl"/>
  <xsl:include href="string.xsl"/>

  <xsl:template match="/">
    <html>
      <head>
        <!-- The XSLT Recommendation specifies that the XSLT processor should
        output this meta tag when in HTML output mode. However, Xalan is too
        stupid to do that, so we work around it. This results in double meta
        tags when using a more compliant processor, like Saxon. -->
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<title>
	  <xsl:apply-templates select="r:resume/r:header/r:name"/>
	  <xsl:text> - </xsl:text>
	  <xsl:value-of select="$resume.word"/>
	</title>
        <link rel="stylesheet" type="text/css">
	  <xsl:attribute name="href">
	    <xsl:value-of select="$css.href"/>
	  </xsl:attribute>
	</link>
        <xsl:apply-templates select="r:resume/r:keywords" mode="header"/>
      </head>
      <body class="resume">
	<xsl:apply-templates select="r:resume"/>
      </body>
    </html>
  </xsl:template>

  <!-- Suppress the keywords in the main body of the document -->
  <xsl:template match="r:keywords"/>

  <!-- But put them into the HTML header. -->
  <xsl:template match="r:keywords" mode="header">
    <meta name="keywords">
      <xsl:attribute name="content">
	<xsl:apply-templates select="r:keyword"/>
      </xsl:attribute>
    </meta>
  </xsl:template>

  <xsl:template match="r:keyword">
    <xsl:value-of select="."/>
    <xsl:if test="position() != last()">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- Output your name and the word "Resume". -->
  <xsl:template match="r:header" mode="standard">
    <h1 class="nameHeading"><xsl:apply-templates select="r:name"/></h1>
    <p>
      <xsl:apply-templates select="r:address"/>
      <xsl:apply-templates select="r:contact"/>
    </p>
  </xsl:template>

  <!-- Alternate formatting for the page header. -->
  <!-- Display the name and contact information in a single centered block. -->
  <!-- Since the 'align' attribute is deprecated, we rely on a CSS -->
  <!-- style to center the headerBlock. -->
  <xsl:template match="r:header" mode="centered">
    <div class="headerBlock" style="text-align: center">
      <h1 class="nameHeading"><xsl:apply-templates select="r:name"/></h1>
      <xsl:apply-templates select="r:address"/>
      <xsl:apply-templates select="r:contact"/>
    </div>
  </xsl:template>

  <!-- Contact information -->
  <xsl:template match="r:contact/r:phone">
    <xsl:apply-templates select="@location"/>
    <xsl:value-of select="$phone.word"/><xsl:text>: </xsl:text>
    <xsl:apply-templates/>
    <br/>
  </xsl:template>

  <xsl:template match="r:contact/r:fax">
    <xsl:apply-templates select="@location"/>
    <xsl:value-of select="$fax.word"/><xsl:text>: </xsl:text>
    <xsl:apply-templates/>
    <br/>
  </xsl:template>

  <xsl:template match="r:contact/r:pager">
    <xsl:value-of select="$pager.word"/><xsl:text>: </xsl:text>
    <xsl:apply-templates/>
    <br/>
  </xsl:template>

  <xsl:template match="r:contact/r:email">
    <xsl:value-of select="$email.word"/><xsl:text>: </xsl:text>
    <a href="mailto:{.}">
      <xsl:apply-templates/>
    </a>
    <br/>
  </xsl:template>

  <xsl:template match="r:contact/r:url">
    <xsl:value-of select="$url.word"/><xsl:text>: </xsl:text>
    <a href="{.}">
      <xsl:apply-templates/>
    </a>
    <br/>
  </xsl:template>

  <xsl:template match="r:contact/r:instantMessage">
    <xsl:call-template name="IMServiceName">
      <xsl:with-param name="Service" select="@service"/>
    </xsl:call-template>
    <xsl:text>: </xsl:text>

    <xsl:apply-templates/>
    <br/>
  </xsl:template>

  <!-- Address, in various formats -->
  <xsl:template match="r:address" mode="free-form">
    <p class="address">
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="r:address" mode="standard">

    <p class="address">
      <!-- templates defined in address.xsl for setting standard fields -->
      <xsl:variable name="AdminDivision">
        <xsl:call-template name="AdminDivision"/>
      </xsl:variable>
      <xsl:variable name="CityDivision">
        <xsl:call-template name="CityDivision"/>
      </xsl:variable>
      <xsl:variable name="PostCode">
        <xsl:call-template name="PostCode"/>
      </xsl:variable>

      <xsl:for-each select="r:street">
        <xsl:apply-templates select="."/><br/>
      </xsl:for-each>
      <xsl:if test="r:street2">
        <xsl:apply-templates select="r:street2"/><br/>
      </xsl:if>
      <xsl:if test="string-length($CityDivision) &gt; 0">
        <xsl:value-of select="$CityDivision"/><br/>
      </xsl:if>
      <xsl:apply-templates select="r:city"/>
      <xsl:if test="string-length($AdminDivision) &gt; 0">
        <xsl:text>, </xsl:text><xsl:value-of select="$AdminDivision"/>
      </xsl:if>
      <xsl:if test="string-length($PostCode) &gt; 0">
        <xsl:text> </xsl:text><xsl:value-of select="$PostCode"/> 
      </xsl:if>
      <xsl:if test="r:country">
        <br/><xsl:apply-templates select="r:country"/>
      </xsl:if>
    </p>
  </xsl:template>

  <xsl:template match="r:address" mode="european">

    <p class="address">
      <!-- templates defined in address.xsl for setting standard fields -->
      <xsl:variable name="AdminDivision">
        <xsl:call-template name="AdminDivision"/>
      </xsl:variable>
      <xsl:variable name="CityDivision">
        <xsl:call-template name="CityDivision"/>
      </xsl:variable>
      <xsl:variable name="PostCode">
        <xsl:call-template name="PostCode"/>
      </xsl:variable>

      <xsl:for-each select="r:street">
        <xsl:apply-templates select="."/><br/>
      </xsl:for-each>
      <xsl:if test="r:street2">
        <xsl:apply-templates select="r:street2"/><br/>
      </xsl:if>
      <xsl:if test="string-length($CityDivision) &gt; 0">
        <xsl:value-of select="$CityDivision"/><br/>
      </xsl:if>
      <xsl:if test="string-length($PostCode) &gt; 0">
        <xsl:value-of select="$PostCode"/><xsl:text> </xsl:text> 
      </xsl:if>
      <xsl:apply-templates select="r:city"/>
      <xsl:if test="string-length($AdminDivision) &gt; 0">
        <br/><xsl:value-of select="$AdminDivision"/>
      </xsl:if>
      <xsl:if test="r:country">
        <br/><xsl:apply-templates select="r:country"/>
      </xsl:if>
    </p>
  </xsl:template>

  <xsl:template match="r:address" mode="italian">

    <p class="address">
      <xsl:for-each select="r:street">
        <xsl:apply-templates select="."/><br/>
      </xsl:for-each>
      <xsl:if test="r:street2">
        <xsl:apply-templates select="r:street2"/><br/>
      </xsl:if>
      <xsl:if test="r:postalCode">
        <xsl:apply-templates select="r:postalCode"/><xsl:text> </xsl:text> 
      </xsl:if>
      <xsl:apply-templates select="r:city"/>
      <xsl:if test="r:province">
        <xsl:text> (</xsl:text>
        <xsl:apply-templates select="r:province"/>
        <xsl:text>)</xsl:text>
      </xsl:if>
      <xsl:if test="r:country">
        <br/><xsl:apply-templates select="r:country"/>
      </xsl:if>
    </p>
  </xsl:template>

  <!-- Preserve line breaks within a free format address -->
  <xsl:template match="r:address//text()">
    <xsl:call-template name="String-Replace">
      <xsl:with-param name="Text" select="."/>
      <xsl:with-param name="Search-For">
        <xsl:text>&#xA;</xsl:text>
      </xsl:with-param>
      <xsl:with-param name="Replace-With">
        <br/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- Objective, with level 2 heading. -->
  <xsl:template match="r:objective">
    <h2 class="objectiveHeading"><xsl:value-of select="$objective.word"/></h2>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Past jobs, with level 2 heading. -->
  <xsl:template match="r:history">
    <h2 class="historyHeading"><xsl:value-of select="$history.word"/></h2>
    <xsl:apply-templates select="r:job"/>
  </xsl:template>

  <!-- Format each job -->
  <xsl:template match="r:job">
    <p class="job">
      <xsl:apply-templates select="r:jobtitle"/> <br/>
      <xsl:apply-templates select="r:employer"/> <br/>
      <xsl:apply-templates select="r:period"/>
    </p>
    <xsl:apply-templates select="r:description">
      <xsl:with-param name="css.class">jobDescription</xsl:with-param>
    </xsl:apply-templates>
    <xsl:if test="r:projects/r:project">
      <div class="projects">
        <p><xsl:value-of select="$projects.word"/></p>
        <xsl:apply-templates select="r:projects"/>
      </div>
    </xsl:if>
    <xsl:if test="r:achievements/r:achievement">
      <div class="achievements">
        <p><xsl:value-of select="$achievements.word"/></p>
        <xsl:apply-templates select="r:achievements"/>
      </div>
    </xsl:if>
  </xsl:template>
		
  <xsl:template match="r:jobtitle">
    <span class="jobTitle">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="r:employer">
    <span class="employer">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <!-- Format the projects section as a bullet list -->
  <xsl:template match="r:projects">
    <ul>
      <xsl:for-each select="r:project">
        <li class="project">
          <xsl:apply-templates/>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <xsl:template match="r:period">
    <xsl:apply-templates select="r:from"/>-<xsl:apply-templates select="r:to"/>
  </xsl:template>

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

  <xsl:template match="r:present"><xsl:value-of select="$present.word"/></xsl:template>

  <!-- Format the achievements section as a bullet list *SE* -->
  <xsl:template match="r:achievements">
    <ul>
      <xsl:for-each select="r:achievement">
        <li class="achievement">
          <xsl:apply-templates/>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <!-- Degrees and stuff -->
  <xsl:template match="r:academics">
    <h2 class="academicsHeading"><xsl:value-of select="$academics.word"/></h2>
    <xsl:apply-templates select="r:degrees"/>
    <xsl:apply-templates select="r:note"/>
  </xsl:template>

  <xsl:template match="r:degrees">
    <ul class="degrees">
      <xsl:apply-templates select="r:degree"/>
    </ul>
    <xsl:apply-templates select="r:note"/>
  </xsl:template>

  <xsl:template match="r:note">
    <div class="note">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="r:degree">
    <li class="degree">
      <span class="degreeTitle">
        <xsl:apply-templates select="r:level"/>
        <xsl:if test="r:major">
          <xsl:text> </xsl:text>
          <xsl:value-of select="$in.word"/>
          <xsl:text> </xsl:text>
          <xsl:apply-templates select="r:major"/>
        </xsl:if>
      </span>
      <xsl:apply-templates select="r:minor"/>
      <xsl:if test="r:date|r:period">
        <xsl:text>, </xsl:text>
        <xsl:apply-templates select="r:date|r:period"/>
      </xsl:if>
      <xsl:if test="r:annotation">
        <xsl:text>. </xsl:text>
        <xsl:apply-templates select="r:annotation"/>
      </xsl:if>
      <xsl:if test="r:institution">
        <br/>
        <xsl:apply-templates select="r:institution"/>
      </xsl:if>

      <xsl:apply-templates select="r:subjects"/>
    </li>
  </xsl:template>

  <!-- Format the subjects -->
  <xsl:template match="r:subjects">
    <xsl:if test="r:subject">
      <table>
        <xsl:for-each select="r:subject">
          <tr>
            <td>
              <xsl:apply-templates select="r:title"/>
            </td>
            <td>
              <xsl:apply-templates select="r:result"/>
            </td>
          </tr>
        </xsl:for-each>
      </table>
    </xsl:if>
  </xsl:template>

  <!-- Format the open-ended skills -->

  <xsl:template match="r:skillarea">
    <h2 class="skillareaHeading"><xsl:apply-templates select="r:title"/></h2>
    <xsl:apply-templates select="r:skillset"/>
  </xsl:template>

  <xsl:template match="r:skillset">
    <xsl:choose>
      <xsl:when test="$skills.format = 'comma'">
	<p>
          <xsl:apply-templates select="r:title" mode="comma"/>

          <xsl:if test="r:skill">
            <span class="skills">
              <xsl:apply-templates select="r:skill" mode="comma"/>
            </span>
          </xsl:if>
          <!-- The following block should be removed in a future version. -->
          <xsl:if test="r:skills">
            <span class="skills">
              <xsl:apply-templates select="r:skills" mode="comma"/>
            </span>
          </xsl:if>
	</p>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="r:title" mode="bullet"/>

        <xsl:if test="r:skill">
          <ul class="skills">
            <xsl:apply-templates select="r:skill" mode="bullet"/>
          </ul>
        </xsl:if>
        <!-- The following block should be removed in a future version. -->
        <xsl:if test="r:skills">
          <ul class="skills">
            <xsl:apply-templates select="r:skills" mode="bullet"/>
          </ul>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="r:skillset/r:title" mode="comma">
    <span class="skillsetTitle">
      <xsl:apply-templates/><xsl:text>: </xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="r:skillset/r:title" mode="bullet">
    <h3 class="skillsetTitle"><xsl:apply-templates/></h3>
  </xsl:template>

  <!-- Format a skill as part of a comma-separated list -->
  <xsl:template match="r:skill" mode="comma">
    <xsl:variable name="Text">
      <xsl:apply-templates/>
    </xsl:variable>
    <xsl:value-of select="normalize-space($Text)"/>
    <xsl:apply-templates select="@level"/>
    <xsl:if test="following-sibling::r:skill">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- Format a skill as part of a bulleted list -->
  <xsl:template match="r:skill" mode="bullet">
    <xsl:variable name="Text">
      <xsl:apply-templates/>
    </xsl:variable>
    <li class="skill">
      <xsl:value-of select="normalize-space($Text)"/>
      <xsl:apply-templates select="@level"/>
    </li>
  </xsl:template>

  <!-- Format a skill level -->
  <xsl:template match="r:skill/@level">
    <xsl:if test="$skills.level.display = 1">
      <xsl:value-of select="$skills.level.start"/>
      <xsl:value-of select="normalize-space(.)"/>
      <xsl:value-of select="$skills.level.end"/>
    </xsl:if>
  </xsl:template>

  <!-- Format publications -->
  <xsl:template match="r:pubs">
    <h2 class="pubsHeading"><xsl:value-of select="$publications.word"/></h2>
    <ul class="pubs">
      <xsl:apply-templates select="r:pub"/>
    </ul>
  </xsl:template>

  <!-- Format a single publication -->
  <xsl:template match="r:pub">
    <li class="pub">
      <xsl:call-template name="FormatPub"/>
    </li>
  </xsl:template>

  <!-- Memberships, with level 2 heading. -->
  <xsl:template match="r:memberships">
    <h2 class="membershipsHeading"><xsl:apply-templates select="r:title"/></h2>
    <ul>
      <xsl:apply-templates select="r:membership"/>
    </ul>
  </xsl:template>

  <!-- A single membership. -->
  <xsl:template match="r:membership">
    <li>
      <xsl:if test="r:title">
        <span class="membershipTitle"><xsl:apply-templates select="r:title"/></span><br/>
      </xsl:if>
      <xsl:if test="r:organization">
        <span class="organization"><xsl:apply-templates select="r:organization"/></span><br/>
      </xsl:if>
      <xsl:if test="r:period">
	<xsl:apply-templates select="r:period"/><br/>
      </xsl:if>
      <xsl:apply-templates select="r:description">
        <xsl:with-param name="css.class">membershipDescription</xsl:with-param>
      </xsl:apply-templates>
    </li>
  </xsl:template>

  <!-- Format interests section. -->
  <xsl:template match="r:interests">
    <h2 class="interestsHeading">
      <xsl:call-template name="InterestsTitle"/>
    </h2>

    <ul>
      <xsl:apply-templates select="r:interest"/>
    </ul>
  </xsl:template>

  <!-- A single interest. -->
  <xsl:template match="r:interest">
    <li>
      <span class="interestTitle"><xsl:apply-templates select="r:title"/></span>

      <!-- Append period to title if followed by a single-line description -->
      <xsl:if test="$interest.description.format = 'single-line' and r:description">
        <xsl:text>. </xsl:text>
      </xsl:if>

      <xsl:apply-templates select="r:description"/>
    </li>
  </xsl:template>

  <!-- Format an interest description -->
  <xsl:template match="r:interest/r:description">
    <xsl:call-template name="r:description">
      <xsl:with-param name="paragraph.format"
        select="$interest.description.format"/>
      <xsl:with-param name="css.class">interestDescription</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- Format awards section. -->
  <xsl:template match="r:awards">
    <h2 class="awardsHeading">
      <xsl:call-template name="AwardsTitle"/>
    </h2>

    <ul>
      <xsl:apply-templates select="r:award"/>
    </ul>
  </xsl:template>

  <!-- A single award. -->
  <xsl:template match="r:award">
    <li class="award">
      <span class="awardTitle"><xsl:apply-templates select="r:title"/></span>

      <xsl:if test="r:organization"><xsl:text>, </xsl:text></xsl:if>
      <xsl:apply-templates select="r:organization"/>

      <xsl:if test="r:date"><xsl:text>, </xsl:text></xsl:if>
      <xsl:apply-templates select="r:date"/>

      <xsl:apply-templates select="r:description"/>
    </li>
  </xsl:template>

  <!-- Format the misc info -->
  <xsl:template match="r:misc">
    <h2 class="miscHeading"><xsl:value-of select="$miscellany.word"/></h2>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Format the "last modified" date -->
  <xsl:template match="r:lastModified">
    <p class="lastModified">
      <xsl:value-of select="$last-modified.phrase"/>
      <xsl:text> </xsl:text>
      <xsl:apply-templates/>
      <xsl:text>.</xsl:text>
    </p>
  </xsl:template>

  <!-- Format the legalese -->
  <xsl:template match="r:copyright">
    <div class="copyright">
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
      <xsl:apply-templates select="r:legalnotice"/>
    </div>
  </xsl:template>

  <!-- Put a space between first and last name -->
  <xsl:template match="r:name">
    <xsl:apply-templates select="r:firstname"/>
    <xsl:text> </xsl:text>
    <xsl:if test="r:middlenames">
      <xsl:apply-templates select="r:middlenames"/>
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="r:surname"/>
    <xsl:if test="r:suffix">
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="r:suffix"/>
    </xsl:if>
  </xsl:template>

  <!-- para -> p -->
  <xsl:template match="r:para">
    <p class="para">
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <!-- emphasis -> strong -->
  <xsl:template match="r:emphasis">
    <strong class="emphasis"><xsl:value-of select="."/></strong>
  </xsl:template>

  <!-- url -> monospace along with href -->
  <xsl:template match="r:url" name="FormatUrl">
    <a class="urlA">
      <xsl:attribute name="href">
        <xsl:value-of select="."/>
      </xsl:attribute>
      <xsl:value-of select="."/>
    </a>
  </xsl:template>

  <!-- link -> make link from href attribute -->
  <xsl:template match="r:link">
    <a class="linkA">
      <xsl:attribute name="href">
	<xsl:value-of select="@href"/>
      </xsl:attribute>
      <xsl:value-of select="."/>
    </a>
  </xsl:template>

  <!-- citation -> cite -->
  <xsl:template match="r:citation">
    <cite class="citation"><xsl:value-of select="."/></cite>
  </xsl:template>

  <!-- Format the referees -->
  <xsl:template match="r:referees">
    <h2 class="refereesHeading"><xsl:value-of select="$referees.word"/></h2>
    <xsl:choose>
      <xsl:when test="$referees.display = 1">
        <xsl:apply-templates select="r:referee"/>
      </xsl:when>
      <xsl:otherwise>
        <p><xsl:value-of select="$referees.hidden.phrase"/></p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="r:referee">
    <div class="referee">
      <div class="refereeName"><xsl:apply-templates select="r:name"/></div>

      <xsl:if test="r:title or r:organization">
        <div>
          <xsl:apply-templates select="r:title"/>
          <xsl:if test="r:title and r:organization">
            <xsl:text>, </xsl:text>
          </xsl:if>
          <xsl:apply-templates select="r:organization"/>
        </div>
      </xsl:if>

      <div class="refereeContact">
        <xsl:apply-templates select="r:address"/>
        <xsl:apply-templates select="r:contact"/>
      </div>
    </div>
  </xsl:template>

  <!-- Format a description as either a block (div) or a single line (span) -->
  <xsl:template match="r:description" name="r:description">
    <!-- Possible values: 'block', 'single-line' -->
    <xsl:param name="paragraph.format">block</xsl:param>
    <xsl:param name="css.class">description</xsl:param>

    <xsl:choose>
      <xsl:when test="$paragraph.format = 'single-line'">
        <span class="{$css.class}">
          <xsl:for-each select="r:para">
            <xsl:apply-templates/>

            <xsl:if test="following-sibling::*">
              <xsl:value-of select="$description.para.separator"/>
            </xsl:if>

          </xsl:for-each>
        </span>
      </xsl:when>

      <xsl:otherwise> <!-- block -->
        <div class="{$css.class}"><xsl:apply-templates/></div>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

</xsl:stylesheet>
