<!--#INCLUDE file= "../../include/config.asp"-->

<%

  Set f = New Factura

  if Request.ServerVariables("REQUEST_METHOD") = "POST" then
  
      if request.QueryString("id") <> "" then
        f.delete(request.QueryString("id"))
      else
        f.update(Request("model"))

      end if
  
  else
    
    f.getFactura(Request.QueryString("codigoFactura"))
    
  end if
  
  
%>

