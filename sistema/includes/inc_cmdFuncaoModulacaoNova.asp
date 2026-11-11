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

	sql = " select distinct FC.Cod_Funcao, FC.Desc_Funcao, FC.tipo_funcao, FC.Situacao_Disciplinar "
	sql = sql & " from SRH_DIRETRIZES D "
	sql = sql & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = D.CodFuncao "
	sql = sql & " WHERE FC.Cod_grupo = " & Session("CodGrupo")
	if trim(strTipoModulacao) <> "" then 
		sql = sql & " AND FC.Tipo_Funcao = '" & trim(strTipoModulacao) & "'"
	end if
	if session("NivelPermissao") = "A" then
	else
		if Situacao_Disciplinar = "I" and PorPeriodo<>"S" then 
			sql = sql & " AND FC.Cod_Funcao = " & intcodFuncaoCadastro
		end if
		if Situacao_Disciplinar = "D" then
			'perfil de diretor não poderá mexer no Disciplinares
			sql = sql & " and 1=2"
		end if
		if intcodFuncaoCadastro <> "" then
			if Situacao_Disciplinar = "I" and PorPeriodo<>"S" then
				sql = sql & " and FC.Cod_Funcao = " & intcodFuncaoCadastro
			end if
		end if
	end if
	sql = sql & " ORDER BY FC.Desc_Funcao " 
	'response.write sql
	RS.OPEN SQL, CNN
%>
<select name="cmbFuncao" id="cmbFuncao" style="width:250pt" class="form-control" <%=strFuncao%> >
	<option value="0">Selecione...</option>
<%
	strEncontrou = "N"
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodFuncao) = trim(rs("Cod_Funcao")) then
				strSelecionado = " selected"
				strTipoLancamento = trim(rs("Situacao_Disciplinar")) 
				tipo_funcao = trim(rs("tipo_funcao")) 
				strEncontrou = "S"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Cod_Funcao")& " " & strSelecionado &">" &  rs("Desc_Funcao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
<%
if intCodFuncao <> "0" and intCodFuncao<>"" and strEncontrou = "N" then
	%>
	<option selected="selected" value="<%=intCodFuncao%>"><%=strNomeFuncao%></option>
	<%
end if	
%>
</select>