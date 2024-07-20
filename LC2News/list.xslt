<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:variable name="color" select='"red"' />
  <xsl:variable name="axv" select="/*" />
  <xsl:variable name="footer">
    <hr/>
    <address>(c) by David Honisch</address>
  </xsl:variable>

  <xsl:template name="DoStuff">
    <xsl:param name="Input" />
    <xsl:for-each select="$Input">
      <!-- Do stuff with input -->
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="DoStuff2">
    <xsl:param name="Input" />
    <h1><xsl:value-of select="$Input/title" />:</h1>
    <table border="1" style="width:85%;">
      <tr bgcolor="#9acd32">
        <th>Updated</th>
        <th>Title</th>
        <th>Url</th>
      </tr>
    <xsl:for-each select="$Input">              
          <tr>
            <td>
              <xsl:value-of select="update" />
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
  </xsl:template>

  <xsl:template name="DropFileArea">
    <xsl:param name="Input" />
     <!-- <fieldset>
    <legend>Drop a file</legend>
    <div id="inputKeyFile" class="btn btn-default">Drop a file</div>
    <br />
    <input type="text" name="inputFile" id="inputFile" value="test.csv" />
    <br />
    <button type="button" class="btn btn-default"
      onclick="execCMD('.\\resources\\plugins\\%plugin%\\launch.bat
            '+document.getElementById('inputFile').value, '%plugin%');">
      Start</button>
    <xsl:element name="div">
      <xsl:attribute name="id"><xsl:value-of select="/root/id" />_progress</xsl:attribute>
    </xsl:element>
  </fieldset> -->
  </xsl:template>

  <xsl:template name="createTabsOLD">
    <xsl:param name="Input" />
    <xsl:for-each select="$Input">
      <!-- Do stuff with input -->
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="createTabHeaders">
    <xsl:param name="Input" />
  <xsl:for-each select="$Input">
      <!-- <xsl:for-each select="root/urlslist/urls"> -->
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

      <!-- </xsl:for-each> -->
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="createTabs">
    <xsl:param name="Input" />
    <!-- default -->
  Update:<xsl:value-of select="$Input/update" />   
  <table border="1" style="width:85%;">
      <tr bgcolor="#9acd32">
        <th>Title</th>
        <th>Updated</th>
        <th>Url</th>
      </tr>
      <xsl:for-each select="$Input">

        <!-- <xsl:for-each select="root/tabapp/urlslist/urls"> -->
        <tr>
          <td>
            <xsl:value-of select="title" />
          </td>
          <td>
            <xsl:value-of select="update" />
          </td>
          <td>

            <xsl:element name="a">

              <xsl:value-of select="url" />
              <!-- <xsl:attribute name="href">javascript:openBrowser('<xsl:value-of select="url"
              />');</xsl:attribute> -->
              <xsl:attribute name="href">
                <xsl:value-of select="urltarget" />
              </xsl:attribute>
            </xsl:element>


          </td>
        </tr>
      </xsl:for-each>
    </table>
    <!-- </xsl:for-each> -->
  </xsl:template>
  <!-- DoCreateTabBodies -->
  <xsl:template name="DoCreateTabBodies">
    <xsl:param name="Input" />
    <xsl:for-each select="$Input">
      <!-- <xsl:for-each select="root/urlslist/urls"> -->
        <xsl:variable name="x" select="id" />
        <xsl:variable name="xv" select="$Input/*" />
        <xsl:variable name="items" select="/root/categories/@x/url" />
        
          <xsl:element name="div">
        <xsl:attribute name="role">tabpanel</xsl:attribute>
            <xsl:attribute name="class">tab-pane fade</xsl:attribute>
            <xsl:attribute name="id">
          <xsl:value-of select="id" />
        </xsl:attribute>
                              <xsl:attribute name="aria-labelledby">
          <xsl:value-of select="id" />-tab</xsl:attribute>
                              <xsl:element name="div">
          <xsl:attribute name="class">panel panel-default</xsl:attribute>
                                <xsl:element name="div">
          <xsl:attribute name="panel-heading">
              <xsl:value-of select="title" />
            </xsl:attribute>                                  <xsl:element name="div">
          <xsl:attribute name="class">panel-body demo-btn</xsl:attribute>
          <xsl:attribute name="style">min-height:252px;</xsl:attribute>
                                    
            <!-- tables -->
            Update:<xsl:value-of select="update" />
            <xsl:choose>
            <xsl:when test="$x='catmenu_home'">
                <xsl:call-template name="DoStuff2">
                    <xsl:with-param name="Input" select="/root/categories/catmenu_home/url"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$x='catmenu_info'">
                <xsl:call-template name="DoStuff2">
                    <xsl:with-param name="Input" select="/root/categories/catmenu_info/url"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
           

            </xsl:element>
          </xsl:element>

        </xsl:element>
      </xsl:element>

      <!-- </xsl:for-each> -->
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="DoCreateULList">
    <xsl:param name="Input" />    
      <ul id="myTab" class="nav nav-tabs" role="tablist">
        <xsl:element name="li">
          <xsl:attribute name="role">presentation</xsl:attribute>
            <xsl:attribute name="class">active</xsl:attribute>
            <xsl:element name="a">
            <xsl:attribute name="href">#<xsl:value-of select="/root/id" /></xsl:attribute>
              <xsl:attribute
              name="id"><xsl:value-of select="/root/id" />-tab</xsl:attribute>
              <xsl:attribute name="role"> tab</xsl:attribute>
              <xsl:attribute name="data-toggle">tab</xsl:attribute>
              <xsl:attribute name="aria-expanded">true</xsl:attribute>
              <xsl:attribute name="aria-controls">
              <xsl:value-of select="/root/id" />
            </xsl:attribute>
            <!-- <xsl:value-of select="/root/title" /> -->
              <xsl:value-of
              select="/root/subtitle" />
          </xsl:element>
        </xsl:element>
        <!-- REPLACED -->
        <xsl:call-template name="createTabHeaders">
          <xsl:with-param name="Input" select="root/category/url" />
        </xsl:call-template>

        <!-- REPLACED -->
        <li role="presentation" class="dropdown">
          <a href="#" id="myTabDrop1" class="dropdown-toggle" data-toggle="dropdown"
            aria-controls="myTabDrop1-contents" aria-expanded="false">API <span class="caret"></span>
          </a>
          <ul class="dropdown-menu" role="menu" aria-labelledby="myTabDrop1"
            id="myTabDrop1-contents">
            <li ng-repeat="item in dropdowns">
              <a href="#>dropHelp" tabindex="-1" role="tab" id="dropdown1-tab"
                data-toggle="tab"
                aria-controls="dropHelp" onclick="alert('Updates coming soon....')">Help</a>
            </li>
          </ul>
        </li>
      </ul>
    
  </xsl:template>
  <!-- DoCreateTabContents -->
  <xsl:template name="DoCreateTabContents">
    <xsl:param name="Input" />
    <div id="myTabContent" class="tab-content">
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
<xsl:attribute  name="style">min-height: 252px;</xsl:attribute>

<!-- <xsl:copy-of  select="/root/reftables/homecnt" /> updated on:
<xsl:value-of  select="/root/update" /> -->
              <!-- <xsl:value-of select="/root/reftables/homecnt" /> -->
              <!-- <br/>debug 2 <xsl:value-of select="$Input" /> -->
              <xsl:call-template name="createTabs">
                <!-- <xsl:with-param name="Input" select="root/urlslist/urls" /> -->
                <xsl:with-param name="Input" select="$Input" />
              </xsl:call-template>
              <!-- REPLACED -->
              <!-- REPLACED -->
            </xsl:element>
          </xsl:element>

        </xsl:element>
      </xsl:element>
      <!-- REPLACED -->
      <xsl:call-template name="DoCreateTabBodies">
        <xsl:with-param name="Input2" select="root/urlslist/urls" />
        <xsl:with-param name="Input" select="$Input" />
      </xsl:call-template>
    </div>
  </xsl:template>

  <xsl:template match="/">
    <root>
      <xsl:template match="/">
        <html>
          <body>        
            <xsl:call-template name="DoCreateULList">
              <xsl:with-param name="Input" select="root/category/url" />
            </xsl:call-template>            
            <!-- contents -->
            <xsl:call-template name="DoCreateTabContents">
              <xsl:with-param name="Input" select="root/category/url" />
            </xsl:call-template>

            <xsl:copy-of select="$footer"/>
          </body>
        </html>
      </xsl:template>


    </root>
  </xsl:template>
</xsl:stylesheet>   