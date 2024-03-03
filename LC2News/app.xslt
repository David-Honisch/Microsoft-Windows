<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:variable name="color" select='"red"' />
  <xsl:template match="/">
  <root>
  <xsl:template match="/">
  <html>
  <body>

  <fieldset>
    <legend>Drop a file</legend>
    <div id="inputKeyFile" class="btn btn-default">Drop a file</div>
    <br />
    <input type="text" name="inputFile" id="inputFile" value="test.csv" />
    <br />
    <button type="button" class="btn btn-default"
      onclick="execCMD('.\\resources\\plugins\\%plugin%\\launch.bat '+document.getElementById('inputFile').value, '%plugin%');">
      Start</button>
    <xsl:element name="div">
      <xsl:attribute name="id"><xsl:value-of select="/root/id" />_progress</xsl:attribute>
    </xsl:element>
  </fieldset>

  <!-- <div class="container-fluid cm-container-white"> -->
  <!-- <h2 style="margin-top:0;">Welcome to LetzteChance.Org</h2> -->
  <ul id="myTab" class="nav nav-tabs" role="tablist">
    <!-- <li role="presentation" class="active">
                  <a href="#appplugins" id="appplugins-tab" role="tab" data-toggle="tab" aria-controls="appplugins"
    aria-expanded="true">Application</a>
                </li> -->
    <xsl:element name="li">
      <xsl:attribute name="role">presentation</xsl:attribute>
                  <xsl:attribute name="class">active</xsl:attribute>
                  <xsl:element
        name="a">
        <xsl:attribute name="href">#<xsl:value-of select="/root/id" /></xsl:attribute>
                    <xsl:attribute
          name="id"><xsl:value-of select="/root/id" />-tab</xsl:attribute>
                    <xsl:attribute name="role">
      tab</xsl:attribute>
                    <xsl:attribute name="data-toggle">tab</xsl:attribute>
                    <xsl:attribute
          name="aria-expanded">true</xsl:attribute>
                    <xsl:attribute name="aria-controls">
          <xsl:value-of select="/root/id" />
        </xsl:attribute>
        <!-- <xsl:value-of select="/root/title" /> -->
                    <xsl:value-of select="/root/subtitle" /> updated on:<xsl:value-of select="/root/update" />
      </xsl:element>
    </xsl:element>
    <xsl:for-each select="root/urlslist/urls">
      <!-- <li role="presentation" class="active">
                  <a href="#appplugins" id="appplugins-tab" role="tab" data-toggle="tab" aria-controls="appplugins"
      aria-expanded="true">Application</a>
                </li> -->
                  <xsl:element name="li">
        <xsl:attribute name="role">presentation</xsl:attribute>
                    <xsl:element name="a">
          <xsl:attribute name="href">#<xsl:value-of select="id" /></xsl:attribute>
                      <xsl:attribute
            name="id"><xsl:value-of select="id" />-tab</xsl:attribute>
                      <xsl:attribute name="role">tab</xsl:attribute>
                      <xsl:attribute
            name="data-toggle">tab</xsl:attribute>
                      <xsl:attribute name="aria-expanded">false</xsl:attribute>
                      <xsl:attribute
            name="aria-controls">
            <xsl:value-of select="id" />
          </xsl:attribute>
                      <xsl:value-of select="title" />
        </xsl:element>
      </xsl:element>

    </xsl:for-each>
    <li role="presentation" class="dropdown">
      <a href="#" id="myTabDrop1" class="dropdown-toggle" data-toggle="dropdown"
        aria-controls="myTabDrop1-contents" aria-expanded="false">API <span class="caret"></span>
      </a>
      <ul class="dropdown-menu" role="menu" aria-labelledby="myTabDrop1" id="myTabDrop1-contents">
        <li ng-repeat="item in dropdowns">
          <a href="#>dropHelp" tabindex="-1" role="tab" id="dropdown1-tab" data-toggle="tab"
            aria-controls="dropHelp" onclick="alert('Updates coming soon....')">Help</a>
        </li>
      </ul>
    </li>
  </ul>
  <div id="myTabContent" class="tab-content">
  <!-- <div role="tabpanel" class="tab-pane fade active in" id="appplugins"
  aria-labelledby="appplugins-tab"> -->
  <xsl:element name="div">
  <xsl:attribute name="role">tab-panel</xsl:attribute>
  <xsl:attribute name="class">tab-pane fade active in</xsl:attribute>
  <xsl:attribute name="id"><xsl:value-of select="/root/id" /></xsl:attribute>
  <xsl:attribute name="aria-labelledby"><xsl:value-of select="/root/id" />-tab</xsl:attribute>

  <xsl:element name="div">
  <xsl:attribute name="class">panel panel-default</xsl:attribute>
  <xsl:element name="div">
  <xsl:attribute name="panel-heading">
    <xsl:value-of select="/root/title" />
  </xsl:attribute>
  <xsl:element name="div">
  <xsl:attribute name="class">panel-body demo-btn</xsl:attribute>
  <xsl:attribute name="style">min-height: 252px;</xsl:attribute>
  
  <xsl:copy-of select="/root/reftables/homecnt" />
  <!-- <xsl:value-of select="/root/reftables/homecnt" /> -->
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
  
  <!-- <xsl:element name="a">
                          <xsl:attribute name="href">#<xsl:value-of select="/root/id" /></xsl:attribute>
                          <xsl:value-of select="/root/title" />
                        </xsl:element> -->
</xsl:element>
</xsl:element>

</xsl:element>
</xsl:element>

<xsl:for-each select="root/urlslist/urls">
<xsl:variable name="v" select="id"/>
<xsl:param name="x" select="id"/> 
<!-- <xsl:value-of select="$x"></xsl:value-of> -->

  <xsl:element name="div">
    <xsl:attribute name="role">tabpanel</xsl:attribute>
                      <xsl:attribute name="class">tab-pane fade</xsl:attribute>
                      <xsl:attribute
      name="id">
      <xsl:value-of select="id" />
    </xsl:attribute>
                      <xsl:attribute name="aria-labelledby">
      <xsl:value-of select="id" />-tab</xsl:attribute>
                      <xsl:element name="div">
      <xsl:attribute name="class">panel panel-default</xsl:attribute>
                        <xsl:element name="div">
        <xsl:attribute name="panel-heading">
          <xsl:value-of select="title" />
        </xsl:attribute>
                          <xsl:element name="div">
          <xsl:attribute name="class">panel-body demo-btn</xsl:attribute>
                            <xsl:attribute name="style">min-height:252px;</xsl:attribute>
                            
                            
                            <table border="1" style="width:85%;">
                              <tr bgcolor="#9acd32">
                                <th>Updated</th>
                                <th>Title</th>
                                <th>Url</th>
                              </tr>
                              <xsl:for-each select="/root/x/urls">
                                <tr>
                                  <td>
                                    <xsl:value-of select="year" />
                                  </td>
                                  <td>
                                    <xsl:value-of select="title" />
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
                            
                            <!-- <xsl:element name="a">
            <xsl:attribute name="href">#<xsl:value-of select="id" /></xsl:attribute>
            <xsl:value-of select="id" />- <xsl:value-of select="title" />
          </xsl:element> -->
          
        </xsl:element>
      </xsl:element>

    </xsl:element>
  </xsl:element>

</xsl:for-each>


<!-- </xsl:element> -->


</div>


<!-- <div class="panel panel-default ">
              <div class="panel-heading ">
                <xsl:value-of select="root/title" />
                <xsl:value-of select="root/subttitle" />
                <xsl:value-of select="root/desc" />
              </div>
              <div class="panel-body demo-btn " style="min-height: 252px; ">
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

                        <xsl:element name="input">
                          <xsl:value-of select="url" />

                          <xsl:attribute name="type">button</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="title" />
                          </xsl:attribute>

                          <xsl:attribute name="onclick">
                            <xsl:value-of select="urltarget" />
                          </xsl:attribute>
                        </xsl:element>


                      </td>
                    </tr>
                  </xsl:for-each>
                </table>
              </div>
            </div> -->
<!-- </div> -->

</body>
</html>
</xsl:template>


</root>
</xsl:template>
</xsl:stylesheet>   