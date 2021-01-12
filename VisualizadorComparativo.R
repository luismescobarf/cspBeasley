#Carga de paquetes
library("readxl", "tibble", "tidyverse","shiny")
#Lector de información
Comparaciones <- read_excel("/Users/kennycardenas/Desktop/Integra/Tesis RIB/ComparativoResultados_Integra_Beasley_VRPSolver.xlsx", sheet = "Comparativo")
n <- dim(Comparaciones)
n[1] -> nfilas
n[2] -> ncolumnas
Comparaciones <- Comparaciones[1:(nfilas-1),]
#Nombre de la instancia
Comparaciones$Instancias <- c(apply(Comparaciones[,1:2] , 1 , paste , collapse = "-"))
#Borrar las columnas que tienen estas indicaciones
Comparaciones <- Comparaciones[,3:ncol(Comparaciones)]
#Separar tablas de diferentes casos
#Beasly96
Beasly96 <- cbind(Comparaciones[,1:4], Comparaciones$Instancias)
names(Beasly96) <- c(Beasly96[2,1:4], "Instancias")
Beasly96 <- Beasly96[3:nrow(Beasly96),]
#VRPSolver19
VRPSolver19 <- cbind(Comparaciones[,5:8],Comparaciones$Instancias)
names(VRPSolver19) <- c(VRPSolver19[2,1:4], "Instancias")
VRPSolver19 <- VRPSolver19[3:nrow(VRPSolver19),]
#VRPSolver19 con k fijo de Beasly96
VRPSolver19KB96 <- cbind(Comparaciones[,9:12],Comparaciones$Instancias)
names(VRPSolver19KB96) <- c(VRPSolver19KB96[2,1:4], "Instancias")
VRPSolver19KB96 <- VRPSolver19KB96[3:nrow(VRPSolver19KB96),]
#VRPSolver19 con Min k
VRPSolver19Mink <- cbind(Comparaciones[,13:16],Comparaciones$Instancias)
names(VRPSolver19Mink) <- c(VRPSolver19Mink[2,1:4], "Instancias")
VRPSolver19Mink <- VRPSolver19Mink[3:nrow(VRPSolver19Mink),] 
#Bolaños20 Heuristica
Bolanos20H <- cbind(Comparaciones[,17:20],Comparaciones$Instancias)
names(Bolanos20H) <- c(Bolanos20H[2,1:4], "Instancias")
Bolanos20H <- Bolanos20H[3:nrow(Bolanos20H),] 
#Bolaños20 Modelo inicializado
Bolanos20M <- cbind(Comparaciones[,21:25],Comparaciones$Instancias)
names(Bolanos20M) <- c(Bolanos20M[2,1:5], "Instancias")
Bolanos20M <- Bolanos20M[3:nrow(Bolanos20M),] 
#Bolaños con cortes en K
Bolanos20CortesK <- cbind(Comparaciones[,26:29],Comparaciones$Instancias)
names(Bolanos20CortesK) <- c(Bolanos20CortesK[2,1:4], "Instancias")
Bolanos20CortesK <- Bolanos20CortesK[3:nrow(Bolanos20CortesK),] 
