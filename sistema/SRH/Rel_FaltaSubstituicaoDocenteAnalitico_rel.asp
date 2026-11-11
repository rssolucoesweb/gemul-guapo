<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
-->
<html>
<head>
<title><%=session("Titulo")%> - Alunos</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script></head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%

	dim intPagina
	
	strDataI				= request.Form("txtDataI")
	strDataF				= request.Form("txtDataF")
	intCodProfessor	        = Trim(Request("cmbProfessor"))
	strlpp 					= Trim(Request.Form("cmblpp"))
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))
	strClassificacao		= request.Form("cmbClassificacao")

    strTituloRelatorio  	= "Relatório Analítico de Faltas e Substituições"

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
	    <td colspan="14" class="<%=strclasse%>"><div align="center"><strong>Faltas no Per&iacute;odo: <%=strDataI%>a<%=strDataF%> </strong></div></td>
      </tr>
	  <tr bgcolor="#CCCCCC">
		<td width="3%" height="39" class="<%=strclasse%>"><div align="left"><strong>Data</strong></div></td>
		<td width="9%" class="<%=strclasse%>"><div align="left"><strong>Categoria</strong></div></td>
		<td width="15%" class="<%=strclasse%>">		  <p align="left"><strong>Colaborador </strong><strong>Titular </strong></p></td>
		<td width="4%" class="<%=strclasse%>"><div align="left"><strong>Faltas </strong></div></td>
		<td width="4%" class="<%=strclasse%>"><div align="left"><strong>Turma</strong></div></td>
		<td width="13%" class="<%=strclasse%>"><div align="left"><strong>Disciplina</strong></div></td>
		<td width="13%" class="<%=strclasse%>"><div align="left"><strong>Justificativa</strong></div></td>
		<td width="7%" class="<%=strclasse%>"><div align="left"><strong>Colaborador Substituto </strong></div></td>
		<td width="7%" class="<%=strclasse%>"><div align="left"><strong>Aulas Substitu&iacute;das</strong></div></td>
	    <td width="25%" class="<%=strclasse%>"><div align="left"><strong>Conte&uacute;do Ministrado </strong></div></td>
	    <td width="7%" class="<%=strclasse%>"><div align="left"><strong>Situacao </strong></div></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
	intPagina = 1
	cont = 0
	
	sql = "select CF.ANO_LETIVO, CF.SEMESTRE_LETIVO, CF.DATALANCAMENTO, CF.TIPO_COLABORADOR, C.NOME AS TITULAR, CF.NUMERO_FALTA, T.NOMETURMA, D.DESC_DISCIPLINA, "
	sql = sql & " CF.JUSTIFICATIVA, CS.NOME AS SUSBTITUTO, CF.NUMERO_AULA, CF.CONTEUDO_SUBSTITUICAO, CF.SITUACAO AS STATUS "
	sql = sql & " from SRH_COLABORADOR_FREQUENCIA CF "
	sql = sql & " LEFT JOIN SCA_TURMA T ON T.COD_EMPRESA=CF.COD_EMPRESA AND T.COD_TURMA=CF.COD_TURMA "
	sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.CODIGO = CF.COD_COLABORADOR "
	sql = sql & " LEFT JOIN SCA_DISCIPLINA D ON D.COD_EMPRESA = CF.COD_EMPRESA AND D.COD_DISCIPLINA = CF.COD_DISCIPLINA " 
	sql = sql & " LEFT  JOIN SRH_COLABORADOR CS ON CS.CODIGO = CF.COD_COLABORADORSUBSTITUTO "
	sql = sql & " WHERE CF.COD_EMPRESA = " & session("CodEmpresa")
	if intCodProfessor <> "" and intCodProfessor <> "0" then 
	   sql = sql & " AND CF.COD_COLABORADOR = " & intCodProfessor
	end if
    if Session("NivelPermissao") <> "A" then
	   sql = sql & " AND CF.FECHAMENTO = 'S' "  ' se o movimento estiver fechado
	end if   
    sql = sql & " and convert(datetime,convert(varchar, CF.DATALANCAMENTO, 103),103) >=  convert(datetime, '" & strDataI & "',103)"
    sql = sql & " and convert(datetime,convert(varchar, CF.DATALANCAMENTO, 103),103) <=  convert(datetime, '" & strDataF & "',103)"
	'ordem de classificação do relatorio
	if strClassificacao = "D" then
	 	sql = sql & " Order By CF.DATALANCAMENTO "
	elseif strClassificacao = "C" then
	 	sql = sql & " Order By TITULAR, CF.DATALANCAMENTO "
	elseif strClassificacao = "T" then
	 	sql = sql & " Order By T.NOMETURMA"
	elseif strClassificacao = "S" then
	 	sql = sql & " Order By CS.NOME"
	end if
    rs.open sql, cnn
	if not rs.eof then 
	   
	   mostraCabecalho
	   
	   While not rs.eof
	   
	   	  if trim(rs("TIPO_COLABORADOR")) = "P" then
		      strTipoColaborador = "Professor"
		  elseif  trim(rs("TIPO_COLABORADOR")) = "F" then
		      strTipoColaborador = "Funcionário"
		  end if	
  	   	  if trim(rs("STATUS")) = "S" then
		      strSituacao = "ABONO"
		  else
		      strSituacao = "-----"
		  end if	  
  
	   
	      %>
		  <tr>
		  <td class="<%=strclasse%>" align="left"><div align="center">&nbsp;<%=rs("DATALANCAMENTO")%></div></td>
		  <td class="<%=strclasse%>" align="left"><div align="center">&nbsp;<%=strTipoColaborador%></div></td>
	  	  <td align="center" class="<%=strclasse%>"><div align="left">&nbsp;<%=rs("TITULAR")%></div></td>
		  <td align="center" class="<%=strclasse%>">&nbsp;<%=rs("NUMERO_FALTA")%></td>
		  <td class="<%=strclasse%>" align="center"><%=rs("NOMETURMA")%>&nbsp;</td>
		  <td class="<%=strclasse%>" align="center"><div align="left">&nbsp;<%=rs("DESC_DISCIPLINA")%></div></td>
		  <td align="center" class="<%=strclasse%>"><div align="left">&nbsp;<%=rs("JUSTIFICATIVA")%></div></td>
		  <td align="center" class="<%=strclasse%>"><div align="left">&nbsp;<%=rs("SUSBTITUTO")%></div></td>
		  <td align="center" class="<%=strclasse%>">&nbsp;<%=rs("NUMERO_AULA")%></td>
		  <td align="center" class="<%=strclasse%>"><div align="left">&nbsp;<%=rs("CONTEUDO_SUBSTITUICAO")%></div></td>
 	      <td align="center" class="<%=strclasse%>"><div align="center">&nbsp;<%=strSituacao%>&nbsp;</div></td></tr>
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
		  cont = cont + 1
		  intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
		  rs.movenext
	   wend
	   %>
	   <tr>
	   <td colspan="14" class="<%=strclasse%>">Quantidade de Lan&ccedil;amento no Per&iacute;do: <%=cont%></td>
	   </tr>
	   <%
	else
		%>
		  <tr>
			<td height="62" colspan="14" align="center" class="<%=strclasse%>"><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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
