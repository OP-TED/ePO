<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.5" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  
    xmlns:xmi="http://www.omg.org/spec/XMI/20131001">
    <xsl:output method="xml" indent="yes" version="1.0"/>
    <xsl:strip-space elements="*" />
    
    <xsl:template match="/">
        <Glossary xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <xsl:apply-templates/>
        </Glossary>
    </xsl:template>
    <xsl:template match="element[@xmi:type='uml:Class']">
        <Class>
            <ClassName>
                <xsl:value-of select="@name"/>
            </ClassName>
            <ClassDefinition>
                <xsl:value-of select="properties/@documentation"/>
            </ClassDefinition>
            <xsl:for-each select="attributes/attribute">
            <Attribute>
                    <AttributeName>
                        <xsl:value-of select="@name"/>
                    </AttributeName>
                    <AttributeDefinition>
                        <xsl:value-of select="documentation/@value"/>
                    </AttributeDefinition>
                    <AttributeType>
                        <xsl:value-of select="properties/@type"/>
                    </AttributeType>
            </Attribute>
            </xsl:for-each>
        </Class>          
    </xsl:template>
</xsl:stylesheet>