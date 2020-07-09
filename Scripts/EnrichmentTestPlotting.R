#This script is for plotting out enrichment test results
suppressMessages(suppressWarnings(library(tidyverse)))
args = commandArgs(trailingOnly=TRUE)
#args="G4_K_minus"

#Loading the data
#create relative score by dividing by first entry value
dir = paste0("Output/",args[1])

objects = c()
for (i in list.files(dir,full.names = T)){
	permute <- read.table(i)
	permute$enrichment = permute$V4/mean(permute$V4)
	bed_name <- strsplit(strsplit(i,"/")[[1]][3],"[.]")[[1]][1]
	permute$gene=bed_name
	objects<- append(bed_name,objects)
	assign(bed_name,permute)
}

#binding all 4 dataframes together
true <- data.frame()
bind<- data.frame()

for (obj in objects){
	t<- get(obj)
	true <- rbind(t[1,],true)
	bind <- rbind(t[2:nrow(t),],bind)
}



#plotting
ggplot(bind)+geom_violin(aes(gene,enrichment,fill=gene),lwd=0.9) +
	geom_boxplot(width=0.05,aes(gene,enrichment),lwd=0.9) +
	#scale_fill_manual(values=c("#53b0db","#53b0db","#53b0db","#6ceb70"))+
	theme_classic(base_size = 19) +
	geom_point(data=true,aes(gene,enrichment),fill="red",colour="black",pch=21, size=5)+
	theme(legend.position = "none")  +
	labs(x="Cells",y="Enrichment")+
	ggsave(paste0("Plots/enrichmentPlot",args[1],".png"))




