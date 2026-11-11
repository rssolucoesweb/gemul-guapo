<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
SESSION.Timeout = 1200
Server.ScriptTimeout = 1200
%>
<html>
<head>
<title>GEMUL - situação academica</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<script src="js/js_funcoes_gerais.js"></script>
<script src="js/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->
<!--#include file="includes/inc_aguarde.asp"-->
<br>
<%
	dim intPagina
	
	strDataI				= formatadataAP(request.Form("txtDataI"))
	strDataF				= formatadataAP(request.Form("txtDataF"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodSituacaoAluno		= Trim(Request.Form("cmbSituacaoAluno"))
	strlpp 					= Trim(Request.Form("cmblpp"))
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))
	strOpcaoRelatorio		= request.Form("optOpcao")
	strTipoRelatorio		= request.Form("cmbTipoRelatorio")

 	sub mostraCabecalho()
  	    strTituloRelatorio  	= "Controle de Situação Acadêmica - Analítico "
	    %>
	    <!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
	    <br>
	    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	    <tr bgcolor="#CCCCCC">
	    <td colspan="8" class="<%=strclasse%>"><div align="center"><strong>Per&iacute;odo de : <%=strDataI%>&nbsp;a&nbsp;<%=strDataF%> </strong></div></td>
        </tr>
	    <tr bgcolor="#CCCCCC">
		<td width="3%" height="19" class="<%=strclasse%>"><div align="left"><strong>Ord.</strong></div></td>
		<td width="7%" class="<%=strclasse%>"><strong>Matr&iacute;cula</strong></td>
		<td width="74%" class="<%=strclasse%>"><p align="left"><strong> Nome do Aluno </strong><strong></strong></p></td>
		<td width="10%" class="<%=strclasse%>"><strong>Data/Situa&ccedil;&atilde;o</strong></td>
	    <td width="6%" class="<%=strclasse%>"><strong>Situa&ccedil;&atilde;o</strong></td>
	    </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
	

 	intPagina = 1
	cont = 0
	
	sql = "SELECT A.MATRICULA, A.NOMEALUNO, S.DESC_SITUACAOALUNO, MAX(CS.DATA_SITUACAO) AS DATASITUACAO "
	sql = sql & " FROM SCA_CONTROLE_SITUACAO_ALUNO CS "
	sql = sql & " INNER JOIN SCA_SITUACAOALUNO S ON S.COD_SITUACAOALUNO = CS.COD_SITUACAOALUNO "
	sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = CS.COD_ALUNO"
	sql = sql & " WHERE CS.cod_empresa = " & session("CodEmpresa")
	if intCodSituacaoAluno <> "0" and intCodSituacaoAluno <> "" then
    	sql = sql & " AND S.COD_SITUACAOALUNO = " & intCodSituacaoAluno
	end if	
	sql = sql & " and convert(datetime,convert(varchar, CS.DATA_SITUACAO, 103),103) >=  convert(datetime, '" & strDataI & "',103) "
	sql = sql & " and convert(datetime,convert(varchar, CS.DATA_SITUACAO, 103),103) <=  convert(datetime, '" & strDataF & "',103) "
    sql = sql & " GROUP BY A.MATRICULA, A.NOMEALUNO, S.DESC_SITUACAOALUNO "
	sql = sql & " ORDER BY A.NOMEALUNO, S.DESC_SITUACAOALUNO"
	rs.open sql, cnn
	if not rs.eof then 
	   
	   mostraCabecalho
	   
	   While not rs.eof
          cont = cont + 1
	      %>
		  <tr>
		  <td class="<%=strclasse%>" align="left"><div align="center">&nbsp;<%=cont%></div></td>
		  <td align="left" class="<%=strclasse%>"><div align="center">&nbsp;<%=rs("MATRICULA")%></div></td>
	  	  <td align="center" class="<%=strclasse%>"><div align="left">&nbsp;<%=rs("NOMEALUNO")%></div></td>
		  <td align="center" class="<%=strclasse%>"><%=formatadataAP(rs("DATASITUACAO"))%></td>
		  <td align="center" class="<%=strclasse%>"><%=rs("DESC_SITUACAOALUNO")%></td>
		  </tr>
		  <%
	 	  'quantidade de registros da página
		  if int(intQtdeRegistroPorPagina) = int(strlpp) - 1 then
			 intPagina = intPagina + 1
			 intQtdeRegistroPorPagina = 1
			 fimTabela
			 %>
			 <pre></pre>				
		 	 <%			
			 mostraCabecalho
	 	  end if	
		  intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
		  rs.movenext
	   wend
	   %>
	   
		<tr>
	   <td colspan="8" class="<%=strclasse%>">Quantidade de Alunos: <%=cont%></td>
	   </tr>
	   <%
	else
		%>
		   <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
		   <tr>
			<td height="62" colspan="8" align="center" class="<%=strclasse%>"><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close
%>
</table>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
