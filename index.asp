<% Session.LCID = 1033 %>
<!--#INCLUDE file= "include/config.asp"-->
<!--#INCLUDE file= "template/header.asp"-->

<body id="odtApp" style="overflow: hidden;
height: 100%;
display: block;
position: absolute;
width: 100%;
">

	<% if usuarioPuede(ODT_acceso) then %>
  
<div id="header-wrap" style="float: left;width: 100%;height: 38px;margin-bottom: 6px; background-color: #fafafa;


position: fixed;
left: 0;
top: 0;"> <!-- fafafa!!!! -->
    <div id="header" style="height: 31px;padding-top: 7px;margin-left: 14px;float:left">
	<select style="display:none" id="MNaNombre"><% renderSelectMNaNombre %></select>
	
	<span style="font-size: 20px;">Sistema</span>
	<a class="btn" href="#" style="position: relative;top: -3px;border-radius: 0;width: 50px;padding: 3px;">ODT</a>
	<span class="searchInputContainer" style="">
		<input style="font-size: 15px;border: 1px solid #CACACA;border-radius: 3px;width: 250px;padding: 2px 5px; margin-left: 400px;" placeholder="Buscar por nombre ó número" id="input-search" type="text" autocomplete="off" role="textbox">
		<input class="lupa-search" src="/odtweb/static/img/lupa.png" type="image" name="yt4" value="submit" style="position: relative;
right: 31px;
top: 4px;
padding: 3px 6px 2px 6px">
		</span>
	</div>
	
	<div style="color: #666;font-size: 14px;    margin-right: 12px;float: right;margin-top: 7px;"><%= obtenerNombre(USUARIO_DEFAULT) %>
	</div>
  </div>
  
<div id="scrollable" style="

width: 100%;
margin-top: 40px;
float: left;
overflow-y: auto;
height: 100%;
">
 <!--<script type="text/javascript">window.reload();</script>-->	 <!-- codigo que hace que la pagina se recargue sola para refrescar cambios-->

  <div <a</a> <li><strong>
		Estimados usuarios: Estamos trabajando sobre el programa con el objetivo de incorporar mejoras. Si encuentran inconvenientes, por favor reportarlos a
		<a href="mailto:fferrarello@dow.com?subject=Error en ODT">este</a> correo. 
		Disculpen las molestias, gracias.</strong></li></div>
<div>
<li><u><strong>Referencias:</strong></u>
ODT Anulada: <img alt="anulada" height="20" src="static/img/icon/odt_anulada.png" width="20"> // ODT Auditada: <img alt="auditada" height="20" src="static/img/icon/odt_auditada.png" width="20">
 // ODT Completada: <img alt="completada" height="20" src="static/img/icon/odt_completada.png" width="20">  // ODT Creada: <img alt="creada" height="20" src="static/img/icon/odt_creada.png" width="20">
 // ODT Creada urgente: <img alt="creada urgente" height="20" src="static/img/icon/odt_creada_urgente.png" width="20">  // ODT Definida: <img alt="definida" height="20" src="static/img/icon/odt_definida.png" width="20">
// ODT Definida Urgente: <img alt="definida urgente" height="20" src="static/img/icon/odt_definida_urgente.png" width="20"> // ODT Iniciada: <img alt="iniciada" height="20" src="static/img/icon/odt_iniciado.png" width="20">

</li>
</div>

    <div class="container" id="running-board" style="padding-top: 8px;">

      <div id="project-header" style="height: 21px;padding-bottom: 8px;margin-top:8px">
        
          <ul id="menu-filtros" style="width: 780px">
               
			   <li><span id="comments_count"><a id="todas" href="#" class="current">Todas <span class="count"><%= cantidadOdtsTodas(USUARIO_DEFAULT) %></span></a></span></li>

          <% if usuarioPuede(ODT_puedeGenerarOrden) then %>       
              <li><a href="#" id="solicitadas" style="padding: 0 2px 5px 2px;">Solicitadas</a></li>
          <% end if %>   
		  
		  <% if usuarioPuede(ODT_puedeCargarDetalle) then %>
				<li><a href="#" id="pendientes" style="padding: 0 2px 5px 2px;">Iniciadas</a></li>
		  <% else %>
				<% if usuarioPuede(ODT_puedeGenerarOrden) then %>
					<li><a href="#" id="pendientes" style="padding: 0 2px 5px 2px;">Pendientes</a></li>
				<% end if %>   
          <% end if %>   
		  <% if usuarioPuede(ODT_puedeGenerarOrden) then %>
				<li><a href="#" id="96mas" style="padding: 0 2px 5px 2px;">+ 96 hs. <span class="count"><span class="count">0</span></span></a></li>
			<% end if %>
          <% if usuarioPuede(ODT_puedeDefinir) or usuarioPuede(ODT_puedeAuditar) then %>
              <li><span data-updates-count="9" id="updates_count"><a id="aDefinir" href="#" id="updates_nav">A Definir <% if usuarioPuede(ODT_puedeDefinir) then %><span class="count">0</span><% end if %>
              </a></span></li>
          <% end if %>
          
          <% if usuarioPuede(ODT_puedeAprobar) and false then %>
          <li><a id="aAprobar" href="#" >Aprobadas <span class="count"><span class="count">0</span></span></a></li>
          <% end if %>
		  
		   <% if usuarioPuede(ODT_puedeAuditar) then %>
          <li><a id="aAuditar" href="#" >A Auditar <span class="count"><span class="count">0</span></span></a></li>
          <% end if %>

          <% if usuarioPuede(ODT_puedePlanificar) then %>
          <li><a id="planificar" href="#" >Planificar</a></li>
          <% end if %>
          
          <% if usuarioPuede(ODT_puedeFacturar) then %>
          <li><a id="facturas" href="#" >Facturas</a></li>
          <% end if %>

          <% if usuarioPuede(ODT_puedeAdministrar) then %>
          <li><a id="administrar" href="#" >Administrar</a></li>
          <% end if %>

        </ul>
        <ul style="width: 354px; margin-left: 593px; text-align: right;">
        
          <% if usuarioPuede(ODT_puedeFacturar) Then %>
          <input type="button" id="nuevaFactura" value="Nueva Factura" class="btn" style="display:none; position: relative;top: -6px;" />
          <% end if %>
            
          <% if usuarioPuede(ODT_puedeGenerarOrden) then %>
            <input type="button" id="nuevaOrden" value="Nueva ODT" class="btn" style="position: relative;top: -6px;" />
          <% end if %>
          
          <% if usuarioPuede(ODT_puedeAdministrar) then %>
            <input type="button" id="nuevoEdificio" value="Nuevo Edificio" class="btn adminBtn" style="display: none; position: relative;top: -6px;" />
          <% end if %>
          
          <% if usuarioPuede(ODT_puedeAdministrar) then %>
            <input type="button" id="nuevoListado" value="Nuevo Contrato" class="btn adminBtn" style="display: none; position: relative;top: -6px;" />&nbsp;
            <input type="button" id="nuevoServicio" value="Nuevo Servicio" class="btn adminBtn" style="display: none; position: relative;top: -6px;" />
          <% end if %>
        </ul>
      </div>
    </div>
	


  <div id="content-wrap">
    <div class="container" id="content">
      <div class="NS-projects-content">
        <div id="main" style="width: 100%;">
          <div class="blogentry">

            <div class="body" id="container">
              <ul id="listaOdt"></ul>
			  <div id="spinner" style="display: none;height: 10px;width: 100%;text-align: center;float: left;"><img src="/odtweb/static/img/spinner.gif" style="margin-top: 7px;"></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  
   </div>  

    <div class="modal_dialog" id="ventana-dialogo">
      <div class="modal_dialog_outer">
        <div class="modal_dialog_sizer">
          <div class="modal_dialog_inner">
            <div class="modal_dialog_content">
              
              <div class="modal_dialog_head">
                  <h4 id="modal_dialog_title" style="font-weight: bold; font-size: 18px;padding: 15px 20px 11px 20px;"></h4>
                  <a class="modal_dialog_close" onclick="$('#ventana-dialogo').hide()">
                  <div class="icon-x">X</div>
                  </a>
              </div>

              
              <div class="modal_dialog_body">
                <div id="odtFull"></div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <%
    
    if request.querystring("odt") <> "" then
        
        response.write "<script> $(function(){ var codt = " & request.querystring("odt") & ";"  
        response.write "var modelo = new Odt({codigoODT: codt});"
        response.write "modelo.fetch({success: function(){"
        response.write "    if(modelo.get('MNSolicitante') != 0) {"
        response.write "    var v = new OdtView({model: modelo});"
        response.write "    v.editODT();"        
        response.write "} } });"
        response.write "}) </script>"
    
    end if 
    %>
  

    <!--#INCLUDE file= "template/odt_template.asp"-->
    <!--#INCLUDE file= "template/serviciosMaterialesTemplate.asp"-->
    <!--#INCLUDE file= "template/facturas_template.asp"-->
    <!--#INCLUDE file= "template/admin_template.asp"-->
    <!--#INCLUDE file= "template/planificar_template.asp"-->
    <!--#INCLUDE file= "template/control_de_obra_template.asp"-->
    
	
	<% else %>
	
		<div style="  text-align: center;  padding: 200px;">
			<img src="/odtweb/static/img/bloqueado.png">
			<span style="font-size: 20px;position: relative;top: -16px;font-family: arial;">No tiene permiso para acceder al Sistema ODT</span>
		</div>
	
	<% end if %>

