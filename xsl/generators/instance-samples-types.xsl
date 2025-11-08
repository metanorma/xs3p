<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!--
  XS3P Content Generator Module: Instance Samples - Types
  This module contains type-related templates for XML instance representation.

  Dependencies:
  - core/constants.xsl
  - core/keys.xsl
  - utils/references.xsl
  - utils/namespaces.xsl
  - generators/component-links.xsl
-->
<xsl:stylesheet
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns="http://www.w3.org/1999/xhtml"
 xmlns:xsd="http://www.w3.org/2001/XMLSchema"
 version="1.0"
 exclude-result-prefixes="xsd">

   <!--
     Prints out a sample XML instance from a complex type definition.
     Param(s):
            schemaLoc (String) optional
                Schema file containing this complex type definition;
                if in current schema, 'schemaLoc' is set to 'this'.
     -->
   <xsl:template match="xsd:complexType" mode="sample">
      <xsl:param name="schemaLoc">this</xsl:param>
      <xsl:param name="parentGroups"/>

      <xsl:call-template name="PrintSampleComplexElement">
         <xsl:with-param name="type" select="."/>
         <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
         <xsl:with-param name="parentGroups" select="$parentGroups"/>
      </xsl:call-template>
   </xsl:template>

   <!--
     Prints out attributes of a complex type definition, including
     those inherited from a base type.
     Param(s):
            type (Node) required
                Complex type definition
            subTypeAttrs (String) optional
                List of attributes in sub-types of this current type
                definition
            isInherited (boolean) optional
                If true, display attributes using 'inherited' CSS class.
            isNewField (boolean) optional
                If true, display attributes using 'newFields' CSS class.
            fromTopCType (boolean) optional
                Set to true if this is being displayed in the XML
                Instance Representation table of a top-level complex
                type definition, in which case, 'inherited' attributes
                and elements are distinguished.
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
            schemaLoc (String) optional
                Schema file containing this complex type definition;
                if in current schema, 'schemaLoc' is set to 'this'.
            typeList (String) optional
                List of types in this call chain. Name of type starts
                with '*', and ends with '+'. (Used to prevent infinite
                recursive loop.)
     -->
   <xsl:template name="PrintSampleTypeAttrs">
      <xsl:param name="type"/>
      <xsl:param name="subTypeAttrs"/>
      <xsl:param name="isInherited">false</xsl:param>
      <xsl:param name="isNewField">false</xsl:param>
      <xsl:param name="fromTopCType">false</xsl:param>
      <xsl:param name="margin">0</xsl:param>
      <xsl:param name="schemaLoc">this</xsl:param>
      <xsl:param name="typeList"/>

      <xsl:choose>
         <!-- Circular type hierarchy -->
         <xsl:when test="$type/@name and contains($typeList, concat('*', $type/@name, '+'))">
            <!-- Do nothing.
                 Error message will be written out by 'PrintSampleTypeContent' template.
            -->
         </xsl:when>
         <!-- Derivation -->
         <xsl:when test="$type/xsd:complexContent or $type/xsd:simpleContent">
            <xsl:choose>
               <xsl:when test="$type/xsd:complexContent/xsd:restriction">
                  <xsl:call-template name="PrintSampleDerivedTypeAttrs">
                     <xsl:with-param name="derivationElem" select="$type/xsd:complexContent/xsd:restriction"/>
                     <xsl:with-param name="subTypeAttrs" select="$subTypeAttrs"/>
                     <xsl:with-param name="isInherited" select="$isInherited"/>
                     <xsl:with-param name="isNewField" select="$isNewField"/>
                     <xsl:with-param name="fromTopCType" select="$fromTopCType"/>
                     <xsl:with-param name="margin" select="$margin"/>
                     <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
                     <xsl:with-param name="typeList" select="concat($typeList, '*', $type/@name, '+')"/>
                  </xsl:call-template>
               </xsl:when>
               <xsl:when test="$type/xsd:simpleContent/xsd:restriction">
                  <xsl:call-template name="PrintSampleDerivedTypeAttrs">
                     <xsl:with-param name="derivationElem" select="$type/xsd:simpleContent/xsd:restriction"/>
                     <xsl:with-param name="subTypeAttrs" select="$subTypeAttrs"/>
                     <xsl:with-param name="isInherited" select="$isInherited"/>
                     <xsl:with-param name="isNewField" select="$isNewField"/>
                     <xsl:with-param name="fromTopCType" select="$fromTopCType"/>
                     <xsl:with-param name="margin" select="$margin"/>
                     <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
                     <xsl:with-param name="typeList" select="concat($typeList, '*', $type/@name, '+')"/>
                  </xsl:call-template>
               </xsl:when>
               <xsl:when test="$type/xsd:complexContent/xsd:extension">
                  <xsl:call-template name="PrintSampleDerivedTypeAttrs">
                     <xsl:with-param name="derivationElem" select="$type/xsd:complexContent/xsd:extension"/>
                     <xsl:with-param name="subTypeAttrs" select="$subTypeAttrs"/>
                     <xsl:with-param name="isInherited" select="$isInherited"/>
                     <xsl:with-param name="isNewField" select="$isNewField"/>
                     <xsl:with-param name="fromTopCType" select="$fromTopCType"/>
                     <xsl:with-param name="margin" select="$margin"/>
                     <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
                     <xsl:with-param name="typeList" select="concat($typeList, '*', $type/@name, '+')"/>
                  </xsl:call-template>
               </xsl:when>
               <xsl:when test="$type/xsd:simpleContent/xsd:extension">
                  <xsl:call-template name="PrintSampleDerivedTypeAttrs">
                     <xsl:with-param name="derivationElem" select="$type/xsd:simpleContent/xsd:extension"/>
                     <xsl:with-param name="subTypeAttrs" select="$subTypeAttrs"/>
                     <xsl:with-param name="isInherited" select="$isInherited"/>
                     <xsl:with-param name="isNewField" select="$isNewField"/>
                     <xsl:with-param name="fromTopCType" select="$fromTopCType"/>
                     <xsl:with-param name="margin" select="$margin"/>
                     <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
                     <xsl:with-param name="typeList" select="concat($typeList, '*', $type/@name, '+')"/>
                  </xsl:call-template>
               </xsl:when>
            </xsl:choose>
         </xsl:when>
         <!-- No derivation -->
         <xsl:when test="local-name($type)='complexType'">
            <xsl:call-template name="PrintSampleAttrList">
               <xsl:with-param name="list" select="$type"/>
               <xsl:with-param name="subTypeAttrs" select="$subTypeAttrs"/>
               <xsl:with-param name="isInherited" select="$isInherited"/>
               <xsl:with-param name="isNewField" select="$isNewField"/>
               <xsl:with-param name="margin" select="$margin"/>
               <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
               <xsl:with-param name="typeList" select="concat($typeList, '*', $type/@name, '+')"/>
            </xsl:call-template>
         </xsl:when>
         <!-- Ignore base types that are simple types -->
      </xsl:choose>
   </xsl:template>

   <!--
     Helper function 'PrintSampleTypeAttrs' template to
     handle case of derived types.
     Param(s):
            derivationElem (Node) required
                'restriction' or 'extension' element
            subTypeAttrs (String) optional
                List of attributes in sub-types of
                this current type definition
            isInherited (boolean) optional
                If true, display attributes using 'inherited' CSS class.
            isNewField (boolean) optional
                If true, display attributes using 'newFields' CSS class.
            fromTopCType (boolean) optional
                Set to true if this is being displayed
                in the XML Instance Representation table
                of a top-level complex type definition, in
                which case, 'inherited' attributes and
                elements are distinguished.
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
            schemaLoc (String) optional
                Schema file containing this derivation element;
                if in current schema, 'schemaLoc' is set to 'this'.
            typeList (String) optional
                List of types in this call chain. Name of type starts
                with '*', and ends with '+'. (Used to prevent infinite
                recursive loop.)
     -->
   <xsl:template name="PrintSampleDerivedTypeAttrs">
      <xsl:param name="derivationElem"/>
      <xsl:param name="subTypeAttrs"/>
      <xsl:param name="isInherited">false</xsl:param>
      <xsl:param name="isNewField">false</xsl:param>
      <xsl:param name="fromTopCType">false</xsl:param>
      <xsl:param name="margin">0</xsl:param>
      <xsl:param name="schemaLoc">this</xsl:param>
      <xsl:param name="typeList"/>

      <!-- Get attributes from this type to add to
            'subTypeAttrs' list for recursive call on base type -->
      <xsl:variable name="thisAttrs">
         <xsl:call-template name="GetAttrList">
            <xsl:with-param name="list" select="$derivationElem"/>
         </xsl:call-template>
      </xsl:variable>

      <!-- Look for base type -->
      <xsl:variable name="baseTypeName">
         <xsl:call-template name="GetRefName">
            <xsl:with-param name="ref" select="$derivationElem/@base"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="defLoc">
         <xsl:call-template name="FindComponent">
            <xsl:with-param name="ref" select="$derivationElem/@base"/>
            <xsl:with-param name="compType">complex type</xsl:with-param>
         </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
         <!-- Complex type was found in current schema. -->
         <xsl:when test="normalize-space($defLoc)='this'">
            <xsl:variable name="ctype" select="key('complexType', $baseTypeName)"/>
            <xsl:call-template name="PrintSampleTypeAttrs">
               <xsl:with-param name="type" select="$ctype"/>
               <xsl:with-param name="subTypeAttrs" select="concat($subTypeAttrs, $thisAttrs)"/>
               <xsl:with-param name="isInherited">
                  <xsl:choose>
                     <xsl:when test="$fromTopCType!='false'">
                        <xsl:text>true</xsl:text>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:text>false</xsl:text>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:with-param>
               <xsl:with-param name="isNewField" select="$isNewField"/>
               <xsl:with-param name="fromTopCType" select="$fromTopCType"/>
               <xsl:with-param name="margin" select="$margin"/>
               <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
               <xsl:with-param name="typeList" select="$typeList"/>
            </xsl:call-template>
         </xsl:when>
         <!-- Complex type was not found. -->
         <xsl:when test="normalize-space($defLoc)='' or normalize-space($defLoc)='none' or normalize-space($defLoc)='xml' or normalize-space($defLoc)='xsd'">
            <!-- IGNORE: Error message will be printed out be
                 'PrintSampleTypeContent' template. -->
         </xsl:when>
         <!-- Complex type was found in external schema. -->
         <xsl:otherwise>
            <xsl:variable name="ctype" select="document($defLoc)/xsd:schema/xsd:complexType[@name=$baseTypeName]"/>
            <xsl:call-template name="PrintSampleTypeAttrs">
               <xsl:with-param name="type" select="$ctype"/>
               <xsl:with-param name="subTypeAttrs" select="concat($subTypeAttrs, $thisAttrs)"/>
               <xsl:with-param name="isInherited">
                  <xsl:choose>
                     <xsl:when test="$fromTopCType!='false'">
                        <xsl:text>true</xsl:text>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:text>false</xsl:text>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:with-param>
               <xsl:with-param name="isNewField" select="$isNewField"/>
               <xsl:with-param name="fromTopCType" select="$fromTopCType"/>
               <xsl:with-param name="margin" select="$margin"/>
               <xsl:with-param name="schemaLoc" select="$defLoc"/>
               <xsl:with-param name="typeList" select="$typeList"/>
            </xsl:call-template>
         </xsl:otherwise>
      </xsl:choose>

      <!-- Print out attributes in this type -->
      <xsl:call-template name="PrintSampleAttrList">
         <xsl:with-param name="list" select="$derivationElem"/>
         <xsl:with-param name="subTypeAttrs" select="$subTypeAttrs"/>
         <xsl:with-param name="isInherited" select="$isInherited"/>
         <xsl:with-param name="isNewField">
            <xsl:choose>
               <xsl:when test="$fromTopCType!='false' and $isInherited='false'">
                  <xsl:text>true</xsl:text>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:text>false</xsl:text>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:with-param>
         <xsl:with-param name="margin" select="$margin"/>
         <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
      </xsl:call-template>
   </xsl:template>

   <!--
     Prints out the element content of a complex type definition,
     including those inherited from a base type.
     Param(s):
            type (Node) required
                Complex type definition
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
            isInherited (boolean) optional
                If true, display elements using 'inherited' CSS class.
            isNewField (boolean) optional
                If true, display elements using 'newFields' CSS class.
            fromTopCType (boolean) optional
                Set to true if this is being displayed in the XML
                Instance Representation table of a top-level complex
                type definition, in which case, 'inherited' attributes
                and elements are distinguished.
            addBR (boolean) optional
                If true, can add <br/> before element content.
                Applicable only if displaying complex content.
            schemaLoc (String) optional
                Schema file containing this type definition;
                if in current schema, 'schemaLoc' is set to 'this'.
            typeList (String) optional
                List of types in this call chain. Name of type starts
                with '*', and ends with '+'. (Used to prevent infinite
                recursive loop.)
     -->
   <xsl:template name="PrintSampleTypeContent">
      <xsl:param name="type"/>
      <xsl:param name="margin">0</xsl:param>
      <xsl:param name="isInherited">false</xsl:param>
      <xsl:param name="isNewField">false</xsl:param>
      <xsl:param name="fromTopCType">false</xsl:param>
      <xsl:param name="addBR">true</xsl:param>
      <xsl:param name="schemaLoc">this</xsl:param>
      <xsl:param name="typeList"/>
      <xsl:param name="parentGroups"/>

      <xsl:choose>
         <!-- Circular type hierarchy -->
         <xsl:when test="$type/@name and contains($typeList, concat('*', $type/@name, '+'))"/>
         <!-- Derivation by restriction on complex content -->
         <xsl:when test="$type/xsd:complexContent/xsd:restriction">
            <xsl:variable name="restriction" select="$type/xsd:complexContent/xsd:restriction"/>

            <!-- Test if base type is in schema to print out warning comment-->
            <xsl:variable name="baseTypeName">
               <xsl:call-template name="GetRefName">
                  <xsl:with-param name="ref" select="$restriction/@base"/>
               </xsl:call-template>
            </xsl:variable>
            <!-- Look for base type -->
            <xsl:variable name="defLoc">
               <xsl:call-template name="FindComponent">
                  <xsl:with-param name="ref" select="$restriction/@base"/>
                  <xsl:with-param name="compType">complex type</xsl:with-param>
               </xsl:call-template>
            </xsl:variable>

            <xsl:choose>
               <!-- Complex type was not found. -->
               <xsl:when test="normalize-space($defLoc)='' or normalize-space($defLoc)='none' or normalize-space($defLoc)='xml' or normalize-space($defLoc)='xsd'">
                  <xsl:call-template name="Repeat">
                     <xsl:with-param name="content"><xsl:text> </xsl:text></xsl:with-param>
                     <xsl:with-param name="count" select="$margin"/>
                  </xsl:call-template>
                  <span class="c">
                     <xsl:text>&lt;!-- '</xsl:text>
                     <xsl:call-template name="PrintTypeRef">
                        <xsl:with-param name="ref" select="$restriction/@base"/>
                        <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
                     </xsl:call-template>
                     <xsl:text>' super type was not found in this schema. Some elements and attributes may be missing. --></xsl:text>
                  </span>
                  <xsl:text>&#xa;</xsl:text>
               </xsl:when>
               <!-- Complex type was found. -->
               <xsl:otherwise>
                  <!-- IGNORE element content of base type if by restriction,
                       since current content will override restricted
                       base type's content. -->
               </xsl:otherwise>
            </xsl:choose>

            <!-- Print out content from this type -->
            <xsl:if test="$restriction/xsd:*[local-name(.)!='annotation']">
               <xsl:call-template name="PrintSampleParticleList">
                  <xsl:with-param name="list" select="$restriction"/>
                  <xsl:with-param name="margin" select="$margin"/>
                  <xsl:with-param name="isInherited" select="$isInherited"/>
                  <xsl:with-param name="isNewField">
                     <xsl:choose>
                        <xsl:when test="$fromTopCType!='false' and $isInherited='false'">
                           <xsl:text>true</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:text>false</xsl:text>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:with-param>
                  <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
                  <xsl:with-param name="typeList" select="concat($typeList, '*', $type/@name, '+')"/>
                  <xsl:with-param name="parentGroups" select="$parentGroups"/>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>
         <!-- Derivation by extension on complex content -->
         <xsl:when test="$type/xsd:complexContent/xsd:extension">
            <xsl:variable name="extension" select="$type/xsd:complexContent/xsd:extension"/>

            <xsl:variable name="baseTypeName">
               <xsl:call-template name="GetRefName">
                  <xsl:with-param name="ref" select="$extension/@base"/>
               </xsl:call-template>
            </xsl:variable>

            <xsl:choose>
               <xsl:when test="contains($typeList, concat('*', $baseTypeName, '+'))">
                  <xsl:call-template name="Repeat">
                     <xsl:with-param name="content"><xsl:text> </xsl:text></xsl:with-param>
                     <xsl:with-param name="count" select="$margin"/>
                  </xsl:call-template>
                  <span class="c">
                     <xsl:text>&lt;-- Extends: </xsl:text>
                     <xsl:call-template name="PrintTypeRef">
                        <xsl:with-param name="ref" select="$extension/@base"/>
                        <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
                     </xsl:call-template>
                     <xsl:text> (Circular type hierarchy) --&gt;</xsl:text>
                  </span>
                  <xsl:text>&#xa;</xsl:text>
               </xsl:when>
               <xsl:otherwise>
                  <!-- Look for base type -->
                  <xsl:variable name="defLoc">
                     <xsl:call-template name="FindComponent">
                        <xsl:with-param name="ref" select="$extension/@base"/>
                        <xsl:with-param name="compType">complex type</xsl:with-param>
                     </xsl:call-template>
                  </xsl:variable>

                  <xsl:choose>
                     <!-- Complex type was found in current schema. -->
                     <xsl:when test="normalize-space($defLoc)='this'">
                        <xsl:variable name="ctype" select="key('complexType', $baseTypeName)"/>
                        <xsl:call-template name="PrintSampleTypeContent">
                           <xsl:with-param name="type" select="$ctype"/>
                           <xsl:with-param name="margin" select="$margin"/>
                           <xsl:with-param name="isInherited">
                              <xsl:choose>
                                 <xsl:when test="$fromTopCType!='false'">
                                    <xsl:text>true</xsl:text>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:text>false</xsl:text>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:with-param>
                           <xsl:with-param name="isNewField" select="$isNewField"/>
                           <xsl:with-param name="fromTopCType" select="$fromTopCType"/>
                           <xsl:with-param name="addBR">false</xsl:with-param>
                           <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
                           <xsl:with-param name="typeList" select="concat($typeList, '*', $type/@name, '+')"/>
                           <xsl:with-param name="parentGroups" select="$parentGroups"/>
                        </xsl:call-template>
                     </xsl:when>
                     <!-- Complex type was not found. -->
                     <xsl:when test="normalize-space($defLoc)='' or normalize-space($defLoc)='none' or normalize-space($defLoc)='xml' or normalize-space($defLoc)='xsd'">
                        <xsl:call-template name="Repeat">
                           <xsl:with-param name="content"><xsl:text> </xsl:text></xsl:with-param>
                           <xsl:with-param name="count" select="$margin"/>
                        </xsl:call-template>
                        <span class="c">
                           <xsl:text>&lt;!-- '</xsl:text>
                           <xsl:call-template name="PrintTypeRef">
                              <xsl:with-param name="ref" select="$extension/@base"/>
                              <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
                           </xsl:call-template>
                           <xsl:text>' super type was not found in this schema. Some elements and attributes may be missing. --></xsl:text>
                        </span>
                        <xsl:text>&#xa;</xsl:text>
                     </xsl:when>
                     <!-- Complex type was found in external schema. -->
                     <xsl:otherwise>
                        <xsl:variable name="ctype" select="document($defLoc)/xsd:schema/xsd:complexType[@name=$baseTypeName]"/>
                        <xsl:call-template name="PrintSampleTypeContent">
                           <xsl:with-param name="type" select="$ctype"/>
                           <xsl:with-param name="margin" select="$margin"/>
                           <xsl:with-param name="isInherited">
                              <xsl:choose>
                                 <xsl:when test="$fromTopCType!='false'">
                                    <xsl:text>true</xsl:text>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:text>false</xsl:text>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:with-param>
                           <xsl:with-param name="isNewField" select="$isNewField"/>
                           <xsl:with-param name="fromTopCType" select="$fromTopCType"/>
                           <xsl:with-param name="addBR">false</xsl:with-param>
                           <xsl:with-param name="schemaLoc" select="$defLoc"/>
                           <xsl:with-param name="typeList" select="concat($typeList, '*', $type/@name, '+')"/>
                           <xsl:with-param name="parentGroups" select="$parentGroups"/>
                        </xsl:call-template>
                     </xsl:otherwise>
                  </xsl:choose>

                  <!-- Print out content from this type -->
                  <xsl:if test="$extension/xsd:*[local-name(.)!='annotation']">
                     <xsl:call-template name="PrintSampleParticleList">
                        <xsl:with-param name="list" select="$extension"/>
                        <xsl:with-param name="margin" select="$margin"/>
                        <xsl:with-param name="isInherited" select="$isInherited"/>
                        <xsl:with-param name="isNewField">
                           <xsl:choose>
                              <xsl:when test="$fromTopCType!='false' and $isInherited='false'">
                                 <xsl:text>true</xsl:text>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:text>false</xsl:text>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:with-param>
                        <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
                        <xsl:with-param name="typeList" select="concat($typeList, '*', $type/@name, '+')"/>
                        <xsl:with-param name="parentGroups" select="$parentGroups"/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <!-- Derivation by restriction on simple content -->
         <xsl:when test="$type/xsd:simpleContent/xsd:restriction">
            <!-- Print out simple type constraints-->
            <span style="margin-left: {$margin}em">
               <xsl:text> </xsl:text>
               <xsl:apply-templates select="$type/xsd:simpleContent" mode="sample">
                  <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
               </xsl:apply-templates>
               <xsl:text> </xsl:text>
            </span><br/>
         </xsl:when>
         <!-- Derivation by extension on simple content -->
         <xsl:when test="$type/xsd:simpleContent/xsd:extension">
            <!-- Print out base type name -->
            <xsl:call-template name="Repeat">
               <xsl:with-param name="content"><xsl:text> </xsl:text></xsl:with-param>
               <xsl:with-param name="count" select="$margin"/>
            </xsl:call-template>
               <xsl:text> </xsl:text>
               <xsl:call-template name="PrintTypeRef">
                  <xsl:with-param name="ref" select="$type/xsd:simpleContent/xsd:extension/@base"/>
                  <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
               </xsl:call-template>
               <xsl:text>&#xa;</xsl:text>
         </xsl:when>
         <!-- No derivation: complex type definition -->
         <xsl:when test="local-name($type)='complexType'">
            <!-- Print out content from this type -->
            <xsl:call-template name="PrintSampleParticleList">
               <xsl:with-param name="list" select="$type"/>
               <xsl:with-param name="margin" select="$margin"/>
               <xsl:with-param name="isInherited" select="$isInherited"/>
               <xsl:with-param name="isNewField" select="$isNewField"/>
               <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
               <xsl:with-param name="typeList" select="concat($typeList, '*', $type/@name, '+')"/>
               <xsl:with-param name="parentGroups" select="$parentGroups"/>
            </xsl:call-template>
         </xsl:when>
      </xsl:choose>
   </xsl:template>

   <!--
     Prints out sample XML instances from a list of
     element particle.
     Param(s):
            list (Node) required
                Node containing list of element particles
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
            isInherited (boolean) optional
                If true, display elements using 'inherited' CSS class.
            isNewField (boolean) optional
                If true, display elements using 'newFields' CSS class.
            schemaLoc (String) optional
                Schema file containing this particle list;
                if in current schema, 'schemaLoc' is set to 'this'.
            typeList (String) optional
                List of types in this call chain. Name of type starts
                with '*', and ends with '+'. (Used to prevent infinite
                recursive loop.)
     -->
   <xsl:template name="PrintSampleParticleList">
      <xsl:param name="list"/>
      <xsl:param name="margin">0</xsl:param>
      <xsl:param name="isInherited">false</xsl:param>
      <xsl:param name="isNewField">false</xsl:param>
      <xsl:param name="schemaLoc">this</xsl:param>
      <xsl:param name="typeList"/>
      <xsl:param name="parentGroups"/>

      <xsl:if test="$list">
         <xsl:apply-templates select="$list/xsd:group | $list/xsd:sequence | $list/xsd:choice | $list/xsd:all | $list/xsd:element" mode="sample">
            <xsl:with-param name="margin" select="$margin"/>
            <xsl:with-param name="isInherited" select="$isInherited"/>
            <xsl:with-param name="isNewField" select="$isNewField"/>
            <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
            <xsl:with-param name="typeList" select="$typeList"/>
            <xsl:with-param name="parentGroups" select="$parentGroups"/>
         </xsl:apply-templates>
      </xsl:if>
   </xsl:template>

   <!--
     Prints out the constraints of a complex type with simple content
     to be displayed within a sample XML instance.
     Param(s):
            schemaLoc (String) optional
                Schema file containing this simple content
                restriction; if in current schema, 'schemaLoc' is
                set to 'this'
     -->
   <xsl:template match="xsd:simpleContent[xsd:restriction]" mode="sample">
      <xsl:param name="schemaLoc">this</xsl:param>

      <span class="constraint">
         <xsl:call-template name="PrintSampleSimpleRestriction">
            <xsl:with-param name="restriction" select="./xsd:restriction"/>
            <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
         </xsl:call-template>
      </span>
   </xsl:template>

   <!--
     Prints out the constraints of a simple type definition to be
     displayed within a sample XML instance.
     Param(s):
            schemaLoc (String) optional
                Schema file containing this simple type definition;
                if in current schema, 'schemaLoc' is set to 'this'
     -->
   <xsl:template match="xsd:simpleType" mode="sample">
      <xsl:param name="schemaLoc">this</xsl:param>

      <span class="constraint">
         <xsl:call-template name="PrintSampleSimpleConstraints">
            <xsl:with-param name="simpleContent" select="."/>
            <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
         </xsl:call-template>
      </span>
   </xsl:template>

   <!--
     Prints out the constraints of simple content
     to be displayed within a sample XML instance.
     Param(s):
            simpleContent (Node) required
                Node containing with the simple content
            schemaLoc (String) optional
                Schema file containing these simple constraints;
                if in current schema, 'schemaLoc' is set to 'this'.
     -->
   <xsl:template name="PrintSampleSimpleConstraints">
      <xsl:param name="simpleContent"/>
      <xsl:param name="schemaLoc">this</xsl:param>
      <xsl:param name="typeList"/>

      <xsl:choose>
         <!-- Derivation by restriction -->
         <xsl:when test="$simpleContent/xsd:restriction">
            <xsl:call-template name="PrintSampleSimpleRestriction">
               <xsl:with-param name="restriction" select="$simpleContent/xsd:restriction"/>
               <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
               <xsl:with-param name="typeList" select="$typeList"/>
            </xsl:call-template>
         </xsl:when>
         <!-- Derivation by list -->
         <xsl:when test="$simpleContent/xsd:list">
            <xsl:choose>
               <xsl:when test="$simpleContent/xsd:list/@itemType">
                  <xsl:text>list of: </xsl:text>
                  <xsl:call-template name="PrintTypeRef">
                     <xsl:with-param name="ref" select="$simpleContent/xsd:list/@itemType"/>
                     <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
                  </xsl:call-template>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:text>list of: [ </xsl:text>
                  <xsl:call-template name="PrintSampleSimpleConstraints">
                     <xsl:with-param name="simpleContent" select="$simpleContent/xsd:list/xsd:simpleType"/>
                     <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
                  </xsl:call-template>
                  <xsl:text> ]</xsl:text>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <!-- Derivation by union -->
         <xsl:when test="$simpleContent/xsd:union">
            <xsl:text>union of: [ </xsl:text>

            <xsl:variable name="hasMemberTypes">
               <xsl:if test="normalize-space($simpleContent/xsd:union/@memberTypes)!=''">
                  <xsl:text>true</xsl:text>
               </xsl:if>
            </xsl:variable>
            <xsl:if test="$hasMemberTypes='true'">
               <xsl:call-template name="PrintWhitespaceList">
                  <xsl:with-param name="value" select="$simpleContent/xsd:union/@memberTypes"/>
                  <xsl:with-param name="compType">type</xsl:with-param>
                  <xsl:with-param name="separator">,</xsl:with-param>
                  <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
               </xsl:call-template>
            </xsl:if>
            <xsl:for-each select="$simpleContent/xsd:union/xsd:simpleType">
               <xsl:if test="position()!=1 or $hasMemberTypes='true'">
                  <xsl:text>, </xsl:text>
               </xsl:if>
               <xsl:text>[ </xsl:text>
               <xsl:call-template name="PrintSampleSimpleConstraints">
                  <xsl:with-param name="simpleContent" select="."/>
                  <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
               </xsl:call-template>
               <xsl:text> ]</xsl:text>
            </xsl:for-each>

            <xsl:text> ]</xsl:text>
         </xsl:when>
      </xsl:choose>
   </xsl:template>

   <!--
     Prints out the constraints of simple content
     derived by restriction, which is to be displayed
     within a sample XML instance.
     Param(s):
            restriction (Node) required
                Node containing with the restriction
            schemaLoc (String) optional
                Schema file containing this restriction element;
                if in current schema, 'schemaLoc' is set to 'this'.
     -->
   <xsl:template name="PrintSampleSimpleRestriction">
      <xsl:param name="restriction"/>
      <xsl:param name="schemaLoc">this</xsl:param>
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
            <xsl:call-template name="PrintSampleSimpleConstraints">
               <xsl:with-param name="simpleContent" select="$restriction/xsd:simpleType"/>
               <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
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
            <!-- Write out reference to base type -->
            <xsl:call-template name="PrintTypeRef">
               <xsl:with-param name="ref" select="$baseTypeRef"/>
               <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
            </xsl:call-template>
         </xsl:when>
      </xsl:choose>

      <!-- Regular Expression Pattern -->
      <xsl:variable name="pattern">
         <xsl:call-template name="PrintPatternFacet">
            <xsl:with-param name="simpleRestrict" select="$restriction"/>
         </xsl:call-template>
      </xsl:variable>
      <!-- Range -->
      <xsl:variable name="range">
         <xsl:call-template name="PrintRangeFacets">
            <xsl:with-param name="simpleRestrict" select="$restriction"/>
         </xsl:call-template>
      </xsl:variable>
      <!-- Length -->
      <xsl:variable name="length">
         <xsl:call-template name="PrintLengthFacets">
            <xsl:with-param name="simpleRestrict" select="$restriction"/>
         </xsl:call-template>
      </xsl:variable>

      <!-- Print out facets -->
      <xsl:if test="$restriction/xsd:enumeration">
         <xsl:text> (</xsl:text>
         <xsl:call-template name="PrintEnumFacets">
            <xsl:with-param name="simpleRestrict" select="$restriction"/>
         </xsl:call-template>
         <xsl:text>)</xsl:text>
      </xsl:if>
      <xsl:if test="$pattern !=''">
         <xsl:text> (</xsl:text>
         <xsl:copy-of select="$pattern"/>
         <xsl:text>)</xsl:text>
      </xsl:if>
      <xsl:if test="$range !=''">
         <xsl:text> (</xsl:text>
         <xsl:copy-of select="$range"/>
         <xsl:text>)</xsl:text>
      </xsl:if>
      <xsl:if test="$restriction/xsd:totalDigits">
         <xsl:text> (</xsl:text>
         <xsl:call-template name="PrintTotalDigitsFacet">
            <xsl:with-param name="simpleRestrict" select="$restriction"/>
         </xsl:call-template>
         <xsl:text>)</xsl:text>
      </xsl:if>
      <xsl:if test="$restriction/xsd:fractionDigits">
         <xsl:text> (</xsl:text>
         <xsl:call-template name="PrintFractionDigitsFacet">
            <xsl:with-param name="simpleRestrict" select="$restriction"/>
         </xsl:call-template>
         <xsl:text>)</xsl:text>
      </xsl:if>
      <xsl:if test="$length !=''">
         <xsl:text> (</xsl:text>
         <xsl:copy-of select="$length"/>
         <xsl:text>)</xsl:text>
      </xsl:if>
      <xsl:if test="$restriction/xsd:whiteSpace">
         <xsl:text> (</xsl:text>
         <xsl:call-template name="PrintWhitespaceFacet">
            <xsl:with-param name="simpleRestrict" select="$restriction"/>
         </xsl:call-template>
         <xsl:text>)</xsl:text>
      </xsl:if>
   </xsl:template>

</xsl:stylesheet>