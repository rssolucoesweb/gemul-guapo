<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/08/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Disciplina
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	
	intCodigo			= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strDescAbreviada	= Trim(Request.Form("txtDescAbreviada"))
	strDescHistorico	= Trim(Request.Form("txtDescHistorico"))
			
	if acao="I" then
	
		strMensagem = "Registro Salvo com sucesso..."
	
		sql = "SELECT Max(COD_Disciplina) as MaiorCodigo" 
		sql = sql & " FROM SCA_DISCIPLINA"
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

		sql = "Insert Into SCA_DISCIPLINA(Cod_Empresa, COD_Disciplina, DESC_Disciplina, Desc_Abreviada, Desc_Historico)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodigo & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "'" & strDescAbreviada & "',"
		sql = sql & "'" & strDescHistorico & "')"
		cnn.execute sql
		GravarLog sql


	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update SCA_DISCIPLINA Set"
		sql = sql & " DESC_Disciplina = '" & strDescricao & "',"
		sql = sql & " Desc_Abreviada = '" & strDescAbreviada & "',"
		sql = sql & " Desc_Historico = '" & strDescHistorico & "' "
		sql = sql & " where COD_Disciplina = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_DISCIPLINA "
		sql = sql & " where COD_Disciplina = " & intCodigo
		cnn.execute sql
		GravarLog sql
	
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Disciplina_cad.asp';
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