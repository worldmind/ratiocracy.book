<?xml version='1.0'?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:import
    href="/usr/share/xml/docbook/stylesheet/docbook-xsl-ns/html/chunk.xsl"/>

 <xsl:param name="chunker.output.encoding">UTF-8</xsl:param>
 <xsl:param name="toc.section.depth">5</xsl:param>
 <xsl:param name="generate.section.toc.level">4</xsl:param>
 <xsl:param name="chunk.first.sections">1</xsl:param>
 <xsl:param name="chunk.section.depth">5</xsl:param>
 <xsl:param name="base.dir">../ratiocracy.github.io/book/</xsl:param>
 <xsl:param name="use.id.as.filename">1</xsl:param>
 <xsl:param name="custom.css.source">/css/style.css</xsl:param>
 <xsl:template name="user.footer.navigation">

 </xsl:template>

</xsl:stylesheet>
