<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/07/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de Colaborador - Professor
-->
<%	
	if strExecutarSubmitProfessorSubstituto = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	if intCodEmpresaGrupoUsuario = "" or intCodEmpresaGrupoUsuario = "0" then intCodEmpresaGrupoUsuario = Session("CodEmpresa")

    strPermitedobras = ""
	sql = " SELECT C.codigo, C.nome, ISNULL(N.PermiteSubstituicao,'S') as PodeSubstituir, ISNULL(N.Permitedobras,'S') as PodeDobrar, "
	sql = sql & " (select COUNT(codigo) from SRH_COLABORADOR where cpf = c.cpf ) as contratos "
	sql = sql & " FROM SRH_COLABORADOR C "
	sql = sql & " left join SRH_NIVEL N ON N.Codigo = C.Cod_nivel "
	sql = sql & " WHERE c.codlotacao = " & intCodEmpresaGrupoUsuario
	sql = sql & " AND (C.CodCategoria = 1 or C.CodCategoria = 8) "
	sql = sql & " union "
	sql = sql & " select C.codigo, C.nome, ISNULL(N.PermiteSubstituicao,'S') as PodeSubstituir, ISNULL(N.Permitedobras,'S') as PodeDobrar, "
	sql = sql & " (select COUNT(codigo) from SRH_COLABORADOR where cpf = c.cpf ) as contratos "
	sql = sql & " from SRH_COLABORADOR_SUBSTITUTO CS "
	sql = sql & " inner join SRH_COLABORADOR C ON C.codigo=CS.CodColaboradorSubstituto and CS.Situacao='A' "
	sql = sql & " left join SRH_NIVEL N ON N.Codigo = C.Cod_nivel "
	sql = sql & " WHERE cs.CodEmpresaSubstituido=" & intCodEmpresaGrupoUsuario
	sql = sql & " order by c.nome "
	RS.OPEN SQL, CNN
%>
<select name="cmbProfessorSubstituto" id="cmbProfessorSubstituto" style="width:250pt" class="combo" <%=strFuncao%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodProfessorSubstituto) = trim(rs("Codigo")) then
				strSelecionado = " selected"
				if rs("PodeSubstituir") = "N" then 
				    %>
					<script>
                        alert("ATENÇÃO: Substituição não Autorizada. Verifique!");
                        window.navigate('FaltaColaborador_Cad.asp');
                    </script>
                    <% 
 					strSelecionado = ""
  				end if 
				if rs("contratos") > 1 then 
				    %>
					<script>
                        alert("ATENÇÃO: Não será permitida substituição para mais de um contrato. Verifique!");
                        window.navigate('FaltaColaborador_Cad.asp');
                    </script>
                    <% 
 					strSelecionado = ""
  				end if 
				strPermitedobras = rs("PodeDobrar")
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