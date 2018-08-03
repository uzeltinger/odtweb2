
<script type="text/template" id="materialTemplate">

    <div class="labels">
      <label style="width: 255px; text-align: left">{{MaterialesTxt}}</label>
      <label style="width: 40px; text-align: right;">{{Cant}}</label>
      <label style="width: 60px; text-align: right;">{{Precio}}</label>
      <label style="width: 50px; text-align: left">{{NroFactura}}</label>
      <label style="width: 230px; text-align: left">{{Observaciones}}</label>
      <% if usuarioPuede(ODT_puedeCargarDetalle) then %>
      {[ if(readOnly == 0) { ]}
      <a href="#" id="go-trash" style="background: url(/odtweb/static/img/trash.gif) no-repeat 0 0;width: 12px;height: 12px;float: right;margin-top: 10px;"></a>
      {[ } ]}
      <% end if %>
    </div>
    <% if usuarioPuede(ODT_puedeCargarDetalle) then %>
    {[ if(readOnly == 0) { ]}
    <div class="editFields">
      <input type="text" name="MaterialesTxt" class="fieldMat" style="width: 255px" value="{{MaterialesTxt}}" />    
      <input type="text" name="Cant" class="fieldMat" style="width: 40px;text-align: right;" value="{{Cant}}" />
      <input type="text" name="Precio" id="servicio-precio" class="fieldMat" style="width: 60px;text-align: right;" value="{{Precio}}" />
      <input type="text" name="NroFactura" class="fieldMat" style="width: 50px" value="{{NroFactura}}" />
      <input type="text" name="Observaciones" class="fieldMat" style="width: 220px; margin-right: 5px" value="{{Observaciones}}" />
      <input type="button" id="addOk" value="Ok" class="btn" style="padding: 2px 6px;">
      
      <a href="#" id="go-trash" style="background: url(/odtweb/static/img/trash.gif) no-repeat 0 0;width: 12px;height: 12px;float: right;margin-top: 10px;"></a>
      
    </div>
    {[ } ]}
    <% end if %>
</script>

<script type="text/template" id="servicioTemplate">

    <div class="labels">
      <label style="width: 285px; text-align: left">{{Descripcion}}</label>
      <label style="width: 40px; text-align: right;">{{Cant}}</label>
      <label style="width: 60px; text-align: right;">{{Precio}}</label>
      <label style="width: 250px; text-align: left">{{Observaciones}}</label>
      <% if usuarioPuede(ODT_puedeCargarDetalle) then %>
      {[ if(readOnly == 0) { ]}
      <a href="#" id="go-trash" style="background: url(/odtweb/static/img/trash.gif) no-repeat 0 0;width: 12px;height: 12px;float: right;margin-top: 10px;"></a>
      {[ } ]}
      <% end if %>
    </div>

    <% if usuarioPuede(ODT_puedeCargarDetalle) then %>
    {[ if(readOnly == 0) { ]}
    <div class="editFields">
      <select name="codigoItem" class="fieldMat" style="width: 285px" id="cargarServicioDescripcion{{ItemID}}" /></select>
      <input type="text" name="Cant" class="fieldMat" style="width: 40px;text-align: right;" value="{{Cant}}" />
      <input type="text" name="Precio" class="fieldMat skipThisPlease" style="width: 60px;text-align: right;" value="{{Precio}}" disabled />
      <input type="text" name="Observaciones" class="fieldMat" style="width: 220px" value="{{Observaciones}}" />
      <input type="button" id="addOk" value="Ok" class="btn" style="padding: 2px 6px;">
      
      <a href="#" id="go-trash" style="background: url(/odtweb/static/img/trash.gif) no-repeat 0 0;width: 12px;height: 12px;float: right;margin-top: 10px;"></a>
      
    </div>
    {[ } ]}
    <% end if %>
</script>


<!-- SEEM NOT USED :(

<script type="text/template" id="cargarMatsTabsTemplate">
  <ul class="tabs" style="margin: 0;border-left: 0;background-color: #D8D8D8;border-top: 1px solid #999;">
      <li style="" class="active"><a href="#tab1">Solicitud</a></li>
      <li style="margin: 0px; height: 31px; " class=""><a href="#tab1">Materiales ($<span id="totalMateriales"></span>)</a></li>
      <li style="margin: 0;height: 31px;" class=""><a href="#tab2">Servicios ($<span id="totalServicios"></span>)</a></li>
      <li style="margin: 0;height: 31px;" class=""><a href="#tab3">Detalles</a></li>
      <li style="width: auto;width: 162px;text-align: right;padding-right: 10px;font-size: 17px;float: right;background-color: #D8D8D8;" >
        Total 
        <span style="font-weight: bold;">$ <span id="totalesMaterialesServicios"></span></span>
     </li>
  </ul>
</script>
-->