<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_popup.css">
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<script>
	
	function resultadoConsulta(intCodigo){
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	function salvar(acao){
		
		if (frm.txtHabilitacao.value == "") {
			alert("A Habilitacao deve ser informada !");
			frm.txtHabilitacao.focus();
			return false;
		}
		
		if (frm.txtReconhecimento.value == "") {
			alert("O Reconhecimento deve ser informado !");
			frm.txtReconhecimento.focus();
			return false;
		}
		
		if (frm.txtDataReconhecimento.value == "") {
			alert("A Data Reconhecimento deve ser informada !");
			frm.txtDataReconhecimento.focus();
			return false;
		}
		
		if (frm.txtAutorizacao.value == "") {
			alert("A Autorizacao deve ser informada !");
			frm.txtAutorizacao.focus();
			return false;
		}
		
		if (frm.txtDataAutorizacao.value == "") {
			alert("A Data Autorizacao deve ser informada !");
			frm.txtDataAutorizacao.focus();
			return false;
		}
		
		if (frm.txtCHExigida.value == "") {
			alert("A C.H. Exigida deve ser informada !");
			frm.txtCHExigida.focus();
			return false;
		}
		
		frm.action="CursoResolucao_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<%
	intCodEmp				= Session("CodEmpresa")
	intCodigo				= Request.Form("txtCodigo")
	intCodCurso				= Trim(Request.QueryString("CodCurso"))
	strhabilitacao			= Request.Form("txthabilitacao")
	strReconhecimento		= Request.Form("txtreconhecimento")
	strAutorizacao			= Request.Form("txtautorizacao")
	strDataReconhecimento	= Request.Form("txtDataReconhecimento")
	strDataAutorizacao		= Request.Form("txtDataAutorizacao")
	strCHExigida			= Request.Form("txtCHExigida")
	
	if trim(intCodCurso) <> "" then
	
		sql = "SELECT *"
		sql = sql & " FROM SCA_CURSO"
		sql = sql & " Where Cod_curso = " & intCodCurso
		sql = sql & " And cod_empresa = " & Session("CodEmpresa")			
		rs.open sql, cnn
		
		if rs.eof = false then
			intCodCurso	 		= rs("Cod_curso")
			strDescricao 		= rs("Descricao")
			strDescAbreviada	= rs("Desc_Abreviada")
			strDescHistorico	= rs("Desc_Historico")
		end if 
		rs.close
		
	end if
	
	if trim(intCodigo) <> "" then
	
		sql = "SELECT Codigo, Cod_Empresa, Cod_curso, habilitacao, reconhecimento, autorizacao, "
		sql = sql & " dataReconhecimento, DataAutorizacao, CH_Exigida "
		sql = sql & " FROM SCA_CURSO_RESOLUCAO"
		sql = sql & " where Cod_Empresa = " & Session("CodEmpresa")		
		sql = sql & " and  Codigo = " & intCodigo	
		sql = sql & " Order by Codigo"
		rs.open sql, cnn
		
		if rs.eof = false then
			
			strhabilitacao			= rs("habilitacao")
			strReconhecimento		= rs("reconhecimento")
			strAutorizacao			= rs("autorizacao")
			strDataReconhecimento	= rs("dataReconhecimento")
			strDataAutorizacao		= rs("DataAutorizacao")
			strCHExigida			= rs("CH_Exigida")
			
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir

			
		end if 
		rs.close
	else
	
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir

	end if

%>
<form name="frm" id="frm" method="post">
<table width="98%" align="center" class="formulario" bgcolor="#FFFFFF">
<tr>
  <td  align="center" class="TituloFormulario"><table width="98%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td height="18" colspan="2" align="center"><span class="tituloSistema">Resolu&ccedil;&atilde;o do Curso</span></td>
      </tr>
    <tr>
      <td height="18" colspan="2">&nbsp;</td>
      </tr>
    <tr>
      <td height="18" class="texto" colspan="2" bgcolor="#CCCCCC"><strong>Dados Curso </strong></td>
      </tr>
    <tr>
      <td><span class="TextoForm">C&oacute;digo</span></td>
      <td><span class="TextoForm">
        <input readonly name="txtCodCurso" class="text" type="text" onKeyPress="return formataCampo(this,2,10)" id="txtCodCurso" value="<%=intCodCurso%>" size="8" >
        <input  name="txtCodigo" type="hidden" class="text" id="txtCodigo"  value="<%=intCodigo%>" size="10" maxlength="10" onKeyPress="return formataCampo(this,2,10)">
      </span></td>
      </tr>
    <tr>
      <td height="25"><span class="texto1">Descri&ccedil;&atilde;o (Uso Interno)</span></td>
      <td><input name="txtDescricao"  readonly type="text" class="text" id="txtDescricao" size="60" maxlength="50" value="<%=strDescricao%>"></td>
      </tr>
    <tr>
      <td width="320" height="25"><span class="texto1">Descri&ccedil;&atilde;o Abreviada (Hor&aacute;rio): </span></td>
      <td width="917"><input name="txtDescAbreviada" readonly type="text" class="text" id="txtDescAbreviada" size="20" maxlength="20" value="<%=strDescAbreviada%>"></td>
      </tr>
    <tr>
      <td><span class="texto1">Descri&ccedil;&atilde;o (Hist&oacute;rico) </span></td>
      <td><input name="txtDescHistorico" type="text" readonly class="text" id="txtDescHistorico" size="60" maxlength="100" value="<%=strDescHistorico%>"></td>
      </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      </tr>
    <tr>
      <td height="18" class="texto" colspan="2" bgcolor="#CCCCCC"><strong>Dados Resolu&ccedil;&atilde;o </strong></td>
      </tr>
    <tr>
      <td><span class="texto1">Habilita&ccedil;&atilde;o</span></td>
      <td><span class="texto1">
        <input name="txtHabilitacao" type="text" class="text" id="txtHabilitacao" size="40" maxlength="100" value="<%=strHabilitacao%>">
        </span></td>
      </tr>
    <tr>
      <td><span class="texto1">Reconhecimento</span></td>
      <td><span class="texto1">
        <input name="txtReconhecimento" type="text" class="text" id="txtReconhecimento" size="40" maxlength="100" value="<%=strReconhecimento%>">
  &nbsp;            Publica&ccedil;&atilde;o&nbsp;
  <input name="txtDataReconhecimento" type="text" class="text" id="txtDataReconhecimento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataReconhecimento%>">
        do reconhecimento. </span></td>
      </tr>
    <tr>
      <td><span class="texto1">Autoriza&ccedil;&atilde;o</span></td>
      <td><span class="texto1">
        <input name="txtAutorizacao" type="text" class="text" id="txtAutorizacao" size="40" maxlength="100" value="<%=strAutorizacao%>">
  &nbsp;            Publica&ccedil;&atilde;o&nbsp;
  <input name="txtDataAutorizacao" type="text" class="text" id="txtDataAutorizacao" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataAutorizacao%>">
        da autoriza&ccedil;&atilde;o.</span></td>
      </tr>
    <tr>
      <td><span class="texto1">C.H. Exigida</span></td>
      <td><span class="texto1">
        <input name="txtCHExigida" type="text" class="text" id="txtCHExigida" size="5" maxlength="4" value="<%=strCHExigida%>" onKeyPress="return formataCampo(this, 2, 4)">
        </span></td>
      </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      </tr>
    <tr>
      <td colspan="2"><!--#include file="../../includes/inc_botoes_cadastroPopap.asp"--></td>
      </tr>
    <tr>
      <td colspan="2">&nbsp;</td>
      </tr>
    <tr>
      <td colspan="2">
	  <%
	  		
			cont =0
			
			sql = "SELECT Codigo, Cod_Empresa, Cod_curso, habilitacao, reconhecimento, autorizacao, "
			sql = sql & " dataReconhecimento, DataAutorizacao, CH_Exigida "
			sql = sql & " FROM SCA_CURSO_RESOLUCAO"
			sql = sql & " where Cod_Empresa = " & Session("CodEmpresa")		
			sql = sql & " and  Cod_curso = " & intCodCurso	
			sql = sql & " Order by Codigo"
			rs.open sql, cnn
							
			if rs.eof = false then
			%>
        <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
          <tr bgcolor="#E5E5E5">
            <td width="10%" class="celula"><strong>C&oacute;digo</strong></td>
            <td width="43%" class="celula"><strong>Habilita&ccedil;&atilde;o</span></strong></td>
            <td width="34%" class="celula"><strong>Reconhecimento</span></strong></td>
            <td width="13%" height="21" class="celula"><strong>C.H. Exigida<span class="TextoForm"> </span></strong></td>
          </tr>
          <%
				while not rs.eof
					cont = cont + 1	
					%>
          <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
            <td class="celula"><%=rs("Codigo")%></td>
            <td class="celula"><%=trim(rs("habilitacao"))%></td>
            <td class="celula"><%=trim(rs("reconhecimento"))%></td>
            <td height="20" class="celula"><%=trim(rs("CH_Exigida"))%></td>
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
    <tr>
      <td colspan="2">&nbsp;</td>
    </tr>
    </table>
    <br></td>
</tr>
  </table>
</form>
</body>
</html>