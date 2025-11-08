<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!--
  XS3P Content Generator Module: Instance Samples - Attributes
  This module contains attribute-related templates for XML instance representation.

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
     Prints out a sample XML instance representation
     of an attribute declaration.
     Param(s):
            subTypeAttrs (String) optional
                List of attributes in sub-types of the type that
                contains this attribute
            isInherited (boolean) optional
                If true, display attribute using 'inherited' CSS
                class.
            isNewField (boolean) optional
                If true, display attribute using 'newFields' CSS
                class.
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
            addBR (boolean) optional
                If true, add <br/> before attribute.
            schemaLoc (String) optional
                Schema file containing this attribute declaration;
                if in current schema, 'schemaLoc' is set to 'this'.
     -->
   <xsl:template match="xsd:attribute[@name]" mode="sample">
      <xsl:param name="subTypeAttrs"/>
      <xsl:param name="isInherited">false</xsl:param>
      <xsl:param name="isNewField">false</xsl:param>
      <xsl:param name="margin">0</xsl:param>
      <xsl:param name="addBR">false</xsl:param>
      <xsl:param name="schemaLoc">this</xsl:param>

      <!-- Get attribute namespace -->
      <xsl:variable name="attrNS">
         <xsl:call-template name="GetAttributeNS">
            <xsl:with-param name="attribute" select="."/>
         </xsl:call-template>
      </xsl:variable>

      <xsl:choose>
         <xsl:when test="contains($subTypeAttrs, concat('*', normalize-space($attrNS), '+', normalize-space(@name), '+'))">
            <!-- IGNORE: Sub type has attribute with same name;
                 Sub-type's attribute declaration will override this
                 one. -->
         </xsl:when>
         <xsl:when test="@use and normalize-space(@use)='prohibited'">
            <!-- IGNORE: Attribute is prohibited. -->
         </xsl:when>
         <xsl:otherwise>
            <xsl:call-template name="Repeat">
               <xsl:with-param name="content">
                  <xsl:text> </xsl:text>
               </xsl:with-param>
               <xsl:with-param name="count" select="$margin"/>
            </xsl:call-template>

            <span class="na">
               <xsl:variable name="prefix">
                  <xsl:call-template name="GetAttributePrefix">
                     <xsl:with-param name="attribute" select="."/>
                  </xsl:call-template>
               </xsl:variable>
               <xsl:call-template name="PrintNSPrefix">
                  <xsl:with-param name="prefix" select="$prefix"/>
                  <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
               </xsl:call-template>
               <xsl:value-of select="@name"/>
               <xsl:text>=</xsl:text>
            </span>
            <span class="s">
               <xsl:text>"</xsl:text>

               <xsl:choose>
                  <!-- Fixed value is provided -->
                  <xsl:when test="@fixed">
                     <span class="fixed">
                        <xsl:value-of select="@fixed"/>
                     </span>
                  </xsl:when>
                  <!-- Type reference is provided -->
                  <xsl:when test="@type">
                     <xsl:call-template name="PrintTypeRef">
                        <xsl:with-param name="ref" select="@type"/>
                        <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
                     </xsl:call-template>
                  </xsl:when>
                  <!-- Local type definition is provided -->
                  <xsl:when test="xsd:simpleType">
                     <xsl:apply-templates select="xsd:simpleType" mode="sample">
                        <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
                     </xsl:apply-templates>
                  </xsl:when>
                  <xsl:otherwise>
                     <span class="type">anySimpleType</span>
                  </xsl:otherwise>
               </xsl:choose>
               <xsl:text>"</xsl:text>
            </span>

            <!-- Don't print occurrence info and documentation
                 for global attributes. -->
            <xsl:if test="local-name(..)!='schema'">
               <!-- Occurrence info-->
               <xsl:text> </xsl:text>
               <xsl:call-template name="PrintOccurs">
                  <xsl:with-param name="component" select="."/>
               </xsl:call-template>
               <!-- Documentation -->
               <xsl:call-template name="PrintSampleDocumentation">
                  <xsl:with-param name="component" select="."/>
               </xsl:call-template>
            </xsl:if>

            <xsl:text>&#xa;</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--
     Prints out a sample XML instance representation
     of an attribute reference.
     Param(s):
            subTypeAttrs (String) optional
                List of attribute in sub-types of the type that
                contains this attribute
            isInherited (boolean) optional
                If true, display attributes using 'inherited' CSS
                class.
            isNewField (boolean) optional
                If true, display attributes using 'newFields' CSS
                class.
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
            addBR (boolean) optional
                If true, add <br/> before attribute.
            schemaLoc (String) optional
                Schema file containing this attribute reference;
                if in current schema, 'schemaLoc' is set to 'this'
     -->
   <xsl:template match="xsd:attribute[@ref]" mode="sample">
      <xsl:param name="subTypeAttrs"/>
      <xsl:param name="isInherited">false</xsl:param>
      <xsl:param name="isNewField">false</xsl:param>
      <xsl:param name="margin">0</xsl:param>
      <xsl:param name="addBR">false</xsl:param>
      <xsl:param name="schemaLoc">this</xsl:param>

      <!-- Get attribute name -->
      <xsl:variable name="attrName">
         <xsl:call-template name="GetRefName">
            <xsl:with-param name="ref" select="@ref"/>
         </xsl:call-template>
      </xsl:variable>

      <!-- Get attribute namespace -->
      <xsl:variable name="attrNS">
         <xsl:call-template name="GetAttributeNS">
            <xsl:with-param name="attribute" select="."/>
         </xsl:call-template>
      </xsl:variable>

      <xsl:choose>
         <xsl:when test="contains($subTypeAttrs, concat('*', normalize-space($attrNS), '+', normalize-space($attrName), '+'))">
            <!-- IGNORE: Sub type has attribute with same name;
                 Sub-type's attribute declaration will override this
                 one. -->
         </xsl:when>
         <xsl:when test="@use and normalize-space(@use)='prohibited'">
            <!-- IGNORE: Attribute is prohibited. -->
         </xsl:when>
         <xsl:otherwise>
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

            <span class="na">
               <xsl:call-template name="PrintAttributeRef">
                  <xsl:with-param name="ref" select="@ref"/>
                  <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
               </xsl:call-template>
               <xsl:text>=</xsl:text>
            </span>
            <span class="s">
               <xsl:text>"</xsl:text>
               <!-- Fixed value is provided -->
               <xsl:if test="@fixed">
                  <span class="fixed">
                     <xsl:value-of select="@fixed"/>
                  </span>
                  <xsl:text> </xsl:text>
               </xsl:if>
               <xsl:text>" </xsl:text>
               <!-- Print occurs info-->
               <xsl:call-template name="PrintOccurs">
                  <xsl:with-param name="component" select="."/>
               </xsl:call-template>
               <!-- Documentation -->
               <xsl:call-template name="PrintSampleDocumentation">
                  <xsl:with-param name="component" select="."/>
               </xsl:call-template>
            </span>
            <xsl:text>&#xa;</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--
     Prints out a sample XML instance representation of an attribute
     group definition.
     Param(s):
            schemaLoc (String) optional
                Schema file containing this attribute group
                definition; if in current schema, 'schemaLoc' is
                set to 'this'.
     -->
   <xsl:template match="xsd:attributeGroup[@name]" mode="sample">
      <xsl:param name="schemaLoc">this</xsl:param>

      <xsl:for-each select="xsd:attribute | xsd:attributeGroup | xsd:anyAttribute">
         <xsl:variable name="addBR">
            <xsl:choose>
               <xsl:when test="position()!=1">
                  <xsl:text>true</xsl:text>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:text>false</xsl:text>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>

         <xsl:apply-templates select="." mode="sample">
            <xsl:with-param name="addBR" select="$addBR"/>
            <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
         </xsl:apply-templates>
      </xsl:for-each>
   </xsl:template>

   <!--
     Prints out a sample XML instance representation of an attribute
     group reference.
     Param(s):
            subTypeAttrs (String) optional
                List of attributes in sub-types of the type that
                contains this attribute group
            isInherited (boolean) optional
                If true, display attributes using 'inherited' CSS
                class.
            isNewField (boolean) optional
                If true, display attributes using 'newFields' CSS
                class.
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
            parentGroups (String) optional
                List of parent attribute group definitions that
                contain this attribute group. Used to prevent
                infinite loops when displaying attribute group
                definitions. In such a case, writes out an error
                message and stops processing.
            schemaLoc (String) optional
                Schema file containing this attribute group
                reference if in current schema, 'schemaLoc' is
                set to 'this'.
     -->
   <xsl:template match="xsd:attributeGroup[@ref]" mode="sample">
      <xsl:param name="subTypeAttrs"/>
      <xsl:param name="isInherited">false</xsl:param>
      <xsl:param name="isNewField">false</xsl:param>
      <xsl:param name="margin">0</xsl:param>
      <xsl:param name="parentGroups"/>
      <xsl:param name="schemaLoc">this</xsl:param>

      <!-- Get attribute group name -->
      <xsl:variable name="attrGrpName">
         <xsl:call-template name="GetRefName">
            <xsl:with-param name="ref" select="@ref"/>
         </xsl:call-template>
      </xsl:variable>

      <xsl:choose>
         <xsl:when test="contains($parentGroups, concat('*', normalize-space($attrGrpName), '+'))">
            <!-- Circular attribute group definition -->
            <xsl:call-template name="HandleError">
               <xsl:with-param name="isTerminating">false</xsl:with-param>
               <xsl:with-param name="errorMsg">
                  <xsl:text>Circular attribute group reference: </xsl:text>
                  <xsl:value-of select="$attrGrpName"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
            <!-- Look for attribute group definition -->
            <xsl:variable name="defLoc">
               <xsl:call-template name="FindComponent">
                  <xsl:with-param name="ref" select="@ref"/>
                  <xsl:with-param name="compType">attribute group</xsl:with-param>
               </xsl:call-template>
            </xsl:variable>

            <xsl:choose>
               <!-- Not found -->
               <xsl:when test="normalize-space($defLoc)='' or normalize-space($defLoc)='none' or normalize-space($defLoc)='xml' or normalize-space($defLoc)='xsd'">
                  <div class="other" style="margin-left: {$margin}em">
                     <xsl:text>Attribute group reference (not shown): </xsl:text>
                     <xsl:call-template name="PrintAttributeGroupRef">
                        <xsl:with-param name="ref" select="@ref"/>
                        <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
                     </xsl:call-template>
                     <!-- Documentation -->
                     <xsl:call-template name="PrintSampleDocumentation">
                        <xsl:with-param name="component" select="."/>
                     </xsl:call-template>
                  </div>
               </xsl:when>
               <!-- Found in current schema -->
               <xsl:when test="normalize-space($defLoc)='this'">
                  <xsl:variable name="attrGrpDef" select="key('attributeGroup', $attrGrpName)"/>
                  <xsl:apply-templates select="$attrGrpDef/xsd:attribute | $attrGrpDef/xsd:attributeGroup" mode="sample">
                     <xsl:with-param name="subTypeAttrs" select="$subTypeAttrs"/>
                     <xsl:with-param name="isInherited" select="$isInherited"/>
                     <xsl:with-param name="isNewField" select="$isNewField"/>
                     <xsl:with-param name="parentGroups" select="concat($parentGroups, concat('*', normalize-space($attrGrpName), '+'))"/>
                     <xsl:with-param name="margin" select="$margin"/>
                     <xsl:with-param name="addBR">true</xsl:with-param>
                     <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
                  </xsl:apply-templates>
               </xsl:when>
               <!-- Found in external schema -->
               <xsl:otherwise>
                  <xsl:variable name="attrGrpDef" select="document($defLoc)/xsd:schema/xsd:attributeGroup[@name=$attrGrpName]"/>
                  <xsl:apply-templates select="$attrGrpDef/xsd:attribute | $attrGrpDef/xsd:attributeGroup" mode="sample">
                     <xsl:with-param name="subTypeAttrs" select="$subTypeAttrs"/>
                     <xsl:with-param name="isInherited" select="$isInherited"/>
                     <xsl:with-param name="isNewField" select="$isNewField"/>
                     <xsl:with-param name="parentGroups" select="concat($parentGroups, concat('*', normalize-space($attrGrpName), '+'))"/>
                     <xsl:with-param name="margin" select="$margin"/>
                     <xsl:with-param name="addBR">true</xsl:with-param>
                     <xsl:with-param name="schemaLoc" select="$defLoc"/>
                  </xsl:apply-templates>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--
     Prints out sample XML instances from a list of attributes and
     attribute groups.
     Param(s):
            list (Node) required
                Node containing list of attributes and attribute groups
            subTypeAttrs (String) optional
                List of attributes in sub-types of
                the type definition containing this list
            isInherited (boolean) optional
                If true, display attributes using 'inherited' CSS class.
            isNewField (boolean) optional
                If true, display attributes using 'newFields' CSS class.
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
            schemaLoc (String) optional
                Schema file containing this attribute list;
                if in current schema, 'schemaLoc' is set to 'this'.
     -->
   <xsl:template name="PrintSampleAttrList">
      <xsl:param name="list"/>
      <xsl:param name="subTypeAttrs"/>
      <xsl:param name="isInherited">false</xsl:param>
      <xsl:param name="isNewField">false</xsl:param>
      <xsl:param name="margin">0</xsl:param>
      <xsl:param name="schemaLoc">this</xsl:param>

      <xsl:apply-templates select="$list/xsd:attribute | $list/xsd:attributeGroup | $list/xsd:anyAttribute" mode="sample">
         <xsl:with-param name="subTypeAttrs" select="$subTypeAttrs"/>
         <xsl:with-param name="isInherited" select="$isInherited"/>
         <xsl:with-param name="isNewField" select="$isNewField"/>
         <xsl:with-param name="margin" select="$margin"/>
         <xsl:with-param name="addBR">true</xsl:with-param>
         <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
      </xsl:apply-templates>
   </xsl:template>

   <!--
     Returns the names and namespaces of attributes
     in a list of attributes and attribute groups.
     Param(s):
            list (Node) required
                Node containing list of attributes and attribute groups
     -->
   <xsl:template name="GetAttrList">
      <xsl:param name="list"/>

      <xsl:if test="$list">
         <xsl:for-each select="$list/xsd:attribute | $list/xsd:attributeGroup | $list/xsd:anyAttribute">
            <xsl:choose>
               <!-- Attribute declaration -->
               <xsl:when test="local-name(.)='attribute' and @name">
                  <!-- Get attribute name -->
                  <xsl:variable name="attrName" select="@name"/>
                  <!-- Get attribute namespace -->
                  <xsl:variable name="attrNS">
                     <xsl:call-template name="GetAttributeNS">
                        <xsl:with-param name="attribute" select="."/>
                     </xsl:call-template>
                  </xsl:variable>

                  <xsl:value-of select="concat('*', normalize-space($attrNS), '+', normalize-space($attrName), '+')"/>
               </xsl:when>
               <!-- Attribute reference -->
               <xsl:when test="local-name(.)='attribute' and @ref">
                  <!-- Get attribute name -->
                  <xsl:variable name="attrName">
                     <xsl:call-template name="GetRefName">
                        <xsl:with-param name="ref" select="@ref"/>
                     </xsl:call-template>
                  </xsl:variable>
                  <!-- Get attribute namespace -->
                  <xsl:variable name="attrNS">
                     <xsl:call-template name="GetAttributeNS">
                        <xsl:with-param name="attribute" select="."/>
                     </xsl:call-template>
                  </xsl:variable>

                  <xsl:value-of select="concat('*', normalize-space($attrNS), '+', normalize-space($attrName), '+')"/>
               </xsl:when>
               <!-- Attribute Group reference -->
               <xsl:when test="local-name(.)='attributeGroup' and @ref">
                  <xsl:variable name="attrGrpName">
                     <xsl:call-template name="GetRefName">
                        <xsl:with-param name="ref" select="@ref"/>
                     </xsl:call-template>
                  </xsl:variable>
                  <xsl:call-template name="GetAttrList">
                     <xsl:with-param name="list" select="key('attributeGroup', $attrGrpName)"/>
                  </xsl:call-template>
               </xsl:when>
               <!-- Attribute wildcard -->
               <xsl:when test="local-name(.)='anyAttribute'">
               </xsl:when>
            </xsl:choose>
         </xsl:for-each>
      </xsl:if>
   </xsl:template>

   <!--
     Prints out a sample XML instance representation of an element
     content wild card.
     Param(s):
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
     -->
   <xsl:template match="xsd:any | xsd:anyAttribute" mode="sample">
      <xsl:param name="margin">0</xsl:param>

      <xsl:call-template name="PrintWildcard">
         <xsl:with-param name="componentType">
            <xsl:choose>
               <xsl:when test="local-name(.)='anyAttribute'">attribute</xsl:when>
               <xsl:otherwise>element</xsl:otherwise>
            </xsl:choose>
         </xsl:with-param>
         <xsl:with-param name="namespace" select="@namespace"/>
         <xsl:with-param name="processContents" select="@processContents"/>
         <xsl:with-param name="minOccurs" select="@minOccurs"/>
         <xsl:with-param name="maxOccurs" select="@maxOccurs"/>
         <xsl:with-param name="margin" select="number($margin)"/>
      </xsl:call-template>
   </xsl:template>

   <!--
     Print out a wildcard.
     Param(s):
            componentType (attribute|element) required
              XML Schema component type
            namespaces (String) required
              Namespace attribute of wildcard
            processContents (String) required
              Process contents attribute of wildcard
            namespaces (String) required
              Namespace attribute of wildcard
            margin (non-negative Integer) optional
              The amount of spaces to indent
     -->
   <xsl:template name="PrintWildcard">
      <xsl:param name="componentType">element</xsl:param>
      <xsl:param name="namespace"/>
      <xsl:param name="processContents"/>
      <xsl:param name="minOccurs"/>
      <xsl:param name="maxOccurs"/>
      <xsl:param name="margin" select="$ATTR_INDENT"/>

      <xsl:call-template name="Repeat">
         <xsl:with-param name="content"><xsl:text> </xsl:text></xsl:with-param>
         <xsl:with-param name="count" select="$margin"/>
      </xsl:call-template>

      <span class="cs">
         <xsl:text>Allow any </xsl:text>
         <xsl:value-of select="$componentType"/>
         <xsl:text>s from </xsl:text>

         <xsl:choose>
            <!-- ##any -->
            <xsl:when test="not($namespace) or normalize-space($namespace)='##any'">
               <xsl:text>any namespace</xsl:text>
            </xsl:when>
            <!-- ##other -->
            <xsl:when test="normalize-space($namespace)='##other'">
               <xsl:text>a namespace other than this schema's namespace</xsl:text>
            </xsl:when>
            <!-- ##targetNamespace, ##local, specific namespaces -->
            <xsl:otherwise>
               <!-- ##targetNamespace -->
               <xsl:variable name="hasTargetNS">
                  <xsl:if test="contains($namespace, '##targetNamespace')">
                     <xsl:text>true</xsl:text>
                  </xsl:if>
               </xsl:variable>
               <!-- ##local -->
               <xsl:variable name="hasLocalNS">
                  <xsl:if test="contains($namespace, '##local')">
                     <xsl:text>true</xsl:text>
                  </xsl:if>
               </xsl:variable>
               <!-- Specific namespaces -->
               <!-- Remove '##targetNamespace' string if any-->
               <xsl:variable name="temp">
                  <xsl:choose>
                     <xsl:when test="$hasTargetNS='true'">
                        <xsl:value-of select="concat(substring-before($namespace, '##targetNamespace'), substring-after($namespace, '##targetNamespace'))"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="$namespace"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:variable>
               <!-- Remove '##local' string if any -->
               <xsl:variable name="specificNS">
                  <xsl:choose>
                     <xsl:when test="$hasLocalNS='true'">
                        <xsl:value-of select="concat(substring-before($temp, '##local'), substring-after($temp, '##local'))"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="$temp"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:variable>
               <xsl:variable name="hasSpecificNS">
                  <xsl:if test="normalize-space($specificNS)!=''">
                     <xsl:text>true</xsl:text>
                  </xsl:if>
               </xsl:variable>

               <xsl:if test="$hasLocalNS='true'">
                  <xsl:text>no namespace</xsl:text>
               </xsl:if>

               <xsl:if test="$hasTargetNS='true'">
                  <xsl:choose>
                     <xsl:when test="$hasLocalNS='true' and $hasSpecificNS!='true'">
                        <xsl:text> and </xsl:text>
                     </xsl:when>
                     <xsl:when test="$hasLocalNS='true'">
                        <xsl:text>, </xsl:text>
                     </xsl:when>
                  </xsl:choose>
                  <xsl:text>this schema's namespace</xsl:text>
               </xsl:if>

               <xsl:if test="$hasSpecificNS='true'">
                  <xsl:choose>
                     <xsl:when test="$hasTargetNS='true' and $hasLocalNS='true'">
                        <xsl:text>, and </xsl:text>
                     </xsl:when>
                     <xsl:when test="$hasTargetNS='true' or $hasLocalNS='true'">
                        <xsl:text> and </xsl:text>
                     </xsl:when>
                  </xsl:choose>
                  <xsl:text>the following namespace(s): </xsl:text>
                  <xsl:call-template name="PrintWhitespaceList">
                     <xsl:with-param name="value" select="normalize-space($specificNS)"/>
                     <xsl:with-param name="separator">,</xsl:with-param>
                  </xsl:call-template>
               </xsl:if>
            </xsl:otherwise>
         </xsl:choose>
         <!-- Process contents -->
         <xsl:text> (</xsl:text>
         <xsl:choose>
            <xsl:when test="$processContents">
               <xsl:value-of select="normalize-space($processContents)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:text>strict</xsl:text>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:text> validation)</xsl:text>
         <xsl:text>.</xsl:text>

         <!-- Print min/max occurs -->
         <xsl:if test="$componentType='element'">
            <xsl:text> </xsl:text>
            <xsl:call-template name="PrintOccurs">
               <xsl:with-param name="minOccurs" select="$minOccurs"/>
               <xsl:with-param name="maxOccurs" select="$maxOccurs"/>
            </xsl:call-template>
         </xsl:if>
      </span>
      <xsl:text>&#xa;</xsl:text>
   </xsl:template>

</xsl:stylesheet>