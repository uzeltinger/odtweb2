<!--#INCLUDE file= "include/config.asp"-->
<!--#INCLUDE file= "template/header.asp"-->
<!--#INCLUDE file= "include/mails.asp"-->
<!--#INCLUDE file= "include/conexion.asp"-->
<!--#INCLUDE file= "include/util.asp"-->


<%
On Error Resume next
'ODT_mail_confirmado 33922
'ODT_mail_solicitante 33922
'ODT_mail_definidor 33922
'Dim s, t

's = "Estoy haciendo una prueba elemental"
't = "D:\Inetpub\wwwroot\odtweb\attaches\prueba.txt"
'sendmail USUARIO_DEFAULT, "gsieder@dow.com", "ODT | Confirmada Orden de Trabajo Nro: " & 33970, s

'sendmailConAttach USUARIO_DEFAULT, "gsieder@dow.com",  "ODT | Confirmada Orden de Trabajo 33897", s, 33897   ', "D:\Inetpub\wwwroot\odtweb\attaches\prueba.txt"

'------------------------ Listar todos los objetos de la BD MySql----------------------------------------

Set rst = conexion.EXECUTE("Show Databases",, adCmdText)
	'Creo una tabla para que sea más fácil ver
	response.write "<table border=""1"">"
	' Loop entre las bases
	While not rst.EOF
		'Nombres de las BD
		Response.write "<tr><td colspan=""2"">" & rst.Fields(0).name & " : " & rst.Fields(0) & "</td></tr>"
		'Nombres de las tablas LO QUE ESTABAMOS BUSCANDO
		Set objTables = conexion.Execute("SHOW TABLES FROM " & rst.Fields(0),, adCmdText)
		Response.write "<tr><td valign=""top"">Tables:</td><td>"
		While not objTables.EOF
			Response.write "   " & objTables.Fields(0) & "<br>"
			objTables.MoveNext
		Wend
		'Fin de la tabla 
		Response.write "</td></tr>"
	'Próxima BD (si existe)
	rst.MoveNext	
	Wend
	'Cerramos todo
	Response.write "</table>"

'------------------------ Fin listar todos los objetos de la BD MySql----------------------------------------



'Set rst = DbQuery("SELECT * FROM sistemausuarios Order by MN DESC")

'For i = 1 To 30
'response.write (rst("MNAprobador") & "  ")
'rst.movenext
'Next

%>
 