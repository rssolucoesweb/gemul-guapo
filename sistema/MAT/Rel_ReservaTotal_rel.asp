<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 26/07/2012
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<style>
.celulaTotal
{ 
	FONT-SIZE: 14pt;
	border-top: 1px solid #FFFFFF; 
	border-left: 1px solid #FFFFFF; 
	border-bottom: 1px solid #000000; 
	border-right: 1px solid #000000;
}
</style>
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script></head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file=../../includes/inc_aguarde.asp-->
<br>
<%
	dim intPagina
	strCod_empresa 			= Session("CodEmpresa")
	intOrdenacao 			= request.Form("cmbOrdenacao")
	intCurso	 			= request.Form("cmbAgrupamento")
	strDataInicio = ""
	strDataFim = ""
	strTituloRelatorio  	= "Rela&ccedil;&atilde;o de Cadastro de Reservas da <br> Matrícula " & year(date)
	if intCurso <> "0" then
		sql = "select * from [dbo].[MAT_periodo_curso] where codigo = " & intCurso
		RS.OPEN SQL, CNN
		IF RS.EOF = FALSE THEN
			strDataInicio 	= formataDataBD(rs("dt_inicial"))
			strDataFim 		= formataDataBD(rs("dt_final"))
			strCurso 		= rs("curso")
			strTituloRelatorio  	= "Rela&ccedil;&atilde;o Totais de Cadastro de Reservas do <strong>" & strCurso & "</strong> <br> Matrícula " & year(date)
		END IF
		rs.close
	end if
	
	
	sub mostraCabecalhoLogo()
%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<%
	end Sub

	sub mostraCabecalhoTotal()
%>
	<table width="60%" border="0" align="center" cellpadding="0" cellspacing="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td height="31" colspan="2"  align="center" class="celulaTotal"><strong>RESUMO DAS RESERVAS POR AGRUPAMENTO</strong></td>
	  </tr>
      <%
      
      	sql = "SELECT periodo, count(*) as qtde "
		sql = sql & " FROM MAT_Reserva "
		sql = sql & " where Situacao = 'R'"
		sql = sql & " AND ISNULL(ATUALIZADO,'N') = 'N'"

			if intCurso <> "0" then
				sql = sql & " and periodo = '" & strCurso & "'"
			end if
	
		sql = sql & " group by periodo order by periodo	"
		
		rs.open sql, cnn
		if not rs.eof then 
			While not rs.eof
				%>
				<tr>
					<td width="57%" height="48" class="celulaTotal">&nbsp;<%=rs("periodo")%></td>
					<td width="43%" align="center" class="celulaTotal"><%=rs("qtde")%></td>
				</tr>
				<%
				total = total + rs("qtde")
				rs.movenext
			wend
		end if
		rs.close
	%>
        <tr bgcolor="#EEEEEE">
       		<td height="40" class="celulaTotal"><strong>&nbsp;TOTAL</strong></td>
       		<td height="40" align="center" class="celulaTotal"><strong><%=total%></strong></td>
        </tr>
      
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
%>
<%
	intPagina = 1
	intQtdeRegistroPorPagina = 1
	mostraCabecalhoLogo
	mostraCabecalhoTotal
%>
</table>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
