<%
Class Informe


  Public Sub getInformes(fromCodigoInforme, search)

    response.Charset = "utf-8" 
    response.ContentType = "application/json"

    if fromCodigoInforme = 0 then 
      where = "true" 
    else 
      where = "codigoInforme < "& fromCodigoInforme
    end if

    sql = "SELECT * FROM odtinformes inf "
    sql = sql & "WHERE " & where
    sql = sql & " ORDER BY inf.codigoInforme DESC "
    sql = sql & "LIMIT " & CANT_POR_PAGINA

    QueryToJSON(conexion, sql).Flush
  
    'devolver informes    
  end Sub



  Public Sub getInforme(codigoInforme) 
  
    response.Charset = "utf-8" 
    response.ContentType = "application/json"
    
    sql = "SELECT * FROM odtinformes WHERE codigoInforme = "& codigoInforme 

    QueryToJSON(conexion, sql).Flush
  
  End Sub  

  Public Sub update(jsonData)   
  response.write( jsonData ) 
    dim facData : Set facData = JSON.parse(jsonData)
    localLogAdd(jsonData)
    codigoInforme = Clng(facData.codigoInforme)    
    action = "u"    
    response.Charset = "utf-8" 
    response.ContentType = "application/json"    

    if codigoInforme = 0 then      
      set RS = DbOpen("odtinformes")
        RS.Addnew
        RS.Update
      RS.close
      lastID = lastInsertId()      
      action = "n"      
      codigoInforme = lastID      
    end if

    set RS = DbOpen("SELECT * FROM odtinformes WHERE codigoInforme="& codigoInforme)
      RS("numeroInforme") = facData.numeroInforme
      RS("nombreInforme") = facData.nombreInforme      
      f = split(facData.desdeInforme, "-")
      RS("desdeInforme") = f(2) & "-" & f(1) & "-" & f(0)
      f = split(facData.hastaInforme, "-")
      RS("hastaInforme") = f(2) & "-" & f(1) & "-" & f(0)
      RS("mnCreacion") = facData.mnCreacion
      RS.Update 
    RS.Close  

    sql = "DELETE  FROM odtinformecolumna WHERE idInforme = " & codigoInforme
    Set RS = DbQuery(sql)

    sa = ""
    sa = sa & "INSERT INTO odtinformecolumna (idInfoCol, idInforme, idColumna, nombreColumna, colMostrar, colNombre, colFiltrar, colFiltro) VALUES "
    sa = sa & "(null, "&codigoInforme&", ""codigoODT"", ""codigoODT"", " 
    sa = sa & facData.colMostrar_codigoODT & ", """ & facData.colNombre_codigoODT & """, " & facData.colFiltrar_codigoODT & ", """ & facData.colFiltro_codigoODT & """),"
    sa = sa & "(null, "&codigoInforme&", ""codigoPlanta"", ""codigoPlanta"", " 
    sa = sa & facData.colMostrar_codigoPlanta & ", """ & facData.colNombre_codigoPlanta & """, " & facData.colFiltrar_codigoPlanta & ", """ & facData.colFiltro_codigoPlanta & """),"    
    sa = sa & "(null, "&codigoInforme&", ""codigoPrioridad"", ""codigoPrioridad"", " 
    sa = sa & facData.colMostrar_codigoPrioridad & ", """ & facData.colNombre_codigoPrioridad & """, " & facData.colFiltrar_codigoPrioridad & ", """ & facData.colFiltro_codigoPrioridad & """),"
    sa = sa & "(null, "&codigoInforme&", ""codigoEdificio"", ""codigoEdificio"", " 
    sa = sa & facData.colMostrar_codigoEdificio & ", """ & facData.colNombre_codigoEdificio & """, " & facData.colFiltrar_codigoEdificio & ", """ & facData.colFiltro_codigoEdificio & """),"
    sa = sa & "(null, "&codigoInforme&", ""FechaHoraSolicitud"", ""FechaHoraSolicitud"", " 
    sa = sa & facData.colMostrar_FechaHoraSolicitud & ", """ & facData.colNombre_FechaHoraSolicitud & """, " & facData.colFiltrar_FechaHoraSolicitud & ", """ & facData.colFiltro_FechaHoraSolicitud & """)," 
    sa = sa & "(null, "&codigoInforme&", ""MNSolicitante"", ""MNSolicitante"", " 
    sa = sa & facData.colMostrar_MNSolicitante & ", """ & facData.colNombre_MNSolicitante & """, " & facData.colFiltrar_MNSolicitante & ", """ & facData.colFiltro_MNSolicitante & """),"
    sa = sa & "(null, "&codigoInforme&", ""MNAprobador"", ""MNAprobador"", " 
    sa = sa & facData.colMostrar_MNAprobador & ", """ & facData.colNombre_MNAprobador & """, " & facData.colFiltrar_MNAprobador & ", """ & facData.colFiltro_MNAprobador & """),"
    sa = sa & "(null, "&codigoInforme&", ""MNcontacto"", ""MNcontacto"", " 
    sa = sa & facData.colMostrar_MNcontacto & ", """ & facData.colNombre_MNcontacto & """, " & facData.colFiltrar_MNcontacto & ", """ & facData.colFiltro_MNcontacto & """),"
    sa = sa & "(null, "&codigoInforme&", ""Cuenta"", ""Cuenta"", " 
    sa = sa & facData.colMostrar_Cuenta & ", """ & facData.colNombre_Cuenta & """, " & facData.colFiltrar_Cuenta & ", """ & facData.colFiltro_Cuenta & """),"
    sa = sa & "(null, "&codigoInforme&", ""codigoCuenta"", ""codigoCuenta"", " 
    sa = sa & facData.colMostrar_codigoCuenta & ", """ & facData.colNombre_codigoCuenta & """, " & facData.colFiltrar_codigoCuenta & ", """ & facData.colFiltro_codigoCuenta & """),"
    sa = sa & "(null, "&codigoInforme&", ""codigoTipoTarea"", ""codigoTipoTarea"", " 
    sa = sa & facData.colMostrar_codigoTipoTarea & ", """ & facData.colNombre_codigoTipoTarea & """, " & facData.colFiltrar_codigoTipoTarea & ", """ & facData.colFiltro_codigoTipoTarea & """),"
    sa = sa & "(null, "&codigoInforme&", ""DescripcionODT"", ""DescripcionODT"", " 
    sa = sa & facData.colMostrar_DescripcionODT & ", """ & facData.colNombre_DescripcionODT & """, " & facData.colFiltrar_DescripcionODT & ", """ & facData.colFiltro_DescripcionODT & """),"
    sa = sa & "(null, "&codigoInforme&", ""UbicacionTarea"", ""UbicacionTarea"", " 
    sa = sa & facData.colMostrar_UbicacionTarea & ", """ & facData.colNombre_UbicacionTarea & """, " & facData.colFiltrar_UbicacionTarea & ", """ & facData.colFiltro_UbicacionTarea & """),"
    sa = sa & "(null, "&codigoInforme&", ""FechaRealizacion"", ""FechaRealizacion"", " 
    sa = sa & facData.colMostrar_FechaRealizacion & ", """ & facData.colNombre_FechaRealizacion & """, " & facData.colFiltrar_FechaRealizacion & ", """ & facData.colFiltro_FechaRealizacion & """),"
    sa = sa & "(null, "&codigoInforme&", ""FechaPlanificacion"", ""FechaPlanificacion"", " 
    sa = sa & facData.colMostrar_FechaPlanificacion & ", """ & facData.colNombre_FechaPlanificacion & """, " & facData.colFiltrar_FechaPlanificacion & ", """ & facData.colFiltro_FechaPlanificacion & """),"
    sa = sa & "(null, "&codigoInforme&", ""CompletadaEmpresa"", ""CompletadaEmpresa"", " 
    sa = sa & facData.colMostrar_CompletadaEmpresa & ", """ & facData.colNombre_CompletadaEmpresa & """, " & facData.colFiltrar_CompletadaEmpresa & ", """ & facData.colFiltro_CompletadaEmpresa & """),"
    sa = sa & "(null, "&codigoInforme&", ""Aprobado"", ""Aprobado"", " 
    sa = sa & facData.colMostrar_Aprobado & ", """ & facData.colNombre_Aprobado & """, " & facData.colFiltrar_Aprobado & ", """ & facData.colFiltro_Aprobado & """),"
    sa = sa & "(null, "&codigoInforme&", ""ComentariosSG"", ""ComentariosSG"", " 
    sa = sa & facData.colMostrar_ComentariosSG & ", """ & facData.colNombre_ComentariosSG & """, " & facData.colFiltrar_ComentariosSG & ", """ & facData.colFiltro_ComentariosSG & """),"
    sa = sa & "(null, "&codigoInforme&", ""FacturaNro"", ""FacturaNro"", " 
    sa = sa & facData.colMostrar_FacturaNro & ", """ & facData.colNombre_FacturaNro & """, " & facData.colFiltrar_FacturaNro & ", """ & facData.colFiltro_FacturaNro & """),"
    sa = sa & "(null, "&codigoInforme&", ""ParaFacturar"", ""ParaFacturar"", " 
    sa = sa & facData.colMostrar_ParaFacturar & ", """ & facData.colNombre_ParaFacturar & """, " & facData.colFiltrar_ParaFacturar & ", """ & facData.colFiltro_ParaFacturar & """),"
    sa = sa & "(null, "&codigoInforme&", ""codigoFactura"", ""codigoFactura"", " 
    sa = sa & facData.colMostrar_codigoFactura & ", """ & facData.colNombre_codigoFactura & """, " & facData.colFiltrar_codigoFactura & ", """ & facData.colFiltro_codigoFactura & """),"
    sa = sa & "(null, "&codigoInforme&", ""ParaRevisar"", ""ParaRevisar"", " 
    sa = sa & facData.colMostrar_ParaRevisar & ", """ & facData.colNombre_ParaRevisar & """, " & facData.colFiltrar_ParaRevisar & ", """ & facData.colFiltro_ParaRevisar & """),"
    sa = sa & "(null, "&codigoInforme&", ""MNdefinidor"", ""MNdefinidor"", " 
    sa = sa & facData.colMostrar_MNdefinidor & ", """ & facData.colNombre_MNdefinidor & """, " & facData.colFiltrar_MNdefinidor & ", """ & facData.colFiltro_MNdefinidor & """),"
    sa = sa & "(null, "&codigoInforme&", ""fechaDefinicion"", ""fechaDefinicion"", " 
    sa = sa & facData.colMostrar_fechaDefinicion & ", """ & facData.colNombre_fechaDefinicion & """, " & facData.colFiltrar_fechaDefinicion & ", """ & facData.colFiltro_fechaDefinicion & """),"
    sa = sa & "(null, "&codigoInforme&", ""definido"", ""definido"", " 
    sa = sa & facData.colMostrar_definido & ", """ & facData.colNombre_definido & """, " & facData.colFiltrar_definido & ", """ & facData.colFiltro_definido & """),"
    sa = sa & "(null, "&codigoInforme&", ""presupuestar"", ""presupuestar"", " 
    sa = sa & facData.colMostrar_presupuestar & ", """ & facData.colNombre_presupuestar & """, " & facData.colFiltrar_presupuestar & ", """ & facData.colFiltro_presupuestar & """),"
    sa = sa & "(null, "&codigoInforme&", ""MNAnulacion"", ""MNAnulacion"", " 
    sa = sa & facData.colMostrar_MNAnulacion & ", """ & facData.colNombre_MNAnulacion & """, " & facData.colFiltrar_MNAnulacion & ", """ & facData.colFiltro_MNAnulacion & """),"
    sa = sa & "(null, "&codigoInforme&", ""fechaAnulacion"", ""fechaAnulacion"", " 
    sa = sa & facData.colMostrar_fechaAnulacion & ", """ & facData.colNombre_fechaAnulacion & """, " & facData.colFiltrar_fechaAnulacion & ", """ & facData.colFiltro_fechaAnulacion & """),"
    sa = sa & "(null, "&codigoInforme&", ""mnCreacion"", ""mnCreacion"", " 
    sa = sa & facData.colMostrar_mnCreacion & ", """ & facData.colNombre_mnCreacion & """, " & facData.colFiltrar_mnCreacion & ", """ & facData.colFiltro_mnCreacion & """),"
    sa = sa & "(null, "&codigoInforme&", ""fechaCreacion"", ""fechaCreacion"", " 
    sa = sa & facData.colMostrar_fechaCreacion & ", """ & facData.colNombre_fechaCreacion & """, " & facData.colFiltrar_fechaCreacion & ", """ & facData.colFiltro_fechaCreacion & """),"
    sa = sa & "(null, "&codigoInforme&", ""fechaModificacion"", ""fechaModificacion"", " 
    sa = sa & facData.colMostrar_fechaModificacion & ", """ & facData.colNombre_fechaModificacion & """, " & facData.colFiltrar_fechaModificacion & ", """ & facData.colFiltro_fechaModificacion & """),"
    sa = sa & "(null, "&codigoInforme&", ""fechaCompletada"", ""fechaCompletada"", " 
    sa = sa & facData.colMostrar_fechaCompletada & ", """ & facData.colNombre_fechaCompletada & """, " & facData.colFiltrar_fechaCompletada & ", """ & facData.colFiltro_fechaCompletada & """),"
    sa = sa & "(null, "&codigoInforme&", ""mnModificacion"", ""mnModificacion"", " 
    sa = sa & facData.colMostrar_mnModificacion & ", """ & facData.colNombre_mnModificacion & """, " & facData.colFiltrar_mnModificacion & ", """ & facData.colFiltro_mnModificacion & """),"
    sa = sa & "(null, "&codigoInforme&", ""iniciado"", ""iniciado"", " 
    sa = sa & facData.colMostrar_iniciado & ", """ & facData.colNombre_iniciado & """, " & facData.colFiltrar_iniciado & ", """ & facData.colFiltro_iniciado & """),"
    sa = sa & "(null, "&codigoInforme&", ""auditado"", ""auditado"", " 
    sa = sa & facData.colMostrar_auditado & ", """ & facData.colNombre_auditado & """, " & facData.colFiltrar_auditado & ", """ & facData.colFiltro_auditado & """),"
    sa = sa & "(null, "&codigoInforme&", ""terminadaFisicamente"", ""terminadaFisicamente"", " 
    sa = sa & facData.colMostrar_terminadaFisicamente & ", """ & facData.colNombre_terminadaFisicamente & """, " & facData.colFiltrar_terminadaFisicamente & ", """ & facData.colFiltro_terminadaFisicamente & """),"
    sa = sa & "(null, "&codigoInforme&", ""estado"", ""estado"", " 
    sa = sa & facData.colMostrar_estado & ", """ & facData.colNombre_estado & """, " & facData.colFiltrar_estado & ", """ & facData.colFiltro_estado & """),"
    sa = sa & "(null, "&codigoInforme&", ""activo"", ""activo"", " 
    sa = sa & facData.colMostrar_activo & ", """ & facData.colNombre_activo & """, " & facData.colFiltrar_activo & ", """ & facData.colFiltro_activo & """),"
    sa = sa & "(null, "&codigoInforme&", ""clasificacion"", ""clasificacion"", " 
    sa = sa & facData.colMostrar_clasificacion & ", """ & facData.colNombre_clasificacion & """, " & facData.colFiltrar_clasificacion & ", """ & facData.colFiltro_clasificacion & """),"
    sa = sa & "(null, "&codigoInforme&", ""revisada"", ""revisada"", " 
    sa = sa & facData.colMostrar_revisada & ", """ & facData.colNombre_revisada & """, " & facData.colFiltrar_revisada & ", """ & facData.colFiltro_revisada & """),"
    sa = sa & "(null, "&codigoInforme&", ""revisada_por"", ""revisada_por"", " 
    sa = sa & facData.colMostrar_revisada_por & ", """ & facData.colNombre_revisada_por & """, " & facData.colFiltrar_revisada_por & ", """ & facData.colFiltro_revisada_por & """),"
    sa = sa & "(null, "&codigoInforme&", ""electrica"", ""electrica"", " 
    sa = sa & facData.colMostrar_electrica & ", """ & facData.colNombre_electrica & """, " & facData.colFiltrar_electrica & ", """ & facData.colFiltro_electrica & """);"

    Set rst = DbQuery(sa)



'field.name: colMostrar[electrica][] field.value : 0
'informes.js:251 field.name: colNombre[electrica][] field.value : 
'informes.js:251 field.name: colFiltrar[electrica][] field.value : 0
'informes.js:251 field.name: colFiltro[electrica][] field.value : 

    response.write("{""action"":"""& action &""",""codigoInforme"":"""& codigoInforme &"""}")

  End Sub
  
  
  Public Sub addODT(codigoInforme, codigoODT)
  

    response.Charset = "utf-8" 
    response.ContentType = "application/json"
    
    DbQuery("UPDATE odts SET codigoInforme=" & codigoInforme &" WHERE codigoODT="& codigoODT)
    
    response.write("{""action"":""ok""}")
  
  End Sub
  
End Class
%>