<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<%
Response.AddHeader "Content-Type", "text/html; charset=utf-8"
Response.AddHeader "Pragma", "no-cache"
response.Charset="utf-8"
%>
<html>
<head>
<title><%=session("Titulo")%> - Grade Curricular</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
<style type="text/css">
body,td,th {
	font-family: Tahoma;
}
</style>
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
	
	strAno	 					= Trim(Request("txtAno"))
	intSemestre 				= Trim(Request("cmbSemestre"))
	stroptOpcao					= Trim(Request.Form("optOpcao")) 
	strAnoLetivo 				= session("strAnoLetivo")
	strSemestre 				= session("strSemestre")
	
	MsgCabecalho = ""
	if stroptOpcao = "0" then
		MsgCabecalho = "<br>DEFICIT"
	elseif stroptOpcao = "1" then
		MsgCabecalho = "<br>EXCESSO DE MODULA&Ccedil;&Atilde;0"
	elseif stroptOpcao = "2" then
		MsgCabecalho = "<br>MODULA&Ccedil;&Atilde;0 FECHADA"
	elseif stroptOpcao = "3" then
		MsgCabecalho = "<br>TODAS AS SITUA&Ccedil;&Otilde;ES"
	else
		MsgCabecalho = "<br>TODAS AS SITUA&Ccedil;&Otilde;ES"
	end if
	
	if intSemestre = "3" then
	   strMsgSemestre = "Anual"
	else
	   strMsgSemestre = intSemestre
	end if   
	
	strTituloRelatorio = "MAPA DE MODULAÇÃO - " & strAno & "/" & strMsgSemestre & MsgCabecalho
	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
        <tr height="28">
           <td align="center" class="celula" colspan="11" bgcolor="#F0F0F0"><strong><font size="+1">PROFESSORES</font></strong></td>
        </tr>
	  <tr bgcolor="#CCCCCC">
	    <td width="2%" rowspan="2" class="celula"><div align="center"><strong>Ord.</strong></div></td>
	    <td width="23%" rowspan="2" class="celula"><div align="center"><strong>Curso</strong></div></td>
	    <td width="6%" rowspan="2" class="celula"><div align="center"><strong>Per&iacute;odo</strong></div></td>
	    <td width="7%" height="76" rowspan="2" align="center" class="celula"><strong>Turno</strong></td>
	    <td width="21%" height="76" rowspan="2" class="celula"><div align="center"><strong>Fun&ccedil;&atilde;o</strong></div></td>
	    <td width="6%" height="76" rowspan="2" align="center" class="celula"><strong>Qtde. de Turmas</strong></td>
	    <td width="8%" height="76" rowspan="2" align="center" class="celula"><strong>Vagas<br>
        (Necess&aacute;ria)</strong></td>
        <td width="7%" height="76" rowspan="2" class="celula"><div align="center"><strong>Aulas<br>(Necess&aacute;ria) </strong></div></td>
	    <td colspan="2" class="celula"><div align="center"><strong>Vagas/Aulas Moduladas <br>
	    </strong></div></td>
	    <td width="4%" rowspan="2" class="celula"><div align="center"><strong>Saldo</strong></div></td>
      </tr>
	  <tr bgcolor="#CCCCCC">
	    <td width="7%" class="celula"><div align="center"><strong>Contratual</strong></div></td>
        <td width="7%" class="celula"><div align="center"><strong>Per&iacute;odo</strong></div></td>
	  </tr>
	  
	<%
	end Sub

	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0
	
	sql = " execute [dbo].[SP_Rel_MapaModulacaoNovo] " & session("codGrupo") & "," & strAnoLetivo & "," & strSemestre & "," & stroptOpcao
	'RESPONSE.WRITE SQL
    rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof 
				cont = cont+1
				if unidade <> rs("unidade") then
				%>
				  <tr  height="28">
				    <td height="35" colspan="11" align="center" bgcolor="#CCE6FF" class="celula"><strong><font size="3"><%=rs("unidade")%></font></strong></td>
	  </tr>
                 <%
				 end if
				 %>
				  <tr  height="28">
				    <td class="celula"><div align="center"><%=cont%></div></td>
					<td align="left" class="celula"><%=rs("curso")%>&nbsp;</td>
					<td align="center" class="celula" ><%=rs("periodo")%>&nbsp;</td>
					<td align="left" class="celula"><%=rs("turno")%>&nbsp;</td>
					<td align="left" class="celula"><%=rs("funcao")%>&nbsp;</td>
					<td  class="celula" align="center"><%=rs("qtde_turmas")%>&nbsp;</td>
					<td  class="celula" align="center"><%=rs("vagas_necessarias")%>&nbsp;</td>
					<td  class="celula" align="center"><%=rs("aulas_necessarias")%>&nbsp;</td>
					<td  class="celula" align="center"><%=rs("modulado_contratual")%>&nbsp;</td>
					<td  class="celula" align="center"><%=rs("modulado_periodo")%>&nbsp;</td>
					<td  class="celula" align="center"><%=rs("saldo")%>&nbsp;</td>
				</tr>
		<%
			unidade = rs("unidade")
		rs.movenext
		wend
	else
		%>
		  <tr>
			<td height="18" colspan="11" class="celula" align="center"><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close
%>
</table>

<br>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
