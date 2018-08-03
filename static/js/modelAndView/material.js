
var mySyncFunction = function(method, model, options) {
        if(method=='fetch') {
            options.url = model.url + '?id=' + model.id; 
        } else if(method=='delete') {
            options.url = model.url + '?id=' + model.id; 
        } else {
            options.url = model.url; 
        }
        return Backbone.sync(method, model, options);
}
// ------------------- MODEL --------------------------------------------

Material = Backbone.Model.extend({

  idAttribute: "ItemID",
  url: "api/mat/update.asp",
  sync: mySyncFunction,
  
  defaults: {
    Cant: 0,
    CodigoODT: 0,
    ItemID: 0,
    MaterialesTxt: "",
    Observaciones: "",
    NroFactura: "",
    Precio: 0,
    fechaCreacion: "",
    mnCreacion: ""
  },

  initialize: function(attributes) {
    
    // Defino comportamiento al modificar el modelo

  }
  

});

ListaMateriales = Backbone.Collection.extend({
  
  model: Material,
  odt: null,

  initialize: function() {
  
        this.bind("add", function(m) {

          var view = new MaterialView({model: m});
          $("#listaMateriales").append(view.render().el);
          view.toggleEdit();
          view.$("[name=MaterialesTxt]").focus();
            
        }, this);
        
        //this.on('change', this.updateTotalMateriales, this);
    
  }

  
});





// Materiales VIEW ----------------------

MaterialView = Backbone.View.extend({
  
  tagName : 'li',
  
  className: 'materialesView',
  
  firstEnter: true,
  
  initialize: function(){
  
  },
  
  render: function() {
    var variables = this.model.toJSON();
    
    variables.Precio = "$ " + parseFloat(variables.Precio).toFixed(2);
    
    variables.readOnly = this.model.collection.odt.get("CompletadaEmpresa");
    
    var template = _.template($('#materialTemplate').html());
    
    $(this.el).html( template(variables) );

    return this;
  },
  
  events: {
    'click input[type=button]' : 'update',
    'click a#go-trash' : 'destroy',
    'keyup':'jumpToNextField',
    'click' : 'toggleEdit',
    'blur #servicio-precio' : 'blurPrecio',
    'focus #servicio-precio' : 'enterPrecio'

  },
  
  vacio: function() {
  
        return (this.$("[name=MaterialesTxt]").val() == "" &&
               parseFloat(this.$("[name=Precio]").val().replace("$","").replace(",",".")) == 0 && 
               parseFloat(this.$("[name=Cant]").val()) == 0 && 
               this.$("[name=Observaciones]").val() == "");
    },
    
  toggleEdit: function() {
  
    if (this.model.collection.odt.get("CompletadaEmpresa") != 0 ) {
        return false;
    }
    
  
    $("li", this.$el.parent()).removeClass("materialesEdit");
    this.$el.addClass('materialesEdit');
    return false;
  },
  
  destroy: function() {
    if(this.model.get("ItemID") == 0) {
        this.remove();
        $("input[type=button]#addMaterial").show();
        $("input[type=button]#addMaterial").focus();
    } else {
        if(this.vacio()) {
                var _this = this;
                _this.model.collection.remove(_this);
                this.model.destroy({success: function(model, response) {
                    _this.remove();
                    $("input[type=button]#addMaterial").show();
                    $("input[type=button]#addMaterial").focus();
                }});
                return false;            
        }
        
        if(confirm("¿Está seguro que quiere borrar ese material?")) {
            var _this = this;
            _this.model.collection.remove(_this);
            this.model.destroy({success: function(model, response) {
                _this.remove();
                $("input[type=button]#addMaterial").show();
                $("input[type=button]#addMaterial").focus();
            }});
        }
    }
    
    return false;
  },
  
  update: function(evento) {
    
    var modelo = this.model;
    
    var attr = {
        Cant: parseFloat(this.$("[name=Cant]").val().replace(",",".")),
        MaterialesTxt: this.$("[name=MaterialesTxt]").val(),
        Observaciones: this.$("[name=Observaciones]").val(),
        NroFactura: this.$("[name=NroFactura]").val(),
        Precio: parseFloat(this.$("[name=Precio]").val().replace("$","").replace(",",".")),
    };
    
    modelo.set(attr, {silent: true});
    
    var _this = this;
    _this.$el.css('opacity', '.5');
    
    modelo.save({},{success: function(model, response) {
        _this.render();
        _this.$el.removeClass('materialesEdit');
        _this.$el.css('opacity', '1');
        
        $("input[type=button]#addMaterial").show();
        $("input[type=button]#addMaterial").focus();
    }});
    
    return false;
    
  },
  
  jumpToNextField: function(evt) {

    var _this = this;
    
    if(!$(evt.srcElement).hasClass("btn")){
        var charCode = evt.charCode || evt.keyCode;
        
        if (charCode  == 13) { //Enter 
        
          evt.preventDefault();
          
          if(this.firstEnter) {
            $(evt.srcElement).select();
            this.firstEnter = false;
          } else { 
            $(evt.srcElement).next().select();
          }
          
          return false;
        }
        
        if (charCode  == 27) { //Esc
          evt.preventDefault();
          
          if(_this.vacio()){
            _this.destroy();
          } else {
            _this.render();
            _this.$el.removeClass('materialesEdit');
          }
          $("input[type=button]#addMaterial").show();
          $("input[type=button]#addMaterial").focus();
          return false;
        }
    }
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

})






