<!--#INCLUDE file= "../../include/config.asp"-->

<%
  
  Set s = New Servicios

  if Request.ServerVariables("REQUEST_METHOD") = "POST" then
  
      if request.QueryString("id") <> "" then
        s.delete(request.QueryString("id"))
      else
        s.update(Request("model"))

      end if
  
  else
  
  end if
    
  
  
%>