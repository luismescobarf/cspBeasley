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
solucion = solucionVRP_Solver('./solutions/vrpSolver_csp50.txt')#Solución sospecha infactible, 24 itinerarios
#solucion = solucionVRP_Solver('./solutions/sol_csp50.txt')#Solución sospecha infactible, 24 itinerarios
#solucion = solucionVRP_Solver('./solutions/sol_csp50_b.txt')#Solución VRPSolver tiempos de servicio corregidos, 27 itinerarios
#solucion = solucionVRP_Solver('./solutions/sol_csp50_modeloPropuesto.txt')#Solución mesquita92+borcinova17, 27 itinerarios

#Preparar encabezado de la instancia
nombreInstancia = instancia['nombreInstancia'].split('/')[-1].split('.')[0]
nombreInstanciaExtension = nombreInstancia + '_Solomon.txt'
try:
    
    with open('./encabezado.txt') as encabezado, open('./beasleySolomonFormat/'+nombreInstanciaExtension, 'w') as nuevaInstanciaSolomon:
        
        #Agregar el nombre del caso de prueba en la primera línea
        nuevaInstanciaSolomon.write(nombreInstancia)
        
        #Agregar todas las líneas del encabezado
        for linea in encabezado:
            nuevaInstanciaSolomon.write(linea)   
        
except:
    print('Problemas abriendo el encabezado o el archivo de salida con la instancia en formato Solomon')


#Insertar información de los nodos (bloques de servicio)



#Generar el archivo con los costos de los arcos (transiciones factibles)

