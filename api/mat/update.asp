<!--#INCLUDE file= "../../include/config.asp"-->

<%

  'log(Request("odt"))
  
  Set m = New Material
  
  if Request.ServerVariables("REQUEST_METHOD") = "POST" then
  
      if request.QueryString("id") <> "" then
        m.delete(request.QueryString("id"))
      else
        m.update(Request("model"))
      end if
  
  else
  
  end if
  
%>