#!/bin/bash
reval_tech_old=script_files/reval_tech.html.old
reval_tech=script_files/reval_tech.html
hash_new=script_files/hash.new
hash_old=script_files/hash.old
TMPPDFLINKS=script_files/tmpdflinks
PDFLINKS_OLD=script_files/pdflinks.old
PDFLINKS=script_files/pdflinks
NEWLINKS=script_files/newlinks
touch $reval_tech_old
touch $reval_tech
touch $hash_old
touch $hash_new

while read line;
do
hash_old_text=$line;
done < $hash_old

while read line;
do
hash_new_text=$line
done < $hash_new

received_hash_new_text=$(md5sum script_files/reval_tech.html | cut -d ' ' -f 1)
received_hash_old_text=$(md5sum script_files/reval_tech.html.old | cut -d ' ' -f 1)

if [ "$hash_new_text" != "$received_hash_new_text" ] || [ "$hash_old_text" != "$received_hash_old_text" ] ; then
echo Fatal Error hashes of received files dont match >> script_files/logs/fatalerrors.log
echo fatal error refer logs
else

echo Starting to mail the list
echo .
echo .

#for old files getting pdflinks_old file
echo $(grep -o 'href=".*pdf' $reval_tech_old) > $TMPPDFLINKS
sed 's#href="#http:\/\/www.mu.ac.in\/revaluation\/revalfh13\/#g' $TMPPDFLINKS > $PDFLINKS_OLD
#have purposfully not overwritten TMPPDFLINKS for debugging
cp $PDFLINKS_OLD script_files/pdflinks.tmp
#tr ' ' '\n' < script_files/pdflinks.tmp > $PDFLINKS
sed 's#.pdf\s#.pdf\n#g' script_files/pdflinks.tmp > $PDFLINKS_OLD
rm script_files/pdflinks.tmp


#for new File getting pdflinks
echo $(grep -o 'href=".*pdf' $reval_tech) > $TMPPDFLINKS
sed 's#href="#http:\/\/www.mu.ac.in\/revaluation\/revalfh13\/#g' $TMPPDFLINKS > $PDFLINKS
#have purposfully not overwritten TMPPDFLINKS for debugging
cp $PDFLINKS script_files/pdflinks.tmp
#tr ' ' '\n' < script_files/pdflinks.tmp > $PDFLINKS
sed 's#.pdf\s#.pdf\n#g' script_files/pdflinks.tmp > $PDFLINKS
rm script_files/pdflinks.tmp

fi

echo All pdflinks generated
echo .
echo .

#finds the difference
$(grep -Fxvf $PDFLINKS_OLD $PDFLINKS) > $NEWLINKS

#replace the old pdflinks to newone
rm $PDFLINKS_OLD
cp $PDFLINKS $PDFLINKS_OLD

#mailing the Different links to list of people

