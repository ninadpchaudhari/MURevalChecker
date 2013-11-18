#!/bin/bash
reval_tech_old=script_files/reval_tech.html.old
reval_tech=script_files/reval_tech.html
hash_new=script_files/hash.new
hash_old=script_files/hash.old
mkdir -p script_files/logs
touch $reval_tech_old
touch $reval_tech
touch $hash_new
touch $hash_old

echo $(md5sum script_files/reval_tech.html.old | cut -d ' ' -f 1)> $hash_old
while read line;
do
hash_old_text=$line;
done < $hash_old

wget http://www.mu.ac.in/revaluation/revalfh13/reval_tech.html -O $reval_tech
echo $(md5sum script_files/reval_tech.html | cut -d ' ' -f 1)> $hash_new
while read line;
do
hash_new_text=$line
done < $hash_new

if [ "$hash_old_text" = "$hash_new_text" ] ;
then
	echo nothing changed as of now
	exit
else
	/bin/bash ./mailchanges.sh
	rm $hash_old
	cp $hash_new $hash_old
	rm $reval_tech_old 
	cp $reval_tech $reval_tech_old
	echo Starting Main Execution
	echo .
	echo .
	/bin/bash ./main.sh
fi
