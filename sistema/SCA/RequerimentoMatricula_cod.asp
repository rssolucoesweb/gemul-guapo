<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 29/08/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@gmail.com
	::	Objetivo Pagina...: requerimento de matricula
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_replaceRequest.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))

	'carregando variavel
	'chave
	strCod_empresa 		= Session("CodEmpresa")
	strSemestre 		= session("strSemestre")
	strAnoLetivo 		= session("strAnoLetivo")

	strSemestreDestino 	= session("strSemestre")
	strAnoLetivoDestino	= session("strAnoLetivo")
	
	intCodigo 			= Trim(Request.Form("txtCodAluno"))

	'turma
	strCodTurma		= cLng(left(ReplaceRequest(Trim(Request.Form("cmbTurma"))),8))
	if 	strCodTurma = "" then strCodTurma = "0"
	
	'turma anterior
	strCodTurmaAnterior		= left(ReplaceRequest(Trim(Request.Form("txtCodTurmaAtual"))),8)
	if 	strCodTurmaAnterior = "" then strCodTurmaAnterior = "0"
	strCodTurmaAnterior = cLng(strCodTurmaAnterior)

	strFoneResidencial 	= ReplaceRequest(Trim(Request.Form("txtFoneResidencial")))
	strFonecomercial 	= ReplaceRequest(Trim(Request.Form("txtFonecomercial")))
	strFoneCelular	 	= ReplaceRequest(Trim(Request.Form("txtFonecelular")))
	strEmail 			= ReplaceRequest(Trim(Request.Form("txtEmail")))

	'endereço
	strLogradouro 		= ReplaceRequest(Trim(Request.Form("txtLogradouro")))
	strNumero_endereco 	= ReplaceRequest(Trim(Request.Form("txtNumero_endereco")))
	strComp_endereco 	= ReplaceRequest(Trim(Request.Form("txtComp_endereco")))
	strBairroaluno 		= ReplaceRequest(Trim(Request.Form("txtBairroaluno")))
	strCidaderesidencia	= ReplaceRequest(Trim(Request.Form("txtCidaderesidencia")))
	strUfresidencia 	= ReplaceRequest(Trim(Request.Form("cmbUfresidencia")))
	if strUfresidencia = "" then strUfresidencia = "0"
	strCepresidencia 	= ReplaceRequest(Trim(Request.Form("txtCepresidencia")))

	IF strCodTurma <> "0" THEN
		sql = "SELECT COD_SEMESTRE" 
		sql = sql & " FROM SCA_TURMA"
		sql = sql & " WHERE COD_TURMA = " & strCodTurma
		sql = sql & " AND COD_EMPRESA = " & strCod_empresa
		rs.open sql, cnn
		if not RS.EOF then
			strSemestre = RS("COD_SEMESTRE")
		end if
		rs.close
	END IF

			
	if acao="I" then
		
		strMensagem = "Requerimento incluído com sucesso.\nClique em OK para imprimir o requerimento de matrícula."

		'incluir aluno na turma
		if strCodTurma <> "0" then

			'REGRA PARA NÃO DEIXAR DUPLICAR O REQUERIMENTO DE MATRICULA
			sql = "select s.Desc_SituacaoAluno"
			sql = sql & " from sca_aluno a"
			sql = sql & " inner join sca_situacaoaluno s on s.Cod_SituacaoAluno=a.COD_SITUACAOALUNO and s.Cod_Empresa=a.cod_empresa"
			sql = sql & " where replace(replace(s.Desc_SituacaoAluno,'É','E'),'Í','I') = 'PRE-MATRICULA'"
			sql = sql & " and a.codigo = "&intCodigo
			
			rs.open sql, cnn,3,3
			if not rs.eof then
				rs.close
				%>
				<script>
					alert("ATENÇÃO: \nEsse aluno já foi efetuada a renovação da matrícula.");
					window.history.back();
				</script>
				<%	
				response.End()
			end if
			rs.close
			'REGRA PARA VERIFICAR SE A DOCUMENTAÇÃO DO ALUNO ESTA EM DIAS
			sql = "select d.descricao as docs, ad.data_prorrogacao "
			sql = sql & " from SCA_ALUNO_DOCUMENTACOES ad"
			sql = sql & " inner join sca_documentacoes d on d.codigo=ad.cod_documentacoes"
			sql = sql & " where ad.cod_aluno = " & intCodigo
			sql = sql & " and d.cod_empresa = " & strCod_empresa
			sql = sql & " and ad.situacao = 'I'"
			strDocs = ""
			strMsn = false
			rs.open sql, cnn,3,3
			if not rs.eof then	
				while not rs.eof
					if not isnull(rs("data_prorrogacao")) then
						if rs("data_prorrogacao")<date then
							strMsn = true
							strDocs	= strDocs & "- " & rs("Docs") & "\n"
						end if
					else
						strMsn = true
						strDocs	= strDocs & "- " & rs("Docs") & "\n"
					end if
					rs.movenext
				wend
				rs.close
				if strMsn then
					%>
					<script>
						alert("ATENÇÃO: \nEsse aluno esta com a documentação irregular, favor verificar os documentos:\n\n<%=strDocs%>");
						window.history.back();
					</script>
					<%	
					response.End()
				end if
			end if
			rs.close	
			
			'REGRA PARA INCLUSAO DE SITUACAO - PREMATRICULA
			sql = "SELECT COD_SITUACAOALUNO " 
			sql = sql & " FROM SCA_SITUACAOALUNO"
			sql = sql & " WHERE COD_EMPRESA = " & strCod_empresa
			sql = sql & " AND Desc_SituacaoAluno = 'PRÉ-MATRÍCULA'"
			rs.open sql, cnn,3,3
			if RS.EOF then
				rs.close
				cnn.rollbackTrans
				%>
				<script>
					alert("ATENÇÃO: Deve ser cadastrada a situação PRÉ-MATRÍCULA.");
					window.history.back();
				</script>
				<%
				response.End()
			else
				strCod_situacaoaluno = rs("COD_SITUACAOALUNO")
			end if
			rs.close
			
	    	'atualiza o cadastro do aluno
			sql = "Update SCA_ALUNO Set "
			sql = sql & "COD_SITUACAOALUNO=" & strCod_situacaoaluno & ","
			if 	strLogradouro 	 = "" then
				sql = sql & "LOGRADOURO=NULL,"
			else
				sql = sql & "LOGRADOURO='" & strLogradouro & "',"
			end if
			if 	strNumero_endereco 	 = "" then
				sql = sql & "NUMERO_ENDERECO=NULL,"
			else
				sql = sql & "NUMERO_ENDERECO='" & strNumero_endereco & "',"
			end if
			if 	strComp_endereco 	 = "" then
				sql = sql & "COMP_ENDERECO=NULL,"
			else
				sql = sql & "COMP_ENDERECO='" & strComp_endereco & "',"
			end if
			if 	strBairroaluno 	 = "" then
				sql = sql & "BAIRROALUNO=NULL,"
			else
				sql = sql & "BAIRROALUNO='" & strBairroaluno & "',"
			end if
			if 	strCidaderesidencia 	 = "" then
				sql = sql & "CIDADERESIDENCIA=NULL,"
			else
				sql = sql & "CIDADERESIDENCIA='" & strCidaderesidencia & "',"
			end if
			if 	strUfresidencia 	 = "0" then
				sql = sql & "UFRESIDENCIA=NULL,"
			else
				sql = sql & "UFRESIDENCIA='" & strUfresidencia & "',"
			end if
			if 	strCepresidencia 	 = "" then
				sql = sql & "CEPRESIDENCIA=NULL,"
			else
				sql = sql & "CEPRESIDENCIA=" & strCepresidencia & ","
			end if
			if 	strFoneResidencial 	 = "" then
				sql = sql & "FONERESIDENCIAL=NULL,"
			else
				sql = sql & "FONERESIDENCIAL='" & strFoneResidencial & "',"
			end if		
			if 	strFonecomercial 	 = "" then
				sql = sql & "FONECOMERCIAL=NULL,"
			else
				sql = sql & "FONECOMERCIAL='" & strFonecomercial & "',"
			end if
			if 	strFoneCelular 	 = "" then
				sql = sql & "FONECELULAR=NULL,"
			else
				sql = sql & "FONECELULAR='" & strFoneCelular & "',"
			end if		
			if 	strEmail 	 = "" then
				sql = sql & "EMAIL=NULL"
			else
				sql = sql & "EMAIL='" & strEmail & "'"
			end if
			sql = sql & " Where Cod_Empresa = " & strCod_empresa
			sql = sql & " And CODIGO = " & intCodigo
			cnn.execute sql
			GravarLog sql

			strEscola = session("EmpresaWeb")
			strCidade = session("CidadeEmpresaWeb")	
			strUfResidencia = session("UFEmpresaWeb")	
		
			sql = "select top 1 P.DESCRICAO AS PERIODO, C.DESCRICAO AS CURSO, T.ANOLETIVO, T.COD_SEMESTRE,T.Cod_Turma"
			sql = sql & " from SCA_ALUNO_TURMA AT "
			sql = sql & " LEFT JOIN SCA_TURMA T ON AT.COD_TURMA = T.Cod_Turma AND AT.COD_EMPRESA = T.COD_EMPRESA"
			sql = sql & " LEFT JOIN SCA_TURNO TU ON TU.COD_TURNO = T.Cod_TURNO AND TU.COD_EMPRESA = T.COD_EMPRESA"
			sql = sql & " LEFT JOIN SCA_GRADECURRICULAR G ON T.Cod_GradeCurricular = G.Cod_GradeCurricular AND T.COD_EMPRESA = G.COD_EMPRESA"
			sql = sql & " LEFT JOIN SCA_PERIODO P ON P.COD_EMPRESA = T.COD_EMPRESA AND P.COD_PERIODO = G.COD_PERIODO"
			sql = sql & " LEFT JOIN SCA_CURSO C ON C.COD_CURSO = P.COD_CURSO AND C.COD_EMPRESA = P.COD_EMPRESA"
			sql = sql & " where AT.cod_empresa = " & strCod_empresa
			sql = sql & " and AT.cod_aluno = " & intCodigo
			sql = sql & " and AT.situacao = 'A'"
			sql = sql & " order by 1 desc"

			rs.open sql, cnn,3,3
			if not RS.EOF then
             	strCodTurmaAnterior = rs("Cod_turma")
				strAnoHistorico = rs("anoletivo")
				strSemestreHistorico = rs("cod_semestre")
				strCurso = rs("curso")
				strSerie = rs("periodo")
				strGeraHistorico = true
			else
				strGeraHistorico = false
			end if
			rs.close		

			strCodUfResidencia = ""
			sql = " select codigo from scf_uf"
			sql = sql & " where sigla = '"&strUfResidencia&"'"
			rs.open sql, cnn,3,3
			if not RS.EOF then
				strCodUfResidencia = rs("codigo")
			end if
			rs.close
						
			'Localizando a maior sequencia da turma anterior do aluno
			sql = "SELECT Max(SEQUENCIA) as MaiorSeq" 
			sql = sql & " FROM SCA_ALUNO_TURMA"
			sql = sql & " where COD_TURMA = " & strCodTurmaAnterior
			sql = sql & " and COD_EMPRESA = " & strCod_empresa
			rs.open sql, cnn,3,3
			if not RS.EOF then
			  if rs("MaiorSeq") <> "" then
					intSequencia = cstr(rs("MaiorSeq")) + 1
				else
					intSequencia = 1	
				end if
			end if
			rs.close

			intCodigoTurmaInativa=" "
			sql = "SELECT top 1 codigo" 
			sql = sql & " FROM SCA_ALUNO_TURMA"
			sql = sql & " where COD_TURMA = " & strCodTurmaAnterior
			sql = sql & " and COD_EMPRESA = " & strCod_empresa
			sql = sql & " order by codigo desc"
			rs.open sql, cnn,3,3
			if not RS.EOF then
			    intCodigoTurmaInativa = rs("codigo")
			end if
			rs.close
    
			'inativa a turma anterior se existir
			sql = "update SCA_ALUNO_TURMA "
			sql = sql & " SET SITUACAO = 'R'," 
			sql = sql & " DATA_SITUACAO = '" &formataDataBD(date)& " " &time& "' " 
			sql = sql & " where CODIGO = " & intCodigoTurmaInativa
			cnn.execute sql
			GravarLog sql			
    
			strSituacaoNaTurma = "A" 'ativo na turma
			sql = "insert into SCA_ALUNO_TURMA (COD_EMPRESA, COD_ALUNO, COD_TURMA, SEQUENCIA, ANO_LETIVO, SEMESTRE, SITUACAO, DATA_SITUACAO) VALUES ("
			sql = sql & "" & strCod_empresa & "," 
			sql = sql & "" & intCodigo & "," 
			sql = sql & "" & strCodTurma & "," 
			sql = sql & "" & intSequencia & "," 
			sql = sql & "" & strAnoLetivo & "," 
			sql = sql & "" & strSemestre & "," 
			sql = sql & "'" & strSituacaoNaTurma & "'," ' A - ATIVA | R - REMANEJADA
			sql = sql & "'"&formataDataBD(date)& " " &time& "')" 
			cnn.execute sql
			GravarLog sql

			'copia o espelho da grade da turma e inclui ao aluno
			sql = "SELECT GD.COD_GRADECURRICULARDISCIPLINA, GD.COD_DISCIPLINA"
			sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA GD"
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR"
			sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_GRADECURRICULAR = GD.COD_GRADECURRICULAR AND T.COD_EMPRESA = G.COD_EMPRESA"
			sql = sql & " WHERE	T.COD_TURMA = " & strCodTurma
			sql = sql & " AND	T.COD_EMPRESA = " & strCod_empresa
			sql = sql & " AND	G.SITUACAO = 'A'"'GRADE ATIVA

			rs.open sql, cnn,3,3
			if not RS.EOF then
				while not rs.eof
					sql = "SELECT HD.SITUACAO"
					sql = sql & " FROM SCA_HISTORICO_ESCOLAR H"
					sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR_DISCIPLINA HD ON HD.cod_historico_escolar = H.CODIGO"
					sql = sql & " WHERE	H.COD_ALUNO = " & intCodigo
					sql = sql & " AND	HD.COD_GRADECURRICULARDISCIPLINA = " & rs("COD_GRADECURRICULARDISCIPLINA")				
					sql = sql & " AND	H.COD_EMPRESA = " & strCod_empresa
					Rs1.open sql, cnn,3,3
					if Rs1.EOF then				
				
						sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO,COD_GRADECURRICULARDISCIPLINA, COD_DISCIPLINA, SITUACAO) VALUES ("
						sql = sql & "" & strCod_empresa & "," 
						sql = sql & "" & intCodigo & "," 
						sql = sql & "" & strCodTurma & "," 
						sql = sql & "" & strCodTurma & "," 
						sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
						sql = sql & "" & rs("COD_DISCIPLINA") & "," 
						sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
						cnn.execute sql
						GravarLog sql		
										
					else
						IF ISNULL(Rs1("SITUACAO")) THEN
							sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO,COD_GRADECURRICULARDISCIPLINA, COD_DISCIPLINA, SITUACAO) VALUES ("
							sql = sql & "" & strCod_empresa & "," 
							sql = sql & "" & vetAluno(i) & "," 
							sql = sql & "" & strCodTurma & "," 
							sql = sql & "" & strCodTurma & "," 
							sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
							sql = sql & "" & rs("COD_DISCIPLINA") & "," 
							sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
							cnn.execute sql
							GravarLog sql		
						ELSE
							IF Rs1("SITUACAO") <> "AP" and Rs1("SITUACAO") <> "DI" then
		
								sql = "insert into SCA_ALUNO_DISCIPLINA (COD_EMPRESA, COD_ALUNO, COD_TURMA, COD_TURMA_REMANEJAMENTO,COD_GRADECURRICULARDISCIPLINA, COD_DISCIPLINA, SITUACAO) VALUES ("
								sql = sql & "" & strCod_empresa & "," 
								sql = sql & "" & vetAluno(i) & "," 
								sql = sql & "" & strCodTurma & "," 
								sql = sql & "" & strCodTurma & "," 
								sql = sql & "" & rs("COD_GRADECURRICULARDISCIPLINA") & "," 
								sql = sql & "" & rs("COD_DISCIPLINA") & "," 
								sql = sql & "'CR')" 'CURRICULAR COMO DEFAULT
								cnn.execute sql
								GravarLog sql		
							
							END IF
						END IF
					end if
					Rs1.Close	
								
					rs.movenext
				wend
			end if
			rs.close	
			
			if strGeraHistorico then
				'REGRA PARA INCLUSAO DE SITUACAO - PREMATRICULA
			    sql = "SELECT cod_aluno " 
			    sql = sql & " FROM SCA_HISTORICO_ESCOLAR"
			    sql = sql & " WHERE COD_EMPRESA = " & strCod_empresa
			    sql = sql & " AND cod_aluno = " & intCodigo
				sql = sql & " AND ano_letivo = " & strAnoHistorico
				sql = sql & " AND semestre = " & strSemestreHistorico
				rs.open sql, cnn
				if NOT RS.EOF then
					rs.close
					cnn.rollbackTrans
					%>
			 		<script>
			 			alert("ATENÇÃO: Já foi efetuado o requerimento de matrícula para esse aluno, consta historico do ano/semestre.");
						window.history.back();
					</script>
			 		<%
					response.End()
				end if
				rs.close
			
			
				SQL = "INSERT INTO SCA_HISTORICO_ESCOLAR (cod_aluno, cod_empresa, ano_letivo, semestre, escola, cidade, uf, "
				SQL = SQL & "curso, serie) VALUES ("
				SQL = SQL & "" & intCodigo & ","
				SQL = SQL & "" & strCod_empresa & ","
				SQL = SQL & "" & strAnoHistorico & ","
				SQL = SQL & "" & strSemestreHistorico & ","
				SQL = SQL & "'" & strEscola & "',"
				if strCidade = "" then
					SQL = SQL & "null,"
				else
					SQL = SQL & "'" & strCidade & "',"
				end if
				if strCodUfResidencia = "" then
					SQL = SQL & "null,"
				else
					SQL = SQL & "" & strCodUfResidencia & ","
				end if
				if strCurso = "" then
					SQL = SQL & "null,"
				else
					SQL = SQL & "'" & strCurso & "',"
				end if
				if strSerie = "" then
					SQL = SQL & "null)"
				else
					SQL = SQL & "'" & strSerie & "')"
				end if
				cnn.execute SQL
				GravarLog sql	
				
				sql="SELECT MAX(CODIGO) AS codhist"
				sql=sql & " FROM SCA_HISTORICO_ESCOLAR"
				SQL = SQL & " WHERE cod_aluno = " & intCodigo
				SQL = SQL & " AND cod_empresa = " & strCod_empresa
				SQL = SQL & " AND ano_letivo = " & strAnoHistorico
				SQL = SQL & " AND semestre = " & strSemestreHistorico
				
				
				
				rsAux.open sql, cnn, 3, 3
				codHistoricoEscolar = rsAux("codhist")
				rsAux.close
				
				'ATUALIZA HISTORICO 
				sql = "insert SCA_HISTORICO_ESCOLAR_DISCIPLINA "
				sql = sql & "SELECT "
				sql = sql & codHistoricoEscolar & ","'--cod_historico_escolar
				sql = sql & "ano_letivo,"
				sql = sql & "cod_periodo,"
				sql = sql & "semestre,"
				sql = sql & "cod_disciplina,"
				sql = sql & "cod_aluno_disciplina,"
				sql = sql & "nota01,"
				sql = sql & "falta01,"
				sql = sql & "nota02,"
				sql = sql & "falta02,"
				sql = sql & "nota03,"
				sql = sql & "falta03,"
				sql = sql & "nota04,"
				sql = sql & "falta04,"
				sql = sql & "nota05,"
				sql = sql & "falta05,"
				sql = sql & "nota06,"
				sql = sql & "falta06,"
				sql = sql & "nota07,"
				sql = sql & "falta07,"
				sql = sql & "nota08,"
				sql = sql & "falta08,"
				sql = sql & "nota09,"
				sql = sql & "falta09,"
				sql = sql & "nota10,"
				sql = sql & "falta10,"
				sql = sql & "nota11,"
				sql = sql & "falta11,"
				sql = sql & "nota12,"
				sql = sql & "falta12,"
				sql = sql & "nota13,"
				sql = sql & "falta13,"
				sql = sql & "nota14,"
				sql = sql & "falta14,"
				sql = sql & "nota15,"
				sql = sql & "falta15,"
				sql = sql & "media,"
				sql = sql & "null,"' --carga_horaria
				sql = sql & "situacao"
				sql = sql & " FROM SCA_NOTAS_FALTAS "
				sql = sql & " WHERE COD_EMPRESA = " & strCod_empresa
				sql = sql & " AND COD_ALUNO = " & intCodigo
				cnn.execute sql
				GravarLog sql		
										
				'LIMPA TABELA DE NOTAS
				sql = sql & " DELETE FROM SCA_NOTAS_FALTAS "
				sql = sql & " WHERE COD_EMPRESA = " & strCod_empresa
				sql = sql & " AND COD_ALUNO = " & intCodigo
				cnn.execute sql
				GravarLog sql					
			end if				
		end if
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		strParametro = "Rel_RequerimentoMatricula_rel.asp?dest=aluno_cad.asp?txtCodAluno=" & intCodigo & "&sem=" & strSemestreDestino & "&ano=" & strAnoLetivoDestino &"&txtCodAluno=" & intCodigo
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='<%=strParametro%>';
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