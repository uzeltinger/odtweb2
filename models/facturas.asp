<%
Class Factura


  Public Sub getTodas(fromCodigoFactura, search)

    response.Charset = "utf-8" 
    response.ContentType = "application/json"
  
    if fromCodigoFactura = 0 then 
      where = "true" 
    else 
      where = "codigoFactura < "& fromCodigoFactura
    end if
  
  
    ' if search <> "" then
      ' where = where & " AND (su.Nombre  like '%" & search & "%' OR o.codigoODT like '%" & search & "%' OR o.DescripcionODT like '%" & search & "%' OR su1.Nombre  like '%" & search & "%')"
    ' end if

    sql = "SELECT of.codigoFactura, of.FacturaNro, su.Nombre, of.Empresa, of.FechaFactura, of.mnCreacion FROM odtfacturacion of "
    sql = sql & "LEFT JOIN sistemausuarios su ON su.MN = of.mnCreacion "
    sql = sql & "WHERE " & where
    sql = sql & " ORDER BY of.FechaFactura DESC "
    sql = sql & "LIMIT " & CANT_POR_PAGINA

    QueryToJSON(conexion, sql).Flush
    
  end Sub



  





  Public Sub getFactura(codigoFactura) 
  
    response.Charset = "utf-8" 
    response.ContentType = "application/json"
    
    sql = "SELECT * FROM odtfacturacion WHERE codigoFactura = "& codigoFactura 

    QueryToJSON(conexion, sql).Flush
  
  End Sub


  
  
  
  
  

  Public Sub update(jsonData)
    
    dim facData : Set facData = JSON.parse(jsonData)
    log(jsonData)
    codigoFactura = Clng(facData.codigoFactura)
    
    action = "u"
    
    response.Charset = "utf-8" 
    response.ContentType = "application/json"
    

    if codigoFactura = 0 then
      
      set RS = DbOpen("odtfacturacion")
        RS.Addnew
        RS.Update
      RS.close

      lastID = lastInsertId()
      
      action = "n"
      
      codigoFactura = lastID
      
    end if


    set RS = DbOpen("SELECT * FROM odtfacturacion WHERE codigoFactura="& codigoFactura)

      RS("FacturaNro") = facData.FacturaNro
      RS("Empresa") = facData.Empresa
      
      f = split(facData.FechaFactura, "-")
      RS("FechaFactura") = f(2) & "-" & f(1) & "-" & f(0)
      RS("CodigoPrecio") = facData.CodigoPrecio
      RS("mnCreacion") = facData.mnCreacion

      RS.Update 

    RS.Close  

    response.write("{""action"":"""& action &""",""codigoFactura"":"""& codigoFactura &"""}")

  End Sub
  
  
  Public Sub addODT(codigoFactura, codigoODT)
  

    response.Charset = "utf-8" 
    response.ContentType = "application/json"
    
    DbQuery("UPDATE odts SET codigoFactura=" & codigoFactura &" WHERE codigoODT="& codigoODT)
    
    response.write("{""action"":""ok""}")
  
  End Sub
  
  


End Class
%>