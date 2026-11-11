<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Curso 
-->
<%	

	if strExecutarSubmitModulacaoReferencia = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	sql = "SELECT Codigo, AnoReferencia, MesReferencia, SemestreReferencia, Data_Inicial, Data_Final"
	sql = sql & " FROM SRH_MODULACAO_REFERENCIA"
	sql = sql & " where Cod_grupo = " & Session("CodGrupo")
	if strPeriodoModulacaoHistorico = "" then	
	   if ucase(session("usuarioWeb")) <> "CLEOVIS" AND ucase(session("usuarioWeb")) <> "SERGIO" AND ucase(session("usuarioWeb")) <> "FERNANDO.DOMINGOS" AND ucase(session("usuarioWeb")) <> "NIVALDO" THEN
		sql = sql & " and Situacao = 'A' "
	END IF
	end if   

 			
	sql = sql & " order by Data_Final desc"
	rs.open sql, cnn
%>
<select name="cmbModulacaoReferencia" id="cmbModulacaoReferencia" style="width:150pt" class="form-control" <%=strFuncao%>>
<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodModulacaoReferencia) = trim(rs("Codigo")) then
				intAnoLetivo  			= rs("AnoReferencia")
				intSemestre 			= rs("SemestreReferencia")
				strMes 					= rs("MesReferencia")
				strDataInicialModulacao	= rs("Data_Inicial")
				strDataFinalModulacao	= rs("Data_Final")
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			semRef = "/" & rs("SemestreReferencia")
			if trim(rs("SemestreReferencia")) = "3" then semRef = ""
			response.write "<option value=" & rs("Codigo")& " " & strSelecionado &">" & rs("AnoReferencia")& semRef & " - " & ucase(monthname(rs("MesReferencia"))) & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>