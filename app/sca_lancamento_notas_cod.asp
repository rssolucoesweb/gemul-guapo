<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8"
response.ContentType = "text/html"
response.Expires = 0
Server.ScriptTimeOut = 5000
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 19/01/2021
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Notas 
-->
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_recalcula_notas_turma.asp"-->
<!--#include file="includes/inc_aguarde.asp"-->
<%
	strPaginaRetorno	= Trim(Request.Form("txtPaginaRetorno"))
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	intCodCurso	 		= Trim(Request("cmbCurso"))
	intCodPeriodo 		= Trim(Request("cmbPeriodo"))
	strAtivos           = trim(request("cmbativos"))
	strPosicao			= Trim(Request.Form("txtPosicao"))
	intSemestre 		= Trim(Request.Form("cmbSemestre"))
	strAnoLetivo 		= Trim(Request.Form("txtAnoLetivo"))
	strRecalculo 		= Trim(Request.Form("txtRecalculo"))
	buscaHistorico 		= Trim(Request.Form("buscaHistorico"))

	if buscaHistorico = "S" then
		strGravarOnde = "HISTORICO"
		strMensagem = "Registro salvo com sucesso no Histórico..."
	else
		strGravarOnde = "NOTA"	
		strMensagem = "Registro salvo com sucesso..."
	end if
	
	'verifica se o usuario é professor ou admnistrativo
	sql = "select codigo "
	sql = sql & " from SRH_COLABORADOR"
	sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
	sql = sql & " and codLotacao= " & Session("CodEmpresa")
	sql = sql & " and (CodCategoria = 1 or CodCategoria = 8)"'professor
	sql = sql & " and Situacao = 'A'"'ativo
	rs.open sql, cnn
	if rs.eof then
		strTipoAcessoCadastroNotas = "ADM"
	else
		strTipoAcessoCadastroNotas = "PROF"
	end if
	rs.close
	
	if strTipoAcessoCadastroNotas = "ADM" then
		intCodDisciplina	= Trim(Request.Form("cmbDisciplinaTurma"))
		intCodTurma 		= Trim(Request.Form("cmbTurma"))
	elseif strTipoAcessoCadastroNotas = "PROF" then
		intCodDisciplina	= Trim(Request.Form("cmbDisciplinaDoProfessor"))
		IF intCodDisciplina="" OR intCodDisciplina = "0" THEN intCodDisciplina	= Trim(Request.Form("cmbDisciplinaTurma"))
		intCodTurma 			= Trim(Request("cmbTurmaProfessor"))
	end if
	
	'flag para opção de recalculo
	if strRecalculo = "S" then intCodDisciplina	= Trim(Request.Form("cmbDisciplinaTurma"))


	intCodTurno 		= Trim(Request.Form("cmbTurno"))
	strAlunos 			= Trim(Request.Form("chkAluno"))

	
	
	'1 > 1º Bimestre
	'2 > 2º Bimestre
	'3 > 3º Bimestre
	'4 > 4º Bimestre
	'5 > Média Provisória 
	'6 > Exame
	'7 > Conselho de Classe
	'8 > Media Final
	
	'busca a media
	sql = "SELECT media_aprovacao_final, media_aprovacao, condicaoEF_notaInicial, condicaoEF_notaFinal, tipoFormulaFinal, frequencia_minima_percentual "
	sql = sql & " FROM SCA_CRITERIO_AVALIACAO "
	sql = sql & " WHERE	ano_letivo = " & strAnoLetivo
	sql = sql & " AND 	COD_CURSO = " & intCodCurso
	'response.write sql
	rs.open sql, cnn
	if not rs.eof then
		strMediaAprovacaoFinal 		= rs("media_aprovacao_final")
		strMediaAprovacaoExame 		= rs("media_aprovacao")'DO EXAME ESTA GRAVANDO INVERTIDO NO CRITERIO
		intCondicaoEF_notaInicial 	= rs("condicaoEF_notaInicial")
		intCondicaoEF_notaFinal 	= rs("condicaoEF_notaFinal")
		strTipoFormulaFinal 		= rs("tipoFormulaFinal")
		intFrequenciaMinimaPerc		= rs("frequencia_minima_percentual")
	end if
	rs.close
	
	dim C(15)

	' ============================================================
	' MEDIA ESPECIAL
	' Quando o aluno nao possui nota em um ou mais bimestres,
	' remove o(s) componente(s) C1..C4 e ajusta o divisor.
	' Ex.: sem C3 => (C1+C2+C4)/3
	' A formula original da SCA_CALCULO nao e alterada.
	' ============================================================
	Function FormulaMediaEspecial(strFormulaOriginal, bolME1, bolME2, bolME3, bolME4)
		dim strSomaME, intQtdME, strMediaME, strFormulaME

		strSomaME = ""
		intQtdME = 0

		if not bolME1 then
			strSomaME = "C1"
			intQtdME = intQtdME + 1
		end if
		if not bolME2 then
			if strSomaME <> "" then strSomaME = strSomaME & "+"
			strSomaME = strSomaME & "C2"
			intQtdME = intQtdME + 1
		end if
		if not bolME3 then
			if strSomaME <> "" then strSomaME = strSomaME & "+"
			strSomaME = strSomaME & "C3"
			intQtdME = intQtdME + 1
		end if
		if not bolME4 then
			if strSomaME <> "" then strSomaME = strSomaME & "+"
			strSomaME = strSomaME & "C4"
			intQtdME = intQtdME + 1
		end if

		strFormulaME = strFormulaOriginal

		' So altera quando existe pelo menos um bimestre especial
		' e ainda existe pelo menos um bimestre participando da media.
		if intQtdME > 0 and intQtdME < 4 then
			strMediaME = "(" & strSomaME & ")/" & intQtdME
			strFormulaME = Replace(strFormulaME, "(C1+C2+C3+C4)/4", strMediaME, 1, -1, 1)
		end if

		FormulaMediaEspecial = strFormulaME
	End Function
	
	intQtdeLancamento = request.form("qtdeAluno")
		
	cnn.begintrans
	
	for i=1 to intQtdeLancamento
		strCodAluno			= request.form("txtCodAluno_"&i)
		'strAlunoDisciplina 	= request.form("txtAlunoDisciplina_"&i)
		strCodNota 			= request.form("txtCodAlunoNota_"&i)
		strNotaExame 		= ""
		strNotaConselho		= ""
		strSituacaoFinal	= replace(request.form("txtSituacaoFinal_"&i),",",".")
		
		'carrega campos
		sql="select ca.posicao, ca.descricao, ca.formula, ca.digitar, ca.cod_tipo_lancamento as tipo, ca.SIGLA  "
		sql=sql & " from SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO ii"
		sql=sql & " inner join SCA_TIPO_CALCULO tc on tc.codigo = ii.cod_tipo_calculo"
		sql=sql & " inner join SCA_CALCULO ca on ca.cod_tipo_calculo = ii.cod_tipo_calculo"
		sql=sql & " where ii.ano_letivo = " & strAnoLetivo
		sql=sql & " and ii.cod_aluno = " & strCodAluno

		SQL = SQL & " UNION"
		
		sql=sql & " select c.posicao, c.descricao, c.formula, c.digitar, c.cod_tipo_lancamento as tipo, c.SIGLA "
		sql=sql & " from SCA_CRITERIO_AVALIACAO ca"
		sql=sql & " inner join SCA_TIPO_CALCULO tc on tc.codigo = ca.cod_tipo_calculo"
		sql=sql & " inner join SCA_CALCULO c on c.cod_tipo_calculo = tc.codigo"
		sql=sql & " where ca.ano_letivo = " & strAnoLetivo
		sql=sql & " and ca.cod_curso = " & intCodCurso
		
		sql = sql & " AND NOT EXISTS"
		sql = sql & " ("
		sql = sql & " select ca.posicao, ca.descricao, ca.formula, ca.digitar, ca.cod_tipo_lancamento as tipo, ca.SIGLA  "
		sql = sql & " from SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO ii"
		sql = sql & " inner join SCA_TIPO_CALCULO tc on tc.codigo = ii.cod_tipo_calculo"
		sql = sql & " inner join SCA_CALCULO ca on ca.cod_tipo_calculo = ii.cod_tipo_calculo"
		sql = sql & " where ii.ano_letivo = " & strAnoLetivo
		sql = sql & " and ii.cod_aluno = " & strCodAluno
		sql = sql & " )"
		
		if trim(UCASE(SESSION("usuarioweb")))="SERGIO" THEN
			'response.write sql
			'response.end
		END IF	
		
		vetCampo = null
		rs.open sql, cnn
		if not rs.eof then
			vetCampo = rs.getRows
		end if
		rs.close
		
		' ============================================================
		' Verifica os bimestres configurados em SCA_ALUNO_MEDIA_ESPECIAL
		' para ESTE aluno + disciplina + periodo. O COD_CALCULO e ligado
		' a SCA_CALCULO para obter a posicao (C1, C2, C3 ou C4).
		' ============================================================
		bolMediaEspecial1 = false
		bolMediaEspecial2 = false
		bolMediaEspecial3 = false
		bolMediaEspecial4 = false
		bolPossuiMediaEspecial = false

		SQL = "SELECT DISTINCT C.POSICAO "
		SQL = SQL & " FROM SCA_ALUNO_MEDIA_ESPECIAL ME "
		SQL = SQL & " INNER JOIN SCA_CALCULO C ON C.CODIGO = ME.COD_CALCULO "
		SQL = SQL & " WHERE ME.COD_EMPRESA = " & intCodEmp
		SQL = SQL & " AND ME.COD_ALUNO = " & strCodAluno
		SQL = SQL & " AND ME.ANO_LETIVO = " & strAnoLetivo
		SQL = SQL & " AND ME.SEMESTRE = " & intSemestre
		SQL = SQL & " AND ME.COD_PERIODO = " & intCodPeriodo
		SQL = SQL & " AND ME.COD_DISCIPLINA = " & intCodDisciplina
		SQL = SQL & " AND C.COD_TIPO_CALCULO = 1 "
		SQL = SQL & " AND C.COD_TIPO_LANCAMENTO IN (1,2,3,4) "
		rs.open SQL, cnn
		do while not rs.eof
			bolPossuiMediaEspecial = true
			select case cInt(rs("POSICAO"))
				case 1: bolMediaEspecial1 = true
				case 2: bolMediaEspecial2 = true
				case 3: bolMediaEspecial3 = true
				case 4: bolMediaEspecial4 = true
			end select
			rs.movenext
		loop
		rs.close

		calculaMedia = "NAO"
		for j=0 to ubound(vetCampo,2)
			C(j)  = replace(request.form("txtNota_"&i&"_0"&j),".",",")
			
			if trim(UCASE(SESSION("usuarioweb")))="SERGIO" THEN
				'response.write "<br>C(j) :" & C(j) 
				'response.end
			END IF	
			
			if trim(C(j)) = "" then 
				C(j) = -1
			else
				calculaMedia = "SIM"
			end if
		next
		
		
		
		C1  = 0 
		C2  = 0
		C3  = 0
		C4  = 0
		C5  = 0
		C6  = 0
		C7  = 0
		C8  = 0
		C9  = 0
		C10  = 0
		C11  = 0
		C12  = 0
		C13  = 0
		C14  = 0
		C15  = 0

		bolCalcularMediaExame 		= false
		bolCalcularMediaConselho 	= false
		strFormulaCalculoAnterior 	= ""
		strMediaFinal = ""


		' Início da Regra de reprovação por Falta
		SQL = "SELECT "
		SQL = SQL & " Isnull(NF.falta01,'0') + Isnull(NF.falta02,'0') + Isnull(NF.falta03,'0') + Isnull(NF.falta04,'0') + Isnull(NF.falta05,'0') + Isnull(NF.falta06,'0') + Isnull(NF.falta07,'0') + Isnull(NF.falta08,'0') + Isnull(NF.falta09,'0') + Isnull(NF.falta10,'0') + Isnull(NF.falta11,'0') + Isnull(NF.falta12,'0') + Isnull(NF.falta13,'0') + Isnull(NF.falta14,'0') + Isnull(NF.falta15,'0') as totalfalta, "
		SQL = SQL & " AD.CODIGO AS COD_ALUNO_DISCIPLINA, "
		SQL = SQL & " AD.COD_ALUNO AS CODIGO, "
		SQL = SQL & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
		SQL = SQL & " AD.COD_DISCIPLINA, "
		SQL = SQL & " GCD.Ch_Anual "
		SQL = SQL & " FROM SCA_ALUNO_DISCIPLINA AD " 
		SQL = SQL & " INNER JOIN SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO " 
		SQL = SQL & " INNER JOIN SCA_NOTAS_FALTAS NF ON NF.cod_aluno_disciplina = AD.CODIGO " 
		SQL = SQL & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurriculardisciplina = AD.COD_GRADECURRICULARDISCIPLINA "
		SQL = SQL & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa") 
		SQL = SQL & " AND AD.COD_TURMA_REMANEJAMENTO = " & intCodTurma 
		SQL = SQL & " AND A.CODIGO = " & strCodAluno 
		SQL = SQL & " AND AD.COD_DISCIPLINA = " & intCodDisciplina
		'if ucase(session("usuarioWeb")) = "03544163160" THEN
	'		response.write sql
'		END IF
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
		
		if strPercFaltas<>"" and intFrequenciaMinimaPerc <>"" then
			if cInt(strPercFaltas) > cInt(intFrequenciaMinimaPerc) then	
			   strSituacaoFinalFaltas = "RF"
			else
			   strSituacaoFinalFaltas = ""
			end if   
		else
		   strSituacaoFinalFaltas = ""
		end if

		' Fim da regra de reprovação por faltas	

		if buscaHistorico = "S" then
			SQL = "update SCA_HISTORICO_ESCOLAR_DISCIPLINA set "
		else
			SQL = "update SCA_NOTAS_FALTAS set "
		end if		
		for r=0 to ubound(vetCampo,2)
			strNota = C(r)
			strNotaTela = C(r)
			
			if trim(vetCampo(0,r)) = "1"   then  if strNota = -1 then C1   = 0 else C1  = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "2"   then  if strNota = -1 then C2   = 0 else C2  = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "3"   then  if strNota = -1 then C3   = 0 else C3  = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "4"   then  if strNota = -1 then C4   = 0 else C4  = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "5"   then  if strNota = -1 then C5   = 0 else C5  = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "6"   then  if strNota = -1 then C6   = 0 else C6  = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "7"   then  if strNota = -1 then C7   = 0 else C7  = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "8"   then  if strNota = -1 then C8   = 0 else C8  = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "9"   then  if strNota = -1 then C9   = 0 else C9  = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "10"  then  if strNota = -1 then C10  = 0 else C10 = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "11"  then  if strNota = -1 then C11  = 0 else C11 = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "12"  then  if strNota = -1 then C12  = 0 else C12 = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "13"  then  if strNota = -1 then C13  = 0 else C13 = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "14"  then  if strNota = -1 then C14  = 0 else C14 = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "15"  then  if strNota = -1 then C15  = 0 else C15 = cCur(strNota) end if end if

			'Busca Formula
			if trim(vetCampo(3,r)) = "N" then 
				'media conforme formula
				strFormulaAtual = vetCampo(2,r)

				'Aplica a formula diferenciada SOMENTE para o aluno/disciplina
				'que possui configuracao na SCA_ALUNO_MEDIA_ESPECIAL.
				if bolPossuiMediaEspecial then
					strFormulaAtual = FormulaMediaEspecial(strFormulaAtual, bolMediaEspecial1, bolMediaEspecial2, bolMediaEspecial3, bolMediaEspecial4)
				end if

				strNota = replace(round(Eval(strFormulaAtual),1),",",".")
				if trim(strFormulaCalculoAnterior) = "" then strFormulaCalculoAnterior = strFormulaAtual
			end if
			
			if vetCampo(4,r) = "6" and trim(vetCampo(3,r)) = "S" then 
				if strNotaTela = -1 then  
					bolCalcularMediaExame = false
				else
					bolCalcularMediaExame = true
				end if
			elseif vetCampo(4,r) = "6" and trim(vetCampo(3,r)) = "N" then 
				if not bolCalcularMediaExame then
					strNota 		= -1'replace(round(Eval(strFormulaCalculoAnterior),1),",",".")
					if trim(calculaMedia) = "SIM" then 
						strMediaFinal 	= replace(round(Eval(strFormulaCalculoAnterior),1),",",".")
					end if
				end if
			end if
			
			'if session("usuarioWeb")="SERGIO" and i=2 then
			'		response.write "<br>strFormulaCalculoAnterior:" & strFormulaCalculoAnterior
			'		response.write "<br>strMediaFinal:" & strMediaFinal
			'	'response.end
			'end if
			
			if vetCampo(4,r) = "7" and trim(vetCampo(3,r)) = "S" and not bolCalcularMediaExame then 
				if strNotaTela = -1 then  
					bolCalcularConselhoExame = false
				else
					bolCalcularConselhoExame = true
				end if
			elseif (vetCampo(4,r) = "6" or  vetCampo(4,r) = "7" or vetCampo(4,r) = "8") and trim(vetCampo(3,r)) = "N" then 
				if (not bolCalcularConselhoExame) and (not bolCalcularMediaExame) then
					strNota 		= replace(round(Eval(strFormulaCalculoAnterior),1),",",".")
					strMediaFinal 	= replace(round(Eval(strFormulaCalculoAnterior),1),",",".")
				end if
			elseif (vetCampo(4,r) = "5") and trim(vetCampo(3,r)) = "N"  then 
				if bolCalcularMediaExame then
					strNota 		= replace(round(Eval(strFormulaCalculoAnterior),1),",",".")
					strMediaFinal 	= replace(round(Eval(strFormulaCalculoAnterior),1),",",".")
				else
					strNota = -1
				end if
			end if

			strComplemento = "0"	
			if cInt(vetCampo(0,r))>9 then strComplemento = ""

			if calculaMedia = "NAO" and cInt(vetCampo(0,r)) = 5 then
				SQL = SQL & "nota" & strComplemento & vetCampo(0,r) & " = null,"
			elseif calculaMedia = "NAO" and cInt(vetCampo(0,r)) = 9 then
				SQL = SQL & "nota" & strComplemento & vetCampo(0,r) & " = null,"
			else
				if strNota = -1 then
					SQL = SQL & "nota" & strComplemento & vetCampo(0,r) & " = null,"
				else
					SQL = SQL & "nota" & strComplemento & vetCampo(0,r) & " = " & replace(strNota,",",".") & ","
				end if
			end if

			'if session("usuarioWeb")="SERGIO" and i=2 then
			'	response.write "<br>vetCampo(0,r):" & vetCampo(0,r)
			'	response.write "<br>trim(vetCampo(5,r)):" & trim(vetCampo(5,r))
			'	response.write "<br>nota: nota" & strComplemento & vetCampo(0,r)
			'	response.write "<br>strNota: " & strNota
			'	response.write "<br>strMediaFinal:" & strMediaFinal
			'	response.write "<br>bolCalcularMediaExame:" & bolCalcularMediaExame
			'	response.write "<br>bolCalcularConselhoExame:" & bolCalcularConselhoExame
			'	response.write "<hr>"
			'	
			'END IF


		next	


	'IF ucase(SESSION("USUARIOWEB")) = "SERGIO" and i=2 THEN
	'	
	'	response.write "<br>C1:" & C1 
	'	response.write "<br>C2:" & C2
	'	response.write "<br>C3:" & C3 
	'	response.write "<br>C4:" & C4 
	'	response.write "<br>calculo:" & (C1+C2+C3+C4)/4
	'	
	'	response.write "<br>strNota:" & strNota 
	'	response.write "<br>bolCalcularMediaExame:" & bolCalcularMediaExame 
	'	response.write "<br>strMediaAprovacaoFinal:" & strMediaAprovacaoFinal 
	'	response.write "<br>strMediaAprovacaoExame:" & strMediaAprovacaoExame 
	'	response.write "<br>strMediaFinal:" & strMediaFinal 
	'	response.end
	'END IF
		
		if strMediaFinal = "" then strMediaFinal = strNota

        if bolCalcularMediaExame = false then ' Não tem exame
'response.write strMediaFinal & "|" & strMediaAprovacaoFinal
			if cCur(replace(strMediaFinal,".",",")) >= cCur(strMediaAprovacaoFinal) then
			   strSituacaoFinal = "AP"
			else
			   strSituacaoFinal = "RN"
			end if
        else
			strMediaFinal = strNota
			if cCur(replace(strMediaFinal,".",",")) >= cCur(strMediaAprovacaoExame) then
			   strSituacaoFinal = "AP"
			else
			   strSituacaoFinal = "RN"
			end if
        end if		
		if calculaMedia = "SIM" then SQL = SQL & "media=" & replace(strMediaFinal,",",".") & ", "

		if trim(strSituacaoFinal) = "" then
			SQL = SQL & "situacao=null "
		else
			if strSituacaoFinalFaltas = "RF" then strSituacaoFinal = "RF"
			SQL = SQL & "situacao='" & strSituacaoFinal & "' "
		end if
		SQL = SQL & " where codigo = " & strCodNota
		IF ucase(SESSION("USUARIOWEB")) = "SERGIO" THEN
			'response.write "<br>" & sql 
			'response.end
		END IF
		cnn.execute SQL
		GravarLog sql		
		GravarLog "TABELA DE NOTAS ATUALIZADAS PARA O COD_ALUNO " & strCodAluno & " E COD_NOTA = " & strCodNota
		
	next	

	' ============================================================
	' RECALCULO AUTOMATICO DA TURMA / DISCIPLINA
	' Executa dentro da mesma transacao, apos salvar as notas.
	' Nao executa quando a gravacao esta sendo feita no HISTORICO.
	' ============================================================
	if buscaHistorico <> "S" then
		Call RecalcularNotasTurma(intCodEmp, intCodTurma, intCodCurso, intCodPeriodo, strAnoLetivo, intSemestre, intCodDisciplina)
	end if

	if strRecalculo = "S" then
		strParametro = "NotasRecalculo_con.asp?cmbPeriodo="&intCodPeriodo
		strParametro = strParametro & "&txtAnoLetivo="&strAnoLetivo
		strParametro = strParametro & "&cmbSemestre="&intSemestre
		strParametro = strParametro & "&cmbTurma="&intCodTurma
		strParametro = strParametro & "&cmbTurmaProfessor="&intCodTurma
		strParametro = strParametro & "&cmbTurno="&intCodTurno
		strParametro = strParametro & "&cmbCurso="&intCodCurso
		strParametro = strParametro & "&cmbativos="&strAtivos			
		strMsnAlert = "Recalculo"
	else
		strParametro = "sca_lancamento_notas.asp?cmbPeriodo="&intCodPeriodo
		strParametro = strParametro & "&txtAnoLetivo="&strAnoLetivo
		strParametro = strParametro & "&cmbSemestre="&intSemestre
		strParametro = strParametro & "&cmbDisciplinaTurma="&intCodDisciplina
		strParametro = strParametro & "&cmbDisciplinaProfessorHorario="&intCodDisciplina
		strParametro = strParametro & "&cmbDisciplinaDoProfessor="&intCodDisciplina
		strParametro = strParametro & "&chkTipoNota="&intCodTipoNota
		strParametro = strParametro & "&cmbTurma="&intCodTurma
		strParametro = strParametro & "&cmbTurmaProfessor="&intCodTurma
		strParametro = strParametro & "&chkAluno="&strAlunos
		strParametro = strParametro & "&cmbTurno="&intCodTurno
		strParametro = strParametro & "&cmbTipoLancamento="&intCodTipoLancamento
		strParametro = strParametro & "&cmbCurso="&intCodCurso
		strParametro = strParametro & "&cmbativos="&strAtivos
		strParametro = strParametro & "&buscaHistorico="&buscaHistorico
		strMsnAlert = "Nota"
	end if
	%>
	<script>
		aguarde.style.display="none";
	</script>
	<%	
	if err.number = 0 then
		'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMsnAlert%> registrada com sucesso.");
			window.location ='<%=strParametro%>';
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