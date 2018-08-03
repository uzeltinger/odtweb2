// --------------------------- MODEL ------------------------------------

ServicioRealizado = Backbone.Model.extend({

  defaults: {
    Cant: 0,
    ItemID: 0,
    Observaciones: "",
    NroOrden: 0,
    codigoItem: 0,
    fechaCreacion: "",
    mnCreacion: "",
    Descripcion: "",
    Precio: 0

  },


  idAttribute: "ItemID",
  url: "api/ser/update.asp",
  sync: mySyncUpdateFunc,
  
    initialize: function(attributes) {
    
    // Defino comportamiento al modificar el modelo
    this.on('change:codigoItem', this.updatePrecioDescripcion);
  },
  
  updatePrecioDescripcion : function() {
  
    this.set("Precio",getPrecioServicioFromId(this.get("codigoItem")));
    this.set("Descripcion",getDescripcionServicioFromId(this.get("codigoItem")));
  }
});






ListaServicios = Backbone.Collection.extend({

    model: ServicioRealizado,

    initialize: function() {

    this.bind("add", function(m) {


        var view = new ServicioRealizadoView({model: m});
        
        $("#listaServicios").append(view.render().el);
        
        view.toggleEdit();
        view.$("select").select();

      }, this);
    }
});



// --------------------------- VIEW ------------------------------------

ServicioRealizadoView = Backbone.View.extend({
  
  tagName : 'li',
  
  className: 'serviciosView',

  firstEnter: true,  
  
  events: {
    'click input[type=button]' : 'update',
    'click a#go-trash' : 'destroy',
    'keyup':'jumpToNextField',
    'click' : 'toggleEdit',
    'change select': 'updateServicio',
    'change input[name=Cant]': 'updateCantidad'
  },
  
  
  render: function() {
    var variables = this.model.toJSON();
    
    variables.Precio = "$ " + parseFloat(variables.Precio).toFixed(2);
    variables.readOnly = this.model.collection.odt.get("CompletadaEmpresa");
    
    
    var template = _.template($('#servicioTemplate').html());
    
    
    $(this.el).html( template(variables) );
    
    loadComboDataFromJSONObj($('#cargarServicioDescripcion'+this.model.get('ItemID'), this.$el), systemConfig.serviciosComboData, this.model.get('codigoItem'));

    return this;
  },
  
  
  updateServicio: function(e) {

    var idSelected = $(e.srcElement).val();
    this.model.set("codigoItem",idSelected, {silent:true});
    
    var Cant = parseFloat(this.$('[name=Cant]').val().replace("$","").replace(",","."));
    var Precio = getPrecioServicioFromId(idSelected);
    
    this.model.set("Precio", Precio, {silent: true});
    
    this.$('[name=Precio]').val("$ " + parseFloat(Precio).toFixed(2));
  
    return false;
    
  },
  

  
  updateCantidad: function(e) {
    
        var idSelected = this.$('[name=codigoItem]').val();
        
        var Cant = parseFloat(this.$('[name=Cant]').val().replace("$","").replace(",","."));
        var Precio = getPrecioServicioFromId(idSelected);

        this.model.set("Cant", Cant, {silent:true});
        this.$('[name=Precio]').val("$ " + parseFloat(Precio).toFixed(2));
      
        return false;
    },

    
    vacio: function() {
  
        return (this.$("[name=codigoItem]").val() == "" &&
               parseFloat(this.$("[name=Precio]").val().replace("$","")) == 0 && 
               parseFloat(this.$("[name=Cant]").val()) == 0 && 
               this.$("[name=Observaciones]").val() == "");
    },
    
  
    toggleEdit: function(e) {
    
        var thisRow = this.$el;
    
        if (this.model.collection.odt.get("CompletadaEmpresa") != 0 ) {
            return false;
        }
            
        if(!thisRow.hasClass('serviciosEdit')) {
      
            $('.serviciosView').removeClass('serviciosEdit');
            thisRow.addClass('serviciosEdit');
            /*
            var ItemIDTemp = this.model.get("ItemID");
            $('#cargarServicioDescripcion'+ItemIDTemp).empty();
            */
            
            //loadComboDataFromJSONObj($('#cargarServicioDescripcion'+ItemIDTemp), systemConfig.serviciosComboData, this.model.get('codigoItem'));
        }
      
        return false
    },
  
  
  destroy: function() {
    
    if(this.model.get("ItemID") == 0) {
        this.remove();
        $("input[type=button]#addServicio").focus();
    } else {
        if(this.vacio()) {
                var _this = this;
                _this.model.collection.remove(_this);
                this.model.destroy({success: function(model, response) {
                    _this.remove();
                    $("input[type=button]#addServicio").show();
                    $("input[type=button]#addServicio").focus();
                }});
                return false;            
        }
        
        if(confirm("¿Está seguro que quiere borrar ese servicio?")) {
            var _this = this;
            _this.model.collection.remove(_this);
            this.model.destroy({success: function(model, response) {
                _this.remove();
                $("input[type=button]#addServicio").show();
                $("input[type=button]#addServicio").focus();
            }});
        }
    }
  
    return false;
  },

  
  update: function(evento) {

    var modelo = this.model;

    var attr = {
        Cant: parseFloat(this.$("[name=Cant]").val().replace(",",".")),
        codigoItem: this.$("[name=codigoItem]").val(),
        Observaciones: this.$("[name=Observaciones]").val(),
        Precio: parseFloat(this.$("[name=Precio]").val().replace("$","")),
    };

    modelo.set(attr, {silent: true});

    var _this = this;
    _this.$el.css('opacity', '.5');

    modelo.save({},{success: function(model, response) {
        _this.render();
        _this.$el.removeClass('serviciosEdit');
        _this.$el.css('opacity', '1');
        
        $("input[type=button]#addServicio").show();
        $("input[type=button]#addMaterial").focus();
        
    }});

    return false;
    
  },
  
  
  jumpToNextField: function(evt) {
    
    _this = this;
    
    if(!$(evt.srcElement).hasClass("btn")){
        var charCode = evt.charCode || evt.keyCode;
        
        if (charCode  == 13) { //Enter 
        
          evt.preventDefault();
           
           //if(this.firstEnter) {
           //}
           
          if($(evt.srcElement).next().is('input.skipThisPlease')) {
            $(evt.srcElement).next().next().select();
          } else {
            $(evt.srcElement).next().select();
          }
          return false;
        }
        
        if (charCode  == 27) { //Esc
          
          evt.preventDefault();
          _this.render();
          _this.$el.removeClass('serviciosEdit');
          $("input[type=button]#addServicio").show();
          $("input[type=button]#addServicio").focus();
          
          return false;
        }
    }
  }

});


// ---------------- MODEL ----------------

Servicio = Backbone.Model.extend({
  
  idAttribute: 'codigoItem',
  url: "api/servicio/update.asp",
  
  defaults: {
    
    codigoItem: 0,
    Descripcion: "",
    codigoSAP: "",
    Precio: 0,
    icon : 'creada'
    
  },
  
  initialize: function(attributes) {
  }

});

// -------------------- VIEW -------------------------

ServicioView = Backbone.View.extend({
  
  tagName : 'li',
  
  className: 'odt-row',

  initialize : function() {
    //this.render();
    this.model.bind('change', this.render, this);    
  },

  render: function(){
    
    var variables = this.model.toJSON();
    
    variables.Precio = parseFloat(variables.Precio).toFixed(2);
    
    var template = _.template($('#servicio_row_template').html());
    $(this.el).html( template(variables) );

    return this;
  },

  events: {
    "click"  : "editarServicio"
  },

  
  editarServicio: function() {
  
    var model = this.model;
    var viewFull = new ServicioEditarView({model: model});
    var view = viewFull.render().el;
   
    
    $(".modal_dialog_content #modal_dialog_title").html("<span style='font-weight:normal;'>Editar </span><span>Servicio</span>");
                  
    $(".modal_dialog_content").width("530px");

    $(".modal_dialog_body").html(view);
    $("#ventana-dialogo").show();
 
  }
  
}); 


ServicioEditarView = Backbone.View.extend({


  initialize : function(){
    $("#editarServicio").show();
  },

  render: function(){
    
    var variables = this.model.toJSON();
    variables.Precio = "$ " + parseFloat(variables.Precio).toFixed(2);
     
    var template = _.template($('#serviciosEdicionTemplate').html());

    $(this.el).html( template(variables) );

    return this;
    
  },


  
  events: {
    'click #updateServicio' : 'updateServicio',
    'blur #servicio-precio' : 'blurPrecio',
    'focus #servicio-precio' : 'enterPrecio'
  },

  
  updateServicio: function(evento) {
    
    this.model.set({ Descripcion : this.$('#servicio-descr').val(),  
                     Precio : this.$('#servicio-precio').val().replace("$",""),
                     codigoSAP : this.$('#codigoSAP').val()
                  });
                  
    this.model.save({},{ 
            success: function(model, response) {
                $('#ventana-dialogo').hide();
                if(model.get("action") == 'n') {
                    var view = new ServicioView({model: model});
                    $("#listaOdt").append(view.render().el);
                }
                
            }
        });
    
  },
  
  enterPrecio: function() {
  
    var p = $.trim($("#servicio-precio", this.$el).val());
    
    p = p.replace("$", "");
    p = p.replace(".00", "");
    
    $("#servicio-precio", this.$el).val(p);
    
  },
  
  blurPrecio: function() {
  
    var p = parseFloat( $.trim($("#servicio-precio", this.$el).val().replace(",",".")));
    
    $("#servicio-precio", this.$el).val("$ " + p.toFixed(2));
    
  }
  
  

});



