<!-- 
    TEMPLATE: Informe (listado)
-->
<script type="text/template" id="informes_template">
  <div class="iRow ">    
    <div style="width: 10%;" class="botonEditarInforme">{{numeroInforme}}</div>
    <div style="width: 60%;" class="botonEditarInforme">{{nombreInforme}}</div>
    <div style="width: 10%;" class="botonEditarInforme">{{desdeInforme}}</div>
    <div style="width: 10%;" class="editarInforme"><a class="informeRowToEdit">editar</a></div>
    <div style="width: 10%;" class="editarInforme">
      <a target="_blank" href="/odtweb/include/informe.asp?codigoInforme={{ codigoInforme }}" class="informeRowToGenerate">generar</a>
    </div>
  </div>
</script>





<!--
  Template: Informe asignar
-->
<script type="text/template" id="informesEdicionTemplate">

<div class="edicionInforme">  
  
  <div class="edicionInformeDatos">  
    <br />
    <label for="numeroInforme" style="width: 73px; text-align: right; padding: 4px 3px">Informe N&deg;</label>
    
    <input type="text" name="numeroInforme" id="numeroInforme" value="{{ numeroInforme }}" class="fieldInforme inputTextDefaults" style="float: left; margin-right: 20px;" />
    
    <label for="desdeInforme" style="width: 70px; text-align: right; padding: 4px 3px">Desde:</label>
    <input type="text" name="desdeInforme" id="desdeInforme" value="{{ desdeInforme }}" class="fieldInforme inputTextDefaults" style="width:85px" />
    <br /><br />

    <label for="nombreInforme" style="width: 73px; text-align: right; padding: 4px 3px">Nombre:</label>
    <input type="text" name="nombreInforme" id="nombreInforme" class="fieldInforme inputTextDefaults" value="{{ nombreInforme }}" style="float: left; margin-right: 20px;" />

    <label for="hastaInforme" style="width: 70px; text-align: right; padding: 4px 3px">Hasta:</label>
    <input type="text" name="hastaInforme" id="hastaInforme" value="{{ hastaInforme }}" class="fieldInforme inputTextDefaults" style="width:85px" />
    <br /><br />

    <br />
    <div style="text-align: right;padding-right: 20px;">
      <input type="button" id="updateInforme" value="Actualizar Informe" class="btn" />
      <span style="margin: 2px;">&oacute;</span>
      <a style="cursor: pointer" onclick="$('#ventana-dialogo').hide()">Cerrar</a>
    </div>
  </div>
   

  {[ if(cargarColumnasAlInforme)  { ]}
  

    {[ if (codigoInforme != '0') { ]} <!-- Edicion Informe: ODT -->

    <input type="hidden" name="idInforme" id="idInforme" value="{{ codigoInforme }}" class="fieldInforme" />

      <div class="InformesColumnsContainer">
        <span class="titleInformesColumns">Columnas en este Informe</span>
        <div class="listadoColumnas" id="listadoColumnas">
         
        </div>
      </div>      
      
      </div>
    {[ } ]} <!-- Edicion Informe: ODTs -->
  {[ } ]} <!-- si cargoODT en Informe -->

  
</div>

</script>
