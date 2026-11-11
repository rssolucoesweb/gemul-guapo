<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Objetivo Pagina...: Consulta de grupo
-->
<%	

    if intCodGrupo = "" then intCodGrupo = "0" 
	if intCodTipoEmpresa = "" then intCodTipoEmpresa = "0" 
	sql = "select SEG_USUARIOS_EMPRESA.COD_EMPRESA, SEG_EMPRESA.RAZAOSOCIAL, SEG_GRUPO.DESCRICAO AS GRUPO, ANO_LETIVO, SEMESTRE, "
	sql = sql & " ("
	sql = sql & " SELECT COUNT(A.CODIGO) "
	sql = sql & " FROM SCA_ALUNO A"
	sql = sql & " INNER JOIN SCA_ALUNO_ANO_LETIVO AA ON AA.COD_ALUNO = A.CODIGO "
	sql = sql & " AND AA.ANO_LETIVO = " & session("strAnoLetivo")
	sql = sql & " WHERE COD_EMPRESA=SEG_USUARIOS_EMPRESA.COD_EMPRESA)AS REGISTROS, "
	sql = sql & " ("
	sql = sql & " SELECT COUNT(A.CODIGO) "
	sql = sql & " FROM SCA_ALUNO A "
	sql = sql & " INNER JOIN SCA_ALUNO_ANO_LETIVO AA ON AA.COD_ALUNO = A.CODIGO "
	sql = sql & " AND AA.ANO_LETIVO = " & session("strAnoLetivo")
	sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO "
	sql = sql & " WHERE AA.COD_EMPRESA = SEG_USUARIOS_EMPRESA.COD_EMPRESA "
	sql = sql & " AND SA.Cod_SituacaoAluno IN (1,2)"
	sql = sql & " ) AS ATIVOS "
	sql = sql & " FROM SEG_USUARIOS_EMPRESA "
	sql = sql & " INNER JOIN SEG_EMPRESA ON SEG_EMPRESA.CODIGO = SEG_USUARIOS_EMPRESA.COD_EMPRESA "
	sql = sql & " LEFT JOIN SEG_GRUPO ON SEG_EMPRESA.COD_GRUPO = SEG_GRUPO.CODIGO "
	sql = sql & " LEFT JOIN SEG_ENCERRAMENTOATIVIDADES ON SEG_ENCERRAMENTOATIVIDADES.COD_EMPRESA = SEG_EMPRESA.CODIGO "
	sql = sql & " WHERE CODIGO_SEG_USUARIOS_SISTEMA = '" & session("UsuarioWeb") & "'" 
	if intCodGrupo <> "0" then
		sql = sql & " AND SEG_EMPRESA.COD_GRUPO = " & intCodGrupo
	end if
	if intCodTipoEmpresa <> "0" then
		sql = sql & " AND SEG_EMPRESA.CodTipoEmpresa = " & intCodTipoEmpresa
	end if	
	sql = sql & " AND SEG_EMPRESA.BLOQUEIO = 'N' "
	sql = sql & " Order by SEG_GRUPO.DESCRICAO, SEG_EMPRESA.RAZAOSOCIAL"
	RSAux.OPEN SQL, CNN
%>
<select name="cmdEmpresaUsuario" id="cmdEmpresaUsuario" style="width:500pt" class="combo" onchange="submit()">
	<option value="0">Selecione...</option>
<%
	IF RSAux.EOF = FALSE THEN
		while not RSAux.eof
			if trim(intCodEmpresaUsuario) = trim(RSAux("COD_EMPRESA")) then
				strSelecionado = " selected"
				if RSAux("SEMESTRE") = "3" then
				   strSemestrePrincipal = ""
				else
				   strSemestrePrincipal =  "/" & RSAux("SEMESTRE")
				end if  
				
			else
				strSelecionado = ""
			end if
			strGrupo = "SEM GRUPO"
			if not isnull(RSAux("GRUPO")) then strGrupo = RSAux("GRUPO")
			
			if ucase(Session("UsuarioWeb")) = "USUARIO.TESTE" then
				response.write "<option value=" & RSAux("COD_EMPRESA")& " " & strSelecionado &">" & session("EmpresaWeb") & "</option> "  & vbcrlf
			else
				response.write "<option value=" & RSAux("COD_EMPRESA")& " " & strSelecionado &">" & RSAux("RAZAOSOCIAL") & " - ( Total de Ativos: " & RSAux("ATIVOS")& " - Ano Letivo: " & RSAux("ANO_LETIVO") & strSemestrePrincipal & " ) </option> "  & vbcrlf
			end if

			RSAux.movenext
		wend
	END IF
	RSAux.close
%>
</select>