<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 04/08/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: troca situacao aluno
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	acao 					= Trim(Request.QueryString("acao"))
	strCodAluno				= Trim(Request("txtCodAluno"))
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))

	if trim(request.Form("txtData")) = "" then
	   strData 			= formatadataBD(date)
	else
	   strData				= formatadataBD(Trim(request.Form("txtData")))   
	end if

	cnn.begintrans

	sql = " SELECT Data_Baixa, USUARIO_BAIXA FROM SCA_PROTOCOLOPORTAL "
	sql = sql & " WHERE Cod_Empresa = " & Session("CodEmpresa")
	sql = sql & " AND Cod_Aluno = " &  strCodAluno
	sql = sql & " AND Ano = " &  strAnoLetivo 
	sql = sql & " AND Semestre = " & intSemestre
	sql = sql & " AND Tipo_Protocolo = 1 "	
	rs.open sql, cnn
	if not rs.eof then	
	   if acao = "I" then
	       	strMensagem = "Registro Baixado com sucesso..."

	       	sql = " update SCA_PROTOCOLOPORTAL set " 
			sql = sql & "Data_Baixa = '" & strData & "',"
			sql = sql & "USUARIO_BAIXA = '" & trim(session("UsuarioWeb")) & "'"
			sql = sql & " WHERE Cod_Empresa = " & Session("CodEmpresa")
			sql = sql & " AND Cod_Aluno = " &  strCodAluno
			sql = sql & " AND Ano = " &  strAnoLetivo 
			sql = sql & " AND Semestre = " & intSemestre
			sql = sql & " AND Tipo_Protocolo = 1 "	
			cnn.execute sql
			GravarLog sql	
		end if		
	    if acao = "E" then
	       	strMensagem = "Baixa Excluída com sucesso..."

	       	sql = " update SCA_PROTOCOLOPORTAL set " 
			sql = sql & "Data_Baixa = NULL,"
			sql = sql & "USUARIO_BAIXA = NULL "
			sql = sql & " WHERE Cod_Empresa = " & Session("CodEmpresa")
			sql = sql & " AND Cod_Aluno = " &  strCodAluno
			sql = sql & " AND Ano = " &  strAnoLetivo 
			sql = sql & " AND Semestre = " & intSemestre
			sql = sql & " AND Tipo_Protocolo = 1 "	
			cnn.execute sql
			GravarLog sql	
		end if		
	    rs.close	
	else
	    cnn.rollbackTrans
	    %>
		<script>
			alert("ATENÇÃO: \nProtocolo não encontrado. Verifique!");
			window.history.back();
		</script>
		<%	
		response.End()
	 end if


	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='BaixaPreMatricula_cad.asp?txtMatricula=<%=strMatricula%>';
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