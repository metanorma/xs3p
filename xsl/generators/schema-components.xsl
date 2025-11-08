<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!--
  XS3P Content Generator Module: Schema Component Representation
  This module generates the raw XSD representation view of schema components.

  Dependencies:
  - core/constants.xsl
  - utils/references.xsl
  - utils/namespaces.xsl
  - renderers/xml-pretty-printer.xsl
  - generators/component-links.xsl
-->
<xsl:stylesheet
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns="http://www.w3.org/1999/xhtml"
 xmlns:xsd="http://www.w3.org/2001/XMLSchema"
 version="1.0"
 exclude-result-prefixes="xsd">

   <!--
     Prints out the Schema Component Representation table
     for a top-level schema component.
     Param(s):
            component (Node) required
              Top-level schema component
     -->
   <xsl:template name="SchemaComponentTable">
      <xsl:param name="component"/>

      <xsl:variable name="componentID">
         <xsl:call-template name="GetComponentID">
            <xsl:with-param name="component" select="$component"/>
         </xsl:call-template>
      </xsl:variable>


      <div class="bs-callout bs-callout-info">
            <h4>Schema Component Representation
               <span class="xs3p-panel-help">
                  <button type="button" class="btn btn-doc" data-container="body" data-toggle="popover" data-placement="left" data-html="true" data-content="{$HELP_REPRESENTATION}">
                  <span class="glyphicon glyphicon-question-sign"><xsl:text> </xsl:text></span>
                  </button>
               </span>
            </h4>

            <pre class="codehilite">
               <xsl:apply-templates select="$component" mode="schemaComponent"/>
            </pre>
         </div>

   </xsl:template>

   <!--
     Prints out schema component representation of
     declarations.
     Param(s):
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
     -->
   <xsl:template match="xsd:attribute[@name] | xsd:element[@name]" mode="schemaComponent">
      <xsl:param name="margin">0</xsl:param>

      <xsl:call-template name="DisplaySchemaComponent">
         <xsl:with-param name="component" select="."/>
         <xsl:with-param name="margin" select="$margin"/>
         <xsl:with-param name="attributes">
            <!-- Attribute: name -->
            <xsl:call-template name="DisplayAttr">
               <xsl:with-param name="attrName">name</xsl:with-param>
               <xsl:with-param name="attrValue" select="normalize-space(@name)"/>
            </xsl:call-template>
            <!-- Attribute: type -->
            <xsl:if test="@type">
               <xsl:call-template name="DisplayAttr">
                  <xsl:with-param name="attrName">type</xsl:with-param>
                  <xsl:with-param name="attrValue">
                     <xsl:call-template name="PrintTypeRef">
                        <xsl:with-param name="ref" select="normalize-space(@type)"/>
                     </xsl:call-template>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:if>
            <!-- Other attributes -->
            <xsl:call-template name="DisplayOtherAttributes">
               <xsl:with-param name="component" select="."/>
               <xsl:with-param name="attrsNotToDisplay">*name+*type+</xsl:with-param>
            </xsl:call-template>
         </xsl:with-param>
         <xsl:with-param name="excludeFilter">*annotation+</xsl:with-param>
      </xsl:call-template>
   </xsl:template>

   <!--
     Prints out schema component representation of
     definitions and key/uniqueness constraints.
     Param(s):
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
     -->
   <xsl:template match="xsd:attributeGroup[@name] | xsd:complexType[@name] | xsd:simpleType[@name] | xsd:group[@name] | xsd:key | xsd:unique" mode="schemaComponent">
      <xsl:param name="margin">0</xsl:param>

      <xsl:call-template name="DisplaySchemaComponent">
         <xsl:with-param name="component" select="."/>
         <xsl:with-param name="margin" select="$margin"/>
         <xsl:with-param name="attributes">
            <!-- Attribute: name -->
            <xsl:call-template name="DisplayAttr">
               <xsl:with-param name="attrName">name</xsl:with-param>
               <xsl:with-param name="attrValue" select="normalize-space(@name)"/>
            </xsl:call-template>
            <!-- Other attributes -->
            <xsl:call-template name="DisplayOtherAttributes">
               <xsl:with-param name="component" select="."/>
               <xsl:with-param name="attrsNotToDisplay">*name+</xsl:with-param>
            </xsl:call-template>
         </xsl:with-param>
         <xsl:with-param name="excludeFilter">*annotation+</xsl:with-param>
      </xsl:call-template>
   </xsl:template>

   <!--
     Prints out schema component representation of attribute
     references.
     Param(s):
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
     -->
   <xsl:template match="xsd:attribute[@ref]" mode="schemaComponent">
      <xsl:param name="margin">0</xsl:param>

      <xsl:call-template name="DisplaySchemaComponent">
         <xsl:with-param name="component" select="."/>
         <xsl:with-param name="margin" select="$margin"/>
         <xsl:with-param name="attributes">
            <!-- Attribute: ref -->
            <xsl:call-template name="DisplayAttr">
               <xsl:with-param name="attrName">ref</xsl:with-param>
               <xsl:with-param name="attrValue">
                  <xsl:call-template name="PrintAttributeRef">
                     <xsl:with-param name="ref" select="normalize-space(@ref)"/>
                  </xsl:call-template>
               </xsl:with-param>
            </xsl:call-template>
            <!-- Other attributes -->
            <xsl:call-template name="DisplayOtherAttributes">
               <xsl:with-param name="component" select="."/>
               <xsl:with-param name="attrsNotToDisplay">*ref+</xsl:with-param>
            </xsl:call-template>
         </xsl:with-param>
         <xsl:with-param name="excludeFilter">*annotation+</xsl:with-param>
      </xsl:call-template>
   </xsl:template>

   <!--
     Prints out schema component representation of attribute group
     references.
     Param(s):
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
     -->
   <xsl:template match="xsd:attributeGroup[@ref]" mode="schemaComponent">
      <xsl:param name="margin">0</xsl:param>

      <xsl:call-template name="DisplaySchemaComponent">
         <xsl:with-param name="component" select="."/>
         <xsl:with-param name="margin" select="$margin"/>
         <xsl:with-param name="attributes">
            <!-- Attribute: ref -->
            <xsl:call-template name="DisplayAttr">
               <xsl:with-param name="attrName">ref</xsl:with-param>
               <xsl:with-param name="attrValue">
                  <xsl:call-template name="PrintAttributeGroupRef">
                     <xsl:with-param name="ref" select="normalize-space(@ref)"/>
                  </xsl:call-template>
               </xsl:with-param>
            </xsl:call-template>
            <!-- Other attributes -->
            <xsl:call-template name="DisplayOtherAttributes">
               <xsl:with-param name="component" select="."/>
               <xsl:with-param name="attrsNotToDisplay">*ref+</xsl:with-param>
            </xsl:call-template>
         </xsl:with-param>
         <xsl:with-param name="excludeFilter">*annotation+</xsl:with-param>
      </xsl:call-template>
   </xsl:template>

   <!--
     Prints out schema component representation of element
     references.
     Param(s):
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
     -->
   <xsl:template match="xsd:element[@ref]" mode="schemaComponent">
      <xsl:param name="margin">0</xsl:param>

      <xsl:call-template name="DisplaySchemaComponent">
         <xsl:with-param name="component" select="."/>
         <xsl:with-param name="margin" select="$margin"/>
         <xsl:with-param name="attributes">
            <!-- Attribute: ref -->
            <xsl:call-template name="DisplayAttr">
               <xsl:with-param name="attrName">ref</xsl:with-param>
               <xsl:with-param name="attrValue">
                  <xsl:call-template name="PrintElementRef">
                     <xsl:with-param name="ref" select="normalize-space(@ref)"/>
                  </xsl:call-template>
               </xsl:with-param>
            </xsl:call-template>
            <!-- Other attributes -->
            <xsl:call-template name="DisplayOtherAttributes">
               <xsl:with-param name="component" select="."/>
               <xsl:with-param name="attrsNotToDisplay">*ref+</xsl:with-param>
            </xsl:call-template>
         </xsl:with-param>
         <xsl:with-param name="excludeFilter">*annotation+</xsl:with-param>
      </xsl:call-template>
   </xsl:template>

   <!--
     Prints out schema component representation of model group
     references.
     Param(s):
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
     -->
   <xsl:template match="xsd:group[@ref]" mode="schemaComponent">
      <xsl:param name="margin">0</xsl:param>

      <xsl:call-template name="DisplaySchemaComponent">
         <xsl:with-param name="component" select="."/>
         <xsl:with-param name="margin" select="$margin"/>
         <xsl:with-param name="attributes">
            <!-- Attribute: ref -->
            <xsl:call-template name="DisplayAttr">
               <xsl:with-param name="attrName">ref</xsl:with-param>
               <xsl:with-param name="attrValue">
                  <xsl:call-template name="PrintGroupRef">
                     <xsl:with-param name="ref" select="normalize-space(@ref)"/>
                  </xsl:call-template>
               </xsl:with-param>
            </xsl:call-template>
            <!-- Other attributes -->
            <xsl:call-template name="DisplayOtherAttributes">
               <xsl:with-param name="component" select="."/>
               <xsl:with-param name="attrsNotToDisplay">*ref+</xsl:with-param>
            </xsl:call-template>
         </xsl:with-param>
         <xsl:with-param name="excludeFilter">*annotation+</xsl:with-param>
      </xsl:call-template>
   </xsl:template>

   <!--
     Prints out schema component representation of
     'appinfo' and 'documentation' elements.
     Param(s):
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
     -->
   <xsl:template match="xsd:appinfo | xsd:documentation" mode="schemaComponent">
      <xsl:param name="margin">0</xsl:param>

      <xsl:call-template name="DisplaySchemaComponent">
         <xsl:with-param name="component" select="."/>
         <xsl:with-param name="margin" select="$margin"/>
         <xsl:with-param name="attributes">
            <!-- Attribute: source -->
            <xsl:if test="@source">
               <xsl:call-template name="DisplayAttr">
                  <xsl:with-param name="attrName">source</xsl:with-param>
                  <xsl:with-param name="attrValue">
                     <xsl:call-template name="PrintURI">
                        <xsl:with-param name="uri" select="normalize-space(@source)"/>
                     </xsl:call-template>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:if>
            <!-- Other attributes -->
            <xsl:call-template name="DisplayOtherAttributes">
               <xsl:with-param name="component" select="."/>
               <xsl:with-param name="attrsNotToDisplay">*source+</xsl:with-param>
            </xsl:call-template>
         </xsl:with-param>
         <xsl:with-param name="hasAnyContent">true</xsl:with-param>
      </xsl:call-template>
   </xsl:template>

   <!--
     Prints out schema component representation of
     key reference constraints.
     Param(s):
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
     -->
   <xsl:template match="xsd:keyref" mode="schemaComponent">
      <xsl:param name="margin">0</xsl:param>

      <xsl:call-template name="DisplaySchemaComponent">
         <xsl:with-param name="component" select="."/>
         <xsl:with-param name="margin" select="$margin"/>
         <xsl:with-param name="attributes">
            <!-- Attribute: name -->
            <xsl:call-template name="DisplayAttr">
               <xsl:with-param name="attrName">name</xsl:with-param>
               <xsl:with-param name="attrValue" select="normalize-space(@name)"/>
            </xsl:call-template>
            <!-- Attribute: refers -->
            <xsl:call-template name="DisplayAttr">
               <xsl:with-param name="attrName">refer</xsl:with-param>
               <xsl:with-param name="attrValue">
                  <xsl:call-template name="PrintKeyRef">
                     <xsl:with-param name="ref">
                        <xsl:value-of select="normalize-space(@refer)"/>
                     </xsl:with-param>
                  </xsl:call-template>
               </xsl:with-param>
            </xsl:call-template>
            <!-- Other attributes -->
            <xsl:call-template name="DisplayOtherAttributes">
               <xsl:with-param name="component" select="."/>
               <xsl:with-param name="attrsNotToDisplay">*name+*refer+</xsl:with-param>
            </xsl:call-template>
         </xsl:with-param>
         <xsl:with-param name="excludeFilter">*annotation+</xsl:with-param>
      </xsl:call-template>
   </xsl:template>

   <!--
     Prints out schema component representation of
     derivations by extension and restrictions.
     Param(s):
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
     -->
   <xsl:template match="xsd:extension | xsd:restriction" mode="schemaComponent">
      <xsl:param name="margin">0</xsl:param>

      <xsl:call-template name="DisplaySchemaComponent">
         <xsl:with-param name="component" select="."/>
         <xsl:with-param name="margin" select="$margin"/>
         <xsl:with-param name="attributes">
            <!-- Attribute: base -->
            <xsl:if test="@base">
               <xsl:call-template name="DisplayAttr">
                  <xsl:with-param name="attrName">base</xsl:with-param>
                  <xsl:with-param name="attrValue">
                     <xsl:call-template name="PrintTypeRef">
                        <xsl:with-param name="ref" select="normalize-space(@base)"/>
                     </xsl:call-template>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:if>
            <!-- Other attributes -->
            <xsl:call-template name="DisplayOtherAttributes">
               <xsl:with-param name="component" select="."/>
               <xsl:with-param name="attrsNotToDisplay">*base+</xsl:with-param>
            </xsl:call-template>
         </xsl:with-param>
         <xsl:with-param name="excludeFilter">*annotation+</xsl:with-param>
      </xsl:call-template>
   </xsl:template>

   <!--
     Prints out schema component representation of
     derivations by list.
     Param(s):
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
     -->
   <xsl:template match="xsd:list" mode="schemaComponent">
      <xsl:param name="margin">0</xsl:param>

      <xsl:call-template name="DisplaySchemaComponent">
         <xsl:with-param name="component" select="."/>
         <xsl:with-param name="margin" select="$margin"/>
         <xsl:with-param name="attributes">
            <!-- Attribute: itemType-->
            <xsl:if test="@itemType">
               <xsl:call-template name="DisplayAttr">
                  <xsl:with-param name="attrName">itemType</xsl:with-param>
                  <xsl:with-param name="attrValue">
                     <xsl:call-template name="PrintTypeRef">
                        <xsl:with-param name="ref" select="normalize-space(@itemType)"/>
                     </xsl:call-template>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:if>
            <!-- Other attributes -->
            <xsl:call-template name="DisplayOtherAttributes">
               <xsl:with-param name="component" select="."/>
               <xsl:with-param name="attrsNotToDisplay">*itemType+</xsl:with-param>
            </xsl:call-template>
         </xsl:with-param>
         <xsl:with-param name="excludeFilter">*annotation+</xsl:with-param>
      </xsl:call-template>
   </xsl:template>

   <!--
     Prints out schema component representation of
     derivations by union.
     Param(s):
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
     -->
   <xsl:template match="xsd:union" mode="schemaComponent">
      <xsl:param name="margin">0</xsl:param>

      <xsl:call-template name="DisplaySchemaComponent">
         <xsl:with-param name="component" select="."/>
         <xsl:with-param name="margin" select="$margin"/>
         <xsl:with-param name="attributes">
            <!-- Attribute: memberTypes-->
            <xsl:if test="@memberTypes">
               <xsl:call-template name="DisplayAttr">
                  <xsl:with-param name="attrName">memberTypes</xsl:with-param>
                  <xsl:with-param name="attrValue">
                     <xsl:call-template name="PrintWhitespaceList">
                        <xsl:with-param name="value" select="normalize-space(@memberTypes)"/>
                        <xsl:with-param name="compType">type</xsl:with-param>
                     </xsl:call-template>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:if>
            <!-- Other attributes -->
            <xsl:call-template name="DisplayOtherAttributes">
               <xsl:with-param name="component" select="."/>
               <xsl:with-param name="attrsNotToDisplay">*memberTypes+</xsl:with-param>
            </xsl:call-template>
         </xsl:with-param>
         <xsl:with-param name="excludeFilter">*annotation+</xsl:with-param>
      </xsl:call-template>
   </xsl:template>

   <!--
     Prints out schema component representation of
     the root schema element.
     Param(s):
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
     -->
   <xsl:template match="xsd:schema" mode="schemaComponent">
      <xsl:param name="margin">0</xsl:param>

      <xsl:call-template name="DisplaySchemaComponent">
         <xsl:with-param name="component" select="."/>
         <xsl:with-param name="margin" select="$margin"/>
         <xsl:with-param name="attributes">
            <!-- Attribute: source -->
            <xsl:if test="@xml:lang">
               <xsl:call-template name="DisplayAttr">
                  <xsl:with-param name="attrName">xml:lang</xsl:with-param>
                  <xsl:with-param name="attrValue" select="normalize-space(@xml:lang)"/>
               </xsl:call-template>
            </xsl:if>
            <!-- Other attributes -->
            <xsl:call-template name="DisplayOtherAttributes">
               <xsl:with-param name="component" select="."/>
               <xsl:with-param name="attrsNotToDisplay">*lang+</xsl:with-param>
            </xsl:call-template>
         </xsl:with-param>
         <xsl:with-param name="includeFilter">*include+*import+*redefine+</xsl:with-param>
      </xsl:call-template>
   </xsl:template>

   <!--
     Default way to print out schema component representation.
     Param(s):
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
     -->
   <xsl:template match="*" mode="schemaComponent">
      <xsl:param name="margin">0</xsl:param>

      <xsl:call-template name="DisplaySchemaComponent">
         <xsl:with-param name="component" select="."/>
         <xsl:with-param name="margin" select="$margin"/>
         <xsl:with-param name="attributes">
            <xsl:call-template name="DisplayOtherAttributes">
               <xsl:with-param name="component" select="."/>
            </xsl:call-template>
         </xsl:with-param>
         <xsl:with-param name="excludeFilter">*annotation+</xsl:with-param>
      </xsl:call-template>
   </xsl:template>

   <!--
     Prints out comments in schema component representation.
     Param(s):
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
     -->
   <xsl:template match="comment()" mode="schemaComponent">
      <xsl:param name="margin">0</xsl:param>

      <span class="comment" style="margin-left: {$margin}em">
         <xsl:text>&lt;--</xsl:text>
         <xsl:value-of select="."/>
         <xsl:text>--&gt;</xsl:text>
      </span>
   </xsl:template>

   <!--
     Displays a schema element in the correct format
     for the Schema Component Representation table, e.g.
     tags are one color, and content are another.
     Param(s):
            component (Node) required
                Schema element to be displayed
            attributes (Result Tree Fragment) optional
                Pre-formatted attributes of schema element
            margin (nonNegativeInteger) optional
                Number of 'em' to indent from left
            hasAnyContent (boolean) optional
                Set to true if schema element can accept
                child elements from namespaces other than
                the schema namespace, e.g. 'documentation'
                and 'appinfo'
            includeFilter (String) optional
                List of element names, sandwiched between the
                characters, '*' and '+'. If specified, only the
                child elements of the component with tags in
                the list will be displayed.
            excludeFilter (String) optional
                List of element names, sandwiched between the
                characters, '*' and '+'. If specified, display
                all child elements of the component, except
                those with tags in the list.
     -->
   <xsl:template name="DisplaySchemaComponent">
      <xsl:param name="component"/>
      <xsl:param name="attributes"/>
      <xsl:param name="margin">0</xsl:param>
      <xsl:param name="hasAnyContent">false</xsl:param>
      <xsl:param name="includeFilter"/>
      <xsl:param name="excludeFilter"/>

      <xsl:variable name="tag">
         <xsl:call-template name="PrintNSPrefix">
            <xsl:with-param name="prefix">
               <xsl:call-template name="GetXSDPrefix"/>
            </xsl:with-param>
         </xsl:call-template>
         <xsl:value-of select="local-name($component)"/>
      </xsl:variable>

         <!-- Start Tag -->
         <xsl:call-template name="Repeat">
            <xsl:with-param name="content"><xsl:text> </xsl:text></xsl:with-param>
            <xsl:with-param name="count" select="$margin"/>
         </xsl:call-template>
         <span class="nt">
            <xsl:text>&lt;</xsl:text>
            <xsl:copy-of select="$tag"/>
         </span>
         <!-- Attributes -->
         <xsl:copy-of select="$attributes"/>
         <!-- Content -->
         <xsl:variable name="content">
            <xsl:choose>
               <!-- Include filter is on -->
               <xsl:when test="$includeFilter!=''">
                  <xsl:apply-templates select="$component/xsd:*[contains($includeFilter, concat('*', local-name(.), '+'))]" mode="schemaComponent">
                     <xsl:with-param name="margin" select="$ELEM_INDENT"/>
                  </xsl:apply-templates>
                  <xsl:call-template name="Repeat">
                     <xsl:with-param name="content"><xsl:text> </xsl:text></xsl:with-param>
                     <xsl:with-param name="count" select="$margin"/>
                  </xsl:call-template>
                  <span class="scContent">...</span>
                  <xsl:text>&#xa;</xsl:text>
               </xsl:when>
               <!-- Exclude filter is on -->
               <xsl:when test="$excludeFilter!=''">
                  <xsl:apply-templates select="comment() | $component/xsd:*[not(contains($excludeFilter, concat('*', local-name(.), '+')))]" mode="schemaComponent">
                     <xsl:with-param name="margin" select="number($margin) + number($ELEM_INDENT)"/>
                  </xsl:apply-templates>
               </xsl:when>
               <!-- Permits any content -->
               <xsl:when test="$hasAnyContent='true'">
                  <div class="scContent" style="margin-left: {$ELEM_INDENT}em">
                     <xsl:apply-templates select="comment() | $component/* | $component/text()" mode="xpp"/>
                  </div>
               </xsl:when>
               <!-- Contains schema elements -->
               <xsl:otherwise>
                  <xsl:apply-templates select="comment() | $component/xsd:*" mode="schemaComponent">
                     <xsl:with-param name="margin" select="number($margin) + number($ELEM_INDENT)"/>
                  </xsl:apply-templates>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>

         <xsl:choose>
            <!-- Has content -->
            <xsl:when test="normalize-space($content)!=''">
               <!-- End of start tag -->
               <span class="nt">
                  <xsl:text>></xsl:text>
               </span>
               <xsl:text>&#xa;</xsl:text>

               <!-- Content -->
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
               <xsl:text>&#xa;</xsl:text>
            </xsl:when>
            <!-- Empty content -->
            <xsl:otherwise>
               <!-- End of start tag -->
               <span class="nt">
                  <xsl:text>/></xsl:text>
               </span>
               <xsl:text>&#xa;</xsl:text>
            </xsl:otherwise>
         </xsl:choose>
   </xsl:template>

   <!--
     Displays a schema attribute in the correct format
     for the Schema Component Representation table, e.g.
     tags are one color, and content are another.
     Param(s):
            attrName (String) required
                Name of attribute
            attrValue (Result Tree Fragment) required
                Value of attribute, which may be links
     -->
   <xsl:template name="DisplayAttr">
      <xsl:param name="attrName"/>
      <xsl:param name="attrValue"/>

      <xsl:text> </xsl:text>
      <span class="na">
         <xsl:value-of select="$attrName"/>
         <xsl:text>=</xsl:text>
      </span>
      <span class="s">
         <xsl:text>"</xsl:text>
         <xsl:if test="normalize-space($attrValue)!=''">
            <xsl:copy-of select="$attrValue"/>
         </xsl:if>
         <xsl:text>"</xsl:text>
      </span>
   </xsl:template>

   <!--
     Displays attributes from a schema element, unless
     otherwise specified, in the correct format
     for the Schema Component Representation table, e.g.
     tags are one color, and content are another.
     Param(s):
            component (Node) required
                Schema element whose attributes are to be displayed
            attrsNotToDisplay (String) required
                List of attributes not to be displayed
                Each attribute name should prepended with '*'
                and appended with '+'
     -->
   <xsl:template name="DisplayOtherAttributes">
      <xsl:param name="component"/>
      <xsl:param name="attrsNotToDisplay"/>

      <xsl:for-each select="$component/attribute::*">
         <xsl:variable name="attrName" select="local-name(.)"/>
         <xsl:if test="not(contains($attrsNotToDisplay, concat('*', $attrName, '+')))">
            <xsl:call-template name="DisplayAttr">
               <xsl:with-param name="attrName" select="normalize-space($attrName)"/>
               <xsl:with-param name="attrValue" select="normalize-space(.)"/>
            </xsl:call-template>
         </xsl:if>
      </xsl:for-each>
   </xsl:template>

</xsl:stylesheet>