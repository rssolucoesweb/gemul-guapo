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
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	intCodCurso	 		= Trim(Request("cmbCurso"))
	intCodPeriodo 		= Trim(Request("cmbPeriodo"))
	strData		 		= formatadataBD(Trim(Request("txtData")))

	intSemestre 		= Trim(Request.Form("txtSemestre"))
	strAnoLetivo 		= Trim(Request.Form("txtAnoLetivo"))
	
	strGravarOnde = "NOTA"
	msnHistorico  = ""
	if trim(intSemestre) = "3" then
	   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  then
			strGravarOnde = "HISTORICO"
		    strMensagem = "Registro Excluído com sucesso no Histórico..."
	   end if
	else
	   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  or trim(intSemestre) <> trim(session("strSemestre")) then
			strGravarOnde = "HISTORICO"
			strMensagem = "Registro Excluído com sucesso no Histórico..."
	   end if	   
	end if


	intCodDisciplina	= Trim(Request.Form("cmbDisciplinaTurma"))
	intCodTipoNota 		= Trim(Request.Form("chkTipoNota"))
	intCodTurma 		= Trim(Request.Form("cmbTurma"))
	intCodTurno 		= Trim(Request.Form("cmbTurno"))
	strCodAluno			= Trim(Request("txtAluno"))
	strAlunoDisciplina	= Trim(Request("txtAlunoDisc"))
	intCodFalta			= Trim(Request("txtCodFalta"))
	strFalta			= Trim(Request("Falta"))
	strPosicao			= Trim(Request.Form("txtPosicao"))
	strAlunos 			= Trim(Request.Form("chkAluno"))

	IF TRIM(strGravarOnde) = "NOTA" THEN
	'busca os dados dos lancamentos de notas
	
	    strMensagem = "Falta Excluida com sucesso..."
		
		SQL = "SELECT FALTA FROM SCA_FALTAS_DIARIA "
		SQL = SQL & " WHERE COD_EMPRESA = " & intCodEmp
		SQL = SQL & " AND COD_ALUNO = " & strCodAluno
		SQL = SQL & " AND CODIGO = " & intCodFalta
		rs.open sql, cnn
		if not rs.eof then
			SQL = "UPDATE SCA_NOTAS_FALTAS "
			SQL = SQL & " SET falta"&strPosicao&"= falta"&strPosicao&"-" & strFalta
			SQL = SQL & " WHERE cod_empresa="&intCodEmp
			SQL = SQL & " AND cod_aluno="&strCodAluno
			SQL = SQL & " AND cod_aluno_disciplina="&strAlunoDisciplina
			SQL = SQL & " AND cod_periodo="&intCodPeriodo
			SQL = SQL & " AND ano_letivo="&strAnoLetivo
			SQL = SQL & " AND semestre="&intSemestre
			SQL = SQL & " AND cod_disciplina="&intCodDisciplina

			cnn.execute SQL
			GravarLog sql
						
			SQL = "DELETE FROM SCA_FALTAS_DIARIA "
			SQL = SQL & " WHERE COD_EMPRESA = " & intCodEmp
			SQL = SQL & " AND COD_ALUNO = " & strCodAluno
			SQL = SQL & " AND CODIGO = " & intCodFalta
			cnn.execute SQL
			GravarLog sql
		end if
		rs.close			

	ELSEIF TRIM(strGravarOnde) = "HISTORICO" THEN
	'busca os dados dos lancamentos de historico
		strCodHistoricoDisciplina = request("txtCodHistoricoDisciplina")
		
		SQL = "SELECT FALTA FROM SCA_FALTAS_DIARIA "
		SQL = SQL & " WHERE COD_EMPRESA = " & intCodEmp
		SQL = SQL & " AND COD_ALUNO = " & strCodAluno
		SQL = SQL & " AND CODIGO = " & intCodFalta
		rs.open sql, cnn
		if not rs.eof then
			SQL = "UPDATE SCA_HISTORICO_ESCOLAR_DISCIPLINA SET "
			SQL = SQL & "falta"&strPosicao&"=falta"&strPosicao&"-" & strFalta & ""
			SQL = SQL & " where codigo = " & strCodHistoricoDisciplina
			cnn.execute SQL
			GravarLog sql

			SQL = " select codigo, falta"&strPosicao&" as faltaBim FROM SCA_HISTORICO_ESCOLAR_DISCIPLINA "
			SQL = SQL & " where codigo = " & strCodHistoricoDisciplina
			rs1.open sql, cnn
			if not rs1.eof then
				if rs1("faltaBim") < "0" then
				SQL = "UPDATE SCA_HISTORICO_ESCOLAR_DISCIPLINA SET "
				SQL = SQL & "falta"&strPosicao&"= 0"
				SQL = SQL & " where codigo = " & strCodHistoricoDisciplina
				cnn.execute SQL
				GravarLog sql
				end if
			end if
				
			SQL = "DELETE FROM SCA_FALTAS_DIARIA "
			SQL = SQL & " WHERE COD_EMPRESA = " & intCodEmp
			SQL = SQL & " AND COD_ALUNO = " & strCodAluno
			SQL = SQL & " AND CODIGO = " & intCodFalta
			cnn.execute SQL
			GravarLog sql
		end if
		rs.close			

	END IF

	strParametro = "Faltas_cad.asp?cmbPeriodo="&intCodPeriodo
	strParametro = strParametro & "&txtAnoLetivo="&strAnoLetivo
	strParametro = strParametro & "&cmbSemestre="&intSemestre
	strParametro = strParametro & "&cmbDisciplinaTurma="&intCodDisciplina
	strParametro = strParametro & "&chkTipoNota="&intCodTipoNota
	strParametro = strParametro & "&cmbTurma="&intCodTurma
	strParametro = strParametro & "&chkAluno="&strAlunos
	strParametro = strParametro & "&cmbTurno="&intCodTurno
	strParametro = strParametro & "&cmbTipoLancamento="&intCodTipoLancamento
	strParametro = strParametro & "&cmbCurso="&intCodCurso	
	strParametro = strParametro & "&txtData="&formatadataAP(strData)
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			aguarde.style.display="none";
		</script>
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
			aguarde.style.display="none";
		</script>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>