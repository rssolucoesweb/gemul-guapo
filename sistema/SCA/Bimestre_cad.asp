<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 02/03/2009
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Bimestre
-->
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
<script>
	function resultadoConsulta(intCodigo){
	
		var frm = document.getElementById("frm");
		
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtDescricao.value == "") {
			alert("A Descrição deve ser informada!");
			frm.txtDescricao.focus();
			return false;
		}
		if (frm.txtPeriodo.value == "") {
			alert("O Período deve ser informado!");
			frm.txtPeriodo.focus();
			return false;
		}
		
		frm.action="Bimestre_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<%
	strPaginaTitulo 	= "Bimestre_cad.asp"
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strPeriodo			= Trim(Request.Form("txtPeriodo"))

	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")
		
	if trim(intCodigo) <> "" then
	
		sql = "SELECT codigo, periodo, descricao, ano_letivo, semestre"
		sql = sql & " FROM SCA_bimestre"
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
		sql = sql & " and codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			strDescricao			= rs("descricao")
			strPeriodo					= rs("periodo")
			strAnoLetivo 			= Trim(rs("Ano_Letivo"))
			if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
			intSemestre 			= Trim(rs("Semestre"))
			if intSemestre = "" then 	intSemestre  = session("strSemestre")
			
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
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="751"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post">
		  <table width="708" border="0" cellpadding="0" cellspacing="0">

            <tr valign="top">
              <td width="700" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
          </table>
		  <br>
		  <table width="703" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="texto1">Ano:</td>
            <td><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
          </tr>
          <tr>
            <td class="texto1">Semestre:</td>
            <td><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
          </tr>
          <tr>
            <td width="77" class="texto1">Descri&ccedil;&atilde;o:</td>
            <td width="626"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
                <input name="txtDescricao" type="text" class="text" id="txtDescricao" size="50" maxlength="50" value="<%=strDescricao%>"></td>
          </tr>
          <tr>
            <td class="texto1">Per&iacute;odo:</td>
            <td><input name="txtPeriodo" type="text" class="text" id="txtPeriodo" size="50" maxlength="50" value="<%=strPeriodo%>"></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><%
			cont =0
			sql = "SELECT codigo, Periodo, descricao"
			sql = sql & " FROM SCA_bimestre"
			sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
			sql = sql & " and ano_letivo = " & strAnoLetivo			
			IF intSemestre <> "0" THEN
			sql = sql & " and semestre in (" & intSemestre & ")"
			END IF
			sql = sql & " Order by codigo"
			rs.open sql, cnn
			if rs.eof = false then
			%>
                <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td width="8%" class="celula"><strong>C&oacute;digo </strong></td>
                    <td width="40%" height="21" class="celula"><strong>Descri<span class="TextoForm">&ccedil;&atilde;o</span></strong></td>
                    <td width="52%" class="celula"><strong>Per&iacute;odo<span class="TextoForm"></span></strong></td>
                  </tr>
                  <%
				while not rs.eof
					cont = cont + 1	
					%>
                  <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
                    <td class="celula"><%=rs("codigo")%></td>
                    <td height="20" class="celula"><%=trim(rs("descricao"))%></td>
                    <td class="celula"><%=trim(rs("Periodo"))%></td>
                  </tr>
                  <%				
					rs.movenext
					wend
				  %>
                  <tr>
                    <td height="21" colspan="3" class="celula">Total Registros : <%=cont%></td>
                  </table>
              <%
			  end if
			  rs.close%></td>
          </tr>
        </table>
		</form>
		</td>
      </tr>
    </table>
	</td>
  </tr>
</table>
<!--#include file="../rodape.asp"-->
</body>
</html>