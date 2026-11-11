<%	
    if intCodGrupo = "" then intCodGrupo = SESSION("codGrupo")
	if intCodGrupo = "" then intCodGrupo = 1
	anoLogado = SESSION("strAnoLetivo")
	if anoLogado = "" then anoLogado = year(date)


	'sql = "select ue.COD_EMPRESA, e.RAZAOSOCIAL as empresa, "
	'sql = sql & " ("
	'sql = sql & " select count(*) "
	'sql = sql & " FROM SCA_ALUNO a "
	'sql = sql & " inner join sca_aluno_turma at on at.cod_aluno = a.codigo and at.COD_EMPRESA = e.CODIGO"
	'sql = sql & " inner join sca_turma t on t.cod_turma = at.cod_turma "
	'sql = sql & " WHERE t.anoLetivo = " & anoLogado 
	'sql = sql & " and at.situacao = 'A' "
	'sql = sql & " and t.Situacao = 'A' "
	'sql = sql & " and a.COD_SITUACAOALUNO = 1 "
	'sql = sql & " )"
	'sql = sql & "  as ativos "
	'sql = sql & " FROM SEG_USUARIOS_EMPRESA ue INNER JOIN SEG_EMPRESA e ON e.CODIGO = ue.COD_EMPRESA "
	'sql = sql & " WHERE e.CodTipoEmpresa<>5 "
	'sql = sql & " and ue.CODIGO_SEG_USUARIOS_SISTEMA = '" & Session("UsuarioWeb") & "' and e.BLOQUEIO = 'N' "
	'if intCodGrupo <> "0" then
	'	sql = sql & " AND e.COD_GRUPO = " & intCodGrupo
	'end if
	'if intContratoAcesso<>"0" and intContratoAcesso <> "" then
	'	sql = sql & " AND ue.COD_EMPRESA in ("
	'	sql = sql & " select Cod_empresa from SRH_MODULACAO_DISCIPLINAR_DOCENTE where Cod_Colaborador in (" & intContratoAcesso & ")"
	'	sql = sql & " union "
	'	sql = sql & " select COD_EMPRESA from SEG_USUARIOS_EMPRESA"
	'	sql = sql & " where CODIGO_SEG_USUARIOS_SISTEMA =  '" & Session("UsuarioWeb") & "'"
	'	sql = sql & " )"
	'end if
	'
	'sql = sql & " union "
	'sql = sql & " select ue.COD_EMPRESA, e.RAZAOSOCIAL as empresa, 0 as ativos "
	'sql = sql & " FROM SEG_USUARIOS_EMPRESA ue INNER JOIN SEG_EMPRESA e ON e.CODIGO = ue.COD_EMPRESA "
	'sql = sql & " WHERE e.CodTipoEmpresa=5 "
	'sql = sql & " and ue.CODIGO_SEG_USUARIOS_SISTEMA = '" & Session("UsuarioWeb") & "'"
	'sql = sql & " and e.BLOQUEIO = 'N'"
	'if intCodGrupo <> "0" then
	'	sql = sql & " AND e.COD_GRUPO = " & intCodGrupo
	'end if
	'if intContratoAcesso<>"0" and intContratoAcesso <> "" then
	'	sql = sql & " AND ue.COD_EMPRESA in ("
	'	sql = sql & " select Cod_empresa from SRH_MODULACAO_DISCIPLINAR_DOCENTE where Cod_Colaborador in (" & intContratoAcesso & ")"
	'	sql = sql & " union "
	'	sql = sql & " select COD_EMPRESA from SEG_USUARIOS_EMPRESA"
	'	sql = sql & " where CODIGO_SEG_USUARIOS_SISTEMA =  '" & Session("UsuarioWeb") & "'"
	'	sql = sql & " )"
	'end if
	'sql = sql & "  Order by e.RAZAOSOCIAL"
	
	
	
	verificarModulacao = "S"
	sql = "Select distinct codCategoria "
	sql = sql & " from SRH_COLABORADOR "
	sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & Session("UsuarioWeb") & "' "
	sql = sql & " and Situacao = 'A'"
	RSAux.OPEN SQL, CNN
	IF NOT RSAUX.EOF THEN 
		while not RSAux.eof
			if rsAux("codCategoria") <> "1" then
				verificarModulacao = ""
			end if
			RSAux.movenext
		wend
	ELSE
		verificarModulacao = ""
	END IF
	RSAux.close
	
	
	sql = "SELECT e.CodTipoEmpresa, e.CODIGO AS COD_EMPRESA, e.RAZAOSOCIAL as empresa, g.descricao AS GRUPO "
	sql = sql & " FROM SEG_USUARIOS_EMPRESA ue JOIN SEG_EMPRESA e ON e.CODIGO = ue.COD_EMPRESA "
	sql = sql & " JOIN SEG_GRUPO g ON g.CODIGO = e.cod_grupo "
	sql = sql & " WHERE ue.CODIGO_SEG_USUARIOS_SISTEMA = '" & Session("UsuarioWeb") & "' "
	sql = sql & " AND e.COD_GRUPO = " & intCodGrupo & " AND e.BLOQUEIO = 'N' "
	IF verificarModulacao = "S" AND trim(mostraComboSubstituicao) = "N" then
		sql = sql & " AND ue.COD_EMPRESA IN (select DISTINCT COD_EMPRESA "
		sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE"
		sql = sql & " where Cod_Colaborador in ("
		sql = sql & " select codigo "
		sql = sql & " from SRH_COLABORADOR"
		sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & Session("UsuarioWeb") & "'"
		sql = sql & " )"
		sql = sql & " AND Status='A'"
		sql = sql & " and Ano_Letivo = " & anoLogado & ")"
	END IF
	sql = sql & " ORDER BY e.RAZAOSOCIAL"
	RSAux.OPEN SQL, CNN
%>
<div class="school-select">
	<h3><i class="fa-solid fa-magnifying-glass"></i> Selecione sua unidade </h3><br>
	<select name="cmdEmpresaUsuario" id="cmdEmpresaUsuario" onchange="submit()">
		<option value="0">Selecione...</option>
	<%
		IF RSAux.EOF = FALSE THEN
			while not RSAux.eof
				if trim(intCodEmpresaUsuario) = trim(RSAux("COD_EMPRESA")) then
					strSelecionado = " selected"
				else
					strSelecionado = ""
				end if
				
				response.write "<option value=" & RSAux("COD_EMPRESA")& " " & strSelecionado &">" & RSAux("empresa") & "</option> "  & vbcrlf

				RSAux.movenext
			wend
		END IF
		RSAux.close
	%>
	</select>
</div>