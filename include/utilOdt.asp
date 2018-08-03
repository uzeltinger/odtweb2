<!--#INCLUDE file= "include/config.asp"-->
<!--#INCLUDE file= "include/util.asp"-->
<%

Dim CoeficienteGestionMateriales

Function obtenerPlantaODT(codigoPlanta) 
    
    Set rst = DbQuery("SELECT * FROM Plantas WHERE activo AND codigoPlanta = '" & codigoPlanta & "'")
    
    If Not rst.EOF Then
        obtenerPlantaODT = rst("NombrePlanta")
    Else
        obtenerPlantaODT = ""
    End If

End Function

Function obtenerPrioridadODT(codigoPrioridad)
    
    Set rst = DbQuery("SELECT * FROM ODTPrioridades WHERE activo AND codigoPrioridad = '" & codigoPrioridad & "'")
    
    If Not rst.EOF Then
        obtenerPrioridadODT = rst("Prioridad")
    Else
        obtenerPrioridadODT = ""
    End If

End Function

Function totalODT(codigoODT As Long) As Single

    totalODT = totalODTmanoDeObra(codigoODT) + totalODTmateriales(codigoODT)

End Function

Function totalODTmanoDeObra(codigoODT As Long) As Single
Dim rst As ADODB.Recordset
Dim Total As Single
Dim sql As String

    sql = "SELECT ODTItems.Descripcion, ODTItems.Precio, ODTitemsRealizados.Cant, ODTitemsRealizados.Observaciones " & _
        "FROM ODTitemsRealizados INNER JOIN ODTItems ON ODTitemsRealizados.codigoItem = ODTItems.codigoItem " & _
        "WHERE (((ODTitemsRealizados.CodigoODT)=" & codigoODT & ")) ORDER BY nroOrden;"
        
    Set rst = DbQuery(sql)
    
    Total = 0
    
    While Not rst.EOF
        
        Total = Total + (rst("cant") * rst("precio"))
        rst.MoveNext
        
    Wend
            
    totalODTmanoDeObra = Total

End Function

Function totalODTmateriales(codigoODT As Long) As Single
Dim sql As String
Dim f As Date
Dim rst As ADODB.Recordset
Dim Total As Single
Dim subtotal As Single
Dim gestionMateriales As Single
                
    sql = "SELECT  ODTs.FechaRealizacion, ODTItemsMateriales.NroOrden, ODTItemsMateriales.MaterialesTxt, ODTItemsMateriales.Cant, ODTItemsMateriales.Precio, Observaciones " & _
    "FROM ODTItemsMateriales INNER JOIN ODTs ON ODTItemsMateriales.CodigoODT = ODTs.codigoODT " & _
    "where (((ODTItemsMateriales.codigoODT) = " & codigoODT & ")) ORDER BY ODTItemsMateriales.fechaCreacion;"

    Set rst = DbQuery(sql)
    subtotal = 0
    
    If Not rst.EOF Then
    
        If evitarNULL(rst("fechaRealizacion")) = "" Then
            f = Date
        Else
            f = rst("fechaRealizacion")
        End If
        
        CoeficienteGestionMateriales = ObtenerCGC(f)
    
        While Not rst.EOF
            
            subtotal = subtotal + (rst("cant") * rst("precio"))
            
            rst.MoveNext
            
        Wend
        
        gestionMateriales = (subtotal * CoeficienteGestionMateriales)
    
        subtotal = subtotal + gestionMateriales
    
    End If
    
    totalODTmateriales = subtotal

End Function

Function totalCuenta(cuenta As String, facturaNro As String, desde As Date, hasta As Date) As Single
Dim i
Dim inx As Long
Dim sql As String
Dim fecha As String
Dim f As Date
Dim rst As ADODB.Recordset
Dim Total As Single
Dim subtotal As Single

    sql = "SELECT ODTs.FacturaNro, ODTs.Cuenta, ODTs.codigoODT from ODTs where  ( ((ODTs.activo)) And ((ODTs.facturaNro) = '" & facturaNro & "') And ((ODTs.cuenta) = '" & cuenta & "')) " & _
    " AND (ODTs.FechaHoraSolicitud >= '" & Format(desde, fechaSQL) & "') And (ODTs.FechaHoraSolicitud <= '" & Format(hasta, fechaSQL) & "')"
    
    Set rst = DbQuery(sql)
    
    Total = 0
    
    While Not rst.EOF
        
        Total = Total + totalODT(rst("codigoODT"))
        
        rst.MoveNext
    Wend
                
        
    totalCuenta = Total

End Function


Sub ExportarFacturadas(desde As Date, hasta As Date)
Dim i
Dim inx As Long
Dim sql As String
Dim fecha As String
Dim f As Date
Dim rst As ADODB.Recordset
Dim Total As Single
Dim subtotal As Single
Dim cc As String
Dim fn As String

    sql = "SELECT ODTs.FacturaNro, ODTs.Cuenta from ODTs " & _
        " where (((ODTs.FechaHoraSolicitud) >= '" & Format(desde, fechaSQL) & "' And (ODTs.FechaHoraSolicitud) <= '" & Format(hasta, fechaSQL) & "') And ((ODTs.activo))) " & _
        " GROUP BY ODTs.FacturaNro, ODTs.Cuenta " & _
        " HAVING (((ODTs.FacturaNro)<>'') AND ((ODTs.Cuenta)<>'')) " & _
        " ORDER BY ODTs.FacturaNro, ODTs.Cuenta;"

    Set rst = DbQuery(sql)
        
    cc = ""
    fn = ""
    If Not rst.EOF Then
        iniciaEXCEL '"Factura Nro " & rst("FacturaNro")
        'agregarAEXCEL "Factura", "Nro" & rst("FacturaNro")
        
        While Not rst.EOF
            If fn <> evitarNULL(rst("FacturaNro")) Then
                fn = rst("FacturaNro")
                agregarHojaEXCEL "Factura Nro " & rst("FacturaNro")
                agregarAEXCEL "Factura Nro " & rst("FacturaNro")
                agregarAEXCEL "Cuenta", "Cost Center", "Total"
            End If
            subtotal = totalCuenta(evitarNULL(rst("Cuenta")), evitarNULL(rst("facturaNro")), desde, hasta)
            agregarAEXCEL evitarNULL(rst("Cuenta")), obtenerCostCenter(evitarNULL(rst("Cuenta"))), Round(subtotal, 2)
            
            rst.MoveNext
        Wend
        finalizaEXCEL
    End If
End Sub

Function BuscaMNMicser() As String
Dim rst As ADODB.Recordset
Dim sql As String
    
    sql = "SELECT * FROM SistemaConfiguracion WHERE Dato = 'ResponsableMicserMN';"
    Set rst = DbQuery(sql)
    BuscaMNMicser = rst!texto
    
End Function

Function BuscaMnResponsablesDow() As String
Dim rst As ADODB.Recordset
Dim sql As String
    
    sql = "SELECT texto FROM SistemaConfiguracion WHERE Dato = 'ResponsableDowMN';"
    Set rst = DbQuery(sql)
    If Not rst.EOF Then
        BuscaMnResponsablesDow = rst!texto
    End If
    
End Function


   

Function ObtenerCGC(fecha As Date) As Single
Dim rst As Object
    
    Set rst = DbQuery("SELECT ODTCoefGestionCompra.CGC FROM ODTCoefGestionCompra WHERE ODTCoefGestionCompra.FechaValidez <= '" & Format(fecha, fechaSQL) & "' ORDER BY ODTCoefGestionCompra.FechaValidez DESC LIMIT 1;")
    
    If rst.EOF Then
        ObtenerCGC = 0
    Else
        ObtenerCGC = rst!CGC
    End If

End Function

Function obtenerPrioridad(codigoPrioridad As String) As String
Dim rst As Object
    
    Set rst = DbQuery("SELECT Prioridad FROM ODTprioridades WHERE activo AND codigoPrioridad= '" & codigoPrioridad & "';")
    If rst.EOF Then
        obtenerPrioridad = ""
    Else
        obtenerPrioridad = rst!Prioridad
    End If
    
End Function

Function obtenerItem(IDItem As Long) As String
Dim rst As Object
    
    Set rst = DbQuery("SELECT descripcion FROM ODTitems WHERE IDitem= " & str(IDItem) & ";")
    If rst.EOF Then
        obtenerItem = ""
    Else
        obtenerItem = rst!Descripcion
    End If
    
End Function

Function obtenerEdificio(codigoEdificio) As String
Dim rst As ADODB.Recordset
    
    Set rst = DbQuery("SELECT * FROM ODTEdificios WHERE activo AND codigoEdificio = " & str(codigoEdificio))
    
    If Not rst.EOF Then
        obtenerEdificio = rst("Edificio")
    Else
        obtenerEdificio = ""
    End If

End Function

Function BuscaPrecioItem(IDItem As Long, CodigoPrecio As Byte) As Currency
Dim rst As Object
Dim sql As String
Dim cp As Long

    If CodigoPrecio = 0 Then
        cp = MaxCod()
    Else
        cp = CodigoPrecio
    End If
    
    sql = "SELECT ODTItems.IDitem, ODTItems.Precio FROM ODTItems WHERE ODTItems.IDitem = " & str(IDItem) & " and ODTItems.CodigoPrecio = " & str(cp) & ";"
    'Debug.Print sql
    
    Set rst = DbQuery(sql)
    
    If rst.recordCount = 0 Then
        BuscaPrecioItem = 0
    Else
        BuscaPrecioItem = rst!Precio
    End If
    
    rst.Close

End Function

Public Function MaxCod()
Dim rst As Object
    
    Set rst = DbQuery("SELECT * From ODTItems ORDER BY ODTItems.CodigoPrecio DESC")
    
    MaxCod = rst!CodigoPrecio
    
    rst.Close

End Function

Public Function MaxFechaVigencia()
Dim rst As Object
    
    Set rst = DbQuery("SELECT FechaVigencia From ODTItems ORDER BY ODTItems.FechaVigencia DESC LIMIT 1")
    
    MaxFechaVigencia = rst!fechaVigencia
    
    rst.Close

End Function
%>