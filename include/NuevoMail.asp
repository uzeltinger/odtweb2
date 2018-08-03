
<%

 response.write ("Trato de enviar")
Set myMail=CreateObject("CDO.Message")
myMail.Subject="Envio de mail con CDO"
myMail.From="GSieder@eximc.nam.dow.com"
myMail.To="fferrarello@hotmail.com"
myMail.Bcc="fferrarello92@gmail.com"
myMail.Cc="guillermo@sieder.com.ar"
myMail.TextBody="Y aqui vendria el mensaje"


	myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing")=2
	myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver")="localhost"
	myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport")=25
	myMail.Configuration.Fields.Update


myMail.Send
set myMail=nothing


 %>