
<%

' response.write ("Trato de enviar")
'Set myMail=CreateObject("CDO.Message")
'myMail.Subject="Envio de mail con CDO"
'myMail.From="Guillermo@Sieder.com"
'myMail.To="fferrarello@hotmail.com"
'myMail.Bcc="fferrarello92@gmail.com"
'myMail.Cc="guillermo@sieder.com.ar"
'myMail.TextBody="Y aqui vendria el mensaje"


'	myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing")=1
'	myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver")="localhost"
'	myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport")=25
'	myMail.Configuration.Fields.Update


'myMail.Send
'set myMail=nothing


 %>
    <form name="form1" method="post" action="mailto:guillermo@sieder.com.ar">
    <label for="nombre">Nombre: </label><input type="text" name="nombre" id="nombre"><br><br>
    <label for="email">Email: </label><input type="text" name="nombre" id="email"><br><br>
   Enviar un texto<br><br>
    <textarea id="Aqui el texto" name="opinion"></textarea><br><br>
    <input type="submit" name="Submit" value="Enviar">
    </form>