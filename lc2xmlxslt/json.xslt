<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes" />
    <xsl:template match="/">
        <people>
            <xsl:for-each select="//Person">
                <person>
                    <name>
                        <xsl:value-of select="name" />
                    </name>
                    <age>
                        <xsl:value-of select="id" />
                    </age>
                    <email>
                        <xsl:value-of select="email" />
                    </email>
                </person>
            </xsl:for-each>
        </people>
    </xsl:template>
</xsl:stylesheet>