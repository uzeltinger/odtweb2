<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>ODT</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=100">



    <link rel="stylesheet" type="text/css" href="static/css/odt.css">
    <link href="static/css/extra_style.css" media="screen" rel="stylesheet" type="text/css">
    
    <link rel="stylesheet" type="text/css" href="static/css/tabs.css">  
    <link rel="stylesheet" type="text/css" href="static/css/materiales.css">  
    <link rel="stylesheet" type="text/css" href="static/css/facturas.css">  
    <link rel="stylesheet" type="text/css" href="static/css/ui-lightness/jquery-ui-1.8.24.custom.css">  


    <script src="static/js/libs/jquery-1.8.2.min.js"></script>
    <script src="static/js/libs/underscore.js"></script>
    <script src="static/js/libs/backbone.js"></script>
    <script src="static/js/libs/jquery-ui-1.8.24.custom.min.js"></script>
    <script src="static/js/libs/moment.min.js"></script>
    <script src="static/js/libs/color.js"></script>

    <script src="static/js/helper/odtHelper.js"></script>
    <script src="static/js/helper/util.js"></script>
    
    <script src="static/js/system/main.js"></script>
    <!-- Models -->
    <script src="static/js/modelAndView/odt.js"></script>
    <script src="static/js/modelAndView/material.js"></script>
    <script src="static/js/modelAndView/servicios.js"></script>
    <script src="static/js/modelAndView/facturas.js"></script>
    <script src="static/js/modelAndView/edificios.js"></script>
    <script src="static/js/modelAndView/planificar.js"></script>
    <script src="static/js/modelAndView/control_de_obra.js"></script>
    
    <script>
      var USUARIO_DEFAULT = '<%= USUARIO_DEFAULT %>';
      var NOMBRE_USUARIO_DEFAULT = '<%= obtenerNombre(USUARIO_DEFAULT) %>';
      var CGC_IMPORTE = <%= CGCobtenerImporte(now) %>;
      var CGC_CGC_1 = <%= CGCobtenerCGC1(now) %>;
      var CGC_CGC_2 = <%= CGCobtenerCGC2(now) %>;
      global = null;
    </script>
  </head>
