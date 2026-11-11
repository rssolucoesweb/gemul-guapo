<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Extrato de Notas
-->
<html>
<head>
<title><%=session("Titulo")%> - Alunos Por Turma</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%
	dim intPagina
	dim strDepartamento

	dataInicial				= Trim(Request.Form("txtDataInicial"))
	dataFinal				= Trim(Request.Form("txtDataFinal"))
	strCodAluno				= Trim(Request("txtCodAluno"))
	strMatricula 			= Trim(Request("txtMatricula"))
	
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")
	
	strTituloRelatorio  	= "OCORRÊNCIAS<br>		Período: " & formatadataAP(dataInicial) & " a " & formatadataAP(dataFinal)

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td width="8%" class="celula"><div align="center"><strong>Matr&iacute;cula</strong></div></td>
		<td width="30%" class="celula"><div align="center"><strong>Nome do Aluno</strong></div></td>
		<td width="20%" class="celula"><div align="center"><strong>Ocorr&ecirc;ncia</strong></div></td>
		<td width="15%" class="celula"><div align="center"><strong>Tipo</strong></div></td>
		<td width="15%" class="celula"><div align="center"><strong>Usu&aacute;rio inclus&atilde;o </strong></div></td>
	    <td width="25%" class="celula" align="center"><strong>Data</strong></td>
	  </tr>
	<%
	end Sub
	
	sub quebraDepartamento() 
	%>
	  <tr bgcolor="#E2E2E2">
	    <td colspan="6" class="celula"><%=strDepartamento%>&nbsp;</td>
      </tr>
	<%
	end Sub	
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0
	
	sql = "select a.matricula, a.nomealuno, d.descricao as departamento, o.ocorrencia, o.usuario_incl, o.dataocorrencia, TP.DESC_Tipo, DA.PARCELA, DA.ReferenciaMensal"
	sql = sql & " from sca_ocorrencia o"
	sql = sql & " left join seg_departamento d on d.codigo = o.cod_departamento and d.cod_empresa = o.cod_empresa"
	sql = sql & " left join sca_aluno a on a.codigo = o.cod_aluno and a.cod_empresa = o.cod_empresa"
	sql = sql & " LEFT JOIN SCF_DEBITOALUNO DA ON DA.CODIGO = O.COD_DEBITOALUNO AND O.COD_EMPRESA = DA.COD_EMPRESA"
	sql = sql & " LEFT JOIN SCF_TIPOPARCELA TP ON TP.COD_TIPO = DA.COD_TIPOPARCELA AND TP.COD_EMPRESA = DA.COD_EMPRESA"
	sql = sql & " where o.cod_empresa = " &  session("CodEmpresa")
	sql = sql & " and 	o.Ano_Letivo = " & strAnoLetivo
	sql = sql & " and 	o.Semestre = " & intSemestre
	sql = sql & " and 	o.dataocorrencia >='" & formatadataBD(dataInicial) & "'"
	sql = sql & " and 	o.dataocorrencia <='" & formatadataBD(dataFinal) & "'"
	if strCodAluno <> "" then
		sql = sql & " and a.codigo = " & strCodAluno
	end if
	sql = sql & " order by "
	sql = sql & " 	d.descricao, "
	sql = sql & " 	o.dataocorrencia"
	rs.open sql, cnn
	if not rs.eof then 
		controle = 0
		contPorDepto = 0
		While not rs.eof
			IF strDepto <> RS("departamento") THEN
				if controle = 1 then
					%>
					  <tr>
						<td colspan="6" class="celula">Quantidade de Alunos Por Departamento: <%=contPorDepto%></td>
					  </tr>
					 <%
					 contPorDepto = 0
				end if
				if controle = 1 then
					intPagina = intPagina + 1
					intQtdeRegistroPorPagina = 1
					fimTabela
					%>
					<pre></pre>				
					<%			
					mostraCabecalho
				end if
				strDepartamento =  "<strong>" & RS("departamento") & "</strong>"
				quebraDepartamento
			END IF
			controle = 1
			
			msnOcorrencia = ""
			if not isnull(RS("PARCELA")) then
				msnOcorrencia = zeroLeft(RS("PARCELA"),2) 
			end if
			if not isnull(RS("PARCELA")) then
				msnOcorrencia = msnOcorrencia & " - " & RS("ReferenciaMensal")
			end if
			%>
			<tr bgcolor="#FFFFCC"> 
			  <td class="celula" align="left"><%=rs("MATRICULA")%>&nbsp;</td>
			  <td class="celula" align="left"><%=rs("NOMEALUNO")%>&nbsp;</td>
			  <td class="celula"><%=RS("OCORRENCIA")%>&nbsp;<%=msnOcorrencia%></td>
			  <td class="celula"><%=RS("DESC_Tipo")%>&nbsp;</td>
			  <td class="celula"><%=RS("USUARIO_INCL")%>&nbsp;</td>
			  <td class="celula"><%=RS("DATAOCORRENCIA")%></td>
			</tr>
			<%			
			'quantidade de registros da página
			if intQtdeRegistroPorPagina = 50 then
				 intPagina = intPagina + 1
				 intQtdeRegistroPorPagina = 1
				 fimTabela
				%>
				<pre></pre>				
				<%			
				mostraCabecalho
			end if	
			cont = cont + 1
			contPorDepto = contPorDepto + 1
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			strDepto = RS("departamento") 
			rs.movenext
		wend
		%>
		  <tr>
			<td colspan="6" class="celula">Quantidade de Alunos Por Depto: <%=contPorDepto%></td>
		  </tr>
		  <tr>
			<td colspan="6" class="celula">Quantidade de Alunos: <%=cont%></td>
		  </tr>
		 <%
	else
		%>
		  <tr>
			<td colspan="6" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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
