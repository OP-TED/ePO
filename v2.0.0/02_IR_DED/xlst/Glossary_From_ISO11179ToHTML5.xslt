<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" 
xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" 
xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" 
xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
xmlns:ccts="urn:un:unece:uncefact:documentation:2"
xmlns:epo="http://data.europa.eu/ePO/ontology#"
xmlns:math="http://exslt.org/math"
extension-element-prefixes="math">

	<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>

	<xsl:template match="/">
		<xsl:call-template name="HTMLHeader"/>
		<xsl:call-template name="beginBody"/>
			<xsl:text disable-output-escaping="yes">&lt;tr&gt;</xsl:text>
				<xsl:text disable-output-escaping="yes">&lt;td&gt;</xsl:text>
					<xsl:apply-templates/>
				<xsl:text disable-output-escaping="yes">&lt;/td&gt;</xsl:text>
				<xsl:text disable-output-escaping="yes">&lt;tr&gt;</xsl:text>
		<xsl:call-template name="endBody"/>		
	</xsl:template>
	
	<xsl:template match="epo:DictionaryEntry">
		<xsl:apply-templates select="xsd:annotation"/>
	</xsl:template>
	
	<xsl:template match="xsd:annotation">
		<xsl:apply-templates select="xsd:documentation"/>
	</xsl:template>

<xsl:template match="xsd:documentation">
		<xsl:variable name="examples" select="ccts:Examples"/>
		<xsl:variable name="source" select="epo:Sources"/>
		<xsl:variable name="usedIn" select="ccts:UsageRule"/>
		
		<xsl:variable name="entryPos">
			<xsl:number count="epo:DictionaryEntry" format="1"/>
		</xsl:variable>		

		<xsl:variable name="Entry" select="upper-case(substring(ccts:DictionaryEntryName/text(), 1,1))"/>
		<xsl:variable name="nextEntry" select="upper-case(substring(../../../epo:DictionaryEntry[$entryPos + 1]/xsd:annotation/xsd:documentation/ccts:DictionaryEntryName/text(), 1,1))"/>		
		
		<xsl:if test="$entryPos = 1">
			<div class="nqa">
				<hr style="height: 10px; border-style: solid; border-color: #8c8b8b; border-width: 1px 0 0 0; border-radius: 30px;"/>
				<entry_letter>
					<xsl:value-of select="$Entry"/>
					<a href="#index" style="text-decoration:none;"> ↑ </a>
				</entry_letter>
			</div>
		</xsl:if>		
		
		<div class="qa">
			  <xsl:text disable-output-escaping="yes">&lt;input type="checkbox" id="qa</xsl:text><xsl:value-of select="$entryPos"/><xsl:text disable-output-escaping="yes">"/&gt;</xsl:text>
			  <xsl:text disable-output-escaping="yes">&lt;label for="qa</xsl:text><xsl:value-of select="$entryPos"/><xsl:text disable-output-escaping="yes">"&gt;</xsl:text><entry><xsl:value-of select="ccts:DictionaryEntryName"/></entry><xsl:text disable-output-escaping="yes">&lt;/label&gt;</xsl:text>
			<div>
				<definition><xsl:value-of select="ccts:Definition"/></definition>
				<br>
				<xsl:if test="$examples !=''"><examples><bn>Ex.: </bn><xsl:value-of select="$examples"/></examples></xsl:if>	
				<xsl:if test="$source !=''"><sources><br><bn>Source: </bn><xsl:value-of select="$source"/></br></sources></xsl:if>	
				<xsl:if test="$usedIn !=''"><usedIn><br><bn>Used in: </bn><xsl:value-of select="$usedIn"/></br></usedIn></xsl:if>	
				</br>
			</div>
		</div>
		
		<xsl:if test="$Entry != $nextEntry">
			<div class="nqa">
				<hr style="height: 10px; border-style: solid; border-color: #8c8b8b; border-width: 1px 0 0 0; border-radius: 30px;"/>
				<entry_letter>
				<xsl:text disable-output-escaping="yes">&lt;div id="</xsl:text><xsl:value-of select="$nextEntry"/><xsl:text disable-output-escaping="yes">"&gt;</xsl:text><xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
					<xsl:value-of select="$nextEntry"/>
					<a href="#index" style="text-decoration:none;"> ↑ </a>
				</entry_letter>				
			</div>
		</xsl:if>
		
	</xsl:template>

	<xsl:template name="HTMLHeader">
		<xsl:text disable-output-escaping="yes">&lt;html&gt;</xsl:text>	
		<head>
			<meta charset="UTF-8"/>
			<title>eProcurement Ontology (ePO) Glossary</title>
			<link rel = "stylesheet"   type = "text/css"   href = "./css/Glossary.css"/>
		</head>
	</xsl:template>
	
	<xsl:template name="beginBody">
		
	<xsl:text disable-output-escaping="yes">&lt;table width=70%" align="center"&gt;</xsl:text>
		<xsl:text disable-output-escaping="yes">&lt;tr&gt;</xsl:text>
			<xsl:text disable-output-escaping="yes">&lt;td&gt;</xsl:text>
				<xsl:text disable-output-escaping="yes">&lt;body&gt;</xsl:text>
				<h1 class="title_font">eProcurement Ontology (ePO) Glossary</h1>
				<div class="normal_font">
					<p>The following list of eProcurement concepts have been detected through an analysis of the new procurement forms (<b>eForms</b>) to be used soon by all tenderers in the EU.</p>
					<p><b>eForms</b> are one of the actions in the Single Market Strategy, where the European Commission has committed to "facilitate the collection, consolidation, management and analysis of procurement data, supporting Member States’ efforts towards better governance in public procurement".</p>
					<p>Please review the proposed definitions, as well as the link of each concept with the proposed Use Cases and eProcurement phases.</p>
					<p>In the Github section <a href="https://github.com/eProcurement-everis/ePO/wiki/Glossary-Management" style="text-decoration:none">Glossary Management</a> you will find instructions of how to contribute to the enrichment and improvement of the EPO Glossary.</p>
				</div>

				<p>
					<a class="anchor" href="#index"/>
					<div class="index" id="index">
					<a href="#A" style="text-decoration:none;">A </a>
					<a href="#B" style="text-decoration:none;"> B </a>
					<a href="#C" style="text-decoration:none;"> C </a>
					<a href="#D" style="text-decoration:none;"> D </a>
					<a href="#E" style="text-decoration:none;"> E </a>
					<a href="#F" style="text-decoration:none;"> F </a>
					<a href="#G" style="text-decoration:none;"> G </a>
					<a href="#H" style="text-decoration:none;"> H </a>
					<a href="#I" style="text-decoration:none;"> I </a>
					<a href="#J" style="text-decoration:none;"> J </a>
					<a href="#K" style="text-decoration:none;"> K </a>
					<a href="#L" style="text-decoration:none;"> L </a>
					<a href="#M" style="text-decoration:none;"> M </a>
					<a href="#N" style="text-decoration:none;"> N </a>
					<a href="#O" style="text-decoration:none;"> O </a>
					<a href="#P" style="text-decoration:none;"> P </a>
					<a href="#Q" style="text-decoration:none;"> Q </a>
					<a href="#R" style="text-decoration:none;"> R </a>
					<a href="#S" style="text-decoration:none;"> S </a>
					<a href="#T" style="text-decoration:none;"> T </a>
					<a href="#U" style="text-decoration:none;"> U </a>
					<a href="#V" style="text-decoration:none;"> V </a>
					<a href="#W" style="text-decoration:none;"> W </a>
					<a href="#X" style="text-decoration:none;"> X </a>
					<a href="#Y" style="text-decoration:none;"> Y </a>
					<a href="#Z" style="text-decoration:none;"> Z </a>
				</div>
				</p>
			<xsl:text disable-output-escaping="yes">&lt;/td&gt;</xsl:text>		
		<xsl:text disable-output-escaping="yes">&lt;tr&gt;</xsl:text>	
	</xsl:template>

	<xsl:template name="endBody">
		<xsl:text disable-output-escaping="yes">&lt;/table&gt;</xsl:text>
		<xsl:text disable-output-escaping="yes">&lt;/body&gt;</xsl:text>
	</xsl:template>

</xsl:stylesheet>
