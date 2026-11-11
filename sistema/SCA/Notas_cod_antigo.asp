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
	'FORMULA ESPECIAL
		IF TRIM(strGravarOnde) = "NOTA" THEN
		'TABELA DE NOTAS
			sql = "SELECT bimestre, formula, posicao "
			sql = sql & " FROM SCA_TIPO_AVALIACAO "
			sql = sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
			sql = sql & " AND 	COD_CURSO = " & intCodCurso
			sql = sql & " AND	digitar = 'N'"
			sql = sql & " AND	bimestre = 8"
			sql = sql & " order by posicao"
			rs.open sql, cnn,3,3
			if not rs.eof then
				strFormulaMediaFinal 				= rs("formula")
			end if
			rs.close	

			vetPosicaoNotaEspecial = split(strPosicaoNotaEspecial,",")
			
			if strPaginaRetorno = "NOTA" then
				intCodTurma 		= Trim(Request.Form("cmbTurma"))
			elseif strPaginaRetorno = "NOTAPROF" then
				intCodTurma 			= Trim(Request("cmbTurmaProfessor"))
			end if
		
			intCodTurno 		= Trim(Request.Form("cmbTurno"))
			strAlunos 			= Trim(Request.Form("chkAluno"))
			strPosicao			= Trim(Request.Form("txtPosicao"))
			intQtdeLancamento 	= Trim(Request.form("qtdeAluno"))
			
			for i=1 to intQtdeLancamento
				C1  = -1
				C2  = -1
				C3  = -1
				C4  = -1
				C5  = -1
				C6  = -1
				C7  = -1
				C8  = -1
				C9  = -1
				C10  = -1
				C11  = -1
				C12  = -1
				C13  = -1
				C14  = -1
				C15  = -1
	
				strCodAluno			= request.form("txtCodAluno_"&i)
				strNota				= replace(request.form("txtNota_"&i),",",".")
				strNotaCalc			= request.form("txtNota_"&i)
				strFalta 			= request.form("txtFalta_"&i)
				strAlunoDisciplina 	= request.form("txtAlunoDisciplina_"&i)
				strCodNota 			= request.form("txtCodAlunoNota_"&i)
				strMediaFinal		= replace(request.form("txtMediaFinal_"&i),",",".")
				strSituacaoFinal	= replace(request.form("txtSituacaoFinal_"&i),",",".")
	
				if strCodNota <> "" then
					sql = "select "
					for y=0 to uBound(vetPosicaoNotaEspecial)
						if y=uBound(vetPosicaoNotaEspecial) then
							sql = sql & "nota" & vetPosicaoNotaEspecial(y)
						else
							sql = sql & "nota" & vetPosicaoNotaEspecial(y) & ","
						end if
					next
					N1=""
					N2=""
					sql = sql & " from SCA_NOTAS_FALTAS"
					sql = sql & " where codigo = " & strCodNota
					rs.open sql, cnn
					if not rs.eof then
						if not isnull(rs("nota" & vetPosicaoNotaEspecial(0))) then N1  = rs("nota" & vetPosicaoNotaEspecial(0))
						if not isnull(rs("nota" & vetPosicaoNotaEspecial(1))) then N2  = rs("nota" & vetPosicaoNotaEspecial(1))
					end if
					rs.close	

					strMediaEspecial = strNotaCalc
					strNotaEsp 		 = strNotaCalc
					if strNotaEsp = "" then strNotaEsp = 0
					
					if isnull(N1) then N1 = ""
					if isnull(N2) then N2 = ""

					if strPosicao = "01" and strNotaCalc = "" then
						N1 = ""
					end if
					if strPosicao = "02" and strNotaCalc = "" then
						N2 = ""
					end if
					if strPosicao = "04" and strNotaCalc = "" then
						N1 = ""
					end if
					if strPosicao = "05" and strNotaCalc = "" then
						N2 = ""
					end if
					if strPosicao = "07" and strNotaCalc = "" then
						N1 = ""
					end if
					if strPosicao = "08" and strNotaCalc = "" then
						N2 = ""
					end if
					if strPosicao = "10" and strNotaCalc = "" then
						N1 = ""
					end if
					if strPosicao = "11" and strNotaCalc = "" then
						N2 = ""
					end if
					if strPosicao = "13" and strNotaCalc = "" then
						N1 = ""
					end if
					if strPosicao = "14" and strNotaCalc = "" then
						N2 = ""
					end if
					
					if trim(N1)<>"" and trim(N2)<>"" then
						if cCur(N1) > cCur(N2) then
							if cCur(N1) > cCur(strNotaEsp) then
								strMediaEspecial = N1				
							end if
						else
							if cCur(N2) > cCur(strNotaEsp) then
								strMediaEspecial = N2
							end if
						end if
					elseif trim(N1)<>"" then
						if cCur(N1) > cCur(strNotaEsp) then
							strMediaEspecial = N1				
						end if
					elseif trim(N2)<>"" then
						if cCur(N2) > cCur(strNotaEsp) then
							strMediaEspecial = N2				
						end if
					end if
					
					'media
					sql = "select nota01, nota02, nota03, nota04, nota05, nota06, nota07, nota08, nota09, nota10, nota11, nota12, nota13, nota14, nota15 "
					sql = sql & " from SCA_NOTAS_FALTAS"
					sql = sql & " where codigo = " & strCodNota
					rs.open sql, cnn
					if not rs.eof then
						if strPosicao = "01" and strNota<>"" then 
							C1  = strNotaCalc
						else
							if strPosicao = "01" and strNota = "" then
								C1  = 0
							else
								if not isnull(rs("nota01")) then C1  = rs("nota01")
							end if
						end if
						
						if strPosicao = "02" and strNota<>"" then 
							C2  = strNotaCalc
						else
							if strPosicao = "02" and strNota = "" then
								C2  = 0
							else
								if not isnull(rs("nota02")) then C2  = rs("nota02")
							end if
						end if
						if strPosicao = "03" and strNota<>"" then 
							C3  = strNotaCalc
						else
							if strPosicao = "03" and strNota = "" then
								C3  = 0
							else
								
								if not isnull(rs("nota03")) then C3  = rs("nota03")
							end if
						end if
						if strPosicao = "04" and strNota<>"" then 
							C4  = strNotaCalc
						else
							if strPosicao = "04" and strNota = "" then
								C4  = 0
							else
								if not isnull(rs("nota04")) then C4  = rs("nota04")
							end if
						end if
						if strPosicao = "05" and strNota<>"" then 
							C5  = strNotaCalc
						else
							if strPosicao = "05" and strNota = "" then
								C5  = 0
							else
								if not isnull(rs("nota05")) then C5  = rs("nota05")
							end if
						end if
						if strPosicao = "06" and strNota<>"" then 
							C6  = strNotaCalc
						else
							if strPosicao = "06" and strNota = "" then
								C6  = 0
							else
								if not isnull(rs("nota06")) then C6  = rs("nota06")
							end if
						end if
						if strPosicao = "07" and strNota<>"" then 
							C7  = strNotaCalc
						else
							if strPosicao = "07" and strNota = "" then
								C7  = 0
							else
								if not isnull(rs("nota07")) then C7  = rs("nota07")
							end if
						end if
						if strPosicao = "08" and strNota<>"" then 
							C8  = strNotaCalc
						else
							if strPosicao = "08" and strNota = "" then
								C8  = 0
							else
								if not isnull(rs("nota08")) then C8  = rs("nota08")
							end if
						end if
						if strPosicao = "09" and strNota<>"" then 
							C9  = strNotaCalc
						else
							if strPosicao = "09" and strNota = "" then
								C9  = 0
							else
								if not isnull(rs("nota09")) then C9  = rs("nota09")
							end if
						end if
						if strPosicao = "10" and strNota<>"" then 
							C10  = strNotaCalc
						else
							if strPosicao = "10" and strNota = "" then
								C10  = 0
							else
								if not isnull(rs("nota10")) then C10  = rs("nota10")
							end if
						end if
						if strPosicao = "11" and strNota<>"" then 
							C11  = strNotaCalc
						else
							if strPosicao = "11" and strNota = "" then
								C11  = 0
							else
								if not isnull(rs("nota11")) then C11  = rs("nota11")
							end if
						end if
						if strPosicao = "12" and strNota<>"" then 
							C12  = strNotaCalc
						else
							if strPosicao = "12" and strNota = "" then
								C12  = 0
							else
								if not isnull(rs("nota12")) then C12  = rs("nota12")
							end if
						end if
						if strPosicao = "13" and strNota<>"" then 
							C13  = strNotaCalc
						else
							if strPosicao = "13" and strNota = "" then
								C13  = 0
							else
								if not isnull(rs("nota13")) then C13  = rs("nota13")
							end if
						end if
						if strPosicao = "14" and strNota<>"" then 
							C14  = strNotaCalc
						else
							if strPosicao = "14" and strNota = "" then
								C14  = 0
							else
								if not isnull(rs("nota14")) then C14  = rs("nota14")
							end if
						end if
						if strPosicao = "15" and strNota<>"" then 
							C15  = strNotaCalc
						else
							if strPosicao = "15" and strNota = "" then
								C15  = 0
							else
								if not isnull(rs("nota15")) then C15  = rs("nota15")
							end if
						end if
					end if
					rs.close	
		
					if C1   = -1 then C1  = 0
					if C2   = -1 then C2  = 0
					if C3   = -1 then C3  = 0
					if C4   = -1 then C4  = 0
					if C5   = -1 then C5  = 0
					if C6   = -1 then C6  = 0
					if C7   = -1 then C7  = 0
					if C8   = -1 then C8  = 0
					if C9   = -1 then C9  = 0
					if C10  = -1 then C10 = 0
					if C11  = -1 then C11 = 0
					if C12  = -1 then C12 = 0
					if C13  = -1 then C13 = 0
					if C14  = -1 then C14 = 0
					if C15  = -1 then C15 = 0


					if ISNULL(strNotaCalc) then strNotaCalc = ""
					
					if strPosicaoFormula = "01" AND strNotaCalc<>"" then C1 = strMediaEspecial
					if strPosicaoFormula = "02" AND strNotaCalc<>"" then C2 = strMediaEspecial
					if strPosicaoFormula = "03" AND strNotaCalc<>"" then C3 = strMediaEspecial
					if strPosicaoFormula = "04" AND strNotaCalc<>"" then C4 = strMediaEspecial
					if strPosicaoFormula = "05" AND strNotaCalc<>"" then C5 = strMediaEspecial
					if strPosicaoFormula = "06" AND strNotaCalc<>"" then C6 = strMediaEspecial
					if strPosicaoFormula = "07" AND strNotaCalc<>"" then C7 = strMediaEspecial
					if strPosicaoFormula = "08" AND strNotaCalc<>"" then C8 = strMediaEspecial
					if strPosicaoFormula = "09" AND strNotaCalc<>"" then C9 = strMediaEspecial
					if strPosicaoFormula = "10" AND strNotaCalc<>"" then C10 = strMediaEspecial
					if strPosicaoFormula = "11" AND strNotaCalc<>"" then C11 = strMediaEspecial
					if strPosicaoFormula = "12" AND strNotaCalc<>"" then C12 = strMediaEspecial
					if strPosicaoFormula = "13" AND strNotaCalc<>"" then C13 = strMediaEspecial
					if strPosicaoFormula = "14" AND strNotaCalc<>"" then C14 = strMediaEspecial
					if strPosicaoFormula = "15" AND strNotaCalc<>"" then C15 = strMediaEspecial

					if (strPosicao = "01" or strPosicao = "01") and N1 = "" and N2 = "" then
						C3   = ""
					end if
					if (strPosicao = "04" or strPosicao = "05") and N1 = "" and N2 = "" then
						C6   = ""
					end if
					if (strPosicao = "07" or strPosicao = "08") and N1 = "" and N2 = "" then
						C9   = ""
					end if
					if (strPosicao = "10" or strPosicao = "11") and N1 = "" and N2 = "" then
						C12   = ""
					end if

					if C3   = "" then C3  = 0
					if C6   = "" then C6  = 0
					if C9   = "" then C9  = 0
					if C12  = "" then C12 = 0
		
					if isnull(strCodNota) or trim(strCodNota) = "" then
						'incluir
						if trim(strNota) <> "" or trim(strFalta) <> "" then
							
							strSituacaoFinal = ""
							if strFormulaMediaFinal <> "" then
								if cCur(Eval(strFormulaMediaFinal)) >= cCur(strMediaAprovacaoFinal) then
									strSituacaoFinal = "AP"
								else
									strSituacaoFinal = "RN"
								end if
							end if
							
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
	                      
						    if strPercFaltas > intFrequenciaMinimaPerc then	
							   strSituacaoFinal = "RN"
							end if   							
  						    rs.close
							' Fim da regra de reprovação por faltas	
									
							SQL = "INSERT INTO SCA_NOTAS_FALTAS (cod_empresa, cod_aluno, cod_aluno_disciplina, cod_periodo, "
							SQL = SQL & "ano_letivo, semestre, cod_disciplina, "
							SQL = SQL & "nota"&strPosicao&", falta"&strPosicao&","
							if strMediaEspecial<>"" then
								SQL = SQL & "nota"&strPosicaoFormula&", falta"&strPosicaoFormula&","
							end if
							SQL = SQL & "media,situacao) VALUES ("
							SQL = SQL & "" & intCodEmp & ","
							SQL = SQL & "" & strCodAluno & ","
							SQL = SQL & "" & strAlunoDisciplina & ","
							SQL = SQL & "" & intCodPeriodo & ","
							SQL = SQL & "" & strAnoLetivo & ","
							SQL = SQL & "" & intSemestre & ","
							SQL = SQL & "" & intCodDisciplina & ","
							if strNota = "" then
								SQL = SQL & "null,"
							else
								SQL = SQL & "" & strNota & ","
							end if
							if strFalta = "" then
								SQL = SQL & "null,"
							else
								SQL = SQL & "" & strFalta & ","
							end if
							
							if trim(strMediaEspecial)<>"" then
								SQL = SQL & "" & replace(strMediaEspecial,",",".") & ","
								SQL = SQL & "null,"
							end if
												
							if strFormulaMediaFinal = "" then
								SQL = SQL & "null,"
							else
								if strNota <> "" then
								   SQL = SQL & "" & replace(Eval(strFormulaMediaFinal),",",".") & ","
								else   
								   SQL = SQL & "null,"
								end if   
							end if
							
							if strSituacaoFinal = "" then
								SQL = SQL & "null)"
							else
								SQL = SQL & "'" & strSituacaoFinal & "')"
							end if				
							cnn.execute SQL
							GravarLog sql
						end if
					else
						strSituacaoFinal = ""
						
						if strFormulaMediaFinal <> "" then
							if cCur(Eval(strFormulaMediaFinal)) >= cCur(strMediaAprovacaoFinal) then
								strSituacaoFinal = "AP"
							else
								strSituacaoFinal = "RN"
							end if
						end if
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
					  
						if strPercFaltas > intFrequenciaMinimaPerc then	
						   strSituacaoFinal = "RN"
						end if   							
						rs.close
						' Fim da regra de reprovação por faltas	
						
						'alterar nota
						SQL = "UPDATE SCA_NOTAS_FALTAS SET "
						if strNota = "" then
							SQL = SQL & "nota"&strPosicao&"=null,"
						else
							SQL = SQL & "nota"&strPosicao&"=" & strNota & ","
						end if
						if trim(strMediaEspecial)<>"" then
							SQL = SQL & "nota"&strPosicaoFormula&"=" & replace(strMediaEspecial,",",".") & ","
						end if				
						if strFormulaMediaFinal<>"" then
						   'if strNota <> "" then
						      SQL = SQL & "media=" & replace(Eval(strFormulaMediaFinal),",",".") & ","
						   'end if 
						end if
						if strSituacaoFinal = "" then
							SQL = SQL & "situacao=null,"
						else
							SQL = SQL & "situacao='" & strSituacaoFinal & "',"
						end if
						if strFalta = "" then
							SQL = SQL & "falta"&strPosicao&"=null"
						else
							SQL = SQL & "falta"&strPosicao&"=" & strFalta & ""
						end if
						SQL = SQL & " where codigo = " & strCodNota

						cnn.execute SQL
						GravarLog sql
					end if				
					
				end if	
			next
			strFormulaMedia = "Média = Maior Nota"
		ELSE
		'TABELA DE HISTORICO
			sql = "SELECT bimestre, formula, posicao "
			sql = sql & " FROM SCA_TIPO_AVALIACAO "
			sql = sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
			sql = sql & " AND 	COD_CURSO = " & intCodCurso
			sql = sql & " AND	digitar = 'N'"
			sql = sql & " AND	bimestre = 8"
			sql = sql & " order by posicao"
			rs.open sql, cnn,3,3
			if not rs.eof then
				strFormulaMediaFinal 				= rs("formula")
			end if
			rs.close	

			vetPosicaoNotaEspecial = split(strPosicaoNotaEspecial,",")
			
			if strPaginaRetorno = "NOTA" then
				intCodTurma 		= Trim(Request.Form("cmbTurma"))
			elseif strPaginaRetorno = "NOTAPROF" then
				intCodTurma 			= Trim(Request("cmbTurmaProfessor"))
			end if
		
			intCodTurno 		= Trim(Request.Form("cmbTurno"))
			strAlunos 			= Trim(Request.Form("chkAluno"))
			strPosicao			= Trim(Request.Form("txtPosicao"))
			intQtdeLancamento 	= Trim(Request.form("qtdeAluno"))	
			for i=1 to intQtdeLancamento
				C1  = -1
				C2  = -1
				C3  = -1
				C4  = -1
				C5  = -1
				C6  = -1
				C7  = -1
				C8  = -1
				C9  = -1
				C10  = -1
				C11  = -1
				C12  = -1
				C13  = -1
				C14  = -1
				C15  = -1
	
				strCodHistoricoDisciplina		= request.form("txtCodHistoricoDisciplina_"&i)
				strCodAluno			= request.form("txtCodAluno_"&i)
				strNota				= replace(request.form("txtNota_"&i),",",".")
				strNotaCalc			= request.form("txtNota_"&i)
				strFalta 			= request.form("txtFalta_"&i)
				strAlunoDisciplina 	= request.form("txtAlunoDisciplina_"&i)
				strCodNota 			= request.form("txtCodAlunoNota_"&i)
				strMediaFinal		= replace(request.form("txtMediaFinal_"&i),",",".")
				strSituacaoFinal	= replace(request.form("txtSituacaoFinal_"&i),",",".")
				
				if strCodNota <> "" then
					sql = "select "
					for y=0 to uBound(vetPosicaoNotaEspecial)
						if y=uBound(vetPosicaoNotaEspecial) then
							sql = sql & "nota" & vetPosicaoNotaEspecial(y)
						else
							sql = sql & "nota" & vetPosicaoNotaEspecial(y) & ","
						end if
					next
					N1=""
					N2=""
					sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA"
					sql = sql & " where codigo = " & strCodHistoricoDisciplina
					rs.open sql, cnn
					if not rs.eof then
						if not isnull(rs("nota" & vetPosicaoNotaEspecial(0))) then N1  = rs("nota" & vetPosicaoNotaEspecial(0))
						if not isnull(rs("nota" & vetPosicaoNotaEspecial(1))) then N2  = rs("nota" & vetPosicaoNotaEspecial(1))
					end if
					rs.close	
					strMediaEspecial = strNotaCalc
					strNotaEsp 		 = strNotaCalc
					if strNotaEsp = "" then strNotaEsp = 0
	
					if isnull(N1) then N1 = ""
					if isnull(N2) then N2 = ""
					
					if trim(N1)<>"" and trim(N2)<>"" then
						if cCur(N1) > cCur(N2) then
							if cCur(N1) > cCur(strNotaEsp) then
								strMediaEspecial = N1				
							end if
						else
							if cCur(N2) > cCur(strNotaEsp) then
								strMediaEspecial = N2
							end if
						end if
					elseif trim(N1)<>"" then
						if cCur(N1) > cCur(strNotaEsp) then
							strMediaEspecial = N1				
						end if
					elseif trim(N2)<>"" then
						if cCur(N2) > cCur(strNotaEsp) then
							strMediaEspecial = N2				
						end if
					end if
					
					'media
					sql = "select nota01, nota02, nota03, nota04, nota05, nota06, nota07, nota08, nota09, nota10, nota11, nota12, nota13, nota14, nota15 "
					sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA"
					sql = sql & " where codigo = " & strCodHistoricoDisciplina
					rs.open sql, cnn
					if not rs.eof then
						if strPosicao = "01" and strNota<>"" then 
							C1  = strNotaCalc
						else
							if strPosicao = "01" and strNota = "" then
								C1  = 0
							else
								if not isnull(rs("nota01")) then C1  = rs("nota01")
							end if
						end if
						if strPosicao = "02" and strNota<>"" then 
							C2  = strNotaCalc
						else
							if strPosicao = "02" and strNota = "" then
								C2  = 0
							else
								if not isnull(rs("nota02")) then C2  = rs("nota02")
							end if
						end if
						if strPosicao = "03" and strNota<>"" then 
							C3  = strNotaCalc
						else
							if strPosicao = "03" and strNota = "" then
								C3  = 0
							else
								if not isnull(rs("nota03")) then C3  = rs("nota03")
							end if
						end if
						if strPosicao = "04" and strNota<>"" then 
							C4  = strNotaCalc
						else
							if strPosicao = "04" and strNota = "" then
								C4  = 0
							else
								if not isnull(rs("nota04")) then C4  = rs("nota04")
							end if
						end if
						if strPosicao = "05" and strNota<>"" then 
							C5  = strNotaCalc
						else
							if strPosicao = "05" and strNota = "" then
								C5  = 0
							else
								if not isnull(rs("nota05")) then C5  = rs("nota05")
							end if
						end if
						if strPosicao = "06" and strNota<>"" then 
							C6  = strNotaCalc
						else
							if strPosicao = "06" and strNota = "" then
								C6  = 0
							else
								if not isnull(rs("nota06")) then C6  = rs("nota06")
							end if
						end if
						if strPosicao = "07" and strNota<>"" then 
							C7  = strNotaCalc
						else
							if strPosicao = "07" and strNota = "" then
								C7  = 0
							else
								if not isnull(rs("nota07")) then C7  = rs("nota07")
							end if
						end if
						if strPosicao = "08" and strNota<>"" then 
							C8  = strNotaCalc
						else
							if strPosicao = "08" and strNota = "" then
								C8  = 0
							else
								if not isnull(rs("nota08")) then C8  = rs("nota08")
							end if
						end if
						if strPosicao = "09" and strNota<>"" then 
							C9  = strNotaCalc
						else
							if strPosicao = "09" and strNota = "" then
								C9  = 0
							else
								if not isnull(rs("nota09")) then C9  = rs("nota09")
							end if
						end if
						if strPosicao = "10" and strNota<>"" then 
							C10  = strNotaCalc
						else
							if strPosicao = "10" and strNota = "" then
								C10  = 0
							else
								if not isnull(rs("nota10")) then C10  = rs("nota10")
							end if
						end if
						if strPosicao = "11" and strNota<>"" then 
							C11  = strNotaCalc
						else
							if strPosicao = "11" and strNota = "" then
								C11  = 0
							else
								if not isnull(rs("nota11")) then C11  = rs("nota11")
							end if
						end if
						if strPosicao = "12" and strNota<>"" then 
							C12  = strNotaCalc
						else
							if strPosicao = "12" and strNota = "" then
								C12  = 0
							else
								if not isnull(rs("nota12")) then C12  = rs("nota12")
							end if
						end if
						if strPosicao = "13" and strNota<>"" then 
							C13  = strNotaCalc
						else
							if strPosicao = "13" and strNota = "" then
								C13  = 0
							else
								if not isnull(rs("nota13")) then C13  = rs("nota13")
							end if
						end if
						if strPosicao = "14" and strNota<>"" then 
							C14  = strNotaCalc
						else
							if strPosicao = "14" and strNota = "" then
								C14  = 0
							else
								if not isnull(rs("nota14")) then C14  = rs("nota14")
							end if
						end if
						if strPosicao = "15" and strNota<>"" then 
							C15  = strNotaCalc
						else
							if strPosicao = "15" and strNota = "" then
								C15  = 0
							else
								if not isnull(rs("nota15")) then C15  = rs("nota15")
							end if
						end if
					end if
					rs.close	
		
					if C1   = -1 then C1  = 0
					if C2   = -1 then C2  = 0
					if C3   = -1 then C3  = 0
					if C4   = -1 then C4  = 0
					if C5   = -1 then C5  = 0
					if C6   = -1 then C6  = 0
					if C7   = -1 then C7  = 0
					if C8   = -1 then C8  = 0
					if C9   = -1 then C9  = 0
					if C10  = -1 then C10 = 0
					if C11  = -1 then C11 = 0
					if C12  = -1 then C12 = 0
					if C13  = -1 then C13 = 0
					if C14  = -1 then C14 = 0
					if C15  = -1 then C15 = 0
					
					if strPosicaoFormula = "01" then C1 = strMediaEspecial
					if strPosicaoFormula = "02" then C2 = strMediaEspecial
					if strPosicaoFormula = "03" then C3 = strMediaEspecial
					if strPosicaoFormula = "04" then C4 = strMediaEspecial
					if strPosicaoFormula = "05" then C5 = strMediaEspecial
					if strPosicaoFormula = "06" then C6 = strMediaEspecial
					if strPosicaoFormula = "07" then C7 = strMediaEspecial
					if strPosicaoFormula = "08" then C8 = strMediaEspecial
					if strPosicaoFormula = "09" then C9 = strMediaEspecial
					if strPosicaoFormula = "10" then C10 = strMediaEspecial
					if strPosicaoFormula = "11" then C11 = strMediaEspecial
					if strPosicaoFormula = "12" then C12 = strMediaEspecial
					if strPosicaoFormula = "13" then C13 = strMediaEspecial
					if strPosicaoFormula = "14" then C14 = strMediaEspecial
					if strPosicaoFormula = "15" then C15 = strMediaEspecial
					
					if C3   = "" then C3  = 0
					if C6   = "" then C6  = 0
					if C9   = "" then C9  = 0
					if C12  = "" then C12 = 0

					strSituacaoFinal = ""
					if strFormulaMediaFinal <> "" then
						if cCur(Eval(strFormulaMediaFinal)) >= cCur(strMediaAprovacaoFinal) then
							strSituacaoFinal = "AP"
						else
							strSituacaoFinal = "RN"
						end if
					end if	
		
					'alterar nota
					SQL = "UPDATE SCA_HISTORICO_ESCOLAR_DISCIPLINA SET "
					if strNota = "" then
						SQL = SQL & "nota"&strPosicao&"=null,"
					else
						SQL = SQL & "nota"&strPosicao&"=" & strNota & ","
					end if
					if trim(strMediaEspecial)<>"" then
						SQL = SQL & "nota"&strPosicaoFormula&"=" & replace(strMediaEspecial,",",".") & ","
					end if				
					if strFormulaMediaFinal<>"" then
					   SQL = SQL & "media=" & replace(Eval(strFormulaMediaFinal),",",".") & ","
					end if
					if strSituacaoFinal = "" then
						SQL = SQL & "situacao=null,"
					else
						SQL = SQL & "situacao='" & strSituacaoFinal & "',"
					end if
					if strFalta = "" then
						SQL = SQL & "falta"&strPosicao&"=null"
					else
						SQL = SQL & "falta"&strPosicao&"=" & strFalta & ""
					end if
					SQL = SQL & " where codigo = " & strCodHistoricoDisciplina
					cnn.execute SQL
					GravarLog sql
					
				end if	
			next
			strFormulaMedia = "Média = Maior Nota"
		END IF
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
	
		intCodTurno 		= Trim(Request.Form("cmbTurno"))
		strAlunos 			= Trim(Request.Form("chkAluno"))
		strPosicao			= Trim(Request.Form("txtPosicao"))
		
		IF TRIM(strGravarOnde) = "NOTA" THEN
		'busca os dados dos lancamentos de notas
			intQtdeLancamento = request.form("qtdeAluno")
			for i=1 to intQtdeLancamento
				C1  = -1
				C2  = -1
				C3  = -1
				C4  = -1
				C5  = -1
				C6  = -1
				C7  = -1
				C8  = -1
				C9  = -1
				C10  = -1
				C11  = -1
				C12  = -1
				C13  = -1
				C14  = -1
				C15  = -1
	
				strCodAluno			= request.form("txtCodAluno_"&i)
				strNota				= replace(request.form("txtNota_"&i),",",".")
				strNotaCalc			= request.form("txtNota_"&i)
				strFalta 			= request.form("txtFalta_"&i)
				strAlunoDisciplina 	= request.form("txtAlunoDisciplina_"&i)
				strCodNota 			= request.form("txtCodAlunoNota_"&i)
				strMediaFinal		= replace(request.form("txtMediaFinal_"&i),",",".")
				strSituacaoFinal	= replace(request.form("txtSituacaoFinal_"&i),",",".")
	
				C1_SN = true
				C2_SN = true
				C3_SN = true
				C4_SN = true
				C5_SN = true
				C6_SN = true
				C7_SN = true
				C8_SN = true
				C9_SN = true
				C10_SN = true
				C11_SN = true
				C12_SN = true
				C13_SN = true
				C14_SN = true
				C15_SN = true
	'response.Write("<hr>strPosicaoFormula:" & strPosicaoFormula)
				if strCodNota <> "" then
				'carrega variaveis
					sql = "select nota01, nota02, nota03, nota04, nota05, nota06, nota07, nota08, nota09, nota10, nota11, nota12, nota13, nota14, nota15 "
					sql = sql & " from SCA_NOTAS_FALTAS"
					sql = sql & " where codigo = " & strCodNota

					rs.open sql, cnn
					if not rs.eof then
						if strPosicao = "01" and not isnull(rs("nota01")) then 
							C1  = strNotaCalc
							if strNotaCalc<>"" then C1_SN = false
						else
							if strPosicao = "01" and isnull(rs("nota01"))  then
								C1  = strNotaCalc
								if strNotaCalc<>"" then C1_SN = false
							else
								if not isnull(rs("nota01")) then 
									C1  = rs("nota01")
									C1_SN = false
								end if
							end if
						end if
						
						if strPosicao = "02" and not isnull(rs("nota02")) then 
							C2  = strNotaCalc
							if strNotaCalc<>"" then C2_SN = false
						else
							if strPosicao = "02" and isnull(rs("nota02")) then
								C2  = strNotaCalc
								if strNotaCalc<>"" then C2_SN = false
							else
								if not isnull(rs("nota02")) then 
									C2  = rs("nota02")
									C2_SN = false
								end if
							end if
						end if
						if strPosicao = "03" and not isnull(rs("nota03")) then 
							C3  = strNotaCalc
							if strNotaCalc<>"" then C3_SN = false
						else
							if strPosicao = "03" and isnull(rs("nota03")) then
								C3  = strNotaCalc
								if strNotaCalc<>"" then C3_SN = false
							else
								if not isnull(rs("nota03")) then 
									C3  = rs("nota03")
									C3_SN = false
								end if
							end if
						end if
						
						
						if strPosicao = "04" and not isnull(rs("nota04")) then 
							C4  = strNotaCalc
							if strNotaCalc<>"" then C4_SN = false
						else
							if strPosicao = "04" and isnull(rs("nota04")) then
								C4  = strNotaCalc
								if strNotaCalc<>"" then C4_SN = false
							else
								if not isnull(rs("nota04")) then 
									C4  = rs("nota04")
									C4_SN = false
								end if
							end if
						end if

						if strPosicao = "05" and not isnull(rs("nota05")) then 
							if strNotaCalc<>"" then C5  = strNotaCalc
						else
							if strPosicao = "05" and isnull(rs("nota05")) then
								C5  = strNotaCalc
								if strNotaCalc<>"" then C5_SN = false
							else
								if not isnull(rs("nota05")) then 
									C5  = rs("nota05")
									C5_SN = false
								end if
							end if
						end if
						if strPosicao = "06" and not isnull(rs("nota06")) then 
							C6  = strNotaCalc
							if strNotaCalc<>"" then C6_SN = false
						else
							if strPosicao = "06" and isnull(rs("nota06")) then
								C6  = strNotaCalc
								if strNotaCalc<>"" then C6_SN = false
							else
								if not isnull(rs("nota06")) then 
									C6  = rs("nota06")
									C6_SN = false
								end if
							end if
						end if
						if strPosicao = "07" and not isnull(rs("nota07")) then 
							C7  = strNotaCalc
							if strNotaCalc<>"" then C7_SN = false
						else
							if strPosicao = "07" and isnull(rs("nota07")) then
								C7  = strNotaCalc
								if strNotaCalc<>"" then C7_SN = false
							else
								if not isnull(rs("nota07")) then 
									C7 = rs("nota07")
									C7_SN = false
								end if								
							end if
						end if
						if strPosicao = "08" and not isnull(rs("nota08")) then 
							C8  = strNotaCalc
							if strNotaCalc<>"" then C8_SN = false
						else
							if strPosicao = "08" and isnull(rs("nota08")) then
								C8  = strNotaCalc
								if strNotaCalc<>"" then C8_SN = false
							else
								if not isnull(rs("nota08")) then 
									C8  = rs("nota08")
									C8_SN = false
								end if
							end if
						end if
						if strPosicao = "09" and not isnull(rs("nota09")) then 
							C9  = strNotaCalc
							if strNotaCalc<>"" then C9_SN = false
						else
							if strPosicao = "09" and isnull(rs("nota09")) then
								C9  = strNotaCalc
								if strNotaCalc<>"" then C9_SN = false
							else
								if not isnull(rs("nota09")) then
									C9  = rs("nota09")
									C9_SN = false
								end if
							end if
						end if
						if strPosicao = "10" and not isnull(rs("nota10")) then 
							C10  = strNotaCalc
							if strNotaCalc<>"" then C10_SN = false
						else
							if strPosicao = "10" and isnull(rs("nota10")) then
								C10  = strNotaCalc
								if strNotaCalc<>"" then C10_SN = false
							else
								if not isnull(rs("nota10")) then 
									C10  = rs("nota10")
									C10_SN = false
								end if
							end if
						end if
						if strPosicao = "11" and not isnull(rs("nota11")) then 
							C11  = strNotaCalc
							if strNotaCalc<>"" then C11_SN = false
						else
							if strPosicao = "11" and isnull(rs("nota11")) then
								C11  = strNotaCalc
								if strNotaCalc<>"" then C11_SN = false
							else
								if not isnull(rs("nota11")) then 
									C11  = rs("nota11")
									C11_SN = false
								end if
							end if
						end if
						if strPosicao = "12" and not isnull(rs("nota12")) then 
							C12  = strNotaCalc
							if strNotaCalc<>"" then C12_SN = false
						else
							if strPosicao = "12" and isnull(rs("nota12")) then
								C12  = strNotaCalc
								if strNotaCalc<>"" then C12_SN = false
							else
								if not isnull(rs("nota12")) then 
									C12  = rs("nota12")
									C12_SN = false
								end if
							end if
						end if
						if strPosicao = "13" and not isnull(rs("nota13")) then 
							C13  = strNotaCalc
							if strNotaCalc<>"" then C13_SN = false
						else
							if strPosicao = "13" and isnull(rs("nota13")) then
								C13  = strNotaCalc
								if strNotaCalc<>"" then C13_SN = false
							else
								if not isnull(rs("nota13")) then 
									C13  = rs("nota13")
									C13_SN = false
								end if
							end if
						end if
						if strPosicao = "14" and not isnull(rs("nota14")) then 
							C14  = strNotaCalc
							if strNotaCalc<>"" then C14_SN = false
						else
							if strPosicao = "14" and isnull(rs("nota14")) then
								C14  = strNotaCalc
								if strNotaCalc<>"" then C14_SN = false
							else
								if not isnull(rs("nota14")) then 
									C14  = rs("nota14")
									C14_SN = false
								end if
							end if
						end if
						if strPosicao = "15" and not isnull(rs("nota15")) then 
							C15  = strNotaCalc
							if strNotaCalc<>"" then C15_SN = false
						else
							if strPosicao = "15" and isnull(rs("nota15")) then
								C15  = strNotaCalc
								if strNotaCalc<>"" then C15_SN = false
							else
								if not isnull(rs("nota15")) then 
									C15  = rs("nota15")
									C15_SN = false
								end if
							end if
						end if
					end if
					rs.close	
					
				else
				'limpa carrega variaveis
					if strPosicao = "01" then 
						if strNota = "" then
							C1  = 0
						else
							C1  = strNotaCalc
							C1_SN = false
						end if
					end if
					if strPosicao = "02" then 
						if strNota = "" then
							C2  = 0
						else
							C2  = strNotaCalc
							C2_SN = false
						end if
					end if
					if strPosicao = "03" then 
						if strNota = "" then
							C3  = 0
						else
							C3  = strNotaCalc
							C3_SN = false
						end if
					end if
					if strPosicao = "04" then 
						if strNota = "" then
							C4  = 0
						else
							C4  = strNotaCalc
							C4_SN = false
						end if
					end if
					if strPosicao = "05" then 
						if strNota = "" then
							C5  = 0
						else
							C5  = strNotaCalc
							C5_SN = false
						end if
					end if
					if strPosicao = "06" then 
						if strNota = "" then
							C6  = 0
						else
							C6  = strNotaCalc
							C6_SN = false
						end if
					end if
					if strPosicao = "07" then 
						if strNota = "" then
							C7  = 0
						else
							C7  = strNotaCalc
							C7_SN = false
						end if
					end if
					if strPosicao = "08" then 
						if strNota = "" then
							C8  = 0
						else
							C8  = strNotaCalc
							C8_SN = false
						end if
					end if
					if strPosicao = "09" then 
						if strNota = "" then
							C9  = 0
						else
							C9  = strNotaCalc
							C9_SN = false
						end if
					end if
					if strPosicao = "10" then 
						if strNota = "" then
							C10  = 0
						else
							C10  = strNotaCalc
							C10_SN = false
						end if
					end if
					if strPosicao = "11" then 
						if strNota = "" then
							C11  = 0
						else
							C11  = strNotaCalc
							C11_SN = false
						end if
					end if
					if strPosicao = "12" then 
						if strNota = "" then
							C12  = 0
						else
							C12  = strNotaCalc
							C12_SN = false
						end if
					end if
					if strPosicao = "13" then 
						if strNota = "" then
							C13  = 0
						else
							C13  = strNotaCalc
							C13_SN = false
						end if
					end if
					if strPosicao = "14" then 
						if strNota = "" then
							C14  = 0
							C14_SN = false
						else
							C14  = strNotaCalc
						end if
					end if
					if strPosicao = "15" then 
						if strNota = "" then
							C15  = 0
						else
							C15  = strNotaCalc
							C15_SN = false
						end if
					end if
				end if
				'verifica se as medias foram preenchidas
				
				if strFormulaMediaProvisoria <> "" then
					strFormulaMedia = strFormulaMediaProvisoria
					if strFormulaMediaProvisoria2 <> "" then
					   strFormulaMediaRecuperacao = strFormulaMediaProvisoria2
					end if   
					strFormulaUtilizada = "PROVISORIA"
				else
					if strFormulaMediaRecuperacao <> "" then
						strFormulaMedia = strFormulaMediaRecuperacao
					else
						strFormulaMedia = strFormulaMediaFinal
						strFormulaUtilizada = "FINAL"
					end if
				end if

				'media recuperacao
				if trim(strNota) <> "" then
					if trim(strPosRecuperacao) = trim(strPosicao) then strFormulaMedia = strFormulaMediaRecuperacao
				end if

				'media final
				'**********************************
				'
				'verificar se ess REGRA VAI FICAR NO RECALCULO FOI RETIRADA
				'
				'*********************************
				if strPosicaoDigitacaoMediaFinal = "01" and strFormula = strFormulaMediaFinal then strFormulaMedia = strFormulaMediaFinal
				if strPosicaoDigitacaoMediaFinal = "02" and strFormula = strFormulaMediaFinal then strFormulaMedia = strFormulaMediaFinal
				if strPosicaoDigitacaoMediaFinal = "03" and strFormula = strFormulaMediaFinal then strFormulaMedia = strFormulaMediaFinal
				if strPosicaoDigitacaoMediaFinal = "04" and strFormula = strFormulaMediaFinal then strFormulaMedia = strFormulaMediaFinal
				if strPosicaoDigitacaoMediaFinal = "05" and strFormula = strFormulaMediaFinal then strFormulaMedia = strFormulaMediaFinal
				if strPosicaoDigitacaoMediaFinal = "06" and strFormula = strFormulaMediaFinal then strFormulaMedia = strFormulaMediaFinal
				if strPosicaoDigitacaoMediaFinal = "07" and strFormula = strFormulaMediaFinal then strFormulaMedia = strFormulaMediaFinal
				if strPosicaoDigitacaoMediaFinal = "08" and strFormula = strFormulaMediaFinal then strFormulaMedia = strFormulaMediaFinal
				if strPosicaoDigitacaoMediaFinal = "09" and strFormula = strFormulaMediaFinal then strFormulaMedia = strFormulaMediaFinal
				if strPosicaoDigitacaoMediaFinal = "10" and strFormula = strFormulaMediaFinal then strFormulaMedia = strFormulaMediaFinal
				if strPosicaoDigitacaoMediaFinal = "11" and strFormula = strFormulaMediaFinal then strFormulaMedia = strFormulaMediaFinal
				if strPosicaoDigitacaoMediaFinal = "12" and strFormula = strFormulaMediaFinal then strFormulaMedia = strFormulaMediaFinal
				if strPosicaoDigitacaoMediaFinal = "13" and strFormula = strFormulaMediaFinal then strFormulaMedia = strFormulaMediaFinal
				if strPosicaoDigitacaoMediaFinal = "14" and strFormula = strFormulaMediaFinal then strFormulaMedia = strFormulaMediaFinal
				if strPosicaoDigitacaoMediaFinal = "15" and strFormula = strFormulaMediaFinal then strFormulaMedia = strFormulaMediaFinal
				'**********************************
				
				
				if C1   = "" OR C1   = "-1" OR ISNULL(C1) then C1  = 0
				if C2   = "" OR C2   = "-1" OR ISNULL(C2) then C2  = 0
				if C3   = "" OR C3   = "-1" OR ISNULL(C3) then C3  = 0
				if C4   = "" OR C4   = "-1" OR ISNULL(C4) then C4  = 0
				if C5   = "" OR C5   = "-1" OR ISNULL(C5) then C5  = 0
				if C6   = "" OR C6   = "-1" OR ISNULL(C6) then C6  = 0
				if C7   = "" OR C7   = "-1" OR ISNULL(C7) then C7  = 0
				if C8   = "" OR C8   = "-1" OR ISNULL(C8) then C8  = 0
				if C9   = "" OR C9   = "-1" OR ISNULL(C9) then C9  = 0
				if C10  = "" OR C10   = "-1" OR ISNULL(C10) then C10 = 0
				if C11  = "" OR C11   = "-1" OR ISNULL(C11) then C11 = 0
				if C12  = "" OR C12   = "-1" OR ISNULL(C12) then C12 = 0
				if C13  = "" OR C13   = "-1" OR ISNULL(C13) then C13 = 0
				if C14  = "" OR C14   = "-1" OR ISNULL(C14) then C14 = 0
				if C15  = "" OR C15   = "-1" OR ISNULL(C15) then C15 = 0				

				if isnull(strCodNota) or trim(strCodNota) = "" then
				'incluir
					if trim(strNota) <> "" or trim(strFalta) <> "" then
						strSituacaoFinal = ""
						if strFormulaMedia <> "" then
							IF strFormulaUtilizada = "PROVISORIA" THEN
								if round(Eval(strFormulaMedia),1) >= cCur(strMediaAprovacaoExame) then
									strSituacaoFinal = "AP"
								else
									strSituacaoFinal = "RN"
								end if
							ELSE
								if round(Eval(strFormulaMedia),1) >= cCur(strMediaAprovacaoFinal) then
									strSituacaoFinal = "AP"
								else
									strSituacaoFinal = "RN"
								end if
							END IF
						end if	
							
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
					  
						if strPercFaltas > intFrequenciaMinimaPerc then	
						   strSituacaoFinal = "RN"
						end if   							
						rs.close
						' Fim da regra de reprovação por faltas	
						
						SQL = "INSERT INTO SCA_NOTAS_FALTAS (cod_empresa, cod_aluno, cod_aluno_disciplina, cod_periodo, "
						SQL = SQL & "ano_letivo, semestre, cod_disciplina, "
						SQL = SQL & "nota"&strPosicao&", falta"&strPosicao&","
						if strPosicaoFormula<>"" then
							SQL = SQL & "nota"&strPosicaoFormula&", falta"&strPosicaoFormula&","
						end if
						SQL = SQL & "media,situacao) VALUES ("
						SQL = SQL & "" & intCodEmp & ","
						SQL = SQL & "" & strCodAluno & ","
						SQL = SQL & "" & strAlunoDisciplina & ","
						SQL = SQL & "" & intCodPeriodo & ","
						SQL = SQL & "" & strAnoLetivo & ","
						SQL = SQL & "" & intSemestre & ","
						SQL = SQL & "" & intCodDisciplina & ","
						if strNota = "" then
							SQL = SQL & "null,"
						else
							SQL = SQL & "" & strNota & ","
						end if
						if strFalta = "" then
							SQL = SQL & "null,"
						else
							SQL = SQL & "" & strFalta & ","
						end if
						
						if trim(strPosicaoFormula)<>"" then
							SQL = SQL & "" & replace(formatNumber(Eval(strFormula),1),",",".") & ","
							SQL = SQL & "null,"
						end if
											
						if strFormulaMedia = "" then
							SQL = SQL & "null,"
						else
							if trim(strNota) <> "" then
							   SQL = SQL & "" & replace(formatNumber(Eval(strFormulaMedia),1),",",".") & ","
							else   
							   SQL = SQL & "null,"
							end if   
						end if
						
						if strSituacaoFinal = "" then
							SQL = SQL & "null)"
						else
							SQL = SQL & "'" & strSituacaoFinal & "')"
						end if				
						cnn.execute SQL
						GravarLog sql
					end if
				else
				'alteracao
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
					if strNota = "" then
						SQL = SQL & "nota"&strPosicao&"=null, "
					else
						SQL = SQL & "nota"&strPosicao&"=" & strNota & ", "
					end if

					if trim(strFormulaMedia) <> "" then 
						'USADO EXAME FINAL
						if trim(strTipoFormulaFinal) = "EF" then
							if trim(strFormula)<>"" then
								SQL = SQL & "nota"&strPosicaoFormula&"=" & replace(formatNumber(Eval(strFormula),1),",",".") & ", "
							end if		
						
						   'com exame
						    calculaexame="N"
							if trim(strNota) <> "" AND TRIM(strPosicao) = TRIM(strPosRecuperacao) then
							   calculaexame="S"
							end if  

							if TRIM(strPosRecuperacao) = "01" and C1_SN=false  then 
								calculaexame = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "02" and C2_SN=false  then 
								calculaexame = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "03" and C3_SN=false  then 
								calculaexame = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "04" and C4_SN=false  then 
								calculaexame = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "05" and C5_SN=false  then 
								calculaexame = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "06" and C6_SN=false  then 
								calculaexame = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "07" and C7_SN=false  then 
								calculaexame = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "08" and C8_SN=false  then 
								calculaexame = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "09" and C9_SN=false  then 
								calculaexame = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "10" and C10_SN=false then 
								calculaexame = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "11" and C11_SN=false then 
								calculaexame = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "12" and C12_SN=false then 
								calculaexame = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "13" and C13_SN=false then 
								calculaexame = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "14" and C14_SN=false then 
								calculaexame = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "15" and C15_SN=false then 
								calculaexame = "S"							
								strFormulaMedia = strFormulaMediaFinal
							end if

                            if calculaexame="S" then
								SQL = SQL & "media=" & replace(round(Eval(strFormulaMedia),1),",",".") & ", "

							    if cCur(round(Eval(strFormulaMedia),1)) >= cCur(strMediaAprovacaoFinal) then
						   	       strSituacaoFinal = "AP"
							    else
							       strSituacaoFinal = "RN"
							    end if
								
							else

								if round(Eval(strFormulaMediaProvisoria),1) >= cCur(strMediaAprovacaoExame) then
						   	       strSituacaoFinal = "AP"
							    else
							       strSituacaoFinal = "RN"
							    end if
								SQL = SQL & "media=" & replace(round(Eval(strFormulaMediaProvisoria),1),",",".") & ", "
							end if	
							
						'USADO RECUPERAÇÃO
						elseif trim(strTipoFormulaFinal) = "REC" then
						   'com exame
						    calculaRecuperacao="N"
							'validação para quando a nota
								
							
							'acrescentei recuperacao dia 17/12/2009
							'**************************
							if TRIM(strPosRecuperacao) = "01" and C1_SN=false  then 
								calculaRecuperacao = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "02" and C2_SN=false  then 
								calculaRecuperacao = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "03" and C3_SN=false  then 
								calculaRecuperacao = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "04" and C4_SN=false  then 
								calculaRecuperacao = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "05" and C5_SN=false  then 
								calculaRecuperacao = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "06" and C6_SN=false  then 
								calculaRecuperacao = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "07" and C7_SN=false  then 
								calculaRecuperacao = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "08" and C8_SN=false  then 
								calculaRecuperacao = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "09" and C9_SN=false  then 
								calculaRecuperacao = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "10" and C10_SN=false then 
								calculaRecuperacao = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "11" and C11_SN=false then 
								calculaRecuperacao = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "12" and C12_SN=false then 
								calculaRecuperacao = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "13" and C13_SN=false then 
								calculaRecuperacao = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "14" and C14_SN=false then 
								calculaRecuperacao = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "15" and C15_SN=false then 
								calculaRecuperacao = "S"							
								strFormulaMedia = strFormulaMediaFinal
							end if
							'**************************
							
							'acrescentei para conselho dia 17/12/2009
							'**************************
							calculaConselho = "N"
							intNotaConselho = 0
							if TRIM(strPosConselhoClasse) = "01" and C1_SN=false  then 
								calculaConselho = "S"
								intNotaConselho = C1
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosConselhoClasse) = "02" and C2_SN=false  then 
								calculaConselho = "S"
								intNotaConselho = C2
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosConselhoClasse) = "03" and C3_SN=false  then 
								calculaConselho = "S"
								intNotaConselho = C3
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosConselhoClasse) = "04" and C4_SN=false  then 
								calculaConselho = "S"
								intNotaConselho = C4
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosConselhoClasse) = "05" and C5_SN=false  then 
								calculaConselho = "S"
								intNotaConselho = C5
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosConselhoClasse) = "06" and C6_SN=false  then 
								calculaConselho = "S"
								intNotaConselho = C6
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosConselhoClasse) = "07" and C7_SN=false  then 
								calculaConselho = "S"
								intNotaConselho = C7
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosConselhoClasse) = "08" and C8_SN=false  then 
								calculaConselho = "S"
								intNotaConselho = C8
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosConselhoClasse) = "09" and C9_SN=false  then 
								calculaConselho = "S"
								intNotaConselho = C9
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosConselhoClasse) = "10" and C10_SN=false then 
								calculaConselho = "S"
								intNotaConselho = C10
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosConselhoClasse) = "11" and C11_SN=false then 
								calculaConselho = "S"
								intNotaConselho = C11
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosConselhoClasse) = "12" and C12_SN=false then 
								calculaConselho = "S"
								intNotaConselho = C12
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosConselhoClasse) = "13" and C13_SN=false then 
								calculaConselho = "S"
								intNotaConselho = C13
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosConselhoClasse) = "14" and C14_SN=false then 
								calculaConselho = "S"
								intNotaConselho = C14
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosConselhoClasse) = "15" and C15_SN=false then 
								calculaConselho = "S"	
								intNotaConselho = C15						
								strFormulaMedia = strFormulaMediaFinal
							end if
							'**************************
					
							
IF SESSION("USUARIOWEB")="CLEOVIS" THEN
	RESPONSE.Write "<BR>strPosRecuperacao:" & strPosRecuperacao
	RESPONSE.Write "<BR>strPosConselhoClasse:" & strPosConselhoClasse
	RESPONSE.Write "<BR>calculaConselho:" & calculaConselho
	RESPONSE.Write "<BR>calculaRecuperacao:" & calculaRecuperacao
	RESPONSE.Write "<BR>C1_SNsemnota:" & C1_SN
	RESPONSE.Write "<BR>C2_SNsemnota:" & C2_SN
	RESPONSE.Write "<BR>C3_SNsemnota:" & C3_SN
	RESPONSE.Write "<BR>C4_SNsemnota:" & C4_SN
	RESPONSE.Write "<BR>C5_SNsemnota:" & C5_SN
	RESPONSE.Write "<BR>C6_SNsemnota:" & C6_SN
	RESPONSE.Write "<BR>C7_SNsemnota:" & C7_SN
	RESPONSE.Write "<BR>C8_SNsemnota:" & C8_SN
	RESPONSE.Write "<BR>strMediaAprovacaoFinal:" & strMediaAprovacaoFinal
	RESPONSE.Write "<BR>strMediaAprovacaoExame:" & strMediaAprovacaoExame
	RESPONSE.Write "<BR>strFormulaMediaProvisoria:" & strFormulaMediaProvisoria
	RESPONSE.Write "<BR>strFormulaMediaRecuperacao:" & strFormulaMediaRecuperacao
	RESPONSE.Write "<BR>strFormulaMedia:" & strFormulaMedia
	RESPONSE.Write "<BR>strFormulaMediaFinal:" & strFormulaMediaFinal
	RESPONSE.Write "<BR>strFormula:" & strFormula
	RESPONSE.Write "<HR>"
END IF
						
							if calculaConselho = "N" and calculaRecuperacao = "N" then
							'media provisória
								SQL = SQL & "media=" & replace(round(Eval(strFormulaMediaProvisoria),1),",",".") & ", "
								if strPosRecuperacao = strPosicao then
									if strNota = "" then
										SQL = SQL & "nota"&strPosicaoFormula&"=null, "
									else
									  '******	 
								      if strFormulaMediaProvisoria2 = "" then 
									  	 SQL = SQL & "nota"&strPosicaoFormula&"=" & replace(round(Eval(strFormulaMediaRecuperacao),1),",",".") & ", "
									  else
									  	 SQL = SQL & "nota"&strPosicaoFormula&"=" & replace(round(Eval(strFormulaMediaProvisoria),1),",",".") & ", "
									  end if
									  '******	 
									end if
								else
									SQL = SQL & "nota"&strPosicaoFormula&"=" & replace(round(Eval(strFormula),1),",",".") & ", "
								end if
								if round(Eval(strFormulaMediaProvisoria),1) >= cCur(strMediaAprovacaoExame) then
								   strSituacaoFinal = "AP"
								else
								   strSituacaoFinal = "RN"
								end if
							elseif calculaConselho = "N" and calculaRecuperacao = "S" then
							'media da recuperacao
				                if trim(strFormulaMediaRecuperacao) <> "" then  ' testa se a formula nao esta vazia
								   SQL = SQL & "media=" & replace(round(Eval(strFormulaMediaRecuperacao),1),",",".") & ", "
								   if strNota = "" then
								      SQL = SQL & "nota"&strPosicaoFormula&"=null, "
								   else
								      '******
								      if strFormulaMediaProvisoria2 = "" then 
									  	 SQL = SQL & "nota"&strPosicaoFormula&"=" & replace(round(Eval(strFormulaMediaRecuperacao),1),",",".") & ", "
									  else
									  	 SQL = SQL & "nota"&strPosicaoFormula&"=" & replace(round(Eval(strFormulaMediaProvisoria),1),",",".") & ", "
									  end if
									  '******	 
								   end if
								   if round(Eval(strFormulaMediaRecuperacao),1) >= cCur(strMediaAprovacaoExame) then
								      strSituacaoFinal = "AP"
								   else
								      strSituacaoFinal = "RN"
								   end if
								else   
								   SQL = SQL & "media=" & replace(round(Eval(strFormulaMediaProvisoria),1),",",".") & ", "
								   if strNota = "" then
								      SQL = SQL & "nota"&strPosicaoFormula&"=null, "
								   else
									  '******	 
								      if strFormulaMediaProvisoria2 = "" then 
									  	 SQL = SQL & "nota"&strPosicaoFormula&"=" & replace(round(Eval(strFormulaMediaRecuperacao),1),",",".") & ", "
									  else
									  	 SQL = SQL & "nota"&strPosicaoFormula&"=" & replace(round(Eval(strFormulaMediaProvisoria),1),",",".") & ", "
									  end if
									  '******	 
								   end if
								   if round(Eval(strFormulaMediaProvisoria),1) >= cCur(strMediaAprovacaoExame) then
								      strSituacaoFinal = "AP"
								   else
								      strSituacaoFinal = "RN"
								   end if
                                end if								      
							elseif calculaConselho = "S" and calculaRecuperacao = "N" then
							'media especial - fixa
								intCalResultado = Eval(strFormulaMediaProvisoria) + intNotaConselho
								IF intCalResultado > 10 THEN intCalResultado = 10
								SQL = SQL & "media=" & replace(round(intCalResultado,1),",",".") & ", "
								if round(intCalResultado,1) >= cCur(strMediaAprovacaoFinal) then
								   strSituacaoFinal = "AP"
								else
								   strSituacaoFinal = "RN"
								end if
							elseif calculaConselho = "S" and calculaRecuperacao = "S" then
							'media final completa
								intCalResultado = round(Eval(strFormulaMediaFinal),1)
								IF intCalResultado > 10 THEN intCalResultado = 10
								SQL = SQL & "media=" & replace(intCalResultado,",",".") & ", "
								if strNota = "" then
									SQL = SQL & "nota"&strPosicaoFormula&"=null, "
								else
									SQL = SQL & "nota"&strPosicaoFormula&"=" & replace(intCalResultado,",",".") & ", "
								end if
								if cCur(intCalResultado) >= cCur(strMediaAprovacaoFinal) then
								   strSituacaoFinal = "AP"
								else
								   strSituacaoFinal = "RN"
								end if
							end if 
						else
						   if strNota <> "" then
							  SQL = SQL & "media=" & replace(formatNumber(Eval(strFormulaMedia),1),",",".") & ", "
								if round(Eval(strFormulaMedia),1) >= cCur(strMediaAprovacaoFinal) then
									strSituacaoFinal = "AP"
								else
									strSituacaoFinal = "RN"
								end if							  
						   end if	  
						end if
					    
						if strPercFaltas > intFrequenciaMinimaPerc then	
					       strSituacaoFinal = "RN"
					    end if   

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

					if trim(ucase(session("usuarioWeb"))) = "BORGES" then
						'response.Write "<br>SQL:" & SQL
						'response.Write "<br>SQL:" & SQL
						'response.Write "<hr>"
						'RESPONSE.End()
					end if
					cnn.execute SQL
					GravarLog sql
					
				end if
			next
		ELSEIF TRIM(strGravarOnde) = "HISTORICO" THEN
		'busca os dados dos lancamentos de historico
			intQtdeLancamento		= request.form("qtdeAluno")
			for i=1 to intQtdeLancamento
				strCodHistoricoDisciplina		= request.form("txtCodHistoricoDisciplina_"&i)
				strCodAluno			= request.form("txtCodAluno_"&i)
				strNota				= replace(request.form("txtNota_"&i),",",".")
				strNotaCalc			= request.form("txtNota_"&i)
				strFalta 			= request.form("txtFalta_"&i)
				strAlunoDisciplina 	= request.form("txtAlunoDisciplina_"&i)
				strCodNota 			= request.form("txtCodAlunoNota_"&i)
				strMediaFinal		= replace(request.form("txtMediaFinal_"&i),",",".")
				strSituacaoFinal	= replace(request.form("txtSituacaoFinal_"&i),",",".")
	
				C1  = -1
				C2  = -1
				C3  = -1
				C4  = -1
				C5  = -1
				C6  = -1
				C7  = -1
				C8  = -1
				C9  = -1
				C10  = -1
				C11  = -1
				C12  = -1
				C13  = -1
				C14  = -1
				C15  = -1
				
				if strCodNota <> "" then
				'carrega variaveis
					sql = "select nota01, nota02, nota03, nota04, nota05, nota06, nota07, nota08, nota09, nota10, nota11, nota12, nota13, nota14, nota15 "
					sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA"
					sql = sql & " where codigo = " & strCodHistoricoDisciplina
					rs.open sql, cnn
					if not rs.eof then
						if strPosicao = "01" and strNota<>"" then 
							C1  = strNotaCalc
						else
							if strPosicao = "01" and strNota = "" then
								C1  = 0
							else
								if not isnull(rs("nota01")) then C1  = rs("nota01")
							end if
						end if
						if strPosicao = "02" and strNota<>"" then 
							C2  = strNotaCalc
						else
							if strPosicao = "02" and strNota = "" then
								C2  = 0
							else
								if not isnull(rs("nota02")) then C2  = rs("nota02")
							end if
						end if
						if strPosicao = "03" and strNota<>"" then 
							C3  = strNotaCalc
						else
							if strPosicao = "03" and strNota = "" then
								C3  = 0
							else
								if not isnull(rs("nota03")) then C3  = rs("nota03")
							end if
						end if
						if strPosicao = "04" and strNota<>"" then 
							C4  = strNotaCalc
						else
							if strPosicao = "04" and strNota = "" then
								C4  = 0
							else
								if not isnull(rs("nota04")) then C4  = rs("nota04")
							end if
						end if
						if strPosicao = "05" and strNota<>"" then 
							C5  = strNotaCalc
						else
							if strPosicao = "05" and strNota = "" then
								C5  = 0
							else
								if not isnull(rs("nota05")) then C5  = rs("nota05")
							end if
						end if
						if strPosicao = "06" and strNota<>"" then 
							C6  = strNotaCalc
						else
							if strPosicao = "06" and strNota = "" then
								C6  = 0
							else
								if not isnull(rs("nota06")) then C6  = rs("nota06")
							end if
						end if
						if strPosicao = "07" and strNota<>"" then 
							C7  = strNotaCalc
						else
							if strPosicao = "07" and strNota = "" then
								C7  = 0
							else
								if not isnull(rs("nota07")) then C7  = rs("nota07")
							end if
						end if
						if strPosicao = "08" and strNota<>"" then 
							C8  = strNotaCalc
						else
							if strPosicao = "08" and strNota = "" then
								C8  = 0
							else
								if not isnull(rs("nota08")) then C8  = rs("nota08")
							end if
						end if
						if strPosicao = "09" and strNota<>"" then 
							C9  = strNotaCalc
						else
							if strPosicao = "09" and strNota = "" then
								C9  = 0
							else
								if not isnull(rs("nota09")) then C9  = rs("nota09")
							end if
						end if
						if strPosicao = "10" and strNota<>"" then 
							C10  = strNotaCalc
						else
							if strPosicao = "10" and strNota = "" then
								C10  = 0
							else
								if not isnull(rs("nota10")) then C10  = rs("nota10")
							end if
						end if
						if strPosicao = "11" and strNota<>"" then 
							C11  = strNotaCalc
						else
							if strPosicao = "11" and strNota = "" then
								C11  = 0
							else
								if not isnull(rs("nota11")) then C11  = rs("nota11")
							end if
						end if
						if strPosicao = "12" and strNota<>"" then 
							C12  = strNotaCalc
						else
							if strPosicao = "12" and strNota = "" then
								C12  = 0
							else
								if not isnull(rs("nota12")) then C12  = rs("nota12")
							end if
						end if
						if strPosicao = "13" and strNota<>"" then 
							C13  = strNotaCalc
						else
							if strPosicao = "13" and strNota = "" then
								C13  = 0
							else
								if not isnull(rs("nota13")) then C13  = rs("nota13")
							end if
						end if
						if strPosicao = "14" and strNota<>"" then 
							C14  = strNotaCalc
						else
							if strPosicao = "14" and strNota = "" then
								C14  = 0
							else
								if not isnull(rs("nota14")) then C14  = rs("nota14")
							end if
						end if
						if strPosicao = "15" and strNota<>"" then 
							C15  = strNotaCalc
						else
							if strPosicao = "15" and strNota = "" then
								C15  = 0
							else
								if not isnull(rs("nota15")) then C15  = rs("nota15")
							end if
						end if
					end if
					rs.close	
				else
				'limpa carrega variaveis
					if strPosicao = "01" then 
						if strNota = "" then
							C1  = 0
						else
							C1  = strNotaCalc
						end if
					end if
					if strPosicao = "02" then 
						if strNota = "" then
							C2  = 0
						else
							C2  = strNotaCalc
						end if
					end if
					if strPosicao = "03" then 
						if strNota = "" then
							C3  = 0
						else
							C3  = strNotaCalc
						end if
					end if
					if strPosicao = "04" then 
						if strNota = "" then
							C4  = 0
						else
							C4  = strNotaCalc
						end if
					end if
					if strPosicao = "05" then 
						if strNota = "" then
							C5  = 0
						else
							C5  = strNotaCalc
						end if
					end if
					if strPosicao = "06" then 
						if strNota = "" then
							C6  = 0
						else
							C6  = strNotaCalc
						end if
					end if
					if strPosicao = "07" then 
						if strNota = "" then
							C7  = 0
						else
							C7  = strNotaCalc
						end if
					end if
					if strPosicao = "08" then 
						if strNota = "" then
							C8  = 0
						else
							C8  = strNotaCalc
						end if
					end if
					if strPosicao = "09" then 
						if strNota = "" then
							C9  = 0
						else
							C9  = strNotaCalc
						end if
					end if
					if strPosicao = "10" then 
						if strNota = "" then
							C10  = 0
						else
							C10  = strNotaCalc
						end if
					end if
					if strPosicao = "11" then 
						if strNota = "" then
							C11  = 0
						else
							C11  = strNotaCalc
						end if
					end if
					if strPosicao = "12" then 
						if strNota = "" then
							C12  = 0
						else
							C12  = strNotaCalc
						end if
					end if
					if strPosicao = "13" then 
						if strNota = "" then
							C13  = 0
						else
							C13  = strNotaCalc
						end if
					end if
					if strPosicao = "14" then 
						if strNota = "" then
							C14  = 0
						else
							C14  = strNotaCalc
						end if
					end if
					if strPosicao = "15" then 
						if strNota = "" then
							C15  = 0
						else
							C15  = strNotaCalc
						end if
					end if
				end if
				'verifica se as medias foram preenchidas
				if strFormulaMediaProvisoria<> "" then
					strFormulaMedia = strFormulaMediaProvisoria
					strFormulaUtilizada = "PROVISORIA"
				else
					if strFormulaMediaRecuperacao<> "" then
						strFormulaMedia = strFormulaMediaRecuperacao
					else
						strFormulaMedia = strFormulaMediaFinal
						strFormulaUtilizada = "FINAL"
					end if
				end if				
				
				'media recuperacao
				if trim(strNota) <> "" then
					if trim(strPosRecuperacao)=trim(strPosicao) then strFormulaMedia = strFormulaMediaRecuperacao
				end if
				
				'media final
				if strPosicaoDigitacaoMediaFinal = "01" and strFormula = strFormulaMediaFinal then strFormulaMedia = strFormulaMediaFinal
				if strPosicaoDigitacaoMediaFinal = "02" and strFormula = strFormulaMediaFinal then strFormulaMedia = strFormulaMediaFinal
				if strPosicaoDigitacaoMediaFinal = "03" and strFormula = strFormulaMediaFinal then strFormulaMedia = strFormulaMediaFinal
				if strPosicaoDigitacaoMediaFinal = "04" and strFormula = strFormulaMediaFinal then strFormulaMedia = strFormulaMediaFinal
				if strPosicaoDigitacaoMediaFinal = "05" and strFormula = strFormulaMediaFinal then strFormulaMedia = strFormulaMediaFinal
				if strPosicaoDigitacaoMediaFinal = "06" and strFormula = strFormulaMediaFinal then strFormulaMedia = strFormulaMediaFinal
				if strPosicaoDigitacaoMediaFinal = "07" and strFormula = strFormulaMediaFinal then strFormulaMedia = strFormulaMediaFinal
				if strPosicaoDigitacaoMediaFinal = "08" and strFormula = strFormulaMediaFinal then strFormulaMedia = strFormulaMediaFinal
				if strPosicaoDigitacaoMediaFinal = "09" and strFormula = strFormulaMediaFinal then strFormulaMedia = strFormulaMediaFinal
				if strPosicaoDigitacaoMediaFinal = "10" and strFormula = strFormulaMediaFinal then strFormulaMedia = strFormulaMediaFinal
				if strPosicaoDigitacaoMediaFinal = "11" and strFormula = strFormulaMediaFinal then strFormulaMedia = strFormulaMediaFinal
				if strPosicaoDigitacaoMediaFinal = "12" and strFormula = strFormulaMediaFinal then strFormulaMedia = strFormulaMediaFinal
				if strPosicaoDigitacaoMediaFinal = "13" and strFormula = strFormulaMediaFinal then strFormulaMedia = strFormulaMediaFinal
				if strPosicaoDigitacaoMediaFinal = "14" and strFormula = strFormulaMediaFinal then strFormulaMedia = strFormulaMediaFinal
				if strPosicaoDigitacaoMediaFinal = "15" and strFormula = strFormulaMediaFinal then strFormulaMedia = strFormulaMediaFinal
		
				if C1   = -1 then C1  = 0
				if C2   = -1 then C2  = 0
				if C3   = -1 then C3  = 0
				if C4   = -1 then C4  = 0
				if C5   = -1 then C5  = 0
				if C6   = -1 then C6  = 0
				if C7   = -1 then C7  = 0
				if C8   = -1 then C8  = 0
				if C9   = -1 then C9  = 0
				if C10  = -1 then C10 = 0
				if C11  = -1 then C11 = 0
				if C12  = -1 then C12 = 0
				if C13  = -1 then C13 = 0
				if C14  = -1 then C14 = 0
				if C15  = -1 then C15 = 0
				
				'altera hist disc
				SQL = "update SCA_HISTORICO_ESCOLAR_DISCIPLINA SET "
				if strNota = "" then
				   SQL = SQL & "nota"&strPosicao&"=null, "
				else
				   SQL = SQL & "nota"&strPosicao&"=" & strNota & ", "
				end if
				'if trim(strFormula)<>"" then
				'   SQL = SQL & "nota"&strPosicaoFormula&"=" & replace(formatNumber(Eval(strFormula),1),",",".") & ", "
				'end if		
				if trim(strFormulaMedia) <> "" then 
					'USADO EXAME FINAL
					if trim(strTipoFormulaFinal) = "EF" then
					   'com exame
						calculaexame="N"
						if trim(strNota) <> "" then
						   calculaexame="S"
						end if   
						if (cCur(strMediaAprovacaoExame) > round(Eval(strFormulaMediaProvisoria),1)) then
						   calculaexame="S"
						end if   
						if calculaexame="S" then
							SQL = SQL & "media=" & replace(formatNumber(Eval(strFormulaMedia),1),",",".") & ", "
							if round(Eval(strFormulaMedia),1) >= cCur(strMediaAprovacaoFinal) then
							   strSituacaoFinal = "AP"
							else
							   strSituacaoFinal = "RN"
							end if
						end if	

					'USADO RECUPERAÇÃO
					elseif trim(strTipoFormulaFinal) = "REC" then
						   'com exame
						    calculaRecuperacao="N"
							'validação para quando a nota
								
							
							'acrescentei recuperacao dia 17/12/2009
							'**************************
							if TRIM(strPosRecuperacao) = "01" and C1_SN=false  then 
								calculaRecuperacao = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "02" and C2_SN=false  then 
								calculaRecuperacao = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "03" and C3_SN=false  then 
								calculaRecuperacao = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "04" and C4_SN=false  then 
								calculaRecuperacao = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "05" and C5_SN=false  then 
								calculaRecuperacao = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "06" and C6_SN=false  then 
								calculaRecuperacao = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "07" and C7_SN=false  then 
								calculaRecuperacao = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "08" and C8_SN=false  then 
								calculaRecuperacao = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "09" and C9_SN=false  then 
								calculaRecuperacao = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "10" and C10_SN=false then 
								calculaRecuperacao = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "11" and C11_SN=false then 
								calculaRecuperacao = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "12" and C12_SN=false then 
								calculaRecuperacao = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "13" and C13_SN=false then 
								calculaRecuperacao = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "14" and C14_SN=false then 
								calculaRecuperacao = "S"
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosRecuperacao) = "15" and C15_SN=false then 
								calculaRecuperacao = "S"							
								strFormulaMedia = strFormulaMediaFinal
							end if
							'**************************
						
							'acrescentei para conselho dia 17/12/2009
							'**************************
							calculaConselho = "N"
							intNotaConselho = 0
							if TRIM(strPosConselhoClasse) = "01" and C1_SN=false  then 
								calculaConselho = "S"
								intNotaConselho = C1
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosConselhoClasse) = "02" and C2_SN=false  then 
								calculaConselho = "S"
								intNotaConselho = C2
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosConselhoClasse) = "03" and C3_SN=false  then 
								calculaConselho = "S"
								intNotaConselho = C3
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosConselhoClasse) = "04" and C4_SN=false  then 
								calculaConselho = "S"
								intNotaConselho = C4
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosConselhoClasse) = "05" and C5_SN=false  then 
								calculaConselho = "S"
								intNotaConselho = C5
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosConselhoClasse) = "06" and C6_SN=false  then 
								calculaConselho = "S"
								intNotaConselho = C6
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosConselhoClasse) = "07" and C7_SN=false  then 
								calculaConselho = "S"
								intNotaConselho = C7
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosConselhoClasse) = "08" and C8_SN=false  then 
								calculaConselho = "S"
								intNotaConselho = C8
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosConselhoClasse) = "09" and C9_SN=false  then 
								calculaConselho = "S"
								intNotaConselho = C9
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosConselhoClasse) = "10" and C10_SN=false then 
								calculaConselho = "S"
								intNotaConselho = C10
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosConselhoClasse) = "11" and C11_SN=false then 
								calculaConselho = "S"
								intNotaConselho = C11
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosConselhoClasse) = "12" and C12_SN=false then 
								calculaConselho = "S"
								intNotaConselho = C12
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosConselhoClasse) = "13" and C13_SN=false then 
								calculaConselho = "S"
								intNotaConselho = C13
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosConselhoClasse) = "14" and C14_SN=false then 
								calculaConselho = "S"
								intNotaConselho = C14
								strFormulaMedia = strFormulaMediaFinal
							end if
							if TRIM(strPosConselhoClasse) = "15" and C15_SN=false then 
								calculaConselho = "S"	
								intNotaConselho = C15						
								strFormulaMedia = strFormulaMediaFinal
							end if
							'**************************
							if calculaConselho = "N" and calculaRecuperacao = "N" then
							'media provisória
								SQL = SQL & "media=" & replace(round(Eval(strFormulaMediaProvisoria),1),",",".") & ", "
								if strPosRecuperacao = strPosicao then
									if strNota = "" then
										SQL = SQL & "nota"&strPosicaoFormula&"=null, "
									else
										SQL = SQL & "nota"&strPosicaoFormula&"=" & replace(round(Eval(strFormulaMediaRecuperacao),1),",",".") & ", "
									end if
								else
									SQL = SQL & "nota"&strPosicaoFormula&"=" & replace(round(Eval(strFormula),1),",",".") & ", "
								end if
								if round(Eval(strFormulaMediaProvisoria),1) >= cCur(strMediaAprovacaoExame) then
								   strSituacaoFinal = "AP"
								else
								   strSituacaoFinal = "RN"
								end if

							elseif calculaConselho = "N" and calculaRecuperacao = "S" then
							'media da recuperacao
				                if trim(strFormulaMediaRecuperacao) <> "" then  ' testa se a formula nao esta vazia
								   SQL = SQL & "media=" & replace(round(Eval(strFormulaMediaRecuperacao),1),",",".") & ", "
								   if strNota = "" then
								      SQL = SQL & "nota"&strPosicaoFormula&"=null, "
								   else
									  SQL = SQL & "nota"&strPosicaoFormula&"=" & replace(round(Eval(strFormulaMediaRecuperacao),1),",",".") & ", "
								   end if
								   if round(Eval(strFormulaMediaRecuperacao),1) >= cCur(strMediaAprovacaoExame) then
								      strSituacaoFinal = "AP"
								   else
								      strSituacaoFinal = "RN"
								   end if
								else   
								   SQL = SQL & "media=" & replace(round(Eval(strFormulaMediaProvisoria),1),",",".") & ", "
								   if strNota = "" then
								      SQL = SQL & "nota"&strPosicaoFormula&"=null, "
								   else
									  SQL = SQL & "nota"&strPosicaoFormula&"=" & replace(round(Eval(strFormulaMediaProvisoria),1),",",".") & ", "
								   end if
								   if round(Eval(strFormulaMediaProvisoria),1) >= cCur(strMediaAprovacaoExame) then
								      strSituacaoFinal = "AP"
								   else
								      strSituacaoFinal = "RN"
								   end if
                                end if								      
						elseif calculaConselho = "S" and calculaRecuperacao = "N" then
							'media especial - fixa
								intCalResultado = Eval(strFormulaMediaProvisoria) + intNotaConselho
								IF intCalResultado > 10 THEN intCalResultado = 10
								SQL = SQL & "media=" & replace(round(intCalResultado,1),",",".") & ", "
								if round(intCalResultado,1) >= cCur(strMediaAprovacaoFinal) then
								   strSituacaoFinal = "AP"
								else
								   strSituacaoFinal = "RN"
								end if
							elseif calculaConselho = "S" and calculaRecuperacao = "S" then
							'media final completa
								intCalResultado = round(Eval(strFormulaMediaFinal),1)
								IF intCalResultado > 10 THEN intCalResultado = 10
								SQL = SQL & "media=" & replace(intCalResultado,",",".") & ", "
								if cCur(intCalResultado) >= cCur(strMediaAprovacaoFinal) then
								   strSituacaoFinal = "AP"
								else
								   strSituacaoFinal = "RN"
								end if
							end if 
						else
						   if strNota <> "" then
							  SQL = SQL & "media=" & replace(formatNumber(Eval(strFormulaMedia),1),",",".") & ", "
								if round(Eval(strFormulaMedia),1) >= cCur(strMediaAprovacaoFinal) then
									strSituacaoFinal = "AP"
								else
									strSituacaoFinal = "RN"
								end if							  
						   end if	
						end if
				    
						if strPercFaltas > intFrequenciaMinimaPerc then	
					       strSituacaoFinal = "RN"
					    end if   

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
		END IF
	end if
	
	if strPaginaRetorno = "NOTA" then
		strParametro = "Notas_cad.asp?cmbPeriodo="&intCodPeriodo
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
	elseif strPaginaRetorno = "NOTAPROF" then
		strParametro = "NotasProf_cad.asp?cmbPeriodo="&intCodPeriodo
		strParametro = strParametro & "&txtAnoLetivo="&strAnoLetivo
		strParametro = strParametro & "&cmbSemestre="&intSemestre
		strParametro = strParametro & "&cmbDisciplinaProfessorHorario="&intCodDisciplina
		strParametro = strParametro & "&cmbDisciplinaDoProfessor="&intCodDisciplina
		strParametro = strParametro & "&chkTipoNota="&intCodTipoNota
		strParametro = strParametro & "&cmbTurmaProfessor="&intCodTurma
		strParametro = strParametro & "&chkAluno="&strAlunos
		strParametro = strParametro & "&cmbTurno="&intCodTurno
		strParametro = strParametro & "&cmbTipoLancamento="&intCodTipoLancamento
		strParametro = strParametro & "&cmbCurso="&intCodCurso	
		strParametro = strParametro & "&cmbativos="&strAtivos
	end if

	if err.number = 0 then

			' INICIO - Dados Para Envio de E-mail
			
				strNomedisciplina = ""
				sql = "SELECT DESC_DISCIPLINA FROM SCA_DISCIPLINA"
				sql = sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
				sql = sql & " AND	COD_DISCIPLINA = " & intCodDisciplina
				rs.open sql, cnn
				if not rs.eof then
					strNomedisciplina = rs("DESC_DISCIPLINA")
				end if
				rs.close
				
				strEmail = ""	
				sql=" SELECT EMAIL FROM SEG_EMPRESA "
				sql=sql & " WHERE CODIGO = " & Session("CodEmpresa") 
				rs.open sql, cnn
				if not rs.eof then
				   strEmail				= rs("email")	
				end if
				rs.close	
				
				nomeresponsavel = ""	
				sql=" SELECT NOME, EMAIL FROM SRH_COLABORADOR "
				sql=sql & " WHERE CODIGO_SEG_USUARIOS_SISTEMA =  '" & Session("UsuarioWeb") & "'"
				rs.open sql, cnn
				if not rs.eof then
				   nomeresponsavel		= rs("nome")	
				end if
				rs.close	
	
				nometurmalancamento = ""	
				sql=" SELECT NOMETURMA FROM SCA_TURMA "
				sql=sql & " WHERE COD_TURMA =  " & intCodTurma
				rs.open sql, cnn
				if not rs.eof then
				   nometurmalancamento		= rs("nometurma")	
				end if
				rs.close	
	
				strEmailOrigem	 = "webmaster@sisge.com.br"
				strAssuntoEmail	 = "Lançamento de Notas e Faltas"  
				strMensagemEmail = "<br> Lançamento realizado por: " & nomeresponsavel & "<br>"
				strMensagemEmail = strMensagemEmail & "Turma: " & nometurmalancamento & "<br>"
				strMensagemEmail = strMensagemEmail & "Disciplina: " & strNomedisciplina & "<br>"
				strMensagemEmail = strMensagemEmail & "Avaliação: " & strNomeNota & "<br>"
				strMensagemEmail = strMensagemEmail & "Atualização: " & strGravarOnde & "<br>"
	 
				if strEmail <> "" then 
				   'Envia um email com dados do lançamento de notas
				   EnviarEmail strEmailOrigem, strEmail, strAssuntoEmail, strMensagemEmail
				end if
				
			' FIM - Dados Para Envio de E-mail
	
		'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			aguarde.style.display="none";
		</script>
		<script>
			alert("Nota registrada com sucesso.	");
			window.navigate('<%=strParametro%>');
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