 



<%


'Response.Write(Request.QueryString("codigo"))
'Response.Write("<BR>")
'Response.Write(Request.QueryString("destinatario"))
'Response.Write("<BR>")
'Response.Write USUARIO_DEFAULT
  
%>
<!--#INCLUDE file= "config.asp"-->


<!DOCTYPE html>
<html>
    <head>        
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
    </head>
<body>
<header class="container-fluid">
    <div>
        <img src="dow-logo.png" height="50" width="146">
	
        <h2>Envío de Correo electrónico</h2>
		
    </div>
</header>
<body>
<h4>A continuación se abrirá un correo de MS Outlook. Puede ampliar la información del motivo de rechazo en el mismo<br>Una copia se guardara en la carpeta "Sent Items"<br>Muchas Gracias</h4>

<a href="mailto:<% =Request.QueryString("destinatario")%>?
subject=ODT | Rechazo ODT Nro: <% =Request.QueryString("codigo")%>
&body=%0D%0A%0D%0APor favor, comuníquese con Sergio Peralta o Carlos Perez para solucionar este inconveniente. Int. 2525 ó 2431
%0D%0AGracias
"><h4>Continuar</h4></a>

</body>


</html>