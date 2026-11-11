<%
	if trim(Session("CodTodasEmpresaGrupo")) = "" then
		intCodGrupo = 0
		strGrupo = ""
		sql = "select SEG_EMPRESA.COD_GRUPO, SEG_GRUPO.DESCRICAO AS GRUPO"
		sql = sql & " FROM SEG_USUARIOS_EMPRESA"
		sql = sql & " INNER JOIN SEG_EMPRESA ON SEG_EMPRESA.CODIGO = SEG_USUARIOS_EMPRESA.COD_EMPRESA"
		sql = sql & " INNER JOIN SEG_GRUPO ON SEG_GRUPO.CODIGO = SEG_EMPRESA.COD_GRUPO"
		sql = sql & " WHERE CODIGO_SEG_USUARIOS_SISTEMA = '" & session("UsuarioWeb") & "' "
		sql = sql & " AND SEG_USUARIOS_EMPRESA.COD_EMPRESA = " & SESSION("CODEMPRESA")
		RsAux.Open SQL, cnn,3 ,1
		if not RsAux.EOF then
			intCodGrupo = rsAux("cod_grupo")
			strGrupo = rsAux("grupo")
		end if
		RsAux.close
		
		sql = "select SEG_USUARIOS_EMPRESA.COD_EMPRESA"
		sql = sql & " FROM SEG_USUARIOS_EMPRESA"
		sql = sql & " INNER JOIN SEG_EMPRESA ON SEG_EMPRESA.CODIGO = SEG_USUARIOS_EMPRESA.COD_EMPRESA"
		sql = sql & " LEFT 	JOIN SEG_GRUPO 	 ON SEG_EMPRESA.COD_GRUPO = SEG_GRUPO.CODIGO"
		sql = sql & " WHERE CODIGO_SEG_USUARIOS_SISTEMA = '" & session("UsuarioWeb") & "' "
		sql = sql & " AND SEG_EMPRESA.COD_GRUPO = " & intCodGrupo
		RsAux.Open SQL, cnn,3 ,1
		if not RsAux.EOF then
			Session("QtdeUsuarioEmpresaAcessa") = RsAux.recordCount
			while not rsAux.eof
				if intCodEmpTodas = "" then
					intCodEmpTodas = RsAux("cod_empresa")
				else
					intCodEmpTodas = intCodEmpTodas & ", " & RsAux("cod_empresa")
				end if
				rsAux.movenext
			wend
		end if
		RsAux.close
		
		Session("CodGrupo") = intCodGrupo
		Session("Grupo") = strGrupo
		Session("CodTodasEmpresaGrupo") = intCodEmpTodas
		Session("strNomeGrupo") = strGrupo
	end if
%>