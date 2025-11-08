<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!--
  XS3P Content Generator Module: Component Links
  This module generates links to schema components like elements, types, attributes, etc.
-->
<xsl:stylesheet
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns="http://www.w3.org/1999/xhtml"
 xmlns:xsd="http://www.w3.org/2001/XMLSchema"
 version="1.0">

   <!-- Dependencies -->
   <xsl:include href="../core/constants.xsl"/>
   <xsl:include href="../core/parameters.xsl"/>
   <xsl:include href="../utils/references.xsl"/>
   <xsl:include href="../utils/namespaces.xsl"/>
   <xsl:include href="../utils/schema-location.xsl"/>

   <xsl:template name="PrintAttributeRef">
      <xsl:param name="name"/>
      <xsl:param name="ref"/>
      <xsl:param name="schemaLoc">this</xsl:param>

      <xsl:choose>
         <xsl:when test="$name!=''">
            <xsl:call-template name="PrintCompName">
               <xsl:with-param name="name" select="$name"/>
               <xsl:with-param name="compType">attribute</xsl:with-param>
               <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:when test="$ref!=''">
            <xsl:call-template name="PrintCompRef">
               <xsl:with-param name="ref" select="$ref"/>
               <xsl:with-param name="compType">attribute</xsl:with-param>
               <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
            </xsl:call-template>
         </xsl:when>
      </xsl:choose>
   </xsl:template>

   <!--
     Generates a link to an attribute group.
     Param(s):
            name (String) optional
                Name of attribute group
            ref (String) optional
                Reference to attribute group
            (One of 'name' and 'ref' must be provided.)
            schemaLoc (String) optional
                Schema file containing this attribute group reference
                if in current schema, 'schemaLoc' is set to 'this'
     -->
   <xsl:template name="PrintAttributeGroupRef">
      <xsl:param name="name"/>
      <xsl:param name="ref"/>
      <xsl:param name="schemaLoc">this</xsl:param>

      <xsl:choose>
         <xsl:when test="$name!=''">
            <xsl:call-template name="PrintCompName">
               <xsl:with-param name="name" select="$name"/>
               <xsl:with-param name="compType">attribute group</xsl:with-param>
               <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:when test="$ref!=''">
            <xsl:call-template name="PrintCompRef">
               <xsl:with-param name="ref" select="$ref"/>
               <xsl:with-param name="compType">attribute group</xsl:with-param>
               <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
            </xsl:call-template>
         </xsl:when>
      </xsl:choose>
   </xsl:template>

   <!--
     Generates a link to an element.
     Param(s):
            name (String) optional
                Name of element
            ref (String) optional
                Reference to element
            (One of 'name' and 'ref' must be provided.)
            schemaLoc (String) optional
                Schema file containing this element reference
                if in current schema, 'schemaLoc' is set to 'this'
     -->
   <xsl:template name="PrintElementRef">
      <xsl:param name="name"/>
      <xsl:param name="ref"/>
      <xsl:param name="schemaLoc">this</xsl:param>

      <xsl:choose>
         <xsl:when test="$name!=''">
            <xsl:call-template name="PrintCompName">
               <xsl:with-param name="name" select="$name"/>
               <xsl:with-param name="compType">element</xsl:with-param>
               <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:when test="$ref!=''">
            <xsl:call-template name="PrintCompRef">
               <xsl:with-param name="ref" select="$ref"/>
               <xsl:with-param name="compType">element</xsl:with-param>
               <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
            </xsl:call-template>
         </xsl:when>
      </xsl:choose>
   </xsl:template>

   <!--
     Generates a link to a group.
     Param(s):
            name (String) optional
                Name of group
            ref (String) optional
                Reference to group
            (One of 'name' and 'ref' must be provided.)
            schemaLoc (String) optional
                Schema file containing this group reference
                if in current schema, 'schemaLoc' is set to 'this'
     -->
   <xsl:template name="PrintGroupRef">
      <xsl:param name="name"/>
      <xsl:param name="ref"/>
      <xsl:param name="schemaLoc">this</xsl:param>

      <xsl:choose>
         <xsl:when test="$name!=''">
            <xsl:call-template name="PrintCompName">
               <xsl:with-param name="name" select="$name"/>
               <xsl:with-param name="compType">group</xsl:with-param>
               <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:when test="$ref!=''">
            <xsl:call-template name="PrintCompRef">
               <xsl:with-param name="ref" select="$ref"/>
               <xsl:with-param name="compType">group</xsl:with-param>
               <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
            </xsl:call-template>
         </xsl:when>
      </xsl:choose>
   </xsl:template>

   <!--
     Generates a link to a key/uniqueness constraint.
     Param(s):
            name (String) optional
                Name of key/uniqueness constraint
            ref (String) optional
                Reference to key/uniqueness constraint
            (One of 'name' and 'ref' must be provided.)
            schemaLoc (String) optional
                Schema file containing this key/uniqueness constraint
                reference; if in current schema, 'schemaLoc' is set
                to 'this'
     -->
   <xsl:template name="PrintKeyRef">
      <xsl:param name="name"/>
      <xsl:param name="ref"/>
      <xsl:param name="schemaLoc">this</xsl:param>

      <xsl:choose>
         <xsl:when test="$name!=''">
            <xsl:call-template name="PrintCompName">
               <xsl:with-param name="name" select="$name"/>
               <xsl:with-param name="compType">uniqueness/key constraint</xsl:with-param>
               <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:when test="$ref!=''">
            <xsl:call-template name="PrintCompRef">
               <xsl:with-param name="ref" select="$ref"/>
               <xsl:with-param name="compType">uniqueness/key constraint</xsl:with-param>
               <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
            </xsl:call-template>
         </xsl:when>
      </xsl:choose>
   </xsl:template>

   <!--
     Generates a link to a type.
     Param(s):
            name (String) optional
                Name of type
            ref (String) optional
                Reference to type
            (One of 'name' and 'ref' must be provided.)
            schemaLoc (String) optional
                Schema file containing this type reference'
                if in current schema, 'schemaLoc' is set
                to 'this'
     -->
   <xsl:template name="PrintTypeRef">
      <xsl:param name="name"/>
      <xsl:param name="ref"/>
      <xsl:param name="schemaLoc">this</xsl:param>

      <xsl:choose>
         <xsl:when test="$name!=''">
            <span class="type">
               <xsl:call-template name="PrintCompName">
                  <xsl:with-param name="name" select="$name"/>
                  <xsl:with-param name="compType">type</xsl:with-param>
                  <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
               </xsl:call-template>
            </span>
         </xsl:when>
         <xsl:when test="$ref!=''">
            <span class="type">
               <xsl:call-template name="PrintCompRef">
                  <xsl:with-param name="ref" select="$ref"/>
                  <xsl:with-param name="compType">type</xsl:with-param>
                  <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
               </xsl:call-template>
            </span>
         </xsl:when>
      </xsl:choose>
   </xsl:template>

   <!--
     Prints out a link to a schema component's section.
     Param(s):
            baseFile (String) optional
                Documentation file of schema containing this
                component.
                If this component belongs to the current schema,
                omit this variable.
                If this component is from an included or imported
                schema, provide this variable.
            name (String) required
                Name of schema component
            compType (String) required
                Type of schema component
            errMsg (String) optional
                Sentence fragment.
                If specified, link will open up an alert box with
                an error message. For example, if 'errMsg' was set
                to "could not be found", 'name' was "x", and
                'compType' was "type", the error message would be:
                "x" type definition could not be found.
                The sentence fragment should not:
                -start with a capital letter.
                -have a space in front
                -end with a period.
            schemaLoc (String) optional
                Schema file containing this component;
                if in current schema, 'schemaLoc' is set to 'this'
     -->
   <xsl:template name="PrintCompName">
      <xsl:param name="baseFile"/>
      <xsl:param name="name"/>
      <xsl:param name="compType"/>
      <xsl:param name="schemaLoc">this</xsl:param>
      <xsl:param name="errMsg"/>

      <!-- Get correct terminology for statements -->
      <xsl:variable name="noun">
         <xsl:choose>
            <xsl:when test="$compType='element' or $compType='attribute'">
               <xsl:text>declaration</xsl:text>
            </xsl:when>
            <xsl:otherwise>
               <xsl:text>definition</xsl:text>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <!-- Get prefix to use in anchor name. -->
      <xsl:variable name="compPrefix">
         <xsl:choose>
            <xsl:when test="$compType='attribute'">
               <xsl:value-of select="$ATTR_PREFIX"/>
            </xsl:when>
            <xsl:when test="$compType='attribute group'">
               <xsl:value-of select="$ATTR_GRP_PREFIX"/>
            </xsl:when>
            <xsl:when test="$compType='element'">
               <xsl:value-of select="$ELEM_PREFIX"/>
            </xsl:when>
            <xsl:when test="$compType='group'">
               <xsl:value-of select="$GRP_PREFIX"/>
            </xsl:when>
            <xsl:when test="$compType='type'">
               <xsl:value-of select="$TYPE_PREFIX"/>
            </xsl:when>
            <xsl:when test="$compType='uniqueness/key constraint'">
               <xsl:value-of select="$KEY_PREFIX"/>
            </xsl:when>
         </xsl:choose>
      </xsl:variable>

      <!-- Get base URI. -->
      <xsl:variable name="baseURI">
         <xsl:choose>
            <xsl:when test="$baseFile!=''">
               <xsl:value-of select="$baseFile"/>
            </xsl:when>
            <xsl:when test="normalize-space($schemaLoc)!='this'">
               <xsl:call-template name="GetSchemaDocLocation">
                  <xsl:with-param name="uri" select="$schemaLoc"/>
               </xsl:call-template>
            </xsl:when>
         </xsl:choose>
      </xsl:variable>

      <!-- Generate message. -->
      <xsl:variable name="title">
         <xsl:choose>
            <!-- Error message was provided. -->
            <xsl:when test="$errMsg!=''">
               <xsl:text>"</xsl:text><xsl:value-of select="$name"/><xsl:text>" </xsl:text>
               <xsl:value-of select="$compType"/><xsl:text> </xsl:text>
               <xsl:value-of select="$noun"/><xsl:text> </xsl:text>
               <xsl:value-of select="$errMsg"/>
            </xsl:when>
            <!-- There exists a link to the schema component's
                 documentation. -->
            <xsl:otherwise>
               <xsl:text>Jump to "</xsl:text>
               <xsl:value-of select="$name"/>
               <xsl:text>" </xsl:text>
               <xsl:value-of select="$compType"/>
               <xsl:text> </xsl:text>
               <xsl:value-of select="$noun"/>
               <!-- External link -->
               <xsl:if test="normalize-space($baseURI)!=''">
                  <xsl:text>(located in external schema documentation)</xsl:text>
               </xsl:if>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:text>.</xsl:text>
      </xsl:variable>

      <!-- Generate href link -->
      <xsl:variable name="link">
         <xsl:choose>
            <!-- Error message was provided. -->
            <xsl:when test="$errMsg!=''">
               <xsl:text>javascript:void(0)</xsl:text>
            </xsl:when>
            <!-- There exists a link to the schema component's
                 documentation. -->
            <xsl:otherwise>
               <!-- Base URI -->
               <xsl:value-of select="normalize-space($baseURI)"/>
               <!-- Anchor within URI -->
               <xsl:value-of select="concat('#',normalize-space($compPrefix),normalize-space($name))"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <a title="{$title}" href="{$link}">
         <!-- External link -->
         <xsl:if test="normalize-space($baseURI)!=''">
            <xsl:attribute name="class">externalLink</xsl:attribute>
         </xsl:if>

         <!-- Error message was provided. -->
         <xsl:if test="$errMsg!=''">
            <xsl:attribute name="onclick">
               <xsl:text>alert('</xsl:text>
               <xsl:value-of select="$title"/>
               <xsl:text>');</xsl:text>
            </xsl:attribute>
         </xsl:if>

         <xsl:value-of select="$name"/>
      </a>
   </xsl:template>

   <!--
     Prints out a reference to a schema component.
     This template will try to work out which schema that this
     component belongs to and print out the appropriate link.
     component.
     It will also print out the namespace prefix given
     in the reference.
     Param(s):
            ref (String) required
                Reference to schema component
            compType (String) required
                Type of schema component
            schemaLoc (String) optional
                Schema file containing this component reference;
                if in current schema, 'schemaLoc' is set to 'this'
     -->
   <xsl:template name="PrintCompRef">
      <xsl:param name="ref"/>
      <xsl:param name="compType"/>
      <xsl:param name="schemaLoc">this</xsl:param>

      <!-- Get correct terminology for statements -->
      <xsl:variable name="noun">
         <xsl:choose>
            <xsl:when test="$compType='element' or $compType='attribute'">
               <xsl:text>declaration</xsl:text>
            </xsl:when>
            <xsl:otherwise>
               <xsl:text>definition</xsl:text>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

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

      <!-- Get file location of the schema component that is
           being referenced. -->
      <xsl:variable name="compLoc">
         <xsl:call-template name="FindComponent">
            <xsl:with-param name="ref" select="$ref"/>
            <xsl:with-param name="compType" select="$compType"/>
         </xsl:call-template>
      </xsl:variable>

      <!-- Print prefix -->
      <xsl:call-template name="PrintNSPrefix">
         <xsl:with-param name="prefix" select="$refPrefix"/>
         <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
      </xsl:call-template>

      <!-- Print local name -->
      <xsl:choose>
         <!-- Component from XML Schema's or XML's namespace -->
         <xsl:when test="normalize-space($compLoc)='xsd' or normalize-space($compLoc)='xml'">
            <xsl:value-of select="$refName"/>
         </xsl:when>
         <!-- Component found in this schema. -->
         <xsl:when test="normalize-space($compLoc)='this'">
            <xsl:call-template name="PrintCompName">
               <xsl:with-param name="name" select="$refName"/>
               <xsl:with-param name="compType" select="$compType"/>
               <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
            </xsl:call-template>
         </xsl:when>
         <!-- Component not found. -->
         <xsl:when test="normalize-space($compLoc)='' or normalize-space($compLoc)='none'">
            <xsl:call-template name="PrintCompName">
               <xsl:with-param name="name" select="$refName"/>
               <xsl:with-param name="compType" select="$compType"/>
               <xsl:with-param name="errMsg">could not be found</xsl:with-param>
            </xsl:call-template>
         </xsl:when>
         <!-- Component found in an external schema. -->
         <xsl:otherwise>
            <!-- Get documentation file for included schema. -->
            <xsl:variable name="docFile">
               <xsl:call-template name="GetSchemaDocLocation">
                  <xsl:with-param name="uri" select="$compLoc"/>
               </xsl:call-template>
            </xsl:variable>

            <xsl:call-template name="PrintCompName">
               <xsl:with-param name="baseFile" select="$docFile"/>
               <xsl:with-param name="name" select="$refName"/>
               <xsl:with-param name="compType" select="$compType"/>
               <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
            </xsl:call-template>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

</xsl:stylesheet>
