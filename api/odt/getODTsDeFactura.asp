<!--#INCLUDE file= "../../include/config.asp"-->

<%

  Set myODT = New odt
  myODT.getODTsDeFactura(Request("codigoFactura"))
  

  
%>