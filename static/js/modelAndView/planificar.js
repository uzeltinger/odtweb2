// -------------------- VIEW -------------------------

PlanificarView = Backbone.View.extend({
  
  tagName : 'div',
  
  className: 'planificar-view',

  fecha: '',
  
  initialize : function() {
    //this.render();
    //this.model.bind('change', this.render, this);    
    
  },

  render: function(){
    
    var template = _.template($('#planificacion_main_template').html());
    $(this.el).html( template() );

    return this;
  },

  events: {
    "click a#der"  : "semanaAdelante",
    "click a#izq"  : "semanaAtras"
  },
  
  cargarLista: function(fecha) {
    var _this = this;
    
    if(fecha == $.undefined) {
        var d = new moment();
        fecha = d.format("YYYY-MM-DD");
    }
    
    this.fecha = moment(fecha, "YYYY-MM-DD");
    
    this.fecha.day(0); // calculo el ultimo domingo
         
    var f = this.fecha.clone();
    
    for(i=0;i<7;i++) {
        $($(".dias-refe .dia")[i]).text(f.format("ddd DD MMM"));
        f.add('days', 1);
        _this.$($("ul.semana .dia-col")[i]).empty();
        
        if(moment().dayOfYear() == f.dayOfYear()) {
            _this.$($(".dias-refe .dia")[i]).addClass("hoy");
        } else {
            _this.$($(".dias-refe .dia")[i]).removeClass("hoy");
        }
    }
	
	$("#spinner").show();
    
    $.get("/odtweb/api/planificar/list.asp?fecha=" + this.fecha.format("YYYY-MM-DD"), function(estaLista, response) {
         if($.isFunction(estaLista.toJSON)) {
            estaLista = estaLista.toJSON();
         };

        $(estaLista).each( function(idx, odt_json) {
            
            var odt = new Odt(odt_json);
            
            var view = new PlanificarOdtView({model: odt});
            view.FechaPlanificador = _this.fecha;
            odt.trigger("change");
            
        });
		
		$("#spinner").hide();
     });
  },

  semanaAdelante: function() {
    this.fecha.add("days", 7);
    this.cargarLista(this.fecha.format("YYYY-MM-DD"));
  },
  
  
  semanaAtras: function() {
    this.fecha.subtract("days", 7);
    this.cargarLista(this.fecha.format("YYYY-MM-DD"));
  }
  
  
});

// -------------- LISTADO ODT (row) ----------------------------------

PlanificarOdtView = Backbone.View.extend({
  
  tagName : 'li',
  
  className: 'planificar-odt',

  initialize : function() {
    this.model.bind('change', this.posicionar, this);
  },

  render: function(){
    
    var variables = this.model.toJSON();
    var template = _.template($('#planificacion_odt_template').html());
    $(this.el).html( template(variables) );

    return this;
  },

  events: {
    "click .row"  : "mostrarODT"
  },
  
  posicionar: function() {
    
        var fp = new moment(this.model.get("FechaPlanificacion"));
        var offset = fp.diff(this.FechaPlanificador, "days");
        //offset = 1;
        
        if (offset >=0 && offset <= 6) {
            $($("ul.semana .dia-col")[offset]).append(this.render().el);
        } else {
            $(this.render().el).hide();
        }
        
  },

  mostrarODT: function() {
  
    var model = this.model;

    var viewFull = new OdtFullView({model: model});
    var view = viewFull.render().el;

    // seteamos combos con los valores q recibimos

    $('#codigoPlanta', view).val(model.get('codigoPlanta'));

    loadComboData($('#codigoEdificio', view), 'api/getEdificios.asp', model.get('codigoPlanta'), model.get('codigoEdificio'));

    loadComboData($('#MNdefinidor', view), 'api/getDefinidores.asp', model.get('codigoEdificio'),  model.get('MNdefinidor'));

    $("#MNcontacto", view).val(model.get('MNcontacto'));
    $("#codigoPrioridad", view).val(model.get('codigoPrioridad'));
    $("#codigoTipoTarea", view).val(model.get('codigoTipoTarea'));
    $(".modal_dialog_content #modal_dialog_title").html("<span style='font-weight:normal;'>Orden de Trabajo</span><span> Nro " + model.get('codigoODT') + "</span>");
                  
    $(".modal_dialog_content").width("830px");

    $(".modal_dialog_body").html(view);
    
    $("#ventana-dialogo").show();
    
  }

})


 
