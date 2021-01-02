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
        
        #Agregar las líneas del encabezado
        for linea in encabezado:
            nuevaInstanciaSolomon.write(linea)            
            
        #Insertar información de los nodos (bloques de servicio)
        cuatroEspacios = '    '
        seisEspacios = '      '
        nueveEspacios = '         '
        coordenadaVirtualBloque_XY = 1 
        
        #Insertar la información del depósito virtual
        
        
        
        #Realizar el proceso para los nodos (bloques de trabajo o servicios)
        for i in range(1,instancia['numBloques']+1):
            
            #Contenedor de la línea que se va a insertar
            linea = str()
            
            #Número de cliente
            linea += cuatroEspacios + str(i)
            
            #Coordenada en x
            linea += seisEspacios + str(coordenadaVirtualBloque_XY) 
            
            #Coordenada en y
            linea += seisEspacios + str(coordenadaVirtualBloque_XY) 
            
            #Demanda (valor unitario, virtual)
            linea += seisEspacios + str(1) 
            
            #Ready Time
            
            
            #Due Date
            
            #Service Time
            
            #Mover coordenadas
            coordenadaVirtualBloque_XY += 1
            
            
            
                  
        #Generar el segundo archivo de la instancia, con los costos de los arcos (transiciones factibles)
        
except:
    print('Problemas abriendo el encabezado o el archivo de salida con la instancia en formato Solomon')






