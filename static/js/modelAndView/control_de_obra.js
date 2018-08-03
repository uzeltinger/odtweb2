// -------------------- VIEW -------------------------

ControlDeObraView = Backbone.View.extend({
  
  tagName : 'div',
  
  className: 'control-obra-view',

  
  initialize : function() {
    //this.render();
    //this.model.bind('change', this.render, this);    
    
  },

  render: function(){
    
    var template = _.template($('#planilla_control_obra_template').html());
    $(this.el).html( template() );

    return this;
  },

  events: {
  'click li.row'                    : 'clickRow',
  'click li.row textarea'           : 'clickTextarea',
  'click input#aceptarControlObra'  : 'clickAceptar'
  }  ,
  
  clickRow: function(e) {
    $(e.currentTarget).toggleClass("si");
    if($(e.currentTarget).hasClass("si")) {
        $("input.si",e.currentTarget).attr("checked", "checked");
        if($("textarea",e.currentTarget).length > 0) {
            $(e.currentTarget).height("62px");
            $("textarea",e.currentTarget).show();
            $("textarea",e.currentTarget).focus();
        }
    }
    else {
        $("input.no",e.currentTarget).attr("checked", "checked");
        $("textarea",e.currentTarget).hide();
        $(e.currentTarget).height("20px");
    }
  },

  clickTextarea: function() {
    return false;
  },
  
  clickAceptar: function() {
    var res = '[';
    var coma = '';
    $("li.row.si").each(function(i, obj) {
        res += coma + '{';
        res += '"id":' + $(obj).attr("id") + ',"texto":';
        if($("textarea", obj).length > 0) {
            if($("textarea", obj).val() == "") {
				alert("Debe completar todos los campos donde se pide una especificación.");
				$("textarea", obj).focus();
				return false;
			} else {
				res += '1,"obs":' + JSON.stringify($("textarea", obj).val());
			}
			
        } else {
            res += '0';
        }
        res += '}'; 
        coma = ',';
    });
    res += ']';
    
    $.post("/odtweb/api/control/update.asp", {odt: this.model.get("codigoODT"), data: res}, function() {
        $("#ventana-dialogo").hide();
    });
  },
  
  cargarPlanilla: function() {
  
    $.get("/odtweb/api/control/?odt=" + this.model.get("codigoODT"), function(res){
        
        $(eval(res)).each(function(i,obj) {
             $("li#" + obj.itemId).show();
             if(obj.texto != null) {
                $("li#" + obj.itemId + " textarea").val(obj.texto);
             }
             $("li#" + obj.itemId + " input.si").click();
        });
        
        
        
    });
    
  }
  
});



 
