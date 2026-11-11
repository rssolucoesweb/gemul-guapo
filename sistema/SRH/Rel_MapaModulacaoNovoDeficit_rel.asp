<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = true

Response.AddHeader "Content-Type", "text/html; charset=utf-8"
Response.AddHeader "Pragma", "no-cache"
response.Charset="utf-8"

dim intPagina
nomeDocSalvo				= "relatorioModulacao"
strAno	 					= Trim(Request("txtAno"))
intSemestre 				= Trim(Request("cmbSemestre"))
stroptOpcao					= Trim(Request("optOpcao")) 
strFiltro					= Trim(Request("optFiltro")) 
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
	stroptOpcao = "4"
end if

if strFiltro = "P" then
	MsgCabecalho = MsgCabecalho & " - PERÍODO"
end if
if strFiltro = "C" then
	MsgCabecalho = MsgCabecalho & " - CONTRATUAL"
end if

if intSemestre = "3" then
   strMsgSemestre = "Anual"
else
   strMsgSemestre = intSemestre
end if   

strTituloRelatorio = "MAPA DE MODULAÇÃO - " & strAno & "/" & strMsgSemestre & MsgCabecalho

strExportarWord 	= paginaatual & "?exportar=w&txtAno=" & strAno  & "&cmbSemestre=" & intSemestre  & "&optOpcao=" & stroptOpcao & "&optFiltro=" & strFiltro
												 								 
strExportarExcel 	= paginaatual & "?exportar=e&txtAno=" & strAno  & "&cmbSemestre=" & intSemestre  & "&optOpcao=" & stroptOpcao & "&optFiltro=" & strFiltro

%>
<html>
<head>
<title><%=session("Titulo")%> - Grade Curricular</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%	if request("exportar") = "" then %>
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
<style type="text/css">
body,td,th {
	font-family: Tahoma;
}
</style>
<%end if%>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
if request("exportar") = "" then 
    %><!--#include file="../../includes/inc_Botoes_relatorio_word_excel.asp"--><%
end if
%>
<%	if request("exportar") = "" then %>
<!--#include file="../../includes/inc_aguarde.asp"-->
<%	end if %>

<br>
<%

	sub mostraCabecalho()
		if request("exportar") = "" then
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
<%end if%>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
        <tr height="28">
           <td align="center" class="celula" colspan="11" bgcolor="#F0F0F0"><strong><font size="+1">PROFESSORES</font></strong></td>
        </tr>
	  <tr bgcolor="#CCCCCC">
	    <td width="2%" rowspan="2" class="celula"><div align="center"><strong>Ord.</strong></div></td>
		<%if request("exportar") <> "" then%>
        	<td width="20%" rowspan="2"  class="celula"><div align="center"><strong>Unidade</strong></div></td>
        <%end if%>        
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
	
	sub mostraCabecalhoFunc()
		if request("exportar") = "" then
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
    <%end if%>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr>
	    <td height="36" colspan="9" align="center" class="celula"><strong><font size="3"><%=strEmpresaSelecionada%></font></strong></td>
      </tr>
		 <tr height="28">
            <td align="center" class="celula" colspan="9" bgcolor="#F0F0F0"><strong><font size="+1">FUNCIONÁRIOS</font></strong></td>
        </tr>
	  <tr bgcolor="#c0c0c0">
       <td width="2%" rowspan="2" class="celula"><div align="center"><strong>Ord.</strong></div></td>
		<%if request("exportar") <> "" then%>
        	<td width="20%" class="celula"><div align="center"><strong>Unidade</strong></div></td>
        <%end if%>
	    <td width="20%" class="celula"><div align="center"><strong>Curso</strong></div></td>
	    <td width="20%" height="49" class="celula"><div align="center"><strong>Função</strong></div></td>
	    <td width="7%" height="49" align="center" class="celula"><strong>Turno</strong></td>
	    <td width="13%" height="49" align="center" class="celula"><strong>Vagas<br>(Necess&aacute;ria)</strong></td>
	    <td width="13%" height="49" class="celula"><div align="center"><strong>Vagas <br>(Informada-SME)</strong></div></td>
	    <td width="13%" class="celula"><div align="center"><strong>Vagas Moduladas <br>(Informada-SME)</strong></div></td>
	    <td width="10%" class="celula"><div align="center"><strong>Saldo</strong></div></td>
      </tr>
	  
	<%
	end Sub

	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0
	if strFiltro = "" then strFiltro = "C" 
	
	sql = " execute [dbo].[SP_Rel_MapaModulacao_Professor] " & session("codGrupo") & "," & strAnoLetivo & "," & strSemestre & "," & stroptOpcao & ",'" & strFiltro & "'"
    'response.write sql
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof 
			cont = cont+1
			if unidade <> rs("unidade") and request("exportar") = "" then
			%>
			  <tr  height="28">
				<td height="35" colspan="11" align="center" bgcolor="#CCE6FF" class="celula"><strong><font size="3"><%=rs("unidade")%></font></strong></td>
			 </tr>
			 <%
			 end if
			 %>
			  <tr  height="28">
				<td class="celula"><div align="center"><%=cont%></div></td>
				<%if request("exportar") <> "" then%>
					<td align="left" class="celula"><%=rs("unidade")%>&nbsp;</td>
				<%end if%>
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

      <%
	mostraCabecalhoFunc
	sql = " execute [dbo].[SP_Rel_MapaModulacao_Funcionario] " & session("codGrupo") & "," & strAnoLetivo & "," & strSemestre & "," & stroptOpcao
    rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof 
				cont = cont+1
				if unidade <> rs("unidade") and request("exportar") = "" then
				%>
				  <tr  height="28">
				    <td height="35" colspan="11" align="center" bgcolor="#CCE6FF" class="celula"><strong><font size="3"><%=rs("unidade")%></font></strong></td>
	  			  </tr>
				<%
				 end if
				 %>
				  <tr height="28">
					<td align="left" class="celula"><%=cont%></td>
					<%if request("exportar") <> "" then%>
                        <td align="left" class="celula"><%=rs("unidade")%>&nbsp;</td>
                    <%end if%>        
					<td align="left" class="celula"><%=rs("curso")%>&nbsp;</td>
					<td align="left" class="celula"><%=rs("funcao")%>&nbsp;</td>
					<td align="left" class="celula"><%=rs("turno")%>&nbsp;</td>
					<td  class="celula" align="center"><%=rs("vagasliberadasdiretriz")%>&nbsp;</td>
					<td  class="celula" align="center"><%=rs("vagasliberadasdiretriz")%>&nbsp;</td>
					<td  class="celula" align="center"><%=rs("modulados")%>&nbsp;</td>
					<td  class="celula" align="center"><%=rs("vagasliberadasdiretriz")-rs("modulados")%>&nbsp;</td>
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
<%
	if request("exportar") = "w" then 
		Response.ContentType = "application/vnd.ms-word"
        Response.AddHeader "content-disposition","attachment;filename="&nomeDocSalvo&".doc"
	elseif request("exportar") = "e" then 
		Response.ContentType = "application/vnd.ms-excel"
        Response.AddHeader "content-disposition","attachment;filename="&nomeDocSalvo&".xls"
	end if
%>

<br>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
