<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 10/03/2009
	::	Desenvolvedores...: Sérgio Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Consulta de Turma Professor
-->
<%	

	if strExecutarSubmitSiglaCursoPreMatricula = "" then
		strFuncao = ""
		if strSubmitTurmaMaterial = "" then
			strFuncao = ""
		else
			strFuncao="onChange='ConsultaTurma(this.value)'"
		end if

	else
		strFuncao = "onchange='submit()'"
	end if
	if strCodParcelaInicial = "" then strCodParcelaInicial = "0"
	if strAnoInicial = "" then strAnoInicial = "0"
	if intCodSituacaoAluno = "" then intCodSituacaoAluno = "0"
	if intCodTipoParcela = "" then intCodTipoParcela = "0"

	sql = " SELECT DISTINCT SUBSTRING(T.NOMETURMA,1,2) AS SIGLA FROM SCF_DEBITOALUNO DA "
	sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = DA.COD_ALUNO AND A.Cod_Empresa = DA.Cod_Empresa "
	sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = DA.COD_TURMA AND T.COD_EMPRESA = DA.COD_EMPRESA "
	sql = sql & " WHERE DA.COD_EMPRESA = " & Session("CodEmpresa")
	sql = sql & " AND DA.PARCELA = " & strCodParcelaInicial
	sql = sql & " AND DA.ANO = " & strAnoInicial
	sql = sql & " AND A.COD_SITUACAOALUNO = " & intCodSituacaoAluno
	sql = sql & " AND cod_tipoParcela = " & intCodTipoParcela
	sql = sql & " AND cod_situacao_pagamento in (2,3,4) "
	sql = sql & " order by SUBSTRING(T.NOMETURMA,1,2) " 
	RS.OPEN SQL, CNN
%>
<select name="cmbSiglaCursoPreMatricula" id="cmbSiglaCursoPreMatricula" style="width:150pt" class="combo" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(strSiglaCursoPreMatricula) = trim(rs("sigla")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("sigla")& " " & strSelecionado &">" & rs("sigla") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>