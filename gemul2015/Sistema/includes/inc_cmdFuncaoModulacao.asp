<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Curso 
-->
<%	
	if strSubmitFuncao = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	sql = " select distinct FC.Cod_Funcao, FC.Desc_Funcao, FC.Situacao_Disciplinar "
	sql = sql & " from SRH_TURMA_MODULACAO_FUNCAO TMF "
	sql = sql & " INNER JOIN SCA_TURMA T ON T.Cod_Turma = TMF.Cod_Turma AND T.Situacao = 'A' "
	sql = sql & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = TMF.Cod_Funcao "
	sql = sql & " WHERE FC.Cod_grupo = " & Session("CodGrupo")
	if trim(strTipoModulacao) <> "" then 
		sql = sql & " AND FC.Tipo_Funcao = '" & trim(strTipoModulacao) & "'"
	end if
	if session("NivelPermissao") = "A" then
	else
		if intcodFuncaoCadastro <> "" then
			sql = sql & " and FC.Cod_Funcao = " & intcodFuncaoCadastro
		end if
	end if
	sql = sql & " UNION  "
	sql = sql & " SELECT DISTINCT FC.Cod_Funcao, FC.Desc_Funcao, FC.Situacao_Disciplinar" 
	sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA GCD "  
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = GCD.Cod_GradeCurricular AND GC.Situacao = 'A' " 
	sql = sql & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = GCD.Cod_Funcao " 
	sql = sql & " WHERE ISNULL(GCD.COD_FUNCAO,'0')<>'0' " 
	sql = sql & " AND FC.Cod_grupo =" & Session("CodGrupo")
	if trim(strTipoModulacao) <> "" then 
		sql = sql & " AND FC.Tipo_Funcao = '" & trim(strTipoModulacao) & "'"
	end if
	if session("NivelPermissao") = "A" then
	else
		if intcodFuncaoCadastro <> "" then
			sql = sql & " and FC.Cod_Funcao = " & intcodFuncaoCadastro
		end if
	end if
	sql = sql & " ORDER BY FC.Desc_Funcao " 
	RS.OPEN SQL, CNN
%>
<select name="cmbFuncao" id="cmbFuncao" style="width:250pt" class="combo" <%=strFuncao%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodFuncao) = trim(rs("Cod_Funcao")) then
				strSelecionado = " selected"
				strTipoLancamento = trim(rs("Situacao_Disciplinar")) 
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Cod_Funcao")& " " & strSelecionado &">" &  rs("Desc_Funcao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>