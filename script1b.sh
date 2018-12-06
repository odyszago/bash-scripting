#!/bin/bash
function Simul(){
	 con=$(wget $line1 -q -O - )
	 ans=$?
	 l=${line1##*\//}
	 l="${l////\\}"
	 if [ $ans -eq 0 ];then
	    if [ ! -f "$l".txt ];then
		    echo "$line1 INIT"
		    echo $con > "$l".txt
	     else
		 echo $con > "TEST".txt
   	        if cmp -s "$l".txt "TEST".txt; then	
			rm "TEST".txt
		     else
			     echo "$line1"
			     echo $con > "$l".txt
			     rm "TEST".txt
		     
		     fi
	   
	   
	   
	    fi
	  else
		echo "NOT VALID" > "$l".txt
      	       >&2 echo "$line1 FAILED"
	  fi

  }
grep "^[^#*]" $1 > ts.txt
for line1 in $(cat ts.txt);
  do
	  Simul $line1 &

done <ts.txt
wait
rm ts.txt

