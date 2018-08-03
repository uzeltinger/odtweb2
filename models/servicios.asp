<%
Class Servicios

  Public Sub delete(itemID)
    
    if usuarioPuede(ODT_puedeCargarDetalle) then
    
        DbQuery "DELETE FROM odtitemsrealizados WHERE ItemID="& itemID
    
    end if 
    
  End Sub

  

  Public Sub update(jsonData)

    
    dim serData : Set serData = JSON.parse(jsonData)
    
    ItemID = Clng(serData.ItemID)
    
    action = "u"
    
    response.Charset = "utf-8" 
    response.ContentType = "application/json"
    
' ------- SI ES NUEVO SERVICIO LO INSERTO EN DB Y RETORNO SU NUEVO ID ----------------

    if ItemID = 0 then
      
      Set RS = DbOpen("odtitemsrealizados")
      
      RS.Addnew
      RS("CodigoODT") = serData.CodigoODT
      RS("mnCreacion") = USUARIO_DEFAULT
      RS.Update
      RS.close

      lastID = lastInsertId()
      
      action = "n"
      
      ItemID = lastID
      
    end if

    Set RS = DbOpen("SELECT * FROM odtitemsrealizados WHERE ItemID="& ItemID)

      RS("Cant") = csng(replace(serData.Cant,",","."))
      RS("codigoItem") = serData.codigoItem
      RS("Observaciones") = serData.Observaciones
      
    RS.Update 

    RS.Close  
    
    response.write("{""action"":"""& action &""",""ItemID"":"""& ItemID &"""}")
    


  End Sub
  
  
  
  
  
  
  Public Sub listarServicios
  
    QueryToJSON(conexion, "SELECT codigoItem as id, Descripcion as text, Precio FROM odtitems oi WHERE oi.activo = 1 AND oi.FechaVigencia = (SELECT DISTINCT MAX(fechaVigencia) FROM odtitems) ORDER BY oi.fechaVigencia DESC, oi.numeroItem ASC").Flush  
  
  End Sub


End Class
%>