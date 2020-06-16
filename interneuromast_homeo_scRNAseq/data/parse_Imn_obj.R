library(Seurat)
library(ggplot2)

setwd("/home/ntran2/bgmp/shiny-apps-main/interneuromast_homeo_scRNAseq/data/")

obj_integrated <- readRDS("./scaled.filtered_adj_fpkm_1828_smartseq_integ.RDS")

files <- list.files(".", pattern = ".RDS", full.names = TRUE)

file_list <- list()

print("Loading Seurat objects...")
for (i in 1:length(files)) {
  file_list[[i]] <- readRDS(files[i])
  print(object.size(file_list[[i]]), units = "MB")
  
  DefaultAssay(file_list[[i]]) <- "RNA"
  file_list[[i]] <- subset(file_list[[i]], idents = "Inm" , subset = seq.method == "10X")
  file_list[[i]] <- ScaleData(file_list[[i]], features = rownames(file_list[[i]]))
  file_list[[i]] <- RunPCA(file_list[[i]])
  file_list[[i]] <- FindNeighbors(file_list[[i]], dims = 1:10)
  file_list[[i]] <- FindClusters(file_list[[i]], resolution = 0.6)
  file_list[[i]] <- RunUMAP(file_list[[i]], dims = 1:10)
  print(object.size(file_list[[i]]), units = "MB")
  
}

DimPlot(file_list[[1]])

head(file_list[[1]][["RNA"]]@counts)

DoHeatmap(file_list[[1]], features = "wnt2")