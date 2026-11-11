<!--#include file="../../../includes/inc_cnn.asp"-->
<!-- execucao -->   
<% 
 
Function RemoveAcentos(ByVal Texto)
	IF NOT ISNULL(Texto) THEN
		Dim ComAcentos
		Dim SemAcentos
		Dim Resultado
		Dim Cont
		'Conjunto de Caracteres com acentos
		ComAcentos = "¡Õ”⁄…ƒœ÷‹À¿Ã“Ÿ»√’¬Œ‘€ ·ÌÛ˙È‰Ôˆ¸Î‡ÏÚ˘Ë„ı‚ÓÙ˚Í«Á∫∞"
		'Conjunto de Caracteres sem acentos
		SemAcentos = "AIOUEAIOUEAIOUEAOAIOUEaioueaioueaioueaoaioueCc.."
		Cont = 0
		Resultado = Texto
		Do While Cont < Len(ComAcentos)
			Cont = Cont + 1
			Resultado = Replace(Resultado, Mid(ComAcentos, Cont, 1), Mid(SemAcentos, Cont, 1))
		Loop
		RemoveAcentos = Resultado
	END IF
End Function 


codRequisicao = request("id")

strMes1 = month(date)-1
strMes2 = month(date)-2
strAno1 = year(date)
strAno2 = year(date)

if month(date) = 1 then
	strMes1 = 12
	strMes2 = 11
	strAno1 = year(date)-1
	strAno2 = year(date)-1
end if
if month(date) = 2 then
	strMes1 = 1
	strMes2 = 12
	strAno1 = year(date)
	strAno2 = year(date)-1
end if
%>
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabela">
      <tr>
        <td width="26%" rowspan="3" align="center" class="celula"><STRONG>Material</STRONG></td>
        <td width="6%" rowspan="3" align="center" class="celula"><STRONG>Unidade</STRONG></td>
        <td width="19%" rowspan="3" align="center" class="celula"><STRONG>Grupo</STRONG></td>
        <td colspan="2" align="center" class="celula"><strong>Saldo </strong></td>
        <td colspan="4" align="center" class="celula"><STRONG>Quantidade</STRONG></td>
      </tr>
      <tr>
        <td width="8%" rowspan="2" align="center" class="celula"><strong>Real</strong></td>
        <td width="8%" rowspan="2" align="center" class="celula"><strong>Dispon&iacute;vel</strong></td>
        <td colspan="3" align="center" class="celula"><strong>Solicita&ccedil;&atilde;o</strong></td>
        <td width="9%" rowspan="2" align="center" class="celula"><strong>Autorizar</strong></td>
      </tr>
      <tr>
        <td width="10%" align="center" class="celula" bgcolor="#FFFFCC"><%=RemoveAcentos(ucase(monthname(strMes2)))%></td>
        <td width="10%" align="center" class="celula" bgcolor="#C1E0FF"><%=RemoveAcentos(ucase(monthname(strMes1)))%></td>
        <td width="10%" align="center" class="celula" bgcolor="#64FF64"><strong><%=RemoveAcentos(ucase(monthname(month(date))))%></strong></td>
      </tr>
<%
sql = "execute EST_ListaProdutosAutorizacao " & codRequisicao & "," & session("CodEmpresa")	
rsAux.open sql, cnn
if not rsAux.eof then
    while not rsAux.eof
      classCampo = "text"
      readOnly = ""
      if rsAux("quantidade_autorizada") = "0" then
        classCampo = "textDesabilitado"
        readOnly = "readonly"
      end if
      %>
      <tr>
        <td  class="celula"><%=RemoveAcentos(rsAux("produto"))%></td>
        <td class="celula"><%=RemoveAcentos(UCASE(rsAux("unidade")))%></td>
        <td class="celula"><%=RemoveAcentos(rsAux("grupo"))%></td>
        <td class="celula" align="center"><%=rsAux("QTD_ATUAL_ESTOQUE")%></td>
        <td class="celula" align="center"><%=rsAux("QTD_ATUAL_DISPONIVEL")%></td>
        <td class="celula" align="center"  bgcolor="#FFFFCC"><%=rsAux("quantidade_liberada_mes2")%></td>
        <td class="celula" align="center"  bgcolor="#C1E0FF"><%=rsAux("quantidade_liberada_mes1")%></td>
        <td class="celula" align="center"  bgcolor="#64FF64"><%=rsAux("quantidade")%></td>
        <td class="celula" align="center">
          <input <%=readonly%> name="txtQuantidadeAutorizada_<%=codRequisicao%>_<%=rsAux("codProduto")%>_<%=rsAux("codigo")%>" type="text" class="<%=classCampo%>" id="txtQuantidadeAutorizada_<%=codRequisicao%>_<%=rsAux("codProduto")%>_<%=rsAux("codigo")%>" size="7" maxlength="10" value="<%=rsAux("quantidade_autorizada")%>"  onKeyPress="return formataCampo(this,2,10)">
          <input type="hidden" name="txtQuantEstoqueDisp_<%=codRequisicao%>_<%=rsAux("codProduto")%>_<%=rsAux("codigo")%>" value="<%=rsAux("QTD_ATUAL_DISPONIVEL")%>" id="txtQuantEstoqueDisp_<%=codRequisicao%>_<%=rsAux("codProduto")%>_<%=rsAux("codigo")%>">
        </td>
      </tr>
       <%
      rsAux.movenext
    wend
end if
rsAux.close
  %>
</table>
<div align="center"><input <%=strDesabilitaLiberacao%> name="cmbAutorizar" type="button" class="botaoIncluir" value="Clique para Autorizar a Solicita√ß√£o" onClick="autorizar('<%=codRequisicao%>')"></div>
<script>
document.all["aguarde_<%=codRequisicao%>"].style.display="none";
</script>
		 
