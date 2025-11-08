<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!--
  XS3P Rendering Module: UI Components
  This module contains reusable UI component templates.
-->
<xsl:stylesheet
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns="http://www.w3.org/1999/xhtml"
 xmlns:html="http://www.w3.org/1999/xhtml"
 xmlns:exslt="http://exslt.org/common"
 version="1.0">

   <!-- Dependencies -->
   <xsl:include href="../core/constants.xsl"/>

   <!-- ******** Table to Definition List Converter ******** -->

   <xsl:template match="@*|node()" mode="table_to_dl">
      <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="table_to_dl"/>
      </xsl:copy>
   </xsl:template>

   <xsl:template match="html:table" mode="table_to_dl">
      <dl class="dl-horizontal">
         <xsl:apply-templates mode="table_to_dl"/>
      </dl>
   </xsl:template>

    <xsl:template match="html:tbody | html:thead | html:tr" mode="table_to_dl">
      <xsl:apply-templates mode="table_to_dl"/>
   </xsl:template>

   <xsl:template match="html:td | html:th" mode="table_to_dl">
      <xsl:variable name="class"><xsl:if test="local-name() = 'th'">header</xsl:if></xsl:variable>
      <xsl:choose>
         <xsl:when test="not(preceding-sibling::*[local-name() = 'td'] or preceding-sibling::*[local-name() = 'th'])">
            <dt class="{$class}"><xsl:apply-templates mode="table_to_dl"/></dt>
         </xsl:when>
         <xsl:otherwise>
            <dd class="{$class}"><xsl:apply-templates mode="table_to_dl"/></dd>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- ******** UI Component Templates ******** -->

   <!--
     Creates a box that can be opened and closed, such
     that the contents can be hidden away until a button
     is pressed.
     Param(s):
            id (String) required
              Unique ID of the 'div' box
            caption (String) required
              Text describing the contents of the box;
              it will always be shown even when the box
              is closed
            contents (String) required
              Contents of box, which may appear and disappear
              with the press of a button.
            anchor (String) optional
              Anchor, e.g. <a id="...", for this box
            styleClass (String) optional
              Additional CSS class for the entire collapseable box
            isOpened (String) optional
              Set to true if initially opened, and
              false if initially closed
     -->
   <xsl:template name="CollapseableBox">
      <xsl:param name="id"/>
      <xsl:param name="caption"/>
      <xsl:param name="help"/>
      <xsl:param name="contents"/>
      <xsl:param name="anchor"/>
      <xsl:param name="styleClass"/>
      <xsl:param name="isOpened">false</xsl:param>
      <xsl:param name="omitPanelContainer">false</xsl:param>
      <xsl:param name="containsCode">true</xsl:param>

      <xsl:variable name="buttonID" select="concat($id, '_button')"/>
      <xsl:variable name="panelContentClass">
         <xsl:choose>
            <xsl:when test="normalize-space(translate($isOpened,'TRUE','true'))='true'">
               <xsl:text>panel-collapse collapse in</xsl:text>
            </xsl:when>
            <xsl:otherwise>
               <xsl:text>panel-collapse collapse</xsl:text>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="panelTitleClass">
         <xsl:choose>
            <xsl:when test="normalize-space(translate($isOpened,'TRUE','true'))='true'">
               <xsl:text>xs3p-panel-title</xsl:text>
            </xsl:when>
            <xsl:otherwise>
               <xsl:text>xs3p-panel-title collapsed</xsl:text>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <div class="panel-group" id="{$id}-{$anchor}-panel-group">
      <div class="panel panel-default">
         <div class="panel-heading">
            <!-- Box Title -->
            <h4 class="panel-title">
               <a class="{$panelTitleClass}" data-toggle="collapse" data-parent="#{$id}-{$anchor}-panel-group" href="#{$id}-{$anchor}-collapse">
                  <xsl:value-of select="$caption"/>
               </a>
               <xsl:if test="$help != ''">
                  <span class="pull-right xs3p-panel-help">
                     <button type="button" class="btn btn-doc" data-container="body" data-toggle="popover" data-placement="left" data-html="true" data-content="{$help}">
                     <span class="glyphicon glyphicon-question-sign"><xsl:text> </xsl:text></span>
                     </button>
                  </span>
               </xsl:if>
            </h4>
         </div>

         <!-- Box Contents -->
         <xsl:choose>
            <xsl:when test="normalize-space(translate($omitPanelContainer,'TRUE','true'))='true'">
               <div id="{$id}-{$anchor}-collapse" class="{$panelContentClass}">
                  <xsl:copy-of select="$contents"/>
               </div>
            </xsl:when>
            <xsl:otherwise>
               <div id="{$id}-{$anchor}-collapse" class="{$panelContentClass}">
                  <div class="panel-body">
                     <xsl:choose>
                        <xsl:when test="not(normalize-space($contents))">
                          No documentation provided.
                        </xsl:when>
                        <xsl:when test="normalize-space(translate($containsCode,'TRUE','true'))='true'">
                           <pre class="codehilite">
                              <xsl:copy-of select="$contents"/>
                           </pre>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:copy-of select="$contents"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </div>
               </div>
            </xsl:otherwise>
         </xsl:choose>
      </div>
      </div>
   </xsl:template>

   <xsl:template name="AnnotationBlock">
      <xsl:param name="id"/>
      <xsl:param name="caption"/>
      <xsl:param name="contents"/>
      <xsl:param name="containsCode">true</xsl:param>
      <xsl:if test="normalize-space($contents)">
        <dl class="dl-horizontal">
          <dt><xsl:value-of select="$caption"/></dt>
          <dd>
            <xsl:choose>
             <!--  <xsl:when test="not(normalize-space($contents))">
                No documentation provided.
              </xsl:when> -->
              <xsl:when test="normalize-space(translate($containsCode,'TRUE','true'))='true'">
                 <pre class="codehilite">
                    <xsl:copy-of select="$contents"/>
                 </pre>
              </xsl:when>
              <xsl:otherwise>
                 <xsl:copy-of select="$contents"/>
              </xsl:otherwise>
           </xsl:choose>
          </dd>
        </dl>
      </xsl:if>
   </xsl:template>

   <xsl:template name="DLBlock">
      <xsl:param name="id"/>
      <xsl:param name="caption"/>
      <xsl:param name="contents"/>
      <xsl:if test="normalize-space($contents) != ''">
         <xsl:if test="normalize-space($caption) != ''">
            <h4><xsl:copy-of select="$caption"/>:</h4>
         </xsl:if>
        <xsl:copy-of select="$contents"/>
      </xsl:if>
   </xsl:template>

</xsl:stylesheet>