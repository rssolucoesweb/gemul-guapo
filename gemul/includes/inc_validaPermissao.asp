<%Server.ScriptTimeOut=5000%>
<%
Session("DescPerfilUsuario") = ""

function validaPermissao(usuario, sistema)

	sql = " SELECT Usua_Codg, Usua_Stat, Usua_Info_Senha, Perf_Codg, Perf_Desc "
	sql = sql & " FROM SEG_Usuarios_Sistema, Seg_Acessos_Usuario, Seg_Perfis_Sistema "
	sql = sql & " Where Perf_Codg = Aces_Perf_Codg "
	sql = sql & " And Seg_Acessos_Usuario.Aces_Usua_Codg = SEG_Usuarios_Sistema.Usua_Codg "
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