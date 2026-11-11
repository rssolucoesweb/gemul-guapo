<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 29/08/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Situacao 
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "SELECT Max(Cod_ProjetoSociais) as MaiorCodigo" 
		sql = sql & " FROM SCA_PROJETOSOCIAIS"
		rs.open sql, cnn
		if not RS.EOF then
			if rs("MaiorCodigo") <> "" then
				intCodNovo = cstr(rs("MaiorCodigo")) + 1
				intCodigo = intCodNovo
			else
				intCodigo = 1	
			end if
		end if
		rs.close

		sql = "SELECT Cod_ProjetoSociais" 
		sql = sql & " FROM SCA_PROJETOSOCIAIS"
		sql = sql & " WHERE Cod_Empresa = " & intCodEmp
		sql = sql & " AND 	Desc_ProjetoSociais = '" & strDescricao & "'"
		rs.open sql, cnn
		if RS.EOF then

			sql = "Insert Into SCA_PROJETOSOCIAIS(COD_EMPRESA, Cod_ProjetoSociais, Desc_ProjetoSociais)"
			sql = sql & " Values ("
			sql = sql & "" & intCodEmp & ","
			sql = sql & "" & intCodigo & ","
			sql = sql & "'" & strDescricao & "')"
	
			cnn.execute sql
			GravarLog sql

		end if
		rs.close

	elseif acao="A" then
	
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update SCA_PROJETOSOCIAIS Set"
		sql = sql & " Desc_ProjetoSociais = '" & strDescricao & "'"
		sql = sql & " where Cod_ProjetoSociais = " & intCodigo
		sql = sql & " AND Cod_Empresa = " & intCodEmp
		
		cnn.execute sql
		GravarLog sql
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_PROJETOSOCIAIS "
		sql = sql & " where Cod_ProjetoSociais = " & intCodigo
		sql = sql & " AND Cod_Empresa = " & intCodEmp

		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='ProjetoSociais_cad.asp';
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