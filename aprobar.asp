<!--#INCLUDE file= "include/config.asp"-->
<!--#INCLUDE file= "template/header.asp"-->
<!--#INCLUDE file= "include/mails.asp"-->
<%
	o = Request("odt")
	
	if o = "" then
		o = "0"
	end if

	Set rst = DbQuery("SELECT * FROM ODTs WHERE codigoODT=" & o)
	
    If Not rst.EOF Then
		s = ""
        s = s & "<FONT face=Arial color=#000000 size=3><br>"
        s = s & "Aprobada y esperando ser Auditada para facturar Orden de Trabajo Nro: " & o  
		s = s & "Gracias.<BR><BR><a href='http://hwnt04/odtweb/?odt=" & rst("codigoODT") & "'>Para auditar esta órden haga click aquí</a>"
        s = s & "</FONT>"
		
        s = s & "<BR><BR>"
        
        s = s & "Gracias.</FONT>"
                
        sendmail USUARIO_DEFAULT, BuscaMnResponsablesDow & "; amillach@dow.com; " & BuscaMNMicser, "ODT | Aprobación Orden Nro: " & o, s
	
		response.write "<span>Se ha enviado el correo electrónico de aprobación. Muchas Gracias."
		
		 DbQuery("UPDATE ODTs SET Aprobado=1 WHERE codigoODT=" & o)
	end if

%>