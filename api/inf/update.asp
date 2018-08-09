<!--#INCLUDE file= "../../include/config.asp"-->
<%
  Set i = New Informe
  Response.write(Request.ServerVariables("REQUEST_METHOD"))
  if Request.ServerVariables("REQUEST_METHOD") = "POST" then  
      if request.QueryString("id") <> "" then
        i.delete(request.QueryString("id"))
      else
        i.update(Request("model"))
      end if  
  else    
    i.getInforme(Request.QueryString("codigoInforme"))    
  end if  
%>