<!--
	::	DESENVOLVIDO POR..: RS SOLUÇÕES WEB - www.rssolucoesweb.com.br
	::	Data de Criação...: 09/12/2008
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Configurações gerais
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
<!--#include file="../../js/Calendario/Calendario.asp"-->
<script>
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		frm.action="datas_cod.asp";
		frm.submit();
		return true;
 	}
	
	function periodo(){
		alert("Essa ação alterará as datas de validação da matrícula e período de efetivação nos comprovantes!")
 	}
</script>
<%
	strPaginaTitulo 					= "Datas_cad.asp"

	sql = "SELECT *"
	sql = sql & " FROM MAT_periodo_curso"
	rs.open sql, cnn
	
	if rs.eof = false then
		while not rs.eof
			if rs("codigo") = "1"  then dt_inicial_I = formataDataAP(rs("dt_inicial"))
			if rs("codigo") = "2"  then dt_inicial_II = formataDataAP(rs("dt_inicial"))
			if rs("codigo") = "3"  then dt_inicial_III = formataDataAP(rs("dt_inicial"))
			if rs("codigo") = "9"  then dt_inicial_IV = formataDataAP(rs("dt_inicial"))
			if rs("codigo") = "10" then dt_inicial_V = formataDataAP(rs("dt_inicial"))
			if rs("codigo") = "12" then dt_inicial_ef = formataDataAP(rs("dt_inicial"))
			if rs("codigo") = "13" then dt_inicial_regra_especial = formataDataAP(rs("dt_inicial"))

			if rs("codigo") = "1"  then dt_final_I = formataDataAP(rs("dt_final"))
			if rs("codigo") = "2"  then dt_final_II = formataDataAP(rs("dt_final"))
			if rs("codigo") = "3"  then dt_final_III = formataDataAP(rs("dt_final"))
			if rs("codigo") = "9"  then dt_final_IV = formataDataAP(rs("dt_final"))
			if rs("codigo") = "10" then dt_final_V = formataDataAP(rs("dt_final"))
			if rs("codigo") = "12" then dt_final_ef = formataDataAP(rs("dt_final"))
			if rs("codigo") = "13" then dt_final_regra_especial = formataDataAP(rs("dt_final"))
			rs.movenext
		wend
		
	end if 
	rs.close
	
	sql = "SELECT *"
	sql = sql & " FROM MAT_periodo_valido_matricula"
	rs.open sql, cnn
	
	if rs.eof = false then
		while not rs.eof
			if rs("codigo") = "5"  then dt_inicial_ei_V = formataDataAP(rs("dt_inicial"))
			if rs("codigo") = "6"  then dt_inicial_ef_V = formataDataAP(rs("dt_inicial"))
			if rs("codigo") = "8"  then dt_inicial_minima_ei = formataDataAP(rs("dt_inicial"))

			if rs("codigo") = "5"  then dt_final_ei_V = formataDataAP(rs("dt_final"))
			if rs("codigo") = "6"  then dt_final_ef_V = formataDataAP(rs("dt_final"))
			if rs("codigo") = "12"  then dt_final_minima_ef = formataDataAP(rs("dt_final"))
			
			rs.movenext
		wend
		
	end if 
	rs.close
	
	sql = "SELECT periodo_dinamico"
	sql = sql & " FROM MAT_configuracoes where cod_grupo=" & session("codGrupo")
	rs.open sql, cnn
	
	if rs.eof = false then
		periodo_dinamico = rs("periodo_dinamico")
	end if 
	rs.close
	
	strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		
%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="1259"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td width="1259" colspan="2" align="center">
		<form id="frm" method="post">
		  <table width="708" border="0" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td width="700" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
          </table>
		  <br>
          <!--#include file="../includes/inc_ListaHistoricoMatriculaDatas.asp" -->
		  <table width="1255" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="142" class="texto1">&nbsp;</td>
            <td colspan="2"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10"></td>
          </tr>
          <tr bgcolor="#E5E5E5">
            <td height="19" colspan="3" class="texto1"><strong>Faixa et&aacute;ria  para Matr&iacute;cula na Educa&ccedil;&atilde;o Infantil</strong></td>
            </tr>

              <tr>
                <td height="22" class="texto1">Agrupamento I</td>
                <td colspan="2"><span class="texto1">
                  <input name="dt_inicial_I" type="text" class="text" id="dt_inicial_I" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=dt_inicial_I%>" style="cursor:hand" >
                </span><span class="texto1">
                a
                <input name="dt_final_I" type="text" class="text" id="dt_final_I" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=dt_final_I%>" style="cursor:hand" >
                </span></td>
              </tr>
              <tr>
                <td height="22" class="texto1">Agrupamento II</td>
                <td colspan="2"><span class="texto1">
                  <input name="dt_inicial_II" type="text" class="text" id="dt_inicial_II" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=dt_inicial_II%>" style="cursor:hand" >
                  </span><span class="texto1"> a
                    <input name="dt_final_II" type="text" class="text" id="dt_final_II" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=dt_final_II%>" style="cursor:hand" >
                  </span></td>
              </tr>
              <tr>
                <td height="22" class="texto1">Agrupamento III</td>
                <td colspan="2"><span class="texto1">
                  <input name="dt_inicial_III" type="text" class="text" id="dt_inicial_III" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=dt_inicial_III%>" style="cursor:hand" >
                  </span><span class="texto1"> a
                    <input name="dt_final_III" type="text" class="text" id="dt_final_III" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=dt_final_III%>" style="cursor:hand" >
                  </span></td>
              </tr>
              <tr>
                <td height="22" class="texto1">Agrupamento IV</td>
                <td colspan="2"><span class="texto1">
                  <input name="dt_inicial_IV" type="text" class="text" id="dt_inicial_IV" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=dt_inicial_IV%>" style="cursor:hand" >
                  </span><span class="texto1"> a
                    <input name="dt_final_IV" type="text" class="text" id="dt_final_IV" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=dt_final_IV%>" style="cursor:hand" >
                  </span></td>
              </tr>
              <tr>
                <td height="22" class="texto1">Agrupamento V</td>
                <td colspan="2"><span class="texto1">
                  <input name="dt_inicial_V" type="text" class="text" id="dt_inicial_V" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=dt_inicial_V%>" style="cursor:hand" >
                  </span><span class="texto1"> a
                    <input name="dt_final_V" type="text" class="text" id="dt_final_V" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=dt_final_V%>" style="cursor:hand" >
                  </span></td>
              </tr>
          <tr bgcolor="#E5E5E5">
            <td height="19" colspan="3" bgcolor="#FFFFFF" class="texto1">&nbsp;</td>
          </tr>
          <tr bgcolor="#E5E5E5">
            <td height="19" colspan="3" class="texto1"><strong>Faixa et&aacute;ria para Matr&iacute;cula no Ensino Fundamental</strong></td>
          </tr>
          <tr>
            <td height="22" class="texto1">1&ordm; a 9&ordm; ano</td>
            <td colspan="2"><span class="texto1">
            <input name="dt_inicial_ef" type="text" class="text" id="dt_inicial_ef" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=dt_inicial_ef%>" style="cursor:hand" >
            </span><span class="texto1"> a
            <input name="dt_final_ef" type="text" class="text" id="dt_final_ef" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=dt_final_ef%>" style="cursor:hand" >
            </span></td>
          </tr>
		  <tr>
            <td height="22" class="texto1">Dois Agrupamento<br>(regra especial)</td>
            <td colspan="2"><span class="texto1">
            <input name="dt_inicial_regra_especial" type="text" class="text" id="dt_inicial_regra_especial" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=dt_inicial_regra_especial%>" style="cursor:hand" >
            </span><span class="texto1"> a
            <input name="dt_final_regra_especial" type="text" class="text" id="dt_final_regra_especial" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=dt_final_regra_especial%>" style="cursor:hand" >
            </span></td>
          </tr>
          <tr>
            <td colspan="3" class="texto1">&nbsp;</td>
          </tr>
          <tr bgcolor="#E5E5E5">
            <td colspan="3" class="texto1"><strong>Valida&ccedil;&atilde;o do Per&iacute;odo</strong></td>
            </tr>
          <tr>
            <td height="22" class="texto1">Educa&ccedil;&atilde;o Infantil</td>
            <td colspan="2"><span class="texto1">
              <input name="dt_inicial_ei_V" type="text" class="text" id="dt_inicial_ei_V" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=dt_inicial_ei_V%>" style="cursor:hand" >
              </span><span class="texto1"> a
                <input name="dt_final_ei_V" type="text" class="text" id="dt_final_ei_V" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=dt_final_ei_V%>" style="cursor:hand" >
              </span></td>
          </tr>
          <tr>
            <td height="22" class="texto1">Ensino Fundamental</td>
            <td colspan="2"><span class="texto1">
              <input name="dt_inicial_ef_V" type="text" class="text" id="dt_inicial_ef_V" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=dt_inicial_ef_V%>" style="cursor:hand" >
              </span><span class="texto1"> a
                <input name="dt_final_ef_V" type="text" class="text" id="dt_final_ef_V" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=dt_final_ef_V%>" style="cursor:hand" >
              </span></td>
          </tr>
          <tr>
            <td class="texto1">&nbsp;</td>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr bgcolor="#E5E5E5">
            <td colspan="3" class="texto1"><strong>Valida&ccedil;&atilde;o de Idade M&iacute;nima </strong></td>
          </tr>
          <tr>
            <td height="22" class="texto1">Educa&ccedil;&atilde;o Infantil</td>
            <td colspan="2"><span class="texto1">
              <input name="dt_inicial_minima_ei" type="text" class="text" id="dt_inicial_minima_ei" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=dt_inicial_minima_ei%>" style="cursor:hand" >
            </span></td>
          </tr>
          <tr>
            <td height="22" class="texto1">Ensino Fundamental</td>
            <td colspan="2"><span class="texto1">
              <input name="dt_final_minima_ef" type="text" class="text" id="dt_final_minima_ef" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=dt_final_minima_ef%>" style="cursor:hand" >
            </span></td>
          </tr>
          <tr>
            <td class="texto1">&nbsp;</td>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td class="texto1">Per&iacute;odo dinamico</td>
            <td width="30" align="center"><input type="checkbox" value="S" name="periodo_dinamico" onClick="periodo()" id="periodo_dinamico" <%if periodo_dinamico="S" then response.write "checked"%>></td>
            <td width="1083"><span class="texto1">ap&oacute;s a matr&iacute;cula</span></td>
          </tr>
          <tr>
            <td colspan="3">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="3"> <!--#include file="../../includes/inc_botoes_cadastro.asp"--> </td>
          </tr>
          <tr>
            <td colspan="3">&nbsp;</td>
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