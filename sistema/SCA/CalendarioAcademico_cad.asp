<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../js/Calendario/Calendario.asp"-->
<script>
	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		
		frm.txtCodigo.value=intCodigo
		frm.submit();
	}
	function salvar(acao){
			
			var frm = document.getElementById("frm");
			
			if (frm.cmbSemestre.value == "0") {
				alert("O Semestre deve ser informado !");
				frm.cmbSemestre.focus();
				return false;
			}
		
			if (frm.cmbMes.value == "0") {
				alert("O Mês deve ser informado !");
				frm.cmbMes.focus();
				return false;
			}
			
			if (frm.txtData.value == "") {
				alert("A Data deve ser informada !");
				frm.txtData.focus();
				return false;
			}
			
			if (frm.txtDescricao.value == "") {
				alert("A Descrição deve ser informada !");
				frm.txtDescricao.focus();
				return false;
			}
							
			frm.action="CalendarioAcademico_cod.asp?acao=" + acao;
			frm.submit();
			return true;
		
	}
</script>
<%
    strExecutarSubmitSemestre = "S"
    strPaginaTitulo = "CalendarioAcademico_cad.asp"
	intCodigo	 		= Trim(Request("txtCodigo"))
	strAno	 			= Trim(Request("txtAno"))
	if Trim(Request("cmbSemestre")) <> "0" then
		intSemestre 		= Trim(Request("cmbSemestre"))
	else	
		intSemestre 		=  Session("strSemestre")
	end if	

	strMes		 		= Trim(Request("cmbMes"))
	strData 			= Trim(Request("txtData"))
	strData2 			= Trim(Request("txtData2"))
	strDescricao 		= Trim(Request("txtDescricao"))
	
	if Trim(Request("txtData")) = "" then strData = formataDataAP(date)
	if Trim(Request("txtData2")) = "" then strData2 = formataDataAP(date)
	
	if trim(intCodigo) <> "" then
	
		sql = "SELECT Codigo, Ano, Semestre, Mes, Data, Data2, Descricao, Feriado"
		sql = sql & " FROM sca_CalendarioAcademico"
		sql = sql & " Where Codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 		= rs("Codigo")
			strAno	 			= rs("Ano")
			intSemestre	 		= rs("Semestre")
			strMes 		 		= rs("Mes")
			strData 			= formataDataAP(rs("Data"))
			strData2 			= formataDataAP(rs("Data2"))
			strDescricao		= rs("Descricao")
			strFeriado		    = trim(rs("Feriado"))
			if strFeriado       = "S" then Marcado = " checked "
			
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			BotaoSeguimento		 	= "" 'Desabilita o botão Excluir
			
		end if 
		rs.close
	else
	
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		BotaoSeguimento		 = "disabled" 'Desabilita o botão Excluir
	end if 
	
	if strAno = "" then strAno = session("strAnoLetivo")
	if intSemestre = "" then intSemestre = Session("strSemestre")
%>
<table width="100%" height="355" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" >
  <tr valign="top">
    <td align="center">
	<form method="post" id="frm">	
	  <table width="96%" border="0" cellpadding="0" cellspacing="0" >
        <tr valign="top">
          <td width="700" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
        </tr>
        <tr valign="top">
          <td align="left" >
		  <!-- inicio tabela de cadastro de funcionario -->
		  <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="16%" class="texto1">&nbsp;</td>
			    <td width="25" class="texto1"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10"></td>
			    </tr>
			  <tr height="26">
			    <td class="texto1">Ano:</td>
			    <td class="texto1"><input  name="txtAno" type="text" class="text" id="txtAno" value="<%=strAno%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)" onChange="submit()"></td>
			    </tr>
			  <tr height="26">
			    <td class="texto1">Semestre:</td>
			    <td><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
			    </tr>
			  <tr height="26">
			    <td class="texto1">M&ecirc;s:</td>
			    <td class="texto1"><!--#include file="../includes/inc_cmbMes.asp"--></td>
			    </tr>
			  <tr height="26">
			    <td class="texto1">Per&iacute;odo:</td>
			    <td class="texto1"><input name="txtData" type="text" id="txtData" class="text" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strData%>" size="11" maxlength="11" style="cursor:hand" title="Click aqui para visualizar o calend&aacute;rio">
			      a
                  <input name="txtData2" type="text" id="txtData2" class="text" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strData2%>" size="11" maxlength="11" style="cursor:hand" title="Click aqui para visualizar o calend&aacute;rio"></td>
			    </tr>
			  <tr height="26">
			    <td class="texto1">Dia(s) n&atilde;o Letivo:</td>
			    <td class="texto1"><input <%=marcado%> type="checkbox"  id="txtFeriado" name="txtFeriado" value="S" ></td>
			    </tr>
			  <tr height="26">
			    <td class="texto1">&nbsp;</td>
			    <td class="texto1">&nbsp;</td>
			    </tr>
			  <tr>
			    <td class="texto1">Descri&ccedil;&atilde;o: </td>
			    <td class="texto1"><textarea name="txtDescricao" cols="50" rows="6" class="text" id="txtDescricao"><%=strDescricao%></textarea></td>
			    </tr>
			</table>
		  <!-- fim tabela de cadastro de funcionario -->		  </td>
        </tr>
        <tr valign="top">
          <td class="texto1">&nbsp;</td>
        </tr>
        <tr valign="top">
          <td class="texto1"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
        </tr>
        <tr valign="top">
          <td class="texto1">&nbsp;</td>
        </tr>
        <tr valign="top">
        <td class="texto1">
		<%
		cont = 0
		
		sql = "SELECT Codigo, Ano, Semestre, Mes, Data, Data2, Descricao, Feriado"
		sql = sql & " FROM sca_CalendarioAcademico"
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
		sql = sql & " and ano = " & strAno			
		sql = sql & " and semestre in (" & intSemestre & ")"
		sql = sql & " ORDER BY Data desc "
		rs.open sql, cnn
		if rs.eof = false then
		%>
		<table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
			<tr bgcolor="#E5E5E5">
			<td class="celula"><strong>C&oacute;d.</strong></td>
			<td width="28%" class="celula"><div align="center"><strong>Per&iacute;odo</strong></div></td>
			<td width="51%" height="21" class="celula"><strong>Descri&ccedil;&atilde;o</strong></td>
		    <td width="17%" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
			</tr>
		  <%
		  while not rs.eof
		   if  trim(rs("Feriado"))    = "S" then 
		      statusFeriado = "FERIADO"
		   else
		      statusFeriado = "DIA LETIVO"
		   end if  


		  cont = cont + 1	
		  %>
		  <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
			<td width="4%" class="celula"><%=rs("Codigo")%></td>
			<td class="celula"><div align="center"><%=trim(formataDataAP(rs("Data")))%>&nbsp;-&nbsp;<%=trim(formataDataAP(rs("Data2")))%></div></td>
			<td height="21" class="celula  ">&nbsp;<%=trim(rs("Descricao"))%></td>
		    <td height="21" class="celula  ">&nbsp;<strong><%=statusFeriado%></strong></td>
		  </tr>
		  <%				
			rs.movenext
			wend
			%>
	 	<tr>
		<td height="21" colspan="4" class="celula">Total Registros : <%=cont%></td>
	  </table>
		<%
	  end if
	  rs.close%></td>
        </tr>
        <tr valign="top">
          <td align="center" class="texto1">&nbsp;</td>
        </tr>
      </table>
	  </form>
	</td>
  </tr>
</table>
<!--#include file="../rodape.asp"-->
</body>
</html>