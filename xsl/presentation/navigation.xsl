<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!--
  XS3P Presentation Module: Navigation
  This module generates the table of contents sidebar and namespace tables.
-->
<xsl:stylesheet
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns="http://www.w3.org/1999/xhtml"
 xmlns:xsd="http://www.w3.org/2001/XMLSchema"
 xmlns:exslt="http://exslt.org/common"
 version="1.0">

   <!-- Dependencies -->
   <xsl:include href="../core/constants.xsl"/>
   <xsl:include href="../core/parameters.xsl"/>
   <xsl:include href="../utils/references.xsl"/>

   <!--
     Prints out the table of Declared Namespaces for the
     current schema.
     -->
   <xsl:template match="xsd:schema" mode="namespaces">
      <xsl:variable name="contents">
         <table class="table table-striped xs3p-in-panel-table">
            <thead>
               <tr>
                  <th>Prefix</th>
                  <th>Namespace</th>
               </tr>
            </thead>
            <tbody>
               <!-- Default namespace (no prefix) -->
               <xsl:if test="namespace::*[local-name(.)='']">
                  <xsl:variable name="ns" select="namespace::*[local-name(.)='']"/>
                  <tr>
                     <td>
                        <a id="{$NS_PREFIX}">Default namespace</a>
                     </td>
                     <td>
                        <xsl:choose>
                           <xsl:when test="/xsd:schema/@targetNamespace and $ns=normalize-space(/xsd:schema/@targetNamespace)">
                              <span class="targetNS">
                                 <xsl:value-of select="$ns"/>
                              </span>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="$ns"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </td>
                  </tr>
               </xsl:if>
               <!-- Namespaces with prefixes -->
               <xsl:for-each select="namespace::*[local-name(.)!='']">
                  <xsl:variable name="prefix" select="local-name(.)"/>
                  <xsl:variable name="ns" select="."/>
                  <tr>
                     <td>
                        <a id="{concat($NS_PREFIX, $prefix)}">
                           <xsl:value-of select="$prefix"/>
                        </a>
                     </td>
                     <td>
                        <xsl:choose>
                           <xsl:when test="/xsd:schema/@targetNamespace and $ns=normalize-space(/xsd:schema/@targetNamespace)">
                              <span class="targetNS">
                                 <xsl:value-of select="$ns"/>
                              </span>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="$ns"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </td>
                  </tr>
               </xsl:for-each>
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
               <xsl:with-param name="anchor">declared-namespaces</xsl:with-param>
               <xsl:with-param name="styleClass">sample</xsl:with-param>
               <xsl:with-param name="caption">Declared Namespaces</xsl:with-param>
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
               <xsl:with-param name="caption">Declared Namespaces</xsl:with-param>
               <xsl:with-param name="contents">
                  <xsl:apply-templates select="exslt:node-set($contents)" mode="table_to_dl"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--
     Prints out the Table of Contents.
     -->
   <xsl:template match="xsd:schema" mode="toc">
      <ul class="nav nav-list xs3p-sidenav">
         <!-- Section: Schema Document Properties -->
         <li>
            <strong><a href="#SchemaProperties">Schema Document Properties</a></strong>
         </li>

         <!-- Section: Redefined Schema Components -->
         <xsl:if test="xsd:redefine">
            <li>
               <strong><a href="#Redefinitions">Redefined Schema Components</a></strong>
            </li>
         </xsl:if>

         <!-- Sections: Top-level Schema Components -->
         <xsl:choose>
            <!-- Sort schema components -->
            <xsl:when test="normalize-space(translate($sortByComponent,'TRUE','true'))='true'">
               <!-- Declarations -->
               <xsl:if test="xsd:attribute">
                  <!-- Global Declarations -->
                  <ul class="nav nav-list nav-list-attributes">
                     <li><strong><a href="#SchemaAttributes">Attributes</a></strong></li>
                     <xsl:apply-templates select="xsd:attribute" mode="toc">
                        <xsl:sort select="local-name(.)" order="ascending"/>
                        <xsl:sort select="@name" order="ascending"/>
                     </xsl:apply-templates>
                  </ul>
               </xsl:if>
               <xsl:if test="xsd:element">
                  <!-- Global Declarations -->
                  <ul class="nav nav-list nav-list-elements">
                     <li><strong><a href="#SchemaElements">Elements </a></strong></li>
                     <xsl:apply-templates select="xsd:element" mode="toc">
                        <xsl:sort select="local-name(.)" order="ascending"/>
                        <xsl:sort select="@name" order="ascending"/>
                     </xsl:apply-templates>
                  </ul>
               </xsl:if>
               <!-- Definitions -->
               <xsl:if test="xsd:complexType">
                  <li><strong><a href="#SchemaComplexTypes">Complex Types </a></strong></li> <!-- Global Definitions -->
                  <xsl:apply-templates select="xsd:complexType" mode="toc">
                     <xsl:sort select="local-name(.)" order="ascending"/>
                     <xsl:sort select="@name" order="ascending"/>
                  </xsl:apply-templates>
               </xsl:if>
               <xsl:if test="xsd:group">
                  <li><strong><a href="#SchemaGroups">Groups </a></strong></li> <!-- Global Definitions -->
                  <xsl:apply-templates select="xsd:group" mode="toc">
                     <xsl:sort select="local-name(.)" order="ascending"/>
                     <xsl:sort select="@name" order="ascending"/>
                  </xsl:apply-templates>
               </xsl:if>
               <xsl:if test="xsd:notation">
                  <li><strong><a href="#SchemaNotations">Notations </a></strong></li> <!-- Global Definitions -->
                  <xsl:apply-templates select="xsd:notation" mode="toc">
                     <xsl:sort select="local-name(.)" order="ascending"/>
                     <xsl:sort select="@name" order="ascending"/>
                  </xsl:apply-templates>
               </xsl:if>
               <xsl:if test="xsd:simpleType">
                  <li><strong><a href="#SchemaSimpleTypes">Types </a></strong></li> <!-- Global Definitions -->
                  <xsl:apply-templates select="xsd:simpleType" mode="toc">
                     <xsl:sort select="local-name(.)" order="ascending"/>
                     <xsl:sort select="@name" order="ascending"/>
                  </xsl:apply-templates>
               </xsl:if>
               <!--  	Attribute Groups  -->
               <xsl:if test="xsd:attributeGroup">
                  <li><strong><a href="#SchemaAttributeGroups">Attribute Groups</a></strong></li>
                  <xsl:apply-templates select="xsd:attributeGroup" mode="toc">
                     <xsl:sort select="local-name(.)" order="ascending"/>
                     <xsl:sort select="@name" order="ascending"/>
                  </xsl:apply-templates>
               </xsl:if>

            </xsl:when>
            <!-- Display schema components in order as they appear in schema -->
            <xsl:otherwise>
               <li><strong><a href="#SchemaComponents">Global Schema Components</a></strong></li>
               <xsl:apply-templates select="xsd:attribute | xsd:attributeGroup | xsd:complexType | xsd:element | xsd:group | xsd:notation | xsd:simpleType" mode="toc"/>
            </xsl:otherwise>
         </xsl:choose>

         <!-- Section: Glossary -->
         <xsl:if test="normalize-space(translate($printGlossary,'TRUE','true'))='true'">
            <li><strong><a href="#Glossary">Glossary</a></strong></li>
         </xsl:if>
      </ul>
   </xsl:template>

   <!--
     Prints out a link to a top-level schema component section in the
     Table of Contents.
     -->
   <xsl:template match="xsd:*[@name]" mode="toc">
      <xsl:variable name="componentID">
         <xsl:call-template name="GetComponentID">
            <xsl:with-param name="component" select="."/>
         </xsl:call-template>
      </xsl:variable>

      <li class="nav-sub-item">
         <a href="#{$componentID}">
            <xsl:variable name="componentDescription">
               <xsl:call-template name="GetComponentDescription">
                  <xsl:with-param name="component" select="."/>
                  <xsl:with-param name="nav" select="'true'"/>
               </xsl:call-template>
            </xsl:variable>
            <xsl:if test="normalize-space($componentDescription) != ''">
               <xsl:text>: </xsl:text>
            </xsl:if>
            <strong><xsl:value-of select="@name"/></strong>
         </a>
      </li>
   </xsl:template>

</xsl:stylesheet>