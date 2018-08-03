
<%
On Error Resume next
	'msg = "Detalle del rechazo" 
    'Response.Write("<" & "script language=VBScript>") 
    'Response.Write("inputbox """ & msg & """<" & "/script>")
	'La unica manera que le veo es que odt.js redireccione a un form asp donde se pida información y a su vez direccione a rechazo.asp.
	
	
%>

 
<!--#INCLUDE file= "config.asp"-->


<%


Response.Write(Request.QueryString("codigo"))
Response.Write("<BR>")
Response.Write(Request.QueryString("destinatario"))
Response.Write("<BR>")
Response.Write USUARIO_DEFAULT
 





Response.Write("<BR>")
Response.Write msg





Function sendmail(mnfrom, mnto, subject, htmlbody)
	
	Set objCDOMail = Server.CreateObject("CDO.Message")
			
	objCDOMail.From = splitearMns(mnfrom)
	objCDOMail.To = splitearMns(mnto)
	objCDOMail.Subject = subject
	objCDOMail.HtmlBody = htmlbody

	objCDOMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing")=2
	objCDOMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver")="localhost"
	objCDOMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport")=25
	objCDOMail.Configuration.Fields.Update

	objCDOMail.Send
	set objCDOMail=nothing
	
	
	
	'    msg = "Resumida descripción del rechazo" 
    'Response.Write("<" & "script language=VBScript>") 
    'Response.Write("inputbox """ & msg & """<" & "/script>")

    's = ""
        
    '    s = s & "<FONT face=Arial color=#000000 size=3>"
    '    s = s & "<STRONG>Aviso de RECHAZO. <br>De la Orden de Trabajo Nro: " & Request.QueryString("codigo") & "</STRONG><BR>"
	'	s = s & msg
	'	s = s & "Por favor, comuníquese con Sergio Peralta o Carlos Perez para solucionar este inconveniente. Int. 2525 ó 2431"
    '    s = s & "</FONT>"
	 '   s = s & "<BR><BR>"
     '   s = s & "Gracias.</FONT>"
    '    sendmail USUARIO_DEFAULT, Request.QueryString("destinatario"), "ODT | Rechazo ODT Nro: " & (Request.QueryString("codigo"), s
		


End Function








%>
 