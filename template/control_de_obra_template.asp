<script language="javascript">

</script>

<script type="text/template" id="planilla_control_obra_template">
<div class="formularioEdicion">
  
  <div class="odtEdicionSubtitulo" style="height: 20px;"><div style="width: 200px;float: left;">Acciones</div><div style="float: right;">Si / No</div></div>
  
  <ul style="margin:0">

    <%
    sql = "select * from odtcontrolobraitems WHERE activo ORDER BY numero"

	Set RS = DbQuery(sql)

	while Not RS.EOF
		response.write "<li class='row' id='" & RS("numero") & "'>"
        response.write "<div class='texto'>" & RS("Nombre") & "</div>"
        response.write "<div style='float: right;'><input class='si' type='radio' name='p_" & RS("numero") & "' value='1'><input checked class='no' type='radio' name='p_" & RS("numero") & "' value='0'></div>"
        
        if RS("texto") then
            response.write "<textarea style='display:none' name='t_" & RS("numero") & "'></textarea>"
        end if
        
        response.write "</li>"


        RS.movenext
	wend

	RS.close
    %>

    <li id="botones" style="text-align:right; margin-top: 10px;">
      <input type="button" id="aceptarControlObra" value="Aceptar" class="btn" />
      <span style="margin: 2px;">ó</span>
      <a href="javascript:void(0)" onclick="$('#ventana-dialogo').hide()">Salir sin cambios</a>
    </li>

  </ul>

</div>
</script>