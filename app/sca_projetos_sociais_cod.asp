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
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	strSituacao				= Trim(Request.Form("cmbSituacao"))
	if strSituacao = "" or strSituacao = "0" then strSituacao = "A"

	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		existeAmesmaDescricao = "N"
		'REGRA PARA INCLUSAO
		sql = "SELECT Desc_ProjetoSociais" 
		sql = sql & " FROM SCA_PROJETOSOCIAIS"
		sql = sql & " WHERE COD_EMPRESA = " & intCodEmp
		sql = sql & " and Desc_ProjetoSociais = '" & strDescricao & "'"
		rs.open sql, cnn
		if RS.EOF then
			sql = "SELECT Max(Cod_ProjetoSociais) as MaiorCodigo" 
			sql = sql & " FROM SCA_PROJETOSOCIAIS"
			rs1.open sql, cnn
			if not rs1.EOF then
				if rs1("MaiorCodigo") <> "" then
					intCodNovo = cstr(rs1("MaiorCodigo")) + 1
					intCodigo = intCodNovo
				else
					intCodigo = 1	
				end if
			end if
			rs1.close
		
			sql = "Insert Into SCA_PROJETOSOCIAIS(Cod_ProjetoSociais, Desc_ProjetoSociais, situacao)"
			sql = sql & " Values ("
			sql = sql & "" & intCodigo & ","
			sql = sql & "'" & strDescricao & "',"
			sql = sql & "'A')"
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
				alert("ATENÇÃO: Existe o mesmo projeto cadastrado, verifique!");
				window.history.back();
			</script>
			<%
		end if
		
		

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update SCA_PROJETOSOCIAIS Set"
		sql = sql & " Desc_ProjetoSociais = '" & strDescricao & "',"
		sql = sql & " situacao = '" & strSituacao & "'"
		sql = sql & " where Cod_ProjetoSociais = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
	elseif acao="E" then
		
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_PROJETOSOCIAIS "
		sql = sql & " where Cod_ProjetoSociais = " & intCodigo

		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='sca_projetos_sociais.asp';
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