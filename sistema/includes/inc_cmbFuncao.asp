<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->

<%	
	if intCodFuncaoCategoria = "" then intCodFuncaoCategoria = "0"
	sql = "SELECT cod_funcao, desc_funcao, Situacao_Disciplinar, Tipo_Funcao"
	sql = sql & " FROM SRH_FUNCAOCOLABORADOR where 1=1"
	if strSomenteFuncionario = "S" then
		sql = sql & " AND (TIPO_FUNCAO ='FUNCIONARIO' or (TIPO_FUNCAO ='PROFESSOR' and Situacao_Disciplinar='I'))"
	end if
	if strTipoModulacao <> "" and strVerificaTipoFuncao = "" then
		sql = sql & " AND (TIPO_FUNCAO ='"&strTipoModulacao&"')"
	end if
	
	if strVerificaTipoFuncao = "PROFESSOR" then
		sql = sql & " and TIPO_FUNCAO = '" & strVerificaTipoFuncao & "'"
	end if
	if intCodFuncaoCategoria<>"0" then
		sql = sql & " and Cod_FuncaoCategoria = " & intCodFuncaoCategoria 
	end if
	sql = sql & " Order by desc_funcao"
	Situacao_Disciplinar=""
	TipoFuncao = ""
	RS.OPEN SQL, CNN
%>
<select name="cmbFuncao" id="cmbFuncao"  style="width:200pt"  class="form-control" <%=strSubmitFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodFuncao) = trim(rs("cod_funcao")) then
				strSelecionado = " selected"
				Situacao_Disciplinar = rs("Situacao_Disciplinar")
				TipoFuncao = rs("Tipo_Funcao")
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("cod_funcao")& " " & strSelecionado &">" & rs("desc_funcao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>