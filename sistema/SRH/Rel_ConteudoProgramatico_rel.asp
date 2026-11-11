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
<title><%=session("Titulo")%> - Conteúdo Programático</title>
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
	dim strInfoTurma
	
	intAnoLetivo 				= request.Form("txtAno")
	intSemestre 				= request.Form("txtSemestre")
    intCodColaboradorProfessor 	= Trim(Request("cmbProfessor"))
	intCodProfessor 	        = Trim(Request("cmbProfessor"))
	if  Trim(Request("cmbTurma")) <> "" then
		intCodTurma 			= Trim(Request("cmbTurma"))
		intCodTurmaProfessor	= Trim(Request("cmbTurma"))
	else
		intCodTurma				= Trim(Request("cmbTurmaProfessor"))
		intCodTurmaProfessor	= Trim(Request("cmbTurmaProfessor"))
	end if
	
	if  Trim(Request("cmbDisciplinaTurma")) <> "" then
		intCodDisciplina			= Trim(Request("cmbDisciplinaTurma"))
		intCodDisciplinaTurma		= Trim(Request("cmbDisciplinaTurma"))
	else
		intCodDisciplina			 = Trim(Request("cmbDisciplinaDoProfessor"))
		intCodDisciplinaTurma		 = Trim(Request("cmbDisciplinaDoProfessor"))
	end if
	strDataInicial         		= Trim(Request("txtDataInicial"))
	strDataFinal            	= Trim(Request("txtDataFinal"))
	intCodEstagio     			= Trim(Request.Form("cmbEstagio"))
	strlpp 						= Trim(Request.Form("cmblpp"))
	strclasse               	= Trim(Request.Form("cmbTamanhoFonteArial"))

	strTituloRelatorio  	= "Conteúdo Programático - Período: " &  strDataInicial & " à " & strDataFinal 
	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <% if intCodDisciplina <> "0" then %>
	     <tr bgcolor="#CCCCCC">
	     	<td height="15" colspan="4" class="<%=strclasse%>"><strong>Disciplina: <%=rs("Desc_Disciplina")%></strong></td>
         </tr>
	  <% end if %>	 
	  <tr bgcolor="#CCCCCC">
	    <td width="10%" class="<%=strclasse%>"><div align="center"><strong>Turma</strong></div></td>
	    <% if intCodDisciplina = "0" then %>
	       <td width="22%" class="<%=strclasse%>"><div align="center"><strong>Disciplina</strong></div></td>
		<% end if %>   
	    <td width="22%" class="<%=strclasse%>"><div align="center"><strong>Data<span class="TextoForm">/Per&iacute;odo</span></strong></div></td>
	    <td width="68%" height="15" class="<%=strclasse%>"><div align="center"><strong>Conte&uacute;do</strong></div></td>
      </tr>
	  
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	cont = 0

	sql = "SELECT c.*, t.nometurma, t.turmaaluno, d.Desc_Disciplina,p.nome as COLABORADOR"
	sql = sql & " FROM SCA_Conteudo c"
	sql = sql & " inner join sca_turma t on t.cod_turma = c.cod_turma and t.cod_empresa = c.cod_empresa"
	sql = sql & " inner join sca_disciplina d on d.Cod_Disciplina = c.Cod_Disciplina and d.cod_empresa = c.cod_empresa"
	sql = sql & " left join 	SRH_COLABORADOR p on p.codigo = c.cod_colaborador "
	sql = sql & " where c.cod_empresa = " & Session("CodEmpresa")			
	sql = sql & " and c.anoletivo = " & intAnoLetivo		
	sql = sql & " and c.semestre in (" & intSemestre & ")"
	if intCodColaboradorProfessor <> "0" then
		sql = sql & " and c.cod_colaborador = " & intCodColaboradorProfessor
	end if
	if intCodTurma <> "0" then
		sql = sql & " and c.cod_turma = " & intCodTurma
	end if	
	if intCodDisciplina <> "0" then
       sql = sql & " and c.Cod_Disciplina = " & intCodDisciplina
	end if  
	sql = sql & " and c.Fechamento = 'S' "
    sql = sql & " and convert(datetime,convert(varchar, c.datainicial, 103),103) >=  convert(datetime, ' " & strDataInicial & "',103)"
    sql = sql & " and convert(datetime,convert(varchar, c.datainicial, 103),103) <=  convert(datetime, ' " & strDataFinal & "',103)"
	sql = sql & " Order by c.anoletivo, c.semestre, t.nometurma, d.Desc_Disciplina, c.datainicial desc "
	rs.open sql, cnn
	if not rs.eof then 
	    mostraCabecalho
		While not rs.eof 
			if isnull(rs("colaborador")) then
				strProfessor = "PROFESSOR(A) NÃO INFORMADO NO HORÁRIO DE AULA"
			else
				strProfessor = rs("colaborador")
			end if
			%>
			  <tr height="28">
			    <td align="left" class="<%=strclasse%>"><div align="center"><%=trim(rs("TurmaAluno"))%>&nbsp;&nbsp;<%=trim(rs("NomeTurma"))%></div></td>
				<% if intCodDisciplina = "0" then %>
			    	<td align="left" class="<%=strclasse%>"><%=rs("Desc_Disciplina")%></td>
				<% end if %>	
			    <td align="left" class="<%=strclasse%>"><div align="center"><%=trim(formatadataAP(rs("datainicial")))%>&nbsp;a&nbsp;<%=trim(formatadataAP(rs("datafinal")))%></div></td>
			    <td align="left" class="<%=strclasse%>"><%=rs("conteudo")%></td>
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
			cont = cont + 1
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			rs.movenext
		wend
		contPeriodo = contPeriodo + 1
	else
		%>
		  <tr>
			<td colspan="4" class="<%=strclasse%>" align="center"><br><br>
			  <font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close
%>
</table>
<br>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  
  <tr>
    <td colspan="2" align="left"><strong>&nbsp;&nbsp;&nbsp;&nbsp;<%=day(date)%> de <%=monthname(month(date))%> de <%=year(date)%>. </strong></td>
  </tr>
  <tr>
    <td height="21" colspan="2" align="center">&nbsp;</td>
  </tr>
  <tr>
    <td width="51%" align="center">______________________________________</td>
    <td width="49%" align="center">______________________________________</td>
  </tr>
  <tr>
    <td align="center" valign="top"><strong><%=strProfessor%></strong></td>
    <td align="center" valign="top">Coordenador(a)</td>
  </tr>
  <tr>
    <% if intCodEstagio = "0" then %>
    	<td align="center" valign="top">Professor(a)</td>
    <% else %>
    	<td align="center" valign="top">Preceptor</td>
    <% end if %>    
    <td align="center" valign="top">&nbsp;</td>
  </tr>
</table>

<script>
	document.getElementById("aguarde").style.display="none";
</script>
</body>
</html>
