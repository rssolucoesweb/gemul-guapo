<!--#include file="../../../includes/inc_verificaSession.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formatadata.asp"-->
<script>
	function editaFormula (tipoFormula,totalBimestres){
		var strFormula = "(";
		var divisor    = 0;
		var descricao;
		
		//Formula da Média Anual
		for (var i=1;i<=totalBimestres;i++){
			//peso
			for (var j=0;j<4;j++){
			
				if (tipoFormula=='N'){
					if (document.all["opt" + i][j].checked == true){
						if (strFormula != "("){
							 strFormula = strFormula + " + ";
						}
						if (tipoFormula=='N') {
							strFormula = strFormula + "(" + i + "Bim" + " x " + document.all["opt" + i][j].value + ")" ;
							document.all["txtHiddenPeso" + i + "Bim"].value = parseInt(document.all["opt" + i][j].value);
						}else{
							strFormula = strFormula + "(" + i + "EF" + " x " + document.all["opt" + i][j].value + ")" ;
							document.all["txtHiddenPeso" + i + "EF"].value = parseInt(document.all["opt" + i][j].value);
						}
					}
				}
			}
		}
		frm.txtFormula.value = strFormula + ") / " + totalBimestres;
	}
	
	function confirmaFormula(tipoFormula,totalBimestres){
		
		window.opener.frm.txtHiddenPeso1Bim.value = "";
		window.opener.frm.txtHiddenPeso2Bim.value = "";
		window.opener.frm.txtHiddenPeso3Bim.value = "";
		window.opener.frm.txtHiddenPeso4Bim.value = "";		
		window.opener.frm.txtHiddenPeso5Bim.value = "";		
		
		
		window.opener.frm.txtFMedia.value = frm.txtFormula.value;
		window.opener.frm.txtHiddenPeso1Bim.value = document.all["txtHiddenPeso1Bim"].value;
		window.opener.frm.txtHiddenPeso2Bim.value = document.all["txtHiddenPeso2Bim"].value;
		window.opener.frm.txtHiddenPeso3Bim.value = document.all["txtHiddenPeso3Bim"].value;
		window.opener.frm.txtHiddenPeso4Bim.value = document.all["txtHiddenPeso4Bim"].value;
		window.opener.frm.txtHiddenPeso5Bim.value = document.all["txtHiddenPeso5Bim"].value;

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
      <td bgcolor="#CCCCCC" class="celula"><strong>BIMESTRES</strong></td>
      <td width="200" align="center" bgcolor="#CCCCCC" class="celula"><strong>PESO</strong></td>
    </tr>
	<%	
	cont = 0
	
	sql = "SELECT distinct TA.bimestre"
	sql = sql & " FROM SCA_TIPO_AVALIACAO TA"
	sql = sql & " LEFT JOIN SCA_AVALIACAO A ON A.CODTIPOAVALIACAO = TA.CODIGO"
	sql = sql & " where TA.cod_empresa =" & Session("CodEmpresa")		
	sql = sql & " and A.CODCRITERIOAVALIACAO =" & codCriterio	
	sql = sql & " and TA.bimestre NOT IN (5,6)"
	rs.open sql, cnn, 3, 1
	if rs.eof = false then 
		totalBimestres = rs.recordCount
		while not rs.eof
			cont = cont + 1
			strDescricao = trim(rs("bimestre")) & "º Bimestre (" & trim(rs("bimestre")) & "Bim)"
			%>
			<tr height="30"> 
			  <td bgcolor="#CCCCCC" class="celula"><%=strDescricao%>
			  </td>
			  <td bgcolor="#CCCCCC" class="celula">
				  <table width="100%" border="0" cellpadding="0" cellspacing="0">
					  <tr> 
						<td class="celula"><input type="radio" onclick="return editaFormula('N','<%=totalBimestres%>')" name="opt<%=cont%>" value="1">1</td>
						<td class="celula"><input type="radio" onclick="return editaFormula('N','<%=totalBimestres%>')" name="opt<%=cont%>" value="2">2</td>
						<td class="celula"><input type="radio" onclick="return editaFormula('N','<%=totalBimestres%>')" name="opt<%=cont%>" value="3">3</td>
						<td class="celula"><input type="radio" onclick="return editaFormula('N','<%=totalBimestres%>')" name="opt<%=cont%>" value="4">4</td>
					  </tr>
				  </table>
			  </td>
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
    <tr align="center"> 
      <td height="30" colspan="2"><strong><font color="#666666"><a id="formula"></a>
        <input name="txtFormula" type="text" class="text" id="txtFormula" size="45" readonly="true">
		<input type="hidden" name="txtHiddenPeso1Bim">
		<input type="hidden" name="txtHiddenPeso2Bim">
		<input type="hidden" name="txtHiddenPeso3Bim">
		<input type="hidden" name="txtHiddenPeso4Bim">
		<input type="hidden" name="txtHiddenPeso5Bim">
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
        <input name="cmdRetornar" type="button" id="cmdRetornar" onClick="window.close()" value="Retornar" class="botao"> 
      </td>
    </tr>
  </table>
</form>