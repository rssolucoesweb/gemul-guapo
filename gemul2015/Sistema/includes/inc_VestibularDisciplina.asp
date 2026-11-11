<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 18/05/2009
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Disciplina Vestibular
-->
<%	
	sql = "SELECT Codigo, Descricao, Desc_Historico"
	sql = sql & " FROM SCA_VESTIBULAR_DISCIPLINA"
	SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
	sql = sql & " Order by Desc_Historico"
	RS.OPEN SQL, CNN
%>
<select name="cmbVestibularDisciplina" id="cmbVestibularDisciplina" style="width:200pt" class="combo">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodVestibularDisciplina) = trim(rs("Codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Codigo")& " " & strSelecionado &">" & rs("Desc_Historico") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>