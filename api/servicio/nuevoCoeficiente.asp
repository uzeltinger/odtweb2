<!--#INCLUDE file= "../../include/config.asp"-->
<%
    Set s = New Servicio
    FechaValidez = formatSQL(Request.QueryString("FechaValidez"))
    importeHasta = Request.QueryString("importeHasta")

    CGC1 = Request.QueryString("CGC1")
    CGC2 = Request.QueryString("CGC2")
    
    if csng("1,7") = 1.7 then
        CGC1 = replace(CGC1,".",",")
        CGC2 = replace(CGC2,".",",")
    end if
    
    s.nuevoCoeficiente FechaValidez, CGC1, CGC2, importeHasta
    
%>