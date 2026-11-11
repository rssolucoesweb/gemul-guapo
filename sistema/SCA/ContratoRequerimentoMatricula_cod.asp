<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/08/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Disciplina
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnnDocumento.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	intCodGrupo			= Session("CodGrupo")
    strTexto 			= Trim(Request.Form("txtTexto"))
	if acao="I" then
	
		strMensagem = "Registro Salvo com sucesso..."
	
		sql = "SELECT texto"
		sql = sql & " FROM SCA_CONTRATOREQUERIMENTO "
		sql = sql & " Where cod_empresa = " & Session("CodEmpresa")			
		rs.open sql, cnn
		if not RS.EOF then
			%>
			<script>
				alert("ATENÇÃO: Contrato Já Cadastrado... Verifique!");
				window.history.back();
			</script>
			<%
			response.end
		
		end if
		rs.close

		sql = "Insert Into SCA_CONTRATOREQUERIMENTO(Cod_Empresa, Cod_Grupo, Texto)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodGrupo & ","
		if strTexto <> "" then
			sql = sql & "'" & strTexto & "')"
		else
			sql = sql & " null) " 
		end if
		cnn.execute sql
		GravarLog sql


	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update SCA_CONTRATOREQUERIMENTO Set"
		sql = sql & " Texto = '" & strTexto & "'"
		sql = sql & " Where cod_empresa = " & Session("CodEmpresa")		
		cnn.execute sql
		GravarLog sql
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_CONTRATOREQUERIMENTO "
		sql = sql & " Where cod_empresa = " & Session("CodEmpresa")		
		cnn.execute sql
		GravarLog sql
	
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='ContratoRequerimentoMatricula_cad.asp';
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