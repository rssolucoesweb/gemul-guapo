<%
'****************************************
'FUNCAÇÃO PARA MOSTRA MENU DINAMICAMENTE
'****************************************
dim codigo
dim controle

function menuPortal(codMenu, intCpfUsuario, intCodEmpresa, intCodPerfil, intAnoAtual, strMenuAdm, intCodModulo)

	'dim 	rs
	'dim 	idSeparador
	'dim	strImagem
	'dim	strLink
	'dim	strComentario
	'dim	strScript
	
	set rsMenu = server.CreateObject("adodb.recordset")  
	
'	if trim(strMenuAdm) = "S" then
'		sql="SELECT DISTINCT SEG_menu.*"
'		sql=sql & " FROM SEG_menu INNER JOIN SEG_perfil_menu ON SEG_menu.codigo = SEG_perfil_menu.codigo_SEG_menu"
'		sql=sql & " WHERE 	SEG_menu.codigo_SEG_menu="&codMenu
'		sql=sql & " AND SEG_perfil_menu.codigo_SEG_perfil=2"'cod perfil administrativo
'		sql=sql & " AND SEG_menu.codigo in (1,2,11,12,13,14,15,16,17,18,25,26)"'itens do menu administrativo
'		sql=sql & " ORDER BY SEG_menu.ordem, SEG_menu.codigo"
'		'response.Write("<br>passou1<br><br>")
'	else
'		if trim(intCodPerfilSuporte) = "" then
'			'carrega menu de acordo com o perfil do usuarios
'			sql="SELECT distinct SEG_menu.* "
'			sql=sql & " FROM SEG_menu INNER JOIN ((SEG_perfil INNER JOIN SEG_usuarios_acesso ON SEG_perfil.codigo = SEG_usuarios_acesso.codigo_SEG_perfil) INNER JOIN SEG_perfil_menu ON SEG_perfil.codigo = SEG_perfil_menu.codigo_SEG_perfil) ON SEG_menu.codigo = SEG_perfil_menu.codigo_SEG_menu"
'			sql=sql & " WHERE 	SEG_usuarios_acesso.cpf_SEG_usuarios=" & intCpfUsuario
'			sql=sql & " AND 	SEG_menu.codigo_SEG_menu=" & codMenu
'			sql=sql & " AND 	SEG_menu.codigo not in (1,2,11,12,13,14,15,16,17,18,25,26)"'itens do menu administrativo
'			sql=sql & " AND 	SEG_usuarios_acesso.codEmpresa = " & intCodEmpresa
'			sql=sql & " AND 	SEG_menu.codigo_SEG_modulo = " & intCodModulo
'			sql=sql & " order by SEG_menu.ordem, SEG_menu.codigo"
'		'response.Write("<br>passou2<br><br>")
'		else
			sql="SELECT DISTINCT SEG_menu.*"
			sql=sql & " FROM SEG_menu INNER JOIN SEG_perfil_menu ON SEG_menu.codigo = SEG_perfil_menu.codigo_SEG_menu"
			sql=sql & " WHERE 	SEG_menu.codigo_SEG_menu="&codMenu
			'sql=sql & " AND 	SEG_menu.codigo not in (1,2,11,12,13,14,15,16,17,18,25,26)"'itens do menu administrativo
			sql=sql & " AND 	SEG_perfil_menu.codigo_SEG_perfil="&intCodPerfil
			sql=sql & " AND 	SEG_menu.codigo_SEG_modulo = " & intCodModulo
			sql=sql & " ORDER BY SEG_menu.ordem, SEG_menu.codigo"
'		response.Write("<br>" & sql & "<br><br>")
'		'response.Write("<br>passou3<br><br>")
'		end if
'	end if
'	response.Write("parrou")
'	response.End()
	vetMenu = null
	rsMenu.open sql, cnn
	if not rsMenu.eof then
		vetMenu = rsMenu.getRows
	end if
	rsMenu.close
		
	if isArray(vetMenu) then
		controle = 0
		'while not rs.eof
		for i=0 to ubound(vetMenu,2)

			codigoRSMenu  	= vetMenu(0,i)  'rsMenu("codigo")
			imagemRSMenu  	= vetMenu(5,i)  'rsMenu("imagem")
			linkRSMenu 	 	= vetMenu(4,i)  'rsMenu("link")
			descricaoRSMenu	= vetMenu(3,i)  'rsMenu("descricao")

			if cInt(codigoRSMenu)>cInt(codMenu) then
				strImagem = ""
				strLink   = "#"
				strComentario = ""
				strScript = vetMenu(6,i) 'rsMenu("script")
				if isnull(imagemRSMenu) = false then
					strImagem = "itemIcon='" & imagemRSMenu & "'"
				end if
				
				if not isnull(linkRSMenu) then
					if trim(linkRSMenu) <> "" then strLink = linkRSMenu
				end if				
				if controle = 0 then
					Session("strMontraMenuPortal") = Session("strMontraMenuPortal") & "<ul>" & vbcrlf
				end if				
				Session("strMontraMenuPortal") = Session("strMontraMenuPortal") & "<li>" & vbcrlf
				Session("strMontraMenuPortal") = Session("strMontraMenuPortal") & "<a href='" & strLink & "' " & strScript & ">"& descricaoRSMenu &"</a>" & vbcrlf
				menuPortal codigoRSMenu, intCpfUsuario, intCodSia, intCodPerfil, intAnoAtual, strMenuAdm, intCodModulo
				
				Session("strMontraMenuPortal") = Session("strMontraMenuPortal") & "</li>" & vbcrlf
			end if
			controle = 1
			
			'rsMenu.movenext
		next
		'wend
		vetMenu = null
		Session("strMontraMenuPortal") = Session("strMontraMenuPortal") & "</ul>" & vbcrlf
	end if

end function	
'************************************************
'************************************************
%>