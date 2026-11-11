<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Perido 
-->
<%	
	if strExecutarSubmitPeriodo = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	if trim(intCodCurso) = "" then intCodCurso = "0"
	if isnull(intCodCurso) then intCodCurso = "0"
	if strAnoLetivo = "" then strAnoLetivo = year(date)
	
	sql = "select distinct pe.Cod_Periodo, pe.Cod_Curso, pe.Descricao, pe.Sequencia"
	sql = sql & " from SCA_CURSO c"
	sql = sql & " inner join SCA_periodo pe on pe.Cod_Curso = c.Cod_curso"
	sql = sql & " inner join SCA_TURMA tu on tu.Cod_periodo = pe.Cod_Periodo"
	sql = sql & " where tu.AnoLetivo = " & strAnoLetivo
	sql = sql & " and tu.Situacao = 'A'"
	sql = sql & " and tu.Cod_Empresa = " & session("codEmpresa")
	sql = sql & " and pe.cod_curso = " & intCodCurso
	sql = sql & " Order by pe.Sequencia"
	
	RS.OPEN SQL, CNN
%>
<select name="cmbPeriodo" id="cmbPeriodo" class="form-control"  <%=strDisabilitaCombo%> <%=strFuncao%> <%=strPeriodo_Disabled%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodPeriodo) = trim(rs("Cod_Periodo")) then
				strSelecionado = " selected"
				strSerie = rs("Descricao")
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Cod_Periodo")& " " & strSelecionado &">" & rs("Descricao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>