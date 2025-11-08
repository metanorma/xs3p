<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!--
  XS3P Utility Module: Common Helper Templates
  This module contains widely-used helper templates for formatting and component utilities.
-->
<xsl:stylesheet
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns="http://www.w3.org/1999/xhtml"
 xmlns:xsd="http://www.w3.org/2001/XMLSchema"
 version="1.0">

   <!-- Include dependencies -->
   <xsl:include href="../core/constants.xsl"/>
   <xsl:include href="../core/parameters.xsl"/>
   <xsl:include href="references.xsl"/>

   <!--
     Returns the description that can be used in
     headers for a schema component.
     Param(s):
            component (Node) required
                Schema component
     -->
   <xsl:template name="GetComponentDescription">
      <xsl:param name="component"/>
      <xsl:param name="nav" select="'false'"/>

      <xsl:choose>
         <xsl:when test="$nav = 'true' and normalize-space(translate($sortByComponent,'TRUE','true'))='true'">
            <xsl:choose>
               <xsl:when test="local-name($component)='all'">
                  <xsl:text>All Model Group</xsl:text>
               </xsl:when>
               <xsl:when test="local-name($component)='attribute'"></xsl:when>
               <xsl:when test="local-name($component)='attributeGroup'"></xsl:when>
               <xsl:when test="local-name($component)='choice'">
                  <xsl:text>Choice Model Group</xsl:text>
               </xsl:when>
               <xsl:when test="local-name($component)='complexType'"></xsl:when>
               <xsl:when test="local-name($component)='element'"></xsl:when>
               <xsl:when test="local-name($component)='group'">
                  <xsl:text>Model Group</xsl:text>
               </xsl:when>
               <xsl:when test="local-name($component)='notation'"></xsl:when>
               <xsl:when test="local-name($component)='sequence'">
                  <xsl:text>Sequence Model Group</xsl:text>
               </xsl:when>
               <xsl:when test="local-name($component)='simpleType'"></xsl:when>
               <xsl:otherwise>
                  <xsl:call-template name="HandleError">
                     <xsl:with-param name="isTerminating">true</xsl:with-param>
                     <xsl:with-param name="errorMsg">
      Unknown schema component, <xsl:value-of select="local-name($component)"/>.
                     </xsl:with-param>
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:otherwise>

            <xsl:choose>
               <xsl:when test="local-name($component)='all'">
                  <xsl:text>All Model Group</xsl:text>
               </xsl:when>
               <xsl:when test="local-name($component)='attribute'">
                  <xsl:text>Attribute</xsl:text>
               </xsl:when>
               <xsl:when test="local-name($component)='attributeGroup'">
                  <xsl:text>Attribute Group</xsl:text>
               </xsl:when>
               <xsl:when test="local-name($component)='choice'">
                  <xsl:text>Choice Model Group</xsl:text>
               </xsl:when>
               <xsl:when test="local-name($component)='complexType'">
                  <xsl:text>Complex Type</xsl:text>
               </xsl:when>
               <xsl:when test="local-name($component)='element'">
                  <xsl:text>Element</xsl:text>
               </xsl:when>
               <xsl:when test="local-name($component)='group'">
                  <xsl:text>Model Group</xsl:text>
               </xsl:when>
               <xsl:when test="local-name($component)='notation'">
                  <xsl:text>Notation</xsl:text>
               </xsl:when>
               <xsl:when test="local-name($component)='sequence'">
                  <xsl:text>Sequence Model Group</xsl:text>
               </xsl:when>
               <xsl:when test="local-name($component)='simpleType'">
                  <xsl:text>Simple Type</xsl:text>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:call-template name="HandleError">
                     <xsl:with-param name="isTerminating">true</xsl:with-param>
                     <xsl:with-param name="errorMsg">
      Unknown schema component, <xsl:value-of select="local-name($component)"/>.
                     </xsl:with-param>
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--
     Returns the unique identifier for a top-level schema
     component. Returns the string "schema" if the 'component'
     is the root schema element.
     Param(s):
            component (Node) required
                Schema component
     -->
   <xsl:template name="GetComponentID">
      <xsl:param name="component"/>

      <xsl:choose>
         <xsl:when test="local-name($component)='schema'">
            <xsl:text>schema</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:variable name="componentPrefix">
               <xsl:call-template name="GetComponentPrefix">
                  <xsl:with-param name="component" select="$component"/>
               </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="concat($componentPrefix, $component/@name)"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--
     Returns the prefix to add in front of a schema component
     name when generating anchor names.
     Param(s):
            component (Node) required
                Schema component
     -->
   <xsl:template name="GetComponentPrefix">
      <xsl:param name="component"/>

      <xsl:choose>
         <xsl:when test="local-name($component)='attribute'">
            <xsl:value-of select="$ATTR_PREFIX"/>
         </xsl:when>
         <xsl:when test="local-name($component)='attributeGroup'">
            <xsl:value-of select="$ATTR_GRP_PREFIX"/>
         </xsl:when>
         <xsl:when test="local-name($component)='complexType'">
            <xsl:value-of select="$CTYPE_PREFIX"/>
         </xsl:when>
         <xsl:when test="local-name($component)='element'">
            <xsl:value-of select="$ELEM_PREFIX"/>
         </xsl:when>
         <xsl:when test="local-name($component)='group'">
            <xsl:value-of select="$GRP_PREFIX"/>
         </xsl:when>
         <xsl:when test="local-name($component)='notation'">
            <xsl:value-of select="$NOTA_PREFIX"/>
         </xsl:when>
         <xsl:when test="local-name($component)='simpleType'">
            <xsl:value-of select="$STYPE_PREFIX"/>
         </xsl:when>
         <xsl:when test="local-name($component)='key' or local-name($component)='unique'">
            <xsl:value-of select="$KEY_PREFIX"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:call-template name="HandleError">
               <xsl:with-param name="isTerminating">true</xsl:with-param>
               <xsl:with-param name="errorMsg">
Unknown schema component, <xsl:value-of select="local-name($component)"/>.
               </xsl:with-param>
            </xsl:call-template>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--
     Returns a glossary term reference for the
     schema component type, if applicable.
     Param(s):
            component (Node) required
                Schema component
     -->
   <xsl:template name="GetComponentTermRef">
      <xsl:param name="component"/>

      <xsl:choose>
         <xsl:when test="local-name($component)='notation'">
            <xsl:text>Notation</xsl:text>
         </xsl:when>
      </xsl:choose>
   </xsl:template>

   <!--
     Prints out a boolean value.
     Param(s):
            boolean (String) required
                Boolean value
     -->
   <xsl:template name="PrintBoolean">
      <xsl:param name="boolean"/>

      <xsl:choose>
         <xsl:when test="normalize-space(translate($boolean,'TRUE', 'true'))='true' or normalize-space($boolean)='1'">
            <xsl:text>yes</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>no</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--
     Print out a URI. If it starts with 'http', a link is provided.
     Param(s):
            uri (String) required
              URI to be printed
     -->
   <xsl:template name="PrintURI">
      <xsl:param name="uri"/>

      <xsl:choose>
         <xsl:when test="starts-with($uri, 'http')">
            <a title="{$uri}" href="{$uri}">
               <xsl:value-of select="$uri"/>
            </a>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$uri"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--
     Print out a link to the documentation of schema document.
     For this happen, the 'linksFile' variable must be provided,
     it must point to an actual file, and in that file, there
     must be a mapping from the schema file location to the
     schema documentation file location.
     Param(s):
            uri (String) required
              Location of schema file
     -->
   <xsl:template name="PrintSchemaLink">
      <xsl:param name="uri"/>

      <xsl:variable name="docFileLoc">
         <xsl:call-template name="GetSchemaDocLocation">
            <xsl:with-param name="uri" select="$uri"/>
         </xsl:call-template>
      </xsl:variable>

      <xsl:choose>
         <xsl:when test="$docFileLoc!=''">
            <a title="Jump to schema documentation for '{$uri}'." href="{$docFileLoc}">
               <xsl:value-of select="$uri"/>
            </a>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$uri"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--
     Prints out the min/max occurrences of a schema component.
     Param(s):
            component (Node) optional
                Schema component
            minOccurs (String) optional
                Minimum occurrences
            maxOccurs (String) optional
                Maximum occurrences
     -->
   <xsl:template name="PrintOccurs">
      <xsl:param name="component"/>
      <xsl:param name="minOccurs"/>
      <xsl:param name="maxOccurs"/>

      <!-- Get min occurs -->
      <xsl:variable name="min">
         <xsl:choose>
            <xsl:when test="$component and local-name($component)='attribute'">
               <xsl:choose>
                  <xsl:when test="normalize-space($component/@use)='required'">
                     <xsl:text>1</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:text>0</xsl:text>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
               <xsl:choose>
                  <xsl:when test="$component and $component/@minOccurs">
                     <xsl:value-of select="$component/@minOccurs"/>
                  </xsl:when>
                  <xsl:when test="$minOccurs != ''">
                     <xsl:value-of select="$minOccurs"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:text>1</xsl:text>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <!-- Get max occurs -->
      <xsl:variable name="max">
         <xsl:choose>
            <xsl:when test="$component and local-name($component)='attribute'">
               <xsl:choose>
                  <xsl:when test="normalize-space($component/@use)='prohibited'">
                     <xsl:text>0</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:text>1</xsl:text>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
               <xsl:choose>
                  <xsl:when test="($component and normalize-space($component/@maxOccurs)='unbounded') or $maxOccurs='unbounded'">
                     <xsl:text>*</xsl:text>
                  </xsl:when>
                  <xsl:when test="$component and $component/@maxOccurs">
                     <xsl:value-of select="$component/@maxOccurs"/>
                  </xsl:when>
                  <xsl:when test="$maxOccurs != ''">
                     <xsl:value-of select="$maxOccurs"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:text>1</xsl:text>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <span class="cs">
         <xsl:choose>
            <xsl:when test="number($min)=1 and number($max)=1">
               <xsl:text>[1]</xsl:text>
            </xsl:when>
            <xsl:otherwise>
               <xsl:text>[</xsl:text>
               <xsl:value-of select="$min"/>
               <xsl:text>..</xsl:text>
               <xsl:value-of select="$max"/>
               <xsl:text>]</xsl:text>
            </xsl:otherwise>
         </xsl:choose>
      </span>
   </xsl:template>

   <!--
     Translates occurrence of '#all' in 'block' value
     of element declarations.
     Param(s):
            EBV (String) required
                Value
     -->
   <xsl:template name="PrintBlockSet">
      <xsl:param name="EBV"/>

      <xsl:choose>
         <xsl:when test="normalize-space($EBV)='#all'">
            <xsl:text>restriction, extension, substitution</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$EBV"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--
     Translates occurrence of '#all' in 'final' value
     of element declarations, and 'block' and 'final' values
     in complex type definitions.
     Param(s):
            EBV (String) required
                Value
     -->
   <xsl:template name="PrintDerivationSet">
      <xsl:param name="EBV"/>

      <xsl:choose>
         <xsl:when test="normalize-space($EBV)='#all'">
            <xsl:text>restriction, extension</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$EBV"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--
     Translates occurrence of '#all' in 'final' value
     of simple type definitions.
     Param(s):
            EBV (String) required
                Value
     -->
   <xsl:template name="PrintSimpleDerivationSet">
      <xsl:param name="EBV"/>

      <xsl:choose>
         <xsl:when test="normalize-space($EBV)='#all'">
            <xsl:text>restriction, list, union</xsl:text>
         </xsl:when>
         <xsl:when test="normalize-space($EBV)!=''">
            <xsl:value-of select="$EBV"/>
         </xsl:when>
      </xsl:choose>
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

      <!--<xsl:text>&#xa;</xsl:text>-->
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

   <xsl:template name="HandleError">
      <xsl:param name="errorMsg"/>
      <xsl:param name="isTerminating">false</xsl:param>

      <xsl:choose>
         <xsl:when test="$isTerminating='true'">
            <xsl:message terminate="yes">
               <xsl:text>XS3P ERROR: </xsl:text>
               <xsl:value-of select="$errorMsg"/>
            </xsl:message>
         </xsl:when>
         <xsl:otherwise>
            <span class="err">
               <xsl:text>ERROR: </xsl:text>
               <xsl:value-of select="$errorMsg"/>
            </span>
            <xsl:text>&#xa;</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

</xsl:stylesheet>