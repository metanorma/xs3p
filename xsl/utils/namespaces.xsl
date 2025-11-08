<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!--
  XS3P Utility Module: Namespace Handling
  This module contains templates for printing namespace prefixes and references.
-->
<xsl:stylesheet
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns="http://www.w3.org/1999/xhtml"
 xmlns:xsd="http://www.w3.org/2001/XMLSchema"
 version="1.0">

   <!-- Include dependencies -->
   <xsl:include href="../core/constants.xsl"/>
   <xsl:include href="../core/parameters.xsl"/>
   <xsl:include href="references.xsl"/>

   <!--
     Prints out a link to the namespace of a prefix,
     and tacks on a colon in the end.
     Param(s):
            prefix (String) required
                Namespace prefix
            nolink (boolean) optional
                If true, doesn't provide a link to the
                namespace in the namespaces table.
            schemaLoc (String) optional
                Schema file containing this namespace prefix;
                if in current schema, 'schemaLoc' is set to 'this'
     -->
   <xsl:template name="PrintNSPrefix">
      <xsl:param name="prefix"/>
      <xsl:param name="nolink">false</xsl:param>
      <xsl:param name="schemaLoc">this</xsl:param>

      <xsl:if test="$prefix!='' and normalize-space(translate($printNSPrefixes,'TRUE','true'))='true'">
         <xsl:choose>
            <xsl:when test="$nolink='false'">
               <xsl:call-template name="PrintNamespaceRef">
                  <xsl:with-param name="prefix" select="$prefix"/>
                  <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
               </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$prefix"/>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:text>:</xsl:text>
      </xsl:if>
   </xsl:template>

   <!--
     Prints out a reference to a namespace in the schema.
     Param(s):
            prefix (String) required
              Namespace prefix referenced
            schemaLoc (String) optional
                Schema file containing this namespace prefix;
                if in current schema, 'schemaLoc' is set to 'this'
     -->
   <xsl:template name="PrintNamespaceRef">
      <xsl:param name="prefix"/>
      <xsl:param name="schemaLoc">this</xsl:param>

      <xsl:if test="$prefix!=''">
         <xsl:choose>
            <xsl:when test="/xsd:schema/namespace::*[local-name(.)=normalize-space($prefix)]">
               <xsl:variable name="link">
                  <xsl:if test="normalize-space($schemaLoc)!='this'">
                     <xsl:call-template name="GetSchemaDocLocation">
                        <xsl:with-param name="uri" select="$schemaLoc"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:value-of select="concat('#', $NS_PREFIX, $prefix)"/>
               </xsl:variable>
               <a href="{$link}" title="Find out namespace of '{$prefix}' prefix">
                  <xsl:value-of select="$prefix"/>
               </a>
            </xsl:when>
            <xsl:otherwise>
               <xsl:variable name="title">
                  <xsl:text>Unknown namespace prefix, </xsl:text>
                  <xsl:value-of select="$prefix"/>
                  <xsl:text>.</xsl:text>
               </xsl:variable>
               <a href="javascript:void(0)" onclick="alert('{$title}')" title="{$title}">
                  <xsl:value-of select="$prefix"/>
               </a>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>
   </xsl:template>

</xsl:stylesheet>