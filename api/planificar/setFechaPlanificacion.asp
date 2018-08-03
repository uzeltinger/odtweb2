<!--#INCLUDE file= "../../include/config.asp"-->

<% 
    debuguea = false
    codigoODT = request.querystring("codigoODT")
    fecha = Date()
    nextSevenDay = DateAdd("d", 7, fecha)
    nextDay = nextSevenDay
    calcularFecha = FormatFechaSql(nextDay)    
    seguir = true
    'x = 0
    do while seguir
        cantidad = getCountTareas(calcularFecha)
        x = x + 1
        if debuguea then Response.write("<br> calcularFecha : " & calcularFecha & " cantidad : " & cantidad) end if
        if(cantidad < CANTIDAD_TAREAS_DIARIAS) then
            seguir = false 
            if debuguea then Response.write("<br> cantidad <  " & CANTIDAD_TAREAS_DIARIAS & " : " & cantidad) end if
        else
            nextDay = DateAdd("d", 1, nextDay)
            calcularFecha = FormatFechaSql(nextDay)    
        end if
        'if(x=10) then seguir = false end if
    loop
    if debuguea then Response.write("<br>devolver: " & calcularFecha) end if
    Response.write(calcularFecha)

    Set RS = DbOpen( "SELECT * FROM odts WHERE codigoODT=" & codigoODT )
    RS("FechaPlanificacion") = calcularFecha
    RS.Update
    RS.Close
    public function getCountTareas(fecha)  
        //dateNow = FormatFechaSql(fecha)
        'fecha = "2018-5-1"
        where = " o.definido = 1 "	    
        where = where & "AND DATE(FechaPlanificacion) = '" & fecha & "'" 	
        sql = "SELECT o.codigoODT, o.FechaPlanificacion, o.definido FROM odts as o "
        sql = sql & "WHERE " & where
        sql = sql & " ORDER BY FechaPlanificacion ASC "
        sql = sql & "LIMIT 10" 
        'response.write(sql)
        'localLogAdd(sql)    
        Set rst = DbQuery(sql)
        'response.write("{" & recordCount(rst) & "}")
        'response.write(recordCount(rst))
        getCountTareas = recordCount(rst)
    end function
%>