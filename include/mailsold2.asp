<%
function splitearMns(mns) 
	if instr(mns, ";") > 0 then
		dim s

		s = split(mns, ";")
		for i = 0 to UBound(s)
			if not instr( s(i), "@" ) > 0 then
				if trim(s(i)) <> "" then
					splitearMns = splitearMns & s(i) & "@eximc.nam.dow.com;"
				end if
			else
				if trim(s(i)) <> "" then
					splitearMns = splitearMns & s(i) & ";"
				end if
			end if		
		next

	else 

	if not instr( mns, "@" ) > 0 then
		if trim(mns) <> "" then
			splitearMns = mns & "@eximc.nam.dow.com;"
		end if
	else
		if trim(mns) <> "" then
		splitearMns = mns
		end if
	end if	 

end if

end function

Function sendmail(mnfrom, mnto, subject, htmlbody)
	
	Set objCDOMail = Server.CreateObject("CDO.Message")
			
	objCDOMail.From = splitearMns(mnfrom)
	objCDOMail.To = splitearMns(mnto)
	objCDOMail.Subject = subject
	objCDOMail.HtmlBody = htmlbody

	objCDOMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing")=2
	objCDOMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver")="localhost"
	objCDOMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport")=25
	objCDOMail.Configuration.Fields.Update

	objCDOMail.Send
	set objCDOMail=nothing

End Function

Function sendmailConAttach(mnfrom, mnto, subject, htmlbody, codigoODT)

	  file = "D:\Inetpub\wwwroot\odtweb\attaches\" & codigoODT & ".txt" '-------------- Verificar si este no es el problema-------------'
'	  response.write (file)
	  dim fs,fname
      set fs=Server.CreateObject("Scripting.FileSystemObject")
      set fname=fs.CreateTextFile(file)
      
	  Set rst = DbQuery("SELECT * FROM ODTs WHERE codigoODT=" & codigoODT)

	  If Not rst.EOF Then
		fname.WriteLine( "Numero:" & """" & rst("codigoODT") & """")
		fname.WriteLine( "Solicitante:" & """" & obtenerNombre(rst("MNsolicitante")) & """")
		fname.WriteLine( "Fecha:" & """" & rst("FechaHoraSolicitud") & """")
       fname.WriteLine( "Planta:" & """" & obtenerPlantaODT(rst("codigoPlanta")) & """")
		fname.WriteLine( "Edificio:" & """" & obtenerEdificioODT(rst("codigoEdificio")) & """")
       fname.WriteLine( "Ubicacion:" & """" & rst("UbicacionTarea") & """")
       fname.WriteLine( "Contacto:" & """" & obtenerNombre(rst("MNcontacto")) & """")
		fname.WriteLine( "Prioridad:" & """" & obtenerPrioridadODT(rst("codigoPrioridad")) & """")
       fname.WriteLine( "Definidor:" & """" & obtenerNombre(rst("MNdefinidor")) & """")
		fname.WriteLine( "Tarea:" & """" & rst("DescripcionODT") & """")
		
		
      end if
	  
	  
	  fname.Close
      set fname=nothing 
      set fs=nothing



	
	Set objCDOMail = Server.CreateObject("CDO.Message")
			
	objCDOMail.From = splitearMns(mnfrom)
	objCDOMail.To = splitearMns(mnto)
	objCDOMail.Subject = subject
	objCDOMail.HtmlBody = htmlbody
	objCDOMail.AddAttachment file

	objCDOMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing")=2
	objCDOMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver")="localhost"
	objCDOMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport")=25
	
	objCDOMail.Configuration.Fields.Update

	objCDOMail.Send
	set objCDOMail=Nothing
	




End Function






Function formatoDia(dia)
Dim dias
	'response.write htmlbody
Dim meses

    dias = Array("", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo")
    meses = Array("", "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre")
    formatoDia = diaDeLaSemana(Weekday(dia)) & " " & Day(dia) & " de " & mes(Month(dia)) & " de " & Year(dia)

End Function

Function BuscaMnResponsablesDow()

    Set rst = DbQuery("SELECT texto FROM SistemaConfiguracion WHERE Dato = 'ResponsableDowMN';")

    If Not rst.EOF Then
        BuscaMnResponsablesDow = rst("texto")
	else
		BuscaMnResponsablesDow = ""
    End If
    
End Function

Function ODT_mail_solicitante(codigoODT)

    Set rst = DbQuery("SELECT * FROM ODTs WHERE codigoODT=" & codigoODT)
    
    s = ""
    If Not rst.EOF Then
        
        s = s & "<FONT face=Arial color=#000000 size=3>"
        s = s & "<STRONG>Solicitud de Orden de Trabajo Nro: " & rst("codigoODT") & "</STRONG>"
        s = s & "</FONT><BR><BR>"
        s = s & "<FONT face=Arial color=#000000 size=2>"
        s = s & "Solicitante: <b>" & obtenerNombre(rst("MNsolicitante")) & "</B><BR>"
		s = s & "Fecha de la Solicitud: <B>" & formatoDia(rst("FechaHoraSolicitud")) & "</B><BR><br>"
        s = s & "Planta: <b>" & obtenerPlantaODT(rst("codigoPlanta")) & "</B><BR>"
        s = s & "Edificio: <b>" & obtenerEdificioODT(rst("codigoEdificio")) & "</B><BR>"
        s = s & "Ubicación de la Tarea: <b>" & rst("UbicacionTarea") & "</B><BR><BR>"
        s = s & "Contacto: <b>" & obtenerNombre(rst("MNcontacto")) & "</B><BR><BR>"
        s = s & "Prioridad: <b>" & obtenerPrioridadODT(rst("codigoPrioridad")) & "</B><BR><BR>"
        s = s & "Definidor: <b> " & obtenerNombre(rst("MNdefinidor")) & "</B><BR><BR>"
        s = s & "Descripción de la Tarea:<BR><BR><b>" & rst("DescripcionODT") & "</b>"
        
        s = s & "<BR><BR>"
        
        s = s & "Gracias.<BR><BR><a href='http://hwnt04/odtweb/?odt=" & rst("codigoODT") & "'>Para ver esta órden haga click aquí</a></FONT>"
                
        sendmail USUARIO_DEFAULT, rst("MNsolicitante"), "ODT | Solicitud Nro: " & codigoODT, s
        'sendmail USUARIO_DEFAULT, BuscaMnResponsablesDow, "ODT | Solicitud Nro: " & codigoODT, s

    End If

End Function

Function ODT_mail_definidor(codigoODT)

    Set rst = DbQuery("SELECT * FROM ODTs WHERE codigoODT=" & codigoODT)
    
    s = ""
    If Not rst.EOF Then
        
        s = s & "<FONT face=Arial color=#000000 size=3>"
        s = s & "<STRONG>Solicitud de Orden de Trabajo para Definir Nro: " & rst("codigoODT") & "</STRONG>"
        s = s & "</FONT><BR><BR>"
        s = s & "<FONT face=Arial color=#000000 size=2>"
        s = s & "Solicitante: <b>" & obtenerNombre(rst("MNsolicitante")) & "</B><BR>"
		s = s & "Fecha de la Solicitud: <B>" & formatoDia(rst("FechaHoraSolicitud")) & "</B><BR><br>"
        s = s & "Planta: <b>" & obtenerPlantaODT(rst("codigoPlanta")) & "</B><BR>"
        s = s & "Edificio: <b>" & obtenerEdificioODT(rst("codigoEdificio")) & "</B><BR>"
        s = s & "Ubicación de la Tarea: <b>" & rst("UbicacionTarea") & "</B><BR><BR>"
        s = s & "Contacto: <b>" & obtenerNombre(rst("MNcontacto")) & "</B><BR><BR>"
        s = s & "Prioridad: <b>" & obtenerPrioridadODT(rst("codigoPrioridad")) & "</B><BR><BR>"
        s = s & "Definidor: <b> " & obtenerNombre(rst("MNdefinidor")) & "</B><BR><BR>"
        s = s & "Descripción de la Tarea:<BR><BR><b>" & rst("DescripcionODT") & "</b>"
        
        s = s & "<BR><BR><a href='http://hwnt04/odtweb/?odt=" & rst("codigoODT") & "'>Para definir esta órden haga click aquí</a><BR><BR>"
        
        s = s & "Gracias.</FONT>"
                
        sendmail USUARIO_DEFAULT, rst("MNdefinidor"), "ODT | Solicitud Para Definir Nro: " & codigoODT, s
		
    End If

End Function


Function ODT_mail_inicio_tareas(codigoODT)

    Set rst = DbQuery("SELECT * FROM ODTs WHERE codigoODT=" & codigoODT)
    
    s = ""
    If Not rst.EOF Then
        
        s = s & "<FONT face=Arial color=#000000 size=3>"
        s = s & "<STRONG>Aviso de Inicio de Trareas<br/></STRONG>de la Orden de Trabajo Nro: " & rst("codigoODT") 
        s = s & "</FONT>"
		
        s = s & "<BR><BR><a href='http://hwnt04/odtweb/?odt=" & rst("codigoODT") & "'>Para ver esta órden haga click aquí</a><BR><BR>"
        
        s = s & "Gracias.</FONT>"
                
        sendmail USUARIO_DEFAULT, rst("MNsolicitante"), "ODT | Inicio de Tareas Solicitud Nro: " & codigoODT, s

    End If

End Function


Function ODT_mail_aprobacion(codigoODT)

    on error resume next
    
    Set rstODT = DbQuery("SELECT * FROM ODTs WHERE codigoODT=" & codigoODT)
    
    s = ""
    If Not rstODT.EOF Then
        
        ' Obtener Coeficiente de Gestion de Compra
        fr = rstODT("fechaRealizacion")
        if not isDate(fr) then
            fr = now
        end if
        
    
        s = s & "<FONT face=Arial color=#000000 size=3>"
        s = s & "<STRONG>ODT | Solicitud de Aprobación de Orden de Trabajo N°: " & codigoODT & "</STRONG>"
        s = s & "</FONT><BR><BR>"
        s = s & "<FONT face=Arial color=#000000 size=2>"
        s = s & "Este es un correo automático generado por el Sistema de Ordenes de Trabajo." & "</B><BR>"
        s = s & "Necesitamos su aprobación para continuar procesando su requerimiento." & "</B><BR>"
        s = s & "Para hacer esto, lea atentamente la descripción de tareas y precios que se detallan mas abajo" & "</B><BR>"
        s = s & "Si está de acuerdo con lo descripto, por favor reenvíe este mensaje tal como está" & "</B><BR>"
        s = s & "IMPORTANTE: No modifique nada en el contenido de este mail" & "</B><BR>"
        s = s & "En caso de discrepancias o reclamos por favor comuníquese con Servicios Integrados." & "</B><BR>"
        s = s & "<BR>"
		s = s & "<a style='font-size:16px;' href='http://hwnt04/odtweb/aprobar.asp?odt=" & rstODT("codigoODT") & "'><b>Para dar su aprobación YA a esta orden haga click aquí</b></a><BR>"
		s = s & "<span style='font-size:16px; color:red'>Esta órden se considerará aprobada automáticamente luego de 96 horas de enviado este correo.</span><BR>"
		s = s & "<BR>"
        s = s & "Muchas Gracias." & "<BR><BR>"

        s = s & "Fecha Solicitada: <B>" & formatoDia(rstODT("FechaHoraSolicitud")) & "</B><BR>"
        s = s & "Fecha de Concluída: <B>" & formatoDia(rstODT("FechaRealizacion")) & "</B><BR><BR>"
        
        s = s & "<P>Nro. de Solicitud: <b>" & rstODT("codigoODT") & "</b><BR>"
        s = s & "Solicitante: <b>" & obtenerNombre(rstODT("MNSolicitante")) & "</B><BR>"
        s = s & "Prioridad: <b>" & obtenerPrioridadODT(rstODT("codigoPrioridad")) & "</B><BR>"
        s = s & "Planta: <b>" & obtenerPlantaODT(rstODT("codigoPlanta")) & "</B><BR>"
        s = s & "Edificio: <b>" & obtenerEdificioODT(rstODT("codigoEdificio")) & "</B><BR>"
        
        s = s & "<br>"
        s = s & "<FONT face=Arial color=#000000 size=2>"
        s = s & "<b> Solicitud Original: </B><BR>" & rstODT("DescripcionODT") & "<BR>"
        s = s & "</FONT>"
        s = s & "<br>"
        
        'Listado de Mano de Obra
        
        Set rst = DbQuery("SELECT ODTitemsRealizados.Cant, ODTitemsRealizados.Observaciones, ODTItems.Descripcion, ODTItems.Precio FROM ODTitemsRealizados INNER JOIN ODTItems ON ODTitemsRealizados.codigoItem = ODTItems.codigoItem WHERE (((ODTitemsRealizados.CodigoODT)=" & codigoODT & "));")
        
        If recordCount(rst) > 0 Then
            
            
            s = s & "<FONT face=Arial color=#000000 size=3>"
            s = s & "<B>DETALLE de Mano de Obra utilizada:</B><BR>"
            s = s & "</FONT>"
                
            i = 1
            's = s & "Item              |                 Descripcion          |          Cantidad            |        Precio" & "<BR>"
            's = s & "<FONT face=Arial color=#000000 size=2>"
            s = s & "<table border='1' style='FONT-FAMILY: Arial; FONT-SIZE:14px;border-collapse: collapse' bordercolor='#C0C0C0' >"
            s = s & "<tr> <td>Item</td> <td>Descripcion</td> <td>Cantidad</td> <td>Precio Unitario</td> <td>Obs</td> </tr>"
            
            While Not rst.EOF
                Total = Total + rst("cant") * rst("Precio")
                
                s = s & "<tr> <td>" & i & "</td><td>" & rst("Descripcion") & "</td><td>" & rst("cant") & "</td><td>" & FormatCurrency(rst("Precio"), 2) & "</td><td>" 
				
				if not IsNull(rst("Observaciones")) then 
					s = s & rst("Observaciones")
				end if
				s = s & "</td></tr>"
				
                i = i + 1
                rst.MoveNext
            Wend
            
            s = s & "</table>"
        
            TotalMO = Total
            s = s & "<BR>"
            s = s & "<b>Total de Mano de Obra: " & FormatCurrency(TotalMO, 2) & "</font></b></p>"
            s = s & "<BR>"
            
        Else
                TotalMO = 0
        End If

		
 ' Listado de Mat
        
        Set rst = DbQuery("SELECT ODTItemsMateriales.NroOrden, ODTItemsMateriales.CodigoODT, ODTItemsMateriales.materialesTxt, ODTItemsMateriales.Cant, ODTItemsMateriales.Precio, ODTItemsMateriales.Observaciones FROM ODTItemsMateriales WHERE ODTItemsMateriales.CodigoODT = " & codigoODT & "; ")
        		
        If recordCount(rst) > 0 Then
        
            s = s & "<FONT face=Arial color=#000000 size=3>"
            s = s & "<b>DETALLE de Materiales utilizados:</B><BR>"
            s = s & "</FONT>"
                
            TotalCGC = 0
            Total = 0
            's = s & "<FONT face=Arial color=#000000 size=2>"
            s = s & "<table border='1' style='FONT-FAMILY: Arial; FONT-SIZE:14px;border-collapse: collapse' bordercolor='#C0C0C0' >"
            s = s & "<tr> <td>Item</td> <td>Descripcion</td> <td>Cantidad</td> <td>Precio Unitario</td> <td>Obs</td> </tr>"
            
            i = 1
            While Not rst.EOF
                Total = Total + (rst("cant") * rst("Precio"))
                
				'TotalCGC = TotalCGC + (rst("cant") * rst("Precio")) * CGC
				
                s = s & "<tr> <td>" & i & "</td><td>" & rst("MaterialesTxt") & "</td><td>" & rst("cant") & "</td><td>" & FormatCurrency(rst("Precio"), 2) & "</td><td>" 
				
				if not IsNull(rst("Observaciones")) then 
					s = s & rst("Observaciones")
				end if
				s = s & "</td></tr>"

                i = i + 1
                rst.MoveNext
            Wend


            if Total >= CGCobtenerImporte(fr) then
                TotalCGC = Total * CGCobtenerCGC2(fr)
            else
                TotalCGC = Total * CGCobtenerCGC1(fr)
            end if
			
            
            TotalMat = Total + TotalCGC
            
            s = s & "</table>"
            
            s = s & "<BR>"
            
            s = s & "<FONT face=Arial color=#000000 size=2>"
            s = s & " <b>Total de Materiales: " & FormatCurrency(TotalMat - TotalCGC) & "</b></p>"
            s = s & " <b>Total de Gestión de Materiales: " & FormatCurrency(TotalCGC) & "</font></b></p>"
            s = s & "<BR>"
        
        Else
            TotalMat = 0
        End If
		
        
        ' planilla de obras
        
        Set rst = DbQuery("SELECT nombre, numero, odtcontrolobraitems.texto as tieneTexto, odtcontroldeobra.texto FROM odtcontroldeobra INNER JOIN odtcontrolobraitems ON odtcontrolobraitems.numero = odtcontroldeobra.itemid WHERE activo AND codigoODT=" & codigoODT & "; ")
        		
        If recordCount(rst) > 0 Then
            
            s = s & "<FONT face=Arial color=#000000 size=3>"
            s = s & "<b>Detalle de la Planilla de Obras:</B><BR>"
            s = s & "</FONT>"
            
            s = s & "<table border='1' style='FONT-FAMILY: Arial; FONT-SIZE:14px;border-collapse: collapse' bordercolor='#C0C0C0' >"
            s = s & "<tr><td>Item</td> <td>Descripcion</td></tr>"

            While Not rst.EOF
                
                s = s & "<tr> <td>" & rst("numero") & "</td><td>" & rst("nombre") & "</td></tr>"
                
				if not IsNull(rst("texto")) then 
					s = s & "<tr><td>OBS</td><td>" & rst("texto") & "</td></tr>" 
				end if

                rst.MoveNext
            Wend
            
            s = s & "</table>"

            s = s & "<BR>"
        
        End If
        
        s = s & "<FONT face=Arial color=#000000 size=3>"
        s = s & " <b>Total de la OT: " & FormatCurrency(TotalMO + TotalMat) & "</font></b></p>"
        s = s & "<FONT face=Arial color=#000000 size=2>"
		if not IsNull(rstODT("ComentariosSG")) then
            if rstODT("ComentariosSG") <> "" then
                s = s & "<b> Comentarios:</b> " & rstODT("ComentariosSG") & "<BR><BR>"
            end if
        end if
		s = s & "<FONT face=Arial color=#000000 size=2>"
        s = s & "Se debitará este Trabajo de la Cuenta: <B>" & obtenercuentasap(rstODT("codigocuenta")) & "</B> Verifique si es correcta, en caso contrario comuníquese con Servicios Generales." & "<BR>"
        s = s & "Sr. Usuario: En caso de estar de acuerdo con la tarea desarrollada y su costo, por favor proceder a su aprobación." & "<BR>"
        s = s & "Del mismo modo, agradeceremos que nos informe si no quedara satisfecho con algún " & "<BR>"
        s = s & "detalle de la misma." & "<BR><BR>"
        s = s & "<P>Muchas Gracias. " & "<BR>"
        s = s & "</FONT>"
        
        sendmail USUARIO_DEFAULT, "amillach@dow.com;" & rstODT("MNsolicitante") , "ODT | Aprobación de la Orden de Trabajo Nro: " & codigoODT, s
		
    End If
    
End Function


Function ODT_mail_presupuesto(codigoODT)

    Set rst = DbQuery("SELECT * FROM ODTs WHERE codigoODT=" & codigoODT)
    
    s = ""
    If Not rst.EOF Then
        
        s = s & "<FONT face=Arial color=#000000 size=3>"
        s = s & "<STRONG>Pedido de Presupuesto</STRONG>"
        s = s & "</FONT><BR><BR>"
        s = s & "<FONT face=Arial color=#000000 size=2>"
        s = s & "Fecha Solicitada: <B>" & formatoDia(rst("FechaHoraSolicitud")) & "</B>"
        s = s & "<P>Nro. de Solicitud: " & rst("codigoODT") & "<BR>"
        s = s & "Solicitante: <b>" & obtenerNombre(rst("MNsolicitante")) & "</B><BR><BR>"
        s = s & "Planta: <b>" & obtenerPlantaODT(rst("codigoPlanta")) & "</B><BR><BR>"
        s = s & "Edificio: <b>" & obtenerEdificioODT(rst("codigoEdificio")) & "</B><BR><BR>"
        s = s & "Ubicación de la Tarea: <b>" & rst("UbicacionTarea") & "</B><BR><BR>"
        s = s & "Contacto: <b>" & obtenerNombre(rst("MNcontacto")) & "</B><BR><BR>"
        s = s & "Prioridad: <b>" & obtenerPrioridadODT(rst("codigoPrioridad")) & "</B><BR><BR>"
        s = s & "Descripción de la Tarea: <BR><BR>" & rst("DescripcionODT")
        
        s = s & "<P>Gracias. </FONT>"
        
        aQuien = USUARIO_DEFAULT & ";" & BuscaMnResponsablesDow & "; " & rst("MNdefinidor") & ";amillach@dow.com; " & BuscaMNMicser
                
        sendmail USUARIO_DEFAULT, aQuien, "ODT | Presupuesto ODT Nro: " & codigoODT, s
    
    End If
	
End Function


Function ODT_mail_confirmado(codigoODT)

	Set rst = DbQuery("SELECT * FROM ODTs WHERE codigoODT=" & codigoODT)
    
    s = ""
    If Not rst.EOF Then
        
        s = s & "<FONT face=Arial color=#000000 size=3>"
        s = s & "<STRONG>Orden de Trabajo Confirmada</STRONG>"
        s = s & "</FONT><BR><BR>"
        s = s & "<FONT face=Arial color=#000000 size=2>"
        s = s & "Fecha Solicitada: <B>" & formatoDia(rst("FechaHoraSolicitud")) & "</B>"
        s = s & "<P>Nro. de Solicitud: " & rst("codigoODT") & "<BR>"
        s = s & "Solicitante: <b>" & obtenerNombre(rst("MNsolicitante")) & "</B><BR><BR>"
        s = s & "Planta: <b>" & obtenerPlantaODT(rst("codigoPlanta")) & "</B><BR><BR>"
        s = s & "Edificio: <b>" & obtenerEdificioODT(rst("codigoEdificio")) & "</B><BR><BR>"
        s = s & "Ubicación de la Tarea: <b>" & rst("UbicacionTarea") & "</B><BR><BR>"
        s = s & "Contacto: <b>" & obtenerNombre(rst("MNcontacto")) & "</B><BR><BR>"
        s = s & "Prioridad: <b>" & obtenerPrioridadODT(rst("codigoPrioridad")) & "</B><BR><BR>"
        s = s & "Aprobador: <b> " & obtenerNombre(rst("MNaprobador")) & "</B><BR><BR>"
        s = s & "Descripción de la Tarea: <BR>" & rst("DescripcionODT")
        
        s = s & "<BR><BR>"
        s = s & "Se debitará este trabajo de la Cuenta: <B>" & obtenerCuentaSap(rst("codigoCuenta")) & "</B> Verifique si es correcta, en caso contrario comuníquese con Servicios Integrados."
        
        s = s & "<P>Gracias. </FONT>"
        
        aQuien = rst("MNsolicitante") & ";" & rst("MNdefinidor") ' & ";" & BuscaMnResponsablesDow
        
        ' Paulo Yañez no quiere que le lleguen los mails
        If UCase(rst("MNAprobador")) <> "U391451" Then
            aQuien = aQuien & " ; " & rst("MNAprobador")
        End If
    on error resume next		
		aQuien = aQuien & ";" 

' Modificacion Devic
Dim modi
modi = ""
modi = modi & "<FONT face=Arial color=#000000 size=2>"
modi = modi & "<B>Numero:" & """" & rst("codigoODT") & "</B><BR>"
modi = modi & "Solicitante:<b>" & """" & obtenerNombre(rst("MNsolicitante")) & "</B><BR>"
modi = modi & "Fecha:<B>" & """" & formatoDia(rst("FechaHoraSolicitud")) & "</B><BR>"
modi = modi & "Planta:<b>" & """" & obtenerPlantaODT(rst("codigoPlanta")) & "</B><BR>
modi = modi & "Edificio:<b>" & """" & obtenerEdificioODT(rst("codigoEdificio")) & "</B><BR>"
modi = modi & "Ubicacion:<b>" & """" & rst("UbicacionTarea") & "</B><BR>"
modi = modi & "Contacto:<b>" & """" & obtenerNombre(rst("MNcontacto")) & "</B><BR>"
modi = modi & "Prioridad:<b>" & """" & obtenerPrioridadODT(rst("codigoPrioridad")) & "</B><BR>"
modi = modi & "Definidor:<b>" & """" & obtenerNombre(rst("MNdefinidor")) & "</B><BR>"
modi = modi & "Tarea: <B>" & """" & rst("DescripcionODT") & "</B><BR></FONT>"
' fin Modificacion Devic


        sendmail USUARIO_DEFAULT, aQuien, "ODT | Confirmada Orden de Trabajo Nro: " & codigoODT, s
        sendmail USUARIO_DEFAULT, "AMillach@dow.com", "ODT | Confirmada Orden de Trabajo Nro: " & codigoODT, s       
        sendmail USUARIO_DEFAULT, "AMillach@dow.com", "ODT Nro: " & codigoODT, modi       



	End If

End Function



%>