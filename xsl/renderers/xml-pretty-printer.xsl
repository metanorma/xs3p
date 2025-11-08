<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!--
  XS3P Rendering Module: XML Pretty Printer
  This module contains templates for displaying XML content.
-->
<xsl:stylesheet
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns="http://www.w3.org/1999/xhtml"
 xmlns:html="http://www.w3.org/1999/xhtml"
 xmlns:xsd="http://www.w3.org/2001/XMLSchema"
 version="1.0">

   <!-- Dependencies -->
   <xsl:include href="../core/constants.xsl"/>
   <xsl:include href="../utils/namespaces.xsl"/>

   <!-- ******** XML Pretty Printer ******** -->

   <!--
     Puts XHTML elements into the result.
     -->
   <xsl:template match="html:*" mode="html">
      <xsl:element name="{local-name(.)}">
         <xsl:for-each select="@*">
            <xsl:copy-of select="."/>
         </xsl:for-each>
         <xsl:apply-templates select="* | text()" mode="html"/>
      </xsl:element>
   </xsl:template>

   <!--
     Displays non-XHTML elements found within XHTML elements.
     -->
   <xsl:template match="*" mode="html">
      <xsl:call-template name="WriteElement">
         <xsl:with-param name="element" select="."/>
         <xsl:with-param name="mode">html</xsl:with-param>
      </xsl:call-template>
   </xsl:template>

   <!--
     Displays text node.
     -->
   <xsl:template match="text()" mode="html">
      <xsl:value-of select="."/>
   </xsl:template>

   <!--
     Displays an arbitrary XML element.
     -->
   <xsl:template match="*" mode="xpp">
      <code class="test">
         <xsl:call-template name="WriteElement">
            <xsl:with-param name="element" select="."/>
            <xsl:with-param name="mode">xpp</xsl:with-param>
         </xsl:call-template>
      </code>
   </xsl:template>

   <!--
     Displays an arbitrary XML text node.
     -->
   <xsl:template match="text()" mode="xpp">
      <xsl:value-of select="."/>
   </xsl:template>

   <!--
     Displays an XML comment.
     -->
   <xsl:template match="comment()" mode="xpp">
      <span class="comment">
         <xsl:text>&lt;--</xsl:text>
         <xsl:value-of select="."/>
         <xsl:text>--&gt;</xsl:text>
      </span>
   </xsl:template>

   <!--
     Displays an XML element in the documentation, e.g.
     tags are escaped.
     Param(s):
            element (Node) required
                XML element to display
            mode (xpp|html) required
                Which mode to invoke for child elements
     -->
   <xsl:template name="WriteElement">
      <xsl:param name="element"/>
      <xsl:param name="mode">xpp</xsl:param>

      <!-- Start Tag -->
      <xsl:text>&lt;</xsl:text>
      <xsl:call-template name="PrintNSPrefix">
         <xsl:with-param name="prefix">
            <xsl:call-template name="GetRefPrefix">
               <xsl:with-param name="ref" select="name($element)"/>
            </xsl:call-template>
         </xsl:with-param>
      </xsl:call-template>
      <xsl:value-of select="local-name($element)"/>
      <!-- Attributes -->
      <xsl:for-each select="$element/@*">
         <xsl:text> </xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:text>="</xsl:text>
         <xsl:value-of select="."/>
         <xsl:text>"</xsl:text>
      </xsl:for-each>

      <xsl:choose>
         <xsl:when test="$element/* | $element/text()">
            <!-- Close Start Tag -->
            <xsl:text>> </xsl:text>
            <!-- Content -->
            <xsl:choose>
               <xsl:when test="$mode!='xpp'">
                  <xsl:apply-templates select="$element/* | $element/text()" mode="html"/>
               </xsl:when>
               <xsl:otherwise>
                  <div class="fakeclass3" style="margin-left: {$ELEM_INDENT}em">
                     <xsl:apply-templates select="$element/* | $element/text()" mode="xpp"/>
                  </div>
               </xsl:otherwise>
            </xsl:choose>
            <!-- End Tag -->
            <xsl:text>&lt;/</xsl:text>
            <xsl:call-template name="PrintNSPrefix">
               <xsl:with-param name="prefix">
                  <xsl:call-template name="GetRefPrefix">
                     <xsl:with-param name="ref" select="name($element)"/>
                  </xsl:call-template>
               </xsl:with-param>
            </xsl:call-template>
            <xsl:value-of select="local-name($element)"/>
            <xsl:text>></xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <!-- Close Start Tag -->
            <xsl:text>/></xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

</xsl:stylesheet>