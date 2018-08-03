<!--#INCLUDE file= "../../include/config.asp"-->

<%
    ' fecha en el formato aaaa-mm-dd
    
	if request.querystring("fecha") <> "" then
        
        splito = split(request.querystring("fecha"), "-")
        a = splito(0)
        m = splito(1)
        d = splito(2)
        
        fecha = dateserial(a,m,d)
        
        Set e = New Odt
        e.getSemana fecha ,""
    end if
  
%>