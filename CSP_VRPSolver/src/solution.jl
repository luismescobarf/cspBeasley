import Base.show, Base.print

mutable struct Solution
   cost::Float64
   routes::Array{Array{Int}}
end

# build Solution from the variables x
function getsolution(data::DataVRPTW, x, objval, optimizer)
   A, dim = arcs(data), n(data)+1
   adj_list = [[] for i in 1:dim] 
   for a in A
      val = get_value(optimizer, x[a])
      if val > 0.5
         push!(adj_list[a[1]+1], a[2])
      end
   end
   visited, routes = [false for i in 2:dim], []
   for i in adj_list[1]
      if !visited[i]
         r, prev = [], 0
         push!(r, i)
         visited[i] = true
         length(adj_list[i+1]) != 1 && error("Problem trying to recover the route from the x values. "*
                                             "Customer $i has $(length(adj_list[i+1])) outcoming arcs.")
         next, prev = adj_list[i+1][1], i
         maxit, it = dim, 0
         while next != 0 && it < maxit
            length(adj_list[next+1]) != 1 && error("Problem trying to recover the route from the x values. "* 
                                                   "Customer $next has $(length(adj_list[next+1])) outcoming arcs.")
            push!(r, next)
            visited[next] = true
            aux = next
            next, prev = adj_list[next+1][1], aux
            it += 1
         end
         (it == maxit) && error("Problem trying to recover the route from the x values. "*
                                "Route cannot be recovered because the return to depot is never reached")
         push!(routes, r)
      end
   end 
   !isempty(filter(y->y==false,visited)) && error("Problem trying to recover the route from the x values. "*
                              "At least one vertex was not visited or there are subtours in the solution x.")

   return Solution(objval, routes)
end

function print_routes(solution)
   
   #Salida de diagnóstico
   #print("Haciendo Pruebas!!!")
   #print("\n")

   for (i,r) in enumerate(solution.routes)
      print("Route #$i: ")
      for j in r
         print("$j ")
      end
      println()
   end
end

contains(p, s) = findnext(s, p, 1) != nothing
# read solution from file
function readsolution(solpath)
   str = read(solpath, String)
   breaks_in = [' '; ':'; '\n';'\t';'\r']
   aux = split(str, breaks_in; limit=0, keepempty=false) 
   sol = Solution(0, [])
   j = 3
   while j <= length(aux)
      r = []
      while j <= length(aux)
         push!(r, parse(Int, aux[j]))
         j += 1
         if contains(lowercase(aux[j]), "cost") || contains(lowercase(aux[j]), "route")
            break
         end
      end
      push!(sol.routes, r)
      if contains(lowercase(aux[j]), "cost")
         sol.cost = parse(Float64, aux[j+1])
         return sol
      end
      j += 2 # skip "Route" and "#j:" elements
   end
   error("The solution file was not read successfully. This format is not recognized.")
   return sol
end

# write solution in a file
function writesolution(solpath, solution)   
   open(solpath, "w") do f
      numeroItinerariosObtenidos = size(solution.routes)[1]
      write(f, "$numeroItinerariosObtenidos\n")
      for (i,r) in enumerate(solution.routes)
         write(f, "Route #$i: ")
         for j in r
            write(f, "$j ") 
         end
         write(f, "\n")
      end
      write(f, "Cost $(solution.cost)\n")
   end
end

# write solution as TikZ figure (.tex) 
function drawsolution(tikzpath, data, solution)
   open(tikzpath, "w") do f
      write(f,"\\documentclass[crop,tikz]{standalone}\n")
      write(f, "\\usetikzlibrary{arrows}\n\\usetikzlibrary{shapes.geometric}\n\\usetikzlibrary {positioning}"*
               "\n\\pgfdeclarelayer{back}\n\\pgfsetlayers{back,main}\n\\makeatletter\n\\pgfkeys{%"*
               "\n/tikz/on layer/.code={\n\\def\\tikz@path@do@at@end{\\endpgfonlayer\\endgroup\\tikz@path@do@at@end}%"*
               "\n\\pgfonlayer{#1}\\begingroup%\n }%\n}\n\\makeatother\n\\begin{document}\n")

      # get limits to draw
      pos_x_vals = [i.pos_x for i in data.G′.V′]
      pos_y_vals = [i.pos_y for i in data.G′.V′]
      scale_fac = 1/(max(maximum(pos_x_vals),maximum(pos_y_vals))/10)
      write(f,"\\begin{tikzpicture}[thick, scale=1, every node/.style={minimum size=0.6cm, scale=0.4}, triangle/.style = {fill=white, regular polygon, regular polygon sides=6, scale=1.1, inner sep=0cm}]\n")
      for i in data.G′.V′
         x_plot, y_plot = scale_fac*i.pos_x, scale_fac*i.pos_y
         if i.id_vertex == 0 # plot depot
            write(f, "\t\\node[draw, line width=0.1mm, rectangle, fill=yellow, inner sep=0.05cm, scale=0.9] (v$(i.id_vertex)) at ($(x_plot),$(y_plot)) {\\footnotesize $(i.id_vertex)};\n")
         elseif i.id_vertex <= n(data)
            write(f, "\t\\node[draw, line width=0.1mm, circle, fill=white, inner sep=0.05cm] (v$(i.id_vertex)) at ($(x_plot),$(y_plot)) {\\footnotesize $(i.id_vertex)};\n")
         else
            write(f, "\t\\node[draw, line width=0.1mm, triangle, fill=white] (v$(i.id_vertex)) at ($(x_plot),$(y_plot)) {\\footnotesize $(i.id_vertex)};\n")
         end
      end
      write(f, "\\begin{pgfonlayer}{back}\n")
      for (idr,r) in enumerate(solution.routes)
         prev = 0
         for i in r
            a = (prev,i)
            edge_style = (prev == 0 || i == 0) ? "dashed,line width=0.2pt,opacity=.4" : "line width=0.4pt"
            write(f, "\t\\path[->,$(edge_style)] (v$(a[1])) edge node {} (v$(a[2]));\n")
            prev = i
         end
         write(f, "\t\\path[->,dashed,line width=0.2pt,opacity=.4] (v$prev) edge node {} (v0);\n")
      end
      write(f, "\\end{pgfonlayer}\n\\end{tikzpicture}\n")
      write(f, "\\end{document}\n")
   end
end


# write solution as graphviz (.dot) 
function drawsolutionDOT(dotpath, data, solution)

   #Preparar información de los arcos
   #A, dim = arcs(data), n(data)+1
   A = arcs(data)  
   #@objective(vrptw.formulation, Min, sum(c(data,a) * x[a] for a in A))

   #Crear/abrir el archivo para descargar la solución obtenida
   open(dotpath, "w") do f

      #Generar cabecera del archivo
      write(f,"digraph D {\n")
		write(f,"rankdir=LR\n")
		write(f,"size=\"4,3\"\n")
		write(f,"ratio=\"fill\"\n")		
		write(f,"node[color=\"black\",shape=\"square\",fillcolor=\"darkseagreen3\",style=\"filled\"]")
		write(f,"\n 0")
		write(f,"\n N1")
      write(f,"\n node[color=\"black\",shape=\"circle\",style=\"\"]")
      
      #Líneas de separación en el archivo del grafo para inspección visual
      write(f,"\n \n");      

      ##Dibujar los arcos generados por la solución
      write(f,"edge[style=\"solid\"]\n")#Estilo de los arcos solución

      #Por cada uno de los itinerarios de la solución
      for (idr,r) in enumerate(solution.routes) 

         prev = 0 #Bloque de trabajo previo en el itinerario

         for i in r #Por cada uno de los bloques de trabajo del itinerario
            
            #Restaurar estilo para cada arco antes de diferenciar si es inicial o intermedio
            write(f,"edge[style=\"solid\"]\n")
                        
            #Construir la tupla que contiene el arco que se va a dibujar
            a = (prev,i)

            #Obtener información de la etiqueta de la arista
            costoTransicion = c(data,a)
            tiempoTransicion = t(data,a)

            #Definir estilo del arco (salida o regreso)
            if (prev == 0 || i == 0) #Arco de inicio o finalización de itinerario

               #Arista que llega al depósito               
               if i == 0 #if(j==num+1){                  
                  write(f,"$(a[1])->N1")#dot_file<<i<<"->N1";
               else
                  #Arista que sale del depósito
                  write(f,"0->$(a[2])")#dot_file<<i<<"->"<<j;                  
               end

               #Adicionar etiqueta de la arista               
               write(f,"[label=\"c=$costoTransicion,t=$tiempoTransicion\",") #dot_file<<"[label=\"c="<<costoTransicion<<",t="<<tiempoTransicion<<"\",";
     
               #Alternativas de color
               write(f,"color=\"darkseagreen3\"] \n")#dot_file<<"color=\"darkseagreen3\"]"<<endl;//Salidas del depósito
               #write(f,"color=\"darkorange2\"] \n")#dot_file<<"color=\"darkorange2\"]"<<endl;//Salidas del depósito
                                                            
            else #Arco intermedio (conexión entre bloques de trabajo)                             

               #Encabezado de las cadenas              
               write(f,"$(a[1])->$(a[2])")#dot_file<<i<<"->"<<j

               #Etiqueta
               write(f,"[label=\"c=$costoTransicion,t=$tiempoTransicion\",")#dot_file<<"[label=\"c="<<costoTransicion<<",t="<<tiempoTransicion<<"\",";                              
               
               #Establecer color si es factible o no       
               if (costoTransicion != 100000000)
                  write(f,"color=\"dodgerblue2\"] \n") #dot_file<<"color=\"dodgerblue2\"]"<<endl;//Transiciones de cadena o turno				
               else
                  write(f,"color=\"red\",style=\"dotted\"] \n") #dot_file<<"color=\"red\",style=\"dotted\"]"<<endl;//Transiciones ilegales
               end
               

            end           
            
            #Actualizar el nodo previo para el siguiente arco
            prev = i

         end
         
      end      

		#Cierre del archivo graphviz (.dot)		
      write(f,"}")

   end#Cierre del archivo graphviz (.dot)

end#Cierre de la función