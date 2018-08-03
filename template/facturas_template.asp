<!-- 
    TEMPLATE: FACTURA (listado)
-->
<script type="text/template" id="factura_template">
  <div class="fRow">
    <div style="width: 30px; background: transparent url(static/img/icon/odt_creada.png)  no-repeat 0 2px; margin-right: 0px;"></div>
    <div style="width: 90px;" class="botonCargarFacturasODT">{{FacturaNro}}</div>
    <div style="width: 200px;" class="botonCargarFacturasODT">{{Empresa}}</div>
    <div style="width: 185px;" class="botonCargarFacturasODT">{{FechaFactura}}</div>
    <div style="width: 320px;" class="botonCargarFacturasODT">{{Nombre}}</div>
    <div style="width: 50px;" class="editarFactura"><a class="botonEditarFactura">editar</a></div>
  </div>
</script>





<!--
  Template: Factura asignar
-->
<script type="text/template" id="facturasEdicionTemplate">

<div class="edicionFactura">  
   {[ if(!cargarFacturasODT)  {  
      var facturaNroDisabled = '';  ]}
      <div class="edicionFacturaDatos">  
     <br />
    <label for="FacturaNro" style="width: 73px; text-align: right; padding: 4px 3px">Factura N&deg;</label>
    {[ if(codigoFactura == 0) { facturaNroDisabled = ''; } ]}
    <input type="text" name="FacturaNro" id="FacturaNro" value="{{ FacturaNro }}" class="fieldFactura inputTextDefaults" style="float: left; margin-right: 20px;" {{ facturaNroDisabled }} />
    
    <label for="FechaFactura" style="width: 70px; text-align: right; padding: 4px 3px">Fecha:</label>
    <input type="text" name="FechaFactura" id="FechaFactura" value="{{ FechaFactura }}" class="fieldFactura inputTextDefaults" style="width:85px" />
    <br /><br />

    <label for="Empresa" style="width: 73px; text-align: right; padding: 4px 3px">Empresa:</label>
    <input type="text" name="Empresa" id="Empresa" class="fieldFactura inputTextDefaults" value="{{ Empresa }}" />
    <br />
    <div style="text-align: right;padding-right: 20px;">
      <input type="button" id="updateFactura" value="Actualizar Factura" class="btn" />
      <span style="margin: 2px;">&oacute;</span>
      <a style="cursor: pointer" onclick="$('#ventana-dialogo').hide()">Cerrar</a>
    </div>
   </div>
  {[ } else { ]}
  
    {[ if (FacturaNro != '0') { ]} <!-- Edicion Factura: ODT -->
      <div class="facturasListContainer">
        <span class="titleFacturasList">ODT en esta factura</span>
        <ul class="facturasList" id="odtFactura">
          <li style="background-color: white;" id="spinnerLeft"><img src="/odtweb/static/img/spinner.gif" style="margin: 5px 0 0 167px"></li>
        </ul>
        
      </div>

      <div class="facturasListContainer">
        <span class="titleFacturasList">ODT sin facturar</span>
        <ul class="facturasList" id="odtSinFacturar">
          <li style="background-color: white;" id="spinnerRight"><img src="/odtweb/static/img/spinner.gif" style="margin: 5px 0 0 167px"></li>
        </ul>
        

      </div>
     
      <div class="clear" style="border-top: 1px solid lightBlue;"></div>
      
      <div class="totalFactura">Total: $ <span id="fTotal">0,00</span> <a style="float: right;margin-right: 20px;font-size: 15px;" target="_blank" href="/odtweb/include/excelFacturaSap.asp?codigoFactura={{ codigoFactura }}">Exportar Items SAP</a></div>
    {[ } ]} <!-- Edicion Factura: ODTs -->
  {[ } ]} <!-- si cargoODT en FActura -->

  
</div>

</script>
