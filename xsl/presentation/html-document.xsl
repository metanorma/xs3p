<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!--
  XS3P Presentation Module: HTML Document Structure
  This module generates the main HTML document structure and orchestrates all components.
  This is the top-level presentation layer that ties everything together.
-->
<xsl:stylesheet
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns="http://www.w3.org/1999/xhtml"
 xmlns:xsd="http://www.w3.org/2001/XMLSchema"
 xmlns:exslt="http://exslt.org/common"
 version="1.0">

   <!-- Dependencies: ALL modules (this orchestrates everything) -->
   <xsl:include href="../core/constants.xsl"/>
   <xsl:include href="../core/parameters.xsl"/>
   <xsl:include href="../utils/references.xsl"/>
   <xsl:include href="../utils/common-helpers.xsl"/>
   <xsl:include href="../renderers/glossary.xsl"/>
   <xsl:include href="../generators/hierarchy-tables.xsl"/>
   <xsl:include href="../generators/properties-tables.xsl"/>
   <xsl:include href="../generators/schema-components.xsl"/>
   <xsl:include href="css-styles.xsl"/>
   <xsl:include href="javascript.xsl"/>

   <!--
     Main template that starts the process
     -->
   <xsl:template match="/xsd:schema">
      <!-- Check that links file is provided if searching external
           schemas for components. -->
      <xsl:if test="$linksFile='' and (normalize-space(translate($searchIncludedSchemas, 'TRUE', 'true'))='true' or normalize-space(translate($searchImportedSchemas, 'TRUE', 'true'))='true')">
         <xsl:call-template name="HandleError">
            <xsl:with-param name="isTerminating">true</xsl:with-param>
            <xsl:with-param name="errorMsg">
'linksFile' variable must be provided if either
'searchIncludedSchemas' or 'searchImportedSchemas' is true.
            </xsl:with-param>
         </xsl:call-template>
      </xsl:if>

      <!-- Get title of document -->
      <xsl:variable name="actualTitle">
         <xsl:choose>
            <xsl:when test="$title != ''">
               <xsl:value-of select="$title"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$DEFAULT_TITLE"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <html>
         <head>
            <!-- Set title bar -->
            <title><xsl:value-of select="$actualTitle"/></title>

            <!-- Set content type -->
            <meta charset="UTF-8"/>

            <!-- Set base URL to use in working out relative paths -->
            <xsl:if test="$baseURL != ''">
               <xsl:element name="base">
                  <xsl:attribute name="href"><xsl:value-of select="$baseURL"/></xsl:attribute>
               </xsl:element>
            </xsl:if>

            <!-- CSS included here, JS at end of body. -->
            <link href="{$bootstrapURL}/css/bootstrap.min.css" rel="stylesheet"/>

            <!-- Set CSS styles -->
            <style type="text/css">
               <xsl:choose>
                  <!-- Use external CSS stylesheet -->
                  <xsl:when test="$externalCSSURL != ''">
                     <xsl:text>
@import url(</xsl:text><xsl:value-of select="$externalCSSURL"/><xsl:text>);
</xsl:text>
                  </xsl:when>
                  <!-- Use internal CSS styles -->
                  <xsl:otherwise>
                     <xsl:call-template name="DocumentCSSStyles"/>
                  </xsl:otherwise>
               </xsl:choose>
            </style>


            <script src="{$jQueryURL}">
               //Import JQuery, required for Bootstrap
            </script>

            <script src="{$bootstrapURL}/js/bootstrap.min.js">
               // Import Bootstrap JS code
            </script>

            <script src="https://cdnjs.cloudflare.com/ajax/libs/pagedown/1.0/Markdown.Converter.js">
              // Import Markdown converter for comments processing
            </script>

         </head>

         <body lang="en" xml:lang="en">
            <div class="title-section">
               <div id="toggle">
                  <span>&lt;</span><!-- &#x2022; -->
               </div>

         <!-- Note: some indentation resets in order to keep a minimum diff readability. -->

            <!-- Hidden documentation snippets for display in the popup -->
            <xsl:apply-templates select="." mode="hiddendoc"/>

            <!-- Title -->
            <h1><a id="top"><xsl:value-of select="$actualTitle"/></a></h1>

            <!-- Section: Schema Document Properties -->
            <section id="SectionSchemaProperties">
               <h2><a id="SchemaProperties">Schema Document Properties</a></h2>
               <!-- Sub-section: Properties table -->
               <xsl:apply-templates select="." mode="properties"/>
               <!-- Sub-section: Namespace Legend -->
               <!--<h3>Declared Namespaces</h3>-->
               <xsl:apply-templates select="." mode="namespaces"/>
               <!-- Sub-section: Schema Component Representation table -->
               <xsl:call-template name="SchemaComponentTable">
                  <xsl:with-param name="component" select="."/>
               </xsl:call-template>
               <xsl:call-template name="SectionFooter"/>
            </section>

             <!-- Section: Redefined Schema Components -->
            <xsl:if test="xsd:redefine">
               <h2><a id="Redefinitions">Redefined Schema Components</a></h2>
               <xsl:apply-templates select="xsd:redefine/xsd:simpleType | xsd:redefine/xsd:complexType | xsd:redefine/xsd:attributeGroup | xsd:redefine/xsd:group" mode="topSection"/>
            </xsl:if>

               <!-- Sections: Top-level Schema Components -->
               <xsl:choose>
                  <!-- Sort schema components -->
                  <xsl:when test="normalize-space(translate($sortByComponent,'TRUE','true'))='true'">

                     <!-- Declarations -->
                     <xsl:if test="xsd:attribute">
                        <section id="SectionSchemaAttributes">
                        <h2><a id="SchemaAttributes">Attributes</a></h2> <!-- Global Declarations -->
                        <xsl:apply-templates select="xsd:attribute" mode="topSection">
                           <xsl:sort select="local-name(.)" order="ascending"/>
                           <xsl:sort select="@name" order="ascending"/>
                        </xsl:apply-templates>
                        </section>
                     </xsl:if>
                     <xsl:if test="xsd:element">
                        <section id="SectionSchemaElements">
                        <h2><a id="SchemaElements">Elements</a></h2> <!-- Global Declarations -->
                        <xsl:apply-templates select="xsd:element" mode="topSection">
                           <xsl:sort select="local-name(.)" order="ascending"/>
                           <xsl:sort select="@name" order="ascending"/>
                        </xsl:apply-templates>
                        </section>
                     </xsl:if>
                     <!-- Definitions -->
                     <xsl:if test="xsd:complexType">
                        <section id="SectionSchemaComplexTypes">
                           <h2><a id="SchemaComplexTypes">Complex Types</a></h2> <!-- Global Definitions -->
                           <xsl:apply-templates select="xsd:complexType" mode="topSection">
                              <xsl:sort select="local-name(.)" order="ascending"/>
                              <xsl:sort select="@name" order="ascending"/>
                           </xsl:apply-templates>
                        </section>
                     </xsl:if>
                     <xsl:if test="xsd:group">
                        <section id="SectionSchemaGroups">
                           <h2><a id="SchemaGroups">Groups</a></h2> <!-- Global Definitions -->
                           <xsl:apply-templates select="xsd:group" mode="topSection">
                              <xsl:sort select="local-name(.)" order="ascending"/>
                              <xsl:sort select="@name" order="ascending"/>
                           </xsl:apply-templates>
                        </section>
                     </xsl:if>
                     <xsl:if test="xsd:notation">
                        <section id="SectionSchemaNotations">
                           <h2><a id="SchemaNotations">Notations</a></h2> <!-- Global Definitions -->
                           <xsl:apply-templates select="xsd:notation" mode="topSection">
                              <xsl:sort select="local-name(.)" order="ascending"/>
                              <xsl:sort select="@name" order="ascending"/>
                           </xsl:apply-templates>
                        </section>
                     </xsl:if>
                     <xsl:if test="xsd:simpleType">
                        <section id="SectionSchemaSimpleTypes">
                           <h2><a id="SchemaSimpleTypes">Types</a></h2> <!-- Global Definitions -->
                           <xsl:apply-templates select="xsd:simpleType" mode="topSection">
                              <xsl:sort select="local-name(.)" order="ascending"/>
                              <xsl:sort select="@name" order="ascending"/>
                           </xsl:apply-templates>
                        </section>
                     </xsl:if>
                     <xsl:if test="xsd:attributeGroup">
                        <section id="SectionSchemaAttributeGroups">
                           <h2><a id="SchemaAttributeGroups">Attribute Groups</a></h2> <!-- Global Definitions -->
                           <xsl:apply-templates select="xsd:attributeGroup" mode="topSection">
                              <xsl:sort select="local-name(.)" order="ascending"/>
                              <xsl:sort select="@name" order="ascending"/>
                           </xsl:apply-templates>
                        </section>
                     </xsl:if>
                  </xsl:when>
                  <!-- Display schema components as they occur -->
                  <xsl:otherwise>
                     <h2><a id="SchemaComponents">Global Schema Components</a></h2>
                     <xsl:apply-templates select="xsd:attribute | xsd:attributeGroup | xsd:complexType | xsd:element | xsd:group | xsd:notation | xsd:simpleType" mode="topSection"/>
                  </xsl:otherwise>
               </xsl:choose>

               <!-- Section: Glossary -->
               <xsl:if test="normalize-space(translate($printGlossary,'TRUE','true'))='true'">
                  <div id="glossary">
                     <h2><a id="Glossary">Glossary</a></h2>
                     <xsl:call-template name="Glossary"/>
                     <xsl:call-template name="SectionFooter"/>
                  </div>
               </xsl:if>

               <!-- Document Footer -->
               <p class="footer">
                  <xsl:text>Generated by </xsl:text>
                  <a href="https://github.com/unitsml/schemas/blob/master/xsl/xs3p.xsl">xs3p</a> (fork of <a href="http://github.com/bitfehler/xs3p">xs3p</a>)
                  <xsl:text>. Last Modified: </xsl:text>
                  <xsl:call-template name="PrintJSCode">
                     <xsl:with-param name="code">document.write(document.lastModified);</xsl:with-param>
                  </xsl:call-template>
               </p>


            </div>
            <br/>

            <nav>
               <div id="toc">
                  <xsl:apply-templates select="." mode="toc"/>
               </div>
            </nav>

            <!-- TOC toggle animation script -->
            <xsl:call-template name="TOCToggleScript"/>

            <!-- Bootstrap initialization and UI behavior script -->
            <xsl:call-template name="BootstrapInitScript"/>
         </body>
         <xsl:if test="2 = 3">
            <body data-spy="scroll" data-target=".xs3p-sidebar" data-offset="65">

               <div class="navbar navbar-fixed-top navbar-inverse" role="navigation">
                  <div class="container">
                     <div class="navbar-header">
                         <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                            <span class="sr-only">Toggle navigation</span>
                            <span class="icon-bar"><xsl:text> </xsl:text></span>
                            <span class="icon-bar"><xsl:text> </xsl:text></span>
                            <span class="icon-bar"><xsl:text> </xsl:text></span>
                         </button>
                         <a class="navbar-brand xs3p-navbar-title"><xsl:value-of select="$actualTitle"/></a>
                     </div>
                  </div>
               </div>
               <div class="container-fluid">
                  <div class="row">
                     <!-- <div class="col-md-3" id="menu-cols">
                        <div class="xs3p-sidebar hidden-print" role="complementary">
                           <xsl:apply-templates select="." mode="toc"/>
                        </div>
                     </div> -->


                    <div class="col-md-9 content" role="main" id="xs3p-content">





                     </div>
                  </div>
               </div>



            </body>
         </xsl:if>
      </html>
   </xsl:template>

   <!--
     Prints out the section for a top-level schema component.
     -->
   <xsl:template match="xsd:*[@name]" mode="topSection">
      <xsl:variable name="componentID">
         <xsl:call-template name="GetComponentID">
            <xsl:with-param name="component" select="."/>
         </xsl:call-template>
      </xsl:variable>

      <xsl:call-template name="ComponentSectionHeader">
         <xsl:with-param name="component" select="."/>
      </xsl:call-template>

      <xsl:if test="local-name() = 'element'">
         <object data="diagrams/{@name}.svg" type="image/svg+xml"></object>
      </xsl:if>

      <!-- Hierarchy table (for types and elements) -->
      <xsl:apply-templates select="." mode="hierarchy"/>

      <!-- Properties table -->
      <xsl:apply-templates select="." mode="properties"/>

      <!-- XML Instance Representation table -->
      <xsl:call-template name="SampleInstanceTable">
         <xsl:with-param name="component" select="."/>
      </xsl:call-template>

      <!-- Schema Component Representation table -->
      <xsl:call-template name="SchemaComponentTable">
         <xsl:with-param name="component" select="."/>
      </xsl:call-template>

      <!-- Footer -->
      <xsl:call-template name="SectionFooter"/>
   </xsl:template>

   <!--
     Prints out the section header of a top-level schema component.
     Param(s):
            component (Node) required
              Top-level schema component
     -->
   <xsl:template name="ComponentSectionHeader">
      <xsl:param name="component"/>

      <xsl:variable name="componentID">
         <xsl:call-template name="GetComponentID">
            <xsl:with-param name="component" select="$component"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="componentDescription">
         <xsl:call-template name="GetComponentDescription">
            <xsl:with-param name="component" select="$component"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="componentTermRef">
         <xsl:call-template name="GetComponentTermRef">
            <xsl:with-param name="component" select="$component"/>
         </xsl:call-template>
      </xsl:variable>

      <h3 class="xs3p-subsection-heading">
         <!-- Description -->
         <xsl:choose>
            <xsl:when test="$componentTermRef != ''">
               <xsl:call-template name="PrintGlossaryTermRef">
                  <xsl:with-param name="code" select="$componentTermRef"/>
                  <xsl:with-param name="term" select="$componentDescription"/>
               </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$componentDescription"/>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:text>: </xsl:text>
         <!-- Name -->
         <!-- <a id="{$componentID}" class="name" data-html="true" data-placement="bottom" data-toggle="tooltip" title="Schema component name."> -->
         <a id="{$componentID}"/>
            <strong><xsl:value-of select="$component/@name"/></strong>
         <!-- </a> -->
      </h3>
   </xsl:template>

   <!--
     Prints out footer for top-level sections.
     -->
   <xsl:template name="SectionFooter">
      <!-- Link to top of page-->
      <div style="text-align: right; clear: both;"><a href="#top" title="Go to top of page"><span class="glyphicon glyphicon-chevron-up"><xsl:text> </xsl:text></span></a></div>
      <hr/>
   </xsl:template>

   <!--
     Emtpy template to avoid unwanted output in 'hiddendoc' mode
     -->
   <xsl:template match="text()" mode="hiddendoc"/>

   <xsl:template match="xsd:element | xsd:attribute | xsd:simpleType" mode="hiddendoc">
      <xsl:if test="./xsd:annotation/xsd:documentation">
         <xsl:variable name="documentation">
            <xsl:for-each select="./xsd:annotation/xsd:documentation">
               <xsl:if test="position()!=1">
                  <xsl:text>,</xsl:text>
               </xsl:if>
               <xsl:value-of select="generate-id(.)"/>
            </xsl:for-each>
         </xsl:variable>
         <div class="modal fade {./@name}" id="{$documentation}-popup" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&#215;</button>
              <h4 class="modal-title" id="{$documentation}-label">
                <xsl:call-template name="GetComponentDescription">
                   <xsl:with-param name="component" select="."/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
                <xsl:choose>
                   <xsl:when test="./@name">
                      <xsl:value-of select="./@name"/>
                   </xsl:when>
                   <xsl:when test="./@ref">
                      <xsl:call-template name="GetRefName">
                         <xsl:with-param name="ref" select="./@ref"/>
                      </xsl:call-template>
                   </xsl:when>
                </xsl:choose>
              </h4>
            </div>
            <div class="modal-body">
              <xsl:call-template name="PrintAnnotation">
                 <xsl:with-param name="component" select="."/>
                 <xsl:with-param name="hidden" select="'true'"/>
              </xsl:call-template>
            </div>
         </div>
      </xsl:if>
   </xsl:template>

   <xsl:template match="xsd:element | xsd:attribute | xsd:simpleType" mode="hiddendoc_modal">
      <xsl:if test="./xsd:annotation/xsd:documentation">
         <xsl:variable name="documentation">
            <xsl:for-each select="./xsd:annotation/xsd:documentation">
               <xsl:if test="position()!=1">
                  <xsl:text>,</xsl:text>
               </xsl:if>
               <xsl:value-of select="generate-id(.)"/>
            </xsl:for-each>
         </xsl:variable>
         <div class="modal fade {./@name}" id="{$documentation}-popup" tabindex="-1" role="dialog" aria-hidden="true">
           <div class="modal-dialog unpre">
             <div class="modal-content">
               <div class="modal-header">
                 <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&#215;</button>
                 <h4 class="modal-title" id="{$documentation}-label">
                   <xsl:call-template name="GetComponentDescription">
                      <xsl:with-param name="component" select="."/>
                   </xsl:call-template>
                   <xsl:text> </xsl:text>
                   <xsl:choose>
                      <xsl:when test="./@name">
                         <xsl:value-of select="./@name"/>
                      </xsl:when>
                      <xsl:when test="./@ref">
                         <xsl:call-template name="GetRefName">
                            <xsl:with-param name="ref" select="./@ref"/>
                         </xsl:call-template>
                      </xsl:when>
                   </xsl:choose>
                 </h4>
               </div>
               <div class="modal-body">
                 <xsl:call-template name="PrintAnnotation">
                    <xsl:with-param name="component" select="."/>
                    <xsl:with-param name="hidden" select="'true'"/>
                 </xsl:call-template>
               </div>
               <div class="modal-footer">
                 <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
               </div>
             </div>
           </div>
         </div>
      </xsl:if>
   </xsl:template>

   <!--
     Print hidden documentation blocks for each documented element.
     Generates pop-up divs for 'annotation' elements, if required.
        Param(s):
            component (Node) required
                Schema component
     -->
   <xsl:template match="*" mode="hiddendoc">
      <xsl:apply-templates select="child::node()" mode="hiddendoc"/>
   </xsl:template>

</xsl:stylesheet>