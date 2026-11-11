<%

	'PERFIL COORDENADORES - 17
	'PERFIL PROFESSORES   - 11
	'PERFIL ADMINISTRADOR - 2
	'PERFIL SECREATARIO GERAL - 15	
	strAcessoPerfil = ""
	'VERIFICA SE O USUARIO TEM ACESSO AO PERFIL DE PROFESSOR
	strTemAcessoFuncionalidade = "N"
	SQL = "SELECT ACES_PERF_CODG"
	SQL = SQL & " FROM SEG_ACESSOS_USUARIO"
	SQL = SQL & " WHERE ACES_USUA_CODG = '" & session("usuarioWeb") & "'"
	SQL = SQL & " AND ACES_PERF_CODG in (" & strCodPefilAcesso & ")"
	'response.write sql
	rs.open sql, cnn
	if not rs.EOF then	
		strTemAcessoFuncionalidade = "S"
		while not rs.eof 
			if trim(rs("ACES_PERF_CODG")) = "17" OR trim(rs("ACES_PERF_CODG")) = "2" OR trim(rs("ACES_PERF_CODG")) = "15" then
				strAcessoPerfil = "COORDENADOR"
			end if
			rs.movenext
		wend
		
	end if
	rs.close

	if trim(strTemAcessoFuncionalidade) = "N" then
		%>	
		<!--script >
			//alert("Você não tem acesso a essa funcionalidade, verifique suas permissões com a secretaria de educação.\nSomente os perfis: Administrador, Secreataria Geral, Coordenador e Professor poderão acessar!")
			//window.history.back();
		</script -->
		<%
		'response.end
	end if

	
	'verifica acesso professor ou coordenador
	
	'response.write "<br>strAcessoPerfil: " & strAcessoPerfil
	'response.write "<br>intCodProfessor: " & session("intCodProfessor")
	'response.write "<br>Seg_CodCategoria: " & session("Seg_CodCategoria")
	'response.write "<br>CodColaboradorContrato: " & session("CodColaboradorContrato")
	
	
	if trim(strAcessoPerfil) = "" then
	'response.write "<br>passou"
		if trim(session("intCodProfessor")) = "" then
		'response.write "<br>passou1"
			if trim(Session("Seg_CodCategoria")) = "1" then 'professor
			'response.write "<br>passou2"
			'response.write "<br>" & Session("Seg_CodColaborador")
				if Session("Seg_CodColaborador")<>"" and  Session("Seg_CodColaborador")<>"0" then
					intCodProfessor 	      	= Session("Seg_CodColaborador")
				end if 
				'response.write "<br>intCodProfessor:" & intCodProfessor
				if intCodProfessor="" then intCodProfessor 	      	= Session("CodColaboradorContrato")
				strAcessoPerfil = "PROFESSOR"
			else	 
				' Consulta a Categoria	
				sql = "select c.codigo "
				sql = sql & " from SRH_COLABORADOR c"
				sql = sql & " inner join SRH_FUNCAOCOLABORADOR f on f.Cod_Funcao = c.codFuncao"
				sql = sql & " where c.codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
				sql = sql & " and (c.CodCategoria = 1 or c.CodCategoria = 8)"'professor  
				sql = sql & " and c.Situacao = 'A'" 'Ativo
				sql = sql & " and f.Desc_Funcao like 'COORDENADOR%'"
				rs.open sql, cnn
				if rs.EOF = false then	
					intCodProfessor 	      	= rs("codigo")
					strAcessoPerfil = "COORDENADOR"
				end if
				rs.close

				if strAcessoPerfil = "" then
					sql = "select c.codigo "
					sql = sql & " from SRH_COLABORADOR c"
					sql = sql & " inner join SRH_FUNCAOCOLABORADOR f on f.Cod_Funcao = c.codFuncao"
					sql = sql & " where c.codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
					sql = sql & " and (c.CodCategoria = 1 or c.CodCategoria = 8)"'professor  
					sql = sql & " and c.Situacao = 'A'" 'Ativo
					sql = sql & " and f.Desc_Funcao like 'PROFESSOR%'"
					rs.open sql, cnn
					if rs.EOF = false then	
						intCodProfessor 	      	= rs("codigo")
						strAcessoPerfil = "PROFESSOR"
					end if
					rs.close
				end if

			end if	
		else
			intCodProfessor = session("intCodProfessor")
			' Consulta a Categoria	
			sql = "select c.codigo "
			sql = sql & " from SRH_COLABORADOR c"
			sql = sql & " inner join SRH_FUNCAOCOLABORADOR f on f.Cod_Funcao = c.codFuncao"
			sql = sql & " where c.codigo = " & intCodProfessor
			sql = sql & " and f.Desc_Funcao like 'COORDENADOR%'"
			rs.open sql, cnn
			if rs.EOF = false then	
				strAcessoPerfil = "COORDENADOR"
			end if
			rs.close

			if strAcessoPerfil = "" then
				sql = "select c.codigo "
				sql = sql & " from SRH_COLABORADOR c"
				sql = sql & " inner join SRH_FUNCAOCOLABORADOR f on f.Cod_Funcao = c.codFuncao"
				sql = sql & " where c.codigo = " & intCodProfessor
				sql = sql & " and f.Desc_Funcao like 'PROFESSOR%'"
				rs.open sql, cnn
				if rs.EOF = false then	
					strAcessoPerfil = "PROFESSOR"
				end if
				rs.close
			end if
		end if
	end if
	'response.write "<br>intCodProfessor: " & intCodProfessor
	'response.write "<br>strAcessoPerfil: " & strAcessoPerfil

%>