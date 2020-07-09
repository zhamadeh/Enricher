#!/bin/bash

for query in BED-Query/*
do

	for file in BED-Input/*
	do

	  echo "********** Running enrichment: ${file##*/} against ${query##*/} *************"
	  sh Scripts/permute.sh $file $query

	done
	Rscript Scripts/EnrichmentTestPlotting.R "${query##*/}" 
done



