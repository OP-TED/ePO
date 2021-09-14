<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  
    xmlns:xmi="http://schema.omg.org/spec/XMI/2.1">
    <xsl:output method="xml" indent="yes" version="1.0"/>
    <xsl:strip-space elements="*" />
    
    <xsl:template match="/">
        <Glossary xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <xsl:apply-templates/>
        </Glossary>
    </xsl:template>
    <xsl:template match="connector/target">
        <Predicates>
            <Class>
                <xsl:value-of select="model/@name"/>
            </Class>
            <PredicateName>
                <xsl:value-of select="role/@name"/>
            </PredicateName>
        </Predicates>          
    </xsl:template>
</xsl:stylesheet>