#Librerías
import pprint as pp
import numpy as np
from cargadorSoluciones import *
from cargadorInstancias import *
       
    
#Sección Principal
#-----------------

#Entrada por lotes (pendiente)
#Entrada por lotes (pendiente)
#Entrada por lotes (pendiente)

#Entradas para una sola instancia
instancia = beasley('./instances/csp50.txt')	
solucion = solucionVRP_Solver('./solutions/sol_csp50.txt')


#Recorrer los itinerarios y revisar:
#-Traslapes de ventanas de tiempo
#-Duración total del turno
#-Número de conductores (opcional)

#Contenedor del reporte
reporte = {}
reporte['traslapes'] = { 'numero':0, 'tuplas':[] }
reporte['itinerariosExtensos'] = { 'numero':0, 'itinerarios':[] }
reporte['costoInterno'] = 0
reporte['costoCompleto'] = 0

#Contenedor de control de los itinerarios
listadoBloques = {}
for i in range(1,instancia['numBloques']+1):
    listadoBloques[i] = 0

#Por cada uno de los itinerarios
for itinerario in solucion[itinerarios]:
    
    #Acumulador de la duración del itinerario
    duracionItinerario = 0
    
    #Validar si se trata de un itinerario con bloque único
    if len(itinerario) == 1:
        duracionItinerario += instancia['bloques'][ itinerario[0] -1 ]
        
    
    
    #Por cada uno de los bloques del itinerario
    for i in range(len(itinerario)-1):
        
        itinerario
        
        
        listadoBloques[bloque] 
        
    





 

							


