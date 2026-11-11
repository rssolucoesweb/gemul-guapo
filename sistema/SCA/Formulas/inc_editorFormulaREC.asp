<!--#include file="../../../includes/inc_verificaSession.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formatadata.asp"-->
<script>
	function editaFormula (tipoFormula,totalBimestres){
		var strFormula = "(Recuperação + ";
		var divisor    = 0;
		var descricao;
		
		//Formula da Média Anual
		for (var i=1;i<=totalBimestres;i++){
			//peso
			for (var j=0;j<4;j++){
			
				if (document.all["opt" + i][j].checked == true){
					if (strFormula != "(Recuperação + "){
						 strFormula = strFormula + " + ";
					}
					strFormula = strFormula + "(REC" + " x " + document.all["opt" + i][j].value + ")" ;
					document.all["txtHiddenPesoEF"].value = parseInt(document.all["opt" + i][j].value);
				}
			}
		}
		totalBimestres = 2;
		frm.txtFormula.value = strFormula + ") / " + totalBimestres;
	}
	
	function confirmaFormula(tipoFormula,totalBimestres){
		
		window.opener.frm.txtHiddenPeso5Bim.value = "";		
		window.opener.frm.txtFMediaREC.value = frm.txtFormula.value;
		window.opener.frm.txtCC.value = "NÃO";
		if (frm.cc.checked==true) window.opener.frm.txtCC.value = "SIM";
		
		window.opener.frm.txtHiddenPeso5Bim.value = document.all["txtHiddenPesoEF"].value;

	}

	function incluiConselho(valor){
		if (frm.cc.value == ""){
			frm.txtFormula.value = '(' + frm.txtFormula.value + ') + CC';
			frm.cc.value = "1";
		}
	}
	

	
function limpar(){
		//limpa os campos do formulário
		var form = window.document.forms[0]
		
		for (var i = 0; i < form.elements.length; i++) {

			if (form.elements[i].type == "radio"){ //option button
				form.elements[i].checked= false;			
			}
			
			if (form.elements[i].type == "text") //text box
				form.elements[i].value="";
		}

		frm.cc.value = "";
		return true;	
	}		
	
</script>
<%
tipoFormula = Trim(Request.QueryString("tipoFormula"))
codCriterio = Trim(Request.QueryString("codigo"))

totalBimestres = 4
%>
<form method="post" id="frm">
  <table width="100%" border="0" align="center" class="tabela" cellpadding="0" cellspacing="0">
    <tr bgcolor="#F7F7F7" height="30"> 
      <td bgcolor="#CCCCCC" class="celula"><strong>RECUPERA&Ccedil;&Atilde;O </strong></td>
      <td width="200" align="center" bgcolor="#CCCCCC" class="celula"><strong>PESO</strong></td>
    </tr>
	<%	
	cont = 0
	
	sql = "SELECT distinct TA.bimestre"
	sql = sql & " FROM SCA_TIPO_AVALIACAO TA"
	sql = sql & " LEFT JOIN SCA_AVALIACAO A ON A.CODTIPOAVALIACAO = TA.CODIGO"
	sql = sql & " where TA.cod_empresa =" & Session("CodEmpresa")		
	sql = sql & " and A.CODCRITERIOAVALIACAO =" & codCriterio	
	sql = sql & " and TA.bimestre = 5"
	rs.open sql, cnn, 3, 1
	if rs.eof = false then 
		totalBimestres = rs.recordCount
		while not rs.eof
			cont = cont + 1
			strDescricao = "Recuperação Final (REC)"
			%>
			<tr height="30"> 
			  <td bgcolor="#CCCCCC" class="celula"><%=strDescricao%></td>
			  <td bgcolor="#CCCCCC" class="celula">
				  <table width="100%" border="0" cellpadding="0" cellspacing="0">
					  <tr> 
						<td class="celula"><input type="radio" onclick="return editaFormula('N','<%=totalBimestres%>')" name="opt<%=cont%>" value="1">1</td>
						<td class="celula"><input type="radio" onclick="return editaFormula('N','<%=totalBimestres%>')" name="opt<%=cont%>" value="2">2</td>
						<td class="celula"><input type="radio" onclick="return editaFormula('N','<%=totalBimestres%>')" name="opt<%=cont%>" value="3">3</td>
						<td class="celula"><input type="radio" onclick="return editaFormula('N','<%=totalBimestres%>')" name="opt<%=cont%>" value="4">4</td>
					  </tr>
				  </table>			  </td>
			</tr>
			<%	
			rs.movenext
		wend
	end if
	rs.close
	%>
	<tr> 
      <td colspan="2"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr  bgcolor="#CCCCCC">
      <td height="30" colspan="2"><strong>Conselho de Classe</strong>
        <input type="radio" onclick="return incluiConselho()" name="cc" value="" />
</td>
    </tr>
    <tr align="center"> 
      <td height="30" colspan="2"><strong><font color="#666666"><a id="formula"></a>
        <input name="txtFormula" type="text" class="text" id="txtFormula" size="45" readonly="true">
		<input type="hidden" name="txtHiddenPesoEF">
        </font></strong></td>
    </tr>
    <tr> 
      <td colspan="2"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr> 
      <td colspan="2"><input name="cmdOK" type="button" id="cmdOK" onClick="confirmaFormula('<%=tipoFormula%>',<%=totalBimestres%>)" value="Confirmar" class="botao">
        &nbsp;
        <input name="cmdLimpar" type="button" id="cmdLimpar" value="Limpar" class="botao" onClick="limpar()">
        &nbsp;
        <input name="cmdRetornar" type="button" id="cmdRetornar" onClick="window.close()" value="Retornar" class="botao">      </td>
    </tr>
  </table>
</form>