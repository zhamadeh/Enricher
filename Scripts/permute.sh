#!/bin/bash

#total number of iterations
iteration=10



#initial interaction (no shuffling) count number of overlaps between BED files
bedtools intersect -a "$1" -b "$2" -u > Permutations/NoShuffle/${1##*/}trueOverlap.txt
x=$(wc -l < "Permutations/NoShuffle/${1##*/}trueOverlap.txt") 
echo "Iteration: 0/"$iteration "=" $x "overlaps" > Output/${2##*/}/${1##*/}${2##*/}nullDist.txt
echo "Iteration: 0/"$iteration "=" $x "overlaps"

#repeat shuffling and counting number of overlaps
for i in $(seq 1 $iteration)
	do 
		number=$(jot -r 1  2000000 50000000)
		echo "Random number between 2Mb and 50Mb ---  $number"
		
		bedtools shift -s $number -i $1 -g Anxilliary/chromLengths-gaps.bed > Permutations/${1##*/}shuffled.bed
		bedtools intersect -a Permutations/${1##*/}shuffled.bed -b "$2" -u > Permutations/${1##*/}permutation.txt
		
		y=$(wc -l < "Permutations/${1##*/}permutation.txt")
		echo "Iteration:" $i"/"$iteration "=" $y "overlaps" >> Output/${2##*/}/${1##*/}${2##*/}nullDist.txt
		echo "Iteration:" $i"/"$iteration "=" $y "overlaps" 
	done

Rscript Scripts/p-values.R ${1##*/} ${2##*/}

