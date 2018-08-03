<!--#INCLUDE file= "../../include/config.asp"-->

<%


  Set f = New Factura

  f.addODT Request("codigoFactura"), Request("codigoODT")
  
%>