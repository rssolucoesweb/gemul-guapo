<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - Sergiob76@gmail.com
	::	Objetivo Pagina...: Cadastro de tipo avaliação
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 			= Trim(Request.QueryString("acao"))
	intCodEmp		= Session("CodEmpresa")
	intCodCurso		= Trim(Request("cmbCurso"))
	intCodigo 		= Trim(Request.Form("txtCodigo"))
	strDescricao 	= Trim(Request.Form("txtDescricao"))
	strSigla		= Trim(Request.Form("txtSigla"))
	intCodAvaliacaoAgrupamento		= Trim(Request.Form("cmbTipoAvaliacaoAgrupamento"))
	strPosicao		= Trim(Request.Form("cmbPosicao"))
	strFormula		= Trim(Request.Form("txtFormula"))
	strDigitar		= Trim(Request.Form("txtDigitar"))
	TipoBimestre		= Trim(Request.Form("cmbTipoBimestre"))
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "SELECT Max(codigo) as MaiorCodigo" 
		sql = sql & " FROM SCA_TIPO_AVALIACAO_Planilha"
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

		sql = "Insert Into SCA_TIPO_AVALIACAO_Planilha(Cod_Empresa, codigo, descricao, sigla, bimestre, posicao, formula, tipo_bimestre, digitar, cod_curso)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodigo & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "'" & strSigla & "',"
		sql = sql & "" & intCodAvaliacaoAgrupamento & ","
		sql = sql & "" & strPosicao & ","
		sql = sql & "'" & strFormula & "',"
		sql = sql & "" & TipoBimestre & ","
		sql = sql & "'" & strDigitar & "',"
		sql = sql & "" & intCodCurso & ")"

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SCA_TIPO_AVALIACAO_Planilha Set"
		sql = sql & " descricao = '" & strDescricao & "',"
		sql = sql & " sigla = '" & strSigla & "',"
		sql = sql & " posicao = " & strPosicao & ","
		sql = sql & " digitar = '" & strDigitar & "',"
		sql = sql & " Tipo_Bimestre = " & TipoBimestre & ","
		sql = sql & " cod_curso = '" & intCodCurso & "',"
		sql = sql & " formula = '" & strFormula & "',"
		sql = sql & " bimestre = " & intCodAvaliacaoAgrupamento & ""
		sql = sql & " where codigo = " & intCodigo
		sql = sql & " and   cod_empresa = " & intCodEmp
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete from SCA_TIPO_AVALIACAO_Planilha "
		sql = sql & " where codigo = " & intCodigo
		sql = sql & " and   cod_empresa = " & intCodEmp
		
	end if

	cnn.execute sql
	GravarLog sql

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='TipoAvaliacaoPlanilha_cad.asp?cmbCurso=<%=intCodCurso%>';
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