<!--#INCLUDE file= "../../include/config.asp"-->

<%
    out = "{"
    out = out + """total"":" & cantidadOdtsTodas(USUARIO_DEFAULT) 
    
    if usuarioPuede(ODT_puedeDefinir) then 
        out = out + ",""aDefinir"":" & cantidadOdtsADefinir(USUARIO_DEFAULT)
    end if
    
    if usuarioPuede(ODT_puedeAuditar) then 
        out = out + ",""aAuditar"":" & cantidadOdtsAAuditar(USUARIO_DEFAULT)
    end if
    
    out = out + "}"
    
    response.Charset = "utf-8" 
    response.ContentType = "application/json"
    response.write(out)
  

%>