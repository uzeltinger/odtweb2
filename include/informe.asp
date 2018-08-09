<!--#INCLUDE file= "config.asp"-->
<!--#INCLUDE file= "util.asp"-->
<head>
<meta charset="utf-8">
<style type="text/css">
	table tr td {
        padding: 4px;
    }
</style>
</head>
<%
mostrarConsultas = false
'Dim desdeInforme, hastaInforme

' Tells the browser to use Excel to open the file
'Response.ContentType = "application/vnd.ms-excel"

codigoInforme = request.querystring("codigoInforme")    
    sql = "SELECT * FROM odtinformes "
    sql = sql + "WHERE " + "codigoInforme = """ + codigoInforme + """"
    Set rst = DbQuery(sql)
    If Not rst.EOF Then
        numeroInforme = rst("numeroInforme")
        nombreInforme = rst("nombreInforme")
        desdeInforme = rst("desdeInforme")
        hastaInforme = rst("hastaInforme")
    End if

if mostrarConsultas Then
%>

<table>
<tr><td colspan="4">Datos del informe</td></tr>
    <tr>
        <td>Informe nยบ: </td><td><% response.write(numeroInforme) %></td>
        <td>Nombre: </td><td><% response.write(nombreInforme) %></td>
        <td>Desde: </td><td><% response.write(desdeInforme) %></td>
        <td>Hasta: </td><td><% response.write(hastaInforme) %></td>
    </tr>
</table>

<%
End if

odtsFilter = ""
    sql2 = "SELECT * FROM odtinformecolumna WHERE idInforme = """ + codigoInforme + """ AND colFiltrar = ""1"""

if mostrarConsultas Then
    response.write sql2
End if

    Set result = DbQuery(sql2)

    While Not result.EOF
        odtsFilter = odtsSelect & " AND " & result("idColumna") & " = """ & result("colFiltro") & """"
        'response.write "odtsFilter"        
          
        result.MoveNext
    Wend

if mostrarConsultas Then
    response.write odtsFilter
End if 

odtsSelect = ""

' Tells the browser to use Excel to open the file
'Response.ContentType = "application/vnd.ms-excel"
 
    sql3 = "SELECT * FROM odtinformecolumna WHERE idInforme = """ + codigoInforme + """ AND colMostrar = ""1"""
    'response.write(sql);
    Set result3 = DbQuery(sql3)  
    tot = recordCount(result3)  
    'response.write tot 
    If recordCount(result3) > 0 Then
    s = ""
    s = s & "<table border='1' style='FONT-FAMILY: Arial; FONT-SIZE:14px;border-collapse: collapse' bordercolor='#C0C0C0' >"
            s = s & "<tr> <td>idColumna</td> <td>nombreColumna</td> <td>colMostrar</td> <td>colNombre </td> <td>colFiltrar</td> <td>colFiltro</td></tr>"
        While Not result3.EOF
                s = s & "<tr>"
                s = s & "<td>" & result3("idColumna") & "</td>"
                if result3("nombreColumna") = "" Then
                    s = s & "<td>" & result3("idColumna") & "</td>"
                Else
                    s = s & "<td>" & result3("nombreColumna") & "</td>"
                End if
                s = s & "<td>" & result3("colMostrar") & "</td>"  
                s = s & "<td>" & result3("colNombre") & "</td>"  
                s = s & "<td>" & result3("colFiltrar") & "</td>"  
                s = s & "<td>" & result3("colFiltro") & "</td>"  
                s = s & "</tr>"				
                result3.MoveNext
        Wend        
            s = s & "</table>"
    End if

sql3 = "SELECT * FROM odtinformecolumna WHERE idInforme = """ + codigoInforme + """ AND colMostrar = ""1"""
    
    Set result3 = DbQuery(sql3)  
    tot = recordCount(result3)      
    If recordCount(result3) > 0 Then
    i = 0
        table = ""
        tableHeader = "<table border='1' style='FONT-FAMILY: Arial; FONT-SIZE:14px;border-collapse: collapse'; bordercolor='#C0C0C0'; >"
        tableHeader = tableHeader & "<tr>"
        While Not result3.EOF
        if i > 0 Then odtsSelect = odtsSelect & "," End if
            odtsSelect = odtsSelect & "" & result3("idColumna") & ""
            if result3("colNombre") = "" Then
                tableHeader = tableHeader & "<td>" & result3("nombreColumna") & "</td>"  
            Else
                tableHeader = tableHeader & "<td>" & result3("colNombre") & "</td>"  
            End if
                      		
            result3.MoveNext
            i = i + 1
        Wend    
        tableHeader = tableHeader & "</tr>"        
       
        'response.write "campos a seleccionar de odts <br>" & odtsSelect
    'set RS = Conn.Execute(sql4)
    End if

desdeInforme = FormatFechaSql(desdeInforme)
hastaInforme = FormatFechaSql(hastaInforme)

sql3 = "SELECT "&odtsSelect&" FROM odts WHERE fechaCreacion BETWEEN '"+desdeInforme+"' AND '"+hastaInforme+"' " & odtsFilter

if mostrarConsultas Then
response.write "<br>" 
response.write sql3 
response.write "<br><br>" 
End if

Set result3 = DbQuery(sql3)  
    tot = recordCount(result3)      
    If recordCount(result3) > 0 Then
    i = 0
        tableBody = ""
        While Not result3.EOF
            tableBody = tableBody & "<tr>"
            For Each col In result3.Fields
            tableBody = tableBody & "<td>" & getColumnValue(col.Name,col.Value) & "</td>"             
            Next 
            tableBody = tableBody & "</tr>"   
            result3.MoveNext
            i = i + 1
        Wend
    End if

tableFooter = "</table>"

table = table & tableHeader
table = table & tableBody
table = table & tableFooter  

response.write table

' out = out + ",""fechaMostrar"":""" & formatearFechaAMostrar(rs("fechaCreacion")) & """"

Function getColumnValue(name,value)

    if name = "MNSolicitante" Or name = "MNAprobador" Or name = "MNcontacto" Or name = "MNdefinidor" Or name = "MNAnulacion" Or name = "mnCreacion" Then
        value = obtenerNombre(value)
    End if
    if name = "codigoPlanta" Then
        value = obtenerPlantaODT(value)
    End if
    if name = "codigoPrioridad" Then
        value = obtenerPrioridadODT(value)
    End if
    if name = "codigoEdificio" Then
        value = obtenerEdificioODT(value)
    End if    
    if name = "FechaHoraSolicitud" Or name = "fechaCreacion" Then
        value = formatearFechaAMostrar(value)
    End if  
    if name = "codigoCuenta" Or name = "codigoCuenta" Then
        value = obtenerCuentaSap(value)
    End if
    
    getColumnValue = value

End Function
%>