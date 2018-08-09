<!--#INCLUDE file= "../../include/config.asp"-->

<%

  Set myODT = New odt
  myODT.getColumnasDelInforme(Request("codigoInforme"))
  
  
%>