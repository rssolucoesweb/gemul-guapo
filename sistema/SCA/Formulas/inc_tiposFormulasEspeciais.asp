<!--#include file="../../../includes/inc_cnn.asp"-->
<script>
	function selecionaFormula(formula){

		window.opener.frm.txtFormulaEspecial.value=formula;
		
	}
</script>
<%
sql="select arq_formula_especial from ave_sistematica_avaliacao"
sql=sql & " where codigo_sia_unid_ensino=" & session("strCodigoSia")
sql=sql & " and ano_letivo=" & session("strAnoLetivo")
sql=sql & " and codigo_ape_composicao_ensino=" & intCodComp 
rs.open sql, cnn
if rs.eof = false then

	if isnull(rs("arq_formula_especial")) = false then
		formula = trim(rs("arq_formula_especial"))
	else
		formula = ""
	end if
	
else

	formula = ""

end if
rs.close
%>
<form id="frm" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formulario">
  <tr>
    <td>
			<br>
			<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
          <tr class="CabecalhoConsulta"> 
            <td width="5%" class="celula">&nbsp;</td>
            <td width="95%" class="celula">Descri&ccedil;&atilde;o da F&oacute;rmula</td>
            <td width="20" class="celula"><A href="#"><img src="../../imagens/icone_x.gif" onClick="window.close()"></A></td>
          </tr>
          <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
            <td class="celula"><input type="radio" name="optTipoFormula" value="inc_escolaMilitar.asp" <%if ucase(formula) = ucase("inc_escolaMilitar.asp") then response.write "checked"%> onClick="return selecionaFormula(this.value)"></td>
            <td colspan="2" class="celula">F&oacute;rmula do Col&eacute;gio Militar</td>
          </tr>
          <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
            <td class="celula"><input name="optTipoFormula" type="radio" value="" <%if ucase(formula) = "" then response.write "checked"%> onClick="return selecionaFormula(this.value)"></td>
            <td colspan="2" class="celula"><%=session("strMensagemNaoEncontrado")%></td>
          </tr>
        </table>
		
		</td>
  </tr>
</table>
<br>
  <center><input name="cmdRetornar" type="button" id="cmdRetornar" onClick="window.close()" value="Retornar" class="botao"></center>
</form>