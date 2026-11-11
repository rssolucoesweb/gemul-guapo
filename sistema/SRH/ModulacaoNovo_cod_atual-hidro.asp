<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 15/11/2013
	::	Desenvolvedores...: Sérgio Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Modulação
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 						= Trim(Request.QueryString("acao"))
	intCodigo	 				= Trim(Request.Form("txtCodigo"))
	strAnoLetivo 				= Trim(Request.Form("txtAnoLetivo"))
	intSemestre 				= Trim(Request.Form("cmbSemestre"))
	
	intCodColaborador			= Trim(Request.Form("txtCodFuncionario"))
	intCodEmpresaGrupo			= Trim(Request.Form("cmbEmpresaGrupo"))
	intCodCurso 				= Trim(Request.Form("cmbCursoCombo"))
	if intCodCurso = "" then intCodCurso = "0"
	intCodCursoCombo 			= Trim(Request.Form("cmbCursoCombo"))
	if intCodCursoCombo = "" then intCodCursoCombo = "0"
	intCodPeriodo 				= Trim(Request.Form("cmbPeriodo"))
	if intCodPeriodo = "" then intCodPeriodo = "0"
	intCodFuncao 				= Trim(Request.Form("cmbFuncao"))
	intCodTurno		 			= Trim(Request.Form("cmbTurno"))
	intCodTurnoOpcional			= Trim(Request.Form("cmbTurnoOpcional"))
	if intCodTurnoOpcional = "" then intCodTurnoOpcional = "0"
	intCodDisciplina	 		= Trim(Request.Form("cmbDisciplina"))
	strTipoLancamento 			= Trim(Request.Form("optTipoLancamento"))
	strTipoModulacao 			= Trim(Request.Form("optTipoModulacao"))
	intTotalAulas 				= Trim(Request.Form("txtTotalAulas"))
	if strTipoModulacao = "FUNCIONARIO" then intTotalAulas = "1"
	strTipoContratacao			= Trim(Request.Form("tipoContratacao"))	
	
	strPeriodoInicial			= Trim(Request.Form("txtPeriodoInicial"))	
	strPeriodoFinal				= Trim(Request.Form("txtPeriodoFinal"))	
	
	strSaldo					= Trim(Request.Form("txtSaldoContratual"))	
	strTotalContratoNivel		= Trim(Request.Form("txtTotalContratual"))
	if strTotalContratoNivel = "" then strTotalContratoNivel = 0
	strTotalModulado			= Trim(Request.Form("txtTotalModulado"))
	PorPeriodo 					= Trim(Request.Form("PorPeriodo"))	
	strDataInicio 				= Trim(Request.Form("txtDataInicio"))
	strDataFinal 				= Trim(Request.Form("txtDataFinal"))
		
	if acao="I" then
		
		if strTipoModulacao = "PROFESSOR" then
			'validar no interdisciplinar:
			'só pode lançar 1 por turno não importa a unidade
			if intCodTurnoOpcional = "" then intCodTurnoOpcional = "0"
            sql = "select isnull(count(*),0) as qtde"
            sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE"
            sql = sql & " where cod_colaborador = "&intCodColaborador
			sql = sql & " and status = 'A'"
            sql = sql & " and ano_letivo = "&strAnoLetivo
            sql = sql & " and semestre = "&intSemestre
            if intCodTurnoOpcional <> "0" then
                sql = sql & " and cod_turno_opcional = "&intCodTurnoOpcional
            else
                sql = sql & " and cod_turno = "&intCodTurno
            end if
            sql = sql & " and situacao_disciplinar = 'I'"
            rs.open sql, cnn
            if rs.eof = false then
                IF rs("qtde") > 0 then
                    %>
                        <script>
                            alert("Professor já modulado nesse turno.");
							window.location="ModulacaoNovo_cad.asp?TipoContratacao=<%=strTipoContratacao%>&txtCodFuncionario=<%=intCodColaborador%>";
                        </script>
                        <%
                        response.end
                end if
            end if
            rs.close

		end if	
		if strTotalContratoNivel > 0 then
        	if strTipoLancamento = "I" then
				total = cINT(strTotalModulado) + (cINT(intTotalAulas)*21)
            else
				total = cINT(strTotalModulado) + cINT(intTotalAulas)
            end if
			'response.Write("<br>strTotalModulado:" & strTotalModulado)
			'response.Write("<br>intTotalAulas:" & intTotalAulas)
			'response.Write("<br>strTotalContratoNivel:" & strTotalContratoNivel)
			'response.Write("<br>total:" & total)
			'response.end
			mensagemBloq = "N"
			if session("codGrupo")="7" then
				if strTotalContratoNivel = 14 then
					if total > 20 then
						mensagemBloq = "S"
					end if 
				elseif strTotalContratoNivel = 21 then
					if total > 27 then
						mensagemBloq = "S"
					end if 
				elseif strTotalContratoNivel = 28 then
					if total > 42 then
						mensagemBloq = "S"
					end if 			
				elseif strTotalContratoNivel > 42 then
					if total > 42 then
						mensagemBloq = "B"
						msn = 42
					end if 
				end if
			else
				if strTotalContratoNivel = 14 then
					if total > 20 then
						mensagemBloq = "S"
					end if 
				elseif strTotalContratoNivel = 21 then
					if total > 27 then
						mensagemBloq = "S"
					end if 
				elseif strTotalContratoNivel = 28 then
					if total > 42 then
						mensagemBloq = "S"
					end if 			
				elseif strTotalContratoNivel > 42 then
					if total > 42 then
						mensagemBloq = "B"
						msn = 42
					end if 
				end if
			end if
			IF mensagemBloq = "S" and PorPeriodo <> "S" then
				%>
				<script>
					alert("O nível do funcionário deve ser alterado.");
					window.location="ModulacaoNovo_cad.asp?TipoContratacao=<%=strTipoContratacao%>&txtCodFuncionario=<%=intCodColaborador%>";
				</script>
				<%
				response.end
			end if
			IF mensagemBloq = "B" then
				%>
				<script>
					alert("Os lançamento para esse funcionário chegou ao limite de <%=msn%>, não poderá mais ser lançado.");
					window.location="ModulacaoNovo_cad.asp?TipoContratacao=<%=strTipoContratacao%>&txtCodFuncionario=<%=intCodColaborador%>";
				</script>
				<%
				response.end
			end if
		
		end if		
		
		strTipoContratacaoGravar = "C"
		if PorPeriodo = "S" then strTipoContratacaoGravar = "A"
		if intCodCurso = "" then intCodCurso = "0"
		
		if strTipoModulacao = "FUNCIONARIO"  then intCodCurso = intCodCursoCombo
		if intCodCurso = "" then intCodCurso = "0"
		
		strMensagem = "Registro incluido com sucesso..."
		sql = "Insert Into SRH_MODULACAO_DISCIPLINAR_DOCENTE (Cod_Colaborador, tipoModulacao, Ano_Letivo, Semestre, Cod_empresa, Cod_Curso, "
		sql = sql & " Cod_periodo, Cod_Turno, Cod_turno_opcional, Cod_funcao, Cod_Disciplina, Total_Aulas, Situacao_disciplinar, "
		sql = sql & " status, data_ativacao, tipo_contratacao, periodo_inicial, periodo_final,DataInicial, DataFinal)"
		sql = sql & " Values ("
		sql = sql & "" & intCodColaborador & ","
		sql = sql & "'" & strTipoModulacao & "',"
		sql = sql & "" & strAnoLetivo & ","
		sql = sql & "" & intSemestre & ","
		sql = sql & "" & intCodEmpresaGrupo & ","
		
		if intCodCurso = "0" then
			sql = sql & " null,"
		else
			sql = sql & "" & intCodCurso & ","
		end if
		if intCodPeriodo = "0" then
			sql = sql & " null,"
		else
			sql = sql & "" & intCodPeriodo & ","
		end if
		
		sql = sql & "" & intCodTurno & ","
		if intCodTurnoOpcional = "0" then
			sql = sql & "null," 
		else
			sql = sql & "" & intCodTurnoOpcional & ","
		end if
		sql = sql & "" & intCodFuncao & ","
		if intCodDisciplina="0" or intCodDisciplina="" then
			sql = sql & "null," 
		else
			sql = sql & "" & intCodDisciplina & ","
		end if
		sql = sql & "" & intTotalAulas & ","
		sql = sql & "'" & strTipoLancamento & "',"
		sql = sql & "'A',"
		sql = sql & "'" & formatadataBD(date) & "',"
		sql = sql & "'" & strTipoContratacaoGravar & "',"
		if strTipoContratacaoGravar = "C" then
			sql = sql & "null,"
			sql = sql & "null,"
		else
			sql = sql & "'" & formatadataBD(strPeriodoInicial) & "',"
			sql = sql & "'" & formatadataBD(strPeriodoFinal) & "',"
		end if
		
		if strDataInicio = "" then
			sql = sql & "'" & formatadataBD(strPeriodoInicial) & "',"
		else
			sql = sql & "'" & formatadataBD(strDataInicio)  &  "',"
		end if
		
		if strDataFinal = "" then
			if strPeriodoFinal = "" then
				sql = sql & "null)"
			else
				sql = sql & "'" & formatadataBD(strPeriodoFinal) & "')"
			end if
		else
			
			sql = sql & "'" & formatadataBD(strDataFinal)  & "')"
		end if
	
		cnn.execute sql
		GravarLog sql
		
		'atualizar o nivel
		intCodNivel = request("cmbNivel")
		if intCodNivel<>"0" then 
			sql = "update srh_colaborador set Cod_nivel = " & intCodNivel & " where codigo = " & intCodColaborador 
			cnn.execute sql
			GravarLog sql	
		end if
	elseif acao="A" then
		strTipoContratacaoGravar = "C"
		if PorPeriodo = "S" then strTipoContratacaoGravar = "A"

		strMensagem = "Registro Alterado com sucesso..."

		sql = "SELECT periodo_inicial, periodo_final, DataInicial, DataFinal "
		sql = sql & " FROM SRH_MODULACAO_DISCIPLINAR_DOCENTE"
		sql = sql & " where codigo = " & intCodigo			
		rs.open sql, cnn
		if rs.eof = false then
			strPeriodoInicialOrigem	= trim(rs("periodo_inicial")) 
			strPeriodoFinalOrigem	= trim(rs("periodo_final")) 
			strDataInicioOrigem		= trim(rs("DataInicial")) 
			strDataFinalOrigem		= trim(rs("DataFinal")) 
		end if 
		rs.close

		'response.Write("<br>strDataInicioOrigem:" & formatadataBD(strPeriodoInicialOrigem))
		'response.Write("<br>strDataInicio:" & formatadataBD(strPeriodoInicial))
		'response.Write("<br>strDataFinalOrigem:" & formatadataBD(strPeriodoFinalOrigem))
		'response.Write("<br>strDataFinal:" & formatadataBD(strPeriodoFinal))
		'response.Write("<br>strTipoContratacaoGravar:" & strTipoContratacaoGravar)

		if (strTipoContratacaoGravar = "C" and formatadataBD(strDataInicioOrigem) = formatadataBD(strDataInicio) and formatadataBD(strDataFinalOrigem) = formatadataBD(strDataFinal)) or (strTipoContratacaoGravar = "A" and formatadataBD(strPeriodoInicialOrigem) = formatadataBD(strPeriodoInicial) and formatadataBD(strPeriodoFinalOrigem) = formatadataBD(strPeriodoFinal) ) then
		'response.Write("<br>passou1")
		'response.End()
			sql = "Update SRH_MODULACAO_DISCIPLINAR_DOCENTE Set"
			sql = sql & " Cod_empresa = " & intCodEmpresaGrupo & ","
			sql = sql & " Cod_Colaborador = " & intCodColaborador & ","
			sql = sql & " Ano_Letivo = " & strAnoLetivo & ","
			sql = sql & " Semestre = " & intSemestre & ","
			if intCodCurso = "0" then
				sql = sql & " Cod_Curso = null,"
			else
				sql = sql & " Cod_Curso = " & intCodCurso & ","
			end if
			if intCodPeriodo = "0" then
				sql = sql & " Cod_periodo = null,"
			else
				sql = sql & " Cod_periodo = " & intCodPeriodo & ","
			end if
			sql = sql & " Cod_funcao = " & intCodFuncao & ","
			sql = sql & " Cod_Turno = " & intCodTurno & ","
			if intCodTurnoOpcional="0" or intCodTurnoOpcional="" then
				sql = sql & "Cod_Turno_Opcional = null," 
			else
				sql = sql & "Cod_Turno_Opcional = " & intCodTurnoOpcional & ","
			end if
			if intCodDisciplina="0" or intCodDisciplina="" then
				sql = sql & "Cod_Disciplina=null," 
			else
				sql = sql & "Cod_Disciplina=" & intCodDisciplina & ","
			end if
			if strTipoContratacao = "C" then
				sql = sql & "periodo_Inicial = null,"
				sql = sql & "periodo_Final = null,"
			else
				sql = sql & "periodo_Inicial = '" & formatadataBD(strPeriodoInicial) & "',"
				sql = sql & "periodo_Final = '" & formatadataBD(strPeriodoFinal) & "',"
			end if
			
			if strDataInicio = "" then
				sql = sql & "DataInicial = null," 
			else
				sql = sql & "DataInicial = '" & formatadataBD(strDataInicio) & "',"
			end if
			
			if strDataFinal = "" then
				sql = sql & "DataFinal = null," 
			else
				sql = sql & "DataFinal = '" &  formatadataBD(strDataFinal)  & "',"
			end if
	
			sql = sql & " Total_Aulas = " & intTotalAulas & ","
			sql = sql & " Situacao_disciplinar = '" & strTipoLancamento & "'"
			sql = sql & " Where Codigo = " & intCodigo

'response.Write(sql)
			cnn.execute sql
			GravarLog sql
		
		else
		'response.Write("<br>passou2")
		'response.End()		
			' Inativa a modulacao anterior
			sql = " Update SRH_MODULACAO_DISCIPLINAR_DOCENTE set  "
			if strDataFinal = "" then
				sql = sql & " DataFinal = null," 
				sql = sql & " periodo_Final = null," 
			else
				if strTipoContratacaoGravar = "C" then
					sql = sql & " DataFinal = '" &  formatadataBD(DateAdd("d",-1,strDataInicio))  & "',"
					sql = sql & " periodo_final = '" &  formatadataBD(DateAdd("d",-1,strDataInicio))  & "',"
				elseif strTipoContratacaoGravar = "A" then
					sql = sql & " DataFinal = '" & formatadataBD(DateAdd("d",-1,strPeriodoInicial)) & "',"
					sql = sql & " periodo_final = '" & formatadataBD(DateAdd("d",-1,strPeriodoInicial)) & "',"
				end if				
			end if
			sql = sql & " status = 'I' "
			sql = sql & " Where Codigo = " & intCodigo
			cnn.execute sql
		
			if strTipoModulacao = "PROFESSOR" then
				'validar no interdisciplinar:
				'só pode lançar 1 por turno não importa a unidade
				if intCodTurnoOpcional = "" then intCodTurnoOpcional = "0"
				sql = "select isnull(count(*),0) as qtde"
				sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE"
				sql = sql & " where cod_colaborador = "&intCodColaborador
				sql = sql & " and status = 'A'"
				sql = sql & " and ano_letivo = "&strAnoLetivo
				sql = sql & " and semestre = "&intSemestre
				if intCodTurnoOpcional <> "0" then
					sql = sql & " and cod_turno_opcional = "&intCodTurnoOpcional
				else
					sql = sql & " and cod_turno = "&intCodTurno
				end if
				sql = sql & " and situacao_disciplinar = 'I'"
				rs.open sql, cnn
				if rs.eof = false then
					IF rs("qtde") > 0 then
						%>
							<script>
								alert("Professor já modulado nesse turno.");
								window.location="ModulacaoNovo_cad.asp?TipoContratacao=<%=strTipoContratacao%>&txtCodFuncionario=<%=intCodColaborador%>";
							</script>
							<%
							response.end
					end if
				end if
				rs.close
	
			end if	
			if strTotalContratoNivel > 0 then
				if strTipoLancamento = "I" then
					total = cINT(strTotalModulado) + (cINT(intTotalAulas)*21)
				else
					total = cINT(strTotalModulado) + cINT(intTotalAulas)
				end if
				'response.Write("<br>strTotalModulado:" & strTotalModulado)
				'response.Write("<br>intTotalAulas:" & intTotalAulas)
				'response.Write("<br>strTotalContratoNivel:" & strTotalContratoNivel)
				'response.Write("<br>total:" & total)
				'response.end
				mensagemBloq = "N"
				if intTotalAulas = "" then intTotalAulas = 0
				if session("codGrupo")="7" then
					if strTotalContratoNivel = 14 then
						if total-intTotalAulas > 20 then
							mensagemBloq = "S"
						end if 
					elseif strTotalContratoNivel = 21 then
						if total-intTotalAulas > 27 then
							mensagemBloq = "S"
						end if 
					elseif strTotalContratoNivel = 28 then
						if total-intTotalAulas > 42 then
							mensagemBloq = "S"
						end if 			
					elseif strTotalContratoNivel > 42 then
						if total-intTotalAulas > 42 then
							mensagemBloq = "B"
							msn = 42
						end if 
					end if
				else
					if strTotalContratoNivel = 14 then
						if total-intTotalAulas > 20 then
							mensagemBloq = "S"
						end if 
					elseif strTotalContratoNivel = 21 then
						if total-intTotalAulas > 27 then
							mensagemBloq = "S"
						end if 
					elseif strTotalContratoNivel = 28 then
						if total-intTotalAulas > 42 then
							mensagemBloq = "S"
						end if 			
					elseif strTotalContratoNivel > 42 then
						if total-intTotalAulas > 42 then
							mensagemBloq = "B"
							msn = 42
						end if 
					end if
				end if

				IF mensagemBloq = "S" and PorPeriodo <> "S" then
					%>
					<script>
						alert("O nível do funcionário deve ser alterado.");
						window.location="ModulacaoNovo_cad.asp?TipoContratacao=<%=strTipoContratacao%>&txtCodFuncionario=<%=intCodColaborador%>";
					</script>
					<%
					response.end
				end if
				IF mensagemBloq = "B" then
					%>
					<script>
						alert("Os lançamento para esse funcionário chegou ao limite de <%=msn%>, não poderá mais ser lançado.");
						window.location="ModulacaoNovo_cad.asp?TipoContratacao=<%=strTipoContratacao%>&txtCodFuncionario=<%=intCodColaborador%>";
					</script>
					<%
					response.end
				end if
			
			end if		
			
			strTipoContratacaoGravar = "C"
			if PorPeriodo = "S" then strTipoContratacaoGravar = "A"
			if intCodCurso = "" then intCodCurso = "0"
			
			if strTipoModulacao = "FUNCIONARIO"  then intCodCurso = intCodCursoCombo
			if intCodCurso = "" then intCodCurso = "0"
			
			strMensagem = "Registro incluido com sucesso..."
			sql = "Insert Into SRH_MODULACAO_DISCIPLINAR_DOCENTE (Cod_Colaborador, tipoModulacao, Ano_Letivo, Semestre, Cod_empresa, Cod_Curso, "
			sql = sql & " Cod_periodo, Cod_Turno, Cod_turno_opcional, Cod_funcao, Cod_Disciplina, Total_Aulas, Situacao_disciplinar, "
			sql = sql & " status, data_ativacao, periodo_inicial, periodo_final,DataInicial, DataFinal, tipo_contratacao)"
			sql = sql & " Values ("
			sql = sql & "" & intCodColaborador & ","
			sql = sql & "'" & strTipoModulacao & "',"
			sql = sql & "" & strAnoLetivo & ","
			sql = sql & "" & intSemestre & ","
			sql = sql & "" & intCodEmpresaGrupo & ","
			
			if intCodCurso = "0" then
				sql = sql & " null,"
			else
				sql = sql & "" & intCodCurso & ","
			end if
			if intCodPeriodo = "0" then
				sql = sql & " null,"
			else
				sql = sql & "" & intCodPeriodo & ","
			end if
			
			sql = sql & "" & intCodTurno & ","
			if intCodTurnoOpcional = "0" then
				sql = sql & "null," 
			else
				sql = sql & "" & intCodTurnoOpcional & ","
			end if
			sql = sql & "" & intCodFuncao & ","
			if intCodDisciplina="0" or intCodDisciplina="" then
				sql = sql & "null," 
			else
				sql = sql & "" & intCodDisciplina & ","
			end if
			sql = sql & "" & intTotalAulas & ","
			sql = sql & "'" & strTipoLancamento & "',"
			sql = sql & "'A',"
			sql = sql & "'" & formatadataBD(date) & "',"
			if strTipoContratacaoGravar = "C" then
				sql = sql & "null,"
				sql = sql & "null,"
				sql = sql & "'" & formatadataBD(strDataInicio)  &  "',"
				sql = sql & "'" & formatadataBD(strDataFinal) & "',"
			elseif strTipoContratacaoGravar = "A" then 'por periodo
				sql = sql & "'" & formatadataBD(strPeriodoInicial) & "',"
				sql = sql & "'" & formatadataBD(strPeriodoFinal) & "',"
				sql = sql & "'" & formatadataBD(strPeriodoInicial) & "',"
				sql = sql & "'" & formatadataBD(strPeriodoFinal) & "',"
			end if
			
			sql = sql & "'" & strTipoContratacaoGravar & "')"
		
			cnn.execute sql
			GravarLog sql
			
			'atualizar o nivel
			intCodNivel = request("cmbNivel")
			if intCodNivel<>"0" then 
				sql = "update srh_colaborador set Cod_nivel = " & intCodNivel & " where codigo = " & intCodColaborador 
				cnn.execute sql
				GravarLog sql	
			end if
		
		end if

	else
	
		strMensagem = "Registro Excluido com sucesso..."
		if strTipoContratacao = "C" then
			'Validar no interdisciplinar:
			'Só pode lançar 1 por turno não importa a unidade
			sql = "select isnull(count(*),0) as qtde"
			sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE"
			sql = sql & " where cod_colaborador = "&intCodColaborador
			sql = sql & " and ano_letivo = "&strAnoLetivo
			sql = sql & " and semestre = "&intSemestre
			sql = sql & " and tipo_contratacao = 'A'"
			rs.open sql, cnn
			if rs.eof = false then
				IF rs("qtde") > 0 then
					'rs.close
					%>
					<script>
						alert("Existem lançamentos adicionais.");
						//window.location="ModulacaoNovo_cad.asp?TipoContratacao=<=strTipoContratacao%>&txtCodFuncionario=<=intCodColaborador%>";
					</script>
					<%
				end if
			end if
			rs.close
		end if			
		
		
		sql = "Delete from SRH_MODULACAO_DISCIPLINAR_DOCENTE "
		sql = sql & " Where Codigo = " & intCodigo
		cnn.execute sql
		GravarLog sql

		'
		'Atualiza empresa conforme a modulação do usuário.
		'
		sql = "SELECT codigo_seg_usuarios_sistema "
		sql = sql & " FROM 	SRH_COLABORADOR"
		sql = sql & " Where codigo = " & intCodColaborador
		rs.open sql, cnn
		if rs.eof = false then
			strUsuarioPortal 	= TRIM(rs("codigo_seg_usuarios_sistema"))
		end if
		rs.close	
      
	    if strUsuarioPortal <> "" then
			sql = "select COD_EMPRESA from SEG_USUARIOS_EMPRESA where cod_empresa NOT in "
			sql = sql & " (select distinct cod_empresa from SRH_MODULACAO_DISCIPLINAR_DOCENTE "
			sql = sql & " where cod_colaborador = " & intCodColaborador & ")"
			sql = sql & " AND CODIGO_SEG_USUARIOS_SISTEMA = '" & strUsuarioPortal & "'"
			rs.open sql, cnn
			if rs.eof = false then
				intcodLotacao 		= TRIM(rs("cod_empresa"))
			end if
			rs.close
			
			if intcodLotacao <> "" then
				sql = "Delete from SEG_USUARIOS_EMPRESA "
				sql = sql & " Where COD_EMPRESA  IN (" & intcodLotacao & ")"
				sql = sql & " AND CODIGO_SEG_USUARIOS_SISTEMA = '" & strUsuarioPortal & "'"
				cnn.execute sql
				GravarLog sql
			end if	
		end if

	end if
	
	'
	'Atualiza empresa conforme a modulação do usuário.
	'
	sql = "SELECT top 1 cod_empresa"
	sql = sql & " FROM 	SRH_MODULACAO_DISCIPLINAR_DOCENTE"
	sql = sql & " Where cod_colaborador = " & intCodColaborador
	sql = sql & " order by codigo desc "
	rs.open sql, cnn
	if rs.eof = false then
		intcodLotacao 		= TRIM(rs("cod_empresa"))
	end if
	rs.close	

	sql = "SELECT codigo_seg_usuarios_sistema "
	sql = sql & " FROM 	SRH_COLABORADOR"
	sql = sql & " Where codigo = " & intCodColaborador
	rs.open sql, cnn
	if rs.eof = false then
		strUsuarioPortal 	= TRIM(rs("codigo_seg_usuarios_sistema"))
	end if
	rs.close	

	if intcodLotacao <> "" and strUsuarioPortal <> "" then

		sql = "SELECT COD_EMPRESA FROM SEG_USUARIOS_EMPRESA " 
		sql = sql & " where CODIGO_SEG_USUARIOS_SISTEMA = '"& strUsuarioPortal & "'"
		sql = sql & " AND COD_EMPRESA = " & intcodLotacao
		rs.open sql,cnn
		if rs.eof = false then
		   JaExiste = True
		else
		   JaExiste = False
		end if		
		rs.close
		
		if JaExiste = True then
			sql = " Update SEG_USUARIOS_EMPRESA "
			sql = sql & " set COD_EMPRESA = " & intcodLotacao
			sql = sql & " where CODIGO_SEG_USUARIOS_SISTEMA = '"& strUsuarioPortal & "'"
			sql = sql & " AND COD_EMPRESA = " & intcodLotacao
			cnn.execute sql
			GravarLog sql
		else
		
			sql = " insert into SEG_USUARIOS_EMPRESA (CODIGO_SEG_USUARIOS_SISTEMA, COD_EMPRESA )"
			sql = sql & " VALUES ('" & strUsuarioPortal & "' , '" & intcodLotacao & "')"
			cnn.execute sql
			GravarLog sql
		end if

	end if	
	
	if session("codGrupo") = "7" then


		'ATUALIZA PONTO - FAIXA 
		sql = "EXECUTE SP_APO_Atualiza_Faixa_Horario " & strAnoLetivo & "," & session("CodGrupo") & "," & intCodColaborador
		cnn.execute sql
		
		'ATUALIZA PONTO - LOTACAO
		sql = "EXECUTE SP_APO_Atualiza_Lotacao_Ponto " & strAnoLetivo & "," & session("CodGrupo") & "," & intCodColaborador
		cnn.execute sql
		
	end if

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location="ModulacaoNovo_cad.asp?TipoContratacao=<%=strTipoContratacao%>&txtCodFuncionario=<%=intCodColaborador%>";
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.location="ModulacaoNovo_cad.asp?TipoContratacao=<%=strTipoContratacao%>&txtCodFuncionario=<%=intCodColaborador%>";
		</script>
		<%
	end if
%>