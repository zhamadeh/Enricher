#Loading the data
args = commandArgs(trailingOnly=TRUE)
#args=c("wt.bed","G4_K_minus")


suppressMessages(suppressWarnings(library(tidyverse)))
permute <- read.table(paste0("Output/",args[2],"/",args[1],args[2],"nullDist.txt"))

#create relative score by dividing by first entry value
permute <- permute%>% mutate(enrichment = V4/mean(permute$V4)) 
null<- permute[2:nrow(permute),]

#mean of null distributtion (permutatiton values)
a <- mean(null$enrichment)
#sd of null distribution
s <- sd(null$enrichment)
#sample size of null distribution
#mean of sample (# of overlaps between 2 BED files)
xbar <- permute[1,6]
#z-score
z<- (xbar-a)/s
#p-value
p <- 2*pnorm(-abs(z))

write=data.frame(args[1],args[2],p)

write.table(write,paste0("P-values/p-values.txt"),append = T,row.names = F,col.names = F,quote = F)


if (p < 0.05){
	state <- (paste0("P-value for ",args[1]," and ", args[2]," : ",p," , ENRICHED"))
	print(noquote(state))
} else {state <- (paste0("P-value for ",args[1]," and ", args[2]," : ",p," , NOT ENRICHED"))
	print(noquote(state))
}


