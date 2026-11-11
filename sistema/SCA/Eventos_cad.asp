<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 06/08/2008
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Eventos 
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
	
	function resultadoConsulta(intCodigo){
	
		var frm = document.getElementById("frm");
		
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmbCurso.value == "0"){
			alert("O Curso deve ser informado.");
			frm.cmbCurso.focus();
			return false;
		}	
		
		if (frm.txtAnoLetivo.value == ""){
			alert("O Ano Letivo deve ser informado.");
			frm.txtAnoLetivo.focus();
			return false;
		}
		
		if (frm.txtSemestre.value == ""){
			alert("O Semestre deve ser informado.");
			frm.txtSemestre.focus();
			return false;
		}
		
		if (frm.txtCargaHoraria.value == ""){
			alert("A Carga Horaria deve ser informada.");
			frm.txtCargaHoraria.focus();
			return false;
		}	
		
		if (frm.txtEvento.value == ""){
			alert("A Descrição do evento deve ser informada.");
			frm.txtEvento.focus();
			return false;
		}				
		
		if (frm.txtDataInicial.value == ""){
			alert("A Data Inicial do evento deve ser informada.");
			frm.txtDataInicial.focus();
			return false;
		}	
		
		if (frm.txtDataFinal.value == ""){
			alert("A Data Final do evento deve ser informada.");
			frm.txtDataFinal.focus();
			return false;
		}	
		
		if (frm.cmbSituacao.value == "0"){
			alert("A Situação deve ser informada.");
			frm.cmbSituacao.focus();
			return false;
		}	
		
		frm.action= "Eventos_cod.asp?acao=" + acao;
		frm.submit();
		return true;	 
 	}
</script>
<%
	strExecutarSubmitCurso	  = "S"
	strPaginaTitulo 		= "Eventos_cad.asp"
	intCodEmp				= Session("CodEmpresa")
	intCodigo		    	= Trim(Request.Form("txtCodigo")) 
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intAnoLetivo			= Trim(Request.Form("txtAnoLetivo"))
	intSemestre 			= Trim(Request.Form("txtSemestre"))
	intCargaHoraria			= Trim(Request.Form("txtCargaHoraria"))
	strEvento			 	= Trim(Request.Form("txtEvento"))
	strDataInicial			= Trim(Request.Form("txtDataInicial"))
	strDataFinal			= Trim(Request.Form("txtDataFinal"))
	strSituacao				= Trim(Request.Form("cmbSituacao"))
	
	if intCodCurso 			= "" then intCodCurso 		= "0" 
	
	if intCodigo <> "" then
	
		sql = "SELECT Codigo, Cod_Empresa, Cod_Curso, Ano_Letivo, Semestre, "
		sql = sql & " CargaHoraria, Evento, DataInicial, DataFinal, Situacao"
		sql = sql & " FROM SCA_SEMINARIO_EVENTO"
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
		sql = sql & " and Codigo = " & intCodigo
		rs.open sql, cnn

		if rs.eof = false then
		
			intCodigo		    	= rs("Codigo")
			intCodCurso	 			= rs("Cod_Curso")
			intAnoSemestre 			= rs("Ano_Letivo")
			intSemestre 			= rs("Semestre")
			intCargaHoraria			= rs("CargaHoraria")
			strEvento			 	= rs("Evento")
			strDataInicial			= rs("DataInicial")
			strDataFinal			= rs("DataFinal")
			strSituacao				= rs("Situacao")
		
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
            <td width="147" class="texto1">&nbsp;</td>
            <td width="556"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Curso:</td>
            <td><span class="texto1">
              <!--#include file="../includes/inc_cmdCurso.asp"-->
            </span></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Ano/Semestre:</td>
            <td class="texto"><input name="txtAnoLetivo" value="<%=intAnoSemestre%>" onKeyPress="return formataCampo(this, 2, 6)"  type="text" class="text" id="txtAnoLetivo" size="4" maxlength="4"> 
              /
            <input name="txtSemestre" value="<%=intSemestre%>" onKeyPress="return formataCampo(this, 2, 6)"  type="text" class="text" id="txtSemestre" size="3" maxlength="1"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">C.H : </td>
            <td><input name="txtCargaHoraria" value="<%=intCargaHoraria%>" onKeyPress="return formataCampo(this, 2, 6)"  type="text" class="text" id="txtCargaHoraria" size="5" maxlength="5"></td>
          </tr>
          <tr>
            <td height="26" class="texto1">Evento : </td>
            <td><input name="txtEvento" value="<%=strEvento%>" type="text" class="text" id="txtEvento" size="50" maxlength="100"></td>
          </tr>
          <tr>
            <td height="24" class="texto1">Vig&ecirc;ncia do Evento: </td>
            <td><span class="texto1">
              <input name="txtDataInicial" type="text" class="text" id="txtDataInicial" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataInicial%>" title="Click aqui para visualizar o calend&aacute;rio">
              &agrave; 
              <input name="txtDataFinal" type="text" class="text" id="txtDataFinal" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataFinal%>" title="Click aqui para visualizar o calend&aacute;rio">
            </span></td>
          </tr>
          <tr>
            <td class="texto1">Situa&ccedil;&atilde;o:</td>
            <td><span class="texto1">
              <!--#include file="../includes/inc_cmdSituacao.asp"-->
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
			cont =0
			
			sql = "SELECT Codigo, Cod_Empresa, Cod_Curso, Ano_Letivo, Semestre, "
			sql = sql & " CargaHoraria, Evento, DataInicial, DataFinal"
			sql = sql & " FROM SCA_SEMINARIO_EVENTO"
			sql = sql & " Where Cod_empresa = " & Session("CodEmpresa")	
		    sql = sql & " and Cod_curso = " & intCodCurso	
			sql = sql & " Order by 	Ano_Letivo, Semestre, evento"	
			rs.open sql, cnn
							
			if rs.eof = false then
			%>
              <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                <tr bgcolor="#E5E5E5">
                  <td width="9%" class="celula"><strong>C&oacute;digo</strong></td>
                  <td width="73%" class="celula"><strong><span class="TextoForm">Evento</span></strong></td>
                  <td width="18%" height="21" align="center" class="celula"><strong><span class="TextoForm"> Ano/Semestre </span></strong></td>
                  </tr>
                <%
					while not rs.eof
						cont = cont + 1	
						%>
						<tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
							<td class="celula"><%=rs("Codigo")%></td>
							<td class="celula"><%=trim(rs("Evento"))%></td>
							<td height="20" align="center" class="celula"><%=trim(rs("Ano_Letivo"))%>/<%=trim(rs("Semestre"))%></td>
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
			  rs.close
			  %>
			 </td>
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