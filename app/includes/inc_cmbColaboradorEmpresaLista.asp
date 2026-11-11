<%	

    if intCodEmpresaGrupo = "" then intCodEmpresaGrupo = "0" 
	
	sql = "select DISTINCT codigo as cod_colaborador, nome, codFuncional"
	sql = sql & " from SRH_COLABORADOR "
	sql = sql & " where codlotacao=" & intCodEmpresaGrupo
	sql = sql & " and Situacao = 'A' and codCategoria in (1,8)"
	sql = sql & " union"
	sql = sql & " select DISTINCT M.COD_COLABORADOR, C.nome + '(Sub)' as nome, C.codFuncional"
	sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE M"
	sql = sql & " inner join SRH_COLABORADOR C ON C.CODIGO = M.COD_COLABORADOR"
	sql = sql & " where M.cod_empresa = " & intCodEmpresaGrupo
	sql = sql & " and M.Status = 'A'"
	sql = sql & " and C.situacao = 'A'"
	sql = sql & " and M.Cod_Modulacao_Substituicao is not null"
	sql = sql & " union"
	sql = sql & " select DISTINCT M.COD_COLABORADOR, C.nome, C.codFuncional"
	sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE M"
	sql = sql & " inner join SRH_COLABORADOR C ON C.CODIGO = M.COD_COLABORADOR"
	sql = sql & " where M.cod_empresa = " & intCodEmpresaGrupo
	sql = sql & " and M.Status = 'A'"
	sql = sql & " and C.situacao = 'A'"
	sql = sql & " union"
	sql = sql & " select DISTINCT CODIGO AS COD_COLABORADOR, nome, codFuncional"
	sql = sql & " from SRH_COLABORADOR "
	sql = sql & " where nome like '%D E F I C I T%'"
	sql = sql & " order by 2"
	'response.write sql
	RSAux.OPEN SQL, CNN
	
%>
<select name="cmdColaboradorUsuario" <%if intCodEmpresaGrupo<>"0" then%>style="height: 300px;"  multiple="multiple"<%end if%> id="cmdColaboradorUsuario" class="form-control">
	<option value="0">Selecione...</option>
<%
	IF RSAux.EOF = FALSE THEN
		while not RSAux.eof
			if trim(intCodColaborador) = trim(RSAux("cod_colaborador")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & RSAux("cod_colaborador")& " " & strSelecionado &">" & RSAux("NOME") & " (" & RSAux("codFuncional") & ")" & "</option> "  & vbcrlf

			RSAux.movenext
		wend
	END IF
	RSAux.close
%>
</select><br><i>(aperte a tecla Ctrl e selecione mais de um colaborador)</i>