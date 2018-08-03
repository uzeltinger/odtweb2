<!--#INCLUDE file= "../../include/config.asp"-->

<%
    Set myODT = New Odt
    
    myODT.presupuestar(Request.QueryString("codigoOdt"))
    
%>