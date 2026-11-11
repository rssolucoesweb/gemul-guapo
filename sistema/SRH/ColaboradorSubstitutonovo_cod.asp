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
	acao 							= Trim(Request.QueryString("acao"))
	intCodEmp						= Session("CodEmpresa")
	intCodGrupo						= Session("CodGrupo")
	strAnoLetivo 					= session("strAnoLetivo")
	strSemestre 					= session("strSemestre")
	intCodTurnoColaboradorSubstituido	= Trim(Request.Form("cmbTurnoColaboradorSubstituido"))

	' Colaborador Substituto
	intCodEmpresaSubstituto			= Trim(Request("txtCodEmpresaSubstituto"))
	intCodColaboradorSubstituto		= Trim(Request("txtCodColaboradorSubstituto"))
	strNomeColaboradorSubstituto	= Trim(Request("txtNomeColaboradorSubstituto"))
	
	'Colaborador Substituido
	intCodEmpresaSubstituido			= Trim(Request("txtCodEmpresaSubstituido"))
	intCodColaboradorSubstituido		= Trim(Request("txtCodColaboradorSubstituido"))
	strNomeColaboradorSubstituido		= Trim(Request("txtNomeColaboradorSubstituido"))
	
	' Dados Colaborados
	intCodCodSubistituicao		 		= Trim(Request.Form("chkCodSubistituicao"))
	vetSubistituicao					= split(intCodCodSubistituicao,",")
	
	strDataInicial						= formataDataBD(Trim(Request.Form("txtDataInicial"))) 
	strDataFinal						= formataDataBD(Trim(Request.Form("txtDataFinal"))) 
	strSituacao							= "A" 
    strEmail                            = Trim(Request.Form("txtHiddenEmailColaboradorSubstituto"))
	'strRequestSubstituicoes				= Trim(Request.Form("txtRequestSubstituicoes"))
	'vetRequestSubstituicoes				= split(strRequestSubstituicoes,",")
	
	'Testando se e um defict 
	if intCodColaboradorSubstituido = "" then intCodColaboradorSubstituido = "0"
	if intCodEmpresaSubstituido = "" then intCodEmpresaSubstituido = Session("CodEmpresa")

	if acao = "I" then
	
		if intCodColaboradorSubstituido <> "" and intCodColaboradorSubstituido <> "0" then
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
		else
			codLancamentoFalta = ""
		end if	
		'		response.write sql
'			response.End()
	
		if codLancamentoFalta = "" then 
			cnn.rollbackTrans
			%>
			<script>
				alert("O lancamento de frequencia localizado nao corresponde ao periodo de frequencia informado.");
				window.history.back();
			</script>
			<%
			response.end
		end if
		
	end if
	
   	if acao <> "E" and acao <> "INATIVAR" then
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
		if rs.eof = false then
			if rs("qtde")=0 then
				cnn.rollbackTrans
				%>
				<script>
					alert("Essa licença não informada ou não abonada na movimentação.");
					window.location='ColaboradorSubstitutoNovo_cad.asp';
				</script>
				<%
				response.end
			end if
		end if
		rs.close
		
	end if
	
	if acao="I" then

		sql = " SELECT "
		sql = sql & " HA.Cod_turma, " 
		sql = sql & " T.NOMETURMA, " 
		sql = sql & " P.Tipo AS SITUACAO_DISCIPLINAR, " 
		sql = sql & " TRH.DESC_TURNO AS TURNO, "
		sql = sql & " TRH.Cod_Turno, " 
		sql = sql & " '' AS DESC_TURNO_OPCIONAL, " 
		sql = sql & " HA.ANOLETIVO, " 
		sql = sql & " HA.SEMESTRE, " 
		sql = sql & " E.RAZAOSOCIAL, " 
		sql = sql & " P.DESCRICAO AS PERIODO, "
		sql = sql & " P.COD_PERIODO, "  
		sql = sql & " ( CASE WHEN P.Tipo = 'I' and F.Situacao_Disciplinar = 'D' then D.DESC_DISCIPLINA WHEN P.Tipo = 'I' and F.Situacao_Disciplinar = 'I' then '' else D.DESC_DISCIPLINA end ) AS DISCIPLINA, "
		sql = sql & " ( CASE WHEN P.Tipo = 'I' and F.Situacao_Disciplinar = 'D' then D.Cod_Disciplina WHEN P.Tipo = 'I' and F.Situacao_Disciplinar = 'I' then '' else D.Cod_Disciplina end ) AS Cod_Disciplina, "
		sql = sql & " F.DESC_FUNCAO AS FUNCAO, "
		sql = sql & " F.Situacao_Disciplinar AS Situacao_Disciplinar, " 
		sql = sql & " ( CASE WHEN P.Tipo = 'I' and F.Situacao_Disciplinar = 'I' then '1' else COUNT(HA.CODIGO) end ) AS TOTAL_AULAS, "
		sql = sql & " ( CASE WHEN P.Tipo = 'I' and F.Situacao_Disciplinar = 'I' then '1' else COUNT(HA.CODIGO) end ) AS SALDO, "
		sql = sql & " 'A' AS STATUS, P.cod_curso, D.COD_DISCIPLINA, F.COD_FUNCAO, T.COD_EMPRESA as cod_empresa_turma, f.tipo_funcao" 
		sql = sql & " FROM SCA_HORARIO_AULA HA "
		sql = sql & " INNER JOIN SEG_EMPRESA E ON E.CODIGO = HA.COD_EMPRESA "
		sql = sql & " INNER JOIN SCA_TURMA T ON T.Cod_Turma = HA.Cod_turma "
		sql = sql & " INNER JOIN SCA_TURNO TU ON TU.COD_TURNO = T.COD_TURNO " 
		sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) AND TRH.COD_GRUPO = " & session("codGrupo")
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GradeCurricular = T.Cod_GradeCurricular "
		sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO = G.COD_PERIODO " 
		sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA = HA.COD_DISCIPLINA " 
		sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.CODIGO = HA.COD_COLABORADOR " 
		sql = sql & " LEFT JOIN SRH_FUNCAOCOLABORADOR F ON F.COD_FUNCAO = C.CODFUNCAO "
		sql = sql & " WHERE HA.ANOLETIVO = " & strAnoLetivo 
		sql = sql & " AND HA.Semestre = 3 " 
		sql = sql & " AND HA.COD_COLABORADOR = " & intCodColaboradorSubstituido
		sql = sql & " AND T.Situacao = 'A' " 
		''sql = sql & " AND TRH.Cod_Turno = " & intCodTurnoColaboradorSubstituido  
		sql = sql & " GROUP BY HA.Cod_turma, T.NOMETURMA, P.Tipo, TRH.DESC_TURNO, TRH.Cod_Turno, HA.ANOLETIVO, HA.SEMESTRE, E.RAZAOSOCIAL, P.DESCRICAO, P.COD_PERIODO, ( CASE WHEN P.Tipo = 'I' and F.Situacao_Disciplinar = 'D' then D.DESC_DISCIPLINA WHEN P.Tipo = 'I' and F.Situacao_Disciplinar = 'I' then '' else D.DESC_DISCIPLINA end ), ( CASE WHEN P.Tipo = 'I' and F.Situacao_Disciplinar = 'D' then D.Cod_Disciplina WHEN P.Tipo = 'I' and F.Situacao_Disciplinar = 'I' then '' else D.Cod_Disciplina end ), F.DESC_FUNCAO, F.Situacao_Disciplinar, P.cod_curso, D.COD_DISCIPLINA, F.COD_FUNCAO, T.COD_EMPRESA, f.tipo_funcao " 
		sql = sql & " ORDER BY E.RAZAOSOCIAL, P.DESCRICAO "	
		vetRequestSubstituicoes = null
		rs.open sql, cnn
		if not rs.eof then
			vetRequestSubstituicoes = rs.getRows
		end if
		rs.close
		
		strMensagem  = "Substituição incluída com sucesso!"
		cont = 0
		if isArray(vetRequestSubstituicoes) then
		
			for i=0 to ubound(vetRequestSubstituicoes,2)
			 	
			 	cont = cont + 1	
				
				codTurno	= vetRequestSubstituicoes(4,i)
				codFuncao	= vetRequestSubstituicoes(20,i)
				cod_empresa_turma = vetRequestSubstituicoes(21,i)
				strOptTipoModulacao = vetRequestSubstituicoes(22,i)
				codCurso 	= vetRequestSubstituicoes(18,i)
				codPeriodo 	= vetRequestSubstituicoes(10,i)
				codDisciplina 		= vetRequestSubstituicoes(19,i)
				codSitDisciplina 	= vetRequestSubstituicoes(14,i)
				if codSitDisciplina = "I" then codDisciplina = "0"

				intAulas = Trim(Request.form("txt"&cont))
					
				'response.write "<br>cont:" &cont & " - intAulas:" & intAulas
				if intAulas = "" then intAulas = 0

				if intAulas > 0  then
					strMensagem = "Registro incluido com sucesso..."
					
					sql = " SET NoCount ON Insert Into SRH_COLABORADOR_SUBSTITUTO(Cod_Empresa, Cod_Grupo, "
					sql = sql & " CodEmpresaSubstituto, CodColaboradorSubstituto, "
					sql = sql & " CodEmpresaSubstituido, CodColaboradorSubstituido, "
					sql = sql & " DataInicial, DataFinal, Situacao, Cod_turma, Cod_Disciplina, Total_Aulas, Cod_Lancamento_Falta)"
					sql = sql & " Values ("
					sql = sql & "" & intCodEmp & ","
					sql = sql & "" & intCodGrupo & ","
					sql = sql & "" & intCodEmpresaSubstituto & ","
					sql = sql & "" & intCodColaboradorSubstituto & ","
					sql = sql & "" & intCodEmpresaSubstituido & ","
					sql = sql & "" & intCodColaboradorSubstituido & ","
					sql = sql & "'" & strDataInicial & "',"
					sql = sql & "'" & strDataFinal & "',"
					sql = sql & "'" & strSituacao & "',"
					sql = sql & "" & vetRequestSubstituicoes(0,i) & ","
					sql = sql & "" & vetRequestSubstituicoes(12,i) & "," 
					sql = sql & "" & intAulas & "," 
					if codLancamentoFalta <> "" then
						sql = sql & "" & codLancamentoFalta & ")"
					else
						sql = sql & "null)"
					end if			
					sql = sql & " ;SELECT @@IDENTITY "
					'response.write sql & "<hr>"
					Set rs1 = cnn.Execute(sql)
					intCodSubstituicao = rs1(0)
					rs1.close
					intCodMensagem = 1 'Inclusao de Registro
					GravarLog sql

					sql = "Insert Into SRH_MODULACAO_DISCIPLINAR_DOCENTE (Cod_Colaborador, tipoModulacao, Ano_Letivo, Semestre, Cod_empresa, "
					sql = sql & " Cod_Curso, Cod_periodo, Cod_Turno, Cod_funcao, Cod_Disciplina, Total_Aulas, Situacao_disciplinar, status, "
					sql = sql & " data_ativacao, tipo_contratacao, periodo_inicial, periodo_final, datainicial, datafinal, Cod_Substituicao) "
					sql = sql & " Values ("
					sql = sql & "" & intCodColaboradorSubstituto & ","
					sql = sql & "'" & strOptTipoModulacao & "',"
					sql = sql & "" & session("strAnoLetivo") & ","
					sql = sql & "" & session("strSemestre") & ","
					sql = sql & "" & trim(cod_empresa_turma) & ","
					if trim(codCurso) = "0" then
						sql = sql & " null,"
					else
						sql = sql & "" & trim(codCurso) & ","
					end if
					if trim(codPeriodo) = "0" then
						sql = sql & " null,"
					else
						sql = sql & "" & trim(codPeriodo) & ","
					end if
					sql = sql & "" & trim(intCodTurnoColaboradorSubstituido) & ","
		
					sql = sql & "" & trim(codFuncao) & ","
					
					if trim(codDisciplina)="0" or trim(codDisciplina)="" then
						sql = sql & "null," 
					else
						sql = sql & "" & trim(codDisciplina) & ","
					end if
					
					sql = sql & "" & intAulas & ","
					sql = sql & "'" & trim(codSitDisciplina) & "',"
					sql = sql & "'A',"
					sql = sql & "'" & formatadataBD(date) & "',"
					sql = sql & "'C',"
					sql = sql & "'" & formatadataBD(strDataInicial) & "',"
					sql = sql & "'" & formatadataBD(strDataFinal) & "',"
					sql = sql & "'" & formatadataBD(strDataInicial) & "',"
					sql = sql & "'" & formatadataBD(strDataFinal) & "',"					
					sql = sql & "" & intCodSubstituicao & ")"
					'response.write sql & "<hr>"
					cnn.execute sql
					GravarLog sql
		
				end if
			next
		end if
		vetRequestSubstituicoes = null

	    if trim(strEmail) <> "" and isnull(strEmail) = false then
    
	        sql = "SELECT CB.Codigo, CB.Cod_Empresa, CB.Cod_Grupo, CodEmpresaSubstituto, C.CodFuncional, CSS.CodFuncional as SUB_CodSubstituido, "
	        sql = sql & " isnull(CodColaboradorSubstituto,0) as CodColaboradorSubstituto, CodEmpresaSubstituido, ESUBT.RAZAOSOCIAL AS EMP_SUBSTITUTO, ESUBI.RAZAOSOCIAL AS EMP_SUBSTITUIDO, "
	        sql = sql & " isnull(CodColaboradorSubstituido,0) as CodColaboradorSubstituido, DataInicial, DataFinal, CB.Situacao,"
	        sql = sql & " isnull(CSS.nome,'DÉFICIT') as NomeSubstituido, C.nome as NomeSubstituto, E.MANTENEDORA"
	        sql = sql & " FROM SRH_COLABORADOR_SUBSTITUTO CB"
	        sql = sql & " inner join SEG_EMPRESA E on E.codigo = CB.Cod_empresa "
	        sql = sql & " left join SRH_COLABORADOR C on C.codigo = CB.CodColaboradorSubstituto "
	        sql = sql & " left join SRH_COLABORADOR CSS on CSS.codigo = CB.CodColaboradorSubstituido	"
	        sql = sql & " left join SEG_EMPRESA ESUBT on ESUBT.codigo = CB.CodEmpresaSubstituto	"
	        sql = sql & " left join SEG_EMPRESA ESUBI on ESUBI.codigo = CB.CodEmpresaSubstituido 	"
	        sql = sql & " WHERE CB.CODIGO = "& intCodSubstituicao            
            'response.write sql
            'response.End
	        rs.open sql, cnn
	        if rs.eof = false then            
    	        strMANTENEDORA = UCASE(rs("MANTENEDORA"))
                strEmp_substituido = rs("emp_substituido")
                intCodColaboradorSubstituido = rs("CodColaboradorSubstituido")
                strNomeSubstituto = trim(rs("NomeSubstituto"))
                intCodFuncional = rs("codFuncional")
                strDataInicial = formatadataAP(rs("dataInicial"))  
                strDataFinal = formatadataAP(rs("dataFinal")) 
                strNomeSubstituido = trim(rs("nomeSubstituido"))
                intCodSubstituido = rs("SUB_CodSubstituido")
                strDataAtual = day(date) & " de " & monthName(month(date)) & " de " & year(date) & "."                
            end if
            rs.close

	        strEmailOrigem	 = "webmaster@sisge.com.br"
	        strAssuntoEmail	 = "Aviso de Substituição"  
	        strMensagemEmail = "<br><br> <strong>DA: " & strMANTENEDORA & "</strong><br><br>"
            strMensagemEmail = strMensagemEmail & "<strong>PARA: " & strEmp_substituido & "<br><br>"
            if intCodColaboradorSubstituido=0 then
	            strMensagemEmail = strMensagemEmail & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Estamos encaminhando o (a) Senhor (a)"
                strMensagemEmail = strMensagemEmail & "<strong>" & strNomeSubstituto & "</strong> matrícula número <strong>"
                strMensagemEmail = strMensagemEmail & intCodFuncional & "</strong>, para que o (a) mesmo (a) possa exercer a função de Professor (a), "
                strMensagemEmail = strMensagemEmail & " em substituição a DÉFICIT, com início em <strong>" & strDataInicial & "</strong>."            
            else
	            strMensagemEmail = strMensagemEmail & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Estamos encaminhando o (a) Senhor (a)"
                strMensagemEmail = strMensagemEmail & "<strong>" & strNomeSubstituto & "</strong> matrícula número <strong>"
                strMensagemEmail = strMensagemEmail & intCodFuncional & "</strong>, para que o (a) mesmo (a) possa exercer a função de Professor (a), "
                strMensagemEmail = strMensagemEmail & " em substituição a Licença Médica do (da) Professor (a) <strong>" & strNomeSubstituido & "</strong>"
                strMensagemEmail = strMensagemEmail & " , matrícula número <strong>"&intCodSubstituido& "</strong> , apartir de <strong>"&strDataInicial &"</strong>"
                strMensagemEmail = strMensagemEmail & " a <strong>"&strDataFinal& "</strong>."  
            end if
            strMensagemEmail = strMensagemEmail & "<br><br> "
	        strMensagemEmail = strMensagemEmail & " Atenciosamente, <br><br><br>"
	        strMensagemEmail = strMensagemEmail & " Aparecida de Goiânia," & strDataAtual & "<br><br><br><br><br>"
	        strMensagemEmail = strMensagemEmail & " <center>___________________________________________</center><br>"
            strMensagemEmail = strMensagemEmail & " <center>Ass. do Funcionário do RH - SME</center><br><br><br>"
            strMensagemEmail = strMensagemEmail & " <center>___________________________________________</center><br>"
            strMensagemEmail = strMensagemEmail & " <center>Servidor / Gestor da Unidade</center>"


		    'Envia um email sobre o aviso do professor (a) substituida.
		   ' EnviarEmail strEmailOrigem, strEmail, strAssuntoEmail, strMensagemEmail
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
		
		strMensagem  = "Substituição Inativada com sucesso!"
		
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

	
	elseif acao = "E" then

		strMensagem = "Substituição Excluída com sucesso!"

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

	'ATUALIZA PONTO - FAIXA 
	'sql = "EXECUTE SP_APO_Atualiza_Faixa_Horario " & strAnoLetivo & "," & session("CodGrupo") & "," & intCodColaboradorSubstituto
	'cnn.execute sql
	
	'ATUALIZA PONTO - LOTACAO
	'sql = "EXECUTE SP_APO_Atualiza_Lotacao_Ponto " & strAnoLetivo & "," & session("CodGrupo") & "," & intCodColaboradorSubstituto
	'cnn.execute sql
	
	'ATUALIZA PONTO - FAIXA 
	'sql = "EXECUTE SP_APO_Atualiza_Faixa_Horario " & strAnoLetivo & "," & session("CodGrupo") & "," & intCodColaboradorSubstituido
	'cnn.execute sql
	
	'ATUALIZA PONTO - LOTACAO
	'sql = "EXECUTE SP_APO_Atualiza_Lotacao_Ponto " & strAnoLetivo & "," & session("CodGrupo") & "," & intCodColaboradorSubstituido
	'cnn.execute sql
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='ColaboradorSubstitutoNovo_cad.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>