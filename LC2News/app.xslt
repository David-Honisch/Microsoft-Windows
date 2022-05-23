<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:variable name="color" select='"red"' />
  <xsl:template match="/">
    <root>
      <xsl:template match="/">
        <html>
          <body>

            <div class="panel panel-default ">
              <div class="panel-heading ">
                <xsl:value-of select="root/title" />
              </div>
              <div class="panel-body demo-btn " style="min-height: 252px; ">
                <!-- <h2>
                  <xsl:value-of select="root/title" />
                </h2> -->
                <!-- <center> -->
                <table border="1" style="width:85%;">
                  <tr bgcolor="#9acd32">
                    <th>Title</th>
                    <th>Url</th>
                  </tr>
                  <xsl:for-each select="root/urlslist/urls">
                    <tr>
                      <td>
                        <xsl:value-of select="title" />
                      </td>
                      <td>

                        <xsl:element name="a">
                          <!-- <xsl:attribute name="href">javascript:openBrowser('{$url}');</xsl:attribute> -->
                          <xsl:attribute name="href">javascript:openBrowser('<xsl:value-of select="url" />');</xsl:attribute>
                          <!-- <xsl:attribute name="onclick">alert('{$url}');</xsl:attribute> -->
                          <xsl:value-of select="url" />
                        </xsl:element>


                      </td>
                    </tr>
                  </xsl:for-each>
                </table>
              </div>
            </div>
            


            <!-- </center> -->
          </body>
        </html>
      </xsl:template>


    </root>
  </xsl:template>
</xsl:stylesheet>   