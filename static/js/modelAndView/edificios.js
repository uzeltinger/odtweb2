// ---------------- MODEL ----------------

Edificio = Backbone.Model.extend({
  
  idAttribute: 'codigoEdificio',
  url: "api/edificio/update.asp",
  
  defaults: {
    
    Planta: '',
    Nombre: '',
    icon: 'creada',
    ListaAprobadores: [],
    ListaDefinidores: []
    
  },
  
  validate: function (attrs) {
        if (attrs.title) {
            if (!_.isString(attrs.Planta) || attrs.Planta.length === 0 ) {
                return "Debe seleccionar una Planta";
            }
            if (!_.isString(attrs.Nombre) || attrs.Nombre.length === 0 ) {
                return "Debe ingresar una Nombre para el edificio";
            }
        }
    }
  

});

// -------------------- VIEW -------------------------

EdificioView = Backbone.View.extend({
  
  tagName : 'li',
  
  className: 'odt-row',

  initialize : function() {
    //this.render();
    this.model.bind('change', this.render, this);    
  },

  render: function(){
    
    var variables = this.model.toJSON();
  
    var template = _.template($('#edificio_row_template').html());
    $(this.el).html( template(variables) );

    return this;
  },

  events: {
    "click"  : "editarEdificio"
  },

  
  editarEdificio: function() {
  
    var viewFull = new EdificioEditarView({model: this.model});
    var view = viewFull.render().el;
    
    $('#edificio-planta', view).val(this.model.get('planta'));
    
    $(".modal_dialog_content #modal_dialog_title").html("<span style='font-weight:normal;'>Editar </span><span>Edificio</span>");
                  
    $(".modal_dialog_content").width("530px");
    
    $("#edificio-planta", view).val(this.model.get("Planta"));
    
    $(".modal_dialog_body").html(view);
    $("#ventana-dialogo").show();
 
  }
  
}); 


EdificioEditarView = Backbone.View.extend({


  initialize : function(){
  },

  render: function(){
    
    var variables = this.model.toJSON();
    
    var template = _.template($('#edificiosEdicionTemplate').html());

    $(this.el).html( template(variables) );

    return this;
    
  },

  
  events: {
    'click #updateEdificio' : 'updateEdificio',
    'click #editDefinidores' : 'editDefinidores',
    'click #editAprobadores' : 'editAprobadores',
    'click #addDefinidor' : 'addDefinidor',
    'click #removeDefinidor' : 'removeDefinidor',
    'click #addAprobador' : 'addAprobador',
    'click #removeAprobador' : 'removeAprobador'
  },
  
  
  addDefinidor: function() {
    if (_.isUndefined($('#definidores option:selected').val())) return false;
    var opt = '<option value="'+ $('#definidores option:selected').val() +'">'+ $('#definidores option:selected').html() +'</option>';
    $('#ListaDefinidores').append(opt);
    $('#definidores option:selected').remove()
  },
  
  removeDefinidor: function() {
    if (_.isUndefined($('#ListaDefinidores option:selected').val())) return false;
    var opt = '<option value="'+ $('#ListaDefinidores option:selected').val() +'">'+ $('#ListaDefinidores option:selected').html() +'</option>';
    $('#definidores').append(opt);
    $('#ListaDefinidores option:selected').remove();
  },
  
  addAprobador: function() {
    if (_.isUndefined($('#aprobadores option:selected').val())) return false;
    var opt = '<option value="'+ $('#aprobadores option:selected').val() +'">'+ $('#aprobadores option:selected').html() +'</option>';
    $('#ListaAprobadores').append(opt);
    $('#aprobadores option:selected').remove()
  },

  removeAprobador: function() {
    if (_.isUndefined($('#ListaAprobadores option:selected').val())) return false;
    var opt = '<option value="'+ $('#ListaAprobadores option:selected').val() +'">'+ $('#ListaAprobadores option:selected').html() +'</option>';
    $('#aprobadores').append(opt);
    $('#ListaAprobadores option:selected').remove();
  },
  

  editDefinidores : function() {
    
    $('#editDefinidores, #editAprobadores').css({fontWeight:'normal', textDecoration : 'none'});
    $('#editDefinidores').css({fontWeight:'bold', textDecoration : 'underline'});
    
    $("#editDefinidoresContainer").show();
    $("#editAprobadoresContainer").hide();
    
  },
  
  editAprobadores: function() {
    
    $('#editDefinidores, #editAprobadores').css({fontWeight:'normal', textDecoration : 'none'});
    $('#editAprobadores').css({fontWeight:'bold', textDecoration : 'underline'});
    
    $("#editDefinidoresContainer").hide();
    $("#editAprobadoresContainer").show();
    
  },
  
  
  updateEdificio: function(evento) {
  
    var ListaDefinidores = [];
    var ListaAprobadores = [];
    
    $('#ListaDefinidores option').each(function(i,e){
        ListaDefinidores.push({'MNdefinidor': e.value, 'Nombre' : e.innerHTML});
    })
    
    $('#ListaAprobadores option').each(function(i,e){
        ListaAprobadores.push({'MNAprobador': e.value, 'Nombre' : e.innerHTML});
    })
  
    this.model.set({ Nombre: this.$('#edificio-nombre').val(),  
                     Planta: this.$('#edificio-planta').val(),
                     ListaAprobadores: ListaAprobadores,
                     ListaDefinidores: ListaDefinidores
                  });
                  
    this.model.save({},{ 
            success: function(model, response) {
                $('#ventana-dialogo').hide();

                if(model.get("action") == 'n') {
                    var view = new EdificioView({model: model});
                    $("#listaOdt").prepend(view.render().el);
                }

                
            }
        });
    
    
  }
  
  

});
