<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!--
  XS3P Content Generator Module: Instance Samples - Groups
  This module contains group and model group templates for XML instance representation.

  Dependencies:
  - core/constants.xsl
  - core/keys.xsl
  - utils/references.xsl
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
     Prints out a sample XML instance representation of an 'all'
     model group.
     Param(s):
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
            isInherited (boolean) optional
                If true, display elements using 'inherited' CSS class.
            isNewField (boolean) optional
                If true, display elements using 'newFields' CSS class.
            schemaLoc (String) optional
                Schema file containing this all model group;
                if in current schema, 'schemaLoc' is set to 'this'
            typeList (String) optional
                List of types in this call chain. Name of type starts
                with '*', and ends with '+'. (Used to prevent infinite
                recursive loop.)
     -->
   <xsl:template match="xsd:all" mode="sample">
      <xsl:param name="margin">0</xsl:param>
      <xsl:param name="isInherited">false</xsl:param>
      <xsl:param name="isNewField">false</xsl:param>
      <xsl:param name="schemaLoc">this</xsl:param>
      <xsl:param name="typeList"/>

      <xsl:if test="normalize-space(@maxOccurs)!='0'">
         <!-- Header -->
         <span class="group" style="margin-left: {$margin}em">
            <xsl:text>Start </xsl:text>
            <xsl:call-template name="PrintGlossaryTermRef">
               <xsl:with-param name="code">All</xsl:with-param>
               <xsl:with-param name="term">All</xsl:with-param>
            </xsl:call-template>
            <!-- Min/max occurs information-->
            <xsl:text> </xsl:text>
            <xsl:call-template name="PrintOccurs">
               <xsl:with-param name="component" select="."/>
            </xsl:call-template>
            <!-- Documentation -->
            <xsl:call-template name="PrintSampleDocumentation">
               <xsl:with-param name="component" select="."/>
            </xsl:call-template>
         </span><br/>

         <!-- Content -->
         <xsl:apply-templates select="xsd:*" mode="sample">
            <xsl:with-param name="margin" select="number($margin) + number($ELEM_INDENT)"/>
            <xsl:with-param name="isInherited" select="$isInherited"/>
            <xsl:with-param name="isNewField" select="$isNewField"/>
            <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
            <xsl:with-param name="typeList" select="$typeList"/>
         </xsl:apply-templates>

         <!-- Footer -->
         <span class="group" style="margin-left: {$margin}em">
            <xsl:text>End All</xsl:text>
         </span><br/>
      </xsl:if>
   </xsl:template>

   <!--
     Prints out a sample XML instance representation of a 'choice'
     model group.
     Param(s):
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
            isInherited (boolean) optional
                If true, display elements using'inherited' CSS class.
            isNewField (boolean) optional
                If true, display elements using 'newFields' CSS class.
            parentGroups (String) optional
                List of parent model group definitions that contain this
                model group. Used to prevent infinite loops when
                displaying model group definitions.
            schemaLoc (String) optional
                Schema file containing this choice model group;
                if in current schema, 'schemaLoc' is set to 'this'
            typeList (String) optional
                List of types in this call chain. Name of type starts
                with '*', and ends with '+'. (Used to prevent infinite
                recursive loop.)
     -->
   <xsl:template match="xsd:choice" mode="sample">
      <xsl:param name="margin">0</xsl:param>
      <xsl:param name="isInherited">false</xsl:param>
      <xsl:param name="isNewField">false</xsl:param>
      <xsl:param name="parentGroups"/>
      <xsl:param name="schemaLoc">this</xsl:param>
      <xsl:param name="typeList"/>

      <xsl:variable name="typeHierarchy">
         <xsl:value-of select="$typeList"/>
      </xsl:variable>

      <xsl:if test="normalize-space(@maxOccurs)!='0'">
         <!-- Header -->
         <xsl:call-template name="Repeat">
            <xsl:with-param name="content"><xsl:text> </xsl:text></xsl:with-param>
            <xsl:with-param name="count" select="$margin"/>
         </xsl:call-template>
         <span class="group">
            <xsl:text>Start </xsl:text>
            <xsl:call-template name="PrintGlossaryTermRef">
               <xsl:with-param name="code">Choice</xsl:with-param>
               <xsl:with-param name="term">Choice</xsl:with-param>
            </xsl:call-template>
            <!-- Min/max occurrence -->
            <xsl:text> </xsl:text>
            <xsl:call-template name="PrintOccurs">
               <xsl:with-param name="component" select="."/>
            </xsl:call-template>
            <!-- Documentation -->
            <xsl:call-template name="PrintSampleDocumentation">
               <xsl:with-param name="component" select="."/>
            </xsl:call-template>
         </span>
         <xsl:text>&#xa;</xsl:text>

         <!-- Content -->
         <xsl:apply-templates select="xsd:*" mode="sample">
            <xsl:with-param name="margin" select="number($margin)+number($ELEM_INDENT)"/>
            <xsl:with-param name="isInherited" select="$isInherited"/>
            <xsl:with-param name="isNewField" select="$isNewField"/>
            <xsl:with-param name="parentGroups" select="$parentGroups"/>
            <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
            <xsl:with-param name="typeList" select="$typeList"/>
         </xsl:apply-templates>

         <!-- Footer -->
         <xsl:call-template name="Repeat">
            <xsl:with-param name="content"><xsl:text> </xsl:text></xsl:with-param>
            <xsl:with-param name="count" select="$margin"/>
         </xsl:call-template>
         <span class="group">
            <xsl:text>End Choice</xsl:text>
         </span>
         <xsl:text>&#xa;</xsl:text>
      </xsl:if>
   </xsl:template>

   <!--
     Prints out a sample XML instance from a 'sequence' model group.
     Param(s):
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
            isInherited (boolean) optional
                If true, display elements using 'inherited' CSS class.
            isNewField (boolean) optional
                If true, display elements using 'newFields' CSS class.
            parentGroups (String) optional
                List of parent model group definitions that contain
                this model group. Used to prevent infinite loops when
                displaying model group definitions.
            schemaLoc (String) optional
                Schema file containing this sequence model group;
                if in current schema, 'schemaLoc' is set to 'this'
            typeList (String) optional
                List of types in this call chain. Name of type starts
                with '*', and ends with '+'. (Used to prevent infinite
                recursive loop.)
     -->
   <xsl:template match="xsd:sequence" mode="sample">
      <xsl:param name="margin">0</xsl:param>
      <xsl:param name="isInherited">false</xsl:param>
      <xsl:param name="isNewField">false</xsl:param>
      <xsl:param name="parentGroups"/>
      <xsl:param name="schemaLoc">this</xsl:param>
      <xsl:param name="typeList"/>

      <xsl:if test="normalize-space(@maxOccurs)!='0'">
         <!-- Get occurrence info -->
         <xsl:variable name="occursInfo">
            <xsl:call-template name="PrintOccurs">
               <xsl:with-param name="component" select="."/>
            </xsl:call-template>
         </xsl:variable>

         <!-- Header -->
         <xsl:if test="normalize-space($occursInfo)!='[1]'">
            <!-- Don't display header if min/max occurs is one. -->
            <xsl:call-template name="Repeat">
               <xsl:with-param name="content"><xsl:text> </xsl:text></xsl:with-param>
               <xsl:with-param name="count" select="$margin"/>
            </xsl:call-template>
            <span class="group">
               <xsl:text>Start </xsl:text>
               <xsl:call-template name="PrintGlossaryTermRef">
                  <xsl:with-param name="code">Sequence</xsl:with-param>
                  <xsl:with-param name="term">Sequence</xsl:with-param>
               </xsl:call-template>

               <xsl:text> </xsl:text>
               <xsl:copy-of select="$occursInfo"/>
               <!-- Documentation -->
               <xsl:call-template name="PrintSampleDocumentation">
                  <xsl:with-param name="component" select="."/>
               </xsl:call-template>
            </span>
            <xsl:text>&#xa;</xsl:text>
         </xsl:if>

         <xsl:apply-templates select="xsd:*" mode="sample">
            <xsl:with-param name="margin">
               <xsl:choose>
                  <xsl:when test="normalize-space($occursInfo)='[1]'">
                     <xsl:value-of select="$margin"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="number($margin)+number($ELEM_INDENT)"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="isInherited" select="$isInherited"/>
            <xsl:with-param name="isNewField" select="$isNewField"/>
            <xsl:with-param name="parentGroups" select="$parentGroups"/>
            <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
            <xsl:with-param name="typeList" select="$typeList"/>
         </xsl:apply-templates>

         <!-- Footer -->
         <xsl:if test="normalize-space($occursInfo)!='[1]'">
            <!-- Don't display footer if min/max occurs is one. -->
            <xsl:call-template name="Repeat">
               <xsl:with-param name="content"><xsl:text> </xsl:text></xsl:with-param>
               <xsl:with-param name="count" select="$margin"/>
            </xsl:call-template>
            <span class="group">
               <xsl:text>End Sequence</xsl:text>
            </span>
            <xsl:text>&#xa;</xsl:text>
         </xsl:if>
      </xsl:if>
   </xsl:template>

   <!--
     Prints out a sample XML instance from a group definition.
     Param(s):
            schemaLoc (String) optional
                Schema file containing this model group definition;
                if in current schema, 'schemaLoc' is set to 'this'
            typeList (String) optional
                List of types in this call chain. Name of type starts
                with '*', and ends with '+'. (Used to prevent infinite
                recursive loop.)
     -->
   <xsl:template match="xsd:group[@name]" mode="sample">
      <xsl:param name="schemaLoc">this</xsl:param>
      <xsl:param name="typeList"/>

      <xsl:apply-templates select="xsd:*" mode="sample">
         <xsl:with-param name="parentGroups" select="concat('*', normalize-space(@name), '+')"/>
         <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
         <xsl:with-param name="typeList" select="$typeList"/>
      </xsl:apply-templates>
   </xsl:template>

   <!--
     Prints out a sample XML instance from a group reference.
     Param(s):
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
            isInherited (boolean) optional
                If true, display elements using 'inherited' CSS
                class.
            isNewField (boolean) optional
                If true, display elements using 'newFields' CSS
                class.
            parentGroups (String) optional
                List of parent model group definitions that contain
                this  model group. Used to prevent infinite loops
                when displaying model group definitions.
            schemaLoc (String) optional
                Schema file containing this model group reference;
                if in current schema, 'schemaLoc' is set to 'this'
            typeList (String) optional
                List of types in this call chain. Name of type starts
                with '*', and ends with '+'. (Used to prevent infinite
                recursive loop.)
     -->
   <xsl:template match="xsd:group[@ref]" mode="sample">
      <xsl:param name="margin">0</xsl:param>
      <xsl:param name="isInherited">false</xsl:param>
      <xsl:param name="isNewField">false</xsl:param>
      <xsl:param name="parentGroups"/>
      <xsl:param name="schemaLoc">this</xsl:param>
      <xsl:param name="typeList"/>

      <!-- Get group name -->
      <xsl:variable name="grpName">
         <xsl:call-template name="GetRefName">
            <xsl:with-param name="ref" select="@ref"/>
         </xsl:call-template>
      </xsl:variable>

      <!-- Create link to the group definition -->
      <xsl:variable name="grpLink">
         <xsl:call-template name="PrintGroupRef">
            <xsl:with-param name="ref" select="@ref"/>
            <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
         </xsl:call-template>
      </xsl:variable>

      <!-- Get occurrence info -->
      <xsl:variable name="occursInfo">
         <xsl:call-template name="PrintOccurs">
            <xsl:with-param name="component" select="."/>
         </xsl:call-template>
      </xsl:variable>

      <xsl:choose>
         <!-- Circular group definition -->
         <xsl:when test="contains($parentGroups, concat('*', normalize-space($grpName), '+'))">
            <!-- Don't show contents -->
            <xsl:call-template name="Repeat">
               <xsl:with-param name="content"><xsl:text> </xsl:text></xsl:with-param>
               <xsl:with-param name="count" select="$margin"/>
            </xsl:call-template>
            <span class="c">
               <xsl:text>Circular model group reference: </xsl:text>
               <xsl:copy-of select="$grpLink"/>
               <!-- Occurrence info -->
               <xsl:text> </xsl:text>
               <xsl:copy-of select="$occursInfo"/>
               <!-- Documentation -->
               <xsl:call-template name="PrintSampleDocumentation">
                  <xsl:with-param name="component" select="."/>
               </xsl:call-template>
            </span>
            <xsl:text>&#xa;</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <!-- Look for group definition -->
            <xsl:variable name="grpDefLoc">
               <xsl:call-template name="FindComponent">
                  <xsl:with-param name="ref" select="@ref"/>
                  <xsl:with-param name="compType">group</xsl:with-param>
               </xsl:call-template>
            </xsl:variable>

            <xsl:choose>
               <!-- Not found -->
               <xsl:when test="normalize-space($grpDefLoc)='' or normalize-space($grpDefLoc)='none' or normalize-space($grpDefLoc)='xml' or normalize-space($grpDefLoc)='xsd'">
                  <div class="other" style="margin-left: {$margin}em">
                     <xsl:text>Model group reference (not shown): </xsl:text>
                     <xsl:copy-of select="$grpLink"/>
                     <!-- Occurrence info -->
                     <xsl:text> </xsl:text>
                     <xsl:copy-of select="$occursInfo"/>
                     <!-- Documentation -->
                     <xsl:call-template name="PrintSampleDocumentation">
                        <xsl:with-param name="component" select="."/>
                     </xsl:call-template>
                  </div>
               </xsl:when>
               <!-- Found in current schema -->
               <xsl:when test="normalize-space($grpDefLoc)='this'">
                  <xsl:variable name="grpDef" select="key('group', $grpName)"/>
                  <xsl:call-template name="PrintSampleGroup">
                     <xsl:with-param name="margin" select="$margin"/>
                     <xsl:with-param name="isInherited" select="$isInherited"/>
                     <xsl:with-param name="isNewField" select="$isNewField"/>
                     <xsl:with-param name="parentGroups" select="concat($parentGroups, concat('*', normalize-space($grpName), '+'))"/>
                     <xsl:with-param name="occursInfo" select="$occursInfo"/>
                     <xsl:with-param name="grpLink" select="$grpLink"/>
                     <xsl:with-param name="grpRef" select="."/>
                     <xsl:with-param name="grpDef" select="$grpDef"/>
                     <xsl:with-param name="grpDefLoc" select="$grpDefLoc"/>
                     <xsl:with-param name="typeList" select="$typeList"/>
                  </xsl:call-template>
               </xsl:when>
               <!-- Found in external schema -->
               <xsl:otherwise>
                  <xsl:variable name="grpDef" select="document($grpDefLoc)/xsd:schema/xsd:group[@name=$grpName]"/>
                  <xsl:call-template name="PrintSampleGroup">
                     <xsl:with-param name="margin" select="$margin"/>
                     <xsl:with-param name="isInherited" select="$isInherited"/>
                     <xsl:with-param name="isNewField" select="$isNewField"/>
                     <xsl:with-param name="parentGroups" select="concat($parentGroups, concat('*', normalize-space($grpName), '+'))"/>
                     <xsl:with-param name="occursInfo" select="$occursInfo"/>
                     <xsl:with-param name="grpLink" select="$grpLink"/>
                     <xsl:with-param name="grpRef" select="."/>
                     <xsl:with-param name="grpDef" select="$grpDef"/>
                     <xsl:with-param name="grpDefLoc" select="$grpDefLoc"/>
                     <xsl:with-param name="typeList" select="$typeList"/>
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--
     Helper template for template, match="xsd:group[@ref]"
     mode="sample". Basically prints out a group reference, for
     which we are able to look up the group definition that it
     is referring to. This template is a work-around because XSLT
     doesn't have variables (in the traditional sense of
     programming languages) and it doesn't allow you to query
     result tree fragments.
     Param(s):
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
            isInherited (boolean) optional
                If true, display elements using 'inherited' CSS class.
            isNewField (boolean) optional
                If true, display elements using 'newFields' CSS class.
            parentGroups (String) optional
                List of parent model group definitions that contain this
                model group. Used to prevent infinite loops when
                displaying model group definitions.
            occursInfo (Result tree fragment) required
                Pre-formatted occurrence info of group reference
            grpLink (Result tree fragment) required
                Pre-formatted <a> link representing group reference
            grpRef (Node) required
                Group reference
            grpDef (Node) required
                Group definition that the reference is pointing to
            grpDefLoc (String) optional
                Schema file containing 'grpDef' group definition;
                if current schema, 'schemaLoc' is set to 'this'
            typeList (String) optional
                List of types in this call chain. Name of type starts
                with '*', and ends with '+'. (Used to prevent infinite
                recursive loop.)
     -->
   <xsl:template name="PrintSampleGroup">
      <xsl:param name="margin">0</xsl:param>
      <xsl:param name="isInherited">false</xsl:param>
      <xsl:param name="isNewField">false</xsl:param>
      <xsl:param name="parentGroups"/>
      <xsl:param name="occursInfo"/>
      <xsl:param name="grpLink"/>
      <xsl:param name="grpRef"/>
      <xsl:param name="grpDef"/>
      <xsl:param name="grpDefLoc">this</xsl:param>
      <xsl:param name="typeList"/>

      <!-- Header -->
      <xsl:if test="normalize-space($occursInfo)!='[1]'">
         <!-- Don't print out header if min/max occurs is one. -->
         <xsl:call-template name="Repeat">
            <xsl:with-param name="content"><xsl:text> </xsl:text></xsl:with-param>
            <xsl:with-param name="count" select="$margin"/>
         </xsl:call-template>
         <span class="group">
            <xsl:text>Start Group: </xsl:text>
            <xsl:copy-of select="$grpLink"/>
            <!-- Occurrence info -->
            <xsl:text> </xsl:text>
            <xsl:copy-of select="$occursInfo"/>
            <!-- Documentation -->
            <xsl:call-template name="PrintSampleDocumentation">
               <xsl:with-param name="component" select="$grpRef"/>
            </xsl:call-template>
         </span>
         <xsl:text>&#xa;</xsl:text>
      </xsl:if>

      <!-- Content -->
      <xsl:apply-templates select="$grpDef/xsd:*" mode="sample">
         <xsl:with-param name="margin">
            <xsl:choose>
               <xsl:when test="normalize-space($occursInfo)!='[1]'">
                  <xsl:value-of select="number($margin)+number($ELEM_INDENT)"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="$margin"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:with-param>
         <xsl:with-param name="isInherited" select="$isInherited"/>
         <xsl:with-param name="isNewField" select="$isNewField"/>
         <xsl:with-param name="parentGroups" select="$parentGroups"/>
         <xsl:with-param name="schemaLoc" select="$grpDefLoc"/>
         <xsl:with-param name="typeList" select="$typeList"/>
      </xsl:apply-templates>

      <!-- Footer -->
      <xsl:if test="normalize-space($occursInfo)!='[1]'">
         <!-- Don't print out footer if min/max occurs is one. -->
         <xsl:call-template name="Repeat">
            <xsl:with-param name="content"><xsl:text> </xsl:text></xsl:with-param>
            <xsl:with-param name="count" select="$margin"/>
         </xsl:call-template>
         <span class="group">
            <xsl:text>End Group: </xsl:text>
            <xsl:copy-of select="$grpLink"/>
         </span>
         <xsl:text>&#xa;</xsl:text>
      </xsl:if>
   </xsl:template>

</xsl:stylesheet>