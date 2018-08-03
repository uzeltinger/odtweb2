<!-- 
    TEMPLATE: ODT ROW
-->
<script type="text/template" id="odt_template">
  <div class="row {{icon}}">
	<div class="{{  MNdefinidor == '<%= USUARIO_DEFAULT %>' ? 'mio' : '' }}" style="width: 30px; background: transparent url(static/img/icon/odt_{{icon}}.png)  no-repeat 0 2px; padding-right: 0px;"></div>
    <div style="width: 50px;">{{codigoODT}}</div>
    <div style="width: 185px;">{{nombreSolicitante}}</div>
    <div style="width: 560px;">{{DescripcionODT}}</div>
	<div style="width: 59px;  float: left; overflow: hidden;  height: 25px;  font-size: 13px;  text-align: right; color: #AAA; padding-right: 0px;">{{fechaMostrar}}</div>
  </div>
</script>

 <script type="text/javascript">window.reload();</script> <!-- script que recarga la pg con ultimos cambios -->
    
<!-- 
    TEMPLATE: ODT FULL 
-->

<script type="text/template" id="odt_template_full">
  
  {[ if(iniciado != '0' || CompletadaEmpresa != '0') { ]}
    <ul class="tabs" style="margin: 0;border-left: 0;background-color: #D8D8D8;border-top: 1px solid #999;">
        <li id="1" style="" class="{{ (detallesSelectedTab == 1)? 'active':'' }}"><a href="#tab1">Solicitud</a></li>
        <li id="2" style="margin: 0px; height: 31px; " class="{{ (detallesSelectedTab == 2)? 'active':'' }}"><a href="#tab2">Materiales ($ <span id="totalMateriales">0.00</span>)</a></li>
        <li id="3" style="margin: 0;height: 31px;" class="{{ (detallesSelectedTab == 3)? 'active':'' }}"><a href="#tab3">Servicios ($ <span id="totalServicios">0.00</span>)</a></li>
        <% if not usuarioPuede(ODT_puedeCargarDetalle) then %>
        {[ if((CompletadaEmpresa != 0) || (terminadaFisicamente != 0) ) { ]}
        <% end if %>
        <li id="4" style="margin: 0;height: 31px;" class="{{ (detallesSelectedTab == 4)? 'active':'' }}"><a href="#tab4">Detalles</a></li>
        <% if not usuarioPuede(ODT_puedeCargarDetalle) then %>
        {[ } ]}
        <% end if %>
        <li style="width: auto;width: 162px;text-align: right;padding-right: 10px;font-size: 17px;float: right;background-color: #D8D8D8;" >
            Total $ <span id="totaltotal" style="font-weight: bold;">0.00</span>
        </li>
    </ul>

    {[ } ]}

<div class="formularioEdicion">
    <div class="tab_container">
      <div id="tab1" class="tab_content" style="display: {[ if(detallesSelectedTab == 1) { ]}block{[ } else { ]}none{[ } ]};">
      
  <div class="odtEdicionSubtitulo" id="lugarFisico">Lugar físico</div>
  <ul style="margin-bottom: 5px">

    <li>
		<label>Planta</label> 
        <select name="codigoPlanta" id="codigoPlanta" class="field comboboxDefaults" style="float: left;">
        <% renderSelectPlantas %>
        </select>
		<label>Edificio</label>
        <select name="codigoEdificio" id="codigoEdificio" class="field comboboxDefaults" style="float: left;"></select>
    </li>

    <li><label>Ubicaci&oacute;n</label> 
      <input type="text" value="{{UbicacionTarea}}" name ="UbicacionTarea" class="field inputTextDefaults" style="width: 620px" />
    </li>
  </ul>
  
  <div class="odtEdicionSubtitulo" id="definidor">Definidor</div>
  <ul>
    <li><label>Nombre</label>
    <select name="MNdefinidor" id="MNdefinidor" class="field comboboxDefaults"></select>
    <% if usuarioPuede(ODT_puedePlanificar) then %>
    {[ if(CompletadaEmpresa == '0' && definido != '0') { ]}
    <div style="display: inline;float: right;margin-top: 0px;">
    <label style="width: 130px;margin-top: 3px;">Fecha Planificación</label>
    <input type="button" id="FechaPlanificacion" value="{{FechaPlanificacion}}" class="btn" style="">
    </div>
    {[ } ]}
    <% end if %>
  </ul>

  <div class="odtEdicionSubtitulo" id="definidor">Trabajo a realizar</div>
  <ul style="margin-bottom: 5px">
	<li><label>Tipo de tarea</label>
      <select name="codigoTipoTarea" id="codigoTipoTarea" style="width:auto" class="field comboboxDefaults">
	  <% renderSelectTipoTarea %>
	  </select>
    </li>
    <li style="height: 84px"><label>Tarea</label>
      <textarea name="DescripcionODT" id="DescripcionODT" class="field" style="width: 620px;height: 64px;padding: 4px 3px;">{{DescripcionODT}}</textarea>
    </li>
    <li style="width: 50%; float: left"><label>Eléctrica</label>
      <select name="electrica" id="electrica" class="field comboboxDefaults">
          <option value="0" {[ if(electrica == 0) { ]} selected {[ } ]} >No</option>
          <option value="1" {[ if(electrica == 1) { ]} selected {[ } ]} >Si</option>
      </select>
    </li>
    <% if usuarioPuedeRevisar(ODT_puedeRevisar) then %>    
    <% 'if USUARIO_DEFAULT = "U215377" Or USUARIO_DEFAULT = "U215375" then %>
      {[ if(codigoTipoTarea == 33) { ]}
        <li style="width: 50%; float: right"><label>Revisada</label>
          <select name="revisada" id="revisada" class="field comboboxDefaults">
            <option value="0" {[ if(revisada == 0) { ]} selected {[ } ]} >Sin Revisar</option>
            <option value="1" {[ if(revisada == 1) { ]} selected {[ } ]} >Revisada</option>
        </select>
        </li>
      {[ } else { ]}
      <input type="hidden" name="revisada" value="0">
      {[ } ]}
    <% else %>      
      <input type="hidden" name="revisada" value="0">
    <% end if %>
    <li style="width: 100%; float: left"><label>Contacto</label>
      <select name="MNcontacto" id="MNcontacto" class="field comboboxDefaults">
	  <% renderSelectContactos %>
	  </select>
    </li>    

    <li style="width: 100%; float: left"><label>Prioridad</label>
      <select name="codigoPrioridad" id="codigoPrioridad" class="field comboboxDefaults">
	  <%
		sql = "SELECT p.codigoPrioridad as id, p.Prioridad as text FROM odtprioridades p WHERE p.Activo" 
		response.write QueryToSelect(sql, "N")
	  %>
	  </select>
    </li>

  </ul>

  <% if usuarioPuedeRevisar(ODT_puedeRevisar) then %>    
      {[ if(codigoTipoTarea == 33) { ]}
      <div style="float: right;">
          <input type="button" id="revisar" value="Guardar" class="btn">
      </div>
      {[ } ]}
  <% end if %>
  
  
    <% if usuarioPuedeRevisar(ODT_puedeRevisar) then %>    
      {[ if(codigoTipoTarea == 33) { ]}
      <div style="float: right;">
          <input type="button" id="rechazar" value="Rechazar" class="btn">
      </div>
      {[ } ]}
	<% end if %>

  {[ if(activo != '0' || codigoODT == 0) { ]}

    {[ if(definido == '0' && CompletadaEmpresa == '0') { ]}
      <div style="float: right;">

      {[ if(codigoODT == 0) { ]}
        <% if usuarioPuede(ODT_puedeGenerarOrden) then %>
          <input type="button" id="update" value="Solicitar Trabajo" class="btn">
          <span style="margin: 0px;">o</span>
        <% end if %>
      {[ } else { ]}
        
        {[ if(CompletadaEmpresa == '0') { ]}

            {[ if(MNSolicitante != '<%= USUARIO_DEFAULT %>' && MNdefinidor == '<%= USUARIO_DEFAULT %>' && CompletadaEmpresa == '0') { ]}
              <% if usuarioPuede(ODT_puedeDefinir) then %>
              <input type="button" id="definir" value="Definir" class="btn" />
              <span style="margin: 0px;">o</span>
              <% end if %>
            {[ } ]}
    
        {[ } else { ]}

            {[ if(MNSolicitante == '<%= USUARIO_DEFAULT %>') { ]}
              <input type="button" id="anular" value="Anular" class="btn">
              <span style="margin: 0px;">o</span>              
            {[ } else { ]}
              <% if usuarioPuede(ODT_puedeAdministrar) then %>
              <input type="button" id="update" value="Actualizar ODT" class="btn" disabled>
              <span style="margin: opx;">o</span>
              <% end if %>
            {[ } ]}  

        {[ } ]}
			
      {[ } ]} 
    
    
      {[ if(codigoODT != 0 && definido == 0 && MNSolicitante == '<%= USUARIO_DEFAULT %>') { ]}
        
        <input type="button" id="anular" value="Anular" class="btn">
        <span style="margin: 0px;">o</span>
        <input type="button" id="saveeditedodt" value="Actualizar ODT" class="btn" >
        <input type="hidden" name="savededitedodt" id="savededitedodt" value="{{codigoODT}}">
        <span style="margin: 0px;">o</span>
      {[ } ]} 
      
      <a href="javascript:void(0)" onclick="$('#ventana-dialogo').hide()">Cerrar</a> <span> &nbsp; </span>  
      
      </div>

    
      <% if usuarioPuede(ODT_puedeDefinir) or usuarioPuede(ODT_puedeAdministrar) then %>
      {[ if(codigoODT != 0 && definido == '0' <% if not usuarioPuede(ODT_puedeAdministrar) then %>&& MNSolicitante != '<%= USUARIO_DEFAULT %>' && MNdefinidor == '<%= USUARIO_DEFAULT %>'<% end if %>)
      { ]}
          
        <div style="float: left;">
          <a href="javascript:void(0)" id="anular">Anular</a>
        </div>
          
      {[ } ]}	
       <% end if %>
       
	  
	{[ } else { // esta definida ]} 
      
      <div style="text-align: left; float: left; width: 575px;margin-top:5px;color: #888;font-size: 14px">
        <span style="">Solicitada por </span><span id="solicitadaPor"><strong>{{nombreSolicitante}}</strong></span>
      <div>  <span style="margin-left: 0px;">Definida por </span><span id="definidaPor"><strong>{{nombreDefinidor}}</strong></span>
        <span id="fechaDefinicion">{{fechaDefinicion}}</span> </div>
      </div>
      
          {[ if(iniciado == 0 && CompletadaEmpresa == '0') { ]}
          <div style="text-align: right; width: 214">
            <% if usuarioPuede(ODT_puedeCargarDetalle) then %>
            <input type="button" id="iniciar" value="Iniciar Trabajo" class="btn" />
            <% end if %>
          </div>
          {[ } else { // esta iniciado o completada ]}
          
            {[ if(iniciado != 0 && CompletadaEmpresa != '0' && auditado == 0 ) { // esta completada ]}
            
            <div style="text-align: right; width: 214">
            <% if usuarioPuede(ODT_puedeAuditar) then %>
            <input type="button" id="auditar" value="Auditada OK" class="btn" />
            <% end if %>
            </div>
            
            {[ } ]}	
            
          {[ } ]}	
      
	{[ } ]} 
    
         <div style="float: left;margin-left: 5px;">
          
            <a href="javascript:void(0)" id="imprimir">Imprimir</a>
            <a href="javascript:void(0)" id="copiar">Copiar</a>          
       </div>
  
  {[ } else { // no es activo o ni nueva odt]} 
  
      <div style="float: right;">
        <div style="font-weight: bold;float: right;margin-left: 21px;margin-top: 2px;">
        <span style="font-size: 14px;color: #888;margin-left: 10px;">Anulada por <strong><span id="anuladaPor">{{nombreAnulacion}}</span></strong></span>
        </div>
        <div style="width: 20px; background: transparent url(static/img/icon/odt_anulada.png)  no-repeat 0 2px; margin-right: 0px;height: 20px;"></div>
      </div>
	
  {[ } ]}

    </div> <!-- tab1 -->
    
    
    
    
    <!-- 
    TEMPLATE: ODT CARGAR SERVICIOS/MATERIALES/DATOS
    NOTA: si por alguna razon te preguntas por que al final de los span aparece un comentario
    que se cierra al principio del siguiente, eso es porque son elementos inline-block, y al introducir
    un retorno de carro, renderiza un espacio de mas... una de las formas de evitarlo, es ESTA.
    PEQLE - para vos PEQLE!!!
    
    -->

    <div id="tab2" class="tab_content" style="display: {{ detallesSelectedTab == 2? 'block':'none' }};">
      
        <ul style="width:790px; height: 30px; margin: 0">
          <li class="encabezadosMateriales">
            <span style="width: 10px;">&nbsp;</span><!--
         --><span style="width: 253px;">Material</span><!--
         --><span style="width: 62px; text-align: right">Cantidad</span><!--
         --><span style="width: 82px; text-align: center">P.U.</span><!--
         --><span style="width: 50px;">N.Fact.</span><!--
         --><span style="width: 63px;">Observaciones</span><!-- 
         --><span style="width: 260px;text-align: right;padding-right: 10px;font-weight: normal;">Gestión de Materiales $ <span id="totalGM">0.00</span></span>
          </li>
        </ul>
        <div class="scrollAuto">
          <ul id="listaMateriales"></ul>
        </div>
        <% if usuarioPuede(ODT_puedeCargarDetalle) then %>
        {[ if(!(CompletadaEmpresa != 0)) { ]}
        <div><input type="button" id="addMaterial" value="Agregar Material" class="btn" style="margin-top: 7px;"/></div>
        {[ } ]}
        <% end if %>
      </div>
      
       <div id="tab3" class="tab_content" style="display: {[ if(detallesSelectedTab == 3) { ]}block{[ } else { ]}none{[ } ]};">

        
        <ul style="width:790px; height: 30px; margin: 0">
          <li class="encabezadosServicios">
            <span style="width: 10px;">&nbsp;</span><!--
         --><span style="width: 253px;">Servicio</span><!--
         --><span style="width: 62px; text-align: right">Cantidad</span><!--
         --><span style="width: 82px; text-align: center">P.U.</span><!--
         --><span style="width: 313px;">Observaciones</span><!--
         --><span style="width:70px">&nbsp;</span>
          </li>


        <div class="scrollAuto">
          <ul id="listaServicios" style="width: 745px; margin-bottom: 0;"></ul>
        </div>
        <% if usuarioPuede(ODT_puedeCargarDetalle) then %>
        {[ if(!(CompletadaEmpresa != 0)) { ]}
        <div><input type="button" id="addServicio" value="Agregar Servicio" class="btn" style="margin-top: 7px;"/></div>
        {[ } ]}
        <% end if %>
         
      </div>
      
      <div id="tab4" class="tab_content" style="display: {{ detallesSelectedTab == 4 ? 'block' : 'none' }};">
         <div id="cargarDetallesForm">

            <span>Fecha realizaci&oacute;n</span>
            {[ if(!(CompletadaEmpresa != 0)) { ]}
            <input type="button" id="FechaRealizacion" value="{[ if(FechaRealizacion) { ]} {{FechaRealizacion}} {[ } else { ]}Cargar Fecha Realización{[ } ]}" class="btn" style="margin-top: 7px;">
            {[ } else { ]}
                <span id="FechaRealizacionStatic" style="font-weight: bold;font-size: 17px;margin-left: 5px;">{{FechaRealizacion}}</span>
            {[ } ]}
            <div class="clear"></div><br />

            Observaciones<br />
            <textarea style="height: 100px;" name="ComentariosSG" id="ComentariosSG">{{ComentariosSG}}</textarea>
            
            <% if not usuarioPuede(ODT_puedeAdministrar) then %>
            {[ if(!(CompletadaEmpresa != 0)) { ]}
            <% end if %>
            <div class="clear"></div>
            <br/>
            <input style="float: left;" type="checkbox" name="terminadaFisicamente" id="terminadaFisicamente" {{ (terminadaFisicamente != 0) ? "checked" : "" }} />
            <label for="terminadaFisicamente" style="float: left; width: auto">La tarea está terminada físicamente.</label>
            <br/><br/>
            <% if usuarioPuede(ODT_puedeCargarDetalle) then %>
            <input style="float: left;" type="checkbox" name="CompletadaEmpresa" id="CompletadaEmpresa" {{ (CompletadaEmpresa != 0) ? "checked" : "" }} />
            <label for="CompletadaEmpresa" style="float: left; width: auto">Finalizada la carga de los Detalles de esta ODT.</label>
            <% end if %>
            <br><br>
            <div>
            <% if usuarioPuede(ODT_puedeCargarDetalle) or  usuarioPuede(ODT_puedeAdministrar) then %>
            <input type="button" id="actualizarDetallesODT" value="Guardar Orden de Trabajo y cerrar ventana" class="btn" style="display:none;"/><br>
            <% end if %>
            
            <% if usuarioPuede(ODT_puedeCargarDetalle) then %>
            <input type="button" id="planillaControlObra" value="Planilla de Control de Obra" class="btn" />
            <% else %>
            <a href="javascript:void(0)" id="planillaControlObra">Planilla de Control de Obra</a>
            <% end if %>
            </div>
            
            <% if not usuarioPuede(ODT_puedeAdministrar) then %>
            {[ } else { ]}
                <br><br>
                <a href="javascript:void(0)" id="planillaControlObra">Planilla de Control de Obra</a>
            {[ } ]}
            <% else %>
            {[ if(FacturaNro) { ]} 
            <span>Facturada en la Factura Nro {{FacturaNro}}</span>
            {[ } ]}
            <% end if %>
            
            {[ if(es96mas != 0 || es96mas != '0') { ]}        
            <div id="aprobarRechazar" class="aprobar-rechazar">
              <br><br>
              <div style="float: left;">
                <input type="button" id="aprobar96mas" value="Aprobar" class="btn" />
              </div>
              <div style="float: left; margin-left: 20px;">
                <input type="button" id="rechazar96mas" value="Rechazar" class="btn btn-rojo" />
              </div>
            </div>
            {[ } ]}
            
         </div>
      </div>
    
    
    
  </div>
  
</script>


<!-- 
    TEMPLATE: ODT DEFINIR
-->

<script type="text/template" id="odtDefinirTemplate">
<div class="formularioEdicion">
  <div class="odtEdicionSubtitulo">Definir</div>
  
  <ul style="margin-top:25px; margin-bottom:0">
    <li style="padding-left: 30px">
      <label>Nombre </label>
      <select id="aprobadoresCombo" class="comboboxDefaults"></select>
    </li>
    <li style="padding-left: 30px">
        <label>Cuenta </label>
       <select style="opacity:.5" id="cuentaCombo" class="comboboxDefaults"></select>
    </li>
    <li style="text-align:right;width: 550px;">
      <a href="javascript:void(0);" id="presupuestar" style="float: left;margin-top: 5px;margin-left: -10px;">Presupuestar</a>  
      <input type="button" id="definirODT" value="Definir" class="btn" /> 
      <span style="margin: 0px;">o</span>
     <div> <a href="javascript:void()" onclick="$('#ventana-dialogo').hide()">Cerrar</a> </div>
    </li>
    
  </ul>

</div>
</script>

<!-- 
    TEMPLATE: ODT IMPRIMIR
-->

<script type="text/template" id="odtImprimir">
<div class='formularioEdicion'>
  
        <FONT face=Arial color=#000000 size=3>
        <STRONG>Solicitud de Orden de Trabajo Nro: {{codigoODT}}</STRONG>
        </FONT><BR><BR>
        <FONT face=Arial color=#000000 size=2>
        Solicitante: <b> {{nombreSolicitante}} </B><BR>
		Fecha de la Solicitud: <B>{{ FechaHoraSolicitud }}</B><BR><br>
        Planta: <b> {{ planta }}</B><BR>
        Edificio: <b>{{ edificio }}</B><BR>
        Ubicación de la Tarea: <b>{{UbicacionTarea}}</B><BR><BR>
        Contacto: <b>{{nombreContacto}}</B><BR><BR>
        Prioridad: <b>{{prioridad}}</B><BR><BR>
        Definidor: <b>{{nombreDefinidor}} </B><BR><BR>
        Descripción de la Tarea:<BR><BR><b>{{DescripcionODT}}</b>
        </FONT>
        
</div>
</script>