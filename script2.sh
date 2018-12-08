#!/bin/bash
fname=$1
if [ -f $fname ]; then
	cd ~
	if [ ! -d gitOdys2902 ]; then
		mkdir gitOdys2902
	fi
	tar -zxvf $fname -C gitOdys2902 > /dev/null
	cd ~
	find gitOdys2902 -type f -name "*.txt" > ts.txt
	if [ ! -d assignments ]; then
		mkdir assignments
	fi
	for line in $(cat ts.txt);
	do	
		cat $(find $line) > ts1.txt 
		for i in $(cat ts1.txt);
		do
	         if [[ $i == http* ]]; then
			cd assignments
			git clone --quiet $i > /dev/null 2>&1
			if [ $? -eq 0 ]; then
				echo "$i Cloning  OK"
			else
				>&2 echo "$i Cloning FAILED"
			fi
			cd ..
		        break
		fi
		done	
		rm ts1.txt
	done
	rm ts.txt
	cd assignments
	touch tsAssign.txt
	for d in $(find . -maxdepth 1 -type d) ; do
		d=${d##*\.}
		d=${d##*\/}
		echo $d >> tsAssign.txt
	   
	done
	for line in $(cat tsAssign.txt);
	do
		cd $line
		find . -not -path '*/\.*' -type d > "d$line".txt
		find . -not -path '*/\.*' | grep  ".txt"  > "f$line".txt
		find . -not -path '*/\.*'  -type f ! -name "*.txt" > "f1$line".txt
		grep -vwE "(d$line|f$line|f1$line|f2$line)" "f$line".txt > "f2$line".txt
		c1=$(cat "f2$line".txt | wc -l)
		c2=$(cat "f1$line".txt | wc -l)
		cdr=$(cat "d$line".txt | wc -l)
		cdr=$((cdr-1))
		echo "$line:"
		echo "Number of directories : $cdr"
		echo "Number of txt files : $c1"
		echo "Number of other files : $c2"
		rm "f1$line".txt
		rm "f$line".txt
		rm "d$line".txt
		rm "f2$line".txt
		if [ "$cdr" -eq "1" ] && [ "$c1" -eq "3" ] && [ "$c2" -eq "0" ]; then
			a=$(find . -maxdepth 1 -type f | wc -l)
			if [ "$a" -eq "1" ] && [ -f "dataA".txt ]; then
				b=$(find . -maxdepth 1 -type d | wc -l)
				b=$((b-1))
				if [ "$b" -eq "1" ] && [ -d more ]; then
					cd more
					a=$(find . -maxdepth 1 -type f | wc -l)
					if [ "$a" -eq "2" ] && [ -f "dataB".txt ] && [ -f "dataC".txt ]; then
						echo "Directory structure is OK"
					else
					   >&2  echo "Directory structure is not OK"	
					
					fi
					cd ..
				else
				>&2	echo "Directory structure is not Ok"
				fi
			else
			>&2	echo "Directory structure is not OK"
		       	fi	       
		else
		 >&2	echo "Directory structure is not OK"
	       	fi	       
					
		cd ..
	done
	rm tsAssign.txt
	cd ..
	rm -r gitOdys2902

else
	echo "Wrong input. The files does not exist . At least in current directory"
fi

