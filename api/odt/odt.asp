<%
Class Odt
'  Public icon
'  Public codigoODT
'  Public Prioridad
'  Public FechaHoraSolicitud
'  Public MNSolicitante
'  Public CostCenter
'  Public Cuenta
'  Public ComentariosSG


  Public Sub get()

    sql = "SELECT codigoODT, op.Prioridad, FechaHoraSolicitud, MNSolicitante, CostCenter, Cuenta, ComentariosSG "
    sql = sql & "FROM odts "
    sql = sql & "INNER JOIN sistemacostcenterusuario sccu ON sccu.MN = odts.MNAprobador "
    sql = sql & "INNER JOIN odtprioridades op ON op.codigoPrioridad = odts.codigoPrioridad "

    sql = sql & "LIMIT 20"

    QueryToJSON(conexion, sql).Flush

  End Sub

  Public Function ObtenerRegitros(intID)
  End Function
End Class
%>