var app;
var myGlobal;

// este objeto es global, para guardar configuraciones del sistema que necesite acceder 
// desde cualquier parte del mismo.

var systemConfig = new Object();
systemConfig.name = "SG2.0 - v1.00";
systemConfig.serviciosComboData = null;
    
// END systemConfig

var primerOdtMostrada = 0;
var ultimaMostrada = 0;

var primerFacturaMostrada = 0;
var ultimaMostrada = 0;

var mySyncUpdateFunc = function(method, model, options) {

        if(method=='fetch') {
            options.url = model.url + '?id=' + model.id; 
        } else if(method=='delete') {
            options.url = model.url + '?id=' + model.id; 
        } else {
            options.url = model.url; 
        }
        return Backbone.sync(method, model, options);
}

	
$(function() {

    moment.monthsShort = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"];
    moment.weekdaysShort = ["Dom", "Lun", "Mar", "Mie", "Jue", "Vie", "Sab"]
	moment.monthsShort = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"];
	moment.relativeTime = {
		future: "en %s",
		past: "hace %s",
		s: "segundos",
		m: "1 minuto",
		mm: "%d minutos",
		h: "1 hora",
		hh: "%d horas",
		d: "1 dia",
		dd: "%d dias",
		M: "1 mes",
		MM: "%d meses",
		y: "1 año",
		yy: "%d años"
	};
  
	$.ajaxSetup ({ cache: false });
	
	Backbone.emulateHTTP = true;
	Backbone.emulateJSON = true;
    
	$.fn.activarBoton = function() {
		this.css("opacity", "1");
		this.attr("disabled", "disabled");
	};
	
	$.fn.desactivarBoton = function() {
		this.css("opacity", ".7");
		this.removeAttr("disabled");
	};

	_.templateSettings = {
		 evaluate : /\{\[([\s\S]+?)\]\}/g,
		 interpolate : /\{\{([\s\S]+?)\}\}/g
	}; // Esto cambia la configuracion del token del template para q me tome {{ }}

	
	// Obtengo configuraciones, datos o demas cosas q voy a utilizar seguramente despues (y guardo en systemConfig)
//	 getServiciosDataCombo();
	
	
    var AppView = Backbone.View.extend({
        
        el: $("#odtApp"),
      
        events: {
            'click input[type=button]#nuevaOrden' : 'nuevaOrden',
            'click input[type=button]#nuevaFactura' : 'nuevaFactura',
            'click a#aDefinir': 'cargarListaDefinir',
            'click a#aAuditar': 'cargarListaAuditar',
            'click a#planificar': 'cargarListaPlanificar',
            'click a#solicitadas': 'cargarListaSolicitadas',
            'click a#pendientes': 'cargarListaPendientes',
            'keypress #input-search' : 'buscarOdts',
            'click input.lupa-search' : 'buscarOdts',
            'click a#facturas' : 'cargarFacturas',
            'click a#todas': 'cargarListaTodas',
            'click a#edificios' : 'cargarEdificios',
            'click a#administrar' : 'cargarAdministrar',
            'click a#servicios' : 'cargarServicios',
            'click a#coeficiente' : 'cargarCoeficiente',
            'click input[type=button]#nuevoEdificio' : 'nuevoEdificio',
            'click input[type=button]#nuevoListado' : 'nuevoListadoVigencia',
            'click input[type=button]#nuevoServicio' : 'nuevoServicio'

        },
        setFechaPlanificacion: function(codigoODT){ 
            console.log("get","/odtweb/api/planificar/setFechaPlanificacion.asp?codigoODT=" + codigoODT);
            $.get("/odtweb/api/planificar/setFechaPlanificacion.asp?codigoODT=" + codigoODT, function(fecha, response) {
                return fecha;
            }).done(function() {
                
            });
        },        

        updateCounters: function() {
            
            var _this = this;
            $.get("/odtweb/api/odt/count.asp", function(data) {
            
                var t = parseInt(_this.$("a#todas span").text());
                var ad = parseInt(_this.$("a#aDefinir span").text());
                var aa = parseInt(_this.$("a#aAuditar span").text());
                
                if(data.total != t) {
                    _this.$("a#todas span").text(data.total);
                        _this.$("a#todas span").addClass("alerta");
                }
                
                if(data.aDefinir != ad) {
                    _this.$("a#aDefinir span").text(data.aDefinir);
                        _this.$("a#aDefinir span").addClass("alerta");
                }
                
                if(data.aAuditar != aa) {
                    _this.$("a#aAuditar span").text(data.aAuditar);
                        _this.$("a#aAuditar span").addClass("alerta");
                }
                
            });
           
        },
        
        
        initialize: function() {
        
            this.updateCounters();
            
            this.cargarListaTodas();

        }, // INITIALIZE

        cargarAdministrar: function() {
        
            $("input[type=button]#nuevaOrden").hide();
            $("input[type=button]#nuevaFactura").hide();	
            $("input[type=button].adminBtn").hide();
            
            $("#menu-filtros a").removeClass("current");
            $("a#administrar").addClass("current");

            var template = _.template($('#admin_template').html());
            $("#listaOdt").empty();
            $("#listaOdt").html( template() );
        
        },
        
        cargarEdificios: function() {
        
            $("input[type=button].adminBtn").hide();
            $("input[type=button]#nuevaOrden").hide();
            $("input[type=button]#nuevaFactura").hide();
            $("input[type=button]#nuevoEdificio").show();
            
            $("a#administrar").attr("admin", "edificio");

            $("#listaOdt").empty();
            ultimaMostrada = 0;
            this.agregarALista();    
        
        },
        
        nuevoListadoVigencia: function() {
            
            $(".modal_dialog_content #modal_dialog_title").html("<span style='font-weight:normal;'>Nuevo </span><span>Contrato</span>");
                          
            $(".modal_dialog_content").width("400px");
            
            var view = _.template($('#nuevoListadoVigenciaTemplate').html());
            
            $(".modal_dialog_body").html(view);
            
            $('#FechaVigencia').datepicker({dateFormat: 'dd/mm/yy'});
            var _this = this;
            
            $('#aceptarNuevoListado').click(function() {
            
                $.post('api/servicio/nuevoListado.asp', 
                       { FechaVigencia: $('#FechaVigencia').val(), version: $('#NumeroContrato').val() },
                       function() {
                           $('#ventana-dialogo').hide();        
                           $("#listaOdt").empty();
                           ultimaMostrada = 0;
                           _this.agregarALista();
                       }
                );
            });
            
            
            $("#ventana-dialogo").show();
        
        },



        cargarCoeficiente: function() {
            
            $(".modal_dialog_content #modal_dialog_title").html("<span style='font-weight:normal;'>Nuevo </span><span>Coeficiente</span>");
                          
            $(".modal_dialog_content").width("530px");
            
            var view = _.template($('#nuevoCoeficienteTemplate').html());
            
            $(".modal_dialog_body").html(view);
            
            $('#FechaValidez').datepicker({dateFormat: 'dd/mm/yy'});
            $('#aceptarNuevoCoeficiente').click(function() {
                
                if($('#FechaValidez').val() == "") {
                    alert("Debe ingresar una fecha válida");
                    return false;
                }
                
                $.ajax({
                    url: 'api/servicio/nuevoCoeficiente.asp',
                    type: 'GET',
                    data: { FechaValidez: $('#FechaValidez').val(), 
                            importeHasta: $('#hasta').val(), 
                            CGC1: $('#CGC1').val(), CGC2: $('#CGC2').val() },
                    success: function() {
                        $('#ventana-dialogo').hide();    
                        location = "/odtweb"
                    }
                });
                
            })
            
            
            $("#ventana-dialogo").show();
        
        },



        
        nuevoEdificio: function() {

            var newEdificio = new Edificio({codigoEdificio : 0});
        
            var viewFull = new EdificioEditarView({model: newEdificio});
            var view = viewFull.render().el;
            
            $(".modal_dialog_content #modal_dialog_title").html("<span style='font-weight:normal;'>Nuevo </span><span>Edificio</span>");
                          
            $(".modal_dialog_content").width("530px");
            
            $(".modal_dialog_body").html(view);
            $("#ventana-dialogo").show();
        },
        
        
        cargarServicios: function() {

            $("input[type=button]#nuevaOrden").hide();
            $("input[type=button]#nuevaFactura").hide();
            $("input[type=button].adminBtn").hide();
            $("input[type=button]#nuevoServicio").show();
            $("input[type=button]#nuevoListado").show();
            
            $("a#administrar").attr("admin", "servicio");
            
            $("#listaOdt").empty();
            ultimaMostrada = 0;
            this.agregarALista();    
        },
        
        nuevoServicio: function() {
        
            var model = new Servicio();
            var viewFull = new ServicioEditarView({model: model});
            var view = viewFull.render().el;
            
            $(".modal_dialog_content #modal_dialog_title").html("<span style='font-weight:normal;'>Nuevo </span><span>Servicio</span>");
            $(".modal_dialog_content").width("530px");
            $(".modal_dialog_body").html(view);
            $("#ventana-dialogo").show();
        },
        
        cargarFacturas: function() {
        
            $("input[type=button]#nuevaOrden").hide();
            $("input[type=button].adminBtn").hide();
            $("input[type=button]#nuevaFactura").show();	

            $("#menu-filtros a").removeClass("current");
            $("a#facturas").addClass("current");
            $("#input-search").val("");

            $("#listaOdt").empty();
            ultimaMostrada = 0;
            this.agregarALista();    
        
        },
        
        
        agregarALista: function() {
        
            // si ya mostré la última que podia traer, no muestro mas.
            if(ultimaMostrada == -1) {
                return;
            }
        
            var vista = ($("a#todas").hasClass("current") ? "odt/getTodas" : 
                ($("a#solicitadas").hasClass("current") ? "odt/getSolicitadas" :
                    ($("a#pendientes").hasClass("current") ? "odt/getPendientes" :                
                        ($("a#facturas").hasClass("current") ? "fac/getFacturas" :       
                            ($("a#administrar").hasClass("current") ? $("a#administrar").attr("admin") + "/list" :       
                                ($("a#aDefinir").hasClass("current") ? "odt/getADefinir" : 
                                    ($("a#aAuditar").hasClass("current") ? "odt/getAAuditar" : "")
                                    )
                                )
                            )	
                        )
                     )
            );

            cargandoContenido = true;
            
            $("#spinner").show();
      
            var url = "/odtweb/api/" + vista + ".asp?ultima=" + ultimaMostrada;
            
            if( $("#input-search").val() ) {
                url += "&buscar=" + $("#input-search").val();
            }
            
            var _app = this;

            $.get(url, function(estaLista, response) {
                $("#spinner").hide();
                
                if( !$.isEmptyObject(estaLista) ) { 
                    
                    if (vista == "servicio/list") {
                        _app.objectosALista(estaLista, Servicio, ServicioView);
                        ultimaMostrada = -1;
                    } else {
                        if (vista == "edificio/list") {
                            _app.objectosALista(estaLista, Edificio, EdificioView);
                            ultimaMostrada = -1;
                        } else {
                            if (vista == "fac/getFacturas") {
                                _app.objectosALista(estaLista, Factura, FacturaView);
                            } else {
                                _app.objectosALista(estaLista, Odt, OdtView);
                            }
                        }
                    }
                    
                } else {
                    if( $("#input-search").val() ) {
                        var texto_li  = "";
                        texto_li = "No se encontraron coincidencias con el criterio de búsqueda";
                    } else {
                        texto_li = "No hay mas contenido para mostrar";
                    }
                    
                    $("#listaOdt").append("<li style='text-align: center;'>" + texto_li + "</li>");
                    
                    ultimaMostrada = -1;
                }
                cargandoContenido = false;
            });

        },

            
        cargarLista: function() {
        
            $("#listaOdt").empty();
            ultimaMostrada = 0;
            this.agregarALista();
        },

        buscarOdts: function(e) {
            
            if(cargandoContenido) return false; 
            if(e.which == 13 || e.type == "click") {
                this.cargarLista();
            }
        },

        
        nuevaFactura: function() {
         
           var blankFactura = new Factura({"codigoFactura": "0", "mnCreacion": USUARIO_DEFAULT});

			var blankFacturaViewFull = new FacturaEditarView({model: blankFactura, cargarFacturasODT: false});
            var view = blankFacturaViewFull.render().el;
            
            $('#FechaFactura', view).datepicker({
                dateFormat: 'dd-mm-yy'
            });    
            
            $(".modal_dialog_body").html(view);   
            $(".modal_dialog_content").width("650px");
            $("#ventana-dialogo").show();
            
        },

         
        nuevaOrden: function() {
        
            var blankODT = new Odt({"codigoODT": 0});

            var blankODTViewFull = new OdtFullView({model:blankODT});
            $(".modal_dialog_body").html(blankODTViewFull.render().el);

            //clearCombo('#codigoPlanta');
            //loadComboData($('#codigoPlanta'), 'api/getPlantas.asp', '', '');

            $('#codigoEdificio').attr('disabled', 'disabled');
            clearCombo('#codigoEdificio');
            loadComboData($('#codigoEdificio'),'api/getEdificios.asp', '');

            $('#MNdefinidor').attr('disabled', 'disabled');
            clearCombo('#MNdefinidor');
            loadComboData($('#MNdefinidor'),'api/getDefinidores.asp', '',  '');

            $(".modal_dialog_content #modal_dialog_title").html("<span>Nueva </span><span style='font-weight:normal;'>Orden de Trabajo</span>");
            
            $("#ventana-dialogo").show();
        },
        
        cargarListaSolicitadas: function() {
            
            $("input[type=button].adminBtn").hide();
            
            $("input[type=button]#nuevaOrden").show();
            $("input[type=button]#nuevaFactura").hide();	
        
            $("#menu-filtros a").removeClass("current");
            $("a#solicitadas").addClass("current");
            $("#input-search").val("");
            
            this.cargarLista();
            
        },
        
        cargarListaPendientes: function() {
            
            $("input[type=button].adminBtn").hide();
            
            $("input[type=button]#nuevaOrden").show();
            $("input[type=button]#nuevaFactura").hide();	
        
            $("#menu-filtros a").removeClass("current");
            $("a#pendientes").addClass("current");
            $("#input-search").val("");
            
            this.cargarLista();
            
        },

        cargarListaDefinir: function() {

            $("input[type=button].adminBtn").hide();
        
            $("input[type=button]#nuevaOrden").show();
            $("input[type=button]#nuevaFactura").hide();	
            
            $("#menu-filtros a").removeClass("current");
            $("a#aDefinir").addClass("current");
            $("#input-search").val("");
            
            $("a#aDefinir span").removeClass("alerta");
            
            this.cargarLista();
        },
        
        cargarListaAuditar: function() {

            $("input[type=button].adminBtn").hide();
        
            $("input[type=button]#nuevaOrden").show();
            $("input[type=button]#nuevaFactura").hide();	
            
            $("#menu-filtros a").removeClass("current");
            $("a#aAuditar").addClass("current");
            $("#input-search").val("");
            
            $("a#aAuditar span").removeClass("alerta");
            
            this.cargarLista();
        },
        
        cargarListaPlanificar: function() {
            $("input[type=button].adminBtn").hide();
            $("input[type=button]#nuevaOrden").hide();
            $("input[type=button]#nuevaFactura").hide();	
            
            $("#menu-filtros a").removeClass("current");
            $("a#planificar").addClass("current");
            
            $("#listaOdt").empty();
             
            ultimaMostrada = -1;             
             
            var pl = new PlanificarView();
            $("#listaOdt").append(pl.render().el);
            
            pl.cargarLista();
            
        },
        
        cargarListaTodas: function() {
            $("input[type=button].adminBtn").hide();
        
            $("input[type=button]#nuevaOrden").show();
            $("input[type=button]#nuevaFactura").hide();	
        
            $("#menu-filtros a").removeClass("current");
            $("a#todas").addClass("current");
            $("#input-search").val("");
            
            $("a#todas span").removeClass("alerta");

            this.cargarLista();			
        },
        
        objectosALista: function(lista, modelo, vista) {
    
            if($.isFunction(lista.toJSON)){
                lista = lista.toJSON();
            };

            $(lista).each( function(idx, odt_json) {
                
                var odt = new modelo(odt_json);
                
                var view = new vista({model: odt});
                
                $("#listaOdt").append(view.render().el);
                
                var numero = odt.id; //get("codigoODT")
                
                ultimaMostrada = numero;
                
                if (numero > primerOdtMostrada) {
                    primerOdtMostrada = numero;
                }
            });
        },
  
        checkNuevasOdt: function() {
            primerFacturaMostrada
        }
    
    });

    app = new AppView();

    var cargandoContenido = false;

    $("#scrollable").scroll(function() {
        if ( ($("#scrollable").scrollTop() + $("#scrollable").height() > $("ul#listaOdt").height()  ) 
                && !cargandoContenido ) {
                
                app.agregarALista();
        }
    }); 
    
    
    getServiciosDataCombo(function() {

        $('body').fadeIn(500);

    })    
    
    setInterval(function() {
        
        app.updateCounters();
        
    }, 60000);

});
  

  
    
  


