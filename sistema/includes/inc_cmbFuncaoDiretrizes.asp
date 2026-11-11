<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/03/2010
	::	Desenvolvedores...: Sergio Borges - sergio@rsslucoesweb.com.br
	::	Objetivo Pagina...: Preenche combo funcao
-->

<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->

<%	
	if intCodCursoCombo = "" then intCodCursoCombo = "0"
	sql = "EXEC SP_MostraVagasRH_Funcao " & intCodEmpresaGrupo & "," & strAnoLetivo & "," & intSemestre & "," & intCodCursoCombo & "," & intCodTurnoColaborador & ",'" & strTipoModulacao & "','FUNCAO','" &strTipoLancamento& "'"
	RS.OPEN SQL, CNN
%>
<select name="cmbFuncao" id="cmbFuncao" style="width:200pt" class="combo" <%=strSubmitFuncao%> >
	<option value="0">Selecione...</option>
<%	strFuncao = ""
	IF RS.EOF = FALSE THEN
		funcao = 0
		modulacao = 0
		saldo = 0
		strDesbilitaAulas = ""
		strTipo_FuncaoSelecionadaCombo = ""
		while not rs.eof
			if trim(intCodFuncao) = trim(rs("CodFuncao")) then
				strSelecionado = " selected"
				strFuncaoCombo = rs("Desc_Funcao")
				funcao = rs("vagas_diretriz")
				intCodCursoFuncao = rs("cod_curso")
				modulacao = rs("ocupadas")
				strTipo_FuncaoSelecionadaCombo = rs("tipo_funcao")
				saldo = rs("vagas")
				if saldo <= 0 then 
					strDesbilitaAulas = "disabled"
					saldo = 0
				end if
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("CodFuncao")& " " & strSelecionado &">" & rs("desc_funcao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>