<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xsd="http://www.w3.org/2001/XMLSchema"
 version="1.0">

   <!-- ******** Global Parameters ******** -->

   <!-- Title of HTML document. -->
   <xsl:param name="title"></xsl:param>

   <!-- If 'true', sorts the top-level schema components by type,
        then name. Otherwise, displays the components by the order that
        they appear in the schema. -->
   <xsl:param name="sortByComponent">true</xsl:param>

   <!-- If 'true', prints all super-types in the
        type hierarchy box.
        Otherwise, prints the parent type only in the
        type hierarchy box. -->
   <xsl:param name="printAllSuperTypes">true</xsl:param>

   <!-- If 'true', prints all sub-types in the
        type hierarchy box.
        Otherwise, prints the direct sub-types only in the
        type hierarchy box. -->
   <xsl:param name="printAllSubTypes">true</xsl:param>

   <!-- If 'true', prints out the Glossary section. -->
   <xsl:param name="printGlossary">true</xsl:param>

   <!-- If 'true', prints prefix matching namespace of schema
        components in XML Instance Representation tables. -->
   <xsl:param name="printNSPrefixes">true</xsl:param>

   <!-- If 'true', searches 'included' schemas for schema components
        when generating links and XML Instance Representation tables. -->
   <xsl:param name="searchIncludedSchemas">false</xsl:param>

   <!-- If 'true', searches 'imported' schemas for schema components
        when generating links and XML Instance Representation tables. -->
   <xsl:param name="searchImportedSchemas">false</xsl:param>

   <!-- File containing the mapping from file locations of external
        (e.g. included, imported, refined) schemas to file locations
        of their XHTML documentation. -->
   <xsl:param name="linksFile"></xsl:param>

   <!-- Set the base URL for resolving links. -->
   <xsl:param name="baseURL"></xsl:param>

   <!-- Uses an external CSS stylesheet rather than using
        internally-declared CSS properties. This refers to xs3p
        specific CSS, not the Bootstrap CSS. -->
   <xsl:param name="externalCSSURL"></xsl:param>

   <!-- Link to JQuery. -->
   <xsl:param name="jQueryURL">https://cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js</xsl:param>

   <!-- Link base to Bootstrap CSS and JS. The files
        <bootstrapURL>/css/bootstrap.min.css and
        <bootstrapURL>/js/bootstrap.min.js must exist.-->
   <xsl:param name="bootstrapURL">https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.4.1</xsl:param> <!--  -->

</xsl:stylesheet>