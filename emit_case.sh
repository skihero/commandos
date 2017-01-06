#!/bin/bash 

#Define states  
OK=0
WARNING=1
UNKNOWN=2 
CRITICAL=3 
 
emit_value=5 
 
function emitter(){ 
	RANGE=4
	emit_value=$RANDOM
	let "emit_value%= $RANGE"
	return $emit_value
}

function response_txt(){ 
	emitter_response=$1 
	case $emitter_response in 
		0) 
		echo "OK" 
		;; 
		1) 
		echo "Warning"
		;; 
		2)
		echo "Unknown" 
		;; 
		3)
		echo "Critical" 
		;;
		*)
		echo "God knows"
		;;
	esac 
return 
}
 
 
for i in `seq 1 100` ; do 
	emitter
	response_txt $emit_value
done 

#END	
