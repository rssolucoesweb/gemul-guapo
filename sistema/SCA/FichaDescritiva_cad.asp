<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 10/01/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Ficha descritiva
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
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
<script>
	function abrePerguntas(){
		window.open("FichaDescritivaPergunta_cad.asp?CodFichaDescritivao="+frm.txtCodigo.value,"consulta", "top=0,left=0,height=600,width=800,menubar=no,toolbar=no,scrollbars=yes,status=yes");
		return true;
	}
	
	function resultadoConsulta(intCodigo){
	
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
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
	
		if (frm.txtDescricao.value == "") {
			alert("A Descrição da Avaliação deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
	
		if (frm.cmbSituacao.value == "0") {
			alert("A Situação deve ser informada !");
			frm.cmbSituacao.focus();
			return false;
		}
		
		frm.action="FichaDescritiva_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<%
	strExecutarSubmit				= "S"
    strSimouNao_submit           	= "N"
	strMostraPerguntas				= "S"
	strPaginaTitulo 				= "FichaDescritiva_cad.asp"

	intCodigo						= Trim(Request.Form("txtCodigo"))
	intAnoLetivo					= Trim(Request.Form("txtAnoLetivo"))
	intSemestre 					= Trim(Request.Form("txtSemestre"))
	strDescricao 					= Trim(Request.Form("txtDescricao"))
	strSituacao						= Trim(Request.Form("cmbSituacao"))
	intCodTipoEmpresa 				= Trim(Request.Form("cmbTipoEmpresa"))
    strObservacao	                = Trim(Request.Form("txtObservacao"))
    strRodape	                    = Trim(Request.Form("txtRodape"))
	strSimouNao         			= Trim(Request.Form("cmbSimouNao"))
	
	if trim(intCodigo) <> "" then
	
		sql = "SELECT Codigo, Cod_empresa, Descricao, Ano_Letivo, Semestre, "
		sql = sql & " Situacao, CodTipoEmpresa , observacoes, rodape, Publicar "
		sql = sql & " FROM SCA_FICHA_DESCRITIVA"
		sql = sql & " Where Codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			intCodigo	 			= rs("Codigo")
			strDescricao			= rs("Descricao")
			intAnoLetivo			= rs("Ano_Letivo")
			intSemestre				= rs("Semestre")
			strSituacao				= rs("Situacao")
			intCodTipoEmpresa		= rs("CodTipoEmpresa")
			strObservacao			= rs("Observacoes")
			strRodape				= rs("Rodape")
			strSimouNao				= rs("Publicar")
			
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			strDesabilitaPerguntas	= "" 'Desabilita o botão Excluir

		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaPerguntas	= "disabled" 'Desabilita o botão Excluir
	end if 
	%>
	<form id="frm" method="post">
        <table width="98%" border="0" cellpadding="0" bgcolor="#FFFFFF" align="center"W cellspacing="0">
        <tr valign="top">
          <td align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
        </tr>
        </table>
        <br>
		<table width="98%" border="0" align="center" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" >
          <tr>
            <td width="24%" height="28" class="texto1">Ano/Semestre:</td>
            <td width="76%" ><input name="txtAnoLetivo" value="<%=intAnoLetivo%>" onKeyPress="return formataCampo(this, 2, 6)"  type="text" class="text" id="txtAnoLetivo" size="4" maxlength="4">	
			  /
			  <input name="txtSemestre" value="<%=intSemestre%>" onKeyPress="return formataCampo(this, 2, 6)"  type="text" class="text" id="txtSemestre" size="3" maxlength="1">            </td>
          </tr>
          <tr>
            <td height="28" class="texto1">Descri&ccedil;&atilde;o  :</td>
            <td><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
              <input name="txtDescricao" type="text" class="text" id="txtDescricao" size="100" maxlength="100" value="<%=strDescricao%>"></td>
          </tr>
              <tr>
                <td height="28"><p class="texto1">Publicar Question&aacute;rio? </p>                </td>
                <td class="TextoForm"><!--#include file="../includes/inc_cmbSimouNao.asp"--></td>
              </tr>
          <tr>
            <td height="28" class="texto1">Situa&ccedil;&atilde;o:</td>
            <td><span class="texto1">
              <!--#include file="../includes/inc_cmdSituacao.asp" -->
            </span></td>
          </tr>
		  <tr>
		    <td height="13" class="texto1">Tipo Empresa:</td>
		    <td><span class="titulo1">
		      <!--#include file="../includes/inc_cmbTipoEmpresa.asp"-->
		    </span></td>
	      </tr>
		  <tr>
            <td height="93" class="texto1"><p>Observa&ccedil;&otilde;es com m&aacute;ximo de 3000 caracteres: </p></td>
            <td><textarea name="txtObservacao" cols="90" rows="5" class="text" id="txtObservacao"><%=strObservacao%></textarea>            </td>
          </tr>
          <tr>
            <td height="65" class="texto1">Rodap&eacute; com M&aacute;ximo 200 caracteres:</td>
            <td><textarea name="txtRodape" cols="90" rows="3" class="text" id="txtRodape"><%=strRodape%></textarea>            </td>
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
            <td colspan="2">
			<%
			cont =0
			
			sql = "SELECT Codigo, Cod_empresa, Descricao, Ano_Letivo, Semestre, Situacao, Publicar"
			sql = sql & " FROM SCA_FICHA_DESCRITIVA"
			if strCompartilharDados = "S" then
				sql = sql & " WHERE Cod_grupo = " & Session("CodGrupo")	
			else   
				sql = sql & " WHERE cod_empresa=" & Session("CodEmpresa")
			end if   
			sql = sql & " Order by Ano_Letivo, Semestre, Descricao"
				
			rs.open sql, cnn
							
			if rs.eof = false then
			%>
                <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                <tr bgcolor="#E5E5E5">
                    <td width="10%" height="21" class="celula"><strong>C&oacute;digo</strong></td>
                    <td width="9%" align="center" class="celula"><strong>Ano/Semestre</strong></td>
                    <td width="66%" class="celula"><strong>Descri<span class="TextoForm">&ccedil;&atilde;o</span></strong></td>
                    <td width="7%" align="center" class="celula"><strong>Situa&ccedil;&atilde;o<span class="TextoForm"></span></strong></td>
                    <td width="8%" align="center" class="celula"><strong>Publicado</strong></td>
                </tr>
                <%
				while not rs.eof
					cont = cont + 1	
					
					  if rs("Situacao") = "A" then strSituacao = "Ativo" 
					  if rs("Situacao") = "I" then strSituacao = "Inativo" 
                      if not isnull(rs("Publicar")) then
					  	if rs("Publicar") = "S" then strPublicar = "Sim" 
					  	if rs("Publicar") = "N" then strPublicar = "N&atilde;o"
					  else	
					  	strPublicar = "" 
					  end if	
					%>
                  	<tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
                    <td class="celula"><%=rs("Codigo")%></td>
                    <td class="celula"><%=trim(rs("Ano_Letivo"))%> / <%=trim(rs("Semestre"))%>&nbsp;</td>
                    <td class="celula"><%=trim(rs("Descricao"))%>&nbsp;</td>
                    <td height="21" align="center" class="celula"><%=trim(strSituacao)%>&nbsp;</td>
                  	<td height="21" align="center" class="celula"><%=trim(strPublicar)%>&nbsp;</td>
                  	</tr>
                  	<%				
					rs.movenext
					wend
				  %>
                  <tr>
                  <td height="21" colspan="5" class="celula">Total Registros : <%=cont%></td>
                  </table>
              <%
			  end if
			  rs.close%>              </td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
        </table>

</form>
<!--#include file="../rodape.asp"-->
</body>
</html>