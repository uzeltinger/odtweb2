<%
  ' T Planta --------------------------------------
  
  Sub listarPlantas

    QueryToJSON(conexion, "SELECT codigoPlanta as id, NombrePlanta as text FROM plantas where activo ORDER BY NombrePlanta;").Flush

  End Sub




' T Edificios --------------------------------------

Sub listarEdificios(Planta)
  
  where = ""
  if Planta <> "" then where = " AND plantas.codigoPlanta = """& Planta &""""

  sql = "SELECT Edificio as text, codigoEdificio as id from odtedificios inner join plantas on plantas.NombrePlanta = odtedificios.Planta WHERE odtedificios.activo " & where & " ORDER BY Edificio" 
  'log(sql)
  QueryToJSON(conexion, sql).Flush

end Sub


' T Usuarios --------------------------------------

Sub listarDefinidores(codigoEdificio)
  
  where = ""
  if codigoEdificio <> "" then where = " AND odtd.codigoEdificio = "& codigoEdificio 

  sql = "SELECT su.MN AS id, su.Nombre as text FROM odtdefinidores odtd inner join sistemausuarios su ON odtd.MNdefinidor = su.MN WHERE odtd.activo " & where & " ORDER BY Nombre"
  
  QueryToJSON(conexion, sql).Flush

end Sub





Sub listarContactos()
  
  sql = "select su.MN as id, su.Nombre as text from sistemausuarios su WHERE activo  ORDER BY Nombre" 
  
  QueryToJSON(conexion, sql).Flush

end Sub




Sub listarAprobadores(codigoEdificio)
  
  where = ""
  if codigoEdificio <> "" then where = " AND odta.codigoEdificio = "& codigoEdificio 

  sql = "select odta.MNAprobador as id, su.Nombre as text  from odtaprobadores odta inner join sistemausuarios su ON su.MN = odta.MNAprobador where su.activo  " & where & " ORDER BY Nombre"
  
  QueryToJSON(conexion, sql).Flush

end Sub




' T PRIORIDADES --------------------------------------
Sub listarPrioridades()
  
  sql = "select p.codigoPrioridad as id, p.Prioridad as text from odtprioridades p where p.Activo " 
  
  QueryToJSON(conexion, sql).Flush

end Sub

' T SISTEMA --------------------------------------------
Sub listarCuentas(aprobador)
    where = ""
    if aprobador <> "" then where = " AND sca.MNaprobador = '"& aprobador &"'"
    'á
    'sql = "SELECT CONCAT(sca.cuentaSAP, ' | ', sca.descripcion)  as id, sca.cuentaImputacion as text FROM sistemacuentasaprobadores sca WHERE sca.activo AND sca.sistema = 'ODT' " & where & " ORDER BY cuentaImputacion"

    sql = "SELECT CONCAT(cuentaSAP, ' | ', IFNULL(descripcion,''))  as text, sistemacuentas.codigoCuenta as id "
    sql = sql & "FROM sistemacuentasaprobadores sca "
    sql = sql & "INNER JOIN sistemacuentas ON sca.codigoCuenta = sistemacuentas.codigoCuenta "
    sql = sql & "WHERE sca.activo AND sistemacuentas.activo AND sca.sistema = 'ODT' " & where
    sql = sql & "ORDER BY cuentaSAP"

    
  QueryToJSON(conexion, sql).Flush
  
end Sub


sub renderSelectPlantas()
	
	sql = "select codigoPlanta as id, NombrePlanta as text from plantas WHERE activo ORDER BY NombrePlanta" 
  
	response.write QueryToSelect(sql, "")

end sub


sub renderSelectContactos()
	
	sql = "select su.MN as id, su.Nombre as text from sistemausuarios su WHERE activo ORDER BY Nombre" 
  
	response.write QueryToSelect(sql, USUARIO_DEFAULT)

end sub

sub renderSelectMNaNombre()
	
	sql = "select UPPER(su.MN) as id, su.Nombre as text from sistemausuarios su ORDER BY Nombre" 
  
	response.write QueryToSelect(sql, USUARIO_DEFAULT)

end sub

sub renderSelectTipoTarea()

'	sql = "select codigoTipoTarea as id, Nombre as text from odttipotareas WHERE activo ORDER BY Nombre" 
  sql = "select codigoTipoTarea as id, Nombre as text from odttipotareas WHERE activo and CodigoTipoTarea > 32 ORDER BY Nombre" 
	response.write QueryToSelect(sql, "")

end sub

Function cantidadOdtsADefinir(MN)

    ' Definidores por edificios
	'sql = "SELECT count(codigoODT) as cantidad "
    'sql = sql & "FROM odts o "
    'sql = sql & "WHERE activo AND NOT definido AND NOT (o.MNSolicitante = '"& MN &"') AND o.codigoEdificio IN (SELECT codigoEdificio FROM odtdefinidores WHERE MNdefinidor = '"& MN &"' AND activo)"

    sql = "SELECT count(codigoODT) as cantidad "
    sql = sql & "FROM odts o "
    sql = sql & "WHERE activo AND NOT definido AND NOT (o.MNSolicitante = '"& MN &"') AND MNdefinidor='" & MN & "'"

	'log(sql)

    Set RS = DbQuery(sql)
	
	if Not (RS.EOF Or RS.BOF) then
		cantidadOdtsADefinir = cint(RS("cantidad"))
	else 
		cantidadOdtsADefinir = 0
	end if
	
	RS.close
	
End Function
  
  
  Function cantidadOdtsTodas(MN)
	
	where = "true"
	
	if usuarioPuede(ODT_puedeAdministrar) then 
      
    else 
		if usuarioPuede(ODT_puedeCargarDetalle) then 
			where = where & " AND o.definido AND o.activo "
		else
			where = where & " AND ((o.MNdefinidor = '"& USUARIO_DEFAULT &"') OR (o.MNcontacto = '"& USUARIO_DEFAULT &"') OR (o.MNAprobador = '"& USUARIO_DEFAULT &"') OR (o.MNSolicitante = '"& USUARIO_DEFAULT &"'))"
		end if
    end if
	
    sql = "SELECT count(*) as cantidad "
    sql = sql & "FROM (odts o INNER JOIN sistemausuarios su ON su.MN = o.MNSolicitante )"
	sql = sql & "LEFT JOIN sistemausuarios su1 ON o.MNdefinidor = su1.MN "
    sql = sql & "WHERE " & where
    sql = sql & " ORDER BY codigoODT DESC "
    
    RS.Open sql, conexion, 1
	
	if Not (RS.EOF Or RS.BOF) then
		cantidadOdtsTodas = RS("cantidad")
	else 
		cantidadOdtsTodas = 0
	end if
	
	RS.close
	
  End Function

  
Function cantidadOdtsAAuditar(MN)

    sql = "SELECT count(codigoODT) as cantidad "
    sql = sql & "FROM odts o "
    sql = sql & "WHERE activo AND definido AND iniciado AND completadaEmpresa AND not auditado AND ((Aprobado) OR (NOT ISNULL(fechacompletada) AND (time_to_sec(timediff(NOW(), fechacompletada )) / 3600) > 96) ) "

	'log(sql)

    Set RS = DbQuery(sql)
	
	if Not (RS.EOF Or RS.BOF) then
		cantidadOdtsAAuditar = cint(RS("cantidad"))
	else 
		cantidadOdtsAAuditar = 0
	end if
	
	RS.close
	
End Function

Function cantidadOdts96mas()
    
    sql = ""
    sql = sql & "SELECT count(codigoODT) as cantidad "
    sql = sql & "FROM odts o "
    sql = sql & "WHERE activo "
    sql = sql & "AND definido "
    sql = sql & "AND iniciado "
    sql = sql & "AND completadaEmpresa "
    sql = sql & "AND (Aprobado <> 1) "
    sql = sql & "AND NOT ISNULL(fechacompletada) "
    sql = sql & "AND (time_to_sec(timediff(NOW(), fechacompletada )) / 3600) > 96"

    Set RS = DbQuery(sql)
	
	if Not (RS.EOF Or RS.BOF) then
		cantidadOdts96mas = cint(RS("cantidad"))
	else 
		cantidadOdts96mas = 9
	end if
	
	RS.close
	
End Function

'agrego funcion para contar cantidad a revisar por sergio y carlos
'Function cantidadOdtsARevisar(MN)

'	 sql = "SELECT count(codigoODT) as cantidad "
 '    sql = sql & "FROM odts o "
 '   sql = sql & "WHERE activo AND not(definido) AND iniciado AND not(completadaEmpresa) AND not (auditado) AND (not(Aprobado) and (NOT ISNULL(fechacompletada)) ) "

	'log(sql)

'    Set RS = DbQuery(sql)
	
'	if Not (RS.EOF Or RS.BOF) then
'		cantidadOdtsARevisar = cint(RS("cantidad"))
'	else 
'		cantidadOdtsARevisar = 0
'	end if
	
'	RS.close
	
'End Function
%>