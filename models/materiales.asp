<%
Class Material

  Public Sub delete(itemID)
  
    if usuarioPuede(ODT_puedeCargarDetalle) then 
    
        DbQuery "DELETE FROM odtitemsmateriales WHERE ItemID="& itemID
    
    end if 
    
  End Sub
  
    
  Public Sub update(jsonData)
  
    dim matData : Set matData = JSON.parse(jsonData)
    
    'lastId = LAST_INSERT_ID("odtitemsmateriales","ItemID") + 1
    ItemID = Clng(matData.ItemID)
    
    action = "u"
    
    response.Charset = "utf-8" 
    response.ContentType = "application/json"
    
' ------- SI ES NUEVO MATERIAL LO INSERTO EN DB Y RETORNO SU NUEVO ID ----------------
' ------- CAMBIOS EN DB,     
    if ItemID = 0 then
      
      set RS = DbOpen("odtitemsmateriales")
      RS.Addnew
      RS("CodigoODT") = matData.CodigoODT
      RS.Update
      RS.close

      lastID = lastInsertId()
      
      action = "n"
      
      ItemID = lastID
      
    end if



    Set RS = DbOpen("SELECT * FROM odtitemsmateriales WHERE ItemID="& ItemID ) ',conexion, 2
      
      RS("MaterialesTxt") = matData.MaterialesTxt
      RS("NroFactura") = matData.NroFactura
	  RS("Cant") = matData.Cant
      RS("Precio") = matData.Precio
      RS("Observaciones") = matData.Observaciones
     
      RS.Update 

    RS.Close  


    response.write("{""action"":"""& action &""",""ItemID"":"""& ItemID &"""}")
    


  End Sub


End Class
%>