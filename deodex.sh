#!/bin/bash

dedeox () {
a=`echo $1 | sed "s/odexed//"`
echo "Dedeoxing $a.apk/jar"
java -jar -Duser.language=en oat2dex.jar $1.odex tmp/$a.dex > /dev/null 2>&1
java -jar baksmali.jar -a $API -x tmp/$a.dex -o tmp/$a
mkdir -p tmp/$a && java -jar smali.jar -a 21 tmp/$a -o tmp/$a/classes.dex
echo "$1.apk classes.dex created"
echo
}

inject_apk () {
a=`echo $1 | sed "s/odexed//"`
echo "Injecting $a classex.dex into $a.apk"
cp $1.apk deodexed/.
zip -r deodexed/$a.apk tmp/$a/classes.dex
echo "classex.dex injected"
echo
}

inject_jar () {
a=`echo $1 | sed "s/odexed//"`
echo "Injecting $a classex.dex into $a.jar"
cp $1.jar deodexed/.
zip -r deodexed/$1.jar tmp/$a/classes.dex
echo "classex.dex injected"
echo
}

cleanup () {
rm -rf tmp
}

echo "Every *.apk/*.jar and *.odex in odexed folder will be deodex and the clesses.dex will be injected into the *.apk/*.jar"
echo -ne "Enter API level and press enter : "
read API
for l in `ls odexed/*.apk | sed "s/.apk//"`; do dedeox $l && inject_apk $l; done > /dev/null 2>&1
for l in `ls odexed/*.jar | sed "s/.jar//"`; do dedeox $l && inject_jar $l; done > /dev/null 2>&1
cleanup
echo "Done"
