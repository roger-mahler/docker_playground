# Named Entity Recognition using HFST-SweNER

See article “HFST-SweNER – A New NER Resource for Swedish “

HFST On GitHub: https://github.com/hfst/hfst

# Installation

This
Optional: Compile latest version of HFST from source:
```bash
% sudo apt-get install git
% git clone https://github.com/hfst/hfst.git
% cd hfst
% ./configure [opions]
% make
% sudo make install
```
Sqitch Docker Packaging
=======================

    docker pull sqitch/sqitch
    curl -L https://git.io/fAX6Z -o sqitch && chmod +x sqitch
    ./sqitch help

This project creates a Docker image with HFST-SweNER installed (with all dependencies).
It's built on [python:2.7-slim-stretch] in an effort to keep the image as
small as possible while supporting all known engines.

Notes
-----
*   The [`hfst-swener.sh`] script runa hfst-swener inaide a docker image and accepts
    the same arguments as . The script mounts the current directory and the home
    directory, so that it acts on the Sqitch project in the current directory
    and reads configuration from the home directory almost as if it was running
    natively on the local host. It also copies over most of the environment
    variables that Sqitch cares about, for transparent configuration.
*   By default, the container runs as the `sqitch` user, but when executed by
    `root`, [`docker-sqitch.sh`] runs the container as `root`. Depending on your
    permissions, you might need to use `root` in order for sqitch to read and
    write files. On Windows and macOS, the `sqitch` user should be fine. On
    Linux, if you find that the container cannot access configuration files in
    your home directory or write change scripts to the local directory, run
    `sudo docker-sqitch.sh` to run as the root user. Just be sure to `chown`
    files that Sqitch created for the consistency of your project.

# Perform NER with HSFT-SweNER
The following command performs NER on file “test.txt” using pmatch (HSFT), with verbose progress prints, and :


% hfst-swener --times --verbose --output-to-file --pmatch test.txt

The output is in this case stored in file “test.txt.ner-pm”.
Use command line switch --help to see available options.

The tags can be extracted with Python script extract-tagged-names.py, which should be avaliable after install. Otherwise it resides in “scripts” folder.
extract-tagged-names.py --help gives command line options.

Extract Text from the ALTO-XML using XSLT (Windows)
The “raw” text in the ALTO-XML files are extracted to plain text files. These files will then later on be cleaned up manually, removing references and other non-related text segments that could affect the text analysis.
Download XSLT processor from MSDN (link)
Download this file from Github.
Modify file (see below) so that:
SUB_CONTENT is extracted when @SUBS_TYPE = 'HypPart1'
Tag is ignored when @SUBS_TYPE = 'HypPart2'
Tag “HYP” is ignored
msxsl.exe  "Daedalus 1931.xml" alto2txt.xslt > “Daedalus 1931”.txt

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:a="http://www.loc.gov/standards/alto/ns-v3#" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text"/>
<xsl:strip-space elements="*"/>
   <xsl:template match="/">
       <xsl:apply-templates select="/a:alto/a:Layout/a:Page/a:PrintSpace"></xsl:apply-templates>
   </xsl:template>
   <xsl:template match="a:PrintSpace">
       <xsl:apply-templates></xsl:apply-templates>
   </xsl:template>
   <xsl:template match="a:ComposedBlock">
       <xsl:text>&#xa;</xsl:text>
       <xsl:apply-templates></xsl:apply-templates>
   </xsl:template>
   <xsl:template match="a:TextBlock">
       <xsl:text>&#xa;&#xa;</xsl:text>
       <xsl:apply-templates></xsl:apply-templates>
   </xsl:template>
   <xsl:template match="a:TextLine">
       <xsl:text>&#xa;</xsl:text>
       <xsl:apply-templates></xsl:apply-templates>
   </xsl:template>
   <xsl:template match="a:String[@SUBS_TYPE = 'HypPart1']">
       <xsl:apply-templates select="@SUBS_CONTENT"></xsl:apply-templates>
   </xsl:template>
   <xsl:template match="a:String[@SUBS_TYPE = 'HypPart2']">
   </xsl:template>
   <xsl:template match="a:String[not(@SUBS_TYPE = 'HypPart1' or @SUBS_TYPE = 'HypPart2')]">
       <xsl:value-of select="@CONTENT"/>
       <!--<xsl:apply-templates select="@SUBS_CONTENT"></xsl:apply-templates>-->
   </xsl:template>
   <xsl:template match="a:SP">
       <xsl:text> </xsl:text>
   </xsl:template>
   <!--<xsl:template match="a:HYP">
       <xsl:value-of select="@CONTENT"/>
   </xsl:template>-->
   <xsl:template match="@SUBS_CONTENT">
       <xsl:value-of select="."/>
       <!--<xsl:text> </xsl:text>[ <xsl:value-of select="."/> ]<xsl:text> </xsl:text>-->
   </xsl:template>
</xsl:stylesheet>
Run the NER on cleaned up text files
Extract NER entities from all text files in current folder and save resulting files in “./output” folder”.

hfst-swener --times --verbose --output-to-file --output-dir ./output/ --names *.txt
Extract NER entities from result files
The following script extracts all entities to text files with a filename that ends with “.tags.txt”. These text files are then appended, with the year added as an extra column (extracted from the filenames):

#!/bin/bash
rm *.tags.txt
for f in *.ner-pm
do
        /usr/local/bin/extract-tagged-names.py $f > $f.tags.txt
done
for i in *.txt
do
        nawk -v YEAR=${i:8:4} '{printf "%s %s\r\n", YEAR, $0}' $i
done


  [Sqitch Project]: https://sqitch.org
  [stable Debian slim]: https://docs.docker.com/samples/library/debian/#debiansuite-slim
  [Firebird]: https://www.firebirdsql.org
  [AdoptOpenJSK]: https://github.com/AdoptOpenJDK/openjdk-docker/blob/master/8/jdk/debian/Dockerfile.hotspot.nightly.slim

