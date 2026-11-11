<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 29/08/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de FormaIngresso 
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 						= Trim(Request.QueryString("acao"))
	intCodEmp					= Session("CodEmpresa")
	intCodigo	 				= Trim(Request.Form("txtCodigo"))
	strDescricao 				= Trim(Request.Form("txtDescricao"))
	strFormaIngressoVinculoInep = Trim(Request.Form("cmbFormaIngressoVinculoInep"))
			
	if acao="I" then
	
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "SELECT Max(CODIGO) as MaiorCodigo" 
		sql = sql & " FROM SCA_FORMAINGRESSO"
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

		sql = "Insert Into SCA_FORMAINGRESSO(COD_EMPRESA, CODIGO, DESCRICAO, Cod_Campo_Inep )"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodigo & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "" & strFormaIngressoVinculoInep & ")"

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update SCA_FORMAINGRESSO Set"
		sql = sql & " DESCRICAO = '" & strDescricao & "',"
		sql = sql & " Cod_Campo_Inep = " & strFormaIngressoVinculoInep & ""
		sql = sql & " where CODIGO = " & intCodigo
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_FORMAINGRESSO "
		sql = sql & " where CODIGO = " & intCodigo
		
	end if
	
	cnn.execute sql
GravarLog sql
if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.navigate('FormaIngresso_cad.asp');
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