<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!--
  XS3P Utility Module: Component References
  This module contains templates for extracting component names, prefixes, and namespaces.
-->
<xsl:stylesheet
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns="http://www.w3.org/1999/xhtml"
 xmlns:xsd="http://www.w3.org/2001/XMLSchema"
 version="1.0">

   <!-- Include core constants for XSD_NS -->
   <xsl:include href="../core/constants.xsl"/>

   <!--
     Returns the namespace of an attribute
     declaration or reference.
     Param(s):
            attribute (Node) required
                Attribute declaration or reference
     -->
   <xsl:template name="GetAttributeNS">
      <xsl:param name="attribute"/>

      <xsl:choose>
         <!-- Qualified local attribute declaration -->
         <xsl:when test="$attribute[@name] and (normalize-space(translate($attribute/@form, 'QUALIFED', 'qualifed'))='qualified' or normalize-space(translate(/xsd:schema/@attributeFormDefault, 'QUALIFED', 'qualifed'))='qualified')">
            <xsl:value-of select="/xsd:schema/@targetNamespace"/>
         </xsl:when>
         <!-- Reference to global attribute declaration -->
         <xsl:when test="$attribute[@ref]">
            <xsl:call-template name="GetRefNS">
               <xsl:with-param name="ref" select="$attribute/@ref"/>
            </xsl:call-template>
         </xsl:when>
         <!-- Otherwise, attribute has no namespace -->
      </xsl:choose>
   </xsl:template>

   <!--
     Returns the namespace prefix of an attribute.
     Param(s):
            attribute (Node) required
                Attribute declaration or reference
     -->
   <xsl:template name="GetAttributePrefix">
      <xsl:param name="attribute"/>

      <xsl:choose>
         <!-- Element reference -->
         <xsl:when test="$attribute/@ref">
            <xsl:call-template name="GetRefPrefix">
               <xsl:with-param name="ref" select="$attribute/@ref"/>
            </xsl:call-template>
         </xsl:when>
         <!-- Global element declaration -->
         <xsl:when test="local-name($attribute/..)='schema'">
            <xsl:call-template name="GetThisPrefix"/>
         </xsl:when>
         <!-- Local element declaration -->
         <xsl:otherwise>
            <xsl:if test="($attribute/@form and normalize-space($attribute/@form)='qualified') or (/xsd:schema/@attributeFormDefault and normalize-space(/xsd:schema/@attributeFormDefault)='qualified')">
               <xsl:call-template name="GetThisPrefix"/>
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--
     Returns the namespace prefix of an element.
     Param(s):
            element (Node) required
                Element declaration or reference
     -->
   <xsl:template name="GetElementPrefix">
      <xsl:param name="element"/>

      <xsl:choose>
         <!-- Element reference -->
         <xsl:when test="$element/@ref">
            <xsl:call-template name="GetRefPrefix">
               <xsl:with-param name="ref" select="$element/@ref"/>
            </xsl:call-template>
         </xsl:when>
         <!-- Global element declaration -->
         <xsl:when test="local-name($element/..)='schema'">
            <xsl:call-template name="GetThisPrefix"/>
         </xsl:when>
         <!-- Local element declaration -->
         <xsl:otherwise>
            <xsl:if test="($element/@form and normalize-space($element/@form)='qualified') or (/xsd:schema/@elementFormDefault and normalize-space(/xsd:schema/@elementFormDefault)='qualified')">
               <xsl:call-template name="GetThisPrefix"/>
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--
     Returns the local name of a reference.
     Param(s):
            ref (String) required
                Reference
     -->
   <xsl:template name="GetRefName">
      <xsl:param name="ref"/>

      <xsl:choose>
         <xsl:when test="contains($ref, ':')">
            <!-- Ref has namespace prefix -->
            <xsl:value-of select="substring-after($ref, ':')"/>
         </xsl:when>
         <xsl:otherwise>
            <!-- Ref has no namespace prefix -->
            <xsl:value-of select="$ref"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--
     Returns the namespace prefix of a reference.
     Param(s):
            ref (String) required
                Reference
     -->
   <xsl:template name="GetRefPrefix">
      <xsl:param name="ref"/>
      <!-- Get namespace prefix -->
      <xsl:value-of select="substring-before($ref, ':')"/>
   </xsl:template>

   <!--
     Returns the namespace of a reference.
     Param(s):
            ref (String) required
                Reference
     -->
   <xsl:template name="GetRefNS">
      <xsl:param name="ref"/>
      <!-- Get namespace prefix -->
      <xsl:variable name="refPrefix" select="substring-before($ref, ':')"/>
      <!-- Get namespace -->
      <xsl:value-of select="/xsd:schema/namespace::*[local-name(.)=normalize-space($refPrefix)]"/>
   </xsl:template>

   <!--
     Returns the declared prefix of this schema's target namespace.
     -->
   <xsl:template name="GetThisPrefix">
      <xsl:if test="/xsd:schema/@targetNamespace">
         <xsl:value-of select="local-name(/xsd:schema/namespace::*[normalize-space(.)=normalize-space(/xsd:schema/@targetNamespace)])"/>
      </xsl:if>
   </xsl:template>

   <!--
     Returns the declared prefix of XML Schema namespace.
     -->
   <xsl:template name="GetXSDPrefix">
      <xsl:value-of select="local-name(/xsd:schema/namespace::*[normalize-space(.)=$XSD_NS])"/>
   </xsl:template>

</xsl:stylesheet>