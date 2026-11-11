<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 26/09/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Diretrizes
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	'cnn.begintrans
	acao 						= Trim(Request.QueryString("acao"))	
	intCodEmpresa				= session("codEmpresa")

	intCodTurma 			= Trim(Request.Form("txtCodigo"))
	intCodItem 				= Trim(Request.QueryString("CodigoItem"))	
	strAnoLetivo 			= request("txtAnoLetivo")
	intSemestre  			= Trim(Request.Form("cmbSemestre"))
	intCodFuncao 	    	= TRIM(Request.Form("cmbFuncao"))
	strVagas	 		    = TRIM(Request.Form("cmbVagas"))
	strTipoModulacao		= Trim(Request.Form("optTipoModulacao"))
	intCodTurno 	    	= TRIM(Request.Form("cmbTurnoRH"))
	intCodTipoEmpresa		= Trim(Request("cmbTipoEmpresa"))
	strModularGrupo			= Trim(Request("ModularGrupo"))
	strFLagTurnoTurma		= Trim(Request("txtFLagTurnoTurma"))
	
	
	if intCodTurno = "" then intCodTurno = "0"

	if acao="I" then
	
		strMensagem = "Registro Salvo com sucesso..."

		if strModularGrupo <> "S" then

			sql = " SELECT Cod_Funcao"
			sql = sql & " FROM SRH_TURMA_MODULACAO_FUNCAO " 
			sql = sql & " where Cod_Turma = " & intCodTurma
			sql = sql & " and Cod_Funcao = " & intCodFuncao
			sql = sql & " and ISNULL(cod_TurnoFuncao,'0') = " & intCodTurno
			rs.open sql, cnn
			if rs.eof = false then
				'cnn.rollbackTrans
				%>
				<script>
					alert("Funcao ja Informada para essa turma. Verifique!");
					window.history.back();
				</script>
				<%
				response.end
			end if 
			rs.close
	
	
			sql = " SELECT T.Cod_turma FROM SCA_TURMA T " 
			sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
			sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) and TRH.Cod_Grupo = " & Session("CodGrupo")	  
			sql = sql & " Where T.Cod_GradeCurricular = (SELECT Cod_GradeCurricular FROM SCA_TURMA WHERE Cod_Turma = " & intCodTurma & ")"
			sql = sql & " and T.AnoLetivo = " & strAnoLetivo
			sql = sql & " and T.Cod_Semestre = " & intSemestre
			if strFLagTurnoTurma <> "I" then
				sql = sql & " and TRH.Cod_Turno  = " & intCodTurno
			end if
			rs.open sql, cnn
			if rs.eof = false then
				while not rs.eof
				
					sql = "Update SCA_TURMA Set"
					sql = sql & " Cod_Tipo_Unidade = " & intCodTipoEmpresa & ","
					sql = sql & " Cod_Tipo_Modulacao = '" & strTipoModulacao & "'"
					sql = sql & " Where Cod_Turma = " & rs("Cod_turma")
					cnn.execute sql
					GravarLog sql
			
					sql = " SELECT Cod_turma FROM SRH_TURMA_MODULACAO_FUNCAO " 
					sql = sql & " Where Cod_Turma = " & rs("Cod_turma")
					sql = sql & " and Cod_Funcao = " & intCodFuncao
					sql = sql & " and ISNULL(cod_TurnoFuncao,'0') = " & intCodTurno
					rsAux.open sql, cnn
					if rsAux.eof then
					
						sql = "Insert Into SRH_TURMA_MODULACAO_FUNCAO( Cod_Turma, Cod_Funcao, cod_TurnoFuncao, Total_Vaga_Funcao )"
						sql = sql & " Values ("
						sql = sql & "" & rs("Cod_turma") & ","
						sql = sql & "" & intCodFuncao & ","
						sql = sql & "" & intCodTurno & ","
						sql = sql & "" & strVagas & ")"
						cnn.execute sql
						GravarLog sql
						
					end if
					rsAux.close
					
					rs.movenext
				wend
			end if 
			rs.close			

		else
		
			sql = " DELETE FROM " 
			sql = sql & " SRH_TURMA_MODULACAO_FUNCAO "
			sql = sql & " WHERE Cod_Funcao = " & intCodFuncao
			sql = sql & " and ISNULL(cod_TurnoFuncao,'0') = " & intCodTurno
			sql = sql & " AND Cod_Turma IN (SELECT Cod_turma "
			sql = sql & " 					FROM SCA_TURMA t "
			sql = sql & " 					INNER JOIN SEG_EMPRESA E ON E.CODIGO = T.COD_EMPRESA "
			sql = sql & " 					INNER JOIN SCA_TURNO TU ON TU.cod_turno = T.cod_turno "
			sql = sql & " 					INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) and TRH.Cod_Grupo = " & Session("CodGrupo") 
			sql = sql & " 					Where substring(t.nometurma,1,3) = (SELECT substring(nometurma,1,3) FROM SCA_TURMA WHERE Cod_turma = " & intCodTurma & ")"
			sql = sql & " 					and t.AnoLetivo = " & strAnoLetivo
			sql = sql & " 					and E.CodTipoEmpresa = " & intCodTipoEmpresa
			if strFLagTurnoTurma <> "I" then
				if intCodTurno <> "0" AND intCodTurno <> "" then
					sql = sql & " and TRH.cod_turno = " & intCodTurno 
				end if
			end if
			sql = sql & " 					and t.Cod_Semestre = " & intSemestre & " )"	
			cnn.execute sql
			GravarLog sql

			sql = " SELECT T.Cod_turma, T.cod_empresa, T.nometurma, E.CodTipoEmpresa " 
			sql = sql & " FROM SCA_TURMA t " 
			sql = sql & " INNER JOIN SEG_EMPRESA E ON E.CODIGO = T.COD_EMPRESA " 
			sql = sql & " INNER JOIN SCA_TURNO TU ON TU.cod_turno = T.cod_turno "
			sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) and TRH.Cod_Grupo = " & Session("CodGrupo")	  
			sql = sql & " Where substring(t.nometurma,1,3) = (SELECT substring(nometurma,1,3) FROM SCA_TURMA WHERE Cod_turma = " & intCodTurma & ")"
			sql = sql & " and t.AnoLetivo = " & strAnoLetivo
			sql = sql & " and t.Cod_Semestre = " & intSemestre
			sql = sql & " and E.CodTipoEmpresa = " & intCodTipoEmpresa
			if strFLagTurnoTurma <> "I" then
				if intCodTurno <> "0" AND intCodTurno <> "" then
					sql = sql & " and TRH.cod_turno = " & intCodTurno 
				end if
			end if
			rs.open sql, cnn
			if rs.eof = false then
				while not rs.eof
				
					sql = "Update SCA_TURMA Set"
					sql = sql & " Cod_Tipo_Unidade = " & intCodTipoEmpresa & ","
					sql = sql & " Cod_Tipo_Modulacao = '" & strTipoModulacao & "'"
					sql = sql & " Where Cod_Turma = " & rs("Cod_turma")
					cnn.execute sql
					GravarLog sql

					sql = " SELECT Cod_turma FROM SRH_TURMA_MODULACAO_FUNCAO " 
					sql = sql & " Where Cod_Turma = " & rs("Cod_turma")
					sql = sql & " and Cod_Funcao = " & intCodFuncao
					sql = sql & " and ISNULL(cod_TurnoFuncao,'0') = " & intCodTurno
					rsAux.open sql, cnn
					if rsAux.eof then
				
						sql = "Insert Into SRH_TURMA_MODULACAO_FUNCAO( Cod_Turma, Cod_Funcao, cod_TurnoFuncao, Total_Vaga_Funcao )"
						sql = sql & " Values ("
						sql = sql & "" & rs("Cod_turma") & ","
						sql = sql & "" & intCodFuncao & ","
						sql = sql & "" & intCodTurno & ","
						sql = sql & "" & strVagas & ")"
						cnn.execute sql
						GravarLog sql
						
					end if 
					rsAux.close
					
					rs.movenext
				wend
			end if 
			rs.close
		
		end if
		
	elseif acao="A" then

		strMensagem = "Registro Alterado com sucesso..."

	elseif acao="E" then
	
		strMensagem = "Registro Excluido com sucesso..."
		
		if strModularGrupo <> "S" then
		
			sql = "Delete From SRH_TURMA_MODULACAO_FUNCAO "
			sql = sql & " Where Cod_Turma in ( SELECT Cod_turma FROM SCA_TURMA  Where Cod_GradeCurricular = (SELECT Cod_GradeCurricular FROM SCA_TURMA WHERE Cod_Turma = " & intCodTurma & ")"
			sql = sql & " and AnoLetivo = " & strAnoLetivo
			sql = sql & " and Cod_Semestre = " & intSemestre & ")"
			cnn.execute sql
			GravarLog sql
			
		else

			sql = " DELETE FROM " 
			sql = sql & " SRH_TURMA_MODULACAO_FUNCAO "
			sql = sql & " WHERE Cod_Funcao = " & intCodFuncao
			sql = sql & " and ISNULL(cod_TurnoFuncao,'0') = " & intCodTurno
			sql = sql & " AND Cod_Turma IN (SELECT Cod_turma "
			sql = sql & " 					FROM SCA_TURMA t "
			sql = sql & " 					INNER JOIN SEG_EMPRESA E ON E.CODIGO = T.COD_EMPRESA "
			sql = sql & " 					Where substring(t.nometurma,1,3) = (SELECT substring(nometurma,1,3) FROM SCA_TURMA WHERE Cod_Turma = " & intCodTurma & ")"
			sql = sql & " 					and t.AnoLetivo = " & strAnoLetivo
			sql = sql & " 					and E.CodTipoEmpresa = " & intCodTipoEmpresa
			sql = sql & " 					and t.Cod_Semestre = " & intSemestre & " )"	
			cnn.execute sql
			GravarLog sql
		
		end if

	elseif acao="EF" then
	
		strMensagem = "Item Excluido com sucesso..."
		
		sql = "Delete From SRH_TURMA_MODULACAO_FUNCAO "
		sql = sql & " Where Codigo = " & intCodItem
		cnn.execute sql
		GravarLog sql

	end if

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		'cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			<% if acao <> "EF" then %>
				window.location='ModulacaoTurmas_cad.asp';
			<% else %>
				window.close();
			<% end if %> 
			window.opener.frm.submit();
		</script>
		<%
		response.end
	else
		'cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.location='ModulacaoTurmas_cad.asp';
		</script>
		<%
	end if
%>