<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Curso 
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
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		if (frm.txtDescricao.value == "") {
			alert("A Descrição deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		
		if (frm.txtDescAbreviada.value == "") {
			alert("A Descrição Abreviada deve ser informada !");
			frm.txtDescAbreviada.focus();
			return false;
		}
		
		if (frm.txtSigla.value == "") {
			alert("A Sigla deve ser informada !");
			frm.txtSigla.focus();
			return false;
		}
		
		if (frm.cmbGrau.value == "0") {
			alert("O Grau deve ser informado !");
			frm.cmbGrau.focus();
			return false;
		}
				
		frm.action="Curso_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<%
	strPaginaTitulo = "Curso_cad.asp"

	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strDescAbreviada	= Trim(Request.Form("txtDescAbreviada"))
	strDescHistorico	= Trim(Request.Form("txtDescHistorico"))

	strSigla			= Trim(Request.Form("txtSigla"))
	intCodGrau			= Trim(Request.Form("cmbGrau"))
	strhabilitacao		= Request.Form("txthabilitacao")
	strReconhecimento	= Request.Form("txtreconhecimento")
	strAutorizacao		= Request.Form("txtautorizacao")
	strDataReconhecimento= Request.Form("txtDataReconhecimento")
	strDataAutorizacao	= Request.Form("txtDataAutorizacao")
	strCHExigida		= Request.Form("txtCHExigida")
	strProcessoSeletivo = Request.Form("cmbSimouNao")
	
		
	if trim(intCodigo) <> "" then
	
		sql = "SELECT *"
		sql = sql & " FROM SCA_CURSO"
		sql = sql & " Where Cod_curso = " & intCodigo
		sql = sql & " And cod_empresa = " & Session("CodEmpresa")			
		rs.open sql, cnn
		
		if rs.eof = false then
					
			intCodigo	 		= rs("Cod_curso")
			strDescricao 		= rs("Descricao")
			strDescAbreviada	= rs("Desc_Abreviada")
			strDescHistorico	= rs("Desc_Historico")
			strSigla			= rs("Sigla")
			intCodGrau			= rs("Cod_Grau")
			
			strhabilitacao		= rs("habilitacao")
			strreconhecimento	= rs("reconhecimento")
			strautorizacao		= rs("autorizacao")

			strDataReconhecimento= formatadataAP(rs("DataReconhecimento"))
			strDataAutorizacao	 = formatadataAP(rs("DataAutorizacao"))

			strCHExigida		 = rs("CH_exigida")
			strProcessoSeletivo  = rs("processoseletivo")
			
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
	<table width="100%"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post">
		  <table width="100%" border="0" cellpadding="0" cellspacing="0">

            <tr valign="top">
              <td width="700" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
          </table>
		  <br>
		  <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="20%" height="24" class="texto1">Descri&ccedil;&atilde;o (Uso Interno)</td>
            <td width="80%"><input  name="txtCodigo" type="hidden" class="text" id="txtCodigo"  value="<%=intCodigo%>" size="10" maxlength="10" onKeyPress="return formataCampo(this,2,10)">
              <input name="txtDescricao" type="text" class="text" id="txtDescricao" size="40" maxlength="50" value="<%=strDescricao%>"></td>
          </tr>
          <tr>
            <td class="texto1">Descri&ccedil;&atilde;o Abreviada (Hor&aacute;rio): </td>
            <td><input name="txtDescAbreviada" type="text" class="text" id="txtDescAbreviada" size="20" maxlength="20" value="<%=strDescAbreviada%>"></td>
          </tr>
          <tr>
            <td height="27" class="texto1">Descri&ccedil;&atilde;o (Hist&oacute;rico) </td>
            <td><input name="txtDescHistorico" type="text" class="text" id="txtDescHistorico" size="100" maxlength="150" value="<%=strDescHistorico%>"></td>
          </tr>
          <tr>
            <td height="27" class="texto1">Sigla</td>
            <td><input name="txtSigla" type="text" class="text" id="txtSigla" size="02" maxlength="02" value="<%=strSigla%>"></td>
          </tr>
          <tr>
            <td class="texto1">Grau</td>
            <td>
              <!--#include file="../includes/inc_cmbGrau.asp" --></td>
          </tr>
          <tr>
            <td class="texto1">Habilita&ccedil;&atilde;o</td>
            <td><span class="texto1">
              <input name="txtHabilitacao" type="text" class="text" id="txtHabilitacao" size="50" maxlength="100" value="<%=strHabilitacao%>">
            </span></td>
          </tr>
          <tr>
            <td class="texto1">Reconhecimento</td>
            <td><span class="texto1">
              <input name="txtReconhecimento" type="text" class="text" id="txtReconhecimento" size="50" maxlength="100" value="<%=strReconhecimento%>">
&nbsp;            Publica&ccedil;&atilde;o&nbsp;
<input name="txtDataReconhecimento" type="text" class="text" id="txtDataReconhecimento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataReconhecimento%>">
            do reconhecimento. </span></td>
          </tr>
          <tr>
            <td class="texto1">Autoriza&ccedil;&atilde;o</td>
            <td><span class="texto1">
              <input name="txtAutorizacao" type="text" class="text" id="txtAutorizacao" size="50" maxlength="100" value="<%=strAutorizacao%>">
&nbsp;            Publica&ccedil;&atilde;o&nbsp;
<input name="txtDataAutorizacao" type="text" class="text" id="txtDataAutorizacao" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataAutorizacao%>">
            da autoriza&ccedil;&atilde;o.</span></td>
          </tr>
          <tr>
            <td class="texto1">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td class="texto1">C.H. Exigida</td>
            <td><span class="texto1">
              <input name="txtCHExigida" type="text" class="text" id="txtCHExigida" size="5" maxlength="4" value="<%=strCHExigida%>" onKeyPress="return formataCampo(this, 2, 4)">
            </span></td>
          </tr>
          <tr>
            <td class="texto1">Prcesso Seletivo :</td>
            <td colspan="2"><!--#include file="../includes/inc_cmbSimouNao.asp"--></td>
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
			
			sql = "SELECT Cod_curso, Descricao, Desc_Abreviada, Sigla, Cod_Grau"
			sql = sql & " FROM SCA_CURSO"
			sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
			sql = sql & " Order by Descricao"
			rs.open sql, cnn
							
			if rs.eof = false then
			%>
              <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                <tr bgcolor="#E5E5E5">
                  <td width="10%" class="celula"><strong>C&oacute;digo</strong></td>
                  <td width="43%" class="celula"><strong>Descri<span class="TextoForm">&ccedil;&atilde;o</span></strong></td>
                  <td width="37%" class="celula"><strong>Descri<span class="TextoForm">&ccedil;&atilde;o Abreviada</span></strong></td>
                  <td width="10%" height="21" class="celula"><strong>Sigla<span class="TextoForm"> </span></strong></td>
                </tr>
                <%
				while not rs.eof
					cont = cont + 1	
					%>
                <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Cod_curso")%>')">
                  <td class="celula"><%=rs("Cod_curso")%></td>
                  <td class="celula"><%=trim(rs("Descricao"))%></td>
                  <td class="celula"><%=trim(rs("Desc_Abreviada"))%></td>
                  <td height="20" class="celula"><%=trim(rs("Sigla"))%></td>
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