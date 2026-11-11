<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 19/11/2012
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Mapa Geral de Vagas - Matricula 
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
		
		
		if (frm.cmbTipoCurso.value == "0") {
			alert("O  Curso deve ser informado !");
			frm.cmbTipoCurso.focus();
			return false;
		}
	
		caminho = "Rel_MapaVagas_rel.asp"
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
	strPaginaTitulo = "Rel_MapaVagas_rel.asp"
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then strAnoLetivo = session("strAnoLetivo")
	strCodGrupo 			= Session("CodGrupo")
	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""

%>
<form method="post" id="frm" action="#">
<table width="100%" height="315" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
<tr valign="top">
		  <td height="22" align="center" class="tituloSistema">Mapa Geral de Vagas</td>
	</tr>
		<tr valign="top">
		  <td align="center">
            <br>
            <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario"><tr><td width="60%" valign="top" class="texto1">
           	  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario"><tr></tr>
              </table>
                <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
                  <tr>
                    <td height="20" class="texto">Ano Letivo:</td>
                    <td><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
                  </tr>
                  <tr>
                    <td height="20" class="texto">Tipo:</td>
                    <td><select name="cmbTipoVaga" class="Combo" id="cmbTipoVaga"  style="width:120pt" >
                    <option value="C">Capacidade</option>
                    <!--option value="P">Vagas Preenchidas</option-->
                    <option value="D">Vagas Existentes</option>
                    <option value="L">Vagas Liberadas</option>
                    <!--option value="E">Vagas Efetivadas</option-->
					<%if Session("UsuarioWeb") = "SERGIO" OR Session("UsuarioWeb") = "NIVALDO.SILVA" OR Session("UsuarioWeb") = "FERNANDO.DOMINGOS" OR Session("UsuarioWeb") = "CLEOVIS" OR Session("UsuarioWeb") = "DOMINGOS.SILVA" OR Session("UsuarioWeb") = "CECILIA.HONORIA" then%>
					<option value="R">Vagas Reservadas</option>
					<%end if%>
        </select>&nbsp;</td>
                  </tr>
                  <tr>
                    <td width="9%" height="20" class="texto">Curso:</td>
                  <td width="91%"><span class="titulo1">
                      <!--#include file="../includes/inc_cmbTipoCurso.asp"-->
                    </span></td>
                  </tr>
				  
				   <tr>
                    <td height="20" class="texto">Ordem:</td>
                    <td>
						<select name="cmbOrdem" class="Combo" id="cmbOrdem"  style="width:120pt" >
						<option value="E">Escola</option>
						<option value="A">Ano Letivo</option>
						</select>
					</td>
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
