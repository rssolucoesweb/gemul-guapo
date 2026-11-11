<%Server.ScriptTimeOut=5000%>
<%

Session("DescPerfilUsuario") = ""
if session("UsuarioWeb")="" then response.Redirect("/login.asp")

function validaPermissao(usuario, sistema)
	
	sql = "SELECT Aces_Usua_Codg, Cod_Categoria, Aces_Perf_Codg "
	sql = sql & " FROM Seg_Acessos_Usuario_Excessoes "
	sql = sql & " WHERE Aces_Usua_Codg = '" & session("UsuarioWeb") & "'"
	sql = sql & " AND Cod_Empresa = " & session("CodEmpresa")
	rsAux.open sql, cnn
	if not rsAux.eof then
		strTabelaAcesso = "SEG_ACESSOS_USUARIO_EXCESSOES"
	else		
		strTabelaAcesso = "SEG_ACESSOS_USUARIO"
	end if
	rsAux.close

	sql = " SELECT Usua_Codg, Usua_Stat, Usua_Info_Senha, Perf_Codg, Perf_Desc "
	sql = sql & " FROM SEG_Usuarios_Sistema, "&strTabelaAcesso&", Seg_Perfis_Sistema "
	sql = sql & " Where Perf_Codg = Aces_Perf_Codg "
	sql = sql & " And "&strTabelaAcesso&".Aces_Usua_Codg = SEG_Usuarios_Sistema.Usua_Codg "
	sql = sql & " And Usua_Codg = '" & usuario & "' "
	sql = sql & " and Seg_Perfis_Sistema.perf_sist_sigl='" & sistema &"'"
	rsAux.open sql, cnn
	
	if rsAux.eof = false then
		intContador = "1"
		permissaoAux = ""
		
		while not rsAux.eof
			if intContador = "1" then
					permissaoAux = cstr(permissaoAux) + cstr(rsAux("Perf_Codg"))
			else
					permissaoAux = cstr(permissaoAux) + cstr(","&rsAux("Perf_Codg"))
			end if
			
			strPerf_Desc = rsAux("Perf_Desc")
			
			rsAux.movenext
			intContador = intContador +  "1"
		wend
		
		validaPermissao = permissaoAux
		Session("DescPerfilUsuario")		= strPerf_Desc
	else			
		validaPermissao = "0"
	end if
	rsAux.close
end function
%>