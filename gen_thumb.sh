for fil in `ls *.jpg`  ; 
do  name=${fil%.*}; 
convert -thumbnail 200 $fil ${name}_thumb.jpg; 
done 
