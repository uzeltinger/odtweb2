<!--#INCLUDE file= "../../include/config.asp"-->
<%
    Set s = New Servicio
    FechaVigencia = formatSQL(Request("FechaVigencia"))
    
    s.nuevoListadoServicios FechaVigencia, Request("version")
    
    's.nuevoListadoServicios("2013-02-01")

%>