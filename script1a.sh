#!/bin/bash
grep "^[^#*]" $1 > ts.txt
for line in $(cat ts.txt); 
  do
	 con=$(wget $line -q -O - )
	 ans=$?
	 l=${line##*\//}
	 l="${l////\\}"
	 if [ $ans -eq 0 ];then
	    if [ ! -f "$l".txt ];then
		    echo "$line INIT"
		    echo $con > "$l".txt
	     else
		 echo $con > "TEST".txt
   	        if cmp -s "$l".txt "TEST".txt; then	
			rm "TEST".txt
		     else
			     echo "$line"
			     echo $con > "$l".txt
			     rm "TEST".txt
		     
		     fi
	   
	   
	   
	    fi
	  else
		echo "NOT VALID" > "$l".txt
		>&2 echo "$line FAILED"
	  fi
done < ts.txt
rm ts.txt

