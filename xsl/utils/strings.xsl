<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!--
  XS3P Utility Module: String Manipulation
  This module contains templates for string operations.
-->
<xsl:stylesheet
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns="http://www.w3.org/1999/xhtml"
 xmlns:xsd="http://www.w3.org/2001/XMLSchema"
 version="1.0">

   <!--
     Repeatedly output a given parameter.
     Param(s):
            content (String) required
              The content to be output
            count (positive Integer) optional
              The number of times to output the content, default is one.
     -->
   <xsl:template name="Repeat">
      <xsl:param name="content"/>
      <xsl:param name="count" select="1"/>

      <xsl:if test="$count > 0">
         <xsl:value-of select="$content"/>
         <xsl:call-template name="Repeat">
            <xsl:with-param name="content" select="$content"/>
            <xsl:with-param name="count" select="$count - 1"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>

   <!--
     Translates occurrences of single and double quotes
     in a piece of text with single and double quote
     escape characters.
     Param(s):
            value (String) required
                Text to translate
     -->
   <xsl:template name="EscapeQuotes">
      <xsl:param name="value"/>

      <xsl:variable name="noSingleQuotes">
         <xsl:call-template name="TranslateStr">
            <xsl:with-param name="value" select="$value"/>
            <xsl:with-param name="strToReplace">'</xsl:with-param>
            <xsl:with-param name="replacementStr">\'</xsl:with-param>
         </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="noDoubleQuotes">
         <xsl:call-template name="TranslateStr">
            <xsl:with-param name="value" select="$noSingleQuotes"/>
            <xsl:with-param name="strToReplace">"</xsl:with-param>
            <xsl:with-param name="replacementStr">\"</xsl:with-param>
         </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="$noDoubleQuotes"/>
   </xsl:template>

   <!--
     Translates occurrences of a string
     in a piece of text with another string.
     Param(s):
            value (String) required
                Text to translate
            strToReplace (String) required
                String to be replaced
            replacementStr (String) required
                Replacement text
     -->
   <xsl:template name="TranslateStr">
      <xsl:param name="value"/>
      <xsl:param name="strToReplace"/>
      <xsl:param name="replacementStr"/>

      <xsl:if test="$value != ''">
         <xsl:variable name="beforeText" select="substring-before($value, $strToReplace)"/>
         <xsl:choose>
            <xsl:when test="$beforeText != ''">
               <xsl:value-of select="$beforeText"/>
               <xsl:value-of select="$replacementStr"/>
               <xsl:call-template name="TranslateStr">
                  <xsl:with-param name="value" select="substring-after($value, $strToReplace)"/>
                  <xsl:with-param name="strToReplace" select="$strToReplace"/>
                  <xsl:with-param name="replacementStr" select="$replacementStr"/>
               </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$value"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>
   </xsl:template>

   <!--
     Tokenises a whitespace-separated list of values, and
     displays them appropriately.
     Param(s):
            value (String) required
              Whitespace-separated list
            compType (String) optional
              Specify schema component type if values in list are
              schema components, so appropriate links can be provided.
            isInList (boolean) optional
              If true, place each value within 'li' tags.
              Assumes that this template is called within an HTML
              list element.
            separator (String) optional
              Character(s) to use to separate resulting values in list.
              Only used if 'isInList' is false.
              If none is provided, uses a space character, ' '.
            isFirst (boolean) optional
              If false, it's a recursive call from 'PrintWhitespaceList'.
            schemaLoc (String) optional
                Schema file containing this all model group;
                if in current schema, 'schemaLoc' is set to 'this'
     -->
   <xsl:template name="PrintWhitespaceList">
      <xsl:param name="value"/>
      <xsl:param name="compType"/>
      <xsl:param name="isInList">false</xsl:param>
      <xsl:param name="separator"/>
      <xsl:param name="isFirst">true</xsl:param>
      <xsl:param name="schemaLoc">this</xsl:param>

      <xsl:variable name="token" select="normalize-space(substring-before($value, ' '))"/>
      <xsl:choose>
         <xsl:when test="$token!=''">
            <!-- Whitespace found in value -->
            <!-- Print out token -->
            <xsl:call-template name="PrintWhitespaceListToken">
               <xsl:with-param name="token" select="$token"/>
               <xsl:with-param name="compType" select="$compType"/>
               <xsl:with-param name="isInList" select="$isInList"/>
               <xsl:with-param name="separator" select="$separator"/>
               <xsl:with-param name="isFirst" select="$isFirst"/>
               <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
            </xsl:call-template>
            <!-- Continue parsing -->
            <xsl:variable name="rest" select="normalize-space(substring-after($value, $token))"/>
            <xsl:if test="$rest!=''">
               <xsl:call-template name="PrintWhitespaceList">
                  <xsl:with-param name="value" select="$rest"/>
                  <xsl:with-param name="compType" select="$compType"/>
                  <xsl:with-param name="isInList" select="$isInList"/>
                  <xsl:with-param name="separator" select="$separator"/>
                  <xsl:with-param name="isFirst">false</xsl:with-param>
                  <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <!-- No more whitespaces  -->
            <!-- Print out one last token -->
            <xsl:if test="normalize-space($value)!=''">
               <xsl:call-template name="PrintWhitespaceListToken">
                  <xsl:with-param name="token" select="$value"/>
                  <xsl:with-param name="compType" select="$compType"/>
                  <xsl:with-param name="isInList" select="$isInList"/>
                  <xsl:with-param name="separator" select="$separator"/>
                  <xsl:with-param name="isFirst" select="$isFirst"/>
                  <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
               </xsl:call-template>
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--
     Helper template for 'PrintWhitespaceList' template,
     which prints out one token in the list.
     Param(s):
            token (String) required
              Token to be printed
            compType (String) optional
              Schema component type of token, if applicable.
            isInList (boolean) optional
              If true, place token within 'li' tags.
            separator (String) optional
              Character(s) use to separate one token from another.
              Only used if 'isInList' is false.
              If none is provided, uses a space character, ' '.
            isFirst (boolean) optional
              If true, token is the first value in the list.
            schemaLoc (String) optional
                Schema file containing this all model group;
                if in current schema, 'schemaLoc' is set to 'this'
     -->
   <xsl:template name="PrintWhitespaceListToken">
      <xsl:param name="token"/>
      <xsl:param name="compType"/>
      <xsl:param name="isInList">false</xsl:param>
      <xsl:param name="separator"/>
      <xsl:param name="isFirst">true</xsl:param>
      <xsl:param name="schemaLoc">this</xsl:param>

      <xsl:variable name="displayValue">
         <xsl:choose>
            <xsl:when test="$compType!=''">
               <xsl:call-template name="PrintCompRef">
                  <xsl:with-param name="ref" select="normalize-space($token)"/>
                  <xsl:with-param name="compType" select="$compType"/>
                  <xsl:with-param name="schemaLoc" select="$schemaLoc"/>
               </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="normalize-space($token)"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:choose>
         <xsl:when test="$isInList!='false'">
            <li>
               <xsl:copy-of select="$displayValue"/>
            </li>
         </xsl:when>
         <xsl:when test="$isFirst!='true'">
            <xsl:choose>
               <xsl:when test="$separator!=''">
                  <xsl:value-of select="$separator"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:text> </xsl:text>
               </xsl:otherwise>
            </xsl:choose>
            <xsl:copy-of select="$displayValue"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="$displayValue"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

</xsl:stylesheet>
