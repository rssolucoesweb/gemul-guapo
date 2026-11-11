<%
'response.write "<br>ce:" & Session("CodEmpresa")
'response.write "<br>ce:" & Session("cpfColaborador")
'response.write "<br>ce:" & Session("CodColaboradorSubstituicao")

if  Session("CodEmpresa") <> "" and Session("cpfColaborador") <> "" then 'and Session("CodColaboradorSubstituicao") = "" then
	intCodigoColaboradorContrato = 0
	if Session("PerfilUsuarioOrigem") = "" then Session("PerfilUsuarioOrigem") = Session("PerfilUsuario")
	
    'Soma total de funcão no cadastro de colaborador
	strTotalFuncao = 0
	sql = " Select isnull(COUNT(C.codigo),'0') AS TOTAL_FUNCAO  "
	sql = sql & " from SRH_COLABORADOR C "  
	sql = sql & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = C.codFuncao "
	sql = sql & " INNER JOIN SRH_TURNO TU ON TU.COD_TURNO = C.CodTurno "  
	sql = sql & " where c.cpf = '" & Session("cpfColaborador") & "'" 
	sql = sql & " and c.Situacao = 'A' "  
	'response.write sql
	RSAux.OPEN SQL, CNN
	IF RSAux.EOF = FALSE THEN
	   strTotalFuncao = RSAux("TOTAL_FUNCAO")
	else
	   strTotalFuncao = 0
	END IF
	RSAux.close
	
    if strTotalFuncao > 0 then
	
		intCodigoColaboradorContrato  = trim(request.Form("cmbCodigoColaboradorContrato"))
		'response.write "intCodigoColaboradorContrato:" & intCodigoColaboradorContrato
		
		if intCodSubstituicao = "0" then
			Session("Seg_CodColaborador")	= ""
			Session("Seg_CodFuncional")		= ""
			Session("Seg_CodCategoria")		= ""
			Session("Seg_Funcao")			= ""
			Session("Seg_CodLotacao")		= ""
			Session("Seg_Turno")			= ""
			Session("Seg_Perfil")			= ""
			Session("Seg_Perfil_especial")	= ""
		end if
		
		sql = " Select C.codigo, c.codLotacao, C.codFuncional, C.CodCategoria, FC.Desc_Funcao AS Funcao, C.CodTurno, TU.Desc_Turno, '0' as Perfil, 'N' as especial "
		sql = sql & " from SRH_COLABORADOR C "  
		sql = sql & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = C.codFuncao "
		sql = sql & " INNER JOIN SRH_TURNO TU ON TU.COD_TURNO = C.CodTurno "  
		'sql = sql & " where c.cpf = '" & Session("cpfColaborador") & "'" 
		sql = sql & " where c.codigo_SEG_USUARIOS_SISTEMA = '" & Session("UsuarioWeb") & "'"
		sql = sql & " and c.Situacao = 'A' " 
		IF Session("CodEmpresa")<>"0" THEN
			sql = sql & " and c.codLotacao = " &  Session("CodEmpresa")
		END IF
		'sql = sql & " and c.CodFuncao not in (Select Cod_Funcao from Seg_Acessos_Usuario_Excessoes where ACES_USUA_CODG = '" & session("UsuarioWeb") & "' and Cod_Funcao = c.codFuncao) "
		'sql = sql & " and c.CodTurno not in (Select Cod_Turno from Seg_Acessos_Usuario_Excessoes where ACES_USUA_CODG = '" & session("UsuarioWeb") & "' and Cod_Funcao = c.CodTurno) "

		sql = sql & " and c.CodFuncao not in (SELECT DISTINCT M.Cod_funcao"
		sql = sql & " 						  FROM SRH_COLABORADOR C"
		sql = sql & " 						  INNER JOIN SRH_MODULACAO_DISCIPLINAR_DOCENTE M ON M.COD_COLABORADOR = C.CODIGO"
		sql = sql & " 						  INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = M.cod_Funcao "
		sql = sql & " 						  INNER JOIN SRH_TURNO TU ON TU.COD_TURNO = C.CodTurno "
		'sql = sql & " 						  WHERE C.CPF = '" & Session("cpfColaborador") & "'" 
		sql = sql & " 						  where c.codigo_SEG_USUARIOS_SISTEMA = '" & Session("UsuarioWeb") & "'"
		sql = sql & " 						  AND M.Status = 'A'"
		
		IF Session("CodEmpresa")<>"0" THEN
			sql = sql & " 					  AND M.cod_empresa = " &  Session("CodEmpresa")
		END IF		
		sql = sql & " 						  ) "	
		
		sql = sql & " UNION "	
		
		sql = sql & " SELECT DISTINCT M.Cod_Colaborador, M.cod_empresa, C.codFuncional, "

		sql = sql & " CASE"
		sql = sql & " 	WHEN FC.TIPO_FUNCAO = 'PROFESSOR' THEN 1"
		sql = sql & " 	WHEN FC.TIPO_FUNCAO = 'FUNCIONARIO' THEN 2"
		sql = sql & " ELSE"
		sql = sql & " 	2"
		sql = sql & " END AS CodCategoria,"
		
		sql = sql & " CASE"
		sql = sql & " 	WHEN FC.TIPO_FUNCAO = 'PROFESSOR' THEN 'PROFESSOR(A)'"
		sql = sql & " 	WHEN FC.TIPO_FUNCAO = 'FUNCIONARIO' THEN FC.Desc_Funcao"
		sql = sql & " ELSE"
		sql = sql & " 	FC.Desc_Funcao"
		sql = sql & " END AS Funcao, "
		
		sql = sql & " M.Cod_Turno as CodTurno, TU.Desc_Turno, '0' as Perfil, 'N' as especial "
		
		sql = sql & " FROM SRH_COLABORADOR C"
		sql = sql & " INNER JOIN SRH_MODULACAO_DISCIPLINAR_DOCENTE M ON M.COD_COLABORADOR = C.CODIGO"
		sql = sql & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = M.cod_Funcao "
		sql = sql & " INNER JOIN SRH_TURNO TU ON TU.COD_TURNO = M.Cod_Turno "
		'sql = sql & " WHERE C.CPF = '" & Session("cpfColaborador") & "'" 	

		sql = sql & " where c.codigo_SEG_USUARIOS_SISTEMA = '" & Session("UsuarioWeb") & "'"
		sql = sql & " AND M.Status = 'A'"
		sql = sql & " AND C.SITUACAO = 'A'"
		sql = sql & " AND M.Cod_Modulacao_Substituicao IS NULL"
		IF Session("CodEmpresa")<>"0" THEN
			sql = sql & " and M.cod_empresa = " &  Session("CodEmpresa")
		END IF
			
'RESPONSE.WRITE "<HR>" & SQL & "<HR>"
		RSAux.OPEN SQL, CNN,3,1
		Session("CodColaboradorContrato") = "0"
		%>
		<label for="exampleInputPassword1"> Contrato</label>
		<select name="cmbCodigoColaboradorContrato" id="cmbCodigoColaboradorContrato" style="width:390pt" class="form-control" onchange="submit()">
		<%
			
			IF RSAux.EOF THEN
				response.write "<option value='0'>---</option> "  & vbcrlf
				intCodigoColaboradorContrato = "0"
				Session("CodColaboradorContrato") = "0"			
			ELSE
				registros = RSAUX.recordCount
				while not RSAux.eof
					if intCodigoColaboradorContrato = "0" or intCodigoColaboradorContrato = "" then intCodigoColaboradorContrato = trim(RSAux("codigo")) & trim(RSAux("CodTurno")) 
					'intCodigoColaboradorContrato = trim(RSAux("codigo")) & trim(RSAux("CodTurno")) 
					if trim(intCodigoColaboradorContrato) = trim(RSAux("codigo")) & trim(RSAux("CodTurno"))  then
						strSelecionado = " selected"
						
						Session("Seg_CodColaborador")	= RSAux("codigo")
						Session("Seg_CodFuncional")		= RSAux("codFuncional")
						Session("Seg_CodCategoria")		= RSAux("CodCategoria")
						Session("Seg_Funcao")			= RSAux("Funcao")
						Session("Seg_CodLotacao")		= RSAux("codLotacao")
						Session("Seg_Turno")			= RSAux("Desc_Turno")
						Session("Seg_Perfil")			= RSAux("Perfil")
						Session("Seg_Perfil_especial")			= RSAux("especial")
						if Session("Seg_Perfil") = "17" then 'perfil de coordenador
							Session("Seg_CodColaborador")	= ""
							Session("Seg_CodFuncional")		= ""
						end if
						Session("CodColaboradorContrato") = RSAux("codigo")
					else
						strSelecionado = ""
					end if
					if cint(registros) = 1 then
						Session("Seg_CodColaborador")	= RSAux("codigo")
						Session("Seg_CodFuncional")		= RSAux("codFuncional")
						Session("Seg_CodCategoria")		= RSAux("CodCategoria")
						Session("Seg_Funcao")			= RSAux("Funcao")
						Session("Seg_CodLotacao")		= RSAux("codLotacao")
						Session("Seg_Turno")			= RSAux("Desc_Turno")
						Session("Seg_Perfil")			= RSAux("Perfil")
						Session("Seg_Perfil_especial")			= RSAux("especial")
						if Session("Seg_Perfil") = "17" then 'perfil de coordenador
							Session("Seg_CodColaborador")	= ""
							Session("Seg_CodFuncional")		= ""
						end if
						Session("CodColaboradorContrato") = RSAux("codigo")
						intCodigoColaboradorContrato = trim(RSAux("codigo")) & "" & trim(RSAux("CodTurno"))
					end if
					response.write "<option value=" & trim(RSAux("codigo")) & trim(RSAux("CodTurno")) & " " & strSelecionado &">" &  RSAux("Funcao") & " - " & RSAux("Desc_Turno") & " / Matr&iacute;cula: " & RSAux("codFuncional") & "</option> "  & vbcrlf
					RSAux.movenext
				wend
			END IF
			RSAux.close
			%>
		</select>
      	<%
		if Session("CodColaboradorSubstituicao") = "" then
			if Session("Seg_Perfil") <> "0" and Session("Seg_Perfil") <> "" then
				response.write " Perfil Especial "
				Session("PerfilUsuario") = Session("Seg_Perfil")
			else
				Session("PerfilUsuario") = Session("PerfilUsuarioOrigem")
			end if
		end if
		'RESPONSE.WRITE "<BR>" & trim(request.Form("cmbCodigoColaboradorContrato"))
		'RESPONSE.WRITE "<BR>" & intCodigoColaboradorContrato
		
	end if
end if 

'response.write "<br>intCodigoColaboradorContrato:" & intCodigoColaboradorContrato
%>