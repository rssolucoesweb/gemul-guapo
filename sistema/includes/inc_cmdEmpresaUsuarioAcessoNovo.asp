<%	

    if intCodGrupo = "" then intCodGrupo = SESSION("codGrupo")
	if intCodGrupo = "" then intCodGrupo = 1
	anoLogado = SESSION("strAnoLetivo")
	if anoLogado = "" then anoLogado = year(date)


	sql = "select ue.COD_EMPRESA, e.RAZAOSOCIAL as empresa, "
	sql = sql & " ("
	sql = sql & " select count(*) "
	sql = sql & " FROM SCA_ALUNO a "
	sql = sql & " inner join sca_aluno_turma at on at.cod_aluno = a.codigo and at.COD_EMPRESA = e.CODIGO"
	sql = sql & " inner join sca_turma t on t.cod_turma = at.cod_turma "
	sql = sql & " WHERE t.anoLetivo = " & anoLogado 
	sql = sql & " and at.situacao = 'A' "
	sql = sql & " and t.Situacao = 'A' "
	sql = sql & " and a.COD_SITUACAOALUNO = 1 "
	sql = sql & " )"
	sql = sql & "  as ativos "
	sql = sql & " FROM SEG_USUARIOS_EMPRESA ue INNER JOIN SEG_EMPRESA e ON e.CODIGO = ue.COD_EMPRESA "
	sql = sql & " WHERE e.CodTipoEmpresa<>5 "
	sql = sql & " and ue.CODIGO_SEG_USUARIOS_SISTEMA = '" & Session("UsuarioWeb") & "' and e.BLOQUEIO = 'N' "
	if intCodGrupo <> "0" then
		sql = sql & " AND e.COD_GRUPO = " & intCodGrupo
	end if
	if intContratoAcesso<>"0" and intContratoAcesso <> "" then
		sql = sql & " AND ue.COD_EMPRESA in (select Cod_empresa from SRH_MODULACAO_DISCIPLINAR_DOCENTE where Cod_Colaborador in (" & intContratoAcesso & "))"
	end if
	
	sql = sql & " union "
	sql = sql & " select ue.COD_EMPRESA, e.RAZAOSOCIAL as empresa, 0 as ativos "
	sql = sql & " FROM SEG_USUARIOS_EMPRESA ue INNER JOIN SEG_EMPRESA e ON e.CODIGO = ue.COD_EMPRESA "
	sql = sql & " WHERE e.CodTipoEmpresa=5 "
	sql = sql & " and ue.CODIGO_SEG_USUARIOS_SISTEMA = '" & Session("UsuarioWeb") & "'"
	sql = sql & " and e.BLOQUEIO = 'N'"
	if intCodGrupo <> "0" then
		sql = sql & " AND e.COD_GRUPO = " & intCodGrupo
	end if
	if intContratoAcesso<>"0" and intContratoAcesso <> "" then
		sql = sql & " AND ue.COD_EMPRESA in (select Cod_empresa from SRH_MODULACAO_DISCIPLINAR_DOCENTE where Cod_Colaborador in (" & intContratoAcesso & "))"
	end if
	sql = sql & "  Order by e.RAZAOSOCIAL"
	'response.write sql
	RSAux.OPEN SQL, CNN
%>
<select name="cmdEmpresaUsuario" id="cmdEmpresaUsuario" class="form-control" onchange="submit()">
	<option value="0">Selecione...</option>
<%
	IF RSAux.EOF = FALSE THEN
		while not RSAux.eof
			if trim(intCodEmpresaUsuario) = trim(RSAux("COD_EMPRESA")) then
				
				strSelecionado = " selected"
				Session("TotalAlunosAtivos") = RSAux("ATIVOS") 
				
			else
				strSelecionado = ""
			end if
			
			if RSAux("COD_EMPRESA") = "9" then
				response.write "<option value=" & RSAux("COD_EMPRESA")& " " & strSelecionado &">" & RSAux("empresa") & "</option> "  & vbcrlf
			else
				response.write "<option value=" & RSAux("COD_EMPRESA")& " " & strSelecionado &">" & RSAux("empresa") & " - ( Total de Ativos: " & RSAux("ATIVOS")& " - Ano Letivo: " & anoLogado & " ) </option> "  & vbcrlf
			end if

			RSAux.movenext
		wend
	END IF
	RSAux.close
%>
</select>