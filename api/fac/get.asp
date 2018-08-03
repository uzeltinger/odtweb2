<!--#INCLUDE file= "../../include/config.asp"-->

<%

  Set f = New Factura

  f.getFactura(Request("codigoFactura"))
  
%>