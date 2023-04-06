<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink">


  <xsl:template match="/">
    <xsl:apply-templates select="//abstractGroup"/>
  </xsl:template>


  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="abstractGroup">
      <xsl:apply-templates />
  </xsl:template>

  <!-- Template for the abstract element -->
  <xsl:template match="abstract">
    <!-- Create a new abstract element with the updated type attribute -->
    <abstract>
      <xsl:apply-templates select="@*|node()"/>
    </abstract>
  </xsl:template>

  <xsl:template match="abstract/@type">

    <xsl:variable name="typeValue">
      <xsl:value-of select="."/>
    </xsl:variable>

    <!-- abstract !-->
    <xsl:choose>
      <xsl:when test="$typeValue = 'executiveSummary'">
        <xsl:variable name="abstractType" select="'executive-summary'"/>
        <xsl:attribute name="abstract-type">
          <xsl:value-of select="$abstractType"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="abstract-type">
          <xsl:value-of select="$typeValue"/>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- TitleGroup !-->
  <xsl:template match="titleGroup">
    <xsl:apply-templates />
  </xsl:template>

  <!-- Title  -->
  <xsl:template match="title">
    <title>
      <xsl:apply-templates select = "@xml:id | @xml:lang | node()" />
    </title>
  </xsl:template>

  <!-- figure -->
  <xsl:template match="figure">
    <fig>
      <xsl:apply-templates select = "@xml:id | @xml:lang | node()" />
    </fig>
  </xsl:template>

  <!-- Tabular -->
  <xsl:template match="tabular">
    <sec>
      <table-wrap-group>
        <xsl:apply-templates select="@*|node()"/>
      </table-wrap-group>
    </sec>
  </xsl:template>

  <!-- block -->
  <xsl:template match="block">
    <xsl:if test="@type = 'box'">
      <boxed-text position="float" content-type="box">
        <xsl:apply-templates select = "@xml:id | @xml:lang | node()" />
      </boxed-text>
    </xsl:if>

    <xsl:if test="@type = 'floatQuote'">
      <disp-quote content-type="float-quote">
        <xsl:apply-templates select = "@xml:id | @xml:lang | node()" />
      </disp-quote>
    </xsl:if>

    <xsl:if test="@type = 'graphics'">
      <graphic>
        <xsl:apply-templates select = "@xml:id | @xml:lang | node()" />
      </graphic>
    </xsl:if>

    <xsl:if test="@type = 'pullQuote'">
      <xsl:choose>
        <xsl:when test="section/title">
          <boxed-text position="float" content-type="pull-quote">
            <xsl:apply-templates select = "@xml:id | @xml:lang | node()"/>
          </boxed-text>
        </xsl:when>
        <xsl:when test="section[not(title)]">
          <disp-quote  content-type="pull-quote">
            <xsl:apply-templates select = "@xml:id | @xml:lang | node()" />
          </disp-quote>
        </xsl:when>
        <xsl:otherwise>
          <disp-quote content-type="pull-quote">
              <xsl:apply-templates select = "@xml:id | @xml:lang | node()" />
          </disp-quote>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

    <xsl:if test="type = 'sidebar'">
      <boxed-text position="float" content-type="sidebar">
          <xsl:apply-templates select = "@xml:id | @xml:lang | node()"/>
      </boxed-text>
    </xsl:if>

    <xsl:if test="type = 'text'">
      <boxed-text position="float" content-type="text">
        <xsl:apply-templates select = "@xml:id | @xml:lang | node()"/>
      </boxed-text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="block/section[not(title)]">
    <xsl:apply-templates select = "@xml:id | @xml:lang | node()"/>
  </xsl:template>






  <!-- Section -->
  <xsl:template match="section">
    <sec>
      <xsl:apply-templates select="@*|node()"/>
    </sec>
  </xsl:template>

  <xsl:template match="section/feature">
    <boxed-text position="float" content-type="feature-floating">
      <xsl:attribute name="position">float</xsl:attribute>
      <xsl:apply-templates select="@*|node()"/>
    </boxed-text>
  </xsl:template>

  <xsl:template match="section/tabular">
    <table-wrap>
      <xsl:apply-templates select="@*|node()"/>
    </table-wrap>
  </xsl:template>

  <xsl:template match="section/figure">
    <fig>
      <xsl:apply-templates select="@* | node()"/>
    </fig>
  </xsl:template>

  <!-- p -->
  <xsl:template match="p">
    <p>
    <xsl:choose>
      <xsl:when test="count(chemicalStructure) > 1">
        <chem-struct>
          <xsl:apply-templates select="chemicalStructure" />
        </chem-struct>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="chemicalStructure" />
      </xsl:otherwise>
    </xsl:choose>

    <xsl:apply-templates select="@xml:id | node()[not(self::chemicalStructure)]"/>
    </p>
  </xsl:template>

  <!-- p/accessionId -->
  <xsl:template match="accessionId">
    <ext-link>
      <xsl:apply-templates select="@ref | @xml:id | node()"/>
    </ext-link>
  </xsl:template>


  <xsl:template match="accessionId/@ref">
    <xsl:variable name="xlinkRef">
      <xsl:value-of select="."/>
    </xsl:variable>
    <xsl:attribute name="xlink:href">
      <xsl:value-of select="$xlinkRef"/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="b">
    <bold>
      <xsl:apply-templates select = "@xml:id | @xml:lang | node()" />
    </bold>
  </xsl:template>

  <!-- blockFixed -->
  <xsl:template match="blockFixed[@type = 'box']">
    <xsl:if test="ancestor::p">
      <hr/>
      <xsl:apply-templates select = "@xml:id | @xml:lang | node()"/>
      <hr/>
    </xsl:if>

    <boxed-text position="anchor" content-type="box">
      <xsl:apply-templates select = "@xml:id | @xml:lang | node()" />
    </boxed-text>
  </xsl:template>

  <xsl:template match="blockFixed[@type = 'poetry']">
    <verse-group>
      <xsl:apply-templates select = "@xml:id | @xml:lang | node()" />
    </verse-group>
  </xsl:template>

  <xsl:template match="blockFixed[@type = 'quotation']">
    <disp-quote content-type="quotation">
      <xsl:apply-templates select = "@xml:id | @xml:lang | node()" />
    </disp-quote>
  </xsl:template>

  <xsl:template match="blockFixed[@type = 'graphic']">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="blockFixed">
    <boxed-text position="anchor" >
      <xsl:attribute name="content-type">
        <xsl:value-of select="@type"/>
      </xsl:attribute>
      <xsl:apply-templates select = "@xml:id | @xml:lang | node()" />
    </boxed-text>
  </xsl:template>

  <!-- chemicalStructure -->
  <xsl:template match="chemicalStructure">
    <chem-struct-wrap>
      <xsl:apply-templates select = "@xml:id | @xml:lang | node()" />
    </chem-struct-wrap>
  </xsl:template>

  <!-- citation -->
  <xsl:template match="citation">
    <element-citation>
      <xsl:apply-templates select = "@xml:id | @xml:lang | node()" />
    </element-citation>
  </xsl:template>

  <!-- computerCode !-->
  <xsl:template match="computerCode">
    <code xml:space="preserve">
      <xsl:apply-templates select = "@xml:id | @xml:lang | node()" />
    </code>
  </xsl:template>

  <!-- displayedItem> -->
  <xsl:template match="displayedItem[@type = 'mathematics']">
    <xsl:choose>
      <xsl:when test="parent::span">
        <inline-formula>
          <xsl:apply-templates select = "@xml:id | @xml:lang | node()" />
        </inline-formula>
      </xsl:when>
      <xsl:otherwise>
        <disp-formula>
          <xsl:apply-templates select = "@xml:id | @xml:lang | node()"/>
        </disp-formula>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="displayedItem[@type = 'text']">
    <disp-formula>
      <xsl:apply-templates select = "@xml:id | @xml:lang | node()"/>
    </disp-formula>
  </xsl:template>

  <xsl:template match="displayedItem[@type = 'chemicalReaction']">
    <chem-struct-wrap>
      <xsl:apply-templates select = "@xml:id | @xml:lang | node()"/>
    </chem-struct-wrap>
  </xsl:template>

  <!-- featureFixed -->
  <xsl:template match="featureFixed">
    <boxed-text position="anchor" content-type="feature-fixed">
      <xsl:apply-templates select = "@xml:id | @xml:lang | node()" />
    </boxed-text>
  </xsl:template>

  <!-- infoAsset -->
  <xsl:template match="named-content">
    <named-conent>
      <xsl:apply-templates select = "@xml:id | @xml:lang | node()" />
    </named-conent>
  </xsl:template>

  <xsl:template match="inlineGraphic">
    <inline-graphic>
      <xsl:apply-templates select = "@xml:id | @xml:lang | node()" />
    </inline-graphic>
  </xsl:template>

  <xsl:template match="link | url">
    <ext-link>
      <xsl:apply-templates select="@href | @xml:id | node()" />
    </ext-link>
  </xsl:template>

  <xsl:template match="@href">
    <xsl:variable name="xlinkRef">
      <xsl:value-of select="."/>
    </xsl:variable>
    <xsl:attribute name="xlink:href">
      <xsl:value-of select="$xlinkRef"/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="listPaired">
    <def-list>
      <xsl:apply-templates />
    </def-list>
  </xsl:template>

  <xsl:template match="mathStatement">
    <statement>
      <xsl:apply-templates select = "@xml:id | @xml:lang | node()" />
    </statement>
  </xsl:template>

  <xsl:template match="note">
    <fn>
      <xsl:apply-templates select = "@xml:id | @xml:lang | node()" />
    </fn>
  </xsl:template>

  <xsl:template match="record">
    <array content-type="record">
      <xsl:apply-templates select = "@xml:id | @xml:lang | node()" />
    </array>
  </xsl:template>

  <xsl:template match="source">
    <xsl:choose>
      <xsl:when test="parent::p">
        <named-content content-type="attribution">
          <xsl:apply-templates select = "@xml:id | @xml:lang | node()" />
        </named-content>
      </xsl:when>
      <xsl:otherwise>
        <attrib>
          <xsl:apply-templates select = "@xml:id | @xml:lang | node()" />
        </attrib>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="span">
    <styled-content>
      <xsl:apply-templates select = "@xml:id | @xml:lang | node()" />
    </styled-content>
  </xsl:template>

  <xsl:template match="tabularFixed">
    <table-wrap position = "anchor">
      <xsl:apply-templates select = "@xml:id | @xml:lang | node()" />
    </table-wrap>
  </xsl:template>

  <xsl:template match="term">
    <abbrev>
      <xsl:apply-templates select = "@xml:id | @xml:lang | node()" />
    </abbrev>
  </xsl:template>

  <xsl:template match="termDefinition[@hidden = 'yes']"/>

  <xsl:template match="termDefinition">
    <named-content content-type="term-definition">
      <xsl:apply-templates select = "@xml:id | @xml:lang | node()" />
    </named-content>
  </xsl:template>

  <!-- termGroup unwrap content -->
  <xsl:template match="termGroup">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="listItem">
    <list-item>
      <xsl:apply-templates select = "@xml:id | @xml:lang | node()" />
    </list-item>
  </xsl:template>

  <!-- fc -->
  <xsl:template match="fc">
    <fixed-case>
      <xsl:apply-templates select = "@xml:id | @xml:lang | node()" />
    </fixed-case>
  </xsl:template>

  <xsl:template match="fi">
    <italic toggle="no">
      <xsl:apply-templates select = "@xml:id | @xml:lang | node()" />
    </italic>
  </xsl:template>

  <xsl:template match="roman">
    <italic toggle="no">
      <xsl:apply-templates select = "@xml:id | @xml:lang | node()" />
    </italic>
  </xsl:template>

  <xsl:template match="i">
    <italic>
      <xsl:apply-templates select = "@xml:id | @xml:lang | node()" />
    </italic>
  </xsl:template>

  <xsl:template match="mediaResourceGroup">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="mediaResource">
    <xsl:choose>
      <xsl:when test="@alt">
        <graphic>
          <xsl:apply-templates select="@* | node()"/>
          <alt><xsl:value-of select="@alt"/></alt>
        </graphic>
      </xsl:when>
      <xsl:otherwise>
        <graphic>
          <xsl:apply-templates select="@* | node()"/>
        </graphic>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="mediaResource/@alt">
  </xsl:template>
  <!-- deleting unwanted tags -->
  <xsl:template match="useSectionTitles"/>
  <xsl:template match="doi"/>
  <xsl:template match="recipe"/>
  <xsl:template match="p/blank"/>


  <!-- Common Attributes -->
  <xsl:template match="@xml:id">
    <xsl:variable name="id">
    <xsl:value-of select="."/>
  </xsl:variable>
  <xsl:attribute name="id">
    <xsl:value-of select="$id"/>
  </xsl:attribute>
  </xsl:template>

  <xsl:template match="@xml:lang">
    <xsl:variable name="lang">
      <xsl:value-of select="."/>
    </xsl:variable>
    <xsl:attribute name="xml:lang">
      <xsl:value-of select="$lang"/>
    </xsl:attribute>
  </xsl:template>
</xsl:stylesheet>

