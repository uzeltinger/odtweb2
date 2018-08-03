<!--#INCLUDE file= "../../include/config.asp"-->

<%

  Set s = New Servicio

  s.getServicio(Request("codigoServicio"))
  
%>