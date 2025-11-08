<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!--
  XS3P Content Generator Module: SVG Diagrams
  This module handles SVG diagram embedding for schema elements.
-->
<xsl:stylesheet
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns="http://www.w3.org/1999/xhtml"
 xmlns:xsd="http://www.w3.org/2001/XMLSchema"
 version="1.0">

   <!-- Dependencies -->
   <xsl:include href="../core/constants.xsl"/>

   <!--
     Embeds an SVG diagram for a schema element.
     Param(s):
            elementName (String) required
                Name of the element
            diagramsPath (String) optional
                Path to diagrams directory, default is "diagrams/"
   -->
   <xsl:template name="EmbedSVGDiagram">
      <xsl:param name="elementName"/>
      <xsl:param name="diagramsPath">diagrams/</xsl:param>

      <xsl:variable name="svgPath">
         <xsl:call-template name="GetSVGPath">
            <xsl:with-param name="elementName" select="$elementName"/>
            <xsl:with-param name="diagramsPath" select="$diagramsPath"/>
         </xsl:call-template>
      </xsl:variable>

      <object data="{$svgPath}" type="image/svg+xml"></object>
   </xsl:template>

   <!--
     Constructs the path to an SVG diagram file.
     Param(s):
            elementName (String) required
                Name of the element
            diagramsPath (String) optional
                Path to diagrams directory
   -->
   <xsl:template name="GetSVGPath">
      <xsl:param name="elementName"/>
      <xsl:param name="diagramsPath">diagrams/</xsl:param>
      <xsl:value-of select="concat($diagramsPath, $elementName, '.svg')"/>
   </xsl:template>

</xsl:stylesheet>