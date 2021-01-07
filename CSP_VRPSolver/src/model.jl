function build_model(data::DataVRPTW, app)

   A = arcs(data) 
   V = [i for i in 1:n(data)] 
   Q = veh_capacity(data)
   T = max_duration(data)

   #K mínimo para cada instancia de Beasley
   K_Beasley = Dict{String,Int64}()
   K_Beasley["csp50"] = 27
   K_Beasley["csp100"] = 44
   K_Beasley["csp150"] = 69
   K_Beasley["csp200"] = 93
   K_Beasley["csp250"] = 108
   K_Beasley["csp300"] = 130
   K_Beasley["csp350"] = 144
   K_Beasley["csp400"] = 159
   K_Beasley["csp450"] = 182
   K_Beasley["csp500"] = 204

   #Obtener el K mínimo de Beasley para el caso que se está solucionando
   nombreInstancia = split(last( split(app["instance"],"/")  ),"_")[1]

   # Formulation
   vrptw = VrpModel()
   @variable(vrptw.formulation, x[a in A], Int)   
   @objective(vrptw.formulation, Min, sum(x[a] for a in A if a[1] == 0))#FO Minimizando únicamente número de empleados
   #@objective(vrptw.formulation, Min, sum(c(data,a) * x[a] for a in A))#FO Minimizando costos y número de empleados   
   @constraint(vrptw.formulation, indeg[i in V], sum(x[a] for a in A if a[2] == i) == 1.0)

   #Restricción para fijar el modelo al valor de K mínimo presentado en (Beasley,96)
   #@constraint(vrptw.formulation, sum(x[a] for a in A if a[1] == 0) == K_Beasley[nombreInstancia])
   
   #Restricción para forzar un arco del óptimo
   #@constraint(vrptw.formulation, x[(9,16)] == 1.0)
   #@constraint(vrptw.formulation, x[(16,23)] == 1.0)

   """
   #Forzar solución óptima al caso csp50.txt a través de restricciones
   #Itinerario 1
   @constraint(vrptw.formulation, x[(0,1)] == 1.0)
   @constraint(vrptw.formulation, x[(1,10)] == 1.0)
   #Itinerario 2
   @constraint(vrptw.formulation, x[(0,2)] == 1.0)
   @constraint(vrptw.formulation, x[(2,13)] == 1.0)
   #Itinerario 3
   @constraint(vrptw.formulation, x[(0,3)] == 1.0)
   #Itinerario 4
   @constraint(vrptw.formulation, x[(0,4)] == 1.0)
   #Itinerario 5
   @constraint(vrptw.formulation, x[(0,5)] == 1.0)
   @constraint(vrptw.formulation, x[(5,19)] == 1.0)
   #Itinerario 6
   @constraint(vrptw.formulation, x[(0,6)] == 1.0)
   @constraint(vrptw.formulation, x[(6,15)] == 1.0)
   #Itinerario 7
   @constraint(vrptw.formulation, x[(0,7)] == 1.0)
   @constraint(vrptw.formulation, x[(7,20)] == 1.0)
   #Itinerario 8
   @constraint(vrptw.formulation, x[(0,8)] == 1.0)
   @constraint(vrptw.formulation, x[(8,17)] == 1.0)
   #Itinerario 9
   @constraint(vrptw.formulation, x[(0,9)] == 1.0)
   @constraint(vrptw.formulation, x[(9,16)] == 1.0)
   @constraint(vrptw.formulation, x[(16,23)] == 1.0)
   #Itinerario 10
   @constraint(vrptw.formulation, x[(0,11)] == 1.0)
   @constraint(vrptw.formulation, x[(11,22)] == 1.0)
   #Itinerario 11
   @constraint(vrptw.formulation, x[(0,12)] == 1.0)
   @constraint(vrptw.formulation, x[(12,27)] == 1.0)
   #Itinerario 12
   @constraint(vrptw.formulation, x[(0,14)] == 1.0)
   @constraint(vrptw.formulation, x[(14,24)] == 1.0)
   #Itinerario 13
   @constraint(vrptw.formulation, x[(0,18)] == 1.0)
   @constraint(vrptw.formulation, x[(18,25)] == 1.0)
   @constraint(vrptw.formulation, x[(25,31)] == 1.0)
   #Itinerario 14   
   @constraint(vrptw.formulation, x[(0,21)] == 1.0)
   @constraint(vrptw.formulation, x[(21,32)] == 1.0)
   @constraint(vrptw.formulation, x[(32,35)] == 1.0)   
   #Itinerario 15
   @constraint(vrptw.formulation, x[(0,26)] == 1.0)
   @constraint(vrptw.formulation, x[(26,33)] == 1.0)
   #Itinerario 16
   @constraint(vrptw.formulation, x[(0,28)] == 1.0)
   #Itinerario 17
   @constraint(vrptw.formulation, x[(0,29)] == 1.0)
   @constraint(vrptw.formulation, x[(29,34)] == 1.0)
   #Itinerario 18
   @constraint(vrptw.formulation, x[(0,30)] == 1.0)
   @constraint(vrptw.formulation, x[(30,36)] == 1.0)
   #Itinerario 19
   @constraint(vrptw.formulation, x[(0,37)] == 1.0)
   @constraint(vrptw.formulation, x[(37,44)] == 1.0)
   #Itinerario 20
   @constraint(vrptw.formulation, x[(0,38)] == 1.0)
   @constraint(vrptw.formulation, x[(38,42)] == 1.0)
   #Itinerario 21
   @constraint(vrptw.formulation, x[(0,39)] == 1.0)
   @constraint(vrptw.formulation, x[(39,41)] == 1.0)
   #Itinerario 22
   @constraint(vrptw.formulation, x[(0,40)] == 1.0)
   @constraint(vrptw.formulation, x[(40,46)] == 1.0)
   #Itinerario 23
   @constraint(vrptw.formulation, x[(0,43)] == 1.0)
   #Itinerario 24
   @constraint(vrptw.formulation, x[(0,45)] == 1.0)
   #Itinerario 25
   @constraint(vrptw.formulation, x[(0,47)] == 1.0)
   @constraint(vrptw.formulation, x[(47,50)] == 1.0)
   #Itinerario 26
   @constraint(vrptw.formulation, x[(0,48)] == 1.0)
   #Itinerario 27
   @constraint(vrptw.formulation, x[(0,49)] == 1.0)
   """   

   #Salida de diagnóstico del modelo
   println(vrptw.formulation)

   # Build the model directed graph G=(V1,A1)
   function buildgraph()

      v_source = v_sink = 0
      V1 = [i for i in 0:n(data)]

      L, U = lowerBoundNbVehicles(data), upperBoundNbVehicles(data) # multiplicity

      G = VrpGraph(vrptw, V1, v_source, v_sink, (L, U))

      if app["enable_cap_res"]
         cap_res_id = add_resource!(G, main = true)
      end
      
      time_res_id = add_resource!(G, main = true)
      """
      for i in V1
         l_i, u_i = 0.0, T # accumulated resource consumption interval [l_i, u_i] for the vertex i
         set_resource_bounds!(G, i, time_res_id, l_i, u_i)
      end
      """

      for v in V1
         if app["enable_cap_res"]
            set_resource_bounds!(G, v, cap_res_id, 0, Q)
         end
         l_i, u_i = 0.0, T # accumulated resource consumption interval [l_i, u_i] for the vertex i
         #set_resource_bounds!(G, v, time_res_id, s(data, v), u_i)
         set_resource_bounds!(G, v, time_res_id, l_i, u_i)#Consumo de tiempo CSP
         #set_resource_bounds!(G, v, time_res_id, l(data, v), u(data, v))
      end

      for (i,j) in A
         arc_id = add_arc!(G, i, j)
         add_arc_var_mapping!(G, arc_id, x[(i,j)])
         if app["enable_cap_res"]
            set_arc_consumption!(G, arc_id, cap_res_id, d(data, j))
         end
         set_arc_consumption!(G, arc_id, time_res_id, t(data, (i, j)) )
      end

      return G
   end

   G = buildgraph()
   add_graph!(vrptw, G)
   
   #Salida de diagnóstico del grafo generado
   #println(G)

   set_vertex_packing_sets!(vrptw, [[(G,i)] for i in V])

   define_packing_sets_distance_matrix!(vrptw, [[c(data, (i, j)) for j in V] for i in V])

   add_capacity_cut_separator!(vrptw, [ ( [(G,i)], Float64(d(data, i)) ) for i in V], Float64(Q))

   set_branching_priority!(vrptw, "x", 1)

   return (vrptw, x)
end
