<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 27/04/2008
	::	Desenvolvedores...: Sérgio Borges - sergiob76@gmail.com
	::	Objetivo Pagina...: Alteração no numero de chamada
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans

	strAcao = request.QueryString("acao")
	
	if strAcao = "I"then
	elseif strAcao = "A"then
		strMensagem = "Registro alterado com sucesso..."
	 
		intCodTurma 			= Trim(Request.Form("cmbTurma"))
		intCodCurso	 			= Trim(Request.Form("cmbCurso"))
		intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
		intSemestre 			= Trim(Request.Form("cmbSemestre"))
		intCodTurno		 		= Trim(Request.Form("cmbTurno"))
		
		if intCodComp = "" then intCodComp = "0"
		if intCodSerie = "" then intCodSerie = "0"
		if intCodTurno = "" then intCodTurno = "0"
		if intCodSemestre = "" then intCodSemestre = "0"
		if intCodTurma = "" then intCodTurma = "0"	
		
		%>
		<form method="post" id="frm" action="numeroDiarioFrequencia_cad.asp">
		<input type="hidden" name="cmbTurma" value="<%=intCodTurma%>" />
		<input type="hidden" name="cmbCurso" value="<%=intCodCurso%>" />
		<input type="hidden" name="cmbPeriodo" value="<%=intCodPeriodo%>" />
		<input type="hidden" name="cmbSemestre" value="<%=intSemestre%>" />
		<input type="hidden" name="cmbTurno	" value="<%=intCodTurno%>" />
		</form>
		<%

		'select dos alunos listados na página
		sql = sqlAlunoTurma(intCodTurma, "")
		rs.open sql, cnn,2,3
		
		if rs.eof = false then
			while not rs.eof
				strNumeroChamada = Trim(Request.Form("txtChamada"&rs("codAlunoTurma")))
				sql="UPDATE SCA_ALUNO_TURMA SET SEQUENCIA="
				 
				if strNumeroChamada <> "" then
					sql = sql & strNumeroChamada
				else
				 	sql = sql& "null" 
				end if
				 
				sql=sql&" WHERE CODIGO = "& rs("codAlunoTurma")
				sql=sql&" and cod_empresa = " & Session("CodEmpresa")								 
				
				cnn.execute sql			 

				rs.movenext
			wend
		end if
		rs.close
		
	elseif strAcao = "E"then 
	end if

	cnn.execute sql
	GravarLog sql
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			frm.submit();
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