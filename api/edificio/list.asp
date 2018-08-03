<!--#INCLUDE file= "../../include/config.asp"-->

<%
  
	if request.querystring("ultima") <> "" then
		ultima = request.querystring("ultima")
	else
		ultima = 0
	end if
	
	if request.querystring("buscar") <> "" then
		search = request.querystring("buscar")
	else
		search = ""
	end if

  Set e = New Edificio
  e.getList ultima, search

  
%>