// ------------- MODELS ---------------------------------------

Odt = Backbone.Model.extend({
  
  idAttribute: "codigoODT",
  
  url : function() {
    var base = "/odtweb/api/odt/update.asp";
    if (this.isNew()) return base;
    return base + "?codigoODT=" + this.id;
  },
     
  defaults: {
    
    codigoODT : 0,
    codigoPlanta: '',
    codigoPrioridad: 'N',
    codigoEdificio: '',
    FechaHoraSolicitud: '',
    MNSolicitante: '',
    nombreSolicitante: '',
    MNAprobador: '',
    MNcontacto: '',
    MNAnulacion: '',
    nombreAnulacion: '',
    Nombre: '',
    Cuenta: '',
    codigoCuenta: 0,
    DescripcionODT:'',
    UbicacionTarea:'',
    FechaRealizacion:'',
    CompletadaEmpresa:'0',
    Aprobado:'0',
    ComentariosSG:'',
    FacturaNro:'0',
    codigoFactura:'0',
    MNdefinidor:'',
    fechaDefinicion:'',
    definido:'0',
    presupuestar:'0',
    fechaCreacion:'',
    mnCreacion:'',
    fechaModificacion:'',
    mnModificacion:'',
    activo: '0',
    iniciado: '0',
    icon: 'creada', 
    fechaMostrar: '',
    nombreSolicitante: '',
    nombreDefinidor: '',
    totalMateriales : 0,
    totalServicios : 0,
    detallesSelectedTab: 1,
    enviarCorreoConfirmacionODT: 0,
    
    ListaMateriales: null,
    ListaServicios: null
  },

  validate: function(attributes){
      // attributes: este mismo objeto, ej attributes.codigoODT accedo a id

  },
  
  initialize: function(attributes) {
  
    this.attributes.ListaMateriales = new ListaMateriales(attributes.materiales);
    // Si cambia algo en ListaMateriales, disparo evento change en ODT.
    //this.attributes.ListaMateriales.on('change', this.change, this);
    this.attributes.ListaMateriales.odt = this;
    
    this.attributes.ListaServicios = new ListaServicios(attributes.servicios);
    //this.attributes.ListaServicios.on('change', this.change, this);
    this.attributes.ListaServicios.odt = this;
  },
  
  getTotalMateriales: function() {
    
    var listaMateriales = this.attributes.ListaMateriales.toJSON();
    var totalMateriales = 0;

    $.each(listaMateriales, function(k,v){ totalMateriales += v.Precio * v.Cant; });
   
    return totalMateriales + totalMateriales * this.attributes.coeficienteGM;
  },
  
  getTotalServicios: function() {
    
    var listaServicios = this.attributes.ListaServicios.toJSON();
    var totalServicios = 0;

    $.each(listaServicios, function(k,v){ totalServicios += v.Precio * v.Cant; })
   
    return totalServicios;
  }
});




Odts = Backbone.Collection.extend({
  
  model: Odt

});







// ------------- VIEWS ---------------------------------------
// -------------- DEFINIR ODT ----------------------------------

OdtDefinirView = Backbone.View.extend({
  initialize : function(){
    //$(".ODTFULL").show();
  },

  render: function(){
    var variables = this.model.toJSON();
    var template = _.template($('#odtDefinirTemplate').html());

    $(this.el).html( template(variables) );

    return this;
  },

  events: {
  'click input[type=button]#definirODT' : 'definirODT',
  'change #aprobadoresCombo': 'updateCuenta'
  
  },
    
  definirODT: function() {
    
    var modelo = this.model;
    
    if( $.trim($('#aprobadoresCombo').val()) < 0 ) {
        alert("Debe selecionar un Aprobador");
        $("#aprobadoresCombo").focus();
        return;
    }
    
    if( $.trim($('#cuentaCombo').val()) == "-99" || $.trim($('#cuentaCombo').val()) == "" ) {
        alert("Debe selecionar una cuenta");
        $("#cuentaCombo").focus();
        return;
    }
    
    modelo.set({  definido : '1',  
                  MNAprobador : $('#aprobadoresCombo').val(),
                  codigoCuenta: $('#cuentaCombo').val()
               });
               
    modelo.save({},{ 
            success: function(model, response) {
            
                model.set({ icon:"definida",
                            nombreDefinidor: NOMBRE_USUARIO_DEFAULT });
                
                app.updateCounters();
                $("#ventana-dialogo").hide();
            }
        });
    
  },
  
  updateCuenta: function(){

    clearCombo('#cuentaCombo');
    loadComboData($('#cuentaCombo'),'api/getCuentas.asp', $('#aprobadoresCombo').val(), "");
    $('#cuentaCombo').removeAttr('disabled');
    $('#cuentaCombo').css('opacity', 1);
    
  }
});

// -------------- EDICION ODT ----------------------------------

OdtFullView = Backbone.View.extend({
  
  
  initialize: function() {
    
    this.model.bind('change', this.render, this);
    
    this.model.attributes.ListaMateriales.on('change remove', this.updateTotals, this);
    this.model.attributes.ListaServicios.on('change remove', this.updateTotals, this);
  },
    
    updateTotals: function() {
  
        var tm = this.model.getTotalMateriales();
        var ts = this.model.getTotalServicios();
        
        $("#totalMateriales", this.$el).text(parseFloat(tm).toFixed(2));
        $("#totalGM", this.$el).text(parseFloat(tm * (1 - ( 1 / (1 + parseFloat(this.model.attributes.coeficienteGM))))).toFixed(2));
        $("#totalServicios", this.$el).text(parseFloat(ts).toFixed(2));
        $("#totaltotal", this.$el).text(parseFloat(tm + ts).toFixed(2));
        
    },

  render: function(){
    
    var variables = this.model.toJSON();
    
    if(variables.FechaRealizacion) {
        variables.FechaRealizacion = moment(variables.FechaRealizacion).format("DD.MMM.YYYY");
    }
    
    var template = _.template($('#odt_template_full').html());
    
    $(this.el).html( template(variables) );
    
    this.updateTotals();
    
    if ( this.model.get("iniciado") ) {
        this.cargarMateriales();
    }
    
    return this;
  },

  events: {
    'click input[type=button]#update'       : 'updateModel',
    'click input[type=button]#definir'      : 'definirODT',
    'click input[type=button]#anular'       : 'anularODT',
    'click a#anular'                        : 'anularODT',
    'change #codigoPlanta'                  : 'updateComboEdificio',
    'change #codigoEdificio'                : 'updateComboDefinidor',
    'click input[type=button]#addMaterial'  : 'addMaterial',
    'click input[type=button]#addServicio'  : 'addServicio',
    'click '                                : 'removeEditing',
    'click #iniciar.btn'                    : 'comenzarTrabajo',
    'click ul.tabs li'                      : 'cambiarTab',
    'click #actualizarDetallesODT.btn'                  : 'actualizarDetallesODT',
    'click #FechaRealizacion'               : 'clickFechaRealizacion',
    'change #CompletadaEmpresa'             : 'toggleCompletadaEmpresa',
    'keyup #ComentariosSG'                 : 'toggleCompletadaEmpresa',
    'keyup'                               : 'checkEsc'
    },
    
    checkEsc: function(e) {
         if (e.keyCode  == 27) {
            $("#ventana-dialogo").hide();
         }
    },
    
    toggleCompletadaEmpresa: function() {
        this.$("#actualizarDetallesODT").val(this.$("#CompletadaEmpresa:checked").val() == "on" ? "Finalizar Orden de Trabajo" : "Cerrar y Guardar Orden de Trabajo");
        this.$("#actualizarDetallesODT").show();
    },
    
    clickFechaRealizacion: function() {
        $('.ui-datepicker-trigger').click();
    },
    
    actualizarDetallesODT : function(evt) {
        
        var m = this.model;
        
        var CompletadaEmpresa = this.$("#CompletadaEmpresa:checked").val() == "on";
        
        if(CompletadaEmpresa) {
            if(this.$('#FechaRealizacion').val() == "Cargar Fecha Realización") {
                alert("No se puede cerrar una Orden de Trabajo si no tiene una fecha de realización");
                return false;
            }
            
        }
        
        m.save({
                    FechaRealizacion: moment(this.$('#FechaRealizacion').val(), "DD.MMM.YYYY").format("YYYY-MM-DD"),
                    CompletadaEmpresa: CompletadaEmpresa,
                    ComentariosSG: this.$('[name=ComentariosSG]').val()
                }, { success: function(model, response) {
                    
                        if(CompletadaEmpresa) {
                            m.set("icon","completada");
                        }
                        
                        $("#ventana-dialogo").hide();
                        
                }});
            
    },
    
    
    
    cambiarTab: function(evt) { // si clickeo li dentro de tabs
         
        this.$("ul.tabs li").removeClass("active"); // remuevo activo (a todos)
        $(evt.currentTarget).addClass("active"); // al elemento clickeado le seteo active
        
        // seteo detallesSelectedTab, asi cuando renderizo la vista va hacia el ultimo tab seleccionado
        var tabIDX = $(evt.currentTarget).attr('id'); 
        
        this.$(".tab_content").hide(); // escondo todos los tabs

        var activeTab = $("a", evt.currentTarget).attr("href");
        this.$(activeTab).show();

        this.model.set("detallesSelectedTab",tabIDX, {silent: true});

        if(tabIDX == 4) {
            var _this = this;
            $('#FechaRealizacion').datepicker(
                { showOn: "button", 
                  dateFormat: "dd.M.yy",
                  onSelect: function() {
                                _this.$("#FechaRealizacion").val(moment(_this.$("#FechaRealizacion").val()).format("DD.MMM.YYYY"));
                                _this.$("#actualizarDetallesODT").show();
                        }      
                }
            ).next(".ui-datepicker-trigger").hide();
        }
        
        
        return false;
    },   
  

  
    
    removeEditing: function() {
        //$("li", this.$el).removeClass("materialesEdit");
        // ESTE RETURN LO COMENTE DEBIDO A QUE ESTE EVENTO SE DISPARA TAMBIEN CUANDO CLICKEO UN CHECKBOX (LOS QUE ESTAN EN "DETALLES")
        // Y ME BLOQUEA LOS CHECKBOXES.
        //return false;
    },

    
    comenzarTrabajo: function() {
    
        this.model.set("icon", "iniciado");
        this.model.save({iniciado: 1});  
        $("#ventana-dialogo").hide();
        
    },
    
    
  addMaterial: function(){
    
    var newMaterial = new Material();
    
    newMaterial.set("CodigoODT", this.model.get("codigoODT"));
    
    var listaMateriales = this.model.get("ListaMateriales");

    newMaterial.save({},{success: function(model, response) {
        listaMateriales.add(newMaterial);
        $("input[type=button]#addMaterial").hide();
    }});
    
  },
  
  
  addServicio: function(){
  
    // primero agrego en DB el servicio asociado a ODT, traigo el itemId, hago new Servicio, y asigno ItemID/CodigoODT y luego lo actualizo
    
    var listaServicios = this.model.get("ListaServicios");

    var newServicio = new ServicioRealizado();
    
    newServicio.set("CodigoODT",this.model.get("codigoODT"), {silent: true} );
    newServicio.set("codigoItem",systemConfig.serviciosComboData[0].id);
    
    // esto es para asignarle un ID, para que funcione el combobox, si no asigna 0, y no me carga servicios al combo

    $.ajax({
            type: "POST",
            url: "api/ser/update.asp",
            data: { model : JSON.stringify(newServicio) },
            dataType : "json",

            error: function(XMLHttpRequest, textStatus, errorThrown) {
              alert(errorThrown); 
            },

            success: function(datos) {
              
              
              if(datos.action == "n") {
                
                newServicio.set("ItemID",datos.ItemID);
                listaServicios.add(newServicio);
                $("input[type=button]#addServicio").hide();
              }

            },
            beforeSend: function(){

            }
    });      
    
    return false;
    
  },
  

  updateModel : function() {
    
    var modelo = this.model;
    
    $('.field').each(function(index,field) {
      modelo.set(field.name,field.value,{ silent: true });
    });
  
    if( modelo.get("codigoPlanta") < 0 ) {
        alert("Debe seleccionar una Planta");
        $("#codigoPlanta").focus();
        return;
    }

    if( modelo.get("codigoEdificio") < 0 ) {
        alert("Debe seleccionar un Edificio");
        $("#codigoEdificio").focus();
        return;
    }

    if( $.trim(modelo.get("UbicacionTarea")) == "" ) {
        alert("Debe indicar la ubicación donde se realizará el trabajo");
        $("#UbicacionTarea").focus();
        return;
    }

    if( modelo.get("MNdefinidor") < 0 ) {
        alert("Debe seleccionar un Definidor");
        $("#MNdefinidor").focus();
        return;
    }

//    if( $.trim(modelo.get("DescripcionODT")) == "" ) {
//        alert("Debe describir un trabajo a realizar");
//        $("#DescripcionODT").focus();
//        return;
//    }

//Pone el valor de la descripción en los comentarios


 if( modelo.get("codigoTipoTarea") == "31" && $.trim(modelo.get("DescripcionODT")) == "") {
        alert("Debe describir un detalle de la falla. Lo que observe y ayude a hacer un diagnóstico");
        return;
    }
	
 if( modelo.get("codigoTipoTarea") == "32"  && $.trim(modelo.get("DescripcionODT")) == "") {
        alert("Debe describir un detalle de la falla. Lo que observe y ayude a hacer un diagnóstico");
        return;
    }

 if( $.trim(modelo.get("DescripcionODT")) == "" ) {
//modelo.set("DescripcionODT", modelo.get("codigoTipoTarea"));
		alert("Debe describir un trabajo a realizar");
		$("#DescripcionODT").focus();
        return;
    }

// Fin Pone el valor de la descripción en los comentarios



    if( modelo.get("MNcontacto") < 0 ) {
        alert("Debe seleccionar un Contacto para el trabajo");
        $("#MNcontacto").focus();
        return;
    }

    if( modelo.get("codigoPrioridad") < 0 ) {
        alert("Debe seleccionar una Prioridad para el trabajo");
        $("#codigoPrioridad").focus();
        return;
    }
  
    modelo.save({},{ 
        success: function(model, response) {
        
              model.set("codigoODT", response);
              model.set("activo", 1);
              model.set("fechaMostrar", moment().format("HH:mm") + "hs");
              modelo.set("nombreSolicitante", NOMBRE_USUARIO_DEFAULT);
              modelo.set("MNSolicitante", USUARIO_DEFAULT);
              
              // creo la vista asociada al modelo y la inserto en la lista.
              var view = new OdtView({model: model});
              var v = $(view.render().el).hide();
              $("ul#listaOdt").prepend(v);
              
              v.slideDown(250, function(){
                v.css('background-color','#FFFFB9').animate({ backgroundColor: "#FFFFFF"}, 1500);
              });
              
              $("#ventana-dialogo").hide();
            }
        });
    },
  
  anularODT: function() {
    if(confirm("Está seguro que quiere anular la ODT Nro " + this.model.get("codigoODT") + "?")) {
        this.model.set("MNAnulacion", USUARIO_DEFAULT);
        this.model.set("nombreAnulacion", NOMBRE_USUARIO_DEFAULT);
        this.model.set("activo", 0);
        this.model.set("icon", "anulada");
        this.model.save();  
        $("#ventana-dialogo").hide();
    }
  },

  updateComboEdificio: function(){
    
      clearCombo('#codigoEdificio');
      clearCombo('#MNdefinidor');
      loadComboData($('#codigoEdificio'),'api/getEdificios.asp', $("#codigoPlanta").val(), "");
      $('#codigoEdificio').removeAttr('disabled');
      $('#codigoEdificio').css('opacity', 1);
      },
      
      updateComboDefinidor: function(){
      clearCombo('#MNdefinidor');
      
      loadComboData($('#MNdefinidor'),'api/getDefinidores.asp', $("#codigoEdificio").val(), "");
      $('#MNdefinidor').removeAttr('disabled');
      $('#MNdefinidor').css('opacity', 1);
  
  },
  
  
  cargarMateriales: function() {
    
    //this.$(".tab_content").hide(); // esconde todos tabs
    //this.$("ul.tabs li:first").addClass("active").show(); // set activo el primer boton
    //this.$(".tab_content:first").show(); // muestra 1er tab

    var _this = this.$("#listaMateriales");
    
    lm = this.model.get("ListaMateriales");
    
    lm.each(function(m){
      var view = new MaterialView({model: m});
      _this.append(view.render().el);
    });
    
    var _this = this.$("#listaServicios");
    
    ls = this.model.get("ListaServicios");
    
    ls.each(function(m){
      var view = new ServicioRealizadoView({model: m});
      _this.append(view.render().el);
    });
    
    
  },
  
  
  definirODT: function(){
    
    var model = this.model;
    var viewFull = new OdtDefinirView({model: model});
    $(".modal_dialog_body").html(viewFull.render().el);

    //$('#cuentaCombo').parent().hide();
    $('#cuentaCombo').attr('disabled', 'disabled');

    clearCombo('#aprobadoresCombo');
    loadComboData($('#aprobadoresCombo'),'api/getAprobadores.asp', model.get('codigoEdificio'), "");
    
    $(".modal_dialog_content").width("600px");

  }  

})






// -------------- LISTADO ODT (row) ----------------------------------

OdtView = Backbone.View.extend({
  
  tagName : 'li',
  
  className: 'odt-row',

  initialize : function() {
    
    this.model.bind('change', this.render, this);
  },

  render: function(){
    
    var variables = this.model.toJSON();
    var template = _.template($('#odt_template').html());
    $(this.el).html( template(variables) );

    return this;
  },

  events: {
    "click .row"  : "editODT"
  },

  editODT: function() {
  
    var model = this.model;

    var viewFull = new OdtFullView({model: model});
    var view = viewFull.render().el;

    // seteamos combos con los valores q recibimos

    $('#codigoPlanta', view).val(model.get('codigoPlanta'));

    loadComboData($('#codigoEdificio', view), 'api/getEdificios.asp', model.get('codigoPlanta'), model.get('codigoEdificio'));

    loadComboData($('#MNdefinidor', view), 'api/getDefinidores.asp', model.get('codigoEdificio'),  model.get('MNdefinidor'));

    $("#MNcontacto", view).val(model.get('MNcontacto'));
    $("#codigoPrioridad", view).val(model.get('codigoPrioridad'));

    $(".modal_dialog_content #modal_dialog_title").html("<span style='font-weight:normal;'>Orden de Trabajo</span><span> Nro " + model.get('codigoODT') + "</span>");
                  
    $(".modal_dialog_content").width("830px");

    //$("ul.tabs li", view).removeClass("active");
    
    $(".modal_dialog_body").html(view);
    
    
    
    $("#ventana-dialogo").show();
    
  }

})


