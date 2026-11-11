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
	strPaginaRetorno	= Trim(Request.Form("txtPaginaRetorno"))
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	intCodCurso	 		= Trim(Request("cmbCurso"))
	intCodPeriodo 		= Trim(Request("cmbPeriodo"))
	strAtivos           = trim(request("cmbativos"))
	strPosicao			= Trim(Request.Form("txtPosicao"))
	intSemestre 		= Trim(Request.Form("txtSemestre"))
	strAnoLetivo 		= Trim(Request.Form("txtAnoLetivo"))
	strRecalculo 		= Trim(Request.Form("txtRecalculo"))

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
		intCodTurma 			= Trim(Request("cmbTurmaProfessor"))
	end if
	
	'flag para opção de recalculo
	if strRecalculo = "S" then intCodDisciplina	= Trim(Request.Form("cmbDisciplinaTurma"))


	intCodTurno 		= Trim(Request.Form("cmbTurno"))
	strAlunos 			= Trim(Request.Form("chkAluno"))

	'carrega campos
	sql = "SELECT  posicao, descricao, formula, digitar, bimestre as tipo "
	sql = sql & " FROM SCA_TIPO_AVALIACAO "
	sql = sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
	sql = sql & " AND 	COD_CURSO = " & intCodCurso
	sql = sql & " order by posicao"
	vetCampo = null
	rs.open sql, cnn
	if not rs.eof then
		vetCampo = rs.getRows
	end if
	rs.close
	
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
	sql = sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
	sql = sql & " AND 	COD_CURSO = " & intCodCurso
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
	
	intQtdeLancamento = request.form("qtdeAluno")
	
	cnn.begintrans
	
	for i=1 to intQtdeLancamento
		for j=0 to ubound(vetCampo,2)
			C(j)  = replace(request.form("txtNota_"&i&"_0"&j),".",",")
			if trim(C(j)) = "" then C(j) = -1
		next
		
		strCodAluno			= request.form("txtCodAluno_"&i)
		'strAlunoDisciplina 	= request.form("txtAlunoDisciplina_"&i)
		strCodNota 			= request.form("txtCodAlunoNota_"&i)
		strNotaExame 		= ""
		strNotaConselho		= ""
		strSituacaoFinal	= replace(request.form("txtSituacaoFinal_"&i),",",".")
		
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
			if strPercFaltas > intFrequenciaMinimaPerc then	
			   strSituacaoFinalFaltas = "RN"
			else
			   strSituacaoFinalFaltas = ""
			end if   

		' Fim da regra de reprovação por faltas	

		if strGravarOnde = "NOTA" then
			SQL = "update SCA_NOTAS_FALTAS set "
		elseif strGravarOnde = "HISTORICO" then
			SQL = "update SCA_HISTORICO_ESCOLAR_DISCIPLINA set "
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
				strNota 		= replace(round(Eval(vetCampo(2,r)),1),",",".")
				if trim(strFormulaCalculoAnterior) = "" then strFormulaCalculoAnterior = vetCampo(2,r)
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
					strMediaFinal 	= replace(round(Eval(strFormulaCalculoAnterior),1),",",".")
				end if
			end if
			if vetCampo(4,r) = "7" and trim(vetCampo(3,r)) = "S" and not bolCalcularMediaExame then 
				if strNotaTela = -1 then  
					bolCalcularConselhoExame = false
				else
					bolCalcularConselhoExame = true
				end if
			elseif vetCampo(4,r) = "8" and trim(vetCampo(3,r)) = "N" then 
				if (not bolCalcularConselhoExame) and (not bolCalcularMediaExame) then
					strNota 		= replace(round(Eval(strFormulaCalculoAnterior),1),",",".")
					strMediaFinal 	= replace(round(Eval(strFormulaCalculoAnterior),1),",",".")
				end if
			end if

			strComplemento = "0"	
			if cInt(vetCampo(0,r))>9 then strComplemento = ""

			if strNota = -1 then
				SQL = SQL & "nota" & strComplemento & vetCampo(0,r) & " = null,"
			else
				SQL = SQL & "nota" & strComplemento & vetCampo(0,r) & " = " & replace(strNota,",",".") & ","
			end if

		next	
		
		if strMediaFinal = "" then strMediaFinal = strNota

        if bolCalcularMediaExame = false then ' Não tem exame
			if cCur(replace(strMediaFinal,".",",")) >= cCur(strMediaAprovacaoFinal) then
			   strSituacaoFinal = "AP"
			else
			   strSituacaoFinal = "RN"
			end if
        else
			if cCur(replace(strMediaFinal,".",",")) >= cCur(strMediaAprovacaoExame) then
			   strSituacaoFinal = "AP"
			else
			   strSituacaoFinal = "RN"
			end if
        end if		

		SQL = SQL & "media=" & replace(strMediaFinal,",",".") & ", "

		if trim(strSituacaoFinal) = "" then
			SQL = SQL & "situacao=null "
		else
			if strSituacaoFinalFaltas = "RN" then strSituacaoFinal = "RN"
			SQL = SQL & "situacao='" & strSituacaoFinal & "' "
		end if
		SQL = SQL & " where codigo = " & strCodNota
		cnn.execute SQL
		GravarLog sql		
		
	next	

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
		strParametro = "NotasNovo_cad.asp?cmbPeriodo="&intCodPeriodo
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
		strMsnAlert = "Nota"
	end if
	
	if err.number = 0 then

		' INICIO - Dados Para Envio de E-mail
		if trim(strRecalculo) = "" then
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
			sql=" SELECT EMAIL, EMAIL_DOMINIO FROM SEG_EMPRESA "
			sql=sql & " WHERE CODIGO = " & Session("CodEmpresa") 
			rs.open sql, cnn
			if not rs.eof then
			   strEmail				= rs("EMAIL")
			   strEmailOrigem		= rs("EMAIL_DOMINIO")	
			   if isnull(strEmail) then strEmail = ""
			   if isnull(strEmailOrigem) then strEmailOrigem = ""
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
	
			strAssuntoEmail	 = "Lançamento de Notas e Faltas"  
			strMensagemEmail = "<br> Lan&ccedil;amento realizado por: " & nomeresponsavel & "<br>"
			strMensagemEmail = strMensagemEmail & "Turma: " & nometurmalancamento & "<br>"
			strMensagemEmail = strMensagemEmail & "Disciplina: " & strNomedisciplina & "<br>"
			strMensagemEmail = strMensagemEmail & "Atualiza&ccedil;&atilde;o: " & strGravarOnde & "<br>"
	
			if strEmail <> "" and strEmailOrigem <> "" then 
			   'Envia um email com dados do lançamento de notas
			   EnviarEmail strEmailOrigem, strEmail, strAssuntoEmail, strMensagemEmail
			end if
		end if	
		' FIM - Dados Para Envio de E-mail
	
		'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			aguarde.style.display="none";
		</script>
		<script>
			alert("<%=strMsnAlert%> registrada com sucesso.	");
			window.location ='<%=strParametro%>';
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