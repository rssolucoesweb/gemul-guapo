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
	acao 			= Trim(Request.QueryString("acao"))
	intCodEmp		= Session("CodEmpresa")
	intCodigo 		= Trim(Request.Form("txtCodigo"))
	intCodCriterioAvaliacao		= Trim(Request("cmbCriterioAvaliacao"))
	strDescricao 	= Trim(Request.Form("txtDescricao"))
	strPosicao	 	= Trim(Request.Form("cmbPosicao"))
	strSigla		= Trim(Request.Form("txtSigla"))
	intCodTipoLancamento		= Trim(Request.Form("cmbTipoLancamento"))
	intCodCalculo				= Trim(Request("cmbCalculo"))
	
	strFormula		= Trim(Request.Form("txtFormula"))
	strDigitar		= Trim(Request.Form("txtDigitar"))
	usuario_incl	= session("usuarioWeb")
 	
	if acao="I" then
		
		existe = "N"
		sql = "select cod_criterio_avaliacao from SCA_CALCULO_AVALIACAO where cod_criterio_avaliacao = " & intCodCriterioAvaliacao & " and posicao=" & strPosicao
		rs.open sql, cnn
		if not rs.eof then
			existe = "S"
		end if
		rs.close
		if existe = "S" then
			cnn.rollbacktrans
			%>
			<script>
				alert("Atenção: Já existe o campo C<%=strPosicao%> cadastrado para esse critério de avaliação!");
				window.history.back();
			</script>
			<%
		end if
		
		strMensagem = "Registro Salvo com sucesso..."

		sql = "Insert Into SCA_CALCULO_AVALIACAO(cod_criterio_avaliacao, descricao, sigla, cod_calculo, cod_tipo_lancamento, posicao, formula, digitar, usuario_incl, data_hora_incl, usuario_altr, data_hora_altr)"
		sql = sql & " Values ("
		sql = sql & "" & intCodCriterioAvaliacao & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "'" & strSigla & "',"
		sql = sql & "" & intCodCalculo & ","
		sql = sql & "" & intCodTipoLancamento & ","
		sql = sql & "" & strPosicao & ","
		sql = sql & "'" & strFormula & "',"
		sql = sql & "'" & strDigitar & "',"
		sql = sql & "'" & usuario_incl & "',"
		sql = sql & "getdate(),"
		sql = sql & "'" & usuario_incl & "',"
		sql = sql & "getdate())"
		cnn.execute sql
		
	elseif acao="A" then
		
		
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update SCA_CALCULO_AVALIACAO Set"
		sql = sql & " descricao = '" & strDescricao & "',"
		sql = sql & " sigla = '" & strSigla & "',"
		sql = sql & " posicao = " & strPosicao & ","
		sql = sql & " digitar = '" & strDigitar & "',"
		sql = sql & " formula = '" & strFormula & "',"
		sql = sql & " cod_calculo = " & intCodCalculo & ","
		sql = sql & " cod_tipo_lancamento = " & intCodTipoLancamento & ","
		sql = sql & " usuario_altr = '" & usuario_incl & "',"
		sql = sql & " data_hora_altr = getdate() "
		sql = sql & " where codigo = " & intCodigo
		cnn.execute sql
		
		existe = "N"
		sql = "select isnull(count(*),0) as qtde from SCA_CALCULO_AVALIACAO where cod_criterio_avaliacao = " & intCodCriterioAvaliacao & " and posicao=" & strPosicao
		rs.open sql, cnn
		if not rs.eof then
			if cInt(rs("qtde"))>1 then
				existe = "S"
			end if
		end if
		rs.close
		if existe = "S" then
			cnn.rollbacktrans
			%>
			<script>
				alert("Atenção: Já existe o campo C<%=strPosicao%> cadastrado para esse critério de avaliação!");
				window.history.back();
			</script>
			<%
		end if
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_CALCULO_AVALIACAO "
		sql = sql & " where codigo = " & intCodigo
		cnn.execute sql
		
	end if
	
	
	GravarLog sql
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='sca_calculoAvaliacao.asp?cmbCriterioAvaliacao=<%=intCodCriterioAvaliacao%>';
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