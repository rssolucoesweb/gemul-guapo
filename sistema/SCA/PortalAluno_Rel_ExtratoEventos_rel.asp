<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 10/03/2008
	::	Desenvolvedores...: Roberto Barbosa - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Relatorio Extrato do Evento
-->
<html>
<head>
<title><%=session("Titulo")%> - Extrato de Notas e Faltas</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="../../includes/inc_verificaLoginAluno.asp"-->
<!--#include file="../../includes/inc_cnnGedu.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/aguarde.asp"-->
<br>
<%
	dim intPagina
	
	strCodAluno				= trim(Session("CodAluno"))
	strclasse               = "Celula"
	strSimouNao             = "N"
	
	if strCodAluno = "" then
		strCodAluno			=	Trim(Request.form("chkAluno"))
	end if
	
	strTituloRelatorio  	= "EXTRATOS DE ATIVIDADES COMPLEMENTARES <br>"
	
	if strCodAluno <> "" then   
		vetCodAluno = split(strCodAluno,",")			 
	end if
		
	
	sub mostraCabecalho()
	%>
	
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<!--#include file="../includes/inc_sqlDadosAlunoDiscriminado.asp"-->
	<table width="100%" border="0">
  	<tr>
    <td align="center">
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td width="7%" align="center" class="<%=strclasse%>"><strong>Ano/Sem</strong></td>
		<td width="65%" class="<%=strclasse%>"><strong>Evento Realizado </strong></td>
		<td width="11%" align="center" class="<%=strclasse%>"><strong>C.Horaria </strong></td>
		<td width="17%" align="center" class="<%=strclasse%>"><p><strong>Frequ&ecirc;ncia (C.H) </strong></p></td>
		</tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
%>
<%
	intPagina = 1
	
	for intContador = 0 to ubound(vetCodAluno)
	
	intCodAluno			= trim(vetCodAluno(intContador))
	mostraCabecalho
	
	cont = 0
	intTotalCargaHoraria = 0 
	intTotalFrequenciaCH = 0 
	
	sql = " Select EV.Ano_letivo, EV.Semestre, EV.Evento, EV.CargaHoraria, FR.FrequenciaCH, FR.Descricao_Evento  "
	sql = sql & " From SCA_SEMINARIO_EVENTO_FREQUENCIA FR "
	sql = sql & " inner join SCA_SEMINARIO_EVENTO EV on  EV.Codigo = FR.Cod_Seminario_Evento "
	sql = sql & " Where Cod_empresa = " & session("CodEmpresa")
	sql = sql & " And Cod_Aluno = " & intCodAluno
	sql = sql & " order by EV.Ano_letivo, EV.Semestre "
	rs.open sql, cnn
	if rs.eof = false then

	while not rs.eof
	
		intTotalCargaHoraria = intTotalCargaHoraria + rs("CargaHoraria")
		intTotalFrequenciaCH = intTotalFrequenciaCH + rs("FrequenciaCH")
	  %>
	  <tr>
	    <td class="<%=strclasse%>" align="center"><%=rs("Ano_letivo")%>/<%=rs("Semestre")%>&nbsp;</td>
	    <td class="<%=strclasse%>" align="left"><%=rs("Evento")%></td>
	    <td class="<%=strclasse%>" align="center"><%=rs("CargaHoraria")%></td>
	    <td align="center" class="<%=strclasse%>"><%=rs("FrequenciaCH")%></td>
	    </tr>
	  <% if strSimouNao = "S" and trim(rs("Descricao_Evento"))<>"" then %>	
	     <tr>
		   <td class="<%=strclasse%>" align="center">&nbsp;</td>
		   <td colspan="3" align="left" class="<%=strclasse%>">Atividade:&nbsp;<%=rs("Descricao_Evento")%> </td>
		   </tr>
	  <% end if	   
	  rs.movenext
	wend
	
			strAproveitamento  = (intTotalFrequenciaCH * 100)/intTotalCargaHoraria
			strNota = (strAproveitamento / 10)

		%>
		  <tr>
		    <td height="24" colspan="5" class="<%=strclasse%>" align="center">
			<table width="33%" border="0">
              <tr>
                <td width="62%">Carga Horaria de Eventos : </td>
                <td width="38%"><%=intTotalCargaHoraria%>h&nbsp;</td>
              </tr>
              <tr>
                <td>Carga Horaria Cumprida : </td>
                <td><%=intTotalFrequenciaCH%>h</td>
              </tr>
              <tr>
                <td>Aproveitamento : </td>
                <td><%=formatnumber(strAproveitamento,0)%>%</td>
              </tr>
            </table></td>
	    </tr>
		 <%
	else
		%>
		  <tr>
			<td colspan="5" class="<%=strclasse%>" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close
	
	intPagina = intPagina + 1
%>
</table>

<%if  ubound(vetCodAluno) then %>
<pre></pre>
<%end if %>
<%next
%>
	</td>
  </tr>
</table>

<script>
	aguarde.style.display="none";
</script>
</body>
</html>