<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 27/11/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Notas e media
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_EnviarEmail.asp"-->
<%
	'on error resume next
	
	strPaginaRetorno	= Trim(Request.Form("txtPaginaRetorno"))
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	intCodCurso	 		= Trim(Request("cmbCurso"))
	intCodPeriodo 		= Trim(Request("cmbPeriodo"))
	strAtivos           = trim(request("cmbativos"))
	
	intSemestre 		= Trim(Request.Form("txtSemestre"))
	strAnoLetivo 		= Trim(Request.Form("txtAnoLetivo"))

	strGravarOnde = "NOTA"	
	if trim(intSemestre) = "3" then
	   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  then
		  'GRAVANDO NO ARQUIVO DE HISTORICO
		  strGravarOnde = "HISTORICO"
		  strMensagem = "Registro salvo com sucesso no Histórico..."
	   end if
	else
	   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  or trim(intSemestre) <> trim(session("strSemestre")) then
		  'GRAVANDO NO ARQUIVO DE NOTAS
		  strGravarOnde = "HISTORICO"
		  msnHistorico  = ""
		  strMensagem = "Registro salvo com sucesso..."
	   end if	   
	end if

	if strPaginaRetorno = "NOTA" then
		intCodDisciplina	= Trim(Request.Form("cmbDisciplinaTurma"))
	elseif strPaginaRetorno = "NOTAPROF" then
		intCodDisciplina	= Trim(Request.Form("cmbDisciplinaProfessorHorario"))
	end if
	
	intCodTipoNota 		= Trim(Request.Form("chkTipoNota"))

	strBimestre = ""
	sql = "SELECT bimestre, DESCRICAO "
	sql = sql & " FROM SCA_TIPO_AVALIACAO "
	sql = sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
	sql = sql & " AND 	COD_CURSO = " & intCodCurso
	sql = sql & " AND	codigo = " & intCodTipoNota 
	rs.open sql, cnn
	if not rs.eof then
		strBimestre = rs("bimestre")
		strNomeNota	= rs("DESCRICAO")
	end if
	rs.close
	
	'verifica recuperação
	strPosRecuperacao = ""
	sql = "SELECT posicao "
	sql = sql & " FROM SCA_TIPO_AVALIACAO "
	sql = sql & " WHERE bimestre = 6"'recuperação
	sql = sql & " AND COD_EMPRESA = " & Session("CodEmpresa") 
	sql = sql & " AND digitar = 'S'"
	sql = sql & " AND COD_CURSO = " & intCodCurso
	rs.open sql, cnn
	if not rs.eof then
		strPosRecuperacao 	= ZeroLeft(rs("posicao"),2)
	end if
	rs.close

	'verifica conselho classe
	strPosConselhoClasse = ""
	sql = "SELECT posicao "
	sql = sql & " FROM SCA_TIPO_AVALIACAO "
	sql = sql & " WHERE bimestre = 7"'conselho
	sql = sql & " AND COD_EMPRESA = " & Session("CodEmpresa") 
	sql = sql & " AND digitar = 'S'"
	sql = sql & " AND COD_CURSO = " & intCodCurso
	rs.open sql, cnn
	if not rs.eof then
		strPosConselhoClasse 	= ZeroLeft(rs("posicao"),2)
	end if
	rs.close
		
	strFormula 			= ""
	strPosicaoFormula 	= ""
	bolFormulaEspecialMaiorNota = false
	sql = "SELECT formula, posicao "
	sql = sql & " FROM SCA_TIPO_AVALIACAO "
	sql = sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
	sql = sql & " AND 	COD_CURSO = " & intCodCurso
	sql = sql & " AND	bimestre = " & strBimestre
	sql = sql & " AND	digitar = 'N'"

	rs.open sql, cnn
	if not rs.eof then
		strFormula 			= rs("formula")
		strPosicaoFormula 	= ZeroLeft(rs("posicao"),2)
		'verifica se a regra do * (buscar as posicoes das notas anteriores e gravar o valor maior na media de referido criterio)
		if trim(strFormula) = "*" then
			bolFormulaEspecialMaiorNota = true
			sql = "SELECT POSICAO "
			sql = sql & " FROM SCA_TIPO_AVALIACAO "
			sql = sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
			sql = sql & " AND 	COD_CURSO = " & intCodCurso
			sql = sql & " AND	bimestre = " & strBimestre
			sql = sql & " AND	digitar = 'S'"
			
			rsAux.open sql, cnn
			if not rsAux.eof then
				while not rsAux.eof
					if strPosicaoNotaEspecial = "" then
						strPosicaoNotaEspecial = ZeroLeft(rsAux("posicao"),2)
					else
						strPosicaoNotaEspecial = strPosicaoNotaEspecial & "," & ZeroLeft(rsAux("posicao"),2)
					end if
					rsAux.movenext
				wend
			end if
			rsAux.close
		end if
	else
		sql = "SELECT formula, posicao "
		sql = sql & " FROM SCA_TIPO_AVALIACAO "
		sql = sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
		sql = sql & " AND 	COD_CURSO = " & intCodCurso
		if strBimestre = 1 or strBimestre = 2 or strBimestre = 3 or strBimestre = 4 then
			sql = sql & " AND	bimestre = 5"
		elseif strBimestre = 6 then
			sql = sql & " AND	bimestre = 8"
		end if		
		sql = sql & " AND	digitar = 'N'"	
		rsAux.open sql, cnn
		if not rsAux.eof then
			strFormula 			= rsAux("formula")
			strPosicaoFormula 	= ZeroLeft(rsAux("posicao"),2)
		end if
		rsAux.close
	end if
	rs.close

	strMediaAprovacaoFinal = 0
	strMediaAprovacaoExame = 0
	intCondicaoEF_notaInicial 	= 0
	intCondicaoEF_notaFinal 	= 0

	sql = "SELECT media_aprovacao_final, media_aprovacao, condicaoEF_notaInicial, condicaoEF_notaFinal, tipoFormulaFinal, frequencia_minima_percentual "
	sql = sql & " FROM SCA_CRITERIO_AVALIACAO "
	sql = sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
	sql = sql & " AND 	COD_CURSO = " & intCodCurso
	rs.open sql, cnn
	if not rs.eof then
		strMediaAprovacaoFinal 	= rs("media_aprovacao")
		strMediaAprovacaoExame 	= rs("media_aprovacao_final")'DO EXAME ESTA GRAVANDO INVERTIDO NO CRITERIO
		intCondicaoEF_notaInicial 	= rs("condicaoEF_notaInicial")
		intCondicaoEF_notaFinal 	= rs("condicaoEF_notaFinal")
		strTipoFormulaFinal 		= rs("tipoFormulaFinal")
		intFrequenciaMinimaPerc		= rs("frequencia_minima_percentual")
	end if
	rs.close
	
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	if bolFormulaEspecialMaiorNota then
        '*
	else
	'FORMULA NORMAL
		'BUSCA FORMULA PARA CALCULAR A MEDIA
		strFormulaMediaProvisoria 			= ""
		strPosicaoFormulaMediaProvisoria 	= ""
		strFormulaMediaRecuperacao 			= ""
		strPosicaoFormulaMediaRecuperacao 	= ""
		strFormulaMediaFinal 				= ""
		strPosicaoFormulaMediaFinal 		= ""
	
		strPosicaoDigitacaoMediaProvisoria	= ""
		strPosicaoDigitacaoMediaRecuperacao	= ""
		strPosicaoDigitacaoMediaFinal		= ""
	
		'carrega formulas
		sql = "SELECT bimestre, formula, posicao "
		sql = sql & " FROM SCA_TIPO_AVALIACAO "
		sql = sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
		sql = sql & " AND 	COD_CURSO = " & intCodCurso
		sql = sql & " AND	digitar = 'N'"
		sql = sql & " order by posicao"
		
		rs.open sql, cnn,3,3
		if not rs.eof then
			while not rs.eof 
				if rs("bimestre") = 5 then 	 'media provisoria

					if strFormulaMediaProvisoria = "" then
						strFormulaMediaProvisoria 			= rs("formula")
						strPosicaoFormulaMediaProvisoria 	= ZeroLeft(rs("posicao"),2)
						strPosicaoDigitacaoMediaProvisoria 	= ""
					end if
					if strFormulaMediaProvisoria <> "" then
						strFormulaMediaProvisoria2 			= rs("formula")
						strPosicaoFormulaMediaProvisoria2 	= ZeroLeft(rs("posicao"),2)
						strPosicaoDigitacaoMediaProvisoria2 	= ""
					end if
					
					sql = "SELECT posicao "
					sql = sql & " FROM SCA_TIPO_AVALIACAO "
					sql = sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
					sql = sql & " AND 	COD_CURSO = " & intCodCurso
					sql = sql & " AND	bimestre = " & rs("bimestre")
					sql = sql & " AND	digitar = 'N'"
					sql = sql & " order by posicao"
					rsAux.open sql, cnn
					if not rsAux.eof then
						strPosicaoDigitacaoMediaProvisoria 	= ZeroLeft(rsAux("posicao"),2)
					end if
					rsAux.close
				elseif rs("bimestre") = 6 then 'media recuperacao
					strFormulaMediaRecuperacao 			= rs("formula")
					strPosicaoFormulaMediaRecuperacao 	= ZeroLeft(rs("posicao"),2)
					strPosicaoDigitacaoMediaRecuperacao = ""
	
					sql = "SELECT posicao "
					sql = sql & " FROM SCA_TIPO_AVALIACAO "
					sql = sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
					sql = sql & " AND 	COD_CURSO = " & intCodCurso
					sql = sql & " AND	bimestre = " & rs("bimestre")
					sql = sql & " AND	digitar = 'N'"
					sql = sql & " order by posicao"
					rsAux.open sql, cnn
					if not rsAux.eof then
						strPosicaoDigitacaoMediaRecuperacao 	= ZeroLeft(rsAux("posicao"),2)
					end if
					rsAux.close				
				elseif rs("bimestre") = 8 then 'media final
					strFormulaMediaFinal 				= rs("formula")
					strPosicaoFormulaMediaFinal 		= ZeroLeft(rs("posicao"),2)
					strPosicaoDigitacaoMediaFinal	 	= ""
	
					sql = "SELECT posicao "
					sql = sql & " FROM SCA_TIPO_AVALIACAO "
					sql = sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
					sql = sql & " AND 	COD_CURSO = " & intCodCurso
					if strPosicaoDigitacaoMediaRecuperacao = "" then
						sql = sql & " AND	bimestre in (6,7," & rs("bimestre") & ")" 'busca no exame/conselho/media
					else
						sql = sql & " AND	bimestre in (7," & rs("bimestre") & ")" 'busca no conselho/media
					end if
					sql = sql & " AND	digitar = 'N'"
					sql = sql & " order by posicao"
					rsAux.open sql, cnn
					if not rsAux.eof then
						strPosicaoDigitacaoMediaFinal 	= ZeroLeft(rsAux("posicao"),2)
					end if
					rsAux.close	
				end if
				rs.movenext
			wend
		end if
		rs.close	

		if strPaginaRetorno = "NOTA" then
			intCodTurma 		= Trim(Request.Form("cmbTurma"))
		elseif strPaginaRetorno = "NOTAPROF" then
			intCodTurma 			= Trim(Request("cmbTurmaProfessor"))
		end if
	
		if  Trim(Request("cmbDisciplinaTurma")) <> "" then
			intCodDisciplina			= Trim(Request("cmbDisciplinaTurma"))
		else
			intCodDisciplina			 = Trim(Request("cmbDisciplinaDoProfessor"))
		end if

		intCodTurno 		= Trim(Request.Form("cmbTurno"))
		strAlunos 			= Trim(Request.Form("chkAluno"))
		strPosicao			= Trim(Request.Form("txtPosicao"))
        		
		IF TRIM(strGravarOnde) = "NOTA" THEN
		'busca os dados dos lancamentos de notas
			intQtdeLancamento = request.form("qtdeAluno")
			for i=1 to intQtdeLancamento
	
				strCodAluno			= request.form("txtCodAluno_"&i)
				strFalta 			= request.form("txtFalta_"&i)
				strCodNota 			= request.form("txtCodAlunoNota_"&i)
				strAlunoDisciplina 	= request.form("txtAlunoDisciplina_"&i)
				strSituacaoFinal	= replace(request.form("txtSituacaoFinal_"&i),",",".")

				' Início da Regra de reprovação por Falta
				SQL = "SELECT "
				SQL = SQL &   "Isnull(NF.falta01,'0') + Isnull(NF.falta02,'0') + Isnull(NF.falta03,'0') + Isnull(NF.falta04,'0') + Isnull(NF.falta05,'0') + Isnull(NF.falta06,'0') + Isnull(NF.falta07,'0') + Isnull(NF.falta08,'0') + Isnull(NF.falta09,'0') + Isnull(NF.falta10,'0') + Isnull(NF.falta11,'0') + Isnull(NF.falta12,'0') + Isnull(NF.falta13,'0') + Isnull(NF.falta14,'0') + Isnull(NF.falta15,'0') as totalfalta, "
				SQL = SQL & "AD.CODIGO AS COD_ALUNO_DISCIPLINA, "
				SQL = SQL & "AD.COD_ALUNO AS CODIGO, "
				SQL = SQL & "AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
				SQL = SQL & "AD.COD_DISCIPLINA, "
				SQL = SQL & "GCD.Ch_Anual "
				SQL = SQL & "FROM SCA_ALUNO_DISCIPLINA AD " 
				SQL = SQL & "INNER JOIN SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO " 
				SQL = SQL & "INNER JOIN SCA_NOTAS_FALTAS NF ON NF.cod_aluno_disciplina = AD.CODIGO " 
				SQL = SQL & "INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurriculardisciplina = AD.COD_GRADECURRICULARDISCIPLINA "
				SQL = SQL & "WHERE AD.COD_EMPRESA = " & Session("CodEmpresa") 
				SQL = SQL & "AND AD.COD_TURMA_REMANEJAMENTO = " & intCodTurma 
				SQL = SQL & "AND A.CODIGO = " & strCodAluno 
				SQL = SQL & "AND AD.COD_DISCIPLINA = " & intCodDisciplina
				rs.open sql, cnn
				if not rs.eof then
				   if rs("CH_ANUAL") = "" or rs("CH_ANUAL") = "0" then
					  strCHDisciplina = 0
				   else  
					  strCHDisciplina = rs("CH_ANUAL")
					  IF rs("TOTALFALTA") = "" or rs("TOTALFALTA") = "0" then
						 strTotalFaltas  = 0
					  else	 
						 strTotalFaltas  = rs("TOTALFALTA")
					  end if	 
				   end if  
				   if strCHDisciplina = "0" or strCHDisciplina = "" then
					  strPercFaltas = 0 
				   else	
					  strPercFaltas = (strTotalFaltas * 100)/strCHDisciplina
				   end if	   
				else 
				   strPercFaltas = 0
				end if  
									
				rs.close
				' Fim da regra de reprovação por faltas	
				
				'alterar nota
				SQL = "UPDATE SCA_NOTAS_FALTAS SET "

				if strPercFaltas > intFrequenciaMinimaPerc then	
				   strSituacaoFinal = "RN"
				end if   

				if trim(strSituacaoFinal) = "" then
					SQL = SQL & "situacao=null, "
				else
					SQL = SQL & "situacao='" & strSituacaoFinal & "', "
				end if
				if strFalta = "" then
					SQL = SQL & "falta"&strPosicao&"=null "
				else
					SQL = SQL & "falta"&strPosicao&"=" & strFalta & ""
				end if
				SQL = SQL & " where codigo = " & strCodNota

				cnn.execute SQL
				GravarLog sql
			next
		ELSEIF TRIM(strGravarOnde) = "HISTORICO" THEN
		'busca os dados dos lancamentos de historico
			intQtdeLancamento		= request.form("qtdeAluno")
			for i=1 to intQtdeLancamento
				strCodHistoricoDisciplina		= request.form("txtCodHistoricoDisciplina_"&i)
				strCodAluno			= request.form("txtCodAluno_"&i)
				strFalta 			= request.form("txtFalta_"&i)
				strAlunoDisciplina 	= request.form("txtAlunoDisciplina_"&i)
				strCodNota 			= request.form("txtCodAlunoNota_"&i)
				strSituacaoFinal	= replace(request.form("txtSituacaoFinal_"&i),",",".")
				
				'altera hist disc
				SQL = "update SCA_HISTORICO_ESCOLAR_DISCIPLINA SET "
				if trim(strSituacaoFinal) = "" then
					SQL = SQL & "situacao=null, "
				else
					SQL = SQL & "situacao='" & strSituacaoFinal & "', "
				end if
				if strFalta = "" then
					SQL = SQL & "falta"&strPosicao&"=null "
				else
					SQL = SQL & "falta"&strPosicao&"=" & strFalta & ""
				end if
				SQL = SQL & " where codigo = " & strCodNota

				cnn.execute SQL
				GravarLog sql
			next
		END IF
	end if
	
		strParametro = "AjusteFaltas_cad.asp?cmbPeriodo="&intCodPeriodo
		strParametro = strParametro & "&txtAnoLetivo="&strAnoLetivo
		strParametro = strParametro & "&cmbSemestre="&intSemestre
		strParametro = strParametro & "&cmbDisciplinaTurma="&intCodDisciplina
		strParametro = strParametro & "&chkTipoNota="&intCodTipoNota
		strParametro = strParametro & "&cmbTurma="&intCodTurma
		strParametro = strParametro & "&chkAluno="&strAlunos
		strParametro = strParametro & "&cmbTurno="&intCodTurno
		strParametro = strParametro & "&cmbTipoLancamento="&intCodTipoLancamento
		strParametro = strParametro & "&cmbCurso="&intCodCurso
		strParametro = strParametro & "&cmbativos="&strAtivos			

	if err.number = 0 then

			' INICIO - Dados Para Envio de E-mail
			
'				strNomedisciplina = ""
'				sql = "SELECT DESC_DISCIPLINA FROM SCA_DISCIPLINA"
'				sql = sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
'				sql = sql & " AND	COD_DISCIPLINA = " & intCodDisciplina
'				rs.open sql, cnn
'				if not rs.eof then
'					strNomedisciplina = rs("DESC_DISCIPLINA")
'				end if
'				rs.close
'				
'				strEmail = ""	
'				sql=" SELECT EMAIL FROM SEG_EMPRESA "
'				sql=sql & " WHERE CODIGO = " & Session("CodEmpresa") 
'				rs.open sql, cnn
'				if not rs.eof then
'				   strEmail				= rs("email")	
'				end if
'				rs.close	
'				
'				nomeresponsavel = ""	
'				sql=" SELECT NOME, EMAIL FROM SRH_COLABORADOR "
'				sql=sql & " WHERE CODIGO_SEG_USUARIOS_SISTEMA =  '" & Session("UsuarioWeb") & "'"
'				rs.open sql, cnn
'				if not rs.eof then
'				   nomeresponsavel		= rs("nome")	
'				end if
'				rs.close	
'	
'				nometurmalancamento = ""	
'				sql=" SELECT NOMETURMA FROM SCA_TURMA "
'				sql=sql & " WHERE COD_TURMA =  " & intCodTurma
'				rs.open sql, cnn
'				if not rs.eof then
'				   nometurmalancamento		= rs("nometurma")	
'				end if
'				rs.close	
'	
'				strEmailOrigem	 = "webmaster@sisge.com.br"
'				strAssuntoEmail	 = "Ajuste de  Faltas"  
'				strMensagemEmail = "<br> Lançamento realizado por: " & nomeresponsavel & "<br>"
'				strMensagemEmail = strMensagemEmail & "Turma: " & nometurmalancamento & "<br>"
'				strMensagemEmail = strMensagemEmail & "Disciplina: " & strNomedisciplina & "<br>"
'				strMensagemEmail = strMensagemEmail & "Avaliação: " & strNomeNota & "<br>"
'				strMensagemEmail = strMensagemEmail & "Atualização: " & strGravarOnde & "<br>"
'	 
'				if strEmail <> "" then 
'				   'Envia um email com dados do lançamento de notas
'				   EnviarEmail strEmailOrigem, strEmail, strAssuntoEmail, strMensagemEmail
'				end if
'				
			' FIM - Dados Para Envio de E-mail
	
		'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			aguarde.style.display="none";
		</script>
		<script>
			alert("Registro de Faltas alterado com sucesso.");
			window.location='<%=strParametro%>';
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			aguarde.style.display="none";
		</script>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>