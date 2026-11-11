<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Extrato de NOtas
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<script>
	function gerar(){
		var caminho;
		if (frm.cmbOpcao.value=="X") {
			caminho = "Rel_Reserva_excl_rel.asp"
		}
		else{
		if (frm.cmbTipo.value=="N")
			caminho = "Rel_Reserva_rel.asp"
		if (frm.cmbTipo.value=="T")
			caminho = "Rel_ReservaTotal_rel.asp"

		}
		frm.action = caminho;
		frm.submit();
		return true;	
	}
</script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<%
	strPaginaTitulo = "Rel_Reserva_rel.asp"

	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""
	
	intCodSetor = request("cmbSetor")
	intCodRegiao = request("cmbRegiao")
	
	
	strCurso 				= request("cmbCurso")
	strPeriodo 				= request("cmbPeriodo")
	strTipo 				= request("cmbTipo")
	if strTipo = "" then strTipo = "N"
	
	strOpcao 				= request("cmbOpcao")
	if strOpcao = "" then strOpcao = "C"
	intCodEmpresaGrupo	= request("cmbEmpresaGrupo")
	if strOpcao = "C" then intCodEmpresaGrupo = "0"

%>
<form method="post" id="frm" action="#">
<table width="100%" height="325" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
<tr valign="top">
		  <td height="22" align="center" class="tituloSistema">Rela&ccedil;&atilde;o de Cadastro de Reservas na Matricula 2021<%'=year(date)%></td>
	</tr>
		<tr valign="top">
		  <td align="center">
<br>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario"><tr><td width="60%" valign="top" class="texto1"><table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario"><tr></tr>
</table>
      <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
        <tr>
          <td height="20" class="texto">Op&ccedil;&atilde;o:</td>
          <td class="texto">&nbsp;
            <input <%if strOpcao = "C" or strOpcao = "" then response.write "checked"%>  type="radio" name="cmbOpcao" id="cmbOpcao" value="C" onChange="submit()">Cadastro&nbsp;&nbsp;
            <input <%if strOpcao = "E" then response.write "checked"%>  type="radio" name="cmbOpcao" id="cmbOpcao" value="E" onChange="submit()">Efetivado&nbsp;&nbsp;
            <input <%if strOpcao = "X" then response.write "checked"%>  type="radio" name="cmbOpcao" id="cmbOpcao" value="X" onChange="submit()">Excluído&nbsp;&nbsp;
            </td>
        </tr>
        <tr>
          <td height="20" class="texto">Curso:</td>
          <td><!--#include file="../includes/inc_cmbCursoMatricula.asp"--></td>
        </tr>
        <tr>
          <td height="20" class="texto">Período/S&eacute;rie:</td>
          <td><!--#include file="../includes/inc_cmbPeriodoMatricula.asp"--></td>
        </tr>

        <%if strOpcao = "E" then%>
        <tr>
          <td height="20" class="texto">Unidade da efetivação:</td>
          <td><!--#include file="../includes/inc_cmbEmpresaGrupo.asp"--></td>
        </tr>
        <tr>
          <td height="20" class="texto">Per&iacute;odo efetiva&ccedil;&atilde;o:</td>
          <td class="texto"><input name="data_inicio" type="text" class="text" id="data_inicio"  onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=data_inicio%>"> 
            a 
              <input name="data_fim" type="text" class="text" id="data_fim"  onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=data_fim%>"></td>
        </tr>
        <%end if%>
        <%if strOpcao = "X" then%>
        <tr>
          <td height="20" class="texto">Per&iacute;odo exclus&atilde;o:</td>
          <td class="texto"><input name="data_inicio" type="text" class="text" id="data_inicio"  onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=data_inicio%>"> 
            a 
              <input name="data_fim" type="text" class="text" id="data_fim"  onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=data_fim%>"></td>
        </tr>
        <%end if%>
        <tr>
          <td height="20" class="texto">Tipo:</td>
          <td><select name="cmbTipo" class="Combo" id="cmbTipo"  style="width:120pt" >
            <option <%if strTipo = "N" then response.write "selected"%> value="N">Nominal</option>
            <option <%if strTipo = "T" then response.write "selected"%> value="T">Total</option>
          </select>
            &nbsp;</td>
        </tr>
		
        <tr>
          <td height="20" class="texto"><strong>Regi&atilde;o (opicional)</strong></td>
          <td><!--#include file="../includes/inc_cmbRegiao.asp"--></td>
        </tr>
        <tr>
          <td height="20" class="texto"><strong>Setor</strong></td>
          <td><!--#include file="../includes/inc_cmbSetor.asp"--></td>
        </tr>
        <tr>
          <td height="20" class="texto">Bolsa</td>
          <td><select name="cmbBolsa" class="Combo" id="cmbBolsa"  style="width:100pt" >
            <option value="T">Todos</option>
            <option value="C">Com Bolsa</option>
            <option value="S">Sem Bolsa</option>
            </select></td>
        </tr>
        <tr>
          <td width="9%" height="20" class="texto">Ordenação:</td>
          <td width="91%">
        <select name="cmbOrdenacao" class="Combo" id="cmbOrdenacao"  style="width:100pt" >
            <option value="0">Selecione...</option>
            <option value="1" <%if intOrdenacao = "1" then response.Write("selected") %>>Ordem de Incrição</option>
            <option value="2" <%if intOrdenacao = "2" then response.Write("selected") %>>Nome</option>
            <option value="3" <%if intOrdenacao = "3" then response.Write("selected") %>>Seríe</option>
            <option value="4" <%if intOrdenacao = "4" then response.Write("selected") %>>Bairro</option>
            <%if strOpcao = "E" then%>
            <option value="5" <%if intOrdenacao = "5" then response.Write("selected") %>>Data de Efetivação</option>
            <%end if%>
        </select>
          </td>
        </tr>
        <tr>
          <td height="20" class="texto">&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td height="2" colspan="2"><hr size="1" color="#CCCCCC"></td>
        </tr>
        <tr>
          <td colspan="2"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->
            &nbsp;</td>
        </tr>
      </table>      
      <strong></strong></td>
       </tr>
</table>
<br>
<br>		  </td>
		</tr>
  </table>

</form>
<!--#include file="../rodape.asp"-->
</body>
</html>
