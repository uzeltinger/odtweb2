// ---------------- MODEL ----------------

Factura = Backbone.Model.extend({
  
    idAttribute: 'codigoFactura',
    sync: mySyncUpdateFunc,
    url: "api/fac/update.asp",
    
  defaults: {
    
    codigoFactura: 0,
    FacturaNro: 0,
    Empresa: 'Devic SRL',
    FechaFactura: '',
    CodigoPrecio: 0,
    fechaCreacion: '',
    mnCreacion: '',
    Nombre: ''
    
  },
  
    addODT: function(codigoODT) { // AGREGA ODT A FACTURA

        $.get("api/fac/addODT.asp",{ codigoFactura : this.get("codigoFactura"), "codigoODT" : codigoODT }, function(){
        });

    }, // addODT

    removeODT: function(codigoODT) { // REMOVE ODT FROM FACTURA

        $.get("api/fac/addODT.asp",{ codigoFactura : 0, "codigoODT" : codigoODT }, function(){
        });
    
    } // removeODT

});





// -------------------- VIEW -------------------------

FacturaView = Backbone.View.extend({
  
  tagName : 'li',
  
  className: 'facturaRow',

  initialize : function() {
    this.render();
    this.model.bind('change', this.render, this);    
  },

  render: function(){
    
    var variables = this.model.toJSON();
  
    if (variables.FechaFactura.indexOf("-") !== -1) {
        //alert(variables.FechaFactura);    
        //tiene un - viene en formato dd-mm-yy
        var m = moment(variables.FechaFactura, "DD-MM-YYYY");
	
    } else {
        
        var m = moment(variables.FechaFactura);
        
    }
    variables.FechaFactura = m.format("DD") + "." + m.format("MMM") + "." + m.format("YY");
    
    var template = _.template($('#factura_template').html());
    $(this.el).html( template(variables) );

    return this;
  },

  events: {
    "click .botonCargarFacturasODT"  : "cargarFacturasODT",
    "click .botonEditarFactura" : "editarFactura"
  },

  
  editarFactura: function() {
  
    var model = this.model;
    var viewFull = new FacturaEditarView({model: model, cargarFacturasODT: false});
    var view = viewFull.render().el;
   
    $('#FechaFactura', view).datepicker({
      dateFormat: 'dd-mm-yy'
    });    
    
    $(".modal_dialog_content #modal_dialog_title").html("<span style='font-weight:normal;'>Editar </span><span>Factura</span>");
    $(".modal_dialog_body").html(view);   
    $(".modal_dialog_content").width("650px");
    
    $("#ventana-dialogo").show();
    
  },

  
  cargarFacturasODT: function() {
    
    var model = this.model;
    var viewFull = new FacturaEditarView({model: model, cargarFacturasODT: true});
    var view = viewFull.render().el;
    
    var urlODTsDeFactura = "api/odt/getODTsDeFactura.asp?codigoFactura="+ model.get("codigoFactura");

    $.get(urlODTsDeFactura, function(estaLista, response){

      var total = 0
      
      $('#spinnerLeft').remove();
    
      $(estaLista).each(function(i, obj){
        var totalODT = parseFloat(obj.totalODT);
        var row = '';
        row += '<span class="fCodigoODT">'+ obj.codigoODT +'</span>';
        row += '<span class="fMN">'+ obj.MNSolicitante +'</span>';
        row += '<span class="fNombre">'+ obj.Nombre +'</span>';
        row += '<span class="ftotalODT">'+ totalODT.toFixed(2) +'</span>';

        row += '<span class="fButton iconRight">&nbsp;</span>';
        
        $('#odtFactura').append('<li value="'+ obj.codigoODT +'" class="addRemove">'+ row +'</li>');

        total += obj.totalODT;
      });
      
      $('#fTotal').html(total.toFixed(2));
      



      // cuando finaliza de cargar las odts en esta factura procedo a cargar las odt sin facturar
      
      $.get("api/odt/getODTsDeFactura.asp?codigoFactura=0", function(estaLista, response){

        $('#spinnerRight').remove();

        $(estaLista).each(function(i, obj){
          var totalODT = parseFloat(obj.totalODT);
          var row = '';
          row += '<span class="fButton iconLeft">&nbsp;</span>';
          row += '<span class="fCodigoODT">'+ obj.codigoODT +'</span>';
          row += '<span class="fMN">'+ obj.MNSolicitante +'</span>';
          row += '<span class="fNombre">'+ obj.Nombre +'</span>';
          row += '<span class="ftotalODT">'+ totalODT.toFixed(2) +'</span>';


          $('#odtSinFacturar').append('<li value="'+ obj.codigoODT +'" class="addRemove">'+ row +'</li>');

          
        });


        
        

        $('.addRemove').bind({
        
          
          click : function(){ 
          
            thisRow = $(this);
            var odtTotal = 0;
            var codigoODT = parseInt(thisRow.find('.fCodigoODT').html());
            
            if (thisRow.find('.iconLeft').html()) { // odt sin Facturar
              $('.fButton',thisRow).appendTo(thisRow);  
              $('.fButton',thisRow).removeClass('iconLeft').addClass('iconRight').removeClass('iconLeft');
              $('#odtFactura').append(thisRow);
              // sumar odt
              odtTotal = parseFloat(thisRow.find('.ftotalODT').html());
              model.addODT(codigoODT);

            } else { // odt en esta Factura
              $('.fButton',thisRow).prependTo(thisRow); 
              $('.fButton',thisRow).removeClass('iconLeft').addClass('iconLeft').removeClass('iconRight');
              $('#odtSinFacturar').append(thisRow);
              // resstar ODT
              odtTotal = parseFloat(thisRow.find('.ftotalODT').html()) * -1;
              model.removeODT(codigoODT);
            }
            
            var total = parseFloat($('#fTotal').html());
            var sumatoria = total + odtTotal;
            
            $('#fTotal').html(sumatoria.toFixed(2));

          }
        });
    

    
      }); // GET SIN FACTURAR

      
    }); // get ODT de factura

    
    $('#FechaFactura', view).datepicker({
      dateFormat: 'dd-mm-yy',
      
      onSelect: function() {
        $(this).change();
      }
    });
    
    $(".modal_dialog_content #modal_dialog_title").html("<span style='font-weight:normal;'>Cargar Ordenes de Trabajo en </span><span>Factura Nro " + model.get("FacturaNro") + "</span>");
    $(".modal_dialog_body").html(view);   
    $(".modal_dialog_content").width("850px");
    
    $("#ventana-dialogo").show();
    
    
  }

}); // facturaView








FacturaEditarView = Backbone.View.extend({


  initialize : function(){
    $("#editarFactura").show();
    
  },

  render: function(){
    
    var variables = this.model.toJSON();
    variables.cargarFacturasODT = this.options.cargarFacturasODT;
    
    if(variables.FechaFactura != "") {
        if (variables.FechaFactura.indexOf("-") !== -1) {
            //alert(variables.FechaFactura);    
            //tiene un - viene en formato dd-mm-yy
            var m = moment(variables.FechaFactura, "DD-MM-YYYY");
        
        } else {
            
            var m = moment(variables.FechaFactura);
        }
        variables.FechaFactura = m.format("DD-MM-YYYY");
    }
    
    var template = _.template($('#facturasEdicionTemplate').html());

    $(this.el).html( template(variables) );

    return this;
    
  },


  
  events: {
    'click #updateFactura' : 'updateFactura'
  },

  
  updateFactura: function(evento) {
    var thisModel = this.model
    
    $('.fieldFactura',this.$el).each(function(key, field) {
      thisModel.set(field.name,field.value, {silent : true});
    });
    
    this.model.save();
    $("#ventana-dialogo").hide();
    
    
  }
  
  

});
