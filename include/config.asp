<%
  ' constantes utilizadas en el sistema
   CANT_POR_PAGINA  = 30
   Const fechaSQL = "yyyy-mm-dd"
   
   PROD = (Request.ServerVariables("SERVER_NAME") = "hwnt04")

   ru = ucase(Request.ServerVariables("REMOTE_USER"))
   USUARIO_DEFAULT = Mid(ru, Instr(ru, "\") + 1)
   
   Session.LCID = 1033 '(1033 = USA)
   'Session.LCID = 11274 'cambiar esto para especificar el separador de decimales (11274 = Argentina)
   
   
   if not PROD then
	   ' TESTEOS (BORRAR DESPUES)
	   'USUARIO_DEFAULT = "NG39226"
	   USUARIO_DEFAULT = "U833190" 'puede definir
	   
	   USUARIO_DEFAULT = "NA08116" 'no puede generar ODT (puede cargar detalle de ordenes)
	else
		if USUARIO_DEFAULT = "U215250" then
			'USUARIO_DEFAULT = "U833860" '"U360821"
		end if
   end if  
USUARIO_DEFAULT = "U215250"
Function localLogAdd(texto)
  dim fs,fname
      set fs=Server.CreateObject("Scripting.FileSystemObject")

      if PROD then
        set fname=fs.OpenTextFile("C:\Inetpub\wwwroot\odtweb\log.txt", 8) ' 8=append 2=create      
      else
        set fname=fs.OpenTextFile("E:\xampp70\htdocs\sieder\ordenesdetrabajo\odtweb\log.txt", 8) ' 8=append 2=create
      end if
      fname.WriteLine(texto)
      fname.Close
      set fname=nothing
      set fs=nothing
End Function

' constante cantidad de tareas por dia
  Const CANTIDAD_TAREAS_DIARIAS = 8

  ' constantes permisos

  Const ODT_puedeRevisar = 512
  Const ODT_puedePlanificar = 256
  Const ODT_puedeFacturar = 128  
  Const ODT_puedeCargarDetalle = 64
  Const ODT_puedeDefinir = 32
  Const ODT_puedeAdministrar = 16
  Const ODT_puedeAuditar = 8
  Const ODT_puedeAprobar = 4
  Const ODT_puedeGenerarOrden = 2
  Const ODT_acceso = 1
  
  Dim getFile(20)

  getFile(0) = "home.asp"
  
%>

<!--#INCLUDE file= "conexion.asp"-->
<!--#INCLUDE file= "JSON_2.0.4.asp"-->
<!--#INCLUDE file= "json2.asp"-->

<!--#INCLUDE file= "util.asp"-->
<!--#INCLUDE file= "mails.asp"-->

<!--#INCLUDE file= "../models/odtAuxUtilDB.asp"-->
<!--#INCLUDE file= "../models/odt.asp"-->
<!--#INCLUDE file= "../models/materiales.asp"-->
<!--#INCLUDE file= "../models/servicios.asp"-->
<!--#INCLUDE file= "../models/facturas.asp"-->
<!--#INCLUDE file= "../models/edificio.asp"-->
<!--#INCLUDE file= "../models/servicio.asp"-->

<%

  ''OBTENGO LOS PERMISOS DEL USUARIO
  ' RS.Open "select ODT from sistemapermisos INNER JOIN sistemausuarios ON sistemausuarios.MN=sistemapermisos.MN where sistemausuarios.MN = '"& USUARIO_DEFAULT &"'", conexion
  
  ' if RS.EOF then
	' PERMISOS_USUARIO = 0
  ' else
	' PERMISOS_USUARIO = BinaryToDec(StrReverse( RS("ODT") ))
  ' end if
  
  ' RS.Close
  
  ' OBTENGO LOS PERMISOS DEL USUARIO
  set RS = DbQuery("select ODT from sistemapermisos where MN = '"& USUARIO_DEFAULT &"'")
  
  if RS.EOF then
	PERMISOS_USUARIO = 0
  else
	PERMISOS_USUARIO = BinaryToDec(StrReverse( RS("ODT") ))
  end if
  
  RS.Close
  
  Set RS = DbQuery("select MNDefinidor from odtdefinidores where activo AND MNDefinidor='"& USUARIO_DEFAULT &"'")
  if not RS.eof then
    PERMISOS_USUARIO = PERMISOS_USUARIO OR ODT_puedeDefinir
  end if
  
  RS.Close

  Set RS = DbQuery("select MNAprobador from odtaprobadores where activo AND MNAprobador='"& USUARIO_DEFAULT &"'")
  if not RS.eof then
    PERMISOS_USUARIO = PERMISOS_USUARIO OR ODT_puedeAprobar
  end if
  
  RS.Close

  Set RS = DbQuery("select MNRevisador from odtrevisadores where activo AND MNRevisador='"& USUARIO_DEFAULT &"'")
  if not RS.eof then
    USUARIO_PERMISOS_ODT = ODT_puedeRevisar
  end if

  RS.Close

%>
