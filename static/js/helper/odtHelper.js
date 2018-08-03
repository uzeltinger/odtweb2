function clearCombo(idEl) {
	$(idEl).empty();
	$(idEl).append('<option value="-99">Seleccione...</option>');
}





function getServiciosDataCombo(fnCallBack) {

    $.ajax({
        type: 'POST',
        url: 'api/getServicios.asp',
        dataType : 'json',
        
        error: function(XMLHttpRequest, textStatus, errorThrown) {
      alert(textStatus); 
        },

        success: function(comboData){
        
          systemConfig.serviciosComboData = comboData;
          fnCallBack();
        }
    });      

}//FN



function loadComboData(el, urlJson, IdRequest, defaultSelected) {

  $.ajax({
      type: 'POST',
      url: urlJson,
      data: 'idRequest=' + IdRequest,
      dataType : 'json',
      
      error: function(XMLHttpRequest, textStatus, errorThrown) {
       alert(textStatus); 
      },

      success: function(comboData){
      
        loadComboDataFromJSONObj(el, comboData, defaultSelected);

      }
  });
  
} // FN


function loadComboDataSync(el, urlJson, IdRequest, defaultSelected) {

  $.ajax({
      type: 'POST',
      url: urlJson,
      data: 'idRequest=' + IdRequest,
      dataType : 'json',
      async:   false,
      
      error: function(XMLHttpRequest, textStatus, errorThrown) {
       alert(textStatus); 
      },

      success: function(comboData){
      
        loadComboDataFromJSONObj(el, comboData, defaultSelected);

      }
  });
  
} // FN



function MNaNombre(mn)
{
	$("select#MNaNombre").val(mn.toUpperCase());
	var nombre = $("select#MNaNombre option:selected").text(); 
	return nombre;
}





function loadComboDataFromJSONObj(el, comboData, defaultSelected) {

        
        _.each(comboData, function(value,key) {
        
          var selected;

          if (isNaN(defaultSelected)) {
            var selected = (value.id == defaultSelected)? ' selected ':'';
            } else { var selected = (value.id.toString() == defaultSelected.toString())? ' selected ':''; }

          el.append('<option value="'+ value.id +'"'+ selected +'>'+ value.text +'</option>');
          
        });
 
 
} // FN





function getPrecioServicioFromId(id) {

  var Precio = 0;

  $(systemConfig.serviciosComboData).each(function(index, elemento){
    
    if(elemento.id == id) {
      
      Precio = elemento.Precio;
    }
  });

  return Precio;
}




function getDescripcionServicioFromId(id) {

  var Descripcion = "";

  $(systemConfig.serviciosComboData).each(function(index, elemento){
    
    if(elemento.id == id) {
      
      Descripcion = elemento.text;
    }
  });

  return Descripcion;
}



