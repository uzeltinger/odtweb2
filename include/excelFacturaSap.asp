<!--#INCLUDE file= "config.asp"-->
<!--#INCLUDE file= "util.asp"-->

<head>
<style type="text/css">
.style1 {
	border-collapse: collapse;
	border-left-style: solid;
	border-left-width: 1px;
	border-right: 1px solid #C0C0C0;
	border-top-style: solid;
	border-top-width: 1px;
	border-bottom: 1px solid #C0C0C0;
}
</style>
</head>

<%
' Tells the browser to use Excel to open the file
Response.ContentType = "application/vnd.ms-excel"

sql = "(select version, '1', sistemacuentas.Cuentasap, '', 'k', codigoSAP, sum(cant), odts.codigoODT, odts.FechaRealizacion, DATE(NOW()), sistemausuarios.Nombre, LEFT(TRIM(odts.DescripcionODT),90), sum(cant) * odtitems.precio from odtitemsrealizados "
sql = sql + "inner join odtitems on odtitemsrealizados.codigoItem = odtitems.codigoItem "
sql = sql + "inner join odts on odts.codigoODT = .odtitemsrealizados.CodigoODT "
sql = sql + "inner join sistemausuarios on odts.MNSolicitante = sistemausuarios.MN "
sql = sql + "left join sistemacuentas on odts.codigoCuenta = sistemacuentas.codigoCuenta "
sql = sql + "where codigoFactura = '" + request.querystring("codigoFactura") + "' group by codigoODT,odtitems.codigoItem order by codigoODT, odtitems.numeroItem) "

sql = sql + "UNION" 

sql = sql + "(select 4700112166, '1', sistemacuentas.Cuentasap, '', 'k', '3006799', ROUND(sum(cant * precio),2), odts.codigoODT, odts.FechaRealizacion, DATE(NOW()), sistemausuarios.Nombre, LEFT(TRIM(odts.DescripcionODT),90),  sum(cant * precio)  from odtitemsmateriales "
sql = sql + "inner join odts on odts.codigoODT = .odtitemsmateriales.CodigoODT "
sql = sql + "inner join sistemausuarios on odts.MNSolicitante = sistemausuarios.MN "
sql = sql + "left join sistemacuentas on odts.codigoCuenta = sistemacuentas.codigoCuenta "
sql = sql + "where codigoFactura = '" + request.querystring("codigoFactura") + "' "
sql = sql + "group by codigoODT ) "

sql = sql + "order by codigoODT"

'log (sql)


Set rst1 = DbQuery(sql)

'CONCAT(YEAR(NOW()), '-', DAY(NOW()), '-', MONTH(NOW()))

%>

<TABLE class="style1">
  <THEAD>        
    <TR>
      <TH BGCOLOR="BLUE"><B><FONT  color=white face=Arial size=2>PO Number</FONT></B></TH>
      <TH BGCOLOR="BLUE"><B><FONT color=white face=Arial size=2>item nr</FONT></B></TH>
      <TH BGCOLOR="BLUE"><B><FONT color=white face=Arial size=2>Cost Object</FONT></B></TH>
	  <TH BGCOLOR="BLUE"><B><FONT color=white face=Arial size=2>GL Account</FONT></B></TH>
      <TH BGCOLOR="BLUE"><B><FONT color=white face=Arial size=2>Account Assignment Category</FONT></B></TH>
      <TH BGCOLOR="BLUE"><B><FONT color=white face=Arial size=2>Service</FONT></B></TH>
      <TH BGCOLOR="BLUE"><B><FONT color=white face=Arial size=2>Quantity or Monetary Amount</FONT></B></TH>
      <TH BGCOLOR="BLUE"><B><FONT color=white face=Arial size=2>External Number</FONT></B></TH>
      <TH BGCOLOR="BLUE"><B><FONT color=white face=Arial size=2>Date of Service</FONT></B></TH>
      <TH BGCOLOR="BLUE"><B><FONT color=white face=Arial size=2>Post Date For Dow use Only</FONT></B></TH>
      <TH BGCOLOR="BLUE"><B><FONT color=white face=Arial size=2>Long Text</FONT></B></TH>
      <TH BGCOLOR="BLUE"><B><FONT color=white face=Arial size=2></FONT></B></TH>
    </TR>
  </THEAD>
  <TBODY>    
     
    <%
	While Not rst1.EOF
	
	' para cada odt obtener los materiales 
	' y calcular el valor agregado por gestión de materiales
	' para cada item agrupados por factura

	mysql = "select * from odtitemsmateriales where codigoODT = " & rst1(7) 
	mysql = mysql + " order by NroFactura ASC"
	Set rsOdts = DbQuery(mysql)			

	totalDeLaOrden = 0
	totalDeLaFactura = 0
	codigoFacturaAnterior = 0

	While Not rsOdts.EOF
		
		precioMateriales = rsOdts(3) * rsOdts(4)
		
		if codigoFacturaAnterior = rsOdts(6) Then

			totalDeLaFactura = totalDeLaFactura + precioMateriales
			totalUltimaFactura = totalDeLaFactura

		else

			'calcular % de agregado				
			if totalDeLaFactura >= CGCobtenerImporte(now) then
				totalDeLaFactura = totalDeLaFactura * (1 + CGCobtenerCGC2(now))
			else
				totalDeLaFactura = totalDeLaFactura * (1 + CGCobtenerCGC1(now))					
			end if

			totalDeLaOrden = totalDeLaOrden + totalDeLaFactura
			totalDeLaFactura = precioMateriales
			totalUltimaFactura = totalDeLaFactura

		end if					

		codigoFacturaAnterior = rsOdts(6)
		
		for i = 0 to rsOdts.fields.count -1 
			v = rsOdts(6)		
			' 3 * 4 si 6 es la misma factura
		next
		rsOdts.MoveNext
	Wend




	'calcular % de agregado para la ultima factura que no entra en el ciclo'				
	if totalUltimaFactura >= CGCobtenerImporte(now) then
		totalUltimaFactura = totalUltimaFactura * (1 + CGCobtenerCGC2(now))	
	else
		totalUltimaFactura = totalUltimaFactura * (1 + CGCobtenerCGC1(now))
	end if

	totalDeLaOrden = totalDeLaOrden + totalUltimaFactura
     %>
     
     <TR>
       <% for i = 0 to rst1.fields.count -1 
			v = rst1(6)
	   %>
       <TD><FONT face=Arial color=#000080 size=2><%
	   if rst1(5) = "3006799" and i=5 then
			if v >= CGCobtenerImporte(now) then
				response.write "3006798"
			else
				response.write "3006799"
			end if
	   else
	   if (rst1(5) = "3002730" or rst1(5) = "3008592") and i=6 then
			response.write rst1(i) * 1.10
		else
			if (rst1(5) = "3006799") and (i=6 or i=12) then
			response.write totalDeLaOrden
			else
				if i=8 or i=9 then
					 
					if isDate(rst1(i)) then
							response.write day(rst1(i)) & "/" & month(rst1(i)) & "/" & year(rst1(i))  
					end if
				else
					response.write rst1(i)
				end if
			end if
		end if
	    end if
	   %></FONT></TD>
       <% next %>
     </TR>
     
     <%
        rst1.MoveNext
        
    Wend
    
     %>
  </TBODY>
</TABLE>