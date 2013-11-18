#!/bin/bash
mkdir -p script_files
reval_tech=script_files/reval_tech.html
TMPPDFLINKS=script_files/tmpdflinks
PDFLINKS=script_files/pdflinks
rm $TMPPDFLINKS
rm $PDFLINKS
rm -r $reval_tech
wget -q http://www.mu.ac.in/revaluation/revalfh13/reval_tech.html -O $reval_tech
echo $(grep -o 'href=".*pdf' $reval_tech) > $TMPPDFLINKS
sed 's#href="#http:\/\/www.mu.ac.in\/revaluation\/revalfh13\/#g' $TMPPDFLINKS > $PDFLINKS
cp $PDFLINKS script_files/pdflinks.tmp
#have purposfully not overwritten TMPPDFLINKS for debugging
#tr ' ' '\n' < script_files/pdflinks.tmp > $PDFLINKS
sed 's#.pdf\s#.pdf\n#g' script_files/pdflinks.tmp > $PDFLINKS
rm script_files/pdflinks.tmp 
echo PDFLINKS acquired
echo .
echo .
mkdir -p script_files/allpdfs
cd script_files/allpdfs
rm -r *
echo Downloading PDFs
echo .
echo .
wget -q -i ../pdflinks
echo All PDFs downloaded
