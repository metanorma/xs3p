<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xsd="http://www.w3.org/2001/XMLSchema"
 version="1.0">

   <!-- ******** Constants ******** -->

   <!-- XML Schema Namespace -->
   <xsl:variable name="XSD_NS">http://www.w3.org/2001/XMLSchema</xsl:variable>

   <!-- XML Namespace -->
   <xsl:variable name="XML_NS">http://www.w3.org/XML/1998/namespace</xsl:variable>

   <!-- Number of spaces to indent from parent element's start tag to
        child element's start tag -->
   <xsl:variable name="ELEM_INDENT">3</xsl:variable>

   <!-- Number of spaces to indent from parent element's start tag to
        attribute's tag -->
   <xsl:variable name="ATTR_INDENT">1</xsl:variable>

   <!-- Title to use if none provided -->
   <xsl:variable name="DEFAULT_TITLE">XML Schema Documentation</xsl:variable>

   <!-- Prefixes used for anchor names -->
      <!-- Type definitions -->
   <xsl:variable name="TYPE_PREFIX">type_</xsl:variable>
      <!-- Attribute declarations -->
   <xsl:variable name="ATTR_PREFIX">attribute_</xsl:variable>
      <!-- Attribute group definitions -->
   <xsl:variable name="ATTR_GRP_PREFIX">attributeGroup_</xsl:variable>
      <!-- Complex type definitions -->
   <xsl:variable name="CTYPE_PREFIX" select="$TYPE_PREFIX"/>
      <!-- Element declarations -->
   <xsl:variable name="ELEM_PREFIX">element_</xsl:variable>
      <!-- Key definitions -->
   <xsl:variable name="KEY_PREFIX">key_</xsl:variable>
      <!-- Group definitions -->
   <xsl:variable name="GRP_PREFIX">group_</xsl:variable>
      <!-- Notations -->
   <xsl:variable name="NOTA_PREFIX">notation_</xsl:variable>
      <!-- Namespace declarations -->
   <xsl:variable name="NS_PREFIX">ns_</xsl:variable>
      <!-- Simple type definitions -->
   <xsl:variable name="STYPE_PREFIX" select="$TYPE_PREFIX"/>
      <!-- Glossary terms -->
   <xsl:variable name="TERM_PREFIX">term_</xsl:variable>

   <!-- The original schema needs to be stored because when
        calculating links for references, the links have to be
        relative to the original schema. See 'PrintCompRef'
        template. -->
   <xsl:variable name="ORIGINAL_SCHEMA" select="/xsd:schema"/>

   <!-- Help texts used throughout the document. -->
      <!-- Hierarchy table -->
   <xsl:variable name="HELP_HIERARCHY">This table shows the schema components type hierarchy.</xsl:variable>
      <!-- Properties table -->
   <xsl:variable name="HELP_PROPERTIES">This table displays the properties of the schema component.</xsl:variable>
      <!-- Documentation panel -->
   <xsl:variable name="HELP_DOCUMENTATION">This panel contains the schema components documentation.</xsl:variable>
      <!-- Instance table -->
   <xsl:variable name="HELP_INSTANCE">
      <xsl:text>The XML Instance Representation table shows the schema component's content as an XML instance.
         &lt;ul&gt;
         &lt;li&gt;The minimum and maximum occurrence of elements and attributes are provided in square brackets, e.g. [0..1].&lt;/li&gt;
         &lt;li&gt;Model group information are shown in gray, e.g. Start Choice ... End Choice.&lt;/li&gt;
         &lt;li&gt;For type derivations, the elements and attributes that have been added to or changed from the base type's content are shown in &lt;strong&gt;bold&lt;/strong&gt;&lt;/li&gt;
         &lt;li&gt;If an element/attribute has a fixed value, the fixed value is shown in green.&lt;/li&gt;
         &lt;li&gt;More stuff&lt;/li&gt;
         &lt;li&gt;If a local element/attribute has documentation, it will be displayed in a window that pops up when the question mark inside the attribute or next to the element is clicked.&lt;/li&gt;
         &lt;/ul&gt;
      </xsl:text>
   </xsl:variable>
      <!-- Representation table -->
   <xsl:variable name="HELP_REPRESENTATION">The Schema Component Representation table below displays the underlying XML representation of the schema component. (Annotations are not shown.)</xsl:variable>

   <xsl:variable name="showCollapseableBox">false</xsl:variable>

   <xsl:variable name="nav-width">270px</xsl:variable>

</xsl:stylesheet>