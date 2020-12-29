#Librerías
#import pprint as pp
#import numpy as np

#Función para cargar la solución generada por 
def solucionVRP_Solver(ruta):    
    
    #Preparación del contenedor tipo diccionario que recibirá la solución
    solucion = {}
    solucion['itinerarios'] = []
    solucion['numItinerarios'] = int()
    solucion['costo'] = float()
    solucion['nombreInstancia'] = str(ruta)#Nombre del caso de la librería    
    
    #Valor grande para costos prohibitivos
    M = 100000000
    solucion['M'] = M#Cargar infactibilidad en el contenedor de la solución
    
    #Intentar abrir el archivo que contiene la solución
    try:
        
        #Ciclo general del recorrido del archivo mientras está abierto
        with open(ruta) as manejadorArchivo: 
            
            #Contador de líneas
            contadorLineas = 0           
         
            #Recorrer cada línea
            for linea_n in manejadorArchivo:
                
                #Cargar línea, limpiar caracteres especiales y volverlo un arreglo
                linea_n = linea_n.strip()
                linea_n = linea_n.split(' ')
                
                #Obtener de la primera línea el número de itinerarios (turnos)
                if not(contadorLineas):                    
                    solucion['numItinerarios'] = int(linea_n[0])                     
                elif(contadorLineas <= solucion['numItinerarios']):                                      
                    solucion['itinerarios'].append( list(map(lambda x:int(x),linea_n[2:])) )                                           
                else:
                    solucion['costo'] = float(linea_n[1])
                                            
                #Actualizar el contador de líneas
                contadorLineas += 1           
            
    except:
         return 'Error en la carga del archivo que contiene la solución CSP!!'     
    	       
    
    #Retornar la instancia que se ha cargado
    return solucion 
       
    
#Llamados de diagnóstico
#-----------------------

#solucion = solucionVRP_Solver('./solutions/sol_csp50.txt')	
	


