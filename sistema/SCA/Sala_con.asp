<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/08/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta Disciplina
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
<script type="text/JavaScript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
//-->
</script>
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>
<script>
	function resultadoConsulta(){
		
		var frm = document.getElementById("frm");
		var form = window.document.forms[0];
		var intContMarcado=0;
		var intCodSelecionados='';
		var intNomeSelecionados='';
		
		//*****verifica se um aluno foi selecionado
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "checkbox"){
				//verifica se o checkbox está marcado
				if (form.elements[i].checked){
					intContMarcado = intContMarcado + 1;
					if (intContMarcado == 1){
						intCodSelecionados = form.elements[i].value;
						intNomeSelecionados = document.all('txtDescDisciplina'+form.elements[i].value).value;
					}else{
						intCodSelecionados = intCodSelecionados + ',' + form.elements[i].value;
						intNomeSelecionados = intNomeSelecionados + ' | ' + document.all('txtDescDisciplina'+form.elements[i].value).value;
					}
				}
			}
		}

		if (intContMarcado==0){
			alert("Selecione uma Disciplina!");
			return false;
		}
		
		window.opener.document.getElementById('txtCodDisciplina').value = intCodSelecionados;
		window.opener.document.getElementById('txtDescDisciplina').value =  intNomeSelecionados; 
		window.opener.document.getElementById('frm').submit();
		window.close();
		
	}	
</script>
<%
	intCodGrade				= Trim(Request("CodGrade"))
	strDescDisciplina		= Trim(Request("txtDescDisciplina"))
	strMostraBotaoVincular	= "S"
	
	if intCodGrade = "" then intCodGrade = 0
%>
<form method="POST" id="frm" action="#">
  <table width="100%" align="left" class="CorFundo" >
    <tr>
      <td width="486" height="85" align="center">
	  <table width="477" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td colspan="2" align="center" class="tituloPrincipal">Consulta Disciplina </td>
          </tr>
          <tr>
            <td width="84">&nbsp;</td>
            <td width="393">&nbsp;</td>
          </tr>
          <tr>
            <td height="28"><span class="TextoForm">Disciplina :   </span></td>
            <td><input name="txtDescDisciplina" type="text" class="text" id="txtDescDisciplina" size="50" maxlength="50" value="<%=strDescDisciplina%>" /></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><!--#include file="../../includes/inc_botoes_consulta.asp"--></td>
          </tr>
        </table>
		<br>
		<table width = "484" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
		  <tr bgcolor="#E5E5E5">
			<td class="TextoForm"><strong>C&oacute;digo</strong></td>
			<td width="87%" bgcolor="#E5E5E5" class="TextoForm"><strong>Nome </strong><strong class="TextoForm">&nbsp;</strong></td>
		  </tr>
		  <%
			cont =0
			
			sql = "SELECT COD_Disciplina, DESC_Disciplina, Desc_Abreviada"
			sql = sql & " FROM SCA_DISCIPLINA"
			sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
		
			if strDescDisciplina <> "" then
				sql = sql & " and DESC_Disciplina LIKE '%" & strDescDisciplina & "%'"
			end if
			
			sql = sql & " order by DESC_Disciplina"
			rs.open sql, cnn
				
			if rs.eof = false then

				while not rs.eof
					cont = cont + 1	
					selecionado = ""
					
					' Consulta SCA_GRADECURRICULARDISCIPLINA
					if intCodGrade <> 0 then
					
						sql = " SELECT Cod_Disciplina "
						sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA "
						sql = sql & " WHERE Cod_GradeCurricular = " &  intCodGrade
						sql = sql & " And Cod_Disciplina = " &  rs("COD_Disciplina")
						rsAux.open sql, cnn
						
						if rsAux.eof = false then
							selecionado = "checked"
						end if
						rsAux.close
					end if
					%>
					  <tr bgcolor="#FFFFFF"  style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)">
						<td width="5%" height="26" class="Texto"><input name="chkDisciplina" type="checkbox" value="<%=rs("COD_Disciplina")%>"  <%=selecionado%>></td>
						<td class="Texto"><input type="hidden" name="txtDescDisciplina<%=rs("COD_Disciplina")%>" value="<%=trim(rs("DESC_Disciplina"))%>">&nbsp;<%=trim(rs("DESC_Disciplina"))%></td>
					  </tr>
					<%				
				rs.movenext
				wend
				%>
				<tr> 
				<td height="21" colspan="4" class="celula"><span class="texto">Total Registros :</span> <%=cont%></td>
				<%
			end if
			rs.close
			%>
	</table>
	</td> 
    </tr>
  </table>
</form>
</body>
</html>
