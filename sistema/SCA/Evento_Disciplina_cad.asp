<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 08/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Regime 
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
		
		if (frm.cmbCurso.value == "0") {
			alert("O Curso deve ser informado !");
			frm.cmbCurso.focus();
			return false;
		}
		if (frm.cmbGradeagrupamento.value == "0") {
			alert("O Agrupamento deve ser informado !");
			frm.cmbGradeagrupamento.focus();
			return false;
		}
		if (frm.cmbDisciplinaCurso.value == "0") {
			alert("A Disciplina deve ser informada !");
			frm.cmbDisciplinaCurso.focus();
			return false;
		}
		if (frm.txtCargaHoraria.value == "") {
			alert("A Carga Horária deve ser informada !");
			frm.txtCargaHoraria.focus();
			return false;
		}
		
		frm.action="Evento_Disciplina_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<%
	strPaginaTitulo = "Evento_Disciplina_cad.asp"
    strExecutarSubmitCurso = "S"
	strExecutarSubmitGradeCurricularGrupos = ""
	
	intCodigo	       		    = Trim(Request.Form("txtCodigo"))
	intCodCurso     			= Trim(Request.Form("cmbCurso"))
	intCodDisciplinaCurso     	= Trim(Request.Form("cmbDisciplinaCurso"))
	strCargaHoraria	        	= Trim(Request.Form("txtCargaHoraria"))
	intCodGradeagrupamento 		= Trim(Request.Form("cmbGradeagrupamento"))
	
	if intCodCurso = "" then
	   intCodCurso = "0"
	end if
	if intCodDisciplinaCurso = "" then
	   intCodDisciplinaCurso = "0"
	end if
		
	if intCodigo <> "" then	
		sql = "SELECT CODIGO, COD_CURSO, COD_DISCIPLINA, CARGA_HORARIA, COD_AGRUPAMENTO"
		sql = sql & " FROM SCA_EVENTO_DISCIPLINA"
		sql = sql & " WHERE COD_EMPRESA = " & Session("CodEmpresa")			
		sql = sql & " AND CODIGO = " & intCodigo		
		rs.open sql, cnn
		if rs.eof = false then
			intCodigo 			            = rs("CODIGO")
			intCodCurso     			    = rs("COD_CURSO")
			intCodGradeagrupamento          = rs("COD_AGRUPAMENTO")
			intCodDisciplinaCurso 			= rs("COD_DISCIPLINA")
			strCargaHoraria			        = rs("CARGA_HORARIA")
	
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
		else
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		end if 
		rs.close
	end if	
%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="896"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td width="896" colspan="2" align="center">
		<form id="frm" method="post">
		  <table width="708" border="0" cellpadding="0" cellspacing="0">

            <tr valign="top">
              <td width="700" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
          </table>
		  <br>
		  <table width="873" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="texto1">Curso:</td>
            <td><!--#include file="../includes/inc_cmdCurso.asp" --></td>
          </tr>
          <tr>
             <td class="texto1">Grupo da Grade:</td>
             <td><!--#include file="../includes/inc_cmdGradeCurricularGrupos.asp"--></td>
          </tr>
          <tr>
            <td width="130" class="texto1">Disciplina:</td>
            <td width="743"><!--#include file="../includes/inc_cmdDisciplinaCurso.asp" --></td>
          </tr>
          <tr>
            <td class="texto1">Carga Hor&aacute;ria:</td>
            <td class="texto1"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10"><input name="txtCargaHoraria" type="text" class="text" id="txtCargaHoraria" onKeyPress="return formataCampo(this, 2, 6)"  size="5" maxlength="5" value="<%=strCargaHoraria%>"></td>
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
            <td colspan="2">&nbsp;</td>
          </tr>

          <tr>
            <td colspan="2"><%
			cont =0
			sql = "SELECT ED.CODIGO, COD_CURSO, ED.COD_DISCIPLINA, ED.CARGA_HORARIA, D.DESC_DISCIPLINA, ED.COD_AGRUPAMENTO"
	        sql = sql & " FROM SCA_EVENTO_DISCIPLINA ED"
	        sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA = ED.COD_DISCIPLINA AND D.COD_EMPRESA = ED.COD_EMPRESA "
	        sql = sql & " WHERE ED.COD_EMPRESA = " & Session("CodEmpresa")			
	        sql = sql & " AND COD_CURSO = " & intCodCurso		
			sql = sql & " Order by D.DESC_DISCIPLINA"
			rs.open sql, cnn
			if rs.eof = false then
			%>
                <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td width="8%" class="celula"><strong>C&oacute;digo </strong></td>
                    <td width="56%" height="21" class="celula"><strong>Descri<span class="TextoForm">&ccedil;&atilde;o</span></strong></td>
                    <td width="18%" height="21" class="celula"><strong>Carga Hor&aacute;ria</strong></td>
                    <td width="18%" class="celula"><strong>Agrupamento</strong></td>
                  </tr>
                  <%
				while not rs.eof
					cont = cont + 1	
					%>
                  <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("CODIGO")%>')">
                    <td class="celula"><%=rs("COD_DISCIPLINA")%>&nbsp;</td>
                    <td height="20" class="celula"><%=trim(rs("DESC_DISCIPLINA"))%>&nbsp;</td>
                    <td height="20" class="celula"><%=trim(rs("CARGA_HORARIA"))%>&nbsp;</td>
                    <td height="20" class="celula"><%=trim(rs("COD_AGRUPAMENTO"))%>&nbsp;</td>
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