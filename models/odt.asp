<%
Class Odt
	
  private Sub SqlOdtToJSON(sql)
	
	Dim out, isFirstItem, comma, codigoODT
    
    out = "["
 
    RS.Open sql, conexion, 1

	if Not (RS.EOF Or RS.BOF) then
		While Not (RS.EOF Or RS.BOF)
		  out = out + "{"
		  
		  isFirstItem = 1
		  For Each col In RS.Fields
			
			if isFirstItem = 1 then 
			  comma = "" 
			  isFirstItem = 0
			else 
			  comma = ", "
			end if
			
			if col.Name = "codigoODT" then codigoODT = col.Value
			
			if isNull(col.Value) then Value = "" else Value = encodeStr(col.Value)
			
			out = out + comma + """"& col.Name &""":"""& Value &""""
		  Next
		  
		  if RS("activo") = 0 then
			icon = "anulada"
		  else
              if not RS("auditado") = 0 then
                icon = "auditada"
              else
                  if not RS("completadaEmpresa") = 0 or not RS("terminadaFisicamente") = 0 then
                    icon = "completada"
                  else
                    If not rs("iniciado") = 0 Then
                        icon = "iniciado"
                    else
                        If not rs("definido") = 0 Then
                            if RS("codigoPrioridad") = "U" then
                                icon = "definida_urgente"
                            else
                                icon = "definida"
                            end if
                        else
                            if RS("codigoPrioridad") = "U" then
                                icon = "creada_urgente"
                            else
                                icon = "creada"
                            end if
                        end if
                    end if
                end if
			  end if
		  end if
      
      ' si estas leyendo esto... grrrr grrrr
      
        ' obtenemos CGC
        If evitarNULL(RS("fechaRealizacion")) = "" Then
            f = Date
        Else
            f = RS("fechaRealizacion")
        End If
      
        out = out + ",""coeficienteGM"":"""& obtenerCGC(f) &""""
  
		  out = out + ",""icon"":"""& icon &""""
		  
		  out = out + ",""fechaMostrar"":""" & formatearFechaAMostrar(rs("fechaCreacion")) & """"
		  
		  'esto devuelve lista materiales
		  out = out + ",""materiales"":["& getSublistaJSON("SELECT NroFactura, codigoODT, MaterialesTxt, Cant, Precio, ItemID, Observaciones, fechaCreacion, mnCreacion FROM odtitemsmateriales oim WHERE oim.CodigoODT = "& codigoODT & " ORDER BY fechaCreacion") &"]"
		  
		  ' y esto devuelve... voila!!! servicios
		  out = out + ",""servicios"":["& getSublistaJSON("select oir.ItemID, oi.Descripcion,oi.codigoItem, oir.Cant, oi.Precio, oir.Observaciones, oir.CodigoODT  FROM odtitemsrealizados oir INNER JOIN odtitems oi ON oi.codigoItem = oir.codigoItem WHERE oir.CodigoODT = "& codigoODT) &"]"
		  
		  out = out + "}," 
		  
		RS.MoveNext
		
		Wend
		
		'corrige ultima coma
		out = left(out, Len(out) -1)
    end if 
	
    out = out + "]"
    
    response.Charset = "utf-8" 
    response.ContentType = "application/json"
    response.write(out)
  End Sub

  
  Private Function getTotalODT(codigoODT)
    
    Dim total, m, s
    
    total = 0
    m = 0
    s = 0

    fecha = ObtenerFechaRealizacionODT(codigoODT)    
    
    mt = 0
    
    RS2.Open "SELECT SUM(oim.Cant * oim.Precio) AS totalMateriales FROM odtitemsmateriales oim WHERE oim.codigoodt = "& codigoODT & " GROUP BY NroFactura",conexion,0,1,1
    while Not (RS2.EOF)
        if not(IsNull(RS2("totalMateriales"))) then
            m = RS2("totalMateriales")
            
            if m >= CGCobtenerImporte(fecha) then
                CGC = CGCobtenerCGC2(fecha)
            else
                CGC = CGCobtenerCGC1(fecha)
            end if
    
        else 
            m = 0
            CGC = 0
        end if 
        
        mt = mt + m + (m * CGC)
        
        RS2.movenext
    wend
    RS2.Close

    RS2.Open "SELECT SUM(oir.Cant * oi.Precio) AS totalServicios FROM odtitemsrealizados oir INNER JOIN odtitems oi ON oi.codigoItem = oir.codigoItem WHERE oir.codigoodt = "& codigoODT,conexion,0,1,1
    if Not (RS2.EOF Or RS2.BOF) then
        if not(IsNull(RS2("totalServicios"))) then
            For Each col In RS2.Fields
                s = col.Value
            Next
        else 
            s = 0
        end if 
    end if
    RS2.Close
    
    total = mt + s
    
    getTotalODT =  total
    
  End Function

  
  Public Sub getODTsDeFactura(codigoFactura)
  
  
    if codigoFactura = 0 then 
      facturaABuscar = " ( ISNULL(o.codigoFactura) OR o.codigoFactura = 0) AND o.CompletadaEmpresa AND o.activo " 
    else 
      facturaABuscar = " o.codigoFactura = "& codigoFactura 
    end if
    
    'response.Charset = "utf-8" 
    response.Charset = "iso8859-1" 
    response.ContentType = "application/json"

    Dim out, isFirstItem, comma, codigoODT, sql, f, cgc
    
    out = "[ "
    
    sql = "SELECT codigoODT, o.MNSolicitante, su.Nombre, o.fechaRealizacion FROM odts o INNER JOIN sistemausuarios su ON su.MN = o.MNSolicitante "
    sql = sql & "WHERE "& FacturaABuscar
    
    Set RS = DbQuery(sql)
    
    if Not (RS.EOF Or RS.BOF) then
      While Not (RS.EOF Or RS.BOF)
        
        ' obtenemos CGC
        If evitarNULL(RS("fechaRealizacion")) = "" Then
            f = Date
        
        Else
            f = RS("fechaRealizacion")
        
            
        End If
        
        'cgc = obtenerCGC(f)
        'log("cgc: "& cgc)

        v = getTotalODT(RS("codigoODT"))
        
        out = out & "{ ""codigoODT"": "& RS("codigoODT") &","
        out = out & " ""MNSolicitante"": """& RS("MNSolicitante") &""","
        out = out & " ""Nombre"": """& left(RS("Nombre"),24) &""","
        
        v = Cstr(Math.Round(v * 100) / 100)
        v = replace(cstr(v), ",", ".")
        out = out & " ""totalODT"": "& v &"},"
        
        
        RS.MoveNext
      wend
      out = left(out, Len(out) -1)
    end if
      
    
    out = out & "]"

    response.write(out)
  
  End Sub

  Public Sub getOdt(codigoODT)
  
    dim sql, where
    
    where = "codigoODT="& codigoODT
    
    if usuarioPuede(ODT_puedeAdministrar) then 
      
    else 
		if usuarioPuede(ODT_puedeCargarDetalle) then 
			where = where & " AND o.definido AND o.activo "
		else
			where = where & " AND ((o.MNdefinidor = '"& USUARIO_DEFAULT &"') OR (o.MNcontacto = '"& USUARIO_DEFAULT &"') OR (o.MNAprobador = '"& USUARIO_DEFAULT &"') OR (o.MNSolicitante = '"& USUARIO_DEFAULT &"'))"
		end if
    end if
    
    sql = "SELECT o.*, "
    sql = sql & "su.Nombre as nombreSolicitante, su1.Nombre as nombreDefinidor, su2.Nombre as nombreAnulacion "
    sql = sql & "FROM ((odts o "
    sql = sql & "INNER JOIN sistemausuarios su ON su.MN = o.MNSolicitante )"
    sql = sql & "LEFT JOIN sistemausuarios su1 ON o.MNdefinidor = su1.MN )"
	sql = sql & "LEFT JOIN sistemausuarios su2 ON o.MNAnulacion = su2.MN "
    sql = sql & "WHERE " & where
    
    SingleObjectQueryToJSON(sql).Flush
    
  End Sub
  
  
  
  
  
  Public Sub update(jsonData)
  
    dim odtData
	Set odtData = JSON.parse(jsonData)

	esNueva = false

	
    if odtData.CodigoODT = 0 then
	
		esNueva = true
		
        odtData.CodigoODT = LAST_INSERT_ID("odts", "codigoODT") + 1
        
        set RS = DbOpen("odts")  
        RS.Addnew
        RS("codigoODT") =  odtData.codigoODT
        RS("MNSolicitante") = USUARIO_DEFAULT
		RS("FechaHoraSolicitud") = now()
		odtData.activo = True
        RS.Update
        RS.close

    end if
    
    ' ACTUALIZACION

    Set RS = DbOpen( "SELECT * FROM odts WHERE codigoODT=" & odtData.codigoODT )
	
      esInicioTareas = false
	  
	  if RS("iniciado") = 0 and odtData.iniciado <> 0 then
		esInicioTareas = true
	  end if

	  esDefinicion = false
	  if RS("definido") = 0 and odtData.definido <> 0 then
		esDefinicion = true
        RS("fechaDefinicion") = now
	  end if

	  esCompletada = false

	  if RS("CompletadaEmpresa") = 0 and odtData.CompletadaEmpresa then
		esCompletada = true
        RS("fechaCompletada") = now
	  end if

      RS("codigoPlanta") = odtData.codigoPlanta
      RS("codigoEdificio") = odtData.codigoEdificio
      RS("UbicacionTarea") = left(odtData.UbicacionTarea,50)
      RS("MNdefinidor") = odtData.MNdefinidor
      RS("DescripcionODT") = odtData.DescripcionODT
      RS("MNcontacto") = odtData.MNcontacto
      RS("codigoPrioridad") = odtData.codigoPrioridad
	  RS("codigoTipoTarea") = odtData.codigoTipoTarea
      RS("Cuenta") = odtData.Cuenta
      RS("MNAprobador") = odtData.MNAprobador

      if odtData.FechaRealizacion <> "" then RS("FechaRealizacion") = CDate(odtData.FechaRealizacion)
      if odtData.FechaPlanificacion <> "" then RS("FechaPlanificacion") = CDate(odtData.FechaPlanificacion)

      RS("CompletadaEmpresa") = odtData.CompletadaEmpresa	
      RS("Aprobado") = odtData.Aprobado
      RS("ComentariosSG") = odtData.ComentariosSG

      RS("definido") = odtData.definido
      RS("iniciado") = odtData.iniciado
      RS("terminadaFisicamente") = odtData.terminadaFisicamente

      RS("auditado") = odtData.auditado
      if isNumeric(odtData.codigoCuenta) then
        RS("codigoCuenta") = odtData.codigoCuenta
      else
        RS("codigoCuenta") = 0
      end if
      RS("presupuestar") = odtData.presupuestar
      RS("activo") = odtData.activo
      RS("MNAnulacion") = odtData.MNAnulacion
      
      RS("revisada") = odtData.revisada
      RS("revisada_por") = odtData.revisada_por
      RS("electrica") = odtData.electrica

      RS.Update 

    RS.Close  
    
    response.write(odtData.CodigoODT)
    if esNueva then
        'localLogAdd("agregada odt : " & odtData.CodigoODT)
    else
        'localLogAdd("editada odt : " & odtData.CodigoODT)
    end if
    if PROD then  
        if esNueva then
            if odtData.codigoTipoTarea = "33" then
                ODT_mail_revisores odtData.CodigoODT
            else
                ODT_mail_solicitante odtData.CodigoODT
                ODT_mail_definidor odtData.CodigoODT
            end if
        end if 

		if esDefinicion then
			ODT_mail_confirmado odtData.CodigoODT
		end if
		
		if esInicioTareas then
            ODT_mail_inicio_tareas odtData.CodigoODT
        end if
        
		if esCompletada then
            ODT_mail_aprobacion odtData.CodigoODT
        end if

        ' si no hay otra accion, solo es guardar, suponemos que se revisa
        if Not (esNueva) And Not (esDefinicion) And Not (esInicioTareas) And Not (esCompletada) then
        'localLogAdd("Revision: no esNueva esDefinicion esInicioTareas esCompletada")
        'localLogAdd("codigoTipoTarea: " & odtData.codigoTipoTarea & " revisada: " & odtData.revisada )
        if (odtData.codigoTipoTarea = 33) And (odtData.revisada = 1) then            
            ODT_mail_solicitante odtData.CodigoODT
            ODT_mail_definidor odtData.CodigoODT
            'localLogAdd("agregada y enviados 2 emails a revisadores")
            end if
        end if
        
    end if

	
  End Sub

  
  Public Sub updateControl(codigoOdt, jsondata)
    dim data
    
	Set data = JSON.parse(jsondata)
    
    DbQuery("DELETE FROM odtcontroldeobra WHERE codigoODT=" & codigoOdt)
    
    set RS = DbOpen("odtcontroldeobra")  
    
    
    For Each k In data.keys()
        RS.Addnew
        
        RS("codigoODT") =  codigoOdt
        RS("itemId") = data.get(k).id
        
        if data.get(k).texto = 1 then
            RS("texto") = data.get(k).obs
        end if
        
        RS.Update
    Next
    
    RS.close
    
    
  End Sub
	
  Public Sub getADefinir(fromCodigoODT, search)

    where = "NOT definido AND o.activo AND NOT (o.MNSolicitante = '"& USUARIO_DEFAULT &"')" 
    
    if fromCodigoODT <> 0 then 
		 where = where &  " AND codigoODT < "& fromCodigoODT 
	end if
	
    ' filtrado usuarios
    
    if usuarioPuede(ODT_puedeAdministrar) OR usuarioPuede(ODT_puedeAuditar)  then 
      
    else 
      if usuarioPuede(ODT_puedeDefinir) THEN 
        ' Definidores del mismo edificio
        'where = where & " AND o.codigoEdificio IN (SELECT codigoEdificio FROM odtdefinidores WHERE MNdefinidor = '"& USUARIO_DEFAULT &"' AND activo)"
        where = where & " AND o.MNdefinidor = '"& USUARIO_DEFAULT &"'"
      else 
        where = where & " AND false "
      end if
    end if
	
	if search <> "" then
		where = where & " AND (su.Nombre  like '%" & search & "%' OR o.codigoODT like '%" & search & "%' OR o.DescripcionODT like '%" & search & "%' OR su1.Nombre  like '%" & search & "%')"
	end if

    sql = "SELECT o.*, "
    sql = sql & "su.Nombre as nombreSolicitante "
    sql = sql & "FROM (odts o "
    sql = sql & "INNER JOIN sistemausuarios su ON su.MN = o.MNSolicitante )"
	sql = sql & "LEFT JOIN sistemausuarios su1 ON o.MNdefinidor = su1.MN "
    sql = sql & "WHERE " & where
    sql = sql & " ORDER BY codigoODT DESC "
    sql = sql & "LIMIT " & CANT_POR_PAGINA

	'log(sql)

    SqlOdtToJSON sql
  End Sub
  
    
 Public Sub getAAuditar(fromCodigoODT, search)

    where = " o.activo AND definido AND iniciado AND completadaEmpresa " 
    
    if fromCodigoODT <> 0 then 
		 where = where &  " AND codigoODT < "& fromCodigoODT 
	end if
	
    ' filtrado usuarios
    
    if usuarioPuede(ODT_puedeAdministrar) OR usuarioPuede(ODT_puedeAuditar)  then 
      
    else 
    
        where = where & " AND false "
    
    end if
	
	if search <> "" then
		where = where & " AND (su.Nombre  like '%" & search & "%' OR o.codigoODT like '%" & search & "%' OR o.DescripcionODT like '%" & search & "%' OR su1.Nombre  like '%" & search & "%')"
	end if

    sql = "SELECT o.*, "
    sql = sql & "su.Nombre as nombreSolicitante "
    sql = sql & "FROM (odts o "
    sql = sql & "INNER JOIN sistemausuarios su ON su.MN = o.MNSolicitante )"
	sql = sql & "LEFT JOIN sistemausuarios su1 ON o.MNdefinidor = su1.MN "
    sql = sql & "WHERE " & where
    sql = sql & " ORDER BY codigoODT DESC "
    sql = sql & "LIMIT " & CANT_POR_PAGINA

	'log(sql)

    SqlOdtToJSON sql
  End Sub
    
  
  Public Sub getSolicitadas(fromCodigoODT, search)

    if fromCodigoODT = 0 then 
		where = "true" 
	else 
		where = "codigoODT < "& fromCodigoODT 
	end if
	
	where = where & " AND o.MNSolicitante = '"& USUARIO_DEFAULT &"'"	
	
	if search <> "" then
		where = where & " AND (su.Nombre  like '%" & search & "%' OR o.codigoODT like '%" & search & "%' OR o.DescripcionODT like '%" & search & "%' OR su1.Nombre  like '%" & search & "%')"
	end if

    sql = "SELECT o.*, "
    sql = sql & "su.Nombre as nombreSolicitante "
    sql = sql & "FROM (odts o "
    sql = sql & "INNER JOIN sistemausuarios su ON su.MN = o.MNSolicitante )"
	sql = sql & "LEFT JOIN sistemausuarios su1 ON o.MNdefinidor = su1.MN "
    sql = sql & "WHERE " & where
    sql = sql & " ORDER BY codigoODT DESC "
    sql = sql & "LIMIT " & CANT_POR_PAGINA

	'log(sql)

    SqlOdtToJSON sql
  End Sub
  
  
  Public Sub getSemana(from, search)

	where = " o.activo AND o.definido "	
    
    where = where & "AND DATE(FechaPlanificacion) >= '" & FormatFechaSql(from) & "' AND DATE(FechaPlanificacion) <= '" & FormatFechaSql(from + 7) & "'" 
	
	if search <> "" then
		where = where & " AND (su.Nombre  like '%" & search & "%' OR o.codigoODT like '%" & search & "%' OR o.DescripcionODT like '%" & search & "%' OR su1.Nombre  like '%" & search & "%')"
	end if

    sql = "SELECT o.*, "
    sql = sql & "su.Nombre as nombreSolicitante, DATEDIFF(DATE(FechaPlanificacion),date('" & FormatFechaSql(from) & "')) as dia "
    sql = sql & "FROM (odts o "
    sql = sql & "INNER JOIN sistemausuarios su ON su.MN = o.MNSolicitante )"
	sql = sql & "LEFT JOIN sistemausuarios su1 ON o.MNdefinidor = su1.MN "
    sql = sql & "WHERE " & where
    sql = sql & " ORDER BY codigoODT DESC "
    'sql = sql & "LIMIT " & CANT_POR_PAGINA

	'log(sql)

    SqlOdtToJSON sql
  End Sub
  
  
  Public Sub getPendientes(fromCodigoODT, search)
	
	where = "NOT completadaEmpresa AND o.activo"
    
	if fromCodigoODT > 0 then 
		where = where & " AND codigoODT < "& fromCodigoODT 
	end if
	
		
	if usuarioPuede(ODT_puedeAdministrar) or usuarioPuede(ODT_puedeAuditar) then 
	else
		if usuarioPuede(ODT_puedeCargarDetalle) then	
			where = where & " AND o.definido AND o.activo AND o.iniciado "
		else
			where = where & " AND o.MNSolicitante = '"& USUARIO_DEFAULT &"'"	
		end if

	end if
	
	if search <> "" then
		where = where & " AND (su.Nombre  like '%" & search & "%' OR o.codigoODT like '%" & search & "%' OR o.DescripcionODT like '%" & search & "%' OR su1.Nombre  like '%" & search & "%')"
	end if

    sql = "SELECT o.*, "
    sql = sql & "su.Nombre as nombreSolicitante "
    sql = sql & "FROM (odts o "
    sql = sql & "INNER JOIN sistemausuarios su ON su.MN = o.MNSolicitante )"
	sql = sql & "LEFT JOIN sistemausuarios su1 ON o.MNdefinidor = su1.MN "
    sql = sql & "WHERE " & where 
    sql = sql & " ORDER BY codigoODT DESC "
    sql = sql & "LIMIT " & CANT_POR_PAGINA

	'log(sql)

    SqlOdtToJSON sql
  End Sub
  
  
  Public Sub getTodas(fromCodigoODT, search)

    if fromCodigoODT = 0 then 
      where = "true" 
    else 
      where = "codigoODT < "& fromCodigoODT 
    end if
	
    ' filtrado usuarios
    
    if usuarioPuede(ODT_puedeAdministrar) OR usuarioPuede(ODT_puedeAuditar) then 
      
    else 
		if usuarioPuede(ODT_puedeCargarDetalle) then 
			where = where & " AND o.definido AND o.activo "
		else
			where = where & " AND ((o.MNdefinidor = '"& USUARIO_DEFAULT &"') OR (o.MNcontacto = '"& USUARIO_DEFAULT &"') OR (o.MNAprobador = '"& USUARIO_DEFAULT &"') OR (o.MNSolicitante = '"& USUARIO_DEFAULT &"'))"
		end if
    end if
	
	if search <> "" then
		where = where & " AND (su.Nombre  like '%" & search & "%' OR o.codigoODT like '%" & search & "%' OR o.DescripcionODT like '%" & search & "%' OR su1.Nombre  like '%" & search & "%'  OR ed.Edificio like '%" & search & "%')"
	end if

    sql = "SELECT o.*, "
    sql = sql & "su.Nombre as nombreSolicitante, su1.Nombre as nombreDefinidor, su2.Nombre as nombreAnulacion, odtfacturacion.FacturaNro "
    sql = sql & "FROM ((((odts o "
    sql = sql & "INNER JOIN sistemausuarios su ON su.MN = o.MNSolicitante )"
    sql = sql & "LEFT JOIN sistemausuarios su1 ON o.MNdefinidor = su1.MN )"
	sql = sql & "LEFT JOIN sistemausuarios su2 ON o.MNAnulacion = su2.MN )"
    sql = sql & "LEFT JOIN odtfacturacion ON o.codigoFactura = odtfacturacion.codigoFactura )"
    sql = sql & "LEFT JOIN odtedificios ed ON o.codigoEdificio = ed.codigoEdificio "
    sql = sql & "WHERE " & where
    sql = sql & " ORDER BY codigoODT DESC "
    sql = sql & "LIMIT " & CANT_POR_PAGINA

	'log(sql)

    SqlOdtToJSON sql
  End Sub
  
  Sub presupuestar(codigoOdt)
    ODT_mail_presupuesto(codigoOdt)
  End Sub
  
  Public Sub getFechasPlanificacion(fecha)  
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
    response.write(recordCount(rst))
  End Sub

End Class
%>