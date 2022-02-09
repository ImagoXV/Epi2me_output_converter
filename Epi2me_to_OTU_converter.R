#Script propre de conversion Epi2me vers table OTU classique

#Chargement des donnees

epi2me_table <- read.csv("*.csv")

#Le vecteur contenant tous les barcodes + unclassified
Barcodes <- c("barcode01","barcode02","barcode03","barcode04","barcode05","barcode06","barcode07","barcode08","barcode09","barcode10","barcode11","barcode12","barcode13","barcode14","barcode15","barcode16","barcode17","barcode18","barcode19","barcode20","barcode21","barcode22","barcode23","barcode24", "unclassified")


#Créer une liste qui va contenir les species de chaque barcode et les regrouper 
Multi <- vector(mode='list', length=25)

names(Multi) <- Barcodes


#Separe chasue barcode et le place dans la liste avec un format pratiquable
for(i in 1:length(Barcodes)){
  Multi[[i]] <- data.frame(table(epi2me_table[epi2me_table$barcode==Barcodes[i],7]))
  if(ncol(Multi[[i]])==2){
    colnames(Multi[[i]]) <- c("Species", Barcodes[i])
  }
}


library(data.table)
#Tente de réunir toutes ces inform  atioons pour faire une table d'abondance 
mg <- merge(Multi[[1]],Multi[[2]], by = "Species", all = TRUE )
for(i in 3:length(Barcodes)){
  if(ncol(Multi[[i]])==2){
    mg <- merge(mg, Multi[[i]], by = "Species", all = TRUE )
  } else {
    df<- data.frame(mg[,1],NA)
    colnames(df) <- c("Species", Barcodes[i])
    mg <- merge(mg, df, by = "Species", all = TRUE )
  }
  
}

#Retourne un csv d'otu normalement correct
write.csv(mg, file = "Epi2me_OTU_table.csv") 




