<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 25/03/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Estágio 
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
		
		if (frm.txtAnoLetivo.value == "") {
			alert("A Ano Letivo deve ser informado !");
			frm.txtAnoLetivo.focus();
			return false;
		}
		
		if (frm.cmbSemestre.value == "0") {
			alert("O Semestre deve ser informado !");
			frm.cmbSemestre.focus();
			return false;
		}
		
		if (frm.txtDescricao.value == "") {
			alert("A Projeto Social deve ser informado !");
			frm.txtDescricao.focus();
			return false;
		}
		
		if (frm.cmbProfessor.value == "") {
			alert("O Orientador deve ser informado !");
			frm.cmbProfessor.focus();
			return false;
		}
		
		frm.action="Estagio_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<%
	strPaginaTitulo 	= "Estagio_cad.asp"
	intCodEstagio 		= Trim(Request.Form("txtCodigo"))
	strAnoLetivo 		= Trim(Request.Form("txtAnoLetivo"))
	intSemestre 		= Trim(Request.Form("cmbSemestre"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	intCodProfessor     = Trim(Request("cmbProfessor"))
	
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")

		
	if trim(intCodEstagio) <> "" then
	
		sql = "SELECT Codigo, cod_empresa, Ano, Semestre, Descricao, Cod_Colaborador "
		sql = sql & " FROM SCA_ESTAGIO"
		sql = sql & " where Cod_empresa = " & Session("CodEmpresa")			
		sql = sql & " and Codigo = " & intCodEstagio
		rs.open sql, cnn
		
		if rs.eof = false then
			intCodEstagio				= rs("Codigo")
			strAnoLetivo	 			= rs("Ano")
			intSemestre			   		= rs("Semestre")
			strDescricao			    = rs("Descricao")
			intCodProfessor			    = rs("Cod_Colaborador")
			
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
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td colspan="2">
        
       		<form id="frm" method="post">
		  <br>
		  <table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td colspan="2" align="center" class="texto1"><span class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></span></td>
            </tr>
          <tr>
            <td width="12%" class="texto1">&nbsp;</td>
            <td width="88%"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodEstagio%>" maxlength="10">              </td>
          </tr>
          <tr>
            <td height="25" class="texto1">Ano Letivo:</td>
            <td><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
          </tr>
          <tr>
            <td height="29" class="texto1">Semestre:</td>
            <td><span class="texto1">
              <!--#include file="../includes/inc_cmdSemestre.asp" -->
            </span></td>
          </tr>
          <tr>
            <td height="29" class="texto1">Orientador:</td>
            <td><!--#include file="../includes/inc_cmdProfessor.asp" --></td>
          </tr>
          <tr>
            <td height="29" class="texto1">Descri&ccedil;&atilde;o do Grupo:</td>
            <td><input name="txtDescricao" type="text" class="text" id="txtDescricao" size="40" maxlength="40" value="<%=strDescricao%>"></td>
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
			
			sql = "SELECT E.Codigo, E.cod_empresa, E.Ano, E.Semestre, E.Descricao, C.nome as Orientador "
			sql = sql & " FROM SCA_ESTAGIO E"
			sql = sql & " LEFT JOIN SRH_COLABORADOR C ON C.CODIGO = E.COD_COLABORADOR " 
			sql = sql & " where E.Cod_empresa = " & Session("CodEmpresa")		
			sql = sql & " Order by E.Descricao"	
			rs.open sql, cnn
							
			if rs.eof = false then
			     %>
                <table width= "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td width="5%"  class="celula"><strong>C&oacute;d. </strong></td>
                    <td width="60%" class="celula"><strong>Descri<span class="TextoForm">&ccedil;&atilde;o do Grupo</span></strong></td>
                    <td width="35%" height="21" class="celula"><strong>Orientador<span class="TextoForm"></span></strong></td>
                  </tr>
                  <%
				while not rs.eof
					cont = cont + 1	
					%>
                  <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
                    <td class="celula"><%=rs("Codigo")%>&nbsp;</td>
                    <td class="celula"><%=trim(rs("Descricao"))%>&nbsp;</td>
                    <td height="20" class="celula"><%=trim(rs("Orientador"))%>&nbsp;</td>
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
		   %>           </td>
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