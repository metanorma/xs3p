<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!--
  XS3P Presentation Module: JavaScript Code
  This module generates JavaScript code for the HTML documentation.
-->
<xsl:stylesheet
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns="http://www.w3.org/1999/xhtml"
 xmlns:xsd="http://www.w3.org/2001/XMLSchema"
 version="1.0">

   <!-- Dependencies -->
   <xsl:include href="../core/parameters.xsl"/>

   <!--
     Java Script code required by the entire HTML document.
     -->
   <xsl:template name="DocumentJSCode">
   </xsl:template>

   <!--
     Prints out JavaScript code.
     NOTE: Javascript code is placed within comments to make it
     work with current browsers. In strict XHTML, JavaScript code
     should be placed within CDATA sections. However, most
     browsers generate a syntax error if the page contains
     CDATA sections. Placing Javascript code within comments
     means that the code cannot contain two dashes.
     Param(s):
            code (Result Tree Fragment) required
                Javascript code
  -->
   <xsl:template name="PrintJSCode">
      <xsl:param name="code"/>

      <script type="text/javascript">
         <!-- If browsers start supporting CDATA sections,
              uncomment the following piece of code. -->
         <!-- <xsl:text disable-output-escaping="yes">
&lt;![CDATA[
</xsl:text> -->
         <!-- If browsers start supporting CDATA sections,
              remove the following piece of code. -->
         <xsl:text disable-output-escaping="yes">
&lt;!--
</xsl:text>

         <xsl:value-of select="$code" disable-output-escaping="yes"/>
         <!-- If browsers start supporting CDATA sections,
              remove the following piece of code. -->
         <xsl:text disable-output-escaping="yes">
// --&gt;
</xsl:text>
         <!-- If browsers start supporting CDATA sections,
              uncomment the following piece of code. -->
         <!-- <xsl:text disable-output-escaping="yes">
]]&gt;
</xsl:text> -->
      </script>
   </xsl:template>

   <!--
     Generates the TOC toggle animation script.
     This allows the navigation sidebar to be shown/hidden.
     -->
   <xsl:template name="TOCToggleScript">
      <script>
         //TOC toggle animation
         $('#toggle').on('click', function(){
            var duration = 400;
            if( $('nav').is(':visible') ) {
               $('nav').animate({ 'left': '-353px' }, duration, function(){
                  $('nav').hide();
               });
               $('body').animate({ 'margin-left': '0' }, duration);
               $('#toggle > span').text('&gt;');
            }
            else {
               $('nav').show();
               $('nav').animate({ 'left': '0px' }, duration);
               $('body').animate({ 'margin-left': '<xsl:value-of select="$nav-width"/>' }, duration);
               $('#toggle > span').text('&lt;');
            }
         });
      </script>
   </xsl:template>

   <!--
     Generates the Bootstrap initialization and UI behavior script.
     This handles tooltips, popovers, modals, markdown processing, and scrolling.
     -->
   <xsl:template name="BootstrapInitScript">
      <script>
            <xsl:text disable-output-escaping="yes">

            $(function () { $("[data-toggle='tooltip']").tooltip(); });
            $(function () { $("[data-toggle='popover']").popover({ trigger: "hover" }); });

            $(function () { $("[data-toggle='modal']").click(function() { return false; })});

            $(function () { $("[data-toggle='modal']").popover({ trigger: "hover", html: true,
content: function () {
    var targetId = $(this).attr('data-target');
    return $(targetId).html();
}}); });



            var c = new Markdown.Converter();
            $('.xs3p-doc').each(function(i, obj) {
               var rawDocID = '#' + $(this).attr('id') + '-raw';
               var indent = $(rawDocID).html().match("^\\n[\\t ]*");
               if (!(indent === null)) {
                  normalized = $(rawDocID).html().replace(new RegExp(indent[0], "gm"), "\n");
               } else {
                  normalized = $(rawDocID).html();
               }
               $(this).html(c.makeHtml(normalized));
               $(this).find('code,pre').each(function(i, block) {
                  $(this).html($(this).text());
               });
            });

            $(window).scroll(function() {
               if ($(".xs3p-sidebar").css("position") == "fixed" &amp;&amp; $(window).height() &lt; $(".xs3p-sidebar").height()) {
                  var perc = $(window).scrollTop() / $("#xs3p-content").height();
                  var overflow = $(".xs3p-sidebar").height() + 105 - $(window).height();
                  $(".xs3p-sidebar").css("top", (65 - Math.round(overflow * perc)) + "px");
               }
            });
            $(window).resize(function() {
               if ($(".xs3p-sidebar").css("position") == "fixed") {
                  $(".xs3p-sidebar").css("top", "65px");
               }
            });
            </xsl:text>
         </script>
   </xsl:template>

</xsl:stylesheet>