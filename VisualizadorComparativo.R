####Carga de paquetes###
library("readxl") 
library("tibble") 
library("tidyverse")
library("shiny")
library("ggplot2")
####Lector de información###
Comparaciones <- read_excel("/Users/kennycardenas/Desktop/Integra/Tesis RIB/ComparativoResultados_Integra_Beasley_VRPSolver.xlsx", sheet = "Comparativo")
n <- dim(Comparaciones)
n[1] -> nfilas
n[2] -> ncolumnas
Comparaciones <- Comparaciones[1:(nfilas-9),]
#Nombre de la instancia
Comparaciones$Instancias <- c(apply(Comparaciones[,1:2] , 1 , paste , collapse = "-"))
#Borrar las columnas que tienen estas indicaciones
Comparaciones <- Comparaciones[,3:ncol(Comparaciones)]
#Separar tablas de diferentes casos
#Beasly96
Beasly96 <- Comparaciones[,1:4]
names(Beasly96) <- c(Beasly96[2,1:4])
Beasly96 <- Beasly96[3:nrow(Beasly96),]
Beasly96[,1:4]<-apply(Beasly96[,1:4],2,as.numeric)
#VRPSolver19
VRPSolver19 <- Comparaciones[,5:8]
names(VRPSolver19) <- c(VRPSolver19[2,1:4])
VRPSolver19 <- VRPSolver19[3:nrow(VRPSolver19),]
VRPSolver19[,1:4]<- apply(VRPSolver19[,1:4],2,as.numeric)
#VRPSolver19 con k fijo de Beasly96
VRPSolver19KB96 <- cbind(Comparaciones[,9:12])
names(VRPSolver19KB96) <- c(VRPSolver19KB96[2,1:4])
VRPSolver19KB96 <- VRPSolver19KB96[3:nrow(VRPSolver19KB96),]
VRPSolver19KB96[,1:4]<- apply(VRPSolver19KB96[,1:4],2,as.numeric)
#VRPSolver19 con Min k
VRPSolver19Mink <- cbind(Comparaciones[,13:16])
names(VRPSolver19Mink) <- c(VRPSolver19Mink[2,1:4])
VRPSolver19Mink <- VRPSolver19Mink[3:nrow(VRPSolver19Mink),] 
VRPSolver19Mink[,1:4]<- apply(VRPSolver19Mink[,1:4],2,as.numeric)
#Bolaños20 Heuristica
Bolanos20H <- cbind(Comparaciones[,17:20])
names(Bolanos20H) <- c(Bolanos20H[2,1:4])
Bolanos20H <- Bolanos20H[3:nrow(Bolanos20H),] 
Bolanos20H[,1:4]<- apply(Bolanos20H[,1:4],2,as.numeric)
#Bolaños20 Modelo inicializado
Bolanos20M <- cbind(Comparaciones[,21:25])
names(Bolanos20M) <- c(Bolanos20M[2,1:5])
Bolanos20M <- Bolanos20M[3:nrow(Bolanos20M),] 
Bolanos20M[,1:5]<- apply(Bolanos20M[,1:5],2,as.numeric)
#Bolaños con cortes en K
Bolanos20CortesK <- cbind(Comparaciones[,26:29])
names(Bolanos20CortesK) <- c(Bolanos20CortesK[2,1:4])
Bolanos20CortesK <- Bolanos20CortesK[3:nrow(Bolanos20CortesK),] 
Bolanos20CortesK[,1:4]<- apply(Bolanos20CortesK[,1:4],2,as.numeric)
#Primer comparación Beasly 96 con VRPSolver 19 resolviendo Beasly 96
TiemposPC <- data.frame(c(Beasly96$`Tiempo Cómputo Total (segundos)`, VRPSolver19KB96$`Tiempo Cómputo Total (segundos)`), (c(rep("Beasly96",10),rep("VRPSolver19KB96",10))))
TiemposPC$Instancia <- c(50,100,150,200,250,300,350,400,450,500)
names(TiemposPC)<- c("CPUTime", "Metodologia", "Instancia")
ggplot(TiemposPC, aes(Instancia, CPUTime, color = factor(Instancia), shape = Metodologia),labels= Metodologia, colors = Metodologia)+scale_y_log10()+geom_point(size = 4, alpha = 0.8)  + 
   xlab('Instancias (turnos)') + ylab("Tiempo Cómputo Total (segundos)")
  
