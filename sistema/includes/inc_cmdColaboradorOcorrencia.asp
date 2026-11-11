<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/07/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de Colaborador 
-->
<%	
	if strExecutarSubmitColaborador = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	sql = "	SELECT DISTINCT C.codigo, C.nome + ' (sub)' as nome, C.codFuncional "
	sql = sql & " FROM SRH_COLABORADOR_SUBSTITUTO CS"
	sql = sql & " inner join SRH_COLABORADOR C ON C.CODIGO = CS.CodColaboradorSubstituto"
	sql = sql & " where CS.CodEmpresaSubstituido = " & Session("CodEmpresa")
	sql = sql & " and C.situacao = 'A' "
	sql = sql & " and CS.Situacao = 'A'"

	'Filtra somente pelo periodo
	sql = sql & " and convert(datetime,convert(varchar, CS.DATAINICIAL , 103),103) >= convert(datetime, '" & strDataInicialModulacao & "',103) "
	sql = sql & " and convert(datetime,convert(varchar, CS.DATAFINAL, 103),103) <= convert(datetime, '" & strDataFinalModulacao & "',103) "
	sql = sql & " and convert(datetime, '" & strDataLancamento & "',103) between convert(datetime,convert(varchar, CS.DATAINICIAL , 103),103) AND convert(datetime,convert(varchar, CS.DATAFINAL, 103),103)"
	sql = sql & " and convert(datetime, '" & strDataLancamentoFinal & "',103) between convert(datetime,convert(varchar, CS.DATAFINAL , 103),103) AND convert(datetime,convert(varchar, CS.DATAFINAL, 103),103)"

	sql = sql & " union"
	sql = sql & " select DISTINCT C.codigo, C.nome, C.codFuncional"
	sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE M"
	sql = sql & " inner join SRH_COLABORADOR C ON C.CODIGO = M.COD_COLABORADOR"
	sql = sql & " where M.cod_empresa = " & Session("CodEmpresa")
	sql = sql & " and M.Status = 'A'"
	sql = sql & " and C.situacao = 'A'"
	sql = "SELECT Codigo, Nome"
	sql = sql & " FROM SRH_COLABORADOR"
	SQL = SQL & " WHERE codlotacao = " & Session("CodEmpresa")
	SQL = SQL & " AND situacao = 'A'"
	sql = sql & " Order by Nome"
	RS.OPEN SQL, CNN
%>
<select name="cmbColaborador" id="cmbColaborador" style="width:240pt" class="form-control" <%=strFuncao%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodColaborador) = trim(rs("Codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & ucase(rs("nome")) & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>