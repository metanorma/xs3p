<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!--
  XS3P Rendering Module: Glossary
  This module contains templates for glossary generation and term references.
-->
<xsl:stylesheet
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns="http://www.w3.org/1999/xhtml"
 xmlns:xsd="http://www.w3.org/2001/XMLSchema"
 version="1.0">

   <!-- Dependencies -->
   <xsl:include href="../core/constants.xsl"/>

   <!--
     Prints out all terms for the glossary section.
     -->
   <xsl:template name="Glossary">
      <xsl:call-template name="PrintGlossaryTerm">
         <xsl:with-param name="code">Abstract</xsl:with-param>
         <xsl:with-param name="term">Abstract</xsl:with-param>
         <xsl:with-param name="description">
            <xsl:text>(Applies to complex type definitions and element declarations).</xsl:text>
            <xsl:text> An abstract element or complex type cannot used to validate an element instance.</xsl:text>
            <xsl:text> If there is a reference to an abstract element, only element declarations that can substitute the abstract element can be used to validate the instance.</xsl:text>
            <xsl:text> For references to abstract type definitions, only derived types can be used.</xsl:text>
         </xsl:with-param>
      </xsl:call-template>

      <xsl:call-template name="PrintGlossaryTerm">
         <xsl:with-param name="code">All</xsl:with-param>
         <xsl:with-param name="term">All Model Group</xsl:with-param>
         <xsl:with-param name="description">
            <xsl:text>Child elements can be provided </xsl:text>
            <em>
               <xsl:text>in any order</xsl:text>
            </em>
            <xsl:text> in instances.</xsl:text>
         </xsl:with-param>
         <xsl:with-param name="link">http://www.w3.org/TR/xmlschema-1/#element-all</xsl:with-param>
      </xsl:call-template>

      <xsl:call-template name="PrintGlossaryTerm">
         <xsl:with-param name="code">Choice</xsl:with-param>
         <xsl:with-param name="term">Choice Model Group</xsl:with-param>
         <xsl:with-param name="description">
            <em>
               <xsl:text>Only one</xsl:text>
            </em>
            <xsl:text> from the list of child elements and model groups can be provided in instances.</xsl:text>
         </xsl:with-param>
         <xsl:with-param name="link">http://www.w3.org/TR/xmlschema-1/#element-choice</xsl:with-param>
      </xsl:call-template>

      <xsl:call-template name="PrintGlossaryTerm">
         <xsl:with-param name="code">CollapseWS</xsl:with-param>
         <xsl:with-param name="term">Collapse Whitespace Policy</xsl:with-param>
         <xsl:with-param name="description">Replace tab, line feed, and carriage return characters with space character (Unicode character 32). Then, collapse contiguous sequences of space characters into single space character, and remove leading and trailing space characters.</xsl:with-param>
      </xsl:call-template>

      <xsl:call-template name="PrintGlossaryTerm">
         <xsl:with-param name="code">ElemBlock</xsl:with-param>
         <xsl:with-param name="term">Disallowed Substitutions</xsl:with-param>
         <xsl:with-param name="description">
            <xsl:text>(Applies to element declarations).</xsl:text>
            <xsl:text> If </xsl:text>
            <em>substitution</em>
            <xsl:text> is specified, then </xsl:text>
            <xsl:call-template name="PrintGlossaryTermRef">
               <xsl:with-param name="code">SubGroup</xsl:with-param>
               <xsl:with-param name="term">substitution group</xsl:with-param>
            </xsl:call-template>
            <xsl:text> members cannot be used in place of the given element declaration to validate element instances.</xsl:text>

            <xsl:text> If </xsl:text>
            <em>derivation methods</em>
            <xsl:text>, e.g. extension, restriction, are specified, then the given element declaration will not validate element instances that have types derived from the element declaration's type using the specified derivation methods.</xsl:text>
            <xsl:text> Normally, element instances can override their declaration's type by specifying an </xsl:text>
            <code>xsi:type</code>
            <xsl:text> attribute.</xsl:text>
         </xsl:with-param>
      </xsl:call-template>

      <xsl:call-template name="PrintGlossaryTerm">
         <xsl:with-param name="code">Key</xsl:with-param>
         <xsl:with-param name="term">Key Constraint</xsl:with-param>
         <xsl:with-param name="description">
            <xsl:text>Like </xsl:text>
            <xsl:call-template name="PrintGlossaryTermRef">
               <xsl:with-param name="code">Unique</xsl:with-param>
               <xsl:with-param name="term">Uniqueness Constraint</xsl:with-param>
            </xsl:call-template>
            <xsl:text>, but additionally requires that the specified value(s) must be provided.</xsl:text>
         </xsl:with-param>
         <xsl:with-param name="link">http://www.w3.org/TR/xmlschema-1/#cIdentity-constraint_Definitions</xsl:with-param>
      </xsl:call-template>

      <xsl:call-template name="PrintGlossaryTerm">
         <xsl:with-param name="code">KeyRef</xsl:with-param>
         <xsl:with-param name="term">Key Reference Constraint</xsl:with-param>
         <xsl:with-param name="description">
            <xsl:text>Ensures that the specified value(s) must match value(s) from a </xsl:text>
            <xsl:call-template name="PrintGlossaryTermRef">
               <xsl:with-param name="code">Key</xsl:with-param>
               <xsl:with-param name="term">Key Constraint</xsl:with-param>
            </xsl:call-template>
            <xsl:text> or </xsl:text>
            <xsl:call-template name="PrintGlossaryTermRef">
               <xsl:with-param name="code">Unique</xsl:with-param>
               <xsl:with-param name="term">Uniqueness Constraint</xsl:with-param>
            </xsl:call-template>
            <xsl:text>.</xsl:text>
         </xsl:with-param>
         <xsl:with-param name="link">http://www.w3.org/TR/xmlschema-1/#cIdentity-constraint_Definitions</xsl:with-param>
      </xsl:call-template>

      <xsl:call-template name="PrintGlossaryTerm">
         <xsl:with-param name="code">ModelGroup</xsl:with-param>
         <xsl:with-param name="term">Model Group</xsl:with-param>
         <xsl:with-param name="description">
            <xsl:text>Groups together element content, specifying the order in which the element content can occur and the number of times the group of element content may be repeated.</xsl:text>
         </xsl:with-param>
         <xsl:with-param name="link">http://www.w3.org/TR/xmlschema-1/#Model_Groups</xsl:with-param>
      </xsl:call-template>

      <xsl:call-template name="PrintGlossaryTerm">
         <xsl:with-param name="code">Nillable</xsl:with-param>
         <xsl:with-param name="term">Nillable</xsl:with-param>
         <xsl:with-param name="description">
            <xsl:text>(Applies to element declarations). </xsl:text>
            <xsl:text>If an element declaration is nillable, instances can use the </xsl:text>
            <code>xsi:nil</code>
            <xsl:text> attribute.</xsl:text>
            <xsl:text> The </xsl:text>
            <code>xsi:nil</code>
            <xsl:text> attribute is the boolean attribute, </xsl:text>
            <em>nil</em>
            <xsl:text>, from the </xsl:text>
            <em>http://www.w3.org/2001/XMLSchema-instance</em>
            <xsl:text> namespace.</xsl:text>
            <xsl:text> If an element instance has an </xsl:text>
            <code>xsi:nil</code>
            <xsl:text> attribute set to true, it can be left empty, even though its element declaration may have required content.</xsl:text>
         </xsl:with-param>
      </xsl:call-template>

      <xsl:call-template name="PrintGlossaryTerm">
         <xsl:with-param name="code">Notation</xsl:with-param>
         <xsl:with-param name="term">Notation</xsl:with-param>
         <xsl:with-param name="description">A notation is used to identify the format of a piece of data. Values of elements and attributes that are of type, NOTATION, must come from the names of declared notations.</xsl:with-param>
         <xsl:with-param name="link">http://www.w3.org/TR/xmlschema-1/#cNotation_Declarations</xsl:with-param>
      </xsl:call-template>

      <xsl:call-template name="PrintGlossaryTerm">
         <xsl:with-param name="code">PreserveWS</xsl:with-param>
         <xsl:with-param name="term">Preserve Whitespace Policy</xsl:with-param>
         <xsl:with-param name="description">Preserve whitespaces exactly as they appear in instances.</xsl:with-param>
      </xsl:call-template>

      <xsl:call-template name="PrintGlossaryTerm">
         <xsl:with-param name="code">TypeFinal</xsl:with-param>
         <xsl:with-param name="term">Prohibited Derivations</xsl:with-param>
         <xsl:with-param name="description">
            <xsl:text>(Applies to type definitions). </xsl:text>
            <xsl:text>Derivation methods that cannot be used to create sub-types from a given type definition.</xsl:text>
         </xsl:with-param>
      </xsl:call-template>

      <xsl:call-template name="PrintGlossaryTerm">
         <xsl:with-param name="code">TypeBlock</xsl:with-param>
         <xsl:with-param name="term">Prohibited Substitutions</xsl:with-param>
         <xsl:with-param name="description">
            <xsl:text>(Applies to complex type definitions). </xsl:text>
            <xsl:text>Prevents sub-types that have been derived using the specified derivation methods from validating element instances in place of the given type definition.</xsl:text>
         </xsl:with-param>
      </xsl:call-template>

      <xsl:call-template name="PrintGlossaryTerm">
         <xsl:with-param name="code">ReplaceWS</xsl:with-param>
         <xsl:with-param name="term">Replace Whitespace Policy</xsl:with-param>
         <xsl:with-param name="description">Replace tab, line feed, and carriage return characters with space character (Unicode character 32).</xsl:with-param>
      </xsl:call-template>

      <xsl:call-template name="PrintGlossaryTerm">
         <xsl:with-param name="code">Sequence</xsl:with-param>
         <xsl:with-param name="term">Sequence Model Group</xsl:with-param>
         <xsl:with-param name="description">
            <xsl:text>Child elements and model groups must be provided </xsl:text>
            <em>
               <xsl:text>in the specified order</xsl:text>
            </em>
            <xsl:text> in instances.</xsl:text>
         </xsl:with-param>
         <xsl:with-param name="link">http://www.w3.org/TR/xmlschema-1/#element-sequence</xsl:with-param>
      </xsl:call-template>

      <xsl:call-template name="PrintGlossaryTerm">
         <xsl:with-param name="code">SubGroup</xsl:with-param>
         <xsl:with-param name="term">Substitution Group</xsl:with-param>
         <xsl:with-param name="description">
            <xsl:text>Elements that are </xsl:text>
            <em>
               <xsl:text>members</xsl:text>
            </em>
            <xsl:text> of a substitution group can be used wherever the </xsl:text>
            <em>
               <xsl:text>head</xsl:text>
            </em>
            <xsl:text> element of the substitution group is referenced.</xsl:text>
         </xsl:with-param>
      </xsl:call-template>

      <xsl:call-template name="PrintGlossaryTerm">
         <xsl:with-param name="code">ElemFinal</xsl:with-param>
         <xsl:with-param name="term">Substitution Group Exclusions</xsl:with-param>
         <xsl:with-param name="description">
            <xsl:text>(Applies to element declarations). </xsl:text>
            <xsl:text>Prohibits element declarations from nominating themselves as being able to substitute a given element declaration, if they have types that are derived from the original element's type using the specified derivation methods.</xsl:text>
         </xsl:with-param>
      </xsl:call-template>

      <xsl:call-template name="PrintGlossaryTerm">
         <xsl:with-param name="code">TargetNS</xsl:with-param>
         <xsl:with-param name="term">Target Namespace</xsl:with-param>
         <xsl:with-param name="description">The target namespace identifies the namespace that components in this schema belongs to. If no target namespace is provided, then the schema components do not belong to any namespace.</xsl:with-param>
      </xsl:call-template>

      <xsl:call-template name="PrintGlossaryTerm">
         <xsl:with-param name="code">Unique</xsl:with-param>
         <xsl:with-param name="term">Uniqueness Constraint</xsl:with-param>
         <xsl:with-param name="description">Ensures uniqueness of an element/attribute value, or a combination of values, within a specified scope.</xsl:with-param>
         <xsl:with-param name="link">http://www.w3.org/TR/xmlschema-1/#cIdentity-constraint_Definitions</xsl:with-param>
      </xsl:call-template>
   </xsl:template>

   <!--
     Prints out a term in the glossary section.
     Param(s):
            code (String) required
              Unique ID of glossary term
            term (String) required
              Glossary term
            description (Result Tree Fragment) required
              Meaning of term; may contain HTML tags and links
            link (String) optional
              URI containing more info about term
     -->
   <xsl:template name="PrintGlossaryTerm">
      <xsl:param name="code"/>
      <xsl:param name="term"/>
      <xsl:param name="description"/>
      <xsl:param name="link"/>

      <p>
         <span class="glossaryTerm">
            <a id="{concat($TERM_PREFIX, $code)}"><xsl:value-of select="$term"/></a>
            <xsl:text> </xsl:text>
         </span>
         <xsl:copy-of select="$description"/>
         <xsl:if test="$link != ''">
            <xsl:text> See: </xsl:text>
            <xsl:call-template name="PrintURI">
               <xsl:with-param name="uri" select="$link"/>
            </xsl:call-template>
            <xsl:text>.</xsl:text>
         </xsl:if>
      </p>
   </xsl:template>

   <!--
     Prints out a reference to a term in the glossary section.
     Param(s):
            code (String) required
              Unique ID of glossary term
            term (String) optional
              Glossary term
     -->
   <xsl:template name="PrintGlossaryTermRef">
      <xsl:param name="code"/>
      <xsl:param name="term"/>

      <xsl:choose>
         <xsl:when test="$code !='' and normalize-space(translate($printGlossary,'TRUE','true'))='true'">
            <a title="Look up '{$term}' in glossary" href="#{concat($TERM_PREFIX, $code)}">
               <xsl:choose>
                  <xsl:when test="$term!=''">
                     <xsl:value-of select="$term"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:text>[term]</xsl:text>
                  </xsl:otherwise>
               </xsl:choose>
            </a>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$term"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

</xsl:stylesheet>