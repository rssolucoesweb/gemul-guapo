<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - Sergiob76@gmail.com
	::	Objetivo Pagina...: Cadastro de tipo avaliação
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
<!--#include file="../../includes/inc_validaPermissaoPagina.asp"-->
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
		
		if (frm.cmbCurso.value == "0") {
			alert("O curso deve ser informado !");
			frm.cmbCurso.focus();
			return false;
		}
		
		if (frm.txtDescricao.value == "") {
			alert("A Descrição deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		if (frm.txtSigla.value == "") {
			alert("A Sigla deve ser informada !");
			frm.txtSigla.focus();
			return false;
		}
		if (frm.cmbTipoAvaliacaoAgrupamento.value == "0") {
			alert("Tipo de Agrupamento deve ser informado !");
			frm.cmbTipoAvaliacaoAgrupamento.focus();
			return false;
		}
		frm.action="tipoAvaliacao_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<%
	strPaginaTitulo = "tipoAvaliacao_cad.asp"
	strPagina = "tipoAvaliacao_cad.asp"
	strExecutarSubmitCurso 	= "S"
	intCodigo 		= Trim(Request.Form("txtCodigo"))
	intCodCurso		= Trim(Request("cmbCurso"))
	strDescricao 	= Trim(Request.Form("txtDescricao"))
	strPosicao	 	= Trim(Request.Form("cmbPosicao"))
	strSigla		= Trim(Request.Form("txtSigla"))
	intCodAvaliacaoAgrupamento		= Trim(Request.Form("cmbTipoAvaliacaoAgrupamento"))
	strFormula		= Trim(Request.Form("txtFormula"))
	strDigitar		= Trim(Request.Form("txtDigitar"))

	if trim(intCodigo) <> "" then
	
		sql = "SELECT *"
		sql = sql & " FROM SCA_TIPO_AVALIACAO"
		sql = sql & " Where codigo = " & intCodigo
		sql = sql & " and cod_empresa = " & Session("CodEmpresa")			
		rs.open sql, cnn
		
		if rs.eof = false then	
			if not isnull(rs("cod_curso")) then intCodCurso				= rs("cod_curso")
			strDescricao			= rs("descricao")
			strSigla				= rs("sigla")
			intCodAvaliacaoAgrupamento				= rs("bimestre")
			strPosicao				= rs("posicao")
			strFormula				= rs("formula")
			strDigitar				= trim(rs("digitar"))
			
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir

		end if 
		rs.close
	else
		strDescricao			= ""
		strSigla				= ""
		intCodAvaliacaoAgrupamento				= "0"
		strPosicao				= ""
		strFormula				= ""
		strDigitar				= ""

		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 

%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="98%"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post" action="tipoAvaliacao_cad.asp">
		  <table width="100%" border="0" cellpadding="0" cellspacing="0">

            <tr valign="top">
              <td width="100%" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
          </table>
		  <br>
		  <table width="98%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="texto1">Curso:</td>
            <td><!--#include file="../includes/inc_cmdCurso.asp" --></td>
          </tr>
          <tr>
            <td width="77" class="texto1">Descri&ccedil;&atilde;o:</td>
            <td width="626"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
                <input name="txtDescricao" type="text" class="text" id="txtDescricao" size="40" maxlength="30" value="<%=strDescricao%>"></td>
          </tr>
          <tr>
            <td class="texto1">Sigla:</td>
            <td><input name="txtSigla" type="text" class="text" id="txtSigla" size="15" maxlength="10" value="<%=strSigla%>"></td>
          </tr>
          <tr>
            <td class="texto1">Tipo:</td>
            <td><!--#include file="../includes/inc_cmdTipoAvaliacaoAgrupamento.asp" --></td>
          </tr>
          <tr>
            <td class="texto1">Campo:</td>
            <td><span class="TextoForm">
              <select name="cmbPosicao" class="Combo" id="cmbPosicao"  style="width:150pt">
			  	<%for i=1 to 25%>
                <option value="<%=i%>" <%if strPosicao = i then response.Write("selected") %>>C<%=i%></option>
			 	<%next%>
              </select>
            </span></td>
          </tr>
          <tr>
            <td class="texto1">F&oacute;rmula:</td>
            <td><input name="txtFormula" type="text" class="text" id="txtFormula" size="100" maxlength="200" value="<%=strFormula%>"></td>
          </tr>
          <tr>
            <td class="texto1">Digitar:</td>
            <td><span class="TextoForm">
              <select name="txtDigitar" class="Combo" id="txtDigitar">
                <option value="S" <%if trim(strDigitar) = "S" then response.Write("selected") %>>Sim</option>
                <option value="N" <%if trim(strDigitar) = "N" then response.Write("selected") %>>N&atilde;o</option>
              </select>
            </span></td>
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
		if intCodCurso = "" then intCodCurso = "0"
		if intCodCurso <> "0" then
			cont =0
			sql = "SELECT SCA_TIPO_AVALIACAO_AGRUPAMENTO.DESCRICAO AS AGRUPAMENTO, SCA_TIPO_AVALIACAO.codigo, SCA_TIPO_AVALIACAO.Descricao, SCA_TIPO_AVALIACAO.Sigla, SCA_TIPO_AVALIACAO.bimestre, SCA_TIPO_AVALIACAO.posicao, SCA_TIPO_AVALIACAO.formula, SCA_TIPO_AVALIACAO.digitar, SCA_CURSO.sigla AS CURSO"
			sql = sql & " FROM SCA_TIPO_AVALIACAO"
			sql = sql & " LEFT JOIN SCA_TIPO_AVALIACAO_AGRUPAMENTO ON SCA_TIPO_AVALIACAO_AGRUPAMENTO.CODIGO = SCA_TIPO_AVALIACAO.BIMESTRE"
			sql = sql & " LEFT JOIN SCA_CURSO ON SCA_CURSO.COD_CURSO = SCA_TIPO_AVALIACAO.COD_CURSO"
			sql = sql & " where SCA_TIPO_AVALIACAO.cod_empresa = " & Session("CodEmpresa")			
			sql = sql & " and 	SCA_CURSO.COD_CURSO = "& intCodCurso
			sql = sql & " Order by posicao"
			rs.open sql, cnn
			if rs.eof = false then
			%>
                <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td width="5%" class="celula"><strong>Curso</strong></td>
                    <td width="5%" class="celula"><strong>C&oacute;digo </strong></td>
                    <td width="15%" height="21" class="celula"><strong><span class="TextoForm">Descri&ccedil;&atilde;o</span></strong></td>
                    <td width="16%" height="21" class="celula"><strong><span class="TextoForm">Sigla</span></strong></td>
                    <td width="13%" class="celula"><strong>Tipo</strong></td>
                    <td width="7%" height="21" class="celula"><strong><span class="TextoForm">Campo</span></strong></td>
                    <td width="36%" class="celula" align="center"><strong>F&oacute;rmula</strong></td>
                    <td width="8%" class="celula" align="center"><strong>Digitar</strong></td>
                  </tr>
                  <%

				  
				while not rs.eof
					cont = cont + 1	
					if trim(rs("bimestre")) = "1" or trim(rs("bimestre")) = "2" or trim(rs("bimestre")) = "3" or trim(rs("bimestre")) = "4" then
						bimestre = trim(rs("bimestre")) & "º Bimestre"
					else
						bimestre = trim(rs("AGRUPAMENTO"))
					end if

					if not isnull(rs("posicao")) then posicao = trim(rs("posicao"))

					
					%>
                  <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
                    <td class="celula"><%=rs("CURSO")%>&nbsp;</td>
                    <td class="celula"><%=rs("codigo")%></td>
                    <td height="20" class="celula"><%=trim(rs("descricao"))%></td>
                    <td height="20" class="celula"><%=trim(rs("sigla"))%></td>
                    <td class="celula"><%=bimestre%></td>
                    <td height="20" class="celula">C<%=posicao%></td>
                    <td class="celula"><%=trim(rs("formula"))%>&nbsp;</td>
                    <td class="celula" align="center"><%=trim(rs("digitar"))%>&nbsp;</td>
                  </tr>
                  <%				
					rs.movenext
				wend
				%>
                  <tr>
                    <td height="21" colspan="8" class="celula">Total Registros : <%=cont%></td>
                  </table>
              <%
			  end if
			  rs.close
		end if%>
              </td>
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