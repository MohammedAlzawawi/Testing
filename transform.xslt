<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink" >


  <xsl:template match="/">
    <xsl:apply-templates select="//abstractGroup"/>
  </xsl:template>

  <xsl:template match="@*" />

  <xsl:template match="abstractGroup">
    <xsl:apply-templates />
  </xsl:template>

  <!-- Template for the abstract element -->
  <xsl:template match="abstract">
    <!-- Create a new abstract element with the updated type attribute -->
    <abstract>
      <xsl:apply-templates select="@* | node()"/>
    </abstract>
  </xsl:template>

  <xsl:template match="useSectionTitles">
    <xsl:variable name="title_level"><xsl:value-of select="@level"/></xsl:variable>

    <xsl:for-each select="//body[1]">
      <xsl:call-template name="useSectionTitle_collection">
        <xsl:with-param name="level" select="number(1)"/>
        <xsl:with-param name="maxLevel" select="number($title_level)"/>
      </xsl:call-template>
    </xsl:for-each>

  </xsl:template>

  <xsl:template name="useSectionTitle_collection">
    <xsl:param name="level" />
    <xsl:param name="maxLevel" />

    <xsl:if test="number($level) &lt;= number($maxLevel)">
      <xsl:for-each select="section">
          <xsl:element name="sec">
            <xsl:apply-templates select="title | titleGroup" mode="useSectionTitle" />
            <xsl:call-template name="useSectionTitle_collection">
              <xsl:with-param name="level" select="$level + 1"/>
              <xsl:with-param name="maxLevel" select="number($maxLevel)"/>
            </xsl:call-template>
          </xsl:element>
        </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <xsl:template match="title" mode="useSectionTitle">
    <title>
      <xsl:apply-templates select="@* | node()"/>
    </title>
  </xsl:template>

  <xsl:template match="titleGroup" mode="useSectionTitle">
    <xsl:apply-templates  mode="useSectionTitle"/>
  </xsl:template>


  <xsl:template match="abstract[@type = 'graphical']" />

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
      <xsl:apply-templates select = "@* | node()" />
    </title>
  </xsl:template>

  <!-- figure -->
  <xsl:template match="figure">
    <fig>
      <xsl:apply-templates select = "@* | node()" />
    </fig>
  </xsl:template>

  <!-- Tabular -->
  <xsl:template match="tabular">
    <sec>
      <table-wrap-group>
        <xsl:apply-templates select="@* |node()"/>
      </table-wrap-group>
    </sec>
  </xsl:template>

  <!-- block -->
  <xsl:template match="block">
    <xsl:if test="@type = 'box'">
      <boxed-text position="float" content-type="box">
        <xsl:apply-templates select = "@* | node()" />
      </boxed-text>
    </xsl:if>

    <xsl:if test="@type = 'floatQuote'">
      <disp-quote content-type="float-quote">
        <xsl:apply-templates select = "@* | node()" />
      </disp-quote>
    </xsl:if>

    <xsl:if test="@type = 'graphics'">
      <graphic>
        <xsl:apply-templates select = "@* | node()" />
      </graphic>
    </xsl:if>

    <xsl:if test="@type = 'pullQuote'">
      <xsl:choose>
        <xsl:when test="section/title">
          <boxed-text position="float" content-type="pull-quote">
            <xsl:apply-templates select = "@* | node()"/>
          </boxed-text>
        </xsl:when>
        <xsl:when test="section[not(title)]">
          <disp-quote  content-type="pull-quote">
            <xsl:apply-templates select = "@* | node()" />
          </disp-quote>
        </xsl:when>
        <xsl:otherwise>
          <disp-quote content-type="pull-quote">
            <xsl:apply-templates select = "@* | node()" />
          </disp-quote>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

    <xsl:if test="type = 'sidebar'">
      <boxed-text position="float" content-type="sidebar">
        <xsl:apply-templates select = "@* | node()"/>
      </boxed-text>
    </xsl:if>

    <xsl:if test="type = 'text'">
      <boxed-text position="float" content-type="text">
        <xsl:apply-templates select = "@* | node()"/>
      </boxed-text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="block/section[not(title)]">
    <xsl:apply-templates select = "@* | node()"/>
  </xsl:template>






  <!-- Section -->
  <xsl:template match="section">
    <sec>
      <xsl:apply-templates select="@* | node()"/>
    </sec>
  </xsl:template>

  <xsl:template match="section/feature">
    <boxed-text position="float" content-type="feature-floating">
      <xsl:apply-templates select="@* |node()"/>
    </boxed-text>
  </xsl:template>

  <xsl:template match="section/tabular">
    <table-wrap>
      <xsl:apply-templates select="@* | node()"/>
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

      <xsl:apply-templates select="@* | node()[not(self::chemicalStructure)]"/>
    </p>
  </xsl:template>

  <!-- p/accessionId -->
  <xsl:template match="accessionId">
    <xsl:choose>
      <xsl:when test="starts-with(@ref, 'info:x-wiley/crsStd')"></xsl:when>
      <xsl:when test="starts-with(@ref, 'info:x-wiley/crsRef')"></xsl:when>
      <xsl:when test="starts-with(@ref, 'info:x-wiley/cochraneLocalStudyId')"></xsl:when>
      <xsl:otherwise>
        <ext-link>
          <xsl:apply-templates select="@* | node()"/>
        </ext-link>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="accessionId/@ref">
    <xsl:variable name="attr_value_map">
      <value input="info:ark" output="ark"/>
      <value input="info:arxiv" output="arxiv"/>
      <value input="info:bibcode" output="astrophysics-data-system-bibcode"/>
      <value input="info:bnf" output="bnf"/>
      <value input="info:ddbj-embl-genbank" output="DDBJ/EMBL/GenBank"/>
      <value input="info:dlf" output="dlf"/>
      <value input="info:doi" output="doi"/>
      <value input="info:eu-repo" output="eu-repo"/>
      <value input="info:fedora" output="fedora"/>
      <value input="info:hdl" output="hdl"/>
      <value input="info:inchi" output="inchi"/>
      <value input="info:lanl-repo" output="lanl-repo"/>
      <value input="info:lccn" output="lccn"/>
      <value input="info:lc" output="lc"/>
      <value input="info:ncid" output="ncid"/>
      <value input="info:netref" output="netref"/>
      <value input="info:nla" output="nla"/>
      <value input="info:nyu" output="nyu"/>
      <value input="info:oclcnum" output="oclcnum"/>
      <value input="info:ofi" output="ofi"/>
      <value input="info:pmid" output="pmid"/>
      <value input="info:pronom" output="pronom"/>
      <value input="info:refseq" output="NCBI:refseq"/>
      <value input="info:rfa" output="rfa"/>
      <value input="info:rlgid" output="rlgid"/>
      <value input="info:sici" output="sici"/>
      <value input="info:sid" output="sid"/>
      <value input="info:srw" output="srw"/>
      <value input="info:ugent-repo" output="ugent-repo"/>
      <value input="info:x-wiley/ae" output="EBI:arrayexpress"/>
      <value input="info:x-wiley/biomodels" output="biomodels"/>
      <value input="info:x-wiley/biostudies" output="biostudies"/>
      <value input="info:x-wiley/bmrb" output="bmrb"/>
      <value input="info:x-wiley/casrn" output="cas-registration-number"/>
      <value input="info:x-wiley/ccdc" output="ccdc"/>
      <value input="info:x-wiley/clinicalTrialsGov" output="clinical-trials-gov"/>
      <value input="info:x-wiley/clinicalTrialsRegistry" output="clinical-trials-registry"/>
      <value input="info:x-wiley/cochrane" output="cochrane-library-record-id"/>
      <value input="info:x-wiley/crs" output="crs-id"/>
      <value input="info:x-wiley/dbgap" output="dbgap"/>
      <value input="info:x-wiley/dbsnp" output="dbsnp"/>
      <value input="info:x-wiley/ebmg" output="ebmg"/>
      <value input="info:x-wiley/ec" output="ec"/>
      <value input="info:x-wiley/eep-dx" output="eep-dx"/>
      <value input="info:x-wiley/eep-eee" output="eep-eee"/>
      <value input="info:x-wiley/eep-guideline" output="eep-guideline"/>
      <value input="info:x-wiley/eep-hp" output="eep-hp"/>
      <value input="info:x-wiley/eep-poem" output="eep-poem"/>
      <value input="info:x-wiley/eep-rule" output="eep-rule"/>
      <value input="info:x-wiley/ega-dataset" output="ega-dataset"/>
      <value input="info:x-wiley/ega-study" output="ega-study"/>
      <value input="info:x-wiley/emblalign" output="emblalign"/>
      <value input="info:x-wiley/emdb" output="emdb"/>
      <value input="info:x-wiley/ena" output="EBI:ena"/>
      <value input="info:x-wiley/flowrepository" output="flow-repository"/>
      <value input="info:x-wiley/geneset" output="geneweaver:geneset"/>
      <value input="info:x-wiley/geneSymbol" output="NCBI:gene"/>
      <value input="info:x-wiley/geo" output="NCBI:geo"/>
      <value input="info:x-wiley/gridref" output="ordnance-survey-grid-reference"/>
      <value input="info:x-wiley/icd10" output="icd10"/>
      <value input="info:x-wiley/icd11" output="icd11"/>
      <value input="info:x-wiley/icd9" output="icd9"/>
      <value input="info:x-wiley/icd" output="icd"/>
      <value input="info:x-wiley/imex" output="imex"/>
      <value input="info:x-wiley/intact" output="intact"/>
      <value input="info:x-wiley/isbn" output="isbn"/>
      <value input="info:x-wiley/issn" output="issn"/>
      <value input="info:x-wiley/jmol" output="jmol"/>
      <value input="info:x-wiley/jws" output="jws"/>
      <value input="info:x-wiley/metabolights" output="metabolights"/>
      <value input="info:x-wiley/lrg" output="lrg"/>
      <value input="info:x-wiley/massive" output="massive"/>
      <value input="info:x-wiley/mmdb" output="NCBI:structure"/>
      <value input="info:x-wiley/ncbi-nucleotide" output="NCBI:nucleotide"/>
      <value input="info:x-wiley/ncbi-pcassay" output="NCBI:pubchem-bioassay"/>
      <value input="info:x-wiley/ncbi-pccompound" output="NCBI:pubchem-compound"/>
      <value input="info:x-wiley/ncbi-pcsubstance" output="NCBI:pubchem-substance"/>
      <value input="info:x-wiley/ncbi-protein" output="NCBI:protein"/>
      <value input="info:x-wiley/ncbi-taxonomy" output="NCBI:taxonomy"/>
      <value input="info:x-wiley/ndb" output="ndb"/>
      <value input="info:x-wiley/omim" output="Omim"/>
      <value input="info:x-wiley/orphanet" output="orphanet"/>
      <value input="info:x-wiley/patent" output="patent"/>
      <value input="info:x-wiley/pdb" output="PDB"/>
      <value input="info:x-wiley/peptideatlas" output="peptide-atlas"/>
      <value input="info:x-wiley/pmc" output="pmc"/>
      <value input="info:x-wiley/pmdb" output="pmdb"/>
      <value input="info:x-wiley/pride" output="pride"/>
      <value input="info:x-wiley/refseqgene" output="NCBI:refseq_gene"/>
      <value input="info:x-wiley/rrid" output="rrid"/>
      <value input="info:x-wiley/sra" output="NCBI:sra"/>
      <value input="info:x-wiley/standard" output="standard"/>
      <value input="info:x-wiley/swissprot" output="SwissProt"/>
      <value input="info:x-wiley/uniprot" output="UniProt"/>
      <value input="info:x-wiley/zenodo" output="zenodo"/>
    </xsl:variable>
  </xsl:template>

  <xsl:template match="b">
    <bold>
      <xsl:apply-templates select = "@* | node()" />
    </bold>
  </xsl:template>

  <xsl:template match="blank">
    <_3g2jatsError-BlankFoundNotDescendantOfExercise/>
  </xsl:template>


  <!-- blockFixed -->
  <xsl:template match="blockFixed">
    <boxed-text position="anchor" >
      <xsl:attribute name="content-type">
        <xsl:value-of select="@type"/>
      </xsl:attribute>
      <xsl:apply-templates select = "@* | node()" />
    </boxed-text>
  </xsl:template>

  <xsl:template match="blockFixed[@type = 'box']">
    <boxed-text position="anchor" content-type="box">
      <xsl:apply-templates select = "@* | node()" />
    </boxed-text>
  </xsl:template>

  <xsl:template match="blockFixed[@type = 'poetry']">
    <verse-group>
      <xsl:apply-templates select = "@* | node()" />
    </verse-group>
  </xsl:template>

  <xsl:template match="blockFixed[@type = 'quotation']">
    <disp-quote content-type="quotation">
      <xsl:apply-templates select = "@* | node()" />
    </disp-quote>
  </xsl:template>

  <!-- chemicalStructure -->
  <xsl:template match="span/chemicalStructure">
    <chem-struct>
      <xsl:apply-templates select = "@* | node()" />
    </chem-struct>
  </xsl:template>

  <xsl:template match="chemicalStructure">
    <chem-struct-wrap>
      <xsl:apply-templates select = "@* | node()" />
    </chem-struct-wrap>
  </xsl:template>

  <!-- citation -->
  <xsl:template match="listItem/citation | note/citation |
                        p/citation |
                        title/citation">
    <mixed-citation>
      <xsl:apply-templates select = "@* | node()" />
    </mixed-citation>
  </xsl:template>

  <xsl:template match="citation/@type">
    <xsl:variable name="attr_value_map">
      <value input="ancestor" output="ancestor-journal"/>
      <value input="book" output="book"/>
      <value input="data" output="data"/>
      <value input="dataNew" output="data"/>
      <value input="dataRelates" output="data"/>
      <value input="journal" output="journal"/>
      <value input="other" output="miscellaneous"/>
      <value input="software" output="software"/>
      <value input="source" output="software"/>
    </xsl:variable>

  </xsl:template>


  <!-- computerCode !-->
  <xsl:template match="computerCode">
    <code xml:space="preserve">
      <xsl:apply-templates select = "@* | node()" />
    </code>
  </xsl:template>

  <!-- displayedItem> -->
  <xsl:template match="displayedItem/p/displayedItem[@type = 'mathematics']" priority="1">
    <named-content content-type="disp-formula">
      <boxed-text content-type="disp-formula">
        <xsl:apply-templates select = "@* | node()" />
      </boxed-text>
    </named-content>
  </xsl:template>

  <!-- email -->
  <xsl:template match="email">
    <email>
      <xsl:choose>
        <xsl:when test="@normalForm != '' and not(@normalForm = 'unknown')">
          <xsl:apply-templates select="@*" />
          <xsl:value-of select="@normalForm"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="@* | node()"/>
        </xsl:otherwise>
      </xsl:choose>
    </email>
  </xsl:template>

  <xsl:template match="displayedItem[@type = 'mathematics']">
    <xsl:choose>
      <xsl:when test="parent::span">
        <inline-formula>
          <xsl:apply-templates select = "@* | node()" />
        </inline-formula>
      </xsl:when>
      <xsl:otherwise>
        <disp-formula>
          <xsl:apply-templates select = "@* | node()"/>
        </disp-formula>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="displayedItem[@type = 'text']">
    <disp-formula>
      <xsl:apply-templates select = "@* | node()"/>
    </disp-formula>
  </xsl:template>

  <xsl:template match="displayedItem[@type = 'chemicalReaction']">
    <chem-struct-wrap>
      <xsl:apply-templates select = "@* | node()"/>
    </chem-struct-wrap>
  </xsl:template>

  <!-- featureFixed -->
  <xsl:template match="featureFixed">
    <boxed-text position="anchor" content-type="feature-fixed">
      <xsl:apply-templates select = "@* | node()" />
    </boxed-text>
  </xsl:template>

  <!-- infoAsset -->
  <xsl:template match="infoAsset">
    <named-conent>
      <xsl:apply-templates select = "@* | node()" />
    </named-conent>
  </xsl:template>

  <!-- inlineGrapic -->
  <xsl:template match="inlineGraphic[@extraInfo = 'missing']">
    <xsl:if test="parent::span and not(preceding-sibling::node() or following-sibling::node())">
      <xsl:choose>
        <xsl:when test="parent::span/@type = 'latex' or  parent::span/@type = 'tex'">
          <!-- Do nothing -->
        </xsl:when>
        <xsl:otherwise>
          <xsl:next-match/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="inlineGraphic">
    <inline-graphic>
      <xsl:apply-templates select = "@* | node()" />
    </inline-graphic>
  </xsl:template>

  <xsl:template match="inlineGraphic/@location">
    <xsl:attribute name="xlink:href" select="."/>
  </xsl:template>

  <xsl:template match="inlineGraphic/@href">
    <xsl:if test="not(../@location)">
      <xsl:attribute name="xlink:href" select="."/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="inlineGraphic/@alt">
    <xsl:attribute name="xlink:title" select="."/>
  </xsl:template>

  <xsl:template match="link | url">
    <ext-link>
      <xsl:apply-templates select="@* | node()" />
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
      <xsl:apply-templates select="@* | node()" />
    </def-list>
  </xsl:template>

  <xsl:template match="mathStatement">
    <statement>
      <xsl:apply-templates select = "@* | node()" />
    </statement>
  </xsl:template>

  <!-- note -->
  <xsl:template match="note">
    <fn>
      <p>
        <xsl:apply-templates select="@* | node()" />
      </p>
    </fn>
  </xsl:template>

  <xsl:template match="figure/note">
    <p>
      <fn>
        <p>
          <xsl:apply-templates select="@* | node()" />
        </p>
      </fn>
    </p>
  </xsl:template>


  <xsl:template match="displayedItem[@type = 'mathematics']/note">
    <fn>
      <p>
        <xsl:apply-templates select="@* | node()" />
      </p>
    </fn>
  </xsl:template>

  <xsl:template match="displayedItem/note">
    <p>
      <fn>
        <p>
          <xsl:apply-templates select="@* | node()" />
        </p>
      </fn>
    </p>
  </xsl:template>

  <!-- record -->

  <xsl:template match="record">
    <array content-type="record">
      <xsl:apply-templates select = "@*" />
      <tbody>
        <xsl:apply-templates select = "node()" />
      </tbody>
    </array>
  </xsl:template>

  <xsl:template match="source">
    <xsl:choose>
      <xsl:when test="parent::p">
        <named-content content-type="attribution">
          <xsl:apply-templates select = "@* | node()" />
        </named-content>
      </xsl:when>
      <xsl:otherwise>
        <attrib>
          <xsl:apply-templates select = "@* | node()" />
        </attrib>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="span">
    <styled-content>
      <xsl:apply-templates select = "@* | node()" />
    </styled-content>
  </xsl:template>

  <xsl:template match="tabularFixed">
    <table-wrap position = "anchor">
      <xsl:apply-templates select = "@* | node()" />
    </table-wrap>
  </xsl:template>

  <xsl:template match="term[@type = 'displayForm']" />

  <xsl:template match="term[@type = 'absent']" >
    <named-content content-type="term">
      <xsl:apply-templates select = "@* | node()" />
    </named-content>
  </xsl:template>

  <xsl:template match="term">
    <named-content content-type="{translate(@type, ' ', '-')}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="node()"/>
    </named-content>
  </xsl:template>

  <xsl:template match="term/@type" />

  <xsl:template match="termDefinition[@hidden = 'yes']"/>

  <xsl:template match="termDefinition">
    <named-content content-type="term-definition">
      <xsl:apply-templates select = "@* | node()" />
    </named-content>
  </xsl:template>

  <!-- termGroup unwrap content -->
  <xsl:template match="termGroup" />

  <xsl:template match="list">
    <list>
      <xsl:apply-templates select = "@* | node()" />
    </list>
  </xsl:template>

  <xsl:template match="list/@style[contains(., 'plain')]">
    <xsl:attribute name="list-type">
      <xsl:value-of select="'simple'"/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="list/@style[contains(., 'bulleted')]">
    <xsl:attribute name="list-type">
      <xsl:value-of select="'bullet'"/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="list/@style[contains(., 'bulleted')]">
    <xsl:attribute name="list-type">
      <xsl:value-of select="'bulleted'"/>
    </xsl:attribute>  </xsl:template>

  <xsl:template match="list/@style[contains(., 'custom')]">
    <xsl:attribute name="list-type">
      <xsl:value-of select="'explicit-label'"/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="list/@style[contains(., 'checkbox')]">
    <xsl:attribute name="style">
      <xsl:value-of select="'check-box'"/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="listItem">
    <list-item>
      <xsl:apply-templates select = "@* | node()" />
    </list-item>
  </xsl:template>

  <!-- fc -->
  <xsl:template match="fc">
    <fixed-case>
      <xsl:apply-templates select = "@* | node()" />
    </fixed-case>
  </xsl:template>

  <!-- fr -->
  <xsl:template match="fc">
    <fixed-case>
      <xsl:apply-templates select = "@* | node()" />
    </fixed-case>
  </xsl:template>

  <xsl:template match="fr">
    <roman toggle="no">
      <xsl:apply-templates select = "@* | node()" />
    </roman>
  </xsl:template>

  <xsl:template match="roman">
    <italic toggle="no">
      <xsl:apply-templates select = "@* | node()" />
    </italic>
  </xsl:template>

  <xsl:template match="i">
    <italic>
      <xsl:apply-templates select = "@* | node()" />
    </italic>
  </xsl:template>

  <xsl:template match="mediaResourceGroup">
    <xsl:choose>
      <xsl:when test="mediaResource[@rendition='webHiRes' and starts-with(@mimeType, 'image')]">
        <xsl:apply-templates select="mediaResource[@rendition='webHiRes' and starts-with(@mimeType, 'image')][position() = 1]" />
      </xsl:when>
      <xsl:when test="count(mediaResource) = 1" >
        <xsl:apply-templates/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="mediaResource">
    <xsl:choose>
      <xsl:when test="@alt">
        <graphic>
          <xsl:apply-templates select="@* | node()"/>
          <alt-text><xsl:value-of select="@alt"/></alt-text>
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

  <xsl:template match="mediaResource/@mimeType">
    <xsl:attribute name="mimeType">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="mediaResource/@rendition">
    <xsl:attribute name="specific-use">
      <xsl:value-of select="'enlarged-web-image'"/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="sup">
    <sup>
      <xsl:apply-templates select="@* | node()"/>
    </sup>
  </xsl:template>

  <xsl:template match="sup">
    <sup>
      <xsl:apply-templates select="@* | node()"/>
    </sup>
  </xsl:template>

  <xsl:template match="sub">
    <sub>
      <xsl:apply-templates select="@* | node()"/>
    </sub>
  </xsl:template>

  <!-- protocol -->
  <xsl:template match="protocol">
    <sec sec-type="protocol">
      <xsl:apply-templates select="@* | node()"/>
    </sec>
  </xsl:template>

  <xsl:template match="protocol/@type">
    <xsl:attribute name="specific-use" select="."/>
  </xsl:template>

  <xsl:template match="protocolStep">
    <list-item>
      <xsl:apply-templates select="node()"/>
    </list-item>
  </xsl:template>

  <xsl:template match="protocolStep/figure | protocolStep/tabular" />

  <xsl:template match="protocolRecipe">
    <sec sec-type="protocol-recipe">
      <xsl:apply-templates select="@* | node()"/>
    </sec>
  </xsl:template>


  <xsl:template match="protocolSection">
    <sec>
      <xsl:apply-templates select="@xml:id"/>
      <xsl:for-each-group select="*" group-adjacent="exists(self::protocolStep)">
        <xsl:variable name="g" select="current-group()"/>
        <xsl:choose>
          <xsl:when test="$g/self::protocolStep and not( $g/figure or $g/tabular )">
            <list list-type="order" specific-use="protocol-steps">
              <xsl:apply-templates select="$g"/>
            </list>
          </xsl:when>
          <xsl:when test="$g/self::protocolStep">
            <xsl:for-each-group select="$g" group-ending-with="protocolStep[figure]|protocolStep[tabular]">
              <xsl:variable name="gr_step" select="current-group()"/>
              <list list-type="order" specific-use="protocol-steps">
                <xsl:apply-templates select="$gr_step"/>
              </list>
              <xsl:apply-templates select="$gr_step[last()]/(figure,tabular)"/>
            </xsl:for-each-group>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="$g"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each-group>
    </sec>
  </xsl:template>


  <!-- deleting unwanted tags -->
  <xsl:template match="@copyright" />
  <xsl:template match="@eRights" />
  <xsl:template match="doi"/>
  <xsl:template match="recipe"/>
  <xsl:template match="p/blank"/>


  <!-- Common Attributes -->

  <xsl:template match="@id">
    <xsl:variable name="id">
      <xsl:value-of select="."/>
    </xsl:variable>
    <xsl:attribute name="id">
      <xsl:value-of select="$id"/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="@lang">
    <xsl:variable name="lang">
      <xsl:value-of select="."/>
    </xsl:variable>
    <xsl:attribute name="lang">
      <xsl:value-of select="$lang"/>
    </xsl:attribute>
  </xsl:template>
</xsl:stylesheet>

