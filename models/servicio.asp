<%
Class Servicio


  Public Sub getList(fromCodigoServicio, search)

    response.Charset = "utf-8" 
    response.ContentType = "application/json"
  
    where = "activo" 
  
    if search <> "" then
       where = where & " AND (e.Descripcion like '%" & search & "%' OR e.version like '%" & search & "%')"
    end if
    
    sql = "SELECT e.codigoItem, e.Descripcion, 'creada' as icon, numeroItem, Precio, codigoSAP, FechaVigencia FROM odtitems e "
    sql = sql & "WHERE " & where & " AND FechaVigencia=(SELECT DISTINCT MAX(FechaVigencia) FROM odtitems) "
    sql = sql & " ORDER BY numeroItem ASC "

    QueryToJSON(conexion, sql).Flush
    'response.write(sql)
    
  end Sub

  
  Public Sub getServicio(codigoItem) 
  
    response.Charset = "utf-8" 
    response.ContentType = "application/json"
    
    sql = "SELECT * FROM odtitems WHERE codigoItem = " & codigoItem 

    QueryToJSON(conexion, sql).Flush
  
  End Sub


  Public Sub update(jsonData)
    
    dim facData : Set facData = JSON.parse(jsonData)
    log(jsonData)
    codigoItem = Clng(facData.codigoItem)
    
    action = "u"
    
    response.Charset = "utf-8" 
    response.ContentType = "application/json"
    

    if codigoItem = 0 then
      
        Set RS = DbOpen("odtitems")
        RS.Addnew
        RS.Update
        RS.close

        lastID = lastInsertId()

        action = "n"

        codigoItem = lastID

        Set RS= DbQuery("SELECT DISTINCT FechaVigencia FROM odtitems ORDER BY FechaVigencia DESC LIMIT 1")
        While Not (RS.EOF Or RS.BOF)
            FechaVigencia = RS("FechaVigencia")
            RS.MoveNext
        Wend      
        RS.Close

        Set RS= DbQuery("SELECT MAX(e.numeroItem) as numeroItem FROM odtitems e WHERE activo AND FechaVigencia=(SELECT DISTINCT FechaVigencia FROM odtitems ORDER BY FechaVigencia DESC LIMIT 1)")
         While Not (RS.EOF Or RS.BOF)
            numeroItem = cLng(RS("numeroItem")) + 1
            RS.MoveNext
        Wend      
        RS.Close

        
    end if

    Set RS = DbOpen("SELECT * FROM odtitems WHERE codigoItem="& codigoItem)

    if csng("1,7") = 1.7 then
        facData.Precio = replace(facData.Precio,".",",")
    end if

    RS("Descripcion") = facData.Descripcion
    RS("codigoSAP") = facData.codigoSAP
    RS("Precio") = CSng(facData.Precio)
    
    if action = "n" then 
        RS("FechaVigencia") = FechaVigencia
        RS("numeroItem") = numeroItem 
    end if


    RS.Update 

    RS.Close  

    response.write("{""action"":"""& action &""",""codigoItem"":"""& codigoItem &"""}")

  End Sub
  


  
    sub nuevoCoeficiente(FechaValidez, CGC1, CGC2, importeHasta)

        if CGC1 > 1 then 
            CGC1 = CGC1 / 100
        end if
        
        if CGC2 > 1 then 
            CGC2 = CGC2 / 100
        end if
        
        set RS = DbOpen("odtcoefgestioncompra")
        RS.Addnew
            RS("FechaValidez") = FechaValidez
            RS("CGC") = CGC1 ' Aqui poner CGC1
            RS("CGC2") = CGC2 ' Aqui poner CGC2
            RS("importe") = importeHasta
        RS.Update
        RS.Close

    end sub



    
    sub nuevoListadoServicios(FechaVigencia, version)

        Set RS_OLD= DbQuery("SELECT * FROM odtitems WHERE activo AND FechaVigencia=(SELECT DISTINCT MAX(FechaVigencia) FROM odtitems)")
        While Not (RS_OLD.EOF Or RS_OLD.BOF)
            
            Set RS = DbOpen("odtitems")
            
            RS.Addnew
                RS("numeroItem") = RS_OLD("numeroItem")
                RS("codigoSAP") = RS_OLD("codigoSAP")
                RS("Descripcion") = RS_OLD("Descripcion")
                RS("Precio") = RS_OLD("Precio")
                RS("FechaVigencia") = FechaVigencia
                RS("version") = version
                RS("mnCreacion") = USUARIO_DEFAULT
            RS.Update
            RS.Close
            
            RS_OLD.MoveNext
        Wend      
        RS_OLD.Close
    end sub
End Class
%>