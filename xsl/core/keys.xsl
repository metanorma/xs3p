<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xsd="http://www.w3.org/2001/XMLSchema"
 version="1.0">

   <!-- ******** Keys ******** -->

   <xsl:key name="type" match="/xsd:schema/xsd:complexType | /xsd:schema/xsd:simpleType | /xsd:schema/xsd:redefine/xsd:complexType | /xsd:schema/xsd:redefine/xsd:simpleType" use="@name" />
   <xsl:key name="complexType" match="/xsd:schema/xsd:complexType | /xsd:schema/xsd:redefine/xsd:complexType" use="@name" />
   <xsl:key name="simpleType" match="/xsd:schema/xsd:simpleType | /xsd:schema/xsd:redefine/xsd:simpleType" use="@name" />
   <xsl:key name="attributeGroup" match="/xsd:schema/xsd:attributeGroup | /xsd:schema/xsd:redefine/xsd:attributeGroup" use="@name" />
   <xsl:key name="group" match="/xsd:schema/xsd:group | /xsd:schema/xsd:redefine/xsd:group" use="@name" />
   <xsl:key name="attribute" match="/xsd:schema/xsd:attribute" use="@name" />
   <xsl:key name="element" match="/xsd:schema/xsd:element" use="@name" />

</xsl:stylesheet>