<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!--
  XS3P Utility Module: Schema Location and Component Finding
  This module contains templates for locating components across schemas.
-->
<xsl:stylesheet
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns="http://www.w3.org/1999/xhtml"
 xmlns:xsd="http://www.w3.org/2001/XMLSchema"
 xmlns:ppp="http://titanium.dstc.edu.au/xml/xs3p"
 version="1.0">

   <!-- Include dependencies -->
   <xsl:include href="../core/parameters.xsl"/>
   <xsl:include href="references.xsl"/>

   <!-- ******** Templates for Finding Components in Different Schema documents ******** -->

   <!-- Special key words: xml, xsd, this, none -->
   <xsl:template name="FindComponent">
      <xsl:param name="ref"/>
      <xsl:param name="compType"/>

      <!-- Get local name -->
      <xsl:variable name="refName">
         <xsl:call-template name="GetRefName">
            <xsl:with-param name="ref" select="$ref"/>
         </xsl:call-template>
      </xsl:variable>

      <!-- Get prefix -->
      <xsl:variable name="refPrefix">
         <xsl:call-template name="GetRefPrefix">
            <xsl:with-param name="ref" select="$ref"/>
         </xsl:call-template>
      </xsl:variable>

      <!-- Get prefix of this schema's target namespace -->
      <xsl:variable name="tnPrefix">
         <xsl:call-template name="GetThisPrefix"/>
      </xsl:variable>

      <!-- Get prefix of XML Schema -->
      <xsl:variable name="xsdPrefix">
         <xsl:call-template name="GetXSDPrefix"/>
      </xsl:variable>

      <xsl:choose>
         <!-- Schema component from XML Schema's namespace,
              unless this schema is for XML Schema -->
         <xsl:when test="$refPrefix=$xsdPrefix and $xsdPrefix!=$tnPrefix">
            <xsl:text>xsd</xsl:text>
         </xsl:when>
         <!-- Schema component from XML's namespace -->
         <xsl:when test="$refPrefix='xml'">
            <xsl:text>xml</xsl:text>
         </xsl:when>
         <!-- Schema component from current schema's namespace -->
         <xsl:when test="$refPrefix=$tnPrefix">
            <xsl:call-template name="FindComponentInSchema">
               <xsl:with-param name="name" select="$refName"/>
               <xsl:with-param name="compType" select="$compType"/>
               <xsl:with-param name="schema" select="/xsd:schema"/>
               <xsl:with-param name="schemaFileLoc">this</xsl:with-param>
            </xsl:call-template>
         </xsl:when>
         <!-- Schema component from imported namespace -->
         <xsl:when test="normalize-space(translate($searchImportedSchemas, 'TRUE', 'true'))='true'">
            <xsl:variable name="refNS" select="/xsd:schema/namespace::*[local-name(.)=normalize-space($refPrefix)]"/>
            <xsl:call-template name="FindComponentInImportedSchemas">
               <xsl:with-param name="name" select="$refName"/>
               <xsl:with-param name="compType" select="$compType"/>
               <xsl:with-param name="compNS" select="$refNS"/>
               <xsl:with-param name="schema" select="/xsd:schema"/>
               <xsl:with-param name="index">1</xsl:with-param>
            </xsl:call-template>
         </xsl:when>
      </xsl:choose>
   </xsl:template>

   <xsl:template name="FindComponentInSchema">
      <xsl:param name="name"/>
      <xsl:param name="compType"/>
      <xsl:param name="schema"/>
      <xsl:param name="schemaFileLoc"/>
      <xsl:param name="schemasSearched"/>

      <!-- Don't examine this schema if we've already
           searched it. Prevents infinite recursion.
           Also check if schema actually exists. -->
      <xsl:if test="$schema and not(contains($schemasSearched, concat('*', $schemaFileLoc, '+')))">
         <!-- Find out if the component is in this schema -->
         <xsl:variable name="thisResult">
            <xsl:call-template name="IsComponentInSchema">
               <xsl:with-param name="name" select="$name"/>
               <xsl:with-param name="compType" select="$compType"/>
               <xsl:with-param name="schema" select="$schema"/>
            </xsl:call-template>
         </xsl:variable>

         <xsl:choose>
            <!-- Component found -->
            <xsl:when test="normalize-space($thisResult)='true'">
               <xsl:value-of select="$schemaFileLoc"/>
            </xsl:when>
            <!-- Component not found -->
            <xsl:when test="normalize-space(translate($searchIncludedSchemas, 'TRUE', 'true'))='true'">
               <!-- Search included schemas -->
               <xsl:variable name="includeResult">
                  <xsl:call-template name="FindComponentInIncludedSchemas">
                     <xsl:with-param name="schema" select="$schema"/>
                     <xsl:with-param name="name" select="$name"/>
                     <xsl:with-param name="compType" select="$compType"/>
                     <xsl:with-param name="index">1</xsl:with-param>
                     <xsl:with-param name="schemasSearched" select="concat($schemasSearched, '*', $schemaFileLoc, '+')"/>
                  </xsl:call-template>
               </xsl:variable>

               <xsl:choose>
                  <xsl:when test="normalize-space($includeResult)!='' and normalize-space($includeResult)!='none'">
                     <xsl:value-of select="$includeResult"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <!-- Search redefined schemas -->
                     <xsl:call-template name="FindComponentInRedefinedSchemas">
                        <xsl:with-param name="schema" select="$schema"/>
                        <xsl:with-param name="name" select="$name"/>
                        <xsl:with-param name="compType" select="$compType"/>
                        <xsl:with-param name="index">1</xsl:with-param>
                        <xsl:with-param name="schemasSearched" select="concat($schemasSearched, '*', $schemaFileLoc, '+')"/>
                     </xsl:call-template>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:when>
         </xsl:choose>
      </xsl:if>
   </xsl:template>

   <xsl:template name="IsComponentInSchema">
      <xsl:param name="name"/>
      <xsl:param name="compType"/>
      <xsl:param name="schema"/>

      <xsl:choose>
         <!-- Schema not found. -->
         <xsl:when test="not($schema)">
            <xsl:text>false</xsl:text>
         </xsl:when>
         <!-- Search for attribute declaration. -->
         <xsl:when test="$compType='attribute' and $schema/xsd:attribute[@name=$name]">
            <xsl:text>true</xsl:text>
         </xsl:when>
         <!-- Search for attribute group definition. -->
         <xsl:when test="$compType='attribute group' and ($schema/xsd:attributeGroup[@name=$name] or $schema/xsd:redefine/xsd:attributeGroup[@name=$name])">
            <xsl:text>true</xsl:text>
         </xsl:when>
         <!-- Search for element declaration. -->
         <xsl:when test="$compType='element' and $schema/xsd:element[@name=$name]">
            <xsl:text>true</xsl:text>
         </xsl:when>
         <!-- Search for group definition. -->
         <xsl:when test="$compType='group' and ($schema/xsd:group[@name=$name] or $schema/xsd:redefine/xsd:group[@name=$name])">
            <xsl:text>true</xsl:text>
         </xsl:when>
         <!-- Search for complex type definition. -->
         <xsl:when test="($compType='type' or $compType='complex type') and ($schema/xsd:complexType[@name=$name] or $schema/xsd:redefine/xsd:complexType[@name=$name])">
            <xsl:text>true</xsl:text>
         </xsl:when>
         <!-- Search for simple type definition. -->
         <xsl:when test="($compType='type' or $compType='simple type') and ($schema/xsd:simpleType[@name=$name] or $schema/xsd:redefine/xsd:simpleType[@name=$name])">
            <xsl:text>true</xsl:text>
         </xsl:when>
         <!-- Search for uniqueness/key constraint definition. -->
         <xsl:when test="$compType='uniqueness/key constraint' and ($schema//xsd:element/xsd:key[@name=$name] or $schema//xsd:element/xsd:unique[@name=$name])">
            <xsl:text>true</xsl:text>
         </xsl:when>
         <!-- Component not found. -->
         <xsl:otherwise>
            <xsl:text>false</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template name="FindComponentInIncludedSchemas">
      <xsl:param name="schema"/>
      <xsl:param name="name"/>
      <xsl:param name="compType"/>
      <xsl:param name="schemasSearched"/>
      <xsl:param name="index">1</xsl:param>

      <xsl:if test="count($schema/xsd:include) &gt;= number($index)">
         <!-- Get the 'schemaLocation' attribute of the 'include'
              element in this schema at position, 'index'. -->
         <xsl:variable name="schemaLoc" select="$schema/xsd:include[position()=$index]/@schemaLocation"/>

         <xsl:variable name="thisResult">
            <!-- Search for the component in the current
                 included schema. -->
            <xsl:call-template name="FindComponentInSchema">
               <xsl:with-param name="name" select="$name"/>
               <xsl:with-param name="compType" select="$compType"/>
               <xsl:with-param name="schema" select="document($schemaLoc)/xsd:schema"/>
               <xsl:with-param name="schemaFileLoc" select="$schemaLoc"/>
               <xsl:with-param name="schemasSearched" select="$schemasSearched"/>
            </xsl:call-template>
         </xsl:variable>

         <xsl:choose>
            <!-- Component was found, so return result. -->
            <xsl:when test="normalize-space($thisResult)!='' and normalize-space($thisResult)!='none'">
               <xsl:value-of select="$thisResult"/>
            </xsl:when>
            <!-- Component was not found, so keep on searching. -->
            <xsl:otherwise>
               <!-- Examine other included schemas in this schema -->
               <xsl:call-template name="FindComponentInIncludedSchemas">
                  <xsl:with-param name="schema" select="$schema"/>
                  <xsl:with-param name="name" select="$name"/>
                  <xsl:with-param name="compType" select="$compType"/>
                  <xsl:with-param name="index" select="number($index)+1"/>
                  <xsl:with-param name="schemasSearched" select="concat($schemasSearched, '*', $schemaLoc, '+')"/>
               </xsl:call-template>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>
   </xsl:template>

   <xsl:template name="FindComponentInRedefinedSchemas">
      <xsl:param name="schema"/>
      <xsl:param name="name"/>
      <xsl:param name="compType"/>
      <xsl:param name="schemasSearched"/>
      <xsl:param name="index">1</xsl:param>

      <xsl:if test="count($schema/xsd:redefine) &gt;= number($index)">
         <!-- Get the 'schemaLocation' attribute of the 'redefine'
              element in this schema at position, 'index'. -->
         <xsl:variable name="schemaLoc" select="$schema/xsd:redefine[position()=$index]/@schemaLocation"/>

         <xsl:variable name="thisResult">
            <!-- Search for the component in the current
                 redefined schema. -->
            <xsl:call-template name="FindComponentInSchema">
               <xsl:with-param name="name" select="$name"/>
               <xsl:with-param name="compType" select="$compType"/>
               <xsl:with-param name="schema" select="document($schemaLoc)/xsd:schema"/>
               <xsl:with-param name="schemaFileLoc" select="$schemaLoc"/>
               <xsl:with-param name="schemasSearched" select="$schemasSearched"/>
            </xsl:call-template>
         </xsl:variable>

         <xsl:choose>
            <!-- Component was found, so return result. -->
            <xsl:when test="normalize-space($thisResult)!='' and normalize-space($thisResult)!='none'">
               <xsl:value-of select="$thisResult"/>
            </xsl:when>
            <!-- Component was not found, so keep on searching. -->
            <xsl:otherwise>
               <!-- Examine other redefined schemas in this schema -->
               <xsl:call-template name="FindComponentInRedefinedSchemas">
                  <xsl:with-param name="schema" select="$schema"/>
                  <xsl:with-param name="name" select="$name"/>
                  <xsl:with-param name="compType" select="$compType"/>
                  <xsl:with-param name="index" select="number($index)+1"/>
                  <xsl:with-param name="schemasSearched" select="concat($schemasSearched, '*', $schemaLoc, '+')"/>
               </xsl:call-template>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>
   </xsl:template>

   <xsl:template name="FindComponentInImportedSchemas">
      <xsl:param name="schema"/>
      <xsl:param name="name"/>
      <xsl:param name="compType"/>
      <xsl:param name="compNS"/>
      <xsl:param name="schemasSearched"/>
      <xsl:param name="index">1</xsl:param>

      <xsl:if test="count($schema/xsd:import) &gt;= number($index)">
         <!-- Get the 'namespace' attribute of the 'import'
              element in this schema at position, 'index'. -->
         <xsl:variable name="schemaNS" select="$schema/xsd:import[position()=$index]/@namespace"/>
         <!-- Get the 'schemaLocation' attribute. -->
         <xsl:variable name="schemaLoc" select="$schema/xsd:import[position()=$index]/@schemaLocation"/>

         <xsl:variable name="thisResult">
            <!-- Check that the imported schema has the matching
                 namespace as the component that we're looking
                 for. -->
            <xsl:if test="normalize-space($compNS)=normalize-space($schemaNS)">
               <!-- Search for the component in the current
                    imported schema. -->
               <xsl:call-template name="FindComponentInSchema">
                  <xsl:with-param name="name" select="$name"/>
                  <xsl:with-param name="compType" select="$compType"/>
                  <xsl:with-param name="schema" select="document($schemaLoc)/xsd:schema"/>
                  <xsl:with-param name="schemaFileLoc" select="$schemaLoc"/>
                  <xsl:with-param name="schemasSearched" select="$schemasSearched"/>
               </xsl:call-template>
            </xsl:if>
         </xsl:variable>

         <xsl:choose>
            <!-- Component was found, so return result. -->
            <xsl:when test="normalize-space($thisResult)!='' and normalize-space($thisResult)!='none'">
               <xsl:value-of select="$thisResult"/>
            </xsl:when>
            <!-- Component was not found, so keep on searching. -->
            <xsl:otherwise>
               <!-- Examine other included schemas in this schema -->
               <xsl:call-template name="FindComponentInImportedSchemas">
                  <xsl:with-param name="schema" select="$schema"/>
                  <xsl:with-param name="name" select="$name"/>
                  <xsl:with-param name="compType" select="$compType"/>
                  <xsl:with-param name="compNS" select="$compNS"/>
                  <xsl:with-param name="index" select="number($index)+1"/>
                  <xsl:with-param name="schemasSearched" select="concat($schemasSearched, '*', $schemaLoc, '+')"/>
               </xsl:call-template>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>
   </xsl:template>

   <!--
     Returns the schema documentation file location for a
     given URI for a schema, done by looking up the file
     specified in 'linksFile' variable.
     It'll throw a fatal error if a value for 'linksFile' was
     provided and the documentation file for 'uri' could not be
     found.
     Param(s):
            uri (String) required
              Location of schema file
     -->
   <xsl:template name="GetSchemaDocLocation">
      <xsl:param name="uri"/>

      <xsl:if test="$linksFile!=''">
         <xsl:variable name="schemaDocFile" select="document($linksFile)/ppp:links/ppp:schema[@file-location=$uri]/@docfile-location"/>
         <xsl:if test="$schemaDocFile=''">
            <xsl:call-template name="HandleError">
               <xsl:with-param name="isTerminating">true</xsl:with-param>
               <xsl:with-param name="errorMsg">
Documentation file for the schema at, <xsl:value-of select="$uri"/>,
was not specified in the links file, <xsl:value-of select="$linksFile"/>.
               </xsl:with-param>
            </xsl:call-template>
         </xsl:if>
         <xsl:value-of select="$schemaDocFile"/>
      </xsl:if>
   </xsl:template>

</xsl:stylesheet>