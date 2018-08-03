<!--#INCLUDE file= "../../include/config.asp"-->

<%
    Set myODT = New Odt
    
    if Request.ServerVariables("REQUEST_METHOD") = "POST" then
    
        myODT.update(Request("model"))
        
    else
        
        myODT.getOdt(Request.QueryString("codigoODT"))
    
    end if
  
%>