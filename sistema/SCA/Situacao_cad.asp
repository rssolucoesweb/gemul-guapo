<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 08/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Situacao 
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
		
		if (frm.txtDescricao.value == "") {
			alert("A Situação deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		
		frm.action="Situacao_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<%
	strPaginaTitulo = "Situacao_cad.asp"

	intCodSituacao 			= Trim(Request.Form("txtCodigo"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	intVinculoAlunoCenso 	= Trim(Request.Form("cmbVinculoAlunoCenso"))
	strSituacao				= Trim(Request.Form("cmbSituacao"))
	
		
	if trim(intCodSituacao) <> "" then
	
		sql = "SELECT Cod_SituacaoAluno, Desc_SituacaoAluno, Cod_Vinculo_Inep, status"
		sql = sql & " FROM SCA_SITUACAOALUNO"
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
		sql = sql & " and Cod_SituacaoAluno = " & intCodSituacao
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodTurno	 			= rs("Cod_SituacaoAluno")
			strDescricao			= rs("Desc_SituacaoAluno")
			intVinculoAlunoCenso	= rs("Cod_Vinculo_Inep")
			strSituacao				= rs("status")
			
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
            <td width="174" class="texto1">Situa&ccedil;&atilde;o :</td>
            <td><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodTurno%>" maxlength="10">
                <input name="txtDescricao" type="text" class="text" id="txtDescricao" size="40" maxlength="40" value="<%=strDescricao%>"></td>
          </tr>
         <tr>
            <td class="texto1">Situa&ccedil;&atilde;o de V&iacute;nculo Inep:</td>
            <td><!--#include file="../includes/inc_cmdSituacaoAlunoVinculoCenso.asp"--></td>
            </tr>
         <tr>
           <td class="texto1">Status:</td>
           <td><!--#include file="../includes/inc_cmdSituacao.asp"--></td>
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
			
			sql = "SELECT Cod_SituacaoAluno, Desc_SituacaoAluno, status"
			sql = sql & " FROM SCA_SITUACAOALUNO"
			sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
			sql = sql & " Order by Desc_SituacaoAluno"
			rs.open sql, cnn
							
			if rs.eof = false then
			%>
                <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td width="9%" class="celula"><strong>C&oacute;d. Situa&ccedil;&atilde;o </strong></td>
                    <td width="79%" height="21" class="celula"><strong>Descri<span class="TextoForm">&ccedil;&atilde;o</span></strong></td>
                    <td width="12%" class="celula"><div align="center"><strong>Status</strong></div></td>
                  </tr>
                  <%
				while not rs.eof
					cont = cont + 1	
					%>
                  <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Cod_SituacaoAluno")%>')">
                    <td class="celula"><%=rs("Cod_SituacaoAluno")%></td>
                    <td height="20" class="celula"><%=trim(rs("Desc_SituacaoAluno"))%></td>
                    <td class="celula"><div align="center"><%=trim(rs("status"))%></div></td>
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