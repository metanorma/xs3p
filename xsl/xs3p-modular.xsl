<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!--
  Copyright (C) DSTC Pty Ltd (ACN 052 372 577) 2002

  MODULAR VERSION OF XS3P

  This is the modular entry point for the xs3p stylesheet.
  All logic has been extracted into specialized modules organized by architectural layer.
  This file serves only as an orchestration layer that includes all modules in proper order.
-->
<xsl:stylesheet
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns="http://www.w3.org/1999/xhtml"
 xmlns:html="http://www.w3.org/1999/xhtml"
 xmlns:xsd="http://www.w3.org/2001/XMLSchema"
 xmlns:ppp="http://titanium.dstc.edu.au/xml/xs3p"
 xmlns:exslt="http://exslt.org/common"
 version="1.0"
 exclude-result-prefixes="xsd ppp html">

   <xsl:output
    method="html"
    omit-xml-declaration="yes"
    doctype-system="about:legacy-compat"
    indent="yes"/>

   <!-- ******** Core Foundation Modules ******** -->
   <!-- Fundamental building blocks: parameters, constants, and keys -->
   <xsl:include href="core/parameters.xsl"/>
   <xsl:include href="core/constants.xsl"/>
   <xsl:include href="core/keys.xsl"/>

   <!-- ******** Utility Modules ******** -->
   <!-- Helper templates for common operations -->
   <xsl:include href="utils/common-helpers.xsl"/>
   <xsl:include href="utils/strings.xsl"/>
   <xsl:include href="utils/namespaces.xsl"/>
   <xsl:include href="utils/references.xsl"/>
   <xsl:include href="utils/schema-location.xsl"/>

   <!-- ******** Rendering Engine Modules ******** -->
   <!-- Low-level output formatters -->
   <xsl:include href="renderers/xml-pretty-printer.xsl"/>
   <xsl:include href="renderers/glossary.xsl"/>
   <xsl:include href="renderers/ui-components.xsl"/>

   <!-- ******** Content Generator Modules ******** -->
   <!-- High-level content generation for specific schema aspects -->
   <xsl:include href="generators/component-links.xsl"/>
   <xsl:include href="generators/hierarchy-tables.xsl"/>
   <xsl:include href="generators/properties-facets.xsl"/>
   <xsl:include href="generators/properties-tables.xsl"/>
   <xsl:include href="generators/instance-samples-types.xsl"/>
   <xsl:include href="generators/instance-samples-elements.xsl"/>
   <xsl:include href="generators/instance-samples-attributes.xsl"/>
   <xsl:include href="generators/instance-samples-groups.xsl"/>
   <xsl:include href="generators/schema-components.xsl"/>
   <xsl:include href="generators/svg-diagrams.xsl"/>

   <!-- ******** Presentation Layer Modules ******** -->
   <!-- Top-level document orchestration and presentation (depends on all above) -->
   <xsl:include href="presentation/css-styles.xsl"/>
   <xsl:include href="presentation/javascript.xsl"/>
   <xsl:include href="presentation/navigation.xsl"/>
   <xsl:include href="presentation/html-document.xsl"/>

</xsl:stylesheet>
