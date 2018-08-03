<!--#INCLUDE file= "../../include/config.asp"-->

<%

  Set e = New Edificio

  e.getEdificio(Request("codigoEdificio"))
  
%>