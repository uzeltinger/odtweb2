
<script type="text/template" id="admin_template">
  
    <div class="admin view" style="padding: 35px;">
        <div style="margin-left: 43px;width: 200px;float:left">
            <a href="javascript:void(0);" id="edificios"><img src="/odtweb/static/img/icon/building.png" style="height: 32px;">
            <span style="font-size: 20px;    color: black;    position: relative;    top: -7px;    left: 5px;">Edificios</span>
            </a>
        </div>	
        <div style="width: 200px;float:left">
            <a href="javascript:void(0);" id="servicios"><img src="/odtweb/static/img/icon/clipboard.png" style="height: 32px;">
            <span style="font-size: 20px;    color: black;    position: relative;    top: -7px;    left: 5px;">Servicios</span>
            </a>
        </div>	
        <div style="width: 400px;float:left">
            <a href="javascript:void(0);" id="coeficiente"><img src="/odtweb/static/img/icon/calculator.png" style="height: 32px;">
            <span style="font-size: 20px;    color: black;    position: relative;    top: -7px;    left: 5px;">Coeficiente de Gestión de Materiales</span>
            </a>
        </div>
        <div style="margin-top: 62px;text-align: center;font-size: 14px;">
            Coeficiente: <%= CGCobtenerCGC1(now) * 100 %>% hasta $<%= CGCobtenerImporte(now) %> y <%= CGCobtenerCGC2(now) * 100 %>% desde $<%= CGCobtenerImporte(now) %> en adelante.
        </div>
    </div>
  
</script>


<script type="text/template" id="edificio_row_template">
  <div class="row {{icon}}">
	<div style="width: 30px; background: transparent url(static/img/icon/odt_{{icon}}.png)  no-repeat 0 2px; margin-right: 0px;"></div>
    <div style="width: 100px;">{{Planta}}</div>
    <div style="width: 580px;">{{Nombre}}</div>
	<div style="width: 180px;  float: left; overflow: hidden;  height: 25px;  font-size: 13px;  text-align: right; color: #AAA; margin-right: 0px;"></div>
  </div>
</script>


<script type="text/template" id="servicio_row_template">
  <div class="row {{icon}}">
	<div style="width: 30px; background: transparent url(static/img/icon/odt_{{icon}}.png)  no-repeat 0 2px; margin-right: 0px;"></div>
    <div style="width: 100px;">{{codigoSAP}}</div>
    <div style="width: 580px;">{{Descripcion}}</div>
    <div style="width: 100px;">$ {{Precio}}</div>
	<div style="width: 70px;  float: left; overflow: hidden;  height: 25px;  font-size: 13px;  text-align: right; color: #AAA; margin-right: 0px;">{{FechaVigencia}}</div>
  </div>
</script>


<script type="text/template" id="serviciosEdicionTemplate">

<div class="edicionServicio">  

    <div style="margin-bottom: 10px">  
     <br />
    <div style="height: 35px;">
    
         <label for="codigoSAP" style="width: 90px; text-align: right; padding: 4px 6px">Código SAP</label>
        <input type="text" name="codigoSAP" id="codigoSAP" class="fieldFactura inputTextDefaults" style="width:85px" value="{{codigoSAP}}">
    </div>
    <div style="height: 35px;">
        <label for="Descripcion" style="width: 90px; text-align: right; padding: 4px 6px">Descripcion</label>
        <input type="text" name="Descripcion" id="servicio-descr" class="fieldFactura inputTextDefaults" style="width:315px" value="{{ Descripcion }}" />
    </div>
    <div style="height: 35px;">
        <label for="FechaFactura" style="width: 90px; text-align: right; padding: 4px 6px">Precio</label>
        <input type="text" name="FechaFactura" id="servicio-precio" value="{{ Precio }}" class="fieldFactura inputTextDefaults" style="text-align: right; width:85px" />
    </div>

    <div style="text-align: right;padding-right: 20px;">
      <input type="button" id="updateServicio" value="Aceptar" class="btn" />
      <span style="margin: 2px;">&oacute;</span>
      <a style="cursor: pointer" onclick="$('#ventana-dialogo').hide();">Cerrar</a>
    </div>
   </div>
  
</div>


</script>

<script type="text/template" id="edificiosEdicionTemplate">

<div class="edicionEdificio">  

        <div style="margin-bottom: 10px">  
        <br />
        
        
        <label for="codigoPlanta" style="width: 95px; text-align: right; padding: 4px 6px">Planta</label>
        <select name="codigoPlanta" id="edificio-planta" class="field comboboxDefaults" style="float: left;">
            <%
                sql = "SELECT NombrePlanta as id, NombrePlanta as text FROM plantas WHERE activo ORDER BY NombrePlanta" 
                response.write QueryToSelect(sql, "N")
            %>
        </select>
        <br style="clear:both" />
        <label for="Nombre" style="width: 95px; text-align: right; padding: 4px 6px">Descripcion</label>
        <input type="text" name="Nombre" id="edificio-nombre" class="fieldFactura inputTextDefaults" style="width:335px;margin-top: 5px;" value="{{ Nombre }}" />
        <br />

        <div style="margin: 10px 0; height: 30px;">
            <div style="float: left; width: 250px;padding-left: 20px;line-height: 30px;">
                <a style="cursor: pointer" id="editDefinidores">Definidores</a> &nbsp;&nbsp;&nbsp;
                <a style="cursor: pointer" id="editAprobadores">Aprobadores</a>
            </div>
            
            <div style="float: left;text-align: right;padding-right: 20px;width: 240px;">
                <input type="button" id="updateEdificio" value="Aceptar" class="btn" />
                <span style="margin: 2px;">&oacute;</span>
                <a style="cursor: pointer" onclick="$('#ventana-dialogo').hide();">Cerrar</a>
            </div>
        </div>
        
        <div id="editDefinidoresContainer" style="padding: 0px 20px; display: none">
            <select id="definidores" size="6" style="float:left;width: 200px;">
            <%
                sql = "SELECT MN as id, Nombre as text FROM sistemausuarios WHERE activo ORDER BY Nombre"  
                response.write QueryToSelect(sql, "dummySelected")
            %>
            </select>
            <div style="float: left;width: 50px;text-align: center;">
                <button id="addDefinidor">&gt;&gt;</button><br />
                <button id="removeDefinidor">&lt;&lt;</button>
            </div>
            <select id="ListaDefinidores" size="6" style="float:left;width: 200px; ">
                {[ _.each(ListaDefinidores, function(e) { ]} 
                <option value="{{e.MNdefinidor}}">{{e.Nombre}}</option>
                {[ }) ]}
            </select>
            <br style="clear:both" />
        </div>

        <div id="editAprobadoresContainer" style="padding: 0px 20px; display: none">
            <select id="aprobadores" size="6" style="float:left;width: 200px;">
            <%
                sql = "SELECT MN as id, Nombre as text FROM sistemausuarios WHERE activo ORDER BY Nombre" 
                response.write QueryToSelect(sql, "dummySelected")
            %>
            </select>
            <div style="float: left;width: 50px;text-align: center;">
                <button id="addAprobador">&gt;&gt;</button><br />
                <button id="removeAprobador">&lt;&lt;</button>
            </div>
            <select id="ListaAprobadores" size="6" style="float:left;width: 200px;">
                {[ _.each(ListaAprobadores, function(e) { ]} 
                <option value="{{e.MNAprobador}}">{{e.Nombre}}</option>
                {[ }) ]}
            </select>
            <br style="clear:both" />
        </div>
        
        
   </div>
  
</div>


</script>



<script type="text/template" id="nuevoListadoVigenciaTemplate">
  
    <div style="padding: 20px 0">
        <label for="FechaVigencia" style="width: 145px; text-align: right; padding: 4px 6px">Nueva Fecha Vigencia</label>
        <input type="text" name="FechaVigencia" id="FechaVigencia" class="fieldFactura inputTextDefaults" style="width:95px;margin-top: 5px;" value="" />
        <br>
        <label for="NumeroContrato" style="width: 145px; text-align: right; padding: 4px 6px">Número de Contrato</label>
        <input type="text" name="NumeroContrato" id="NumeroContrato" class="fieldFactura inputTextDefaults" style="width:95px;margin-top: 5px;" value="" />

        <div style="text-align: right;padding-right: 20px">
            <input type="button" id="aceptarNuevoListado" value="Aceptar" class="btn" />
            <span style="margin: 2px;">&oacute;</span>
            <a style="cursor: pointer" onclick="$('#ventana-dialogo').hide();">Cerrar</a>
        </div>
    </div>
    
</script>



<script type="text/template" id="nuevoCoeficienteTemplate">
        <div style="padding: 10px;">
            <label for="FechaValidez" style="width: 145px; text-align: right; padding: 4px 6px">Nueva Fecha Validez</label>
            <input type="text" name="FechaValidez" id="FechaValidez" class="fieldFactura inputTextDefaults" style="width:95px;margin-top: 5px;" value="">
            
            <br>
            <div style="height: 37px;">
                <label for="CGC" style="width: 86px; text-align: right; padding: 4px 6px">Coeficiente</label>
                <input type="text" name="CGC1" id="CGC1" class="fieldFactura inputTextDefaults" style="width: 52px;margin-top: 5px;float: left;" value="0">
                <span style="text-align: right; padding: 4px 6px;float: left;">%</span>
                <label for="hasta" style="width: 57px; text-align: right; padding: 4px 6px">Hasta</label>
                <input type="text" name="hasta" id="hasta" class="fieldFactura inputTextDefaults" style="width:95px;margin-top: 5px;float: left;" value="0">
            </div>

            <div style="height: 37px;">
            <label for="CGC2" style="width: 86px; text-align: right; padding: 4px 6px">Coeficiente</label>
            <input type="text" name="CGC2" id="CGC2" class="fieldFactura inputTextDefaults" style="width: 52px;margin-top: 5px;float: left;" value="0">
            <span style="text-align: right; padding: 4px 6px;float: left;">%</span>
            <label for="desde" style="width: 57px; text-align: right; padding: 4px 6px">Desde</label>
            <input type="text" name="desde" id="desde" class="fieldFactura inputTextDefaults" style="width:95px;margin-top: 5px;float: left;" value="0">
            </div>
            
        <div style="text-align: right;">
            <input type="button" id="aceptarNuevoCoeficiente" value="Aceptar" class="btn">
            <span style="margin: 2px;">&oacute;</span>
            <a style="cursor: pointer" onclick="$('#ventana-dialogo').hide();">Cerrar</a>
        </div>
    </div>
</script>