<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 24/02/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Perido Equivalente
-->
<%	
	if intCodCurso = "" then intCodCurso = "0"
	
	sql = "SELECT Cod_Periodo, Cod_Curso, Descricao, Sequencia"
	sql = sql & " FROM SCA_PERIODO"
	sql = sql & " where cod_curso = " & intCodCurso
	sql = sql & " Order by Sequencia"
	RSAux.OPEN SQL, CNN
%>
<select name="cmbPeriodoEquivalente" id="cmbPeriodoEquivalente" style="width:70pt" class="combo"  onBlur="AlteraPeriodoRemanejamento(this,'<%=intCodAlunoDisciplina%>')">
	<option value="0">Selecione...</option>
	<%
	IF RSAux.EOF = FALSE THEN
		while not RSAux.eof
			if trim(intCodPeriodoEquivalente) = trim(RSAux("Cod_Periodo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & RSAux("Cod_Periodo")& " " & strSelecionado &">" & RSAux("Descricao") & "</option> "  & vbcrlf
			RSAux.movenext
		wend
	END IF
	RSAux.close
%>
</select>