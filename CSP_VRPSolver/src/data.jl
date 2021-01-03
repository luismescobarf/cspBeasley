import Base.show, Base.print
using DelimitedFiles

mutable struct Vertex
   id_vertex::Int
   pos_x::Float64
   pos_y::Float64
   service_time::Int
   demand::Int
   start_tw::Int
   end_tw::Int
end

# Directed graph
mutable struct InputGraph
   V′::Array{Vertex} # set of vertices
   A::Array{Tuple{Int64,Int64}} # set of edges
   cost::Dict{Tuple{Int64,Int64},Float64} # cost for each arc
   time::Dict{Tuple{Int64,Int64},Float64} # time for each arc
end

mutable struct DataVRPTW
   n::Int
   G′::InputGraph
   Q::Float64 # vehicle capacity
   K::Int #num vehicles available
   T::Float64 #Time consumption
end

# Euclidian distance
function distance(v1::Vertex, v2::Vertex)
   x_sq = (v1.pos_x - v2.pos_x)^2
   y_sq = (v1.pos_y - v2.pos_y)^2
   return floor(sqrt(x_sq + y_sq)*10)/10
end

# Tiempo de desplazamiento
function tiempo_cambio(v1::Vertex, v2::Vertex)
   return v2.start_tw - v1.end_tw
end

function readVRPTWData(path_file::String)

   #Mostrar la ruta recibida (diagnóstico)
   #println("Ruta recibida: ")
   #println(path_file)
   #readline()

   # STEP 1 : pushing data in a vector.
   data = Array{Any,1}()
   open(path_file) do file
      for line in eachline(file)
         if findfirst("CUST", line) != nothing || findfirst("VEH", line) != nothing || 
	    findfirst("NUMBER", line) != nothing
            continue
         end
         for peaceofdata in split(line)
            push!(data, String(peaceofdata))
         end
      end
   end

   n = div(length(data) - 3, 7) - 1
   K = parse(Int, data[2])
   Q = parse(Float64, data[3])
   T = 480 #Duración del turno en minutos
   #T = 1000

   vertices = Vertex[] 
   for i in 0:n
      offset = 3 + i*7
      x = parse(Float64, data[offset + 2])     
      y = parse(Float64, data[offset + 3])     
      d = parse(Int, data[offset + 4])     
      l = parse(Int, data[offset + 5])     
      u = parse(Int, data[offset + 6])     
      s = parse(Int, data[offset + 7])     
      push!(vertices, Vertex(i, x, y, s, d, l, u))
   end
  
   A = Tuple{Int64,Int64}[]
   cost = Dict{Tuple{Int64,Int64},Float64}()
   time = Dict{Tuple{Int64,Int64},Float64}()

   """
   #Mostrar archivo abierto
   open("/VRPTW/src/../data/100/csp50_costs.txt") do file
      for line in eachline(file)        
         for peaceofdata in split(line)
            #push!(data, String(peaceofdata))
            print(peaceofdata," ")
         end
         println()
      end
   end
   readline()
   """

   #Obtener los costos de los arcos factibles (Beasley)
   ###################################################

   #Extraer el nombre de la instancia para construir la ruta del archivo que contiene los costos
   nombreInstancia = split(last( split(path_file,"/")  ),"_")[1]
   nombreArchivoArcosInstancia = nombreInstancia * "_Solomon_costs.txt"   
   
   #Salida de diagnóstico
   #println("Arcos extraídos de------>>>>> "*nombreArchivoArcosInstancia)   
   
   #Cargar el costo de los arcos de los archivos correspondientes
   arcosBeasley = readdlm("/VRPTW/src/../data/beasleySolomonFormat/arcs/"*nombreArchivoArcosInstancia, ' ', Int, '\n')
   
   #Dimensiones del arreglo que recibió los arcos factibles y sus costos
   tuplaDimensiones = size(arcosBeasley)

   #Salida en pantalla de los arcos recibidos a través del archivo
   """
   for i in 1:tuplaDimensiones[1]
      for j in 1:tuplaDimensiones[2]
         println( arcosBeasley[i,j] )
      end
      println()
   end
   """

   #Función para agregar los carcos
   function add_arc!(i, j, costo)
      
      #Adicionarlo al conjunto de arcos A
      push!(A, (i,j)) 

      #Agregar costo y consumo de tiempo de forma genérica VRPTW
      #cost[(i,j)] = distance(vertices[i + 1], vertices[j + 1])  
      #time[(i,j)] = distance(vertices[i + 1], vertices[j + 1]) + vertices[i + 1].service_time 
      
      #Costo del cambio entre bloques de trabajo CSP (Beasley, 96)
      cost[(i,j)] = costo

      #Tiempo consumido al cambiar entre servicios, junto con el tiempo de servicio de i  
      if j == 0
         time[(i,j)] = 0#El retorno no consume tiempo (opcional en el modelamiento)
      elseif i == 0
         time[(i,j)] = vertices[j + 1].service_time
      else
         
         #Tiempo de cambio sin tener en cuenta el consumo de tiempo de los servicios
         #time[(i,j)] = tiempo_cambio(vertices[i + 1], vertices[j + 1])

         #Arco intermedio con todo el consumo de tiempo
         #time[(i,j)] = tiempo_cambio(vertices[i + 1], vertices[j + 1]) + vertices[i + 1].service_time + vertices[j + 1].service_time

         #Arco intermedio con consumo de tiempo de desplazamiento y del nodo terminal
         time[(i,j)] = tiempo_cambio(vertices[i + 1], vertices[j + 1]) + vertices[j + 1].service_time
         
         #Consumo de tiempo en el cambio de contexto y en el nodo de partida (infactibilidad en duración de turno al no ser tenido en cuenta el tiempo de servicio del último bloque)
         #time[(i,j)] = tiempo_cambio(vertices[i + 1], vertices[j + 1]) + vertices[i + 1].service_time
         
      end
   
   end

   #Adición de los arcos DataVRPTW
   """
   for i in 1:n
      #arc from depot
      add_arc!(0, i)
      #arc to depot
      add_arc!(i, 0)
      for j in 1:n
         if (i != j) 
            add_arc!(i, j)
         end
      end
   end
   """

   #Adicionar arcos relacionados con el depósito
   maximoRelativo = maximum(arcosBeasley)  
   for i in 1:n

      #arc from depot
      add_arc!(0, i, maximoRelativo * 2)
      #add_arc!(0, i, 0)#Alternativa sin costo de salida
      #add_arc!(0, i, maximoRelativo)#Mismo costo del máximo relativo entre bloques de trabajo

      #arc to depot
      add_arc!(i, 0, 0)#Costo cero de regreso, se deja abierto u opcional en CSP al tratarse de itinerarios y no de rutas      

   end  

   #Adición de los arcos Beasley CSP
   for i in 1:tuplaDimensiones[1]#Por cada uno de los arcos cargados
      
      #Adición de arcos entre servicios VRPTW
      """
      for j in 1:n
         if (i != j) 
            add_arc!(i, j)
         end
      end
      """

      #Arcos entre servicios (bloques de trabajo CSP)
      add_arc!(arcosBeasley[i,1], arcosBeasley[i,2], arcosBeasley[i,3])

   end
   
   #Mostrar resultado en pantalla (diagnóstico de los datos cargados)
   """
   println("Información Cargada")
   print(n)
   println("Información Cargada")
   print(vertices)
   println("Información Cargada")
   print(A)
   println("Información Cargada")
   print(cost)
   println("Información Cargada")
   print(time)   
   println("Información Cargada")
   print(Q)
   println("Información Cargada")
   print(K)
   readline()
   """
   DataVRPTW(n, InputGraph(vertices, A, cost, time), Q, K, T)
end
arcs(data::DataVRPTW) = data.G′.A # return set of arcs
function c(data,a) 
   if !(haskey(data.G′.cost, a)) 
      return Inf
   end
   return data.G′.cost[a] 
end     
function t(data,a) 
   if !(haskey(data.G′.time, a)) 
      return Inf
   end
   return data.G′.time[a] 
end     
n(data::DataVRPTW) = data.n # return number of requests
d(data::DataVRPTW, i) = data.G′.V′[i+1].demand # return demand of i
s(data::DataVRPTW, i) = data.G′.V′[i+1].service_time # return service time of i
l(data::DataVRPTW, i) = data.G′.V′[i+1].start_tw
u(data::DataVRPTW, i) = data.G′.V′[i+1].end_tw
veh_capacity(data::DataVRPTW) = Int(data.Q)

#Route duration
max_duration(data::DataVRPTW) = data.T

function lowerBoundNbVehicles(data::DataVRPTW) 
   return 1
end

function upperBoundNbVehicles(data::DataVRPTW) 
   return data.K
end
