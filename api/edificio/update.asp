<!--#INCLUDE file= "../../include/config.asp"-->

<%

   Set e = New Edificio

    
    if Request.ServerVariables("REQUEST_METHOD") = "POST" then

        e.update(Request("model"))
        
    else
        
        e.getEdificio(Request.QueryString("codigoEdificio"))

    end if
  
%>