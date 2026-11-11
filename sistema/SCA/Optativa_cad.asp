<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Periodo
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css"></head>
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
		
		if (frm.txtAnoLetivo.value == "") {
			alert("O Ano Letivo Deverá ser Informado !");
			frm.cmbCurso.focus();
			return false;
		}

		if (frm.cmbSemestre.value == "0") {
			alert("O Semestre deverá ser informado !");
			frm.cmbSemestre.focus();
			return false;
		}
		
		if (frm.cmbCurso.value == "0") {
			alert("O Curso Deverá ser informado !");
			frm.cmbCurso.focus();
			return false;
		}

		if (frm.cmbPeriodo.value == "0") {
			alert("O Periodo Deverá ser informado !");
			frm.cmbPeriodo.focus();
			return false;
		}

		if (frm.cmbDisciplinaCurso.value == "0") {
			alert("A Disciplina Deverá ser informada !");
			frm.cmbDisciplinaCurso.focus();
			return false;
		}
		
		frm.action="Optativa_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<%
	strPaginaTitulo 		= "Optativa_cad.asp"
	strExecutarSubmitCurso 	= "S"
	strExecutarSubmitPeriodo = "S"
	
	if Trim(Request("txtAnoLetivo")) = "" then 
	   intAnoLetivo = session("strAnoLetivo")
	else    
	   intAnoLetivo =  Trim(Request("txtAnoLetivo"))
	end if   
	if Trim(Request("cmbSemestre")) = "0" then 
	   intSemestre = session("strSemestre")
	else
	   intSemestre = Trim(Request("cmbSemestre"))
	end if   

    intCodigo						= Trim(Request.Form("txtCodigo"))
	intCodCurso						= Trim(Request("cmbCurso"))
	intCodPeriodo					= Trim(Request.Form("cmbPeriodo"))
	intCodDisciplinaCurso			= Trim(Request.Form("cmbDisciplinaCurso"))
		
	if trim(intCodigo) <> "" then
	
		sql = "SELECT Cod_Optativa, Ano_Letivo, Semestre_Letivo, Cod_Curso, Cod_Periodo, Cod_Disciplina"
		sql = sql & " FROM SCA_OPTATIVAS"
		sql = sql & " where Cod_Empresa = " & Session("CodEmpresa")			
		sql = sql & " and 	Cod_Optativa = " & intCodigo
		rs.open sql, cnn
		if rs.eof = false then
			
			intCodOptativa	 		= rs("Cod_Optativa")
			intAnoLetivo	 		= rs("Ano_Letivo")
			intSemestre	 			= rs("Semestre_Letivo")
			intCodCurso				= rs("Cod_Curso")
			if intCodPeriodo = "0" then
			   intCodPeriodo			= rs("Cod_Periodo")
			end if   
			intCodDisciplinaCurso	= rs("Cod_Disciplina")
			
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
	<table width="928"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td width="928" colspan="2" align="center">
		<form id="frm" method="post" action="Optativa_cad.asp">
		  <table width="708" border="0" cellpadding="0" cellspacing="0">

            <tr valign="top">
              <td width="700" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
          </table>
		  <br>
		  <table width="896" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="113" height="23" class="texto1">Ano Letivo: </td>
            <td width="783"><input onBlur="submit()" name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo"  value="<%=intAnoLetivo%>" size="5" maxlength="4" onKeyPress="return formataCampo(this,2,4)"></td>
          </tr>
          <tr>
            <td height="23" class="texto1">Semestre:</td>
            <td><!--#include file="../includes/inc_cmdSemestreTodos.asp" --></td>
          </tr>
          <tr>
            <td height="23" class="texto1">Curso:</td>
            <td><!--#include file="../includes/inc_cmdCurso.asp" --></td>
          </tr>
          <tr>
            <td height="23" class="texto1">Periodo:</td>
            <td><!--#include file="../includes/inc_cmdPeriodo.asp" --></td>
          </tr>
          <tr>
            <td height="23" class="texto1">Disciplina:</td>
            <td><!--#include file="../includes/inc_cmdDisciplinaCurso.asp" --></td>
          </tr>
          
          
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
          </tr>
          <input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
          <tr>
            <td colspan="2"><%
			cont =0
			if intCodCurso = "" then intCodCurso = 0
			if intCodCurso <> "0" then
				sql = " SELECT op.Cod_Optativa, op.Ano_Letivo, op.Semestre_Letivo, op.Cod_Curso, di.Desc_Disciplina, p.descricao "
				sql = sql & " FROM sca_optativas op "
				sql = sql & " inner join sca_disciplina di on di.Cod_Disciplina = op.Cod_Disciplina and di.cod_empresa = op.cod_empresa "
				sql = sql & " inner join sca_periodo p on p.cod_periodo = op.cod_periodo and p.cod_empresa = op.cod_empresa "
				sql = sql & " WHERE op.Cod_Empresa = " & Session("CodEmpresa")
				sql = sql & " ORDER BY op.Ano_Letivo, op.Semestre_Letivo, di.Desc_Disciplina"
				rs.open sql, cnn
								
				if rs.eof = false then
				%>
					<table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
					  <tr bgcolor="#E5E5E5">
						<td width="6%" class="celula"><strong>Ano</strong></td>
						<td width="11%" class="celula"><strong>Semestre<span class="TextoForm"></span></strong></td>
						<td width="62%" class="celula"><strong>Disciplina</strong></td>
						<td width="21%" height="21" class="celula"><strong>Per&iacute;odo</strong></td>
					  </tr>
					  <%
						while not rs.eof
							cont = cont + 1	
							%>
						  <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Cod_Optativa")%>')">
							<td class="celula">&nbsp;<%=rs("Ano_Letivo")%></td>
							<td class="celula">&nbsp;<%=trim(rs("Semestre_Letivo"))%></td>
							<td class="celula">&nbsp;<%=trim(rs("Desc_Disciplina"))%></td>
							<td height="20" class="celula">&nbsp;<%=trim(rs("descricao"))%></td>
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
				  rs.close
			end if
		  %>		  </td>
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