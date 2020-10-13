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
    <xsl:template match="element[@xmi:type='uml:Enumeration']">
        <CodeList>
            <CodeListName>
                <xsl:value-of select="@name"/>
            </CodeListName>
            <CodeListDefinition>
                <xsl:value-of select="properties/@documentation"/>
            </CodeListDefinition>
            <xsl:for-each select="attributes/attribute">
                <Codes>
                    <AuthorityCode>
                        <xsl:value-of select="@name"/>
                    </AuthorityCode>
                    <CodeName>
                        <xsl:value-of select="initial/@body"/>
                    </CodeName>
                </Codes>
            </xsl:for-each>
        </CodeList>          
    </xsl:template>
</xsl:stylesheet>