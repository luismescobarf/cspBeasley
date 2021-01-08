#Carga de paquetes
library("readxl", "tibble", "tidyverse")
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



