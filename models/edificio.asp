<%
Class Edificio


  Public Sub getList(fromCodigoEdificio, search)

    Dim sqlDefinidores
    
    response.Charset = "utf-8" 
    response.ContentType = "application/json"
  
    if fromCodigoFactura = 0 then 
      where = "activo" 
    else 
      where = "activo AND codigoEdificio < "& fromCodigoFactura
    end if
  
  
    if search <> "" then
       where = where & " AND (e.Edificio like '%" & search & "%' OR e.Planta like '%" & search & "%' )"
    end if

    sql = "SELECT e.codigoEdificio, e.Edificio as Nombre, e.Planta, 'creada' as icon FROM odtedificios e "
    sql = sql & "WHERE " & where
    sql = sql & " ORDER BY e.Planta, e.Edificio ASC "

    sqlDefinidores = "SELECT od.MNdefinidor, su.Nombre FROM odtdefinidores od " & _
                     "INNER JOIN sistemausuarios su ON su.MN = od.MNdefinidor "& _
                     "WHERE od.codigoEdificio = "
    
    sqlAprobadores = "SELECT oa.MNAprobador, su.Nombre FROM odtaprobadores oa " & _
                     "INNER JOIN sistemausuarios su ON su.MN = oa.MNAprobador "& _
                     "WHERE oa.codigoEdificio = "
    
    Dim rs, jsa, col, h, m
    Set rs = conexion.Execute(sql)
    Set jsa = jsArray()
    
    while not (rs.EOF or rs.BOF)
        set jsa(Null) = jsObject()
        
        for each col in rs.Fields
            if isDate(col.Value) then
                h = left("00",2 - len(hour(col.Value))) & hour(col.Value)
                m = left("00",2 - len(minute(col.Value))) & minute(col.Value)
                V = year(col.Value) & "/" & month(col.Value) & "/" & day(col.Value) & " " & h & ":" & m 
            else 
                v =  col.Value
            end if
            jsa(Null)(col.Name) = v & ""
        next
        
        Set jsa(Null)("ListaDefinidores") = QueryToJSON(conexion, sqlDefinidores + jsa(Null)("codigoEdificio"))
        Set jsa(Null)("ListaAprobadores") = QueryToJSON(conexion, sqlAprobadores + jsa(Null)("codigoEdificio"))
        
        rs.MoveNext
    wend
    
    'response.write(SQL)
    
    jsa.flush
    
  end Sub

  
  
  
  
  Public Sub getEdificio(codigoEdificio) 
  
    response.Charset = "utf-8" 
    response.ContentType = "application/json"
    
    sql = "SELECT * FROM odtedificios WHERE codigoEdificio = " & codigoEdificio 

    QueryToJSON(conexion, sql).Flush
  
  End Sub


  
  
  
  
  
  Public Sub update(jsonData)
    
    dim facData : Set facData = JSON.parse(jsonData)
    
    codigoEdificio = Clng(facData.codigoEdificio)
    
    action = "u"
    
    response.Charset = "utf-8" 
    response.ContentType = "application/json"
    

    if codigoEdificio = 0 then
      
      Set RS = DbOpen("odtedificios")
        RS.Addnew
        RS("activo") = 1
        RS.Update
      RS.close

      lastID = lastInsertId()
      
      action = "n"
      
      codigoEdificio = lastID
      
    end if


    Set RS = DbOpen("SELECT * FROM odtedificios WHERE codigoEdificio="& codigoEdificio)
      RS("Planta") = facData.Planta
      RS("Edificio") = facData.Nombre
      RS.Update 
    RS.Close


' SECCION listas definidores y aprobadores      

     Set RS = DbOpen("DELETE FROM odtdefinidores WHERE codigoEdificio = "& codigoEdificio)
          
     Set RS = DbOpen("DELETE FROM odtaprobadores WHERE codigoEdificio = "& codigoEdificio)
     
    
     Set ld = facData.ListaDefinidores
     Set RS = DbOpen("odtdefinidores")
     for i = 0 to ld.length - 1
       Set d = ld.get(i)
       RS.Addnew
           RS("MNdefinidor") = d.MNdefinidor
           RS("codigoEdificio") = codigoEdificio
           RS("activo") = 1
           RS.Update
    next
    RS.CLose
    
    Set la = facData.ListaAprobadores
    Set RS = DbOpen("odtaprobadores")
    for i = 0 to la.length - 1
       Set a = la.get(i) 
       RS.Addnew
           RS("MNAprobador") = a.MNAprobador
           RS("codigoEdificio") = codigoEdificio
           RS("activo") = 1
           RS.Update
    next

    RS.Close
    response.write("{""action"":"""& action &""",""codigoEdificio"":"""& codigoEdificio &"""}")
    
    'response.write(jsonData)
    
  End Sub
  
  
  
  
  


  
  
  Public Sub addODT(FacturaNro, codigoODT)

    response.Charset = "utf-8" 
    response.ContentType = "application/json"
    
    if FacturaNro = 0 then FacturaNro = null
  
    RS.Open "SELECT * FROM odts WHERE codigoODT="& codigoODT,conexion,2
      RS("FacturaNro") = FacturaNro
      RS.Update 
    RS.Close  

    response.write("{""action"":""lalala""}")
  
  End Sub
  
  


End Class
%>