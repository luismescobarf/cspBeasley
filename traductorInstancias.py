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


#Ejemplo para transferencia de líneas
# with open('path/to/input') as infile, open('path/to/output', 'w') as outfile:
#     copy = False
#     for line in infile:
#         if line.strip() == "Start":
#             outfile.write(line) # add this
#             copy = True
#         elif line.strip() == "End":
#             outfile.write(line) # add this
#             copy = False
#         elif copy:
#             outfile.write(line)



# encabezado = "VEHICLE 
# NUMBER     CAPACITY
#   32         100000

# CUSTOMER
# CUST NO.  XCOORD.    YCOORD.    DEMAND   READY TIME   DUE DATE   SERVICE TIME"

