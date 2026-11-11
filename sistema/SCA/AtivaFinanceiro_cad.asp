<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 27/11/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Criterio de Avaliação
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
<script type="text/JavaScript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
//-->
</script></head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif')">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<script>
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		frm.action="AtivaFinanceiro_cod.asp";
		frm.submit();
		return true;
 	}

</script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->

<%
strPaginaTitulo = "AtivaFinanceiro_cad.asp"
strExecutarSubmitSemestre	  = "S"
strExecutarFuncao = "S"
strExecutarSubmit = "S" 
strExecutarSubmitSiglaCursoPreMatricula = "S"

intSemestre 			= session("strSemestre")
strAnoLetivo            = session("strAnoLetivo")


strCodParcelaInicial	= Trim(Request.Form("cmbParcelaInicial"))
if strCodParcelaInicial = "" then strCodParcelaInicial = "0"
strAnoInicial				= Trim(Request.Form("cmbAnoInicial"))
if strAnoInicial = "" then
	strAnoInicial			= session("strAnoLetivo")
end if		
intCodTipoParcela				= Trim(Request.Form("cmbTipoParcela"))
intCodSituacaoAluno				= Trim(Request.Form("cmbSituacaoAluno"))
strSiglaCursoPreMatricula		= Trim(Request.Form("cmbSiglaCursoPreMatricula"))
  
if intCodSituacaoAluno = "" then intCodSituacaoAluno = "0"


strDesabilitaIncluir = "" 'Desabilita o botão Incluir'
strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar
strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
if Session("strChecarFinanceiro") <> "S" then 
	%>
	<script>
		alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, a ativação de alunos\n deverá ser realizada pelo controle de situação");
		window.history.back();
	</script>
	<%
end if	
%>
<form name="frm" method="post" id="frm" action="AtivaFinanceiro_cad.asp">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
<tr valign="top">
<td  align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
</tr>
<tr valign="top">
<td align="center">
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
<tr>
<td width="16%" class="texto1">Ano Letivo:</td>
<td width="84%" colspan="2"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
</tr>
<tr>
<td class="texto1">Semestre:</td>
<td colspan="2"><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
</tr>
<tr>
<td class="texto1">Parcela/Ano Matr&iacute;cula:</td>
<td colspan="2"><!--#include file="../includes/inc_cmbParcelaInicial.asp" -->/<!--#include file="../includes/inc_cmbAnoInicial.asp" --></td>
</tr>
<tr>
<td class="texto1">Tipo Parcela: </td>
<td colspan="2"><!--#include file="../includes/inc_cmdTipoParcela.asp" --></td>
</tr>
<tr>
  <td class="texto1">Situa&ccedil;&atilde;o para Ativa&ccedil;&atilde;o: </td>
  <td colspan="2" class="texto1"><!--#include file="../includes/inc_cmdSituacaoAlunoPre.asp"--></td>
</tr>
<tr>
  <td class="texto1">Curso:</td>
  <td colspan="2" class="texto1"><!--#include file="../includes/inc_cmdSiglaCursoPreMatricula.asp" --></td>
</tr>
<tr> 
  <td class="texto1">&nbsp;</td>
  <td colspan="2">&nbsp;</td>
</tr>
<tr> 
  <td colspan="3"><hr size="1" color="#CCCCCC"></td>
</tr>

<tr> 
  <td colspan="3"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
</tr>
<tr>
  <td colspan="3">&nbsp;</td>
</tr>
<tr>
<td colspan="3"><table class="tabela" width="98%" align="center" border="1" cellpadding="0" cellspacing="0">
<tr class="CabecalhoConsulta"> 
<td width="102" class="celula"><strong>Matr&iacute;cula</strong></td>
<td width="516" class="celula"><strong>Nome</strong></td>
<td width="62" class="celula"><strong>Parcela</strong></td>
<td width="40" class="celula"><strong>Ano</strong></td>
<td width="89" class="celula"><strong>Nova Turma </strong></td>
<td width="112" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
</tr>
<%
if strCodParcelaInicial <> "0" then			
	'seleciona os alunos nas condições de serem ativados
	sql = " SELECT A.CODIGO, A.MATRICULA, A.NOMEALUNO, T.NOMETURMA, DA.PARCELA, DA.ANO, SA.DESC_SITUACAOALUNO, DA.COD_PLANOPARCELA FROM SCF_DEBITOALUNO DA "
	sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = DA.COD_ALUNO AND A.Cod_Empresa = DA.Cod_Empresa"
	sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = DA.COD_TURMA AND T.COD_EMPRESA = DA.COD_EMPRESA "
	sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND SA.COD_EMPRESA=A.COD_EMPRESA "
	sql = sql & " WHERE DA.COD_EMPRESA = " & Session("CodEmpresa")
	sql = sql & " AND DA.PARCELA = " & strCodParcelaInicial
	sql = sql & " AND DA.ANO = " & strAnoInicial
	sql = sql & "AND SA.COD_SITUACAOALUNO = " & intCodSituacaoAluno
	if intCodTipoParcela <> "" then
	   sql = sql & " AND cod_tipoParcela = " & intCodTipoParcela
	end if  
	if strSiglaCursoPreMatricula <> "0" then
	   sql = sql & " AND SUBSTRING(T.NOMETURMA,1,2) = '" & trim(strSiglaCursoPreMatricula) & "'"
	end if  
	sql = sql & " AND cod_situacao_pagamento in (2,3,4)"
	sql = sql & " order by T.NOMETURMA, A.NOMEALUNO "
	rs.open sql, cnn
	cont = 0
	if rs.eof = false then
	
		intCodPlanoParcela      = rs("COD_PLANOPARCELA")
		
		sql = " SELECT CODIGO, MATRICULA, ANO, CODSEMESTRE FROM SCF_PLANOPARCELA "
		sql = sql & " WHERE COD_EMPRESA = " & Session("CodEmpresa")  
		sql = sql & " and codigo = " & intCodPlanoParcela
		rsaux.open sql, cnn,3,3
		if not rsaux.EOF then
			if trim(rsaux("ANO")) <> session("strAnoLetivo") and trim(rsaux("CODSEMESTRE")) <> session("strSemestre") then
			   %>
			   <script>
				   alert("ATENÇÃO! O ANO e o SEMESTRE da parcela Informada, não confere com o ANO e SEMESTRE letivo. Verifique!");
				   window.navigate('AtivaFinanceiro_cad.asp');
			   </script>
			   <%
			   response.End()
			end if
			if trim(rsaux("MATRICULA")) <> "S" then
			   %>
			   <script>
				   alert("ATENÇÃO! A Parcela informada não se refere a uma Matrícula. Verifique!");
				   window.navigate('AtivaFinanceiro_cad.asp');
			   </script>
			   <%
			   response.End()
			end if
		end if
		rsaux.close	
		'	
		while not rs.eof
			strCodAluno             = rs("CODIGO")
			intCodEmp               = Session("CodEmpresa") 
			strMatricula		    = rs("MATRICULA")
		
			%>
			<tr> 
			<td class="celula"><%=strMatricula%></td>
			<td class="celula"><%=rs("NOMEALUNO")%></td>
			<td class="celula"><%=rs("PARCELA")%></td>
			<td class="celula"><%=rs("ANO")%></td>
			<td class="celula"><%=rs("NOMETURMA")%></td>		
			<td class="celula"><%=rs("DESC_SITUACAOALUNO")%></td>
			</tr>
			<%
			cont = cont + 1
			rs.movenext
		wend%>
		<tr >
		<td colspan="6" class="celula">&nbsp;&nbsp;Total de Registros para Ativa&ccedil;&atilde;o: <%=cont%></td>
		</tr>
		<%
	else
		%>
		 <tr> 
		 <td colspan="8" align="center" class="celula"><%=session("strMensagemNaoEncontrado")%></td>
		 </tr>
		 <%
	end if
	rs.close
end if	
%>
</table>
<br><br></td>
</tr>
</table>
</td>
</tr>
 </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>