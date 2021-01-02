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
nombreInstanciaCostoArcosExtension = nombreInstancia + '_Solomon_costs.txt'
try:
    
    with open('./encabezado.txt') as encabezado, open('./beasleySolomonFormat/nodes/'+nombreInstanciaExtension, 'w') as nuevaInstanciaSolomon, open('./beasleySolomonFormat/arcs/'+nombreInstanciaCostoArcosExtension, 'w') as nuevaInstanciaSolomonArcos:
        
        #Agregar el nombre del caso de prueba en la primera línea
        nuevaInstanciaSolomon.write(nombreInstancia)
        
        #Agregar las líneas del encabezado
        for linea in encabezado:
            nuevaInstanciaSolomon.write(linea)            
            
        #Insertar información de los nodos (bloques de servicio)
        cuatroEspacios = '    '
        seisEspacios = '      '
        nueveEspacios = '         '
        coordenadaVirtualBloque_XY = 0 
        
        #Insertar la información del depósito virtual
        lineaDepositoVirtual = str()
        #Número de cliente
        lineaDepositoVirtual += cuatroEspacios + str(0) 
        #Coordenada en x
        lineaDepositoVirtual += seisEspacios + str(coordenadaVirtualBloque_XY)
        #Coordenada en y
        lineaDepositoVirtual += nueveEspacios + str(coordenadaVirtualBloque_XY)
        #Demanda (nada en el depósito)
        lineaDepositoVirtual += nueveEspacios + str(0) 
        #Ready Time
        lineaDepositoVirtual += nueveEspacios + str(0)
        #Due Date
        lineaDepositoVirtual += nueveEspacios + str(0)
        #Service Time
        lineaDepositoVirtual += nueveEspacios + str(0)
        #Insertarla al archivo donde se está almacenando la instancia
        nuevaInstanciaSolomon.write(lineaDepositoVirtual+'\n')
        
        #Mover coordenadas
        coordenadaVirtualBloque_XY += 1
        
        #Realizar el proceso para los nodos (bloques de trabajo o servicios)
        for i in range(1,instancia['numBloques']+1):
            
            #Contenedor de la línea que se va a insertar
            lineaNodo = str()
            
            #Número de cliente
            lineaNodo += cuatroEspacios + str(i)
            
            #Coordenada en x
            lineaNodo += seisEspacios + str(coordenadaVirtualBloque_XY) 
            
            #Coordenada en y
            lineaNodo += nueveEspacios + str(coordenadaVirtualBloque_XY) 
            
            #Demanda (valor unitario, virtual)
            lineaNodo += nueveEspacios + str(1) 
            
            #Ready Time
            lineaNodo += nueveEspacios + str( instancia['bloques'][i-1]['t0'] )         
                        
            #Due Date
            lineaNodo += nueveEspacios + str( instancia['bloques'][i-1]['tf'] )         
            
            #Service Time
            lineaNodo += nueveEspacios + str( instancia['bloques'][i-1]['duracion'] )         
            
            #Insertarla al archivo donde se está almacenando la instancia
            nuevaInstanciaSolomon.write(lineaNodo+'\n')
            
            #Mover coordenadas
            coordenadaVirtualBloque_XY += 1           
                  
        #Generar el segundo archivo de la instancia, con los costos de los arcos (transiciones factibles)
        for transicion in instancia['transiciones']:
            
            #Contenedor de las líneas con el detalle de las transiciones
            lineaTransicion = str()
            
            #Incorporar los detalles provenientes del contenedor de la instancia
            lineaTransicion += str(transicion['i']) + ' ' + str(transicion['j']) + ' ' + str(transicion['costo'])
            
            #Insertarla al archivo donde se está almacenando la instancia
            nuevaInstanciaSolomonArcos.write(lineaTransicion+'\n')
        
except:
    print('Problemas abriendo el encabezado o el archivo de salida con la instancia en formato Solomon')






