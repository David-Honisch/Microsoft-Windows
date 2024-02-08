<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:variable name="color" select='"red"' />
  <xsl:template match="/">
    <xsl:template match="/">
    <root>
      <html>
        <body>
          
            <div class="panel panel-default ">
              <div class="panel-heading ">
                <xsl:value-of select="root/tabapp/title" />
              </div>
              <div class="panel-body demo-btn " style="min-height: 252px; ">
                <!-- <h2>
                  <xsl:value-of select="root/title" />
                </h2> -->
                <!-- <center> -->
                <table border="1" style="width:85%;">
                  <tr bgcolor="#9acd32">
                    <th>Title</th>
                    <th>Updated</th>
                    <th>Url</th>
                  </tr>
                  <xsl:for-each select="root/tabapp/urlslist/urls">
                    <tr>
                      <td>
                        <xsl:value-of select="title" />
                      </td>
                      <td>
                        <xsl:value-of select="year" />
                      </td>
                      <td>

                        <xsl:element name="a">

                          <xsl:value-of select="url" />
                          <!-- <xsl:attribute name="href">javascript:openBrowser('<xsl:value-of select="url" />');</xsl:attribute> -->
                          <xsl:attribute name="href">
                            <xsl:value-of select="urltarget" />
                          </xsl:attribute>
                        </xsl:element>


                      </td>
                    </tr>
                  </xsl:for-each>
                </table>
              </div>
            </div>

          

          <!-- utils -->
          
            <div class="panel panel-default ">
              <div class="panel-heading ">
                <xsl:value-of select="root/tabutils/title" />
              </div>
              <div class="panel-body demo-btn " style="min-height: 252px; ">
                <!-- <h2>
                  <xsl:value-of select="root/title" />
                </h2> -->
                <!-- <center> -->
                <table border="1" style="width:85%;">
                  <tr bgcolor="#9acd32">
                    <th>Title</th>
                    <th>Updated</th>
                    <th>Url</th>
                  </tr>
                  <xsl:for-each select="root/tabutils/urlslist/urls">
                    <tr>
                      <td>
                        <xsl:value-of select="title" />
                      </td>
                      <td>
                        <xsl:value-of select="year" />
                      </td>
                      <td>

                        <xsl:element name="a">

                          <xsl:value-of select="url" />
                          <xsl:attribute name="href">
                            <xsl:value-of select="urltarget" />
                          </xsl:attribute>

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
    </root>
  </xsl:template>
</xsl:stylesheet>