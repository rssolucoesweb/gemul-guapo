<%
if  Session("CodEmpresa") <> "" and Session("cpfColaborador") <> "" then

	if Session("PerfilUsuarioOrigem") = "" then Session("PerfilUsuarioOrigem") = Session("PerfilUsuario")
	
    'Soma total de funcão no cadastro de colaborador
	strTotalFuncao = 0
	sql = " Select isnull(COUNT(C.codigo),'0') AS TOTAL_FUNCAO  "
	sql = sql & " from SRH_COLABORADOR C "  
	sql = sql & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = C.codFuncao "
	sql = sql & " INNER JOIN SRH_TURNO TU ON TU.COD_TURNO = C.CodTurno "  
	sql = sql & " where c.cpf = '" & Session("cpfColaborador") & "'" 
	sql = sql & " and c.Situacao = 'A' "  
	RSAux.OPEN SQL, CNN
	IF RSAux.EOF = FALSE THEN
	   strTotalFuncao = RSAux("TOTAL_FUNCAO")
	else
	   strTotalFuncao = 0
	END IF
	RSAux.close
	
	'Soma total de funcão no perfil extra
	sql = " Select isnull(COUNT(AUE.COD_CATEGORIA),'0') AS TOTAL_FUNCAO "
	sql = sql & " from Seg_Acessos_Usuario_Excessoes AUE " 
	sql = sql & " where AUE.ACES_USUA_CODG = '" & session("UsuarioWeb") & "'" 
	RSAux.OPEN SQL, CNN
	IF RSAux.EOF = FALSE THEN
	   strTotalFuncao = strTotalFuncao + RSAux("TOTAL_FUNCAO")
	END IF
	RSAux.close

    if strTotalFuncao > 0 then
	
		intCodigoColaboradorContrato  = trim(request.Form("cmbCodigoColaboradorContrato"))

		Session("Seg_CodColaborador")	= ""
		Session("Seg_CodFuncional")		= ""
		Session("Seg_CodCategoria")		= ""
		Session("Seg_Funcao")			= ""
		Session("Seg_CodLotacao")		= ""
		Session("Seg_Turno")			= ""
		Session("Seg_Perfil")			= ""
	

		sql = " Select C.codigo, c.codLotacao, C.codFuncional, C.CodCategoria, FC.Desc_Funcao AS Funcao, C.CodTurno, TU.Desc_Turno, '0' as Perfil "
		sql = sql & " from SRH_COLABORADOR C "  
		sql = sql & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = C.codFuncao "
		sql = sql & " INNER JOIN SRH_TURNO TU ON TU.COD_TURNO = C.CodTurno "  
		sql = sql & " where c.cpf = '" & Session("cpfColaborador") & "'" 
		sql = sql & " and c.Situacao = 'A' " 
		sql = sql & " and c.codLotacao = " &  Session("CodEmpresa")
		sql = sql & " and c.CodFuncao not in (Select Cod_Funcao from Seg_Acessos_Usuario_Excessoes where ACES_USUA_CODG = 'MARIA.TRINDADE' and Cod_Funcao = c.codFuncao) "
		sql = sql & " and c.CodTurno not in (Select Cod_Turno from Seg_Acessos_Usuario_Excessoes where ACES_USUA_CODG = 'MARIA.TRINDADE' and Cod_Funcao = c.CodTurno) "
		sql = sql & " UNION "
		sql = sql & " Select " 
		sql = sql & " (SELECT TOP 1 CODIGO FROM SRH_COLABORADOR WHERE CODLOTACAO = AUE.COD_EMPRESA AND cpf =  '" & Session("cpfColaborador") & "') AS CODIGO, "
		sql = sql & " (SELECT TOP 1 CODLOTACAO FROM SRH_COLABORADOR WHERE CODLOTACAO = AUE.COD_EMPRESA AND cpf =  '" & Session("cpfColaborador") & "') AS CODLOTACAO, "
		sql = sql & " (SELECT TOP 1 codFuncional FROM SRH_COLABORADOR WHERE CODLOTACAO = AUE.COD_EMPRESA AND cpf =  '" & Session("cpfColaborador") & "') AS codFuncional, "
		sql = sql & " AUE.COD_CATEGORIA, "
		sql = sql & " FC.Desc_Funcao AS Funcao, "
		sql = sql & " AUE.Cod_Turno AS CodTurno, "
		sql = sql & " TU.Desc_Turno, "
		sql = sql & " ACES_PERF_CODG as Perfil "
		sql = sql & " from Seg_Acessos_Usuario_Excessoes AUE " 
		sql = sql & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = AUE.Cod_Funcao "
		sql = sql & " INNER JOIN SRH_TURNO TU ON TU.COD_TURNO = AUE.Cod_Turno "  
		sql = sql & " where AUE.ACES_USUA_CODG = '" & session("UsuarioWeb") & "'" 
		sql = sql & " and AUE.cod_empresa = " &  Session("CodEmpresa")
		
		'response.Write(sql)
		'response.End()
		
		RSAux.OPEN SQL, CNN
		%>
		<select name="cmbCodigoColaboradorContrato" id="cmbCodigoColaboradorContrato" style="width:390pt" class="combo" onchange="submit()">
		<option value="0">Selecione...</option>
		<%
		
			IF RSAux.EOF = FALSE THEN
				while not RSAux.eof
					
					if trim(intCodigoColaboradorContrato) = trim(RSAux("codigo")) & trim(RSAux("CodTurno"))  then
					
						strSelecionado = " selected"
						
						Session("Seg_CodColaborador")	= RSAux("codigo")
						Session("Seg_CodFuncional")		= RSAux("codFuncional")
						Session("Seg_CodCategoria")		= RSAux("CodCategoria")
						Session("Seg_Funcao")			= RSAux("Funcao")
						Session("Seg_CodLotacao")		= RSAux("codLotacao")
						Session("Seg_Turno")			= RSAux("Desc_Turno")
						Session("Seg_Perfil")			= RSAux("Perfil")
					else
						
						strSelecionado = ""
					end if
					response.write "<option value=" & trim(RSAux("codigo")) & trim(RSAux("CodTurno")) & " " & strSelecionado &">" &  RSAux("Funcao") & " - " & RSAux("Desc_Turno") & " / Matrícula: " & RSAux("codFuncional") & "</option> "  & vbcrlf
					RSAux.movenext
				wend
			END IF
			RSAux.close
			%>
		</select>
      	<%
		if Session("Seg_Perfil") <> "0" and Session("Seg_Perfil") <> "" then
			response.write " Perfil Especial "
			Session("PerfilUsuario") = Session("Seg_Perfil")
		else
			Session("PerfilUsuario") = Session("PerfilUsuarioOrigem")
	    end if
		
	end if
end if %>



