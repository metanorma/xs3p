<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!--
  XS3P Content Generator Module: Hierarchy Tables
  This module generates type hierarchy tables showing substitution groups and type relationships.
-->
<xsl:stylesheet
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns="http://www.w3.org/1999/xhtml"
 xmlns:xsd="http://www.w3.org/2001/XMLSchema"
 version="1.0">

   <!-- Dependencies -->
   <xsl:include href="../core/constants.xsl"/>
   <xsl:include href="../core/keys.xsl"/>
   <xsl:include href="../utils/references.xsl"/>
   <xsl:include href="../renderers/ui-components.xsl"/>
   <xsl:include href="../generators/component-links.xsl"/>

   <!-- ******** Hierarchy table ******** -->

   <!--
     Prints out substitution group hierarchy for
     element declarations.
     -->
   <xsl:template match="xsd:element" mode="hierarchy">
      <!--
        Find out members of substitution group that this element
        heads.
        -->
      <xsl:variable name="members">
         <ul>
            <xsl:call-template name="PrintSGroupMembers">
               <xsl:with-param name="element" select="."/>
            </xsl:call-template>
         </ul>
      </xsl:variable>
      <xsl:variable name="hasMembers">
         <xsl:if test="normalize-space($members)!=''">
            <xsl:text>true</xsl:text>
         </xsl:if>
      </xsl:variable>
      <!-- Print hierarchy table -->
      <xsl:if test="@substitutionGroup or normalize-space($hasMembers)='true'">
         <xsl:variable name="contents">
            <table class="table table-striped xs3p-in-panel-table">
               <tbody>
                  <tr>
                     <td>
                        <ul>
                           <!-- Print substitution group that this element belongs to -->
                           <xsl:if test="@substitutionGroup">
                              <li>
                                 <em>This element can be used wherever the following element is referenced:</em>
                                 <ul>
                                    <li>
                                       <xsl:call-template name="PrintElementRef">
                                          <xsl:with-param name="ref" select="@substitutionGroup"/>
                                       </xsl:call-template>
                                    </li>
                                 </ul>
                              </li>
                           </xsl:if>
                           <!-- Print substitution group that this element heads -->
                           <xsl:if test="normalize-space($hasMembers)='true'">
                              <li>
                                 <em>The following elements can be used wherever this element is referenced:</em>
                                 <xsl:copy-of select="$members"/>
                              </li>
                           </xsl:if>
                        </ul>
                     </td>
                  </tr>
               </tbody>
            </table>
         </xsl:variable>
         <xsl:choose>
            <xsl:when test="$showCollapseableBox = 'true'">
               <xsl:call-template name="CollapseableBox">
                  <xsl:with-param name="id">
                     <xsl:call-template name="GetComponentID">
                        <xsl:with-param name="component" select="."/>
                     </xsl:call-template>
                  </xsl:with-param>
                  <xsl:with-param name="anchor">type-hierarchy</xsl:with-param>
                  <xsl:with-param name="styleClass">sample</xsl:with-param>
                  <xsl:with-param name="caption">Type hierarchy</xsl:with-param>
                  <xsl:with-param name="contents">
                     <xsl:copy-of select="$contents"/>
                  </xsl:with-param>
                  <xsl:with-param name="isOpened">true</xsl:with-param>
                  <xsl:with-param name="omitPanelContainer">true</xsl:with-param>
               </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
               <xsl:call-template name="DLBlock">
                 <xsl:with-param name="id">
                     <xsl:call-template name="GetComponentID">
                        <xsl:with-param name="component" select="."/>
                     </xsl:call-template>
                  </xsl:with-param>
                  <xsl:with-param name="caption">Type hierarchy</xsl:with-param>
                  <xsl:with-param name="contents">
                     <!-- <xsl:apply-templates select="exslt:node-set($contents)" mode="table_to_dl"/> -->
                     <xsl:copy-of select="$contents"/>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>
   </xsl:template>

   <!--
     Prints out Hierarchy table for complex type definitions.
     -->
   <xsl:template match="xsd:complexType" mode="hierarchy">
      <xsl:variable name="contents">
         <table class="table table-striped xs3p-in-panel-table">
            <tbody>
               <!-- Print super types -->
             <xsl:if test="xsd:simpleContent or xsd:complexContent">
               <tr>
                  <th>
                     <xsl:choose>
                        <xsl:when test="normalize-space(translate($printAllSuperTypes, 'TRUE', 'true'))='true'">
                           <xsl:text>Super-types:</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:text>Parent type:</xsl:text>
                        </xsl:otherwise>
                     </xsl:choose>
                  </th>
                  <td>
                     <xsl:choose>
                        <xsl:when test="xsd:simpleContent or xsd:complexContent">
                           <xsl:call-template name="PrintSupertypes">
                              <xsl:with-param name="type" select="."/>
                           </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:text>None</xsl:text>
                        </xsl:otherwise>
                     </xsl:choose>
                  </td>
               </tr>
               </xsl:if>
               <!-- Print sub types -->
               <xsl:variable name="subTypes">
                  <xsl:call-template name="PrintComplexSubtypes">
                        <xsl:with-param name="type" select="."/>
                     </xsl:call-template>
               </xsl:variable>
               <xsl:if test="normalize-space($subTypes) != 'None'">
                  <tr>
                     <th>
                        <xsl:choose>
                           <xsl:when test="normalize-space(translate($printAllSubTypes, 'TRUE', 'true'))='true'">
                              <xsl:text>Sub-types:</xsl:text>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:text>Direct sub-types:</xsl:text>
                           </xsl:otherwise>
                        </xsl:choose>
                     </th>
                     <td>
                        <xsl:copy-of select="$subTypes"/>
                     </td>
                  </tr>
               </xsl:if>
            </tbody>
         </table>
      </xsl:variable>
      <xsl:choose>
         <xsl:when test="$showCollapseableBox = 'true'">
            <xsl:call-template name="CollapseableBox">
               <xsl:with-param name="id">
                  <xsl:call-template name="GetComponentID">
                     <xsl:with-param name="component" select="."/>
                  </xsl:call-template>
               </xsl:with-param>
               <xsl:with-param name="anchor">type-hierarchy</xsl:with-param>
               <xsl:with-param name="styleClass">sample</xsl:with-param>
               <xsl:with-param name="caption">Type hierarchy</xsl:with-param>
               <xsl:with-param name="contents">
                  <xsl:copy-of select="$contents"/>
               </xsl:with-param>
               <xsl:with-param name="isOpened">true</xsl:with-param>
               <xsl:with-param name="omitPanelContainer">true</xsl:with-param>
            </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
            <xsl:call-template name="DLBlock">
              <xsl:with-param name="id">
                  <xsl:call-template name="GetComponentID">
                     <xsl:with-param name="component" select="."/>
                  </xsl:call-template>
               </xsl:with-param>
               <xsl:with-param name="caption">Type hierarchy</xsl:with-param>
               <xsl:with-param name="contents">
                  <xsl:apply-templates select="exslt:node-set($contents)" mode="table_to_dl"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--
     Prints out Hierarchy table for simple type definitions.
     -->
   <xsl:template match="xsd:simpleType" mode="hierarchy">
      <xsl:variable name="contents">
         <table class="table table-striped xs3p-in-panel-table">
            <tbody>
               <!-- Print super types -->
               <tr>
                  <th>
                     <xsl:choose>
                        <xsl:when test="normalize-space(translate($printAllSuperTypes, 'TRUE', 'true'))='true'">
                           <xsl:text>Super-types:</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:text>Parent type:</xsl:text>
                        </xsl:otherwise>
                     </xsl:choose>
                  </th>
                  <td>
                     <xsl:choose>
                        <xsl:when test="xsd:restriction">
                           <xsl:call-template name="PrintSupertypes">
                              <xsl:with-param name="type" select="."/>
                           </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:text>None</xsl:text>
                        </xsl:otherwise>
                     </xsl:choose>
                  </td>
               </tr>
               <!-- Print sub types -->
               <tr>
                  <th>
                     <xsl:choose>
                        <xsl:when test="normalize-space(translate($printAllSubTypes, 'TRUE', 'true'))='true'">
                           <xsl:text>Sub-types:</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:text>Direct sub-types:</xsl:text>
                        </xsl:otherwise>
                     </xsl:choose>
                  </th>
                  <td>
                     <xsl:call-template name="PrintSimpleSubtypes">
                        <xsl:with-param name="type" select="."/>
                     </xsl:call-template>
                  </td>
               </tr>
            </tbody>
         </table>
      </xsl:variable>
      <xsl:choose>
         <xsl:when test="$showCollapseableBox = 'true'">
            <xsl:call-template name="CollapseableBox">
               <xsl:with-param name="id">
                  <xsl:call-template name="GetComponentID">
                     <xsl:with-param name="component" select="."/>
                  </xsl:call-template>
               </xsl:with-param>
               <xsl:with-param name="anchor">type-hierarchy</xsl:with-param>
               <xsl:with-param name="styleClass">sample</xsl:with-param>
               <xsl:with-param name="caption">Type hierarchy</xsl:with-param>
               <xsl:with-param name="contents">
                  <xsl:copy-of select="$contents"/>
               </xsl:with-param>
               <xsl:with-param name="isOpened">true</xsl:with-param>
               <xsl:with-param name="omitPanelContainer">true</xsl:with-param>
            </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
				<xsl:call-template name="DLBlock">
              <xsl:with-param name="id">
                  <xsl:call-template name="GetComponentID">
                     <xsl:with-param name="component" select="."/>
                  </xsl:call-template>
               </xsl:with-param>
               <xsl:with-param name="caption">Type hierarchy</xsl:with-param>
               <xsl:with-param name="contents">
                  <xsl:apply-templates select="exslt:node-set($contents)" mode="table_to_dl"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--
     Unmatched template for 'hierarchy' mode
     -->
   <xsl:template match="*" mode="hierarchy"/>

   <!--
     Prints out members, if any, of the substitution group that a
     given element declaration heads.
     Assumes it will be called within XHTML <ul> tags.
     Param(s):
            element (Node) required
              Top-level element declaration
            elementList (String) optional
                List of elements in this call chain. Name of element starts
                with '*', and ends with '+'. (Used to prevent infinite
                recursive loop.)
     -->
   <xsl:template name="PrintSGroupMembers">
      <xsl:param name="element"/>
      <xsl:param name="elementList"/>

      <xsl:variable name="elemName" select="normalize-space($element/@name)"/>
      <xsl:choose>
         <xsl:when test="contains($elementList, concat('*', $elemName, '+'))">
            <!-- Circular element substitution group hierarchy -->
            <li>
               <xsl:call-template name="HandleError">
                  <xsl:with-param name="isTerminating">false</xsl:with-param>
                  <xsl:with-param name="errorMsg">
                     <xsl:text>Circular element reference to: </xsl:text>
                     <xsl:value-of select="$elemName"/>
                  </xsl:with-param>
               </xsl:call-template>
            </li>
         </xsl:when>
         <xsl:otherwise>
            <!-- Get 'block' attribute. -->
            <xsl:variable name="block">
               <xsl:call-template name="PrintBlockSet">
                  <xsl:with-param name="EBV">
                     <xsl:choose>
                        <xsl:when test="$element/@block">
                           <xsl:value-of select="$element/@block"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="/xsd:schema/@blockDefault"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:variable>

            <xsl:for-each select="/xsd:schema/xsd:element[normalize-space(@substitutionGroup)=$elemName or normalize-space(substring-after(@substitutionGroup, ':'))=$elemName]">
               <li>
                  <xsl:call-template name="PrintElementRef">
                     <xsl:with-param name="name" select="@name"/>
                  </xsl:call-template>
               </li>
               <!-- Recursively find members of a substitution group that
                    current element in list might head, since substitution
                    groups are transitive (unless 'substitution' is
                    blocked).
                -->
               <xsl:if test="not(contains($block, 'substitution'))">
                  <xsl:call-template name="PrintSGroupMembers">
                     <xsl:with-param name="element" select="."/>
                     <xsl:with-param name="elementList" select="concat($elementList, '*', $elemName, '+')"/>
                  </xsl:call-template>
               </xsl:if>
            </xsl:for-each>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--
     Prints out the super types of a given type definition.
     Param(s):
            type (Node) required
                Type definition
            isCallingType (boolean) optional
                If true, 'type' is the type definition that starts
                this call. Otherwise, this is a recursive call from
                'PrintSupertypes' itself.
            typeList (String) optional
                List of types in this call chain. Name of type starts
                with '*', and ends with '+'. (Used to prevent infinite
                recursive loop.)
     -->
   <xsl:template name="PrintSupertypes">
      <xsl:param name="type"/>
      <xsl:param name="isCallingType">true</xsl:param>
      <xsl:param name="typeList"/>

      <xsl:variable name="typeName" select="$type/@name"/>
      <xsl:choose>
         <!-- Circular type hierarchy -->
         <xsl:when test="contains($typeList, concat('*', $typeName, '+'))">
            <!-- Note: Error message will be written out in the Sample Instance table. -->
            <xsl:value-of select="$typeName"/>
         </xsl:when>
         <xsl:otherwise>
            <!-- Get base type reference -->
            <xsl:variable name="baseTypeRef">
               <xsl:choose>
                  <!-- Complex type definition -->
                  <xsl:when test="local-name($type)='complexType'">
                     <xsl:choose>
                        <xsl:when test="$type/xsd:simpleContent/xsd:extension">
                           <xsl:value-of select="$type/xsd:simpleContent/xsd:extension/@base"/>
                        </xsl:when>
                        <xsl:when test="$type/xsd:simpleContent/xsd:restriction">
                           <xsl:value-of select="$type/xsd:simpleContent/xsd:restriction/@base"/>
                        </xsl:when>
                        <xsl:when test="$type/xsd:complexContent/xsd:extension">
                           <xsl:value-of select="$type/xsd:complexContent/xsd:extension/@base"/>
                        </xsl:when>
                        <xsl:when test="$type/xsd:complexContent/xsd:restriction">
                           <xsl:value-of select="$type/xsd:complexContent/xsd:restriction/@base"/>
                        </xsl:when>
                     </xsl:choose>
                  </xsl:when>
                  <!-- Simple type definition -->
                  <xsl:when test="local-name($type)='simpleType'">
                     <xsl:choose>
                        <xsl:when test="$type/xsd:restriction/@base">
                           <xsl:value-of select="$type/xsd:restriction/@base"/>
                        </xsl:when>
                        <xsl:when test="$type/xsd:restriction/xsd:simpleType">
                           <xsl:text>Local type definition</xsl:text>
                        </xsl:when>
                     </xsl:choose>
                  </xsl:when>
               </xsl:choose>
            </xsl:variable>

            <!-- Get derivation method -->
            <xsl:variable name="derive">
               <!-- Complex type definition -->
               <xsl:choose>
                  <xsl:when test="local-name($type)='complexType'">
                     <xsl:choose>
                        <xsl:when test="$type/xsd:simpleContent/xsd:extension or $type/xsd:complexContent/xsd:extension">
                           <xsl:text>extension</xsl:text>
                        </xsl:when>
                        <xsl:when test="$type/xsd:simpleContent/xsd:restriction or $type/xsd:complexContent/xsd:restriction">
                           <xsl:text>restriction</xsl:text>
                        </xsl:when>
                     </xsl:choose>
                  </xsl:when>
                  <!-- Simple type definition -->
                  <xsl:when test="local-name($type)='simpleType'">
                     <xsl:text>restriction</xsl:text>
                  </xsl:when>
               </xsl:choose>
            </xsl:variable>

            <xsl:choose>
               <!-- Print out entire hierarchy -->
               <xsl:when test="normalize-space(translate($printAllSuperTypes, 'TRUE', 'true'))='true'">
                  <xsl:choose>
                     <xsl:when test="normalize-space($baseTypeRef)='Local type definition'">
                        <xsl:value-of select="$baseTypeRef"/>
                        <!-- Symbol to indicate type derivation-->
                        <xsl:text> &lt; </xsl:text>
                     </xsl:when>
                     <xsl:when test="normalize-space($baseTypeRef)!=''">
                        <!-- Get base type name from reference -->
                        <xsl:variable name="baseTypeName">
                           <xsl:call-template name="GetRefName">
                              <xsl:with-param name="ref" select="$baseTypeRef"/>
                           </xsl:call-template>
                        </xsl:variable>
                        <!-- Get base type definition from schema -->
                        <xsl:variable name="baseType" select="key('type', $baseTypeName)"/>
                        <xsl:choose>
                           <!-- Base type was found in this schema -->
                           <xsl:when test="$baseType">
                              <!-- Make recursive call to print out base type and itself -->
                              <xsl:call-template name="PrintSupertypes">
                                 <xsl:with-param name="type" select="$baseType"/>
                                 <xsl:with-param name="isCallingType">false</xsl:with-param>
                                 <xsl:with-param name="typeList" select="concat($typeList, '*', $typeName, '+')"/>
                              </xsl:call-template>
                           </xsl:when>
                           <!-- Base type was not found in this schema -->
                           <xsl:otherwise>
                              <xsl:call-template name="PrintTypeRef">
                                 <xsl:with-param name="ref" select="$baseTypeRef"/>
                              </xsl:call-template>
                           </xsl:otherwise>
                        </xsl:choose>
                        <!-- Symbol to indicate type derivation -->
                        <xsl:text> &lt; </xsl:text>
                     </xsl:when>
                     <xsl:otherwise>
                        <!-- IGNORE: Base type may not be exist probably because
                            current type does not be derived from another type.
                        -->
                     </xsl:otherwise>
                  </xsl:choose>
                  <!-- Print out current type's name -->
                  <xsl:choose>
                     <xsl:when test="$isCallingType='true'">
                        <strong><xsl:value-of select="$typeName"/></strong>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:call-template name="PrintTypeRef">
                           <xsl:with-param name="name" select="$typeName"/>
                        </xsl:call-template>
                     </xsl:otherwise>
                  </xsl:choose>
                  <!-- Print out derivation method -->
                  <xsl:if test="$derive != ''">
                     <xsl:text> (by </xsl:text>
                     <xsl:value-of select="$derive"/>
                     <xsl:text>)</xsl:text>
                  </xsl:if>
               </xsl:when>
               <!-- Print out parent type only -->
               <xsl:otherwise>
                  <!-- Print out base type reference -->
                  <xsl:choose>
                     <xsl:when test="normalize-space($baseTypeRef)='Local type definition'">
                        <xsl:value-of select="$baseTypeRef"/>
                     </xsl:when>
                     <xsl:when test="$baseTypeRef!=''">
                        <xsl:call-template name="PrintTypeRef">
                           <xsl:with-param name="ref" select="$baseTypeRef"/>
                        </xsl:call-template>
                     </xsl:when>
                     <xsl:otherwise>
                        <!-- IGNORE: Base type may not be exist probably because
                             current type does not be derived from another type.
                        -->
                     </xsl:otherwise>
                  </xsl:choose>
                  <!-- Print out derivation method -->
                  <xsl:if test="$derive != ''">
                     <xsl:text> (derivation method: </xsl:text>
                     <xsl:value-of select="$derive"/>
                     <xsl:text>)</xsl:text>
                  </xsl:if>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--
     Prints out the sub types of a given complex type definition.
     Param(s):
            type (Node) required
                Complex type definition
            isCallingType (boolean) optional
                If true, 'type' is the type definition that starts this
                call. Otherwise, this is a recursive call from
                'PrintComplexSubtypes' itself.
            typeList (String) optional
                List of types in this call chain. Name of type starts
                with '*', and ends with '+'. (Used to prevent infinite
                recursive loop.)
     -->
   <xsl:template name="PrintComplexSubtypes">
      <xsl:param name="type"/>
      <xsl:param name="isCallingType">true</xsl:param>
      <xsl:param name="typeList"/>

      <xsl:variable name="typeName" select="normalize-space($type/@name)"/>
      <xsl:choose>
         <!-- Circular type hierarchy -->
         <xsl:when test="contains($typeList, concat('*', $typeName, '+'))">
            <!-- Do nothing. Note: Error message will be written out in the Sample Instance table. -->
         </xsl:when>
         <xsl:otherwise>
            <!-- Find sub types -->
            <xsl:variable name="subTypes">
               <ul>
                  <xsl:for-each select="/xsd:schema/xsd:complexType/xsd:complexContent/xsd:restriction[normalize-space(@base)=$typeName or normalize-space(substring-after(@base, ':'))=$typeName] | /xsd:schema/xsd:complexType/xsd:complexContent/xsd:extension[normalize-space(@base)=$typeName or normalize-space(substring-after(@base, ':'))=$typeName]">
                     <li>
                        <xsl:variable name="subType" select="../.."/>
                        <!-- Write out type name -->
                        <xsl:call-template name="PrintTypeRef">
                           <xsl:with-param name="name" select="$subType/@name"/>
                        </xsl:call-template>
                        <!-- Write derivation method -->
                        <xsl:text> (by </xsl:text>
                        <xsl:value-of select="local-name(.)"/>
                        <xsl:text>)</xsl:text>
                        <!-- Make recursive call to write sub-types of this sub-type -->
                        <xsl:if test="normalize-space(translate($printAllSubTypes, 'TRUE', 'true'))='true'">
                           <xsl:call-template name="PrintComplexSubtypes">
                              <xsl:with-param name="type" select="$subType"/>
                              <xsl:with-param name="isCallingType">false</xsl:with-param>
                              <xsl:with-param name="typeList" select="concat($typeList, '*', $typeName, '+')"/>
                           </xsl:call-template>
                        </xsl:if>
                     </li>
                  </xsl:for-each>
               </ul>
            </xsl:variable>
            <!-- Print out sub types -->
            <xsl:choose>
               <xsl:when test="normalize-space($subTypes)!=''">
                  <xsl:copy-of select="$subTypes"/>
               </xsl:when>
               <xsl:when test="$isCallingType='true'">
                  <xsl:text>None</xsl:text>
               </xsl:when>
            </xsl:choose>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--
        Prints out the sub types of a given simple type definition.
        Param(s):
            type (Node) required
                Simple type definition
            isCallingType (boolean) optional
                If true, 'type' is the type definition that starts this
                call. Otherwise, this is a recursive call from
                'PrintSimpleSubtypes'
            typeList (String) optional
                List of types in this call chain. Name of type starts
                with '*', and ends with '+'. (Used to prevent infinite
                recursive loop.)
     -->
   <xsl:template name="PrintSimpleSubtypes">
      <xsl:param name="type"/>
      <xsl:param name="isCallingType">true</xsl:param>
      <xsl:param name="typeList"/>

      <xsl:variable name="typeName" select="normalize-space($type/@name)"/>
      <xsl:choose>
         <!-- Circular type hierarchy -->
         <xsl:when test="contains($typeList, concat('*', $typeName, '+'))">
            <!-- Do nothing. Note: Error message will be written out in the Sample Instance table. -->
         </xsl:when>
         <xsl:otherwise>
            <!-- Find sub-types that are simple type definitions -->
            <xsl:variable name="simpleSubTypes">
               <ul>
                  <xsl:for-each select="/xsd:schema/xsd:simpleType/xsd:restriction[normalize-space(@base)=$typeName or normalize-space(substring-after(@base, ':'))=$typeName]">
                     <li>
                        <xsl:variable name="subType" select=".."/>
                        <!-- Write out type name -->
                        <xsl:call-template name="PrintTypeRef">
                           <xsl:with-param name="name" select="$subType/@name"/>
                        </xsl:call-template>
                        <!-- Write derivation method -->
                        <xsl:text> (by restriction)</xsl:text>
                        <!-- Make recursive call to write sub-types of this sub-type -->
                        <xsl:if test="normalize-space(translate($printAllSubTypes, 'TRUE', 'true'))='true'">
                           <xsl:call-template name="PrintSimpleSubtypes">
                              <xsl:with-param name="type" select="$subType"/>
                              <xsl:with-param name="isCallingType">false</xsl:with-param>
                              <xsl:with-param name="typeList" select="concat($typeList, '*', $typeName, '+')"/>
                           </xsl:call-template>
                        </xsl:if>
                     </li>
                  </xsl:for-each>
               </ul>
            </xsl:variable>
            <!-- Find sub-types that are complex type definitions -->
            <xsl:variable name="complexSubTypes">
               <ul>
                  <xsl:for-each select="/xsd:schema/xsd:complexType/xsd:simpleContent/xsd:restriction[normalize-space(@base)=$typeName or normalize-space(substring-after(@base, ':'))=$typeName] | /xsd:schema/xsd:complexType/xsd:simpleContent/xsd:extension[normalize-space(@base)=$typeName or normalize-space(substring-after(@base, ':'))=$typeName]">
                     <li>
                        <xsl:variable name="subType" select="../.."/>
                        <!-- Write out type name -->
                        <xsl:call-template name="PrintTypeRef">
                           <xsl:with-param name="name" select="$subType/@name"/>
                        </xsl:call-template>
                        <!-- Write derivation method -->
                        <xsl:text> (by </xsl:text>
                        <xsl:value-of select="local-name(.)"/>
                        <xsl:text>)</xsl:text>
                        <!-- Make recursive call to write sub-types of this sub-type -->
                        <xsl:if test="normalize-space(translate($printAllSubTypes, 'TRUE', 'true'))='true'">
                           <xsl:call-template name="PrintComplexSubtypes">
                              <xsl:with-param name="type" select="$subType"/>
                              <xsl:with-param name="isCallingType">false</xsl:with-param>
                              <xsl:with-param name="typeList" select="concat($typeList, '*', $typeName, '+')"/>
                           </xsl:call-template>
                        </xsl:if>
                     </li>
                  </xsl:for-each>
               </ul>
            </xsl:variable>

            <xsl:variable name="hasSimpleSubTypes">
               <xsl:if test="normalize-space($simpleSubTypes)!=''">
                  <xsl:text>true</xsl:text>
               </xsl:if>
            </xsl:variable>
            <xsl:variable name="hasComplexSubTypes">
               <xsl:if test="normalize-space($complexSubTypes)!=''">
                  <xsl:text>true</xsl:text>
               </xsl:if>
            </xsl:variable>
            <!-- Print out sub types -->
            <xsl:choose>
               <xsl:when test="$hasSimpleSubTypes='true' or $hasComplexSubTypes='true'">
                  <xsl:if test="$hasSimpleSubTypes='true'">
                     <xsl:copy-of select="$simpleSubTypes"/>
                  </xsl:if>
                  <xsl:if test="$hasComplexSubTypes='true'">
                     <xsl:copy-of select="$complexSubTypes"/>
                  </xsl:if>
               </xsl:when>
               <xsl:when test="$isCallingType='true'">
                  <xsl:text>None</xsl:text>
               </xsl:when>
            </xsl:choose>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

</xsl:stylesheet>
