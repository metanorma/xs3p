<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!--
  XS3P Presentation Module: CSS Styles
  This module generates CSS stylesheets for the HTML documentation.
-->
<xsl:stylesheet
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns="http://www.w3.org/1999/xhtml"
 xmlns:xsd="http://www.w3.org/2001/XMLSchema"
 version="1.0">

   <!-- Dependencies -->
   <xsl:include href="../core/constants.xsl"/>
   <xsl:include href="../core/parameters.xsl"/>

   <!--
     CSS properties for the entire HTML document.
     -->

   <xsl:template name="DocumentCSSStyles">
      <xsl:text disable-output-escaping="yes">


nav, section {
  display: block; }

table {
  border-collapse: collapse;
  border-spacing: 0; }


/*dl {
  display: grid;
  grid-template-columns: max-content auto; }
  dl dt p, dl dd p {
    margin-top: 0; }
  dl dt {
    grid-column-start: 1; }
  dl dd {
    grid-column-start: 2; }
*/

body {
  margin-left: auto;
  margin-right: auto;
  max-width: 100%;
  font-size: 16px;
  font-weight: 300;
  line-height: 1.4em;
  color: -internal-root-color;
  background-color: #ffffff; }
  body main {
    margin: 0 3em 0 6em; }
  body main {
    margin: 0; }

/* HTML5 display-role reset for older browsers */
article, aside, details, figcaption, figure,
footer, header, hgroup, menu, nav, section {
  display: block; }

body {
  line-height: 1.3; }


body {
  margin-left: </xsl:text><xsl:value-of select="$nav-width"/><xsl:text>;
  margin-right: 2em; }

main {
  padding-left: 4em;
  padding-right: 2em; }

.title-section{
  padding-left: 4em;
  padding-top: 2em; }





h2 p {
  display: inline; }



/* Navigation*/
#toc {
  font-weight: 400; }
  #toc a {
   color: black;
   text-decoration-color: black; }
  #toc ul {
    margin: 0;
    padding: 0;
    list-style: none; }
    #toc ul li a {
      padding: 5px 10px; }
    #toc ul a {
      text-decoration: none;
      display: block; }
      #toc ul a:hover {
        box-shadow: none;
        color: black; }
  #toc .h2 {
    padding-left: 30px; }
  #toc .h3 {
    padding-left: 50px; }
  #toc .toc-active, #toc li:hover {
    background: #f7f7f7;
    box-shadow: inset -5px 0px 10px -5px #f7f7f7 !important; }
    #toc .toc-active a, #toc li:hover a {
      color: black; }
  @media print {
    #toc .toc-active, #toc li:hover {
      background: white;
      box-shadow: none !important; }
    #toc li:hover a {
      color: black; } }
  @media screen and (max-width: 768px) {
    #toc {
      padding: 0 1.5em;
      overflow: visible; } }
  #toc .toc-active,
  #toc li:hover {
    box-shadow: 0px 1px 0px 0px black !important;
    background: none; }
  #toc li:before {
    content: " ";
    display: none; }

nav {
  line-height: 1.2em; }
  @media screen and (min-width: 768px) {
    nav {
      position: fixed;
      top: 0;
      bottom: 0;
      left: 0;
      width: </xsl:text><xsl:value-of select="$nav-width"/><xsl:text>;
      font-size: 0.9em;
      overflow: auto;
      padding: 0 0 0 0px;
      background-color: #fefefe; } }
  @media print {
    nav {
      position: relative;
      width: auto;
      font-size: 0.9em;
      overflow: auto;
      padding: 0;
      margin-right: 0;
      background-color: white; } }
#toggle {
  margin-left: -4em;
  margin-top: -2em; }
  @media screen and (min-width: 768px) {
    #toggle {
      position: fixed;
      height: 100%;
      width: 20px;
      font-weight: bold;
      background-color: #d8e4ff;
      color: black !important;
      cursor: pointer;
      z-index: 100; }
      #toggle span {
        text-align: center;
        width: 100%;
        position: absolute;
        top: 50%;
        transform: translate(0, -50%); } }
  @media screen and (max-width: 768px) {
    #toggle {
      display: none; } }
  @media print {
    #toggle {
      display: none; } }
@media screen and (min-width: 768px) {
  .container {
    padding-left: 360px; }
  .rule.toc {
    display: none; }
  h1.toc-contents {
    margin-top: 1em; }
  ul#toc-list {
    padding: 0;
    margin: 0; } }


ul, ol {
  margin-left: 2em; }

#toc-list ul {
  margin-bottom: 0.25em; }

#toc-list ol li {
  list-style-type: none; }


/* XS3P specific CSS */
body {
    background-color: #FFF;

}

.nav &gt; li.active {
    background-color: #FFF;
}
.nav &gt; li &gt; a:hover {

    background-color: rgb(0,0,0, 0.05);
}

.nav-sub-item &gt; a {
    padding-left: 30px !important;
}


.nav-sub-item strong {
      font-weight: normal; }

//.nav-list-elements
.nav {
   //background-color: #efe;
   background-color: #e4ecff;
}

.xs3p-sidenav {
    //background-color: #efe;
    background-color: #e4ecff;
}

code {
    color: #333;
}

a.name {
    padding-top: 65px;
}

a:not([href]) {
   color:#1c476c;
}

a:not([href]):hover {
  text-decoration: none;
}


h3.xs3p-subsection-heading {
    margin-bottom: 30px;
}

section, #top {
    margin-top: -65px;
    padding-top: 65px;
}

pre {
    padding: 5px;
}

.xs3p-in-panel-table {
    margin-bottom: 0px;
}

.xs3p-collapse-button {
    font-size: 8pt;
}
.panel-heading .xs3p-panel-title:after {
    font-family: 'Glyphicons Halflings';
    content: "\e114";
    float: left;
    color: grey;
    margin-right: 10px;
}
.panel-heading .xs3p-panel-title.collapsed:after {
    content: "\e080";
}
.panel-info > .panel-heading .xs3p-panel-title:after {
    color: white;
}
.xs3p-panel-help {
    color: #888888;
    cursor: pointer;
}

.panel-group {
    margin-bottom: 20px;
}

.btn-doc {
    padding: 0px;
    border: 0px none;
    background: none repeat scroll 0% 0% transparent;
    line-height: 1;
    font-size: 12px;
}

.unpre {
    font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;
    font-size: 14px;
    white-space: normal;
    word-break: normal;
    word-wrap: normal;
}

.popover {
    max-width: 400px;
}

// Syntax highlighting
.codehilite .err {color: #FFF; background-color: #D2322D; font-weight: bold;} /* Error */
.codehilite .c   {color: #999;}
.codehilite .cs  {color: #999; font-style: italic;}
.codehilite .nt  {color: #2F6F9F;}
.codehilite .nn  {color: #39B3D7;}
.codehilite .na  {color: #47A447;}
.codehilite .s   {color: #D2322D;}
.codehilite a       {color: inherit !important; text-decoration: underline !important;}
.codehilite a:hover {opacity: 0.7 !important;}

dl {
  margin-bottom: 10px;
}

dt {
	font-weight: normal;

	margin-bottom: 10px;
}

dt.header{
	font-weight: 700;
}

.dl-horizontal dt {
	white-space: normal;
}

dd.header{
	font-weight: 700;
}

dd ul {
	margin-left: 0em;
}

.bs-callout {
   padding: 20px;
   padding-top: 10px;
   padding-bottom: 5px;
   margin: 20px 0;
   border: 1px solid #eee;
   border-left-width: 5px;
   border-radius: 3px;
}
.bs-callout-danger {
   border-left-color: #d9534f;
}
.bs-callout-warning {
   border-left-color: #f0ad4e;
}
.bs-callout-info {
   border-left-color: #5bc0de;
}
.bs-callout h4 {
   margin-top: 0;
   margin-bottom: 5px;
}
.bs-callout-danger h4 {
   color: #d9534f;
}
.bs-callout-warning h4 {
   color: #f0ad4e;
}
.bs-callout-info h4 {
   color: black;
   font-size: 11pt;
}


      </xsl:text>
   </xsl:template>


   <xsl:template name="DocumentCSSStyles_Old">
      <xsl:text disable-output-escaping="yes">

.container-fluid {
    padding: 15px 15px;
}

.xs3p-sidenav {
    padding-top: 10px;
    padding-bottom: 10px;
    background-color: #EEE;
    border-radius: 10px;
}

.xs3p-navbar-title {
    color: #FFF !important;
    font-weight: bold;
}

.xs3p-sidebar {
    position: static;
}

body {
   margin-left: 298px;
   margin-right: 2em;
}

nav {
   margin: 0;
   padding: 0;
   border: 0;
   font-size: 100%;
   vertical-align: baseline;
   display: block;
}



@media (min-width: 992px) {
    .xs3p-sidebar {
        position: fixed;
        top: 65px;
        width: 22%;
    }
}
</xsl:text>
   </xsl:template>

</xsl:stylesheet>