<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/10/2020
	::	Desenvolvedores...: Sergio Borges - sergio@rssolucoesweb.com.br
-->
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	nome 					= Trim(Request.Form("nome"))
	cod_modalidade			= Trim(Request.Form("cmbModalidade"))
	cod_categoria			= Trim(Request.Form("cmbCategoria"))
	cod_turno				= Trim(Request.Form("cmbTurno"))
	ano_letivo				= Trim(Request.Form("ano_letivo"))
	capacidade				= Trim(Request.Form("capacidade"))
	strSituacao				= Trim(Request.Form("cmbSituacao"))

	if acao="I" then
		
		strMensagem = "Registro salvo com sucesso..."
		
		existeAmesmaDescricao = "N"
		'REGRA PARA INCLUSAO
		sql = "SELECT nome" 
		sql = sql & " FROM ESP_TURMA"
		sql = sql & " WHERE nome = '" & nome & "'"
		sql = sql & " and ano_letivo = " & ano_letivo
		rs.open sql, cnn
		if RS.EOF then

			sql = "Insert Into ESP_TURMA(nome, cod_modalidade, cod_categoria, cod_turno, ano_letivo, capacidade, situacao)"
			sql = sql & " Values ("
			sql = sql & "'" & nome & "',"
			sql = sql & "" & cod_modalidade & ","
			sql = sql & "" & cod_categoria & ","
			sql = sql & "" & cod_turno & ","
			sql = sql & "" & ano_letivo & ","
			sql = sql & "" & capacidade & ","
			sql = sql & "'" & strSituacao & "')"
			cnn.execute sql
			GravarLog sql			

		else
			existeAmesmaDescricao = "S"
		end if
		rs.close
		
		if existeAmesmaDescricao = "S" then
			cnn.rollbackTrans
			%>
			<script>
				alert("ATENÇÃO: Existe a mesma turma cadastrada para esse ano letivo, verifique!");
				window.history.back();
			</script>
			<%
		end if
		
		

	elseif acao="A" then
		
		strMensagem = "Registro alterado com sucesso..."
		sql = "Update ESP_TURMA Set"
		sql = sql & " nome = '" & nome & "',"
		sql = sql & " cod_modalidade = " & cod_modalidade & ","
		sql = sql & " cod_categoria = " & cod_categoria & ","
		sql = sql & " cod_turno = " & cod_turno & ","
		sql = sql & " ano_letivo = " & ano_letivo & ","
		sql = sql & " capacidade = " & capacidade & ","
		sql = sql & " situacao = '" & strSituacao & "'"
		sql = sql & " where Cod_turma = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
	elseif acao="E" then
		
	
		strMensagem = "Registro excluído com sucesso..."
		sql = "Delete from ESP_TURMA "
		sql = sql & " where Cod_turma = " & intCodigo

		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='esp_turma.asp';
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
