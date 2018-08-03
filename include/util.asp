<% 
' UTILS

Function DbQuery(sql)
	Set DbQuery = conexion.Execute(sql)
End Function

Function DbOpen(sql)

    If instr(1, trim(sql), " ") = 0 Then
        sql = "SELECT * FROM " & sql & " WHERE 0=1;"
    End If

    'If instr(1, trim(sql), "SELECT") = 0 Then
    '    sql = "No se puede usar DbOpen con una query que no sea SELECT"
    'End If
    
    set DbOpen = Server.CreateObject("ADODB.RecordSet")
	DbOpen.LockType = 2
    DbOpen.Open sql, conexion, 2

End Function

function recordCount(r)
	
	recordCount = 0
	
	if r.eof then exit function 
	
	r.movefirst
	
	i = 0
	
	while not r.eof
	
		i = i + 1
		r.movenext
	wend
	
	recordCount = i
	
	r.movefirst
	
end function

function obtenerCuentaSap(codigoCuenta)

	Set rst = DbQuery("SELECT * FROM sistemacuentas WHERE activo AND codigoCuenta = " & codigoCuenta)
    
    If Not rst.EOF Then
        obtenerCuentaSap = rst("cuentaSAP")
		if not isnull(rst("descripcion")) then
			obtenerCuentaSap = obtenerCuentaSap & " | " & rst("descripcion")
		end if
    Else
        obtenerCuentaSap = ""
    End If


end function

Function QueryToJSON(dbc, sql)
        Dim rs, jsa, col
        Set rs = dbc.Execute(sql)
        Set jsa = jsArray()
        While Not (rs.EOF Or rs.BOF)
                Set jsa(Null) = jsObject()
                For Each col In rs.Fields
					if isDate(col.Value) then
                        V = year(col.Value) & "/" & month(col.Value) & "/" & day(col.Value) & " " & hour(col.Value) & ":" & minute(col.Value) & ":" & second(col.Value)  
					else 
						v =  col.Value
					end if
                    jsa(Null)(col.Name) = v
                Next
        rs.MoveNext
        Wend
        Set QueryToJSON = jsa
End Function


Function SingleObjectQueryToJSON(sql)
        Dim rs, jsa, col
        Set rs = conexion.Execute(sql)
        Set jsa = jsObject()
        
        if Not (rs.EOF Or rs.BOF) then
            
            For Each col In rs.Fields
                if isDate(col.Value) then
                    V = year(col.Value) & "/" & month(col.Value) & "/" & day(col.Value) & " " & hour(col.Value) & ":" & minute(col.Value) & ":" & second(col.Value)  
                else 
                    v =  col.Value
                end if
                jsa(col.Name) = v
            Next
        end if
        
        Set SingleObjectQueryToJSON = jsa
End Function


Function QueryToSelect(sql, seleccionado)
        Dim rs, jsa, col
        Set rs = conexion.Execute(sql)
        
        if seleccionado = "" then
            QueryToSelect="<option value='-99'>Seleccione...</option>"
        else 
            QueryToSelect = ""
        end if
        
        While Not (rs.EOF Or rs.BOF)
            QueryToSelect = QueryToSelect & "<option value='" & trim(rs.Fields(0)) & "'" 
			if rs.Fields(0) = seleccionado then
				QueryToSelect = QueryToSelect & " selected "
			end if 
			QueryToSelect = QueryToSelect & ">" & trim(rs.Fields(1)) & "</option>"
			rs.MoveNext
        Wend
End Function



Function encodeStr(str)
  Dim charmap(127), haystack()
  charmap(8)  = "\b"
  charmap(9)  = "\t"
  charmap(10) = "\n"
  charmap(12) = "\f"
  charmap(13) = "\r"
  charmap(34) = "\"""
  charmap(47) = "\/"
  charmap(92) = "\\"

  Dim strlen : strlen = Len(str) - 1
  ReDim haystack(strlen)

  Dim i, charcode
  For i = 0 To strlen
    haystack(i) = Mid(str, i + 1, 1)

    charcode = AscW(haystack(i)) And 65535
    If charcode < 127 Then
      If Not IsEmpty(charmap(charcode)) Then
        haystack(i) = charmap(charcode)
      ElseIf charcode < 32 Then
        haystack(i) = "\u" & Right("000" & Hex(charcode), 4)
      End If
    Else
      haystack(i) = "\u" & Right("000" & Hex(charcode), 4)
    End If
  Next

  encodeStr = Join(haystack, "")
End Function
 

 
 
 
 Function getSublistaJSON(sql)
  
  dim comma, Value
  
  out = ""
  
  RS2.Open sql,conexion,1

  While Not (RS2.EOF Or RS2.BOF)

    out = out + "{"
    
    isFirstItem = 1
    For Each col In RS2.Fields
      if isFirstItem = 1 then 
        comma = "" 
        isFirstItem = 0
      else 
        comma = ", "
      end if

      if isNull(col.Value) then 
        Value = "" 
      else 
        Value = encodeStr(col.Value)
      end if
      
      out = out + comma + """"& col.Name &""":"""& Value &""""

    
    Next

    out = out + "}," 
  
  
    RS2.MoveNext
  Wend

  'corrige ultima coma
  if len(out) > 0 then out = left(out, Len(out) -1)
  
  

  getSublistaJSON = out
  
  RS2.Close
  
end Function

function FormatFechaSql(fecha)
    
    FormatFechaSql = year(fecha) & "-" & month(fecha) & "-" & day(fecha)
    
end function


Function log(texto)

	if PROD then exit function
    On Error Resume Next
    
      dim fs,fname
      set fs=Server.CreateObject("Scripting.FileSystemObject")
      set fname=fs.OpenTextFile("C:\Inetpub\wwwroot\odtweb\log.txt", 8) ' 8=append 2=create      
      fname.WriteLine(texto)
      fname.Close
      set fname=nothing
      set fs=nothing
      
      On Error Goto 0

End Function





Function LAST_INSERT_ID(tabla, idField)
     set rst = Server.CreateObject ("ADODB.RecordSet")
     rst.LockType = 2
     rst.Open "SELECT max("& idField &") as lastId FROM "& tabla &";",conexion    
     
     LAST_INSERT_ID = Clng(rst("lastId"))
     rst.Close
     Set rst = Nothing
     
End Function



Function lastInsertId()
     set rst = Server.CreateObject ("ADODB.RecordSet")
     rst.LockType = 2
     rst.Open "SELECT @@identity AS lastId;", conexion    
     
     lastInsertId = Clng(rst("lastId")) 
     rst.Close
     Set rst = Nothing
End Function




function estaVacia(byref var)
  estaVacia = true

  if not isEmpty(var) and not isnull(var) and var<>"" then 
    estaVacia = false    
  end if
end function



Function obtenerNombre(MN)

     Set rst = DbQuery("SELECT Nombre FROM sistemausuarios WHERE mn='" & MN & "';")    

     if not rst.EOF then
		obtenerNombre = rst("Nombre")
	 else
		obtenerNombre = ""
	 end if

     rst.Close
     Set rst = Nothing
     
End Function 

Function obtenerPlantaODT(codigoPlanta)
    
    Set rst = DbQuery("SELECT * FROM Plantas WHERE codigoPlanta = '" & codigoPlanta & "'")
    
    If Not rst.EOF Then
        obtenerPlantaODT = rst("NombrePlanta")
    Else
        obtenerPlantaODT = ""
    End If
	
	rst.Close

End Function

Function obtenerPrioridadODT(codigoPrioridad)
    
    Set rst = DbQuery("SELECT * FROM ODTPrioridades WHERE codigoPrioridad = '" & codigoPrioridad & "'")
    
    If Not rst.EOF Then
        obtenerPrioridadODT = rst("Prioridad")
    Else
        obtenerPrioridadODT = ""
    End If
	
	rst.Close

End Function

Function obtenerEdificioODT(codigoEdificio)
    
    Set rst = DbQuery("SELECT * FROM ODTEdificios WHERE codigoEdificio = " & codigoEdificio)
    
    If Not rst.EOF Then
        obtenerEdificioODT = rst("Edificio")
    Else
        obtenerEdificioODT = ""
    End If

End Function

Function mes(m) 
Dim meses
    meses = Array("", "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre")
    mes = meses(m)
End Function

Function diaDeLaSemana(d) 
Dim dias
    dias = Array("", "Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado")
    diaDeLaSemana = dias(d)
End Function

function formatearFechaAMostrar(fecha)

	dif = DateDiff("d", fecha, now())
	
	if dif > 7 then
		if dif > 365 then
			formatearFechaAMostrar = Left(mes(month(fecha)),3) & " " &  year(fecha)
		else
			formatearFechaAMostrar = day(fecha) & " " & Left(mes(month(fecha)),3)
		end if 
	else
		if dif = 0 then
			if hour(fecha) > 9 then
				h = hour(fecha)
			else
				h = "0" & hour(fecha)
			end if
			
			if minute(fecha) > 9 then
				m = minute(fecha)
			else
				m = "0" & minute(fecha)
			end if
			
			formatearFechaAMostrar = h & ":" & m & "hs"
		else
			formatearFechaAMostrar = diaDeLaSemana(Weekday(fecha))
		end if 
	end if
	
end function

Function humanizarDiferencia(desde, hasta)
Dim dif
Dim t1 
Dim t2 

    dif = DateDiff("n", desde, hasta)
    
    if dif < 3 then
            humanizarDiferencia = "un minuto"
	else 
		if dif < 60 then
            humanizarDiferencia = dif & " minutos"
        else 
			if dif < 1440 then
				t1 = Int(dif / 60)
				t2 = dif - (t1 * 60)
				humanizarDiferencia = t1 & IIf(t2 > 25, "�", "") & " hora" & IIf(t1 > 1, "s", "")
			else 
				if dif  < 43200 then
					t1 = Int(dif / 1440)
					humanizarDiferencia = t1 & " d�a" & IIf(t1 > 1, "s", "")
				else 
					if dif < 525600 then
						t1 = Int(dif / 43200)
						t2 = (dif - (t1 * 43200)) / 1440
						humanizarDiferencia = t1 & IIf(t2 > 20, "�", "") & " mes" & IIf(t1 > 1, "es", "")
					Else
						t1 = Int(dif / 525600)
						t2 = Int((dif - (t1 * 525600)) / 43200)
						humanizarDiferencia = t1 & " a�o" & IIf(t1 > 1, "s", "")
					End if
				End if
			End if
		End if
	End if
    
End Function

'Convert Binary to Decimal
Function BinaryToDec(BinaryValue) 
  Do 
    B2D = B2D + (Left(BinaryValue, 1) * 2 ^ (Len(BinaryValue) - 1)) 
    BinaryValue = Mid(BinaryValue, 2) 
  Loop Until BinaryValue = "" 

  BinaryToDec = B2D
End Function 



'Convery Decimal to Binary
Function IntToBinary(ByVal num)    
  Dim result    
  I2B="0"    
  If num<1 Then Exit Function    
  result=""    
  Do Until num<1        
    result=result&CStr(num Mod 2)        
    num = Fix(num/2)    
  Loop    
  I2B=StrReverse(result)
  IntToBinary = I2B
End Function








Function enableIf(bPuede)

  if bPuede = true then
    response.write("")
  else
    response.write(" disabled ")
  end if

End Function 





' usuarioPuede: true si coinciden cualquiera de los permisos suministrados (OR)
Function usuarioPuede(permiso) 

  puede = true
  a = PERMISOS_USUARIO AND permiso
  if a = 0 then puede = false
  usuarioPuede = puede

End Function


' usuarioPuedeTodos: true si coinciden todos los permisos suministrados (AND)
Function usuarioPuedeTodos(permiso) 

  puede = false
  if PERMISOS_USUARIO = permiso then puede = true
  usuarioPuedeTodos = puede

End Function


' usuarioPuedeRevisar: usuarioPuede(ODT_puedeRevisar)
Function usuarioPuedeRevisar(permiso) 
  puede = true
  a = USUARIO_PERMISOS_ODT AND permiso
  if a = 0 then puede = false
  usuarioPuedeRevisar = puede
End Function

Function formatSQL(fecha)

  temp = Split(fecha,"/")
  
  formatSQL = temp(2) &"-"& temp(1) &"-"& temp(0)

End Function




Function ObtenerCGC(fecha)
    
    
    sql = "SELECT ODTCoefGestionCompra.CGC FROM ODTCoefGestionCompra WHERE ODTCoefGestionCompra.FechaValidez <= '" & formatSQL(fecha) & "' ORDER BY ODTCoefGestionCompra.FechaValidez DESC LIMIT 1;"
    
    'log(sql)
    
    Set rst = conexion.Execute(sql)

    If rst.EOF Then
        ObtenerCGC = 0
    Else
        For Each col In rst.Fields
            ObtenerCGC = col.Value
        Next      
    End If

End Function




Function evitarNULL(str)
    evitarNULL = ""
    
    If Not IsNull(str) Then
        evitarNULL = Trim(str)
    End If
End Function

   
Function ObtenerFechaRealizacionODT(codigoODT)

    Set rst = DbQuery("SELECT fechaRealizacion FROM ODTs WHERE codigoODT=" & codigoODT)
    
    If rst.EOF Then
        ObtenerFechaRealizacionODT = "1-1-1"
    Else
        ObtenerFechaRealizacionODT = rst("fechaRealizacion")
    End If

End Function


Function CGCobtenerImporte(fecha)
    Set rst = DbQuery("SELECT importe FROM ODTCoefGestionCompra WHERE FechaValidez <= '" & FormatFechaSql(fecha) & "' ORDER BY FechaValidez DESC LIMIT 1;")
    
    If rst.EOF Then
        CGCobtenerImporte = 0
    Else
        CGCobtenerImporte = rst("importe")
    End If
End Function


Function CGCobtenerCGC1(fecha)
    Set rst = DbQuery("SELECT CGC FROM ODTCoefGestionCompra WHERE FechaValidez <= '" & FormatFechaSql(fecha) & "' ORDER BY FechaValidez DESC LIMIT 1;")
    
    If rst.EOF Then
        CGCobtenerCGC1 = 0
    Else
        CGCobtenerCGC1 = rst("CGC")
    End If
End Function

Function CGCobtenerCGC2(fecha)
    Set rst = DbQuery("SELECT CGC2 FROM ODTCoefGestionCompra WHERE FechaValidez <= '" & FormatFechaSql(fecha) & "' ORDER BY FechaValidez DESC LIMIT 1;")
    
    If rst.EOF Then
        CGCobtenerCGC2 = 0
    Else
        CGCobtenerCGC2 = rst("CGC2")
    End If
End Function

' Sub Pause(intSeconds)
  ' startTime = Time()
  ' Do Until DateDiff("s", startTime, Time(), 0, 0) > intSeconds
  ' Loop
' End Sub



%>