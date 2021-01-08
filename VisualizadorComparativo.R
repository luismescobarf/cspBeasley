#Carga de paquetes
library("readxl", "tibble", "tidyverse")
#Lector de información
Comparaciones <- read_excel("/Users/kennycardenas/Desktop/Integra/Tesis RIB/ComparativoResultados_Integra_Beasley_VRPSolver.xlsx", sheet = "Comparativo")
n <- dim(Comparaciones)
n[1] -> nfilas
n[2] -> ncolumnas
Comparaciones <- Comparaciones[1:(nfilas-1),]
