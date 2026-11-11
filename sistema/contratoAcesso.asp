<%
if  intCodSubstituicao <> "0" then
		
	sql = " Select C.codigo, c.codLotacao, C.codFuncional, C.CodCategoria, FC.Desc_Funcao AS Funcao "
	sql = sql & " from SRH_COLABORADOR C "  
	sql = sql & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = C.codFuncao "
	sql = sql & " INNER JOIN SRH_TURNO TU ON TU.COD_TURNO = C.CodTurno "  
	sql = sql & " where c.codigo = " & intCodSubstituicao
	
	sql = sql & " and c.CodFuncao not in (SELECT DISTINCT M.Cod_funcao"
	sql = sql & " 						  FROM SRH_COLABORADOR C"
	sql = sql & " 						  INNER JOIN SRH_MODULACAO_DISCIPLINAR_DOCENTE M ON M.COD_COLABORADOR = C.CODIGO"
	sql = sql & " 						  INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = M.cod_Funcao "
	sql = sql & " 						  INNER JOIN SRH_TURNO TU ON TU.COD_TURNO = C.CodTurno "
	sql = sql & " 						  WHERE C.codigo = " & intCodSubstituicao
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
	sql = sql & " END AS Funcao"
	
	sql = sql & " FROM SRH_COLABORADOR C"
	sql = sql & " INNER JOIN SRH_MODULACAO_DISCIPLINAR_DOCENTE M ON M.COD_COLABORADOR = C.CODIGO"
	sql = sql & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = M.cod_Funcao "
	sql = sql & " INNER JOIN SRH_TURNO TU ON TU.COD_TURNO = M.Cod_Turno "
	sql = sql & " WHERE C.codigo = " & intCodSubstituicao
	sql = sql & " AND M.Status = 'A'"
	sql = sql & " AND C.SITUACAO = 'A'"
	sql = sql & " AND M.Cod_Modulacao_Substituicao IS NULL"
	IF Session("CodEmpresa")<>"0" THEN
		sql = sql & " and M.cod_empresa = " &  Session("CodEmpresa")
	END IF
		
	RSAux.OPEN SQL, CNN,3,1
	%>
	<label for="exampleInputPassword1"> Função</label>
	<select name="cmbCodigoColaboradorFuncao" id="cmbCodigoColaboradorFuncao" style="width:390pt" class="form-control" onchange="submit()">
	<%
		
		IF RSAux.EOF THEN
			response.write "<option value='0'>---</option> "  & vbcrlf
			intCodigoColaboradorContrato = "0"
			Session("CodColaboradorContrato") = "0"			
		ELSE
			registros = RSAUX.recordCount
			while not RSAux.eof
				if trim(intCodigoColaboradorContrato) = trim(RSAux("codigo"))  then
					strSelecionado = " selected"
					
					Session("Seg_CodColaborador")	= RSAux("codigo")
					Session("Seg_CodFuncional")		= RSAux("codFuncional")
					Session("Seg_CodCategoria")		= RSAux("CodCategoria")
					Session("Seg_Funcao")			= RSAux("Funcao")
					Session("Seg_CodLotacao")		= RSAux("codLotacao")
					Session("Seg_Turno")			= RSAux("Desc_Turno")
					Session("Seg_Perfil")			= RSAux("Perfil")
					Session("Seg_Perfil_especial")	= RSAux("especial")
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
					intCodigoColaboradorContrato = trim(RSAux("codigo")) 
				end if
				response.write "<option value=" & trim(RSAux("codigo")) & " " & strSelecionado &">" &  RSAux("Funcao") & " / Matr&iacute;cula: " & RSAux("codFuncional") & "</option> "  & vbcrlf
				RSAux.movenext
			wend
		END IF
		RSAux.close
		%>
	</select>
      	<%
end if 
%>