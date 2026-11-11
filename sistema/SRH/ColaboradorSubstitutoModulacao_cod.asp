<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_replaceRequest.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_EnviarEmail.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 								= Trim(Request.QueryString("acao"))
	CodigoModulacaoExcluir				= Trim(Request.QueryString("CodigoModulacaoExcluir"))
	
	strAnoLetivo 						= session("strAnoLetivo")
	strSemestre 						= session("strSemestre")

	' Colaborador Substituto
	intCodColaboradorSubstituto			= Trim(Request("txtCodColaboradorSubstituto"))
	
	'Colaborador Substituido
	intCodColaboradorSubstituido		= Trim(Request("txtCodColaboradorSubstituido"))
	
	' Dados Substituicao
	strDataInicialRetornoPagina			= Trim(Request("txtDataInicial"))  
	strDataFinalRetornoPagina	    	= Trim(Request("txtDataFinal"))  
	strDataInicial						= formataDataBD(Trim(Request.Form("txtDataInicial"))) 
	strDataFinal						= formataDataBD(Trim(Request.Form("txtDataFinal"))) 
	strJustificativa					= Trim(Request.Form("txtJustificativa")) 
	intCodJustificativaFaltas			= Trim(Request.Form("txtCodJustificativaFaltas")) 
	
	if intCodJustificativaFaltas = "" then intCodJustificativaFaltas = "0"
	if intCodColaboradorSubstituto = "" then intCodColaboradorSubstituto = "0"
	if intCodColaboradorSubstituido = "" then intCodColaboradorSubstituido = "0"

	strParametro = "ColaboradorSubstitutoModulacao_cad.asp?txtCodColaboradorSubstituto="&intCodColaboradorSubstituto
	strParametro = strParametro & "&txtCodColaboradorSubstituido="&intCodColaboradorSubstituido
	strParametro = strParametro & "&txtDataInicial="&strDataInicialRetornoPagina
	strParametro = strParametro & "&txtDataFinal="&strDataFinalRetornoPagina

	
	if acao <> "E" and acao <> "INATIVAR" and acao <> "ES" then 
		if DateDiff("d",strDataInicial,strDataFinal) < 15 then
			cnn.commitTrans
			%>
			<script>
				alert("Periodo minimo para Substituicao e de 15 Dias. Verifique!");
				window.location ='<%=strParametro%>';
			</script>
			<%
			response.end
		end if
	end if

	if acao = "I" then
	
		if intCodJustificativaFaltas <> "" and intCodJustificativaFaltas <> "0" then
			SQL = "select codigo "
			SQL = SQL & " from SRH_COLABORADOR_FREQUENCIA "
			SQL = SQL & " where cod_colaborador = " & intCodColaboradorSubstituido
			SQL = SQL & " and fechamento = 'S' "
			SQL = SQL & " and situacao = 'S' "
			SQL = SQL & " AND ('"&strDataInicial&"' between DataLancamento and DataLancamentoFinal "
			SQL = SQL & " AND '"&strDataFinal&"' between DataLancamento and DataLancamentoFinal)"
			rs.open sql, cnn, 3, 3
			if rs.eof = false then
			   codLancamentoFalta = rs("codigo")
			else
			   codLancamentoFalta = ""
			end if
			rs.close

			if codLancamentoFalta = "" then 
				cnn.rollbackTrans
				%>
				<script>
					alert("O lancamento de frequencia localizado nao corresponde ao periodo de frequencia informado.");
					window.location ='<%=strParametro%>';
				</script>
				<%
				response.end
			end if

		end if	
		
	end if
	
	if acao <> "E" and acao <> "INATIVAR" and acao <> "ES" then 
		'TESTE VALIDACAO ANTES DA GRAVACAO 
		intCodGrupo = session("CodGrupo")
		data_inicial 			= formataDataBD(Trim(Request.Form("txtDataInicial"))) 
		data_final				= formataDataBD(Trim(Request.Form("txtDataFinal"))) 
		codColaboradorSubtituto	= Trim(Request("txtCodColaboradorSubstituto"))
		CodColaboradorAtual		= Trim(Request("txtCodColaboradorSubstituido"))
		
		SQL = "select isnull(count(*),0) as qtde"
		SQL = SQL & " from SRH_COLABORADOR_FREQUENCIA "
		SQL = SQL & " where cod_colaborador = " & CodColaboradorAtual
		SQL = SQL & " and fechamento = 'S' "
		SQL = SQL & " and situacao = 'S' "
		SQL = SQL & " AND ('"&data_inicial&"' between DataLancamento and DataLancamentoFinal "
		SQL = SQL & " or '"&data_final&"' between DataLancamento and DataLancamentoFinal)"
		rs.open sql, cnn, 3, 3
		''if rs.eof = false then
		if rs.eof = true then
			if rs("qtde")=0 then
				cnn.rollbackTrans
				%>
				<script>
					alert("Licença não informada ou não abonada na movimentação.");
					window.location ='<%=strParametro%>';
				</script>
				<%
				response.end
			end if
		end if
		rs.close
		
	end if
	
	if acao="I" then
					
		LocalizaInclusao = "N"

		sql = " select "
		sql = sql & " Codigo, "
		sql = sql & " Cod_Colaborador, "
		sql = sql & " (Case when Situacao_disciplinar = 'I' then 21 else Total_Aulas end) as Total_Aulas, "
		sql = sql & " (Case when Situacao_disciplinar = 'I' and isnull(Saldo_Substituicao,'0')<>'0' then 21 else isnull(Saldo_Substituicao,'0') end) as Saldo_Substituicao, "
		sql = sql & " Situacao_disciplinar "
		sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE "
		sql = sql & " where Cod_Colaborador = " & intCodColaboradorSubstituido
		sql = sql & " and status = 'A' "
		sql = sql & " order by codigo "
		rs.open sql, cnn
		if rs.eof = false then
			while not rs.eof

			   	intAulasSubstituicao = trim(request.Form("txtAulasSubstituicao_"& rs("codigo"))) 
				if intAulasSubstituicao = "" then intAulasSubstituicao = "0"
		
				if clng(rs("Saldo_Substituicao")) + clng(intAulasSubstituicao) > clng(rs("Total_Aulas")) then
					''cnn.commitTrans
					%>
					<script>
						alert("Verifique os Valores informados.\nO Total modulado ao SUBSTITUTO e superior ao saldo do SUBSTITUIDO.");
						//window.location ='<%=strParametro%>';
					</script>
					<%
					''response.end
				end if
				
				if rs("Situacao_disciplinar") = "I" and clng(intAulasSubstituicao) <> "0" then
					intAulasSubstituicao = 1   ' Se for Disciplinar guarda apenas uma aula
				end if
				
				if clng(intAulasSubstituicao) > 0 then
					
					LocalizaInclusao = "S"
			   
					sql = " insert into SRH_MODULACAO_DISCIPLINAR_DOCENTE (Ano_Letivo"
					sql = sql & " ,Semestre"
					sql = sql & " ,Cod_Colaborador"
					sql = sql & " ,tipoModulacao"
					sql = sql & " ,Cod_empresa"
					sql = sql & " ,Cod_Curso"
					sql = sql & " ,Cod_periodo"
					sql = sql & " ,Cod_Turno"
					sql = sql & " ,Cod_Turno_Opcional"
					sql = sql & " ,Cod_Disciplina"
					sql = sql & " ,Cod_Funcao"
					sql = sql & " ,Total_Aulas"
					sql = sql & " ,Situacao_disciplinar"
					sql = sql & " ,Status"
					sql = sql & " ,Data_Ativacao"
					sql = sql & " ,Data_Inativacao"
					sql = sql & " ,Cod_Substituicao_Deficit"
					sql = sql & " ,periodo_inicial"
					sql = sql & " ,periodo_final"
					sql = sql & " ,DataInicial"
					sql = sql & " ,DataFinal"
					sql = sql & " ,tipo_contratacao"
					sql = sql & " ,Cod_Substituicao"
					sql = sql & " ,Cod_Modulacao_Substituicao"
					sql = sql & " ,Saldo_Substituicao"
					sql = sql & " ,DataInicial_Substituicao"
					sql = sql & " ,DataFinal_Substituicao"
					sql = sql & " ,Cod_ColaboradorSubstituido"
					sql = sql & " ,Cod_JustificativaFaltas"
					sql = sql & " ,Descricao_Motivo"
					sql = sql & " ,motivo"
					sql = sql & " ,modulacao_menor"
					sql = sql & " ,modulacao_maior"
					sql = sql & " ,usuario_incl"
					sql = sql & " ,data_hora_incl)"
					sql = sql & " select "
					sql = sql & " Ano_Letivo, "    
					sql = sql & " Semestre, "
					sql = sql & "" & intCodColaboradorSubstituto & ","                    	' Cod_Colaborador,
					sql = sql & " tipoModulacao, "
					sql = sql & " Cod_empresa, "
					sql = sql & " Cod_Curso, "
					sql = sql & " Cod_periodo, "
					sql = sql & " Cod_Turno, "
					sql = sql & " Cod_Turno_Opcional, "
					sql = sql & " Cod_Disciplina, "
					sql = sql & " Cod_Funcao, "
					sql = sql & "" & intAulasSubstituicao & "," 							' Total_Aulas 
					sql = sql & " Situacao_disciplinar, "
					sql = sql & " 'A', "
					sql = sql & " getdate(), "		 										' Data_Ativacao,
					sql = sql & " null, "													' Data_Inativacao,
					sql = sql & " null, "													' Cod_Substituicao_Deficit,
					sql = sql & " null, "													' periodo_inicial,
					sql = sql & " null, "													' periodo_final,
					sql = sql & "'" & strDataInicial & "'," 								' DataInicial,
					sql = sql & "'" & strDataFinal & "',"									' DataFinal,
					sql = sql & " tipo_contratacao, "
					sql = sql & " null, " 													' Cod_Substituicao,
					sql = sql & "" & rs("codigo") & "," 									' Cod_Modulacao_Substituicao,
					sql = sql & "" & intAulasSubstituicao & "," 							' Saldo_Substituicao,
					sql = sql & "'" & strDataInicial & "',"   								' DataInicial_Substituicao,
					sql = sql & "'" & strDataFinal & "',"   								' DataFinal_Substituicao
					sql = sql & "" & rs("Cod_Colaborador") & "," 							' Cod_ColaboradorSubstituido
					sql = sql & "" & intCodJustificativaFaltas & ","  						' Cod_JustificativaFaltas
					if strJustificativa <> "" then											' Descricao_Motivo
						sql = sql & "'" & strJustificativa & "',"
					else
						sql = sql & "null,"
					end if
					sql = sql & "null,"														'motivo
					sql = sql & "null,"														'modulacao_menor
					sql = sql & "null,"														'modulacao_maior
					sql = sql & "'" & session("usuarioWeb")& "',"														'usuario_incl
					sql = sql & "getdate()"														'data_hora_incl
					sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE "
					sql = sql & " where Codigo = " & rs("codigo")
					cnn.execute sql
					GravarLog sql
					
					sql = " Update SRH_MODULACAO_DISCIPLINAR_DOCENTE Set "
					sql = sql & " Saldo_Substituicao =  isnull(Saldo_Substituicao,'0') + " & intAulasSubstituicao  
					sql = sql & " where Codigo = " & rs("codigo")
					cnn.execute sql
					GravarLog sql
					
					'' Gravar Ocorrencia - Uma replica do registro
					sql = " insert into SRH_MODULACAO_SUBSTITUICAO_OCORRENCIA ("
					sql = sql & "  Ano_Letivo"
					sql = sql & " ,Semestre"
					sql = sql & " ,Cod_Colaborador"
					sql = sql & " ,tipoModulacao"
					
					sql = sql & " ,Cod_empresa"
					sql = sql & " ,Cod_Curso"
					sql = sql & " ,Cod_periodo"
					sql = sql & " ,Cod_Turno"
					sql = sql & " ,Cod_Turno_Opcional"
					sql = sql & " ,Cod_Disciplina"
					sql = sql & " ,Cod_Funcao"
					
					sql = sql & " ,Total_Aulas"
					sql = sql & " ,Situacao_disciplinar"
					sql = sql & " ,Status"
					
					sql = sql & " ,Data_Ativacao"
					sql = sql & " ,Data_Inativacao"
					sql = sql & " ,Cod_Substituicao_Deficit"
					sql = sql & " ,periodo_inicial"
					sql = sql & " ,periodo_final"
					sql = sql & " ,DataInicial"
					sql = sql & " ,DataFinal"
					
					sql = sql & " ,tipo_contratacao"
					sql = sql & " ,Cod_Substituicao"
					sql = sql & " ,Cod_Modulacao_Substituicao"
					sql = sql & " ,Saldo_Substituicao"
					sql = sql & " ,DataInicial_Substituicao"
					sql = sql & " ,DataFinal_Substituicao"
					
					sql = sql & " ,Cod_ColaboradorSubstituido"
					sql = sql & " ,Cod_JustificativaFaltas"
					sql = sql & " ,Descricao_Motivo"
					
					sql = sql & " ,Data_Ocorrencia"
					sql = sql & " ,Usuario_Ocorrencia"
					sql = sql & " ,Tipo_Ocorrencia)"
					
					sql = sql & " select "
					sql = sql & " Ano_Letivo, "    
					sql = sql & " Semestre, "
					sql = sql & "" & intCodColaboradorSubstituto & ","                    	' Cod_Colaborador,
					sql = sql & " tipoModulacao, "
					
					sql = sql & " Cod_empresa, "
					sql = sql & " Cod_Curso, "
					sql = sql & " Cod_periodo, "
					sql = sql & " Cod_Turno, "
					sql = sql & " Cod_Turno_Opcional, "
					sql = sql & " Cod_Disciplina, "
					sql = sql & " Cod_Funcao, "
					
					sql = sql & "" & intAulasSubstituicao & "," 							' Total_Aulas 
					sql = sql & " Situacao_disciplinar, "
					sql = sql & " 'A', "
					
					sql = sql & " getdate(), "		 										' Data_Ativacao,
					sql = sql & " null, "													' Data_Inativacao,
					sql = sql & " null, "													' Cod_Substituicao_Deficit,
					sql = sql & " null, "													' periodo_inicial,
					sql = sql & " null, "													' periodo_final,
					sql = sql & "'" & strDataInicial & "'," 								' DataInicial,
					sql = sql & "'" & strDataFinal & "',"									' DataFinal,
					
					sql = sql & " tipo_contratacao, "
					sql = sql & " null, " 													' Cod_Substituicao,
					sql = sql & "" & rs("codigo") & "," 									' Cod_Modulacao_Substituicao,
					sql = sql & "" & intAulasSubstituicao & "," 							' Saldo_Substituicao,
					sql = sql & "'" & strDataInicial & "',"   								' DataInicial_Substituicao,
					sql = sql & "'" & strDataFinal & "',"   								' DataFinal_Substituicao
					
					sql = sql & "" & rs("Cod_Colaborador") & "," 							' Cod_ColaboradorSubstituido
					sql = sql & "" & intCodJustificativaFaltas & ","  						' Cod_JustificativaFaltas
					if strJustificativa <> "" then											' Descricao_Motivo
						sql = sql & "'" & strJustificativa & "',"
					else
						sql = sql & "null,"
					end if
					
					sql = sql & "getdate(),"  												' Data_Ocorrencia
					sql = sql & "'" & session("UsuarioWeb") & "',"   						' Usuario_Ocorrencia
					sql = sql & "'INC'"   													' Tipo_Ocorrencia
					sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE "
					sql = sql & " where Codigo = " & rs("codigo")
					cnn.execute sql
					GravarLog sql
					
				end if		   

			   rs.movenext

			wend
		end if
		rs.close
		
		sql = " select " 
		sql = sql & " sum((Case when Situacao_disciplinar = 'I' then 21 else Total_Aulas end)) as Total_Aulas "
		sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE "  
		sql = sql & " where Cod_Colaborador = " & intCodColaboradorSubstituto
		sql = sql & " and status = 'A' " 
		rs.open sql, cnn
		if rs.eof = false then
			inSaldoTotalSubstituto			= Trim(Rs("Total_Aulas"))
		else
			inSaldoTotalSubstituto			= "0"
		end if
		rs.close
		
		if inSaldoTotalSubstituto > 420 then
			cnn.rollbackTrans
			%>
			<script>
				alert("Total modulado de <%=inSaldoTotalSubstituto%> ultrapassou ao permitido. Verifique!")
				window.location ='<%=strParametro%>';
			</script>
			<%
			response.end	
		end if

		inSaldoTotalSubstitutoTurno = "0"
		inFlagSubstitutoTurno = "N"
		sql = " select cod_turno, sum((Case when Situacao_disciplinar = 'I' then 21 else Total_Aulas end)) as Total_Aulas " 
		sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE " 
		sql = sql & " where Cod_Colaborador = " & intCodColaboradorSubstituto
		sql = sql & " and status = 'A' "
		sql = sql & " group by cod_turno "
		rs.open sql, cnn
		if rs.eof = false then
			while not rs.eof
				if Trim(Rs("Total_Aulas")) > 220 then
					inFlagSubstitutoTurno	= "S"
					inSaldoTotalSubstitutoTurno	= Trim(Rs("Total_Aulas"))
				end if
				rs.movenext
			wend
		end if
		rs.close
		
		if inSaldoTotalSubstitutoTurno > 22 then
			cnn.rollbackTrans
			%>
			<script>
				alert("Total modulado no Turno de <%=inSaldoTotalSubstituto%> ultrapassou ao permitido. Verifique!")
				window.location ='<%=strParametro%>';
			</script>
			<%
			response.end	
		end if

		if LocalizaInclusao = "S" then
			strMensagem = "Registro incluido com sucesso..."
		else
			strMensagem = "Substituicao nao Incluida.\nNao foram informados valores a ser modulado ao Substituto."
		end if

	elseif acao = "A" then
		
		strMensagem  = "Data Final alterada com sucesso!"
		intCodigo	= Trim(Request("txtCodigo"))
		sql = " Update SRH_COLABORADOR_SUBSTITUTO Set "
		sql = sql & " DataFinal = '" & strDataFinal & "'"
		sql = sql & " where codigo = " & intCodigo
		cnn.execute sql
		GravarLog sql

	elseif acao = "INATIVAR" then
		
		strMensagem  = "Substituicao Inativada com sucesso!"

		'' Gravar Ocorrencia - Uma replica do registro
		sql = " insert into SRH_MODULACAO_SUBSTITUICAO_OCORRENCIA "
		sql = sql & " select "
		sql = sql & " Ano_Letivo, "
		sql = sql & " Semestre, "
		sql = sql & " Cod_Colaborador, "
		sql = sql & " tipoModulacao, "
		sql = sql & " Cod_empresa, "
		sql = sql & " Cod_Curso, "
		sql = sql & " Cod_periodo, "
		sql = sql & " Cod_Turno, "
		sql = sql & " Cod_Turno_Opcional, "
		sql = sql & " Cod_Disciplina, "
		sql = sql & " Cod_Funcao, "
		sql = sql & " Total_Aulas, "
		sql = sql & " Situacao_disciplinar, "
		sql = sql & " Status, "
		sql = sql & " Data_Ativacao, "
		sql = sql & " Data_Inativacao, "
		sql = sql & " Cod_Substituicao_Deficit, "
		sql = sql & " periodo_inicial, "
		sql = sql & " periodo_final, "
		sql = sql & " DataInicial, "
		sql = sql & " DataFinal, "
		sql = sql & " tipo_contratacao, "
		sql = sql & " Cod_Substituicao, "
		sql = sql & " Cod_Modulacao_Substituicao, "
		sql = sql & " Saldo_Substituicao, "
		sql = sql & " DataInicial_Substituicao, "
		sql = sql & " DataFinal_Substituicao, "
		sql = sql & " Cod_ColaboradorSubstituido, "
		sql = sql & " Cod_JustificativaFaltas, "
		sql = sql & " Descricao_Motivo, "
		sql = sql & " motivo,"														 
		sql = sql & " modulacao_menor,"														 
		sql = sql & " modulacao_maior,"														 
		sql = sql & " usuario_incl,"														 
		sql = sql & " data_hora_incl,"													 
		sql = sql & " getdate(),"  												 
		sql = sql & "'" & session("UsuarioWeb") & "',"   							 
		sql = sql & "'INA'"   													 
		sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE "
		sql = sql & " Where Cod_Substituicao in (" & intCodCodSubistituicao & ")"
		cnn.execute sql
		GravarLog sql
		
		sql = " Update SRH_COLABORADOR_SUBSTITUTO Set "
		sql = sql & " DataFinal = getdate(),"
		sql = sql & " Situacao = 'I'"
		sql = sql & " where codigo in (" & intCodCodSubistituicao & ")"
		cnn.execute sql
		GravarLog sql

		sql = " Update SRH_MODULACAO_DISCIPLINAR_DOCENTE Set "
		sql = sql & " status = 'I' " 
		sql = sql & " Where Cod_Substituicao in (" & intCodCodSubistituicao & ")"
		cnn.execute sql
		GravarLog sql

	
	elseif acao = "ES" then 

		strMensagem = "Substituicao Excluida com sucesso!"

		'' Gravar Ocorrencia - Uma replica do registro
		sql = " insert into SRH_MODULACAO_SUBSTITUICAO_OCORRENCIA "
		sql = sql & " select "
		sql = sql & " Ano_Letivo, "
		sql = sql & " Semestre, "
		sql = sql & " Cod_Colaborador, "
		sql = sql & " tipoModulacao, "
		sql = sql & " Cod_empresa, "
		sql = sql & " Cod_Curso, "
		sql = sql & " Cod_periodo, "
		sql = sql & " Cod_Turno, "
		sql = sql & " Cod_Turno_Opcional, "
		sql = sql & " Cod_Disciplina, "
		sql = sql & " Cod_Funcao, "
		sql = sql & " Total_Aulas, "
		sql = sql & " Situacao_disciplinar, "
		sql = sql & " Status, "
		sql = sql & " Data_Ativacao, "
		sql = sql & " Data_Inativacao, "
		sql = sql & " Cod_Substituicao_Deficit, "
		sql = sql & " periodo_inicial, "
		sql = sql & " periodo_final, "
		sql = sql & " DataInicial, "
		sql = sql & " DataFinal, "
		sql = sql & " tipo_contratacao, "
		sql = sql & " Cod_Substituicao, "
		sql = sql & " Cod_Modulacao_Substituicao, "
		sql = sql & " Saldo_Substituicao, "
		sql = sql & " DataInicial_Substituicao, "
		sql = sql & " DataFinal_Substituicao, "
		sql = sql & " Cod_ColaboradorSubstituido, "
		sql = sql & " Cod_JustificativaFaltas, "
		sql = sql & " Descricao_Motivo, "
		sql = sql & " motivo,"														 
		sql = sql & " modulacao_menor,"														 
		sql = sql & " modulacao_maior,"														 
		sql = sql & " usuario_incl,"														 
		sql = sql & " data_hora_incl,"													 
		sql = sql & "getdate(),"  												 
		sql = sql & "'" & session("UsuarioWeb") & "',"   							 
		sql = sql & "'EXC'"   													 
		sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE "
		sql = sql & " where Codigo = " & CodigoModulacaoExcluir
		cnn.execute sql
		GravarLog sql
		
		sql = "update SRH_MODULACAO_DISCIPLINAR_DOCENTE set "
		sql = sql & " Saldo_Substituicao = Saldo_Substituicao - ( select Total_Aulas from SRH_MODULACAO_DISCIPLINAR_DOCENTE where codigo = " & CodigoModulacaoExcluir & ")"
		sql = sql & " where codigo in (select Cod_Modulacao_Substituicao from SRH_MODULACAO_DISCIPLINAR_DOCENTE where codigo = " & CodigoModulacaoExcluir & " )"
		cnn.execute sql
		GravarLog sql

		sql = "delete from SRH_MODULACAO_DISCIPLINAR_DOCENTE "
		sql = sql & " Where codigo in (" & CodigoModulacaoExcluir & ")"
		cnn.execute sql
		GravarLog sql

	elseif acao = "E" then

		strMensagem = "Substituicao Excluida com sucesso!"

		'' Gravar Ocorrencia - Uma replica do registro
		sql = " insert into SRH_MODULACAO_SUBSTITUICAO_OCORRENCIA "
		sql = sql & " select "
		sql = sql & " Ano_Letivo, "
		sql = sql & " Semestre, "
		sql = sql & " Cod_Colaborador, "
		sql = sql & " tipoModulacao, "
		sql = sql & " Cod_empresa, "
		sql = sql & " Cod_Curso, "
		sql = sql & " Cod_periodo, "
		sql = sql & " Cod_Turno, "
		sql = sql & " Cod_Turno_Opcional, "
		sql = sql & " Cod_Disciplina, "
		sql = sql & " Cod_Funcao, "
		sql = sql & " Total_Aulas, "
		sql = sql & " Situacao_disciplinar, "
		sql = sql & " Status, "
		sql = sql & " Data_Ativacao, "
		sql = sql & " Data_Inativacao, "
		sql = sql & " Cod_Substituicao_Deficit, "
		sql = sql & " periodo_inicial, "
		sql = sql & " periodo_final, "
		sql = sql & " DataInicial, "
		sql = sql & " DataFinal, "
		sql = sql & " tipo_contratacao, "
		sql = sql & " Cod_Substituicao, "
		sql = sql & " Cod_Modulacao_Substituicao, "
		sql = sql & " Saldo_Substituicao, "
		sql = sql & " DataInicial_Substituicao, "
		sql = sql & " DataFinal_Substituicao, "
		sql = sql & " Cod_ColaboradorSubstituido, "
		sql = sql & " Cod_JustificativaFaltas, "
		sql = sql & " Descricao_Motivo, "
		sql = sql & " motivo,"														 
		sql = sql & " modulacao_menor,"														 
		sql = sql & " modulacao_maior,"														 
		sql = sql & " usuario_incl,"														 
		sql = sql & " data_hora_incl,"													 
		sql = sql & " getdate(),"  												 
		sql = sql & "'" & session("UsuarioWeb") & "',"   							 
		sql = sql & "'EXC'"   													 
		sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE "
		sql = sql & " where Cod_Substituicao = " & intCodCodSubistituicao
		cnn.execute sql
		GravarLog sql


		sql = "Delete from SRH_MODULACAO_DISCIPLINAR_DOCENTE "
		sql = sql & " Where Cod_Substituicao in (" & intCodCodSubistituicao & ")"
		cnn.execute sql
		GravarLog sql

		sql = "Delete from SRH_COLABORADOR_SUBSTITUTO "
		sql = sql & " where Cod_Grupo = " & intCodGrupo
		sql = sql & " And Codigo in (" & intCodCodSubistituicao & ")"
		cnn.execute sql
		GravarLog sql
	
	end if

	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location ='<%=strParametro%>';
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.location ='<%=strParametro%>';
		</script>
		<%
	end if
%>