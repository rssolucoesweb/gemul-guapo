<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: sergio borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de grupo
-->
<%	

    if intCodGrupo = "" then intCodGrupo = "0" 
    if strUsuarioPortal = "" then strUsuarioPortal = "0" 

	sql = "select SEG_USUARIOS_EMPRESA.COD_EMPRESA, SEG_EMPRESA.RAZAOSOCIAL, SEG_GRUPO.DESCRICAO AS GRUPO, ANO_LETIVO, SEMESTRE,"
	sql = sql & "  (SELECT COUNT(CODIGO) FROM SCA_ALUNO "
	sql = sql & " 	WHERE COD_EMPRESA=SEG_USUARIOS_EMPRESA.COD_EMPRESA)AS REGISTROS, "
	sql = sql & "  (SELECT COUNT(CODIGO) FROM SCA_ALUNO A "
	sql = sql & " 	INNER JOIN SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO AND SA.Cod_Empresa = A.COD_EMPRESA "
	sql = sql & " 	WHERE A.COD_EMPRESA = SEG_USUARIOS_EMPRESA.COD_EMPRESA "
	sql = sql & " 	AND (SA.Desc_SituacaoAluno = 'ATIVO' OR SA.Desc_SituacaoAluno = 'PRÉ-MATRÍCULA')) AS ATIVOS "
	sql = sql & " FROM SEG_USUARIOS_EMPRESA"
	sql = sql & " INNER JOIN SEG_EMPRESA ON SEG_EMPRESA.CODIGO = SEG_USUARIOS_EMPRESA.COD_EMPRESA"
	sql = sql & " LEFT 	JOIN SEG_GRUPO 	 ON SEG_EMPRESA.COD_GRUPO = SEG_GRUPO.CODIGO"
	sql = sql & " LEFT JOIN SEG_ENCERRAMENTOATIVIDADES ON SEG_ENCERRAMENTOATIVIDADES.COD_EMPRESA = SEG_EMPRESA.CODIGO "
	sql = sql & " WHERE CODIGO_SEG_USUARIOS_SISTEMA = '" & trim(strUsuarioPortal) & "'" 
	sql = sql & " Order by SEG_GRUPO.DESCRICAO, SEG_EMPRESA.RAZAOSOCIAL"
	RSAux.OPEN SQL, CNN
%>
<select name="cmdEmpresaUsuario" id="cmdEmpresaUsuario" style="width:300pt" class="form-control" onchange="submit()">
	<option value="0">Selecione...</option>
<%
	IF RSAux.EOF = FALSE THEN
		while not RSAux.eof
			if trim(intCodEmpresaUsuario) = trim(RSAux("COD_EMPRESA")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			if not isnull(RSAux("GRUPO")) then strGrupo = RSAux("GRUPO")
			
			response.write "<option value=" & RSAux("COD_EMPRESA")& " " & strSelecionado &">" & RSAux("RAZAOSOCIAL") & "  </option> "  & vbcrlf
			RSAux.movenext
		wend
	END IF
	RSAux.close
%>
</select>