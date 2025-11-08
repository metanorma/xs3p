<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!--
  XS3P Content Generator Module: Properties Table Facets
  This module contains facet printing templates for simple type constraints
  displayed in properties tables.

  Dependencies:
  - core/constants.xsl
  - utils/references.xsl (for PrintTypeRef)
  - renderers/glossary.xsl (for PrintGlossaryTermRef)
-->
<xsl:stylesheet
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns="http://www.w3.org/1999/xhtml"
 xmlns:xsd="http://www.w3.org/2001/XMLSchema"
 xmlns:ppp="http://titanium.dstc.edu.au/xml/xs3p"
 version="1.0"
 exclude-result-prefixes="xsd ppp">

   <!--
     Prints out the constraints of simple content
     to be displayed within a Properties table.
     Param(s):
            simpleContent (Node) required
                Node containing the simple content
            typeList (String) optional
                List of types in this call chain. Name of type starts
                with '*', and ends with '+'. (Used to prevent infinite
                recursive loop.)
   -->
   <xsl:template name="PrintSimpleConstraints">
      <xsl:param name="simpleContent"/>
      <xsl:param name="typeList"/>

      <xsl:choose>
         <!-- Derivation by restriction -->
         <xsl:when test="$simpleContent/xsd:restriction">
            <xsl:call-template name="PrintSimpleRestriction">
               <xsl:with-param name="restriction" select="$simpleContent/xsd:restriction"/>
               <xsl:with-param name="typeList" select="$typeList"/>
            </xsl:call-template>
         </xsl:when>
         <!-- Derivation by list -->
         <xsl:when test="$simpleContent/xsd:list">
            <ul><li>
               <xsl:text>List of: </xsl:text>
               <xsl:choose>
                  <!-- Globally-defined item type -->
                  <xsl:when test="$simpleContent/xsd:list/@itemType">
                     <xsl:call-template name="PrintTypeRef">
                        <xsl:with-param name="ref" select="$simpleContent/xsd:list/@itemType"/>
                     </xsl:call-template>
                  </xsl:when>
                  <!-- Locally-defined item type -->
                  <xsl:otherwise>
                     <ul>
                        <li>
                           <xsl:text>Locally defined type:</xsl:text>
                           <xsl:call-template name="PrintSimpleConstraints">
                              <xsl:with-param name="simpleContent" select="$simpleContent/xsd:list/xsd:simpleType"/>
                              <xsl:with-param name="typeList" select="$typeList"/>
                           </xsl:call-template>
                        </li>
                     </ul>
                  </xsl:otherwise>
               </xsl:choose>
            </li></ul>
         </xsl:when>
         <!-- Derivation by union -->
         <xsl:when test="$simpleContent/xsd:union">
            <ul><li>
               <xsl:text>Union of following types: </xsl:text>
               <ul>
                  <!-- Globally-defined member types -->
                  <xsl:if test="$simpleContent/xsd:union/@memberTypes">
                     <xsl:call-template name="PrintWhitespaceList">
                        <xsl:with-param name="value" select="$simpleContent/xsd:union/@memberTypes"/>
                        <xsl:with-param name="compType">type</xsl:with-param>
                        <xsl:with-param name="isInList">true</xsl:with-param>
                     </xsl:call-template>
                  </xsl:if>
                  <!-- Locally-defined member types -->
                  <xsl:for-each select="$simpleContent/xsd:union/xsd:simpleType">
                     <li>
                        <xsl:text>Locally defined type:</xsl:text>
                        <xsl:call-template name="PrintSimpleConstraints">
                           <xsl:with-param name="simpleContent" select="."/>
                           <xsl:with-param name="typeList" select="$typeList"/>
                        </xsl:call-template>
                     </li>
                  </xsl:for-each>
               </ul>
            </li></ul>
         </xsl:when>
      </xsl:choose>
   </xsl:template>

   <!--
     Prints out the constraints of simple content derived by
     restriction, which is to be displayed in a Properties table.
     Param(s):
            restriction (Node) required
                Node containing the restriction
            typeList (String) optional
                List of types in this call chain. Name of type starts
                with '*', and ends with '+'. (Used to prevent infinite
                recursive loop.)
   -->
   <xsl:template name="PrintSimpleRestriction">
      <xsl:param name="restriction"/>
      <xsl:param name="typeList"/>

      <xsl:variable name="typeName" select="$restriction/parent::xsd:simpleType/@name"/>

      <!-- Print out base type info -->
      <xsl:choose>
         <!-- Circular type hierarchy -->
         <xsl:when test="$typeName != '' and contains($typeList, concat('*', $typeName, '+'))">
            <xsl:call-template name="HandleError">
               <xsl:with-param name="isTerminating">false</xsl:with-param>
               <xsl:with-param name="errorMsg">
                  <xsl:text>Circular type reference to '</xsl:text>
                  <xsl:value-of select="$typeName"/>
                  <xsl:text>' in type hierarchy.</xsl:text>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:when>
         <!-- Locally-defined base type -->
         <xsl:when test="$restriction/xsd:simpleType">
            <xsl:call-template name="PrintSimpleConstraints">
               <xsl:with-param name="simpleContent" select="$restriction/xsd:simpleType"/>
               <xsl:with-param name="typeList" select="$typeList"/>
            </xsl:call-template>
         </xsl:when>
         <!-- Base type reference -->
         <xsl:when test="$restriction">
            <xsl:variable name="baseTypeRef" select="$restriction/@base"/>
            <xsl:variable name="baseTypeName">
               <xsl:call-template name="GetRefName">
                  <xsl:with-param name="ref" select="$baseTypeRef"/>
               </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="baseTypeNS">
               <xsl:call-template name="GetRefNS">
                  <xsl:with-param name="ref" select="$baseTypeRef"/>
               </xsl:call-template>
            </xsl:variable>

            <xsl:choose>
               <!-- Base type is built-in XSD type -->
               <xsl:when test="$baseTypeNS=$XSD_NS">
                  <ul><li>
                     <xsl:text>Base XSD Type: </xsl:text>
                     <xsl:choose>
                        <!-- Current schema is the schema for XSDL -->
                        <xsl:when test="normalize-space(/xsd:schema/@targetNamespace)=$XSD_NS">
                           <xsl:call-template name="PrintTypeRef">
                              <xsl:with-param name="ref" select="$baseTypeRef"/>
                           </xsl:call-template>
                        </xsl:when>
                        <!-- Current schema is not XSD namespace -->
                        <xsl:otherwise>
                           <xsl:value-of select="$baseTypeName"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </li></ul>
               </xsl:when>
               <!-- Other types -->
               <xsl:otherwise>
                  <xsl:variable name="baseType" select="key('simpleType', $baseTypeName)"/>
                  <xsl:choose>
                     <!-- Base type found -->
                     <xsl:when test="$baseType">
                        <xsl:call-template name="PrintSimpleConstraints">
                           <xsl:with-param name="simpleContent" select="$baseType"/>
                           <xsl:with-param name="typeList" select="concat($typeList, '*', $typeName, '+')"/>
                        </xsl:call-template>
                     </xsl:when>
                     <!-- Base type not found -->
                     <xsl:otherwise>
                        <ul><li><strong>
                           <xsl:text>'</xsl:text>
                           <xsl:value-of select="$baseTypeName"/>
                           <xsl:text>' super type was not found in this schema. </xsl:text>
                           <xsl:text>Its facets could not be printed out.</xsl:text>
                        </strong></li></ul>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
      </xsl:choose>

      <!-- Find constraints in current restriction -->
      <xsl:variable name="enumeration">
         <xsl:call-template name="PrintEnumFacets">
            <xsl:with-param name="simpleRestrict" select="$restriction"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="pattern">
         <xsl:call-template name="PrintPatternFacet">
            <xsl:with-param name="simpleRestrict" select="$restriction"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="range">
         <xsl:call-template name="PrintRangeFacets">
            <xsl:with-param name="simpleRestrict" select="$restriction"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="totalDigits">
         <xsl:call-template name="PrintTotalDigitsFacet">
            <xsl:with-param name="simpleRestrict" select="$restriction"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="fractionDigits">
         <xsl:call-template name="PrintFractionDigitsFacet">
            <xsl:with-param name="simpleRestrict" select="$restriction"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="length">
         <xsl:call-template name="PrintLengthFacets">
            <xsl:with-param name="simpleRestrict" select="$restriction"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="whitespace">
         <xsl:call-template name="PrintWhitespaceFacet">
            <xsl:with-param name="simpleRestrict" select="$restriction"/>
         </xsl:call-template>
      </xsl:variable>

      <!-- Print out facets -->
      <xsl:if test="$enumeration!='' or $pattern!='' or $range!='' or $totalDigits!='' or $fractionDigits!='' or $length!='' or $whitespace!=''">
         <ul>
            <xsl:if test="$enumeration!=''">
               <li>
                  <xsl:copy-of select="$enumeration"/>
               </li>
            </xsl:if>
            <xsl:if test="$pattern!=''">
               <li>
                  <xsl:copy-of select="$pattern"/>
               </li>
            </xsl:if>
            <xsl:if test="$range!=''">
               <li>
                  <xsl:copy-of select="$range"/>
               </li>
            </xsl:if>
            <xsl:if test="$totalDigits!=''">
               <li>
                  <xsl:copy-of select="$totalDigits"/>
               </li>
            </xsl:if>
            <xsl:if test="$fractionDigits!=''">
               <li>
                  <xsl:copy-of select="$fractionDigits"/>
               </li>
            </xsl:if>
            <xsl:if test="$length!=''">
               <li>
                  <xsl:copy-of select="$length"/>
               </li>
            </xsl:if>
            <xsl:if test="$whitespace!=''">
               <li>
                  <xsl:copy-of select="$whitespace"/>
               </li>
            </xsl:if>
         </ul>
      </xsl:if>
   </xsl:template>

   <!--
     Print out the enumeration list for derivations by
     restriction on simple content.
     Param(s):
            simpleRestrict (Node) required
              'restriction' element
     -->
   <xsl:template name="PrintEnumFacets">
      <xsl:param name="simpleRestrict"/>

      <xsl:if test="$simpleRestrict/xsd:enumeration">
         <em>value</em>
         <xsl:text> comes from list: {</xsl:text>

         <xsl:for-each select="$simpleRestrict/xsd:enumeration">
            <xsl:if test="position()!=1">
               <xsl:text>|</xsl:text>
            </xsl:if>
            <xsl:text>'</xsl:text>
            <xsl:value-of select="@value"/>
            <xsl:text>'</xsl:text>
         </xsl:for-each>

         <xsl:text>}</xsl:text>
      </xsl:if>
   </xsl:template>

   <!--
     Print out the pattern property for derivations by
     restriction on simple content.
     Param(s):
            simpleRestrict (Node) required
              'restriction' element
     -->
   <xsl:template name="PrintPatternFacet">
      <xsl:param name="simpleRestrict"/>

      <xsl:if test="$simpleRestrict/xsd:pattern">
         <em>pattern</em>
         <xsl:text> = </xsl:text>
         <xsl:value-of select="$simpleRestrict/xsd:pattern/@value"/>
      </xsl:if>
   </xsl:template>

   <!--
     Print out the value ranges for derivations by
     restriction on simple content.
     Param(s):
            simpleRestrict (Node) required
              'restriction' element
     -->
   <xsl:template name="PrintRangeFacets">
      <xsl:param name="simpleRestrict"/>

      <xsl:choose>
         <xsl:when test="($simpleRestrict/xsd:minInclusive or $simpleRestrict/xsd:minExclusive) and ($simpleRestrict/xsd:maxInclusive or $simpleRestrict/xsd:maxExclusive)">
            <xsl:choose>
               <xsl:when test="$simpleRestrict/xsd:minInclusive">
                  <xsl:value-of select="$simpleRestrict/xsd:minInclusive/@value"/>
                  <xsl:text> &lt;= </xsl:text>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="$simpleRestrict/xsd:minExclusive/@value"/>
                  <xsl:text> &lt; </xsl:text>
               </xsl:otherwise>
            </xsl:choose>
            <em>
               <xsl:text>value</xsl:text>
            </em>
            <xsl:choose>
               <xsl:when test="$simpleRestrict/xsd:maxInclusive">
                  <xsl:text> &lt;= </xsl:text>
                  <xsl:value-of select="$simpleRestrict/xsd:maxInclusive/@value"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:text> &lt; </xsl:text>
                  <xsl:value-of select="$simpleRestrict/xsd:maxExclusive/@value"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:when test="$simpleRestrict/xsd:minInclusive">
            <em>
               <xsl:text>value</xsl:text>
            </em>
            <xsl:text> >= </xsl:text>
            <xsl:value-of select="$simpleRestrict/xsd:minInclusive/@value"/>
         </xsl:when>
         <xsl:when test="$simpleRestrict/xsd:minExclusive">
            <em>
               <xsl:text>value</xsl:text>
            </em>
            <xsl:text> > </xsl:text>
            <xsl:value-of select="$simpleRestrict/xsd:minExclusive/@value"/>
         </xsl:when>
         <xsl:when test="$simpleRestrict/xsd:maxInclusive">
            <em>
               <xsl:text>value</xsl:text>
            </em>
            <xsl:text> &lt;= </xsl:text>
            <xsl:value-of select="$simpleRestrict/xsd:maxInclusive/@value"/>
         </xsl:when>
         <xsl:when test="$simpleRestrict/xsd:maxExclusive">
            <em>
               <xsl:text>value</xsl:text>
            </em>
            <xsl:text> &lt; </xsl:text>
            <xsl:value-of select="$simpleRestrict/xsd:maxExclusive/@value"/>
         </xsl:when>
      </xsl:choose>
   </xsl:template>

   <!--
     Print out the length property for derivations by
     restriction on simple content.
     Param(s):
            simpleRestrict (Node) required
              'restriction' element
     -->
   <xsl:template name="PrintLengthFacets">
      <xsl:param name="simpleRestrict"/>

      <xsl:choose>
         <xsl:when test="$simpleRestrict/xsd:length">
            <em>
               <xsl:text>length</xsl:text>
            </em>
            <xsl:text> = </xsl:text>
            <xsl:value-of select="$simpleRestrict/xsd:length/@value"/>
         </xsl:when>
         <xsl:when test="$simpleRestrict/xsd:minLength">
            <em>
               <xsl:text>length</xsl:text>
            </em>
            <xsl:text> >= </xsl:text>
            <xsl:value-of select="$simpleRestrict/xsd:minLength/@value"/>
         </xsl:when>
         <xsl:when test="$simpleRestrict/xsd:maxLength">
            <em>
               <xsl:text>length</xsl:text>
            </em>
            <xsl:text> &lt;= </xsl:text>
            <xsl:value-of select="$simpleRestrict/xsd:maxLength/@value"/>
         </xsl:when>
      </xsl:choose>
   </xsl:template>

   <!--
     Print out the whitespace property for derivations by
     restriction on simple content.
     Param(s):
            simpleRestrict (Node) required
              'restriction' element
     -->
   <xsl:template name="PrintWhitespaceFacet">
      <xsl:param name="simpleRestrict"/>

      <xsl:variable name="facetValue" select="normalize-space(translate($simpleRestrict/xsd:whiteSpace/@value, 'ACELOPRSV', 'aceloprsv'))"/>

      <xsl:choose>
         <xsl:when test="$facetValue='preserve'">
            <em>Whitespace policy: </em>
            <xsl:call-template name="PrintGlossaryTermRef">
               <xsl:with-param name="code">PreserveWS</xsl:with-param>
               <xsl:with-param name="term">preserve</xsl:with-param>
            </xsl:call-template>
         </xsl:when>
         <xsl:when test="$facetValue='replace'">
            <em>Whitespace policy: </em>
            <xsl:call-template name="PrintGlossaryTermRef">
               <xsl:with-param name="code">ReplaceWS</xsl:with-param>
               <xsl:with-param name="term">replace</xsl:with-param>
            </xsl:call-template>
         </xsl:when>
         <xsl:when test="$facetValue='collapse'">
            <em>Whitespace policy: </em>
            <xsl:call-template name="PrintGlossaryTermRef">
               <xsl:with-param name="code">CollapseWS</xsl:with-param>
               <xsl:with-param name="term">collapse</xsl:with-param>
            </xsl:call-template>
         </xsl:when>
      </xsl:choose>
   </xsl:template>

   <!--
     Print out the total digits property for derivations by
     restriction on simple content.
     Param(s):
            simpleRestrict (Node) required
              'restriction' element
     -->
   <xsl:template name="PrintTotalDigitsFacet">
      <xsl:param name="simpleRestrict"/>

      <xsl:if test="$simpleRestrict/xsd:totalDigits">
         <em>total no. of digits</em>
         <xsl:text> = </xsl:text>
         <xsl:value-of select="$simpleRestrict/xsd:totalDigits/@value"/>
      </xsl:if>
   </xsl:template>

   <!--
     Print out the fraction digits property for derivations by
     restriction on simple content.
     Param(s):
            simpleRestrict (Node) required
              'restriction' element
     -->
   <xsl:template name="PrintFractionDigitsFacet">
      <xsl:param name="simpleRestrict"/>

      <xsl:if test="$simpleRestrict/xsd:fractionDigits">
         <em>
            <xsl:text>no. of fraction digits</xsl:text>
         </em>
         <xsl:text> = </xsl:text>
         <xsl:value-of select="$simpleRestrict/xsd:fractionDigits/@value"/>
      </xsl:if>
   </xsl:template>

</xsl:stylesheet>