// ---------------- MODEL ----------------

Informe = Backbone.Model.extend({
  
    idAttribute: 'codigoInforme',
    sync: mySyncUpdateFunc,
    url: "api/inf/update.asp",
    
  defaults: {
    
    codigoInforme: 0,
    numeroInforme: 0,
    nombreInforme: 'Nombre de informe',
    desdeInforme:'',
    hastaInforme: '',
    fechaCreacion: '',
    mnCreacion: ''/*,
    idInforme: 0,
    idColumna: [],
    nombreColumna: [],
    colMostrar: [],
    colNombre: [],
    colFiltrar: 0,
    colFiltro: []*/
    
  },
  /*
    addODT: function(codigoODT) { // AGREGA ODT A Informe

        $.get("api/fac/addODT.asp",{ codigoFactura : this.get("codigoFactura"), "codigoODT" : codigoODT }, function(){
        });

    }, // addODT

    removeODT: function(codigoODT) { // REMOVE ODT FROM FACTURA

        $.get("api/fac/addODT.asp",{ codigoFactura : 0, "codigoODT" : codigoODT }, function(){
        });
    
    } // removeODT
*/
});

/*
InformeColumnas = Backbone.Model.extend({
  
  idAttribute: 'idInforme',
  url: "api/inf/updateColumns.asp",
  
  defaults: {
    idInforme: 0,
    idColumna: [],
    nombreColumna: [],
    colMostrar: [],
    colNombre: [],
    colFiltrar: 0,
    colFiltro: []
    
  },
  
  initialize: function(attributes) {
  }

});
*/

// -------------------- VIEW -------------------------

InformeView = Backbone.View.extend({
  
  tagName : 'li',
  
  className: 'informeRow',

  initialize : function() {
    this.render();
    this.model.bind('change', this.render, this);    
  },

  render: function(){    
    var variables = this.model.toJSON();
  console.log('variables',variables);

 


    if (variables.desdeInforme.indexOf("-") !== -1) {
        //alert(variables.desdeInforme);    
        //tiene un - viene en formato dd-mm-yy
        var m = moment(variables.desdeInforme, "DD-MM-YYYY");	
    } else {        
        var m = moment(variables.desdeInforme);        
    }
    variables.desdeInforme = m.format("DD") + "." + m.format("MMM") + "." + m.format("YY");
    
    if (variables.hastaInforme.indexOf("-") !== -1) {
      //alert(variables.hastaInforme);    
      //tiene un - viene en formato dd-mm-yy
      var m = moment(variables.hastaInforme, "DD-MM-YYYY");	
  } else {        
      var m = moment(variables.hastaInforme);        
  }
  variables.hastaInforme = m.format("DD") + "." + m.format("MMM") + "." + m.format("YY");    

    var template = _.template($('#informes_template').html());
    $(this.el).html( template(variables) );
    return this;
  },
  events: {
    "click .informeRowToEdit"  : "cargarColumnasInforme",
    "click .botonEditarInforme" : "editarInforme",
    "click .informeRowToGenerate" : "generarInforme"
  },
  
  editarInforme: function() {  
    var model = this.model;
    var viewFull = new InformeEditarView({model: model, cargarColumnasAlInforme: false});
    var view = viewFull.render().el;   

    $('#desdeInforme', view).datepicker({
      dateFormat: 'dd-mm-yy'
    });    
    $('#hastaInforme', view).datepicker({
      dateFormat: 'dd-mm-yy'
    });  
    $(".modal_dialog_content #modal_dialog_title").html("<span style='font-weight:normal;'>Editar </span><span>Informe</span>");
    $(".modal_dialog_body").html(view);   
    $(".modal_dialog_content").width("650px");    
    $("#ventana-dialogo").show();    
  },

  cargarColumnasInforme: function() {
    var model = this.model;
    var viewFull = new InformeEditarView({model: model, cargarColumnasAlInforme: true});
    var view = viewFull.render().el;
    var urlColumnasDelInforme = "api/odt/getColumnasDelInforme.asp?codigoInforme="+ model.get("codigoInforme");
    console.log('urlColumnasDelInforme',urlColumnasDelInforme);  
    $.get(urlColumnasDelInforme, function(estaLista, response){
      console.log('estaLista',estaLista);  
      var total = 0      
      $('#spinnerLeft').remove();  
      var rows = '';
      let trclass = '';
      var tableHtml = '<table><tr><th>Campo</th><th>Mostrar</th><th>Mostrar como</th><th>Filtrar</th><th>Filtro</th></tr>';      
      $(estaLista).each(function(i, obj){
        let colMostrarCheked = "";
        if(obj.colMostrar==1){ colMostrarCheked = 'checked="checked"';}
        let colFiltrarCheked = "";
        if(obj.colFiltrar==1){ colFiltrarCheked = 'checked="checked"';}
        trclass = (i%2==0?0:1);
        rows += '<tr class="tr' + trclass + '">';        
        rows += '<td>' + obj.idColumna + '</td>';         
        rows += '<td><input type="checkbox" name="colMostrar_' + obj.idColumna + '" value="'+obj.colMostrar+'" '+colMostrarCheked+' class="fieldInforme" onClick="if(this.checked==true){this.value=\'1\'}else{this.value=\'0\'}"></td>';            
        rows += '<td><input type="text" name="colNombre_' + obj.idColumna + '" value="' + obj.colNombre + '" class="fieldInforme"></td>'; 
        rows += '<td><input type="checkbox" name="colFiltrar_' + obj.idColumna + '" value="'+obj.colFiltrar+'" '+colFiltrarCheked+' class="fieldInforme colFiltrar_' + obj.idColumna + '" onClick="if(this.checked==true){this.value=\'1\'}else{this.value=\'0\'}"></td>'; 
        rows += '<td>'
        let mostrarInput = true;

        
        if(obj.idColumna=='codigoPlanta'){
          let codigoCuentaSelected = obj.colFiltro;
          rows += '<input type="hidden" name="codigoPlantaSelected" id="codigoPlantaSelected" value="' + obj.colFiltro + '"><a id="plantaComboLlenar" style="display: none;">aaa</a><select class="fieldInforme" style="opacity:.5; width: 200px;" id="plantaCombo" name="colFiltro_' + obj.idColumna + '" class="comboboxDefaults"></select>';
          mostrarInput = false;
        }
        
        if(obj.idColumna=='codigoEdificio'){
          let codigoEdificioSelected = obj.colFiltro;
          rows += '<input type="hidden" name="codigoEdificioSelected" id="codigoEdificioSelected" value="' + obj.colFiltro + '"><a id="edificioComboLlenar" style="display: none;">aaa</a><select class="fieldInforme" style="opacity:.5; width: 200px;" id="codigoEdificio" name="colFiltro_' + obj.idColumna + '" class="comboboxDefaults"></select>';
          mostrarInput = false;
        }
        
        if(obj.idColumna=='codigoCuenta'){
          let codigoCuentaSelected = obj.colFiltro;
          rows += '<input type="hidden" name="codigoCuentaSelected" id="codigoCuentaSelected" value="' + obj.colFiltro + '"><a id="cuentaComboLlenar" style="display: none;">aaa</a><select class="fieldInforme" style="opacity:.5; width: 200px;" id="cuentaCombo" name="colFiltro_' + obj.idColumna + '" class="comboboxDefaults"></select>';
          mostrarInput = false;
        }
        
        if(obj.idColumna=='codigoTipoTarea'){
          let codigoCuentaSelected = obj.colFiltro;
          rows += '<input type="hidden" name="codigoTipoTareaSelected" id="codigoTipoTareaSelected" value="' + obj.colFiltro + '"><a id="tipoTareaComboLlenar" style="display: none;">aaa</a><select class="fieldInforme" style="opacity:.5; width: 200px;" id="codigoTipoTarea" name="colFiltro_' + obj.idColumna + '" class="comboboxDefaults"></select>';
          mostrarInput = false;
        }
        
        if(mostrarInput){
          rows += '<input type="text" name="colFiltro_' + obj.idColumna + '" value="' + obj.colFiltro + '" class="fieldInforme">';
        }        
        
        rows += '</td>'; 
        rows += '</tr>';     
      });   

//idColumna, nombreColumna, colMostrar, colNombre, colFiltrar, colFiltro) VALUES "
        


      var tableHtml = tableHtml + rows + '</table>';
      $('#listadoColumnas').append(tableHtml);
      $('#plantaComboLlenar').click();
      $('#edificioComboLlenar').click();
      $('#tipoTareaComboLlenar').click();
      $('#cuentaComboLlenar').click();//updateCuenta();
      //console.log('rows',rows);  

    })
    .done(function(done) {
      //console.log('done',done);  
    })
    .fail(function(fail) {
      //console.log('fail',fail);  
    })
    .always(function(always) {
      //console.log('always',always);  
    }); // get urlColumnasDelInforme

    
      $(".modal_dialog_content #modal_dialog_title").html("<span style='font-weight:normal;'>Cargar Columnas en el </span><span>Informe Nro " + model.get("numeroInforme") + "</span>");
      $(".modal_dialog_body").html(view);         
      $(".modal_dialog_content").width("850px");      
      $("#ventana-dialogo").show();      
  },
  generarInforme: function(){
    console.log('generarInforme');
  },
}); // InformeView











InformeEditarView = Backbone.View.extend({
  initialize : function(){
    $("#editarInforme").show();
    
  },

  render: function(){    
    var variables = this.model.toJSON();
    variables.cargarColumnasAlInforme = this.options.cargarColumnasAlInforme;    

    

    if(variables.desdeInforme != "") {
        if (variables.desdeInforme.indexOf("-") !== -1) {
            //alert(variables.desdeInforme);    
            //tiene un - viene en formato dd-mm-yy
            var m = moment(variables.desdeInforme, "DD-MM-YYYY");        
        } else {            
            var m = moment(variables.desdeInforme);
        }
        variables.desdeInforme = m.format("DD-MM-YYYY");
    }  
    
    if(variables.hastaInforme != "") {
      if (variables.hastaInforme.indexOf("-") !== -1) {
          //alert(variables.hastaInforme);    
          //tiene un - viene en formato dd-mm-yy
          var m = moment(variables.hastaInforme, "DD-MM-YYYY");        
      } else {            
          var m = moment(variables.hastaInforme);
      }
      variables.hastaInforme = m.format("DD-MM-YYYY");
  }    

    var template = _.template($('#informesEdicionTemplate').html());
    $(this.el).html( template(variables) );
    return this;    
  },  

  events: {
    'click #updateInforme' : 'updateInforme',
    "click #cuentaComboLlenar" : "updateCuenta",
    "click #plantaComboLlenar" : "updateComboPlanta",
    "click #edificioComboLlenar" : "loadComboEdificio",
    "click #tipoTareaComboLlenar" : "updateComboTipoTarea",
    "change #plantaCombo" : "updateComboEdificio"
  },  

  updateInforme: function(evento) {
    console.log('updateInforme');
    var thisModel = this.model    
    $('.fieldInforme',this.$el).each(function(key, field) {
      thisModel.set(field.name,field.value, {silent : true});
      //this.InformeColumnas.set(field.name,field.value, {silent : true});
      //this.InformeColumnas.save();
      console.log('field.name: ' + field.name + ' field.value : ' + field.value);
    });    
    this.model.save();
    $("a#informes").click();
    $("#ventana-dialogo").hide();
  },
  updateComboPlanta: function(idPlanta){
    console.log('updateComboPlanta');
    let codigoPlantaSelected = $('#codigoPlantaSelected').val();  
    $('#plantaCombo').removeAttr('disabled');
    $('#plantaCombo').css('opacity', 1); 
    loadComboData($('#plantaCombo'),'api/getPlantas.asp', "", codigoPlantaSelected);
  },
  updateCuenta: function(){
    console.log('updateCuenta');
    console.log('cuentaCombo.val',$('#cuentaCombo').val());
    //$('#cuentaCombo').val();
      clearCombo('#cuentaCombo');
      let codigoCuentaSelected = $('#codigoCuentaSelected').val();  
      //let cuentas = 
      loadComboData($('#cuentaCombo'),'api/getCuentas.asp', "", codigoCuentaSelected);
      $('#cuentaCombo').removeAttr('disabled');
      $('#cuentaCombo').css('opacity', 1);      
    },
    updateComboEdificio: function(){  
      console.log('updateComboEdificio');  
      clearCombo('#codigoEdificio');
      loadComboData($('#codigoEdificio'),'api/getEdificios.asp', $("#plantaCombo").val(), "");  
      $('#codigoEdificio').removeAttr('disabled');
      $('#codigoEdificio').css('opacity', 1);
    },
    loadComboEdificio: function(){   
      let codigoPlantaSelected = $('#codigoPlantaSelected').val();  
      let codigoEdificioSelected = $('#codigoEdificioSelected').val();
      loadComboData($('#codigoEdificio'),'api/getEdificios.asp', codigoPlantaSelected, codigoEdificioSelected);
      $('#codigoEdificio').removeAttr('disabled');
      $('#codigoEdificio').css('opacity', 1);
    },
    updateComboTipoTarea: function(){
      console.log('updateComboTipoTarea');  
      let codigoTipoTareaSelected = $('#codigoTipoTareaSelected').val();
      loadComboData($('#codigoTipoTarea'),'api/getTipoTareas.asp', "", codigoTipoTareaSelected);
      $('#codigoTipoTarea').removeAttr('disabled');
      $('#codigoTipoTarea').css('opacity', 1);
      //$("#codigoTipoTarea").val(codigoTipoTarea);
    }

});
