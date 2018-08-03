<!--#INCLUDE file= "../../include/config.asp"-->

<%
' obtiene ODT: ID = codigoODT (0 lista TODAS), ini = (0)

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

  Set myODT = New odt
  myODT.getAAuditar ultima, search 
  


  
%>