<!--#INCLUDE file= "../../include/config.asp"-->

<%

    Set s = New Servicio

    
    if Request.ServerVariables("REQUEST_METHOD") = "POST" then

        s.update(Request("model"))
        
    else
        
        s.getServicio(Request.QueryString("codigoItem"))

    end if
  
%>