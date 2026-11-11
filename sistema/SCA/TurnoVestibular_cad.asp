<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 08/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Turno 
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
			alert("O Turno deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}

		if (frm.cmbCursoPrimeiraOpcao.value == "0") {
			alert("O Curso deve ser informado !");
			frm.cmbCursoPrimeiraOpcao.focus();
			return false;
		}
		
		frm.action="TurnoVestibular_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<%
	strPaginaTitulo = "TurnoVestibular_cad.asp"

	intCodTurno	 				= Trim(Request.Form("txtCodigo"))
	strDescricao 				= Trim(Request.Form("txtDescricao"))
	intCodCursoPrimeiraOpcao  	= Trim(Request("cmbCursoPrimeiraOpcao"))
		
	if trim(intCodTurno) <> "" then
	
		sql = "SELECT COD_TURNO, DESC_TURNO, COD_CURSO "
		sql = sql & " FROM SCA_TURNO_VESTIBULAR"
		sql = sql & " Where COD_TURNO = " & intCodTurno
		sql = sql & " and cod_empresa = " & Session("CodEmpresa")			
		
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodTurno	 			= rs("COD_TURNO")
			strDescricao			= rs("DESC_TURNO")
			intCodCursoPrimeiraOpcao= rs("COD_CURSO")
			
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
            <td height="20" class="texto1">Curso:</td>
            <td><!--#include file="../includes/inc_cmdCursoPrimeraOpcao.asp" --></td>
          </tr>
          <tr>
            <td height="20" width="101" class="texto1">Turno :</td>
            <td width="602"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodTurno%>" maxlength="10">
               <input name="txtCodCurso" type="hidden" class="text" id="txtCodCurso" size="40" maxlength="40" value="<%=intCodCursoPrimeiraOpcao%>">
               <input name="txtDescricao" type="text" class="text" id="txtDescricao" size="40" maxlength="40" value="<%=strDescricao%>"></td>
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
			sql = "SELECT SCA_TURNO_VESTIBULAR.COD_TURNO, SCA_TURNO_VESTIBULAR.DESC_TURNO, .SCA_CURSO.Desc_Abreviada "
			sql = sql & " FROM SCA_TURNO_VESTIBULAR"
			sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.COD_CURSO = SCA_TURNO_VESTIBULAR.COD_CURSO"
			sql = sql & " where SCA_TURNO_VESTIBULAR.cod_empresa = " & Session("CodEmpresa")			
			sql = sql & " Order by SCA_TURNO_VESTIBULAR.COD_TURNO"
			rs.open sql, cnn
							
			if rs.eof = false then
			%>
                <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td width="14%" class="celula"><strong>C&oacute;d. Turno </strong></td>
                    <td width="43%" height="21" class="celula"><strong>Curso</strong></td>
                    <td width="43%" class="celula"><strong><span class="TextoForm"><strong>Descri&ccedil;&atilde;o</strong></span></strong></td>
                  </tr>
                  <%
				while not rs.eof
					cont = cont + 1	
					%>
                  <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("COD_TURNO")%>')">
                    <td class="celula"><%=rs("COD_TURNO")%></td>
                    <td height="20" class="celula"><%=trim(rs("Desc_Abreviada"))%></td>
                    <td height="20" class="celula"><%=trim(rs("DESC_TURNO"))%></td>
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