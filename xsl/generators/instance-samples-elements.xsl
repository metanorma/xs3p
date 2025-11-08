<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!--
  XS3P Content Generator Module: Instance Samples - Elements
  This module contains element-related templates for XML instance representation.

  Dependencies:
  - core/constants.xsl
  - core/keys.xsl
  - utils/references.xsl
  - utils/namespaces.xsl
  - renderers/glossary.xsl
  - generators/component-links.xsl
-->
<xsl:stylesheet
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns="http://www.w3.org/1999/xhtml"
 xmlns:xsd="http://www.w3.org/2001/XMLSchema"
 version="1.0"
 exclude-result-prefixes="xsd">

   <!--
     Prints out the XML Instance Representation table for a top-level
     schema component.
     Param(s):
            component (Node) required
              Top-level schema component
     -->
   <xsl:template name="SampleInstanceTable">
      <xsl:param name="component"/>

      <!-- Not applicable for simple type definitions and notation
      declarations -->
      <xsl:if test="local-name($component)!='simpleType' and local-name($component)!='notation'">
         <xsl:variable name="componentID">
            <xsl:call-template name="GetComponentID">
               <xsl:with-param name="component" select="$component"/>
            </xsl:call-template>
         </xsl:variable>
         <div class="bs-callout bs-callout-info">
            <h4>XML Instance Representation
               <span class="xs3p-panel-help">
                  <button type="button" class="btn btn-doc" data-container="body" data-toggle="popover" data-placement="right" data-html="true" data-content="{$HELP_INSTANCE}">
                  <span class="glyphicon glyphicon-question-sign"><xsl:text> </xsl:text></span>
                  </button>
               </span>
            </h4>

            <pre class="codehilite">
               <xsl:apply-templates select="$component" mode="sample"/>
            </pre>
         </div>

      </xsl:if>
   </xsl:template>

   <!--
     Prints out a sample XML instance from an element declaration.
     Param(s):
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
            isInherited (boolean) optional
                If true, display elements using 'inherited' CSS class.
            isNewField (boolean) optional
                If true, display elements using 'newFields' CSS class.
            schemaLoc (String) optional
                Schema file containing this element declaration;
                if in current schema, 'schemaLoc' is set to 'this'.
            typeList (String) optional
                List of types in this call chain. Name of type starts
                with '*', and ends with '+'. (Used to prevent infinite
                recursive loop.)
     -->
   <xsl:template match="xsd:element[@name]" mode="sample">
      <xsl:param name="margin">0</xsl:param>
      <xsl:param name="isInherited">false</xsl:param>
      <xsl:param name="isNewField">false</xsl:param>
      <xsl:param name="schemaLoc">this</xsl:param>
      <xsl:param name="typeList"/>
      <xsl:param name="parentGroups"/>

      <xsl:choose>
         <!-- Prohibited element declaration -->
         <xsl:when test="normalize-space(@maxOccurs)='0'">
            <!-- IGNORE if max occurs is zero -->
         </xsl:when>
         <!-- Global element declaration -->
         <xsl:when test="local-name(..)='schema'">
            <xsl:choose>
               <!-- With type reference -->
               <xsl:when test="@type">
                  <xsl:variable name="elemTypeName">
                     <xsl:call-template name="GetRefName">
                        <xsl:with-param name="ref" select="@type"/>
                     </xsl:call-template>
                  </xsl:variable>

                  <!-- Look for complex type definition -->
                  <xsl:variable name="defLoc">
                     <xsl:call-template name="FindComponent">
                        <xsl:with-param name="ref" select="@type"/>
                        <xsl:with-param name="compType">complex type</xsl:with-param>
                     </xsl:call-template>
                  </xsl:variable>

                  <xsl:choose>
                     <!-- Complex type was found in current
                          schema. -->
                     <xsl:when test="normalize-space($defLoc)='this'">
                        <xsl:variable name="ctype" select="key('complexType', $elemTypeName)"/>
                        <xsl:call-template name="PrintSampleComplexElement">
                           <xsl:with-param name="element" select="."/>
                           <xsl:with-param name="type" select="$ctype"/>
                           <xsl:with-param name="parentGroups" select="$parentGroups"/>
                        </xsl:call-template>
                     </xsl:when>
                     <!-- Complex type was not found. -->
                     <xsl:when test="normalize-space($defLoc)='' or normalize-space($defLoc)='none' or normalize-space($defLoc)='xml' or normalize-space($defLoc)='xsd'">
                        <xsl:call-template name="PrintSampleSimpleElement">
                           <xsl:with-param name="element" select="."/>
                           <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
                        </xsl:call-template>
                     </xsl:when>
                     <!-- Complex type was found in external
                          schema. -->
                     <xsl:otherwise>
                        <xsl:variable name="ctype" select="document($defLoc)/xsd:schema/xsd:complexType[@name=$elemTypeName]"/>
                        <xsl:call-template name="PrintSampleComplexElement">
                           <xsl:with-param name="element" select="."/>
                           <xsl:with-param name="type" select="$ctype"/>
                           <xsl:with-param name="parentGroups" select="$parentGroups"/>
                        </xsl:call-template>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:when>
               <!-- With local complex type definition -->
               <xsl:when test="xsd:complexType">
                  <xsl:call-template name="PrintSampleComplexElement">
                     <xsl:with-param name="element" select="."/>
                     <xsl:with-param name="type" select="xsd:complexType"/>
                     <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
                     <xsl:with-param name="parentGroups" select="$parentGroups"/>
                  </xsl:call-template>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:call-template name="PrintSampleSimpleElement">
                     <xsl:with-param name="element" select="."/>
                     <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <!-- Local element declaration -->
         <xsl:otherwise>
            <xsl:choose>
               <!-- With local complex type definition -->
               <xsl:when test="xsd:complexType">
                  <xsl:call-template name="PrintSampleComplexElement">
                     <xsl:with-param name="element" select="."/>
                     <xsl:with-param name="type" select="xsd:complexType"/>
                     <xsl:with-param name="margin" select="$margin"/>
                     <xsl:with-param name="isInherited" select="$isInherited"/>
                     <xsl:with-param name="isNewField" select="$isNewField"/>
                     <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
                     <xsl:with-param name="typeList" select="$typeList"/>
                     <xsl:with-param name="parentGroups" select="$parentGroups"/>
                  </xsl:call-template>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:call-template name="PrintSampleSimpleElement">
                     <xsl:with-param name="element" select="."/>
                     <xsl:with-param name="margin" select="$margin"/>
                     <xsl:with-param name="isInherited" select="$isInherited"/>
                     <xsl:with-param name="isNewField" select="$isNewField"/>
                     <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
                     <xsl:with-param name="typeList" select="$typeList"/>
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--
     Prints out a sample XML instance from an element
     reference.
     Param(s):
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
            isInherited (boolean) optional
                If true, display elements using 'inherited' CSS class.
            isNewField (boolean) optional
                If true, display elements using 'newFields' CSS class.
            schemaLoc (String) optional
                Schema file containing this element reference;
                if in current schema, 'schemaLoc' is set to 'this'.
     -->
   <xsl:template match="xsd:element[@ref]" mode="sample">
      <xsl:param name="margin">0</xsl:param>
      <xsl:param name="isInherited">false</xsl:param>
      <xsl:param name="isNewField">false</xsl:param>
      <xsl:param name="schemaLoc">this</xsl:param>

      <xsl:if test="normalize-space(@maxOccurs)!='0'">
         <xsl:call-template name="PrintSampleSimpleElement">
            <xsl:with-param name="element" select="."/>
            <xsl:with-param name="margin" select="$margin"/>
            <xsl:with-param name="isInherited" select="$isInherited"/>
            <xsl:with-param name="isNewField" select="$isNewField"/>
            <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>

   <!--
     Prints out a sample element instance in one line.
     Param(s):
            element (Node) required
                Element declaration or reference
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
            isInherited (boolean) optional
                If true, display element using 'inherited' CSS class.
            isNewField (boolean) optional
                If true, display element using 'newFields' CSS class.
            typeList (String) optional
                List of types in this call chain. Name of type starts
                with '*', and ends with '+'. (Used to prevent infinite
            schemaLoc (String) optional
                Schema file containing this element declaration
                or reference; if in current schema, 'schemaLoc' is
                set to 'this'.
     -->
   <xsl:template name="PrintSampleSimpleElement">
      <xsl:param name="element"/>
      <xsl:param name="margin">0</xsl:param>
      <xsl:param name="isInherited">false</xsl:param>
      <xsl:param name="isNewField">false</xsl:param>
      <xsl:param name="schemaLoc">this</xsl:param>
      <xsl:param name="typeList"/>

      <!-- Element Tag -->
      <xsl:variable name="elemTag">
         <!-- Local Name -->
         <xsl:choose>
            <!-- Element reference -->
            <xsl:when test="$element/@ref">
               <!-- Note: Prefix will be automatically written out
                    in call to 'PrintElementRef'. -->
               <xsl:call-template name="PrintElementRef">
                  <xsl:with-param name="ref" select="@ref"/>
                  <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
               </xsl:call-template>
            </xsl:when>
            <!-- Element declaration -->
            <xsl:otherwise>
               <!-- Prefix -->
               <xsl:variable name="prefix">
                  <xsl:call-template name="GetElementPrefix">
                     <xsl:with-param name="element" select="$element"/>
                  </xsl:call-template>
               </xsl:variable>
               <xsl:call-template name="PrintNSPrefix">
                  <xsl:with-param name="prefix" select="$prefix"/>
                  <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
               </xsl:call-template>
               <xsl:value-of select="$element/@name"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="typeHierarchy">
         <xsl:value-of select="$typeList"/>
      </xsl:variable>

      <xsl:call-template name="Repeat">
         <xsl:with-param name="content">
            <xsl:text> </xsl:text>
         </xsl:with-param>
         <xsl:with-param name="count" select="$margin"/>
      </xsl:call-template>

      <xsl:choose>
         <xsl:when test="$isNewField!='false'">
            <xsl:attribute name="class">newFields</xsl:attribute>
         </xsl:when>
         <xsl:when test="$isInherited!='false'">
            <xsl:attribute name="class">inherited</xsl:attribute>
         </xsl:when>
      </xsl:choose>

      <!-- Start Tag -->
      <span class="nt">
         <xsl:text>&lt;</xsl:text>
         <xsl:copy-of select="$elemTag"/>
         <xsl:text>></xsl:text>
      </span>

      <!-- Contents -->
      <xsl:text> </xsl:text>
      <xsl:choose>
         <!-- Fixed value is provided -->
         <xsl:when test="$element/@fixed">
            <span class="fixed">
               <xsl:value-of select="$element/@fixed"/>
            </span>
         </xsl:when>
         <!-- Type reference is provided -->
         <xsl:when test="$element/@name and $element/@type">
            <xsl:call-template name="PrintTypeRef">
               <xsl:with-param name="ref" select="$element/@type"/>
               <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
            </xsl:call-template>
         </xsl:when>
         <!-- Local simple type definition is provided -->
         <xsl:when test="$element/@name and $element/xsd:simpleType">
            <xsl:apply-templates select="$element/xsd:simpleType" mode="sample">
               <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
            </xsl:apply-templates>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>...</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:text> </xsl:text>

      <!-- Identity Constraints -->
      <xsl:if test="$element/xsd:unique or $element/xsd:key or $element/xsd:keyref">
         <xsl:text>&#xa;</xsl:text>
         <xsl:apply-templates select="$element/xsd:unique | $element/xsd:key | $element/xsd:keyref" mode="sample">
            <xsl:with-param name="margin" select="number($margin) + number($ELEM_INDENT)"/>
            <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
         </xsl:apply-templates>
         <xsl:call-template name="Repeat">
            <xsl:with-param name="content"><xsl:text> </xsl:text></xsl:with-param>
            <xsl:with-param name="count" select="$margin"/>
         </xsl:call-template>
      </xsl:if>

      <!-- End Tag -->
      <span class="nt">
         <xsl:text>&lt;/</xsl:text>
         <xsl:copy-of select="$elemTag"/>
         <xsl:text>></xsl:text>
      </span>

      <xsl:if test="local-name($element/..)!='schema'">
         <!-- Min/max occurs information -->
         <xsl:text> </xsl:text>
         <xsl:call-template name="PrintOccurs">
            <xsl:with-param name="component" select="$element"/>
         </xsl:call-template>
         <!-- Documentation -->
         <xsl:call-template name="PrintSampleDocumentation">
            <xsl:with-param name="component" select="$element"/>
         </xsl:call-template>
      </xsl:if>
      <xsl:text>&#xa;</xsl:text>
   </xsl:template>

   <!--
     Prints out a sample element instance that has complex content.
     Param(s):
            type (Node) required
                Complex type definition
            element (Node) optional
                Element declaration
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
            isInherited (boolean) optional
                If true, display element using 'inherited' CSS class.
            isNewField (boolean) optional
                If true, display element using 'newFields' CSS class.
            schemaLoc (String) optional
                Schema file containing this element declaration
                or type definition; if in current schema, 'schemaLoc'
                is set to 'this'.
            typeList (String) optional
                List of types in this call chain. Name of type starts
                with '*', and ends with '+'. (Used to prevent infinite
                recursive loop.)
     -->
   <xsl:template name="PrintSampleComplexElement">
      <xsl:param name="type"/>
      <xsl:param name="element"/>
      <xsl:param name="margin">0</xsl:param>
      <xsl:param name="isInherited">false</xsl:param>
      <xsl:param name="isNewField">false</xsl:param>
      <xsl:param name="schemaLoc">this</xsl:param>
      <xsl:param name="typeList"/>
      <xsl:param name="parentGroups"/>

      <xsl:choose>
         <!-- Circular type hierarchy -->
         <xsl:when test="$type/@name and contains($typeList, concat('*', $type/@name, '+'))"/>
         <xsl:otherwise>
            <xsl:variable name="tag">
               <xsl:choose>
                  <xsl:when test="$element">
                     <!-- Prefix -->
                     <xsl:variable name="prefix">
                        <xsl:call-template name="GetElementPrefix">
                           <xsl:with-param name="element" select="$element"/>
                        </xsl:call-template>
                     </xsl:variable>
                     <xsl:call-template name="PrintNSPrefix">
                        <xsl:with-param name="prefix" select="$prefix"/>
                        <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
                     </xsl:call-template>
                     <xsl:value-of select="$element/@name"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:text>...</xsl:text>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:variable>

            <xsl:variable name="fromTopCType">
               <xsl:choose>
                  <xsl:when test="not($element) and local-name($type/..)='schema'">
                     <xsl:text>true</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:text>false</xsl:text>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:variable>

            <xsl:call-template name="Repeat">
               <xsl:with-param name="content"><xsl:text> </xsl:text></xsl:with-param>
               <xsl:with-param name="count" select="$margin"/>
            </xsl:call-template>
            <xsl:choose>
               <xsl:when test="$isNewField!='false'">
                  <xsl:attribute name="class">newFields</xsl:attribute>
               </xsl:when>
               <xsl:when test="$isInherited!='false'">
                  <xsl:attribute name="class">inherited</xsl:attribute>
               </xsl:when>
            </xsl:choose>

            <!-- Start Tag -->
            <span class="nt">
               <xsl:text>&lt;</xsl:text>
               <xsl:copy-of select="$tag"/>
            </span>

            <!-- Get attributes -->
            <xsl:variable name="attributes">
               <xsl:call-template name="PrintSampleTypeAttrs">
                  <xsl:with-param name="type" select="$type"/>
                  <xsl:with-param name="isInherited" select="$isInherited"/>
                  <xsl:with-param name="isNewField" select="$isNewField"/>
                  <xsl:with-param name="margin" select="number($margin) + number($ATTR_INDENT)"/>
                  <xsl:with-param name="fromTopCType" select="$fromTopCType"/>
                  <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
                  <xsl:with-param name="typeList" select="$typeList"/>
               </xsl:call-template>
            </xsl:variable>

            <!-- Print attributes -->
            <xsl:if test="normalize-space($attributes)!=''">
               <xsl:text>&#xa;</xsl:text>
               <xsl:copy-of select="$attributes"/>
            </xsl:if>

            <!-- Get content -->
            <xsl:variable name="content">
               <xsl:call-template name="PrintSampleTypeContent">
                  <xsl:with-param name="type" select="$type"/>
                  <xsl:with-param name="margin" select="number($margin) + number($ELEM_INDENT)"/>
                  <xsl:with-param name="isInherited" select="$isInherited"/>
                  <xsl:with-param name="isNewField" select="$isNewField"/>
                  <xsl:with-param name="fromTopCType" select="$fromTopCType"/>
                  <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
                  <xsl:with-param name="typeList" select="$typeList"/>
                  <xsl:with-param name="parentGroups" select="$parentGroups"/>
               </xsl:call-template>
            </xsl:variable>

            <!-- Find out if content type is mixed -->
            <xsl:variable name="mixed">
               <xsl:choose>
                  <xsl:when test="normalize-space(translate($type/xsd:complexContent/@mixed, 'TRUE', 'true'))='true' or normalize-space($type/xsd:complexContent/@mixed)='1'">
                     <xsl:text>true</xsl:text>
                  </xsl:when>
                  <xsl:when test="normalize-space(translate($type/@mixed, 'TRUE', 'true'))='true' or normalize-space($type/@mixed)='1'">
                     <xsl:text>true</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:text>false</xsl:text>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:variable>

            <!-- Find out if there are identity constraints -->
            <xsl:variable name="hasIdConstraints">
               <xsl:if test="$element and ($element/xsd:unique or $element/xsd:key or $element/xsd:keyref)">
                  <xsl:text>true</xsl:text>
               </xsl:if>
            </xsl:variable>

            <!-- Print content -->
            <xsl:choose>
               <!-- Empty content -->
               <xsl:when test="$hasIdConstraints!='true' and normalize-space($content)=''">
                  <!-- Close start tag -->
                  <span class="nt">
                     <xsl:text>/> </xsl:text>
                  </span>

                  <xsl:if test="$element and local-name($element/..)!='schema'">
                     <!-- Occurrence info -->
                     <xsl:text> </xsl:text>
                     <xsl:call-template name="PrintOccurs">
                        <xsl:with-param name="component" select="$element"/>
                     </xsl:call-template>

                     <!-- Documentation -->
                     <xsl:call-template name="PrintSampleDocumentation">
                        <xsl:with-param name="component" select="$element"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:text>&#xa;</xsl:text>
               </xsl:when>
               <xsl:otherwise>
                  <!-- Close start tag -->
                  <xsl:call-template name="Repeat">
                     <xsl:with-param name="content"><xsl:text> </xsl:text></xsl:with-param>
                     <xsl:with-param name="count" select="$margin"/>
                  </xsl:call-template>
                  <span class="nt">
                     <xsl:text>></xsl:text>
                  </span>

                  <xsl:if test="$element and local-name($element/..)!='schema'">
                     <!-- Occurrence info -->
                     <xsl:text> </xsl:text>
                     <xsl:call-template name="PrintOccurs">
                        <xsl:with-param name="component" select="$element"/>
                     </xsl:call-template>

                     <!-- Documentation -->
                     <xsl:text> </xsl:text>
                     <xsl:call-template name="PrintSampleDocumentation">
                        <xsl:with-param name="component" select="$element"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:text>&#xa;</xsl:text>

                  <!-- Identity Constraints -->
                  <xsl:if test="$element">
                     <xsl:apply-templates select="$element/xsd:unique | $element/xsd:key | $element/xsd:keyref" mode="sample">
                        <xsl:with-param name="margin" select="number($margin) + number($ELEM_INDENT)"/>
                     </xsl:apply-templates>
                  </xsl:if>

                  <!-- Print out restriction/extension information -->
                  <xsl:choose>
                     <xsl:when test="false()">
                     <!-- TODO: port. <xsl:when test="$type/xsd:complexContent/xsd:restriction/@base">-->
                        <br/><span class="other" style="margin-left: {$ELEM_INDENT}em">
                           <xsl:text>&lt;!-- Restricts : </xsl:text>
                           <xsl:call-template name="PrintTypeRef">
                              <xsl:with-param name="ref" select="$type/xsd:complexContent/xsd:restriction/@base"/>
                              <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
                           </xsl:call-template>
                           <xsl:text> --></xsl:text>
                        </span>
                     </xsl:when>
                     <xsl:when test="false()">
                     <!-- TODO: port. <xsl:when test="$type/xsd:complexContent/xsd:extension/@base">-->
                        <br/><span class="other" style="margin-left: {$ELEM_INDENT}em">
                           <xsl:text>&lt;!-- Extends : </xsl:text>
                           <xsl:call-template name="PrintTypeRef">
                              <xsl:with-param name="ref" select="$type/xsd:complexContent/xsd:extension/@base"/>
                              <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
                           </xsl:call-template>
                           <xsl:text> --></xsl:text>
                        </span>
                     </xsl:when>
                  </xsl:choose>

                  <!-- Print out message if has mixed content -->
                  <xsl:if test="$mixed='true'">
                     <xsl:call-template name="Repeat">
                        <xsl:with-param name="content"><xsl:text> </xsl:text></xsl:with-param>
                        <xsl:with-param name="count" select="number($margin) + number($ELEM_INDENT)"/>
                     </xsl:call-template>
                     <span class="c">
                        <xsl:text>&lt;!-- Mixed content -->&#xa;</xsl:text>
                     </span>
                  </xsl:if>

                  <!-- Element Content -->
                  <xsl:copy-of select="$content"/>

                  <!-- End Tag -->
                  <xsl:call-template name="Repeat">
                     <xsl:with-param name="content"><xsl:text> </xsl:text></xsl:with-param>
                     <xsl:with-param name="count" select="$margin"/>
                  </xsl:call-template>
                  <span class="nt">
                     <xsl:text>&lt;/</xsl:text>
                     <xsl:copy-of select="$tag"/>
                     <xsl:text>></xsl:text>
                  </span>
               </xsl:otherwise>
            </xsl:choose>
            <xsl:text>&#xa;</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--
     Prints out the identity constraints of an element to be displayed
     within a sample XML instance.
     Param(s):
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
            schemaLoc (String) optional
                Schema file containing this simple type definition;
                if in current schema, 'schemaLoc' is set to 'this'
     -->
   <xsl:template match="xsd:unique | xsd:key | xsd:keyref" mode="sample">
      <xsl:param name="margin">0</xsl:param>
      <xsl:param name="schemaLoc">this</xsl:param>


      <xsl:call-template name="Repeat">
         <xsl:with-param name="content"><xsl:text> </xsl:text></xsl:with-param>
         <xsl:with-param name="count" select="$margin"/>
      </xsl:call-template>
      <span class="c">
         <xsl:text>&lt;!--&#xa;</xsl:text>

         <xsl:call-template name="Repeat">
            <xsl:with-param name="content"><xsl:text> </xsl:text></xsl:with-param>
            <xsl:with-param name="count" select="number($margin) + number($ATTR_INDENT)"/>
         </xsl:call-template>
         <xsl:choose>
            <xsl:when test="local-name(.)='unique'">
               <xsl:call-template name="PrintGlossaryTermRef">
                  <xsl:with-param name="code">Unique</xsl:with-param>
                  <xsl:with-param name="term">Uniqueness</xsl:with-param>
               </xsl:call-template>
            </xsl:when>
            <xsl:when test="local-name(.)='key'">
               <xsl:call-template name="PrintGlossaryTermRef">
                  <xsl:with-param name="code">Key</xsl:with-param>
                  <xsl:with-param name="term">Key</xsl:with-param>
               </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
               <xsl:call-template name="PrintGlossaryTermRef">
                  <xsl:with-param name="code">KeyRef</xsl:with-param>
                  <xsl:with-param name="term">Key Reference</xsl:with-param>
               </xsl:call-template>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:text> Constraint - </xsl:text>
         <strong>
            <xsl:choose>
               <xsl:when test="local-name(.)='keyref'">
                  <xsl:value-of select="@name"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:variable name="componentID">
                     <xsl:call-template name="GetComponentID">
                        <xsl:with-param name="component" select="."/>
                     </xsl:call-template>
                  </xsl:variable>
                  <a id="{$componentID}"><xsl:value-of select="@name"/></a>
               </xsl:otherwise>
            </xsl:choose>
         </strong>
         <xsl:text>&#xa;</xsl:text>

         <xsl:call-template name="Repeat">
            <xsl:with-param name="content"><xsl:text> </xsl:text></xsl:with-param>
            <xsl:with-param name="count" select="number($margin) + number($ATTR_INDENT)"/>
         </xsl:call-template>
         <xsl:text>Selector - </xsl:text>
         <strong>
            <xsl:value-of select="xsd:selector/@xpath"/>
         </strong>
         <xsl:text>&#xa;</xsl:text>

         <xsl:call-template name="Repeat">
            <xsl:with-param name="content"><xsl:text> </xsl:text></xsl:with-param>
            <xsl:with-param name="count" select="number($margin) + number($ATTR_INDENT)"/>
         </xsl:call-template>
         <xsl:text>Field(s) - </xsl:text>
         <xsl:for-each select="xsd:field">
            <xsl:if test="position()!=1">
               <xsl:text>, </xsl:text>
            </xsl:if>
            <strong>
               <xsl:value-of select="@xpath"/>
            </strong>
         </xsl:for-each>
         <xsl:text>&#xa;</xsl:text>

         <xsl:if test="local-name(.)='keyref'">
            <xsl:call-template name="Repeat">
               <xsl:with-param name="content"><xsl:text> </xsl:text></xsl:with-param>
               <xsl:with-param name="count" select="number($margin) + number($ATTR_INDENT)"/>
            </xsl:call-template>
            <xsl:text>Refers to - </xsl:text>
            <xsl:call-template name="PrintKeyRef">
               <xsl:with-param name="ref" select="@refer"/>
               <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
            </xsl:call-template>
            <xsl:text>&#xa;</xsl:text>
         </xsl:if>

         <xsl:call-template name="Repeat">
            <xsl:with-param name="content"><xsl:text> </xsl:text></xsl:with-param>
            <xsl:with-param name="count" select="$margin"/>
         </xsl:call-template>
         <xsl:text>-->&#xa;</xsl:text>
      </span>
   </xsl:template>

   <!--
     Prints out a link which will open up a window, displaying a
     schema component's documentation.
     Param(s):
            component (Node) required
                Schema component
  -->
   <xsl:template name="PrintSampleDocumentation">
      <xsl:param name="component"/>

      <xsl:if test="$component and $component/xsd:annotation/xsd:documentation">
         <xsl:variable name="documentation">
            <xsl:for-each select="$component/xsd:annotation/xsd:documentation">
               <xsl:if test="position()!=1">
                  <xsl:text>,</xsl:text>
               </xsl:if>
               <xsl:value-of select="generate-id(.)"/>
            </xsl:for-each>
         </xsl:variable>

         <xsl:text> </xsl:text>
         <button type="button" class="btn btn-link btn-doc" data-container="body" data-toggle="modal" data-target="#{$documentation}-popup"><span class="glyphicon glyphicon-info-sign"><xsl:text> </xsl:text></span></button>

      </xsl:if>
   </xsl:template>

   <!--
     Unmatched template for 'sample' mode
     -->
   <xsl:template match="*" mode="sample"/>

</xsl:stylesheet>