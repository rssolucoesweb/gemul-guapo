<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 2/04/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Ata
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body>
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnnDocumento.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../js/Calendario/Calendario.asp"-->
<!--include file="../fckeditor/fckeditor.asp" -->
<script src="../ckeditor/ckeditor.js"></script>
<script src="../ckeditor/config.js"></script>
<script>

	function resultadoConsulta(intCodigo){
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	function salvar(acao){
		
		if (frm.cmbDepartamento.value == "0") {
			alert("O  Departamento deve ser informado !");
			frm.cmbDepartamento.focus();
			return false;
		}
		
		if (frm.txtAssunto.value == "") {
			alert("O  Assunto deve ser informado !");
			frm.txtAssunto.focus();
			return false;
		}
		
		if (frm.txtDescricao.value == "") {
			alert("A Descrição deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		
		if (frm.txtDataAta.value == "") {
			alert("A Data da Ata deve ser informada !");
			frm.txtDataAta.focus();
			return false;
		}
		
		if (frm.txtAnoLetivo.value == "") {
			alert("O Ano Letivo deve ser informado !");
			frm.txtAnoLetivo.focus();
			return false;
		}
		
		if (frm.cmbSemestre.value == "0") {
			alert("O Semestre deve ser informado !");
			frm.cmbSemestre.focus();
			return false;
		}
		
		frm.action="Ata_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<%
	strPaginaTitulo 		= "Ata_cad.asp"
	strExecutarSubmitDepto	= "S"
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	strAssunto 				= Trim(Request.Form("txtAssunto"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	strDataAta 				= Trim(Request.Form("txtDataAta"))
	strTextoAta 			= Trim(Request.Form("txtTextoAta"))
	intCodDepartamento		= Trim(Request.Form("cmbDepartamento"))
	
	if Trim(Request.Form("txtAnoLetivo")) <> "" then
	   strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	else
	   strAnoLetivo = session("strAnoLetivo")   
	end if   

	intSemestre		= Trim(Request.Form("cmbSemestre"))
	
	
	if TRIM(Session("NivelPermissao")) = "A" then
	   strMostraSomenteDeptoAtual = "" 'mostra todos os deptos
    else   
	   strMostraSomenteDeptoAtual = "S" 'mostra somente o depto atual
	end if	
	
	if intCodDepartamento = "" then  intCodDepartamento = "0"
		
	if trim(intCodigo) <> "" then
	
		sql = "SELECT Codigo, Cod_empresa, cod_departamento, Assunto, descricao, data, TextoAta, AnoLetivo , Semestre	"
		sql = sql & " FROM SCA_ATA"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And Cod_empresa = " & session("codEmpresa")
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 			= rs("codigo")
			strAssunto 				= rs("Assunto")
			strDescricao 			= rs("descricao")
			strDataAta 				= formatadataAP(rs("data"))
			strTextoAta				= rs("TextoAta")
			intCodDepartamento		= rs("cod_departamento")
			strAnoLetivo			= rs("AnoLetivo")
			intSemestre				= rs("Semestre")
			
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
		else
			
				
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir

		
		end if 
		rs.close
	else
	
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 
	
	if trim(strDataAta) = "" then strDataAta = formatadataAP(date)
%>
<table width="100%" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr>
    <td>
    <form id="frm" method="post">
    	
		<table width="98%" border="0"  align="center" class="CorFundo" cellpadding="0" cellspacing="0">
          <tr>
            <td colspan="2" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%>&nbsp;</td>
            </tr>
          <tr>
            <td width="12%" class="texto1">&nbsp;</td>
            <td width="88%"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10"></td>
          </tr>
          <tr>
            <td class="texto1"><strong>Departamento :</strong></td>
            <td><!--#include file="../includes/inc_cmdDepartamento.asp" --></td>
          </tr>
          <tr>
            <td class="texto1">Assunto:</td>
            <td><input name="txtAssunto" type="text" class="text" id="txtAssunto" size="40" maxlength="40" value="<%=strAssunto%>"></td>
          </tr>
          <tr>
            <td class="texto1">Descri&ccedil;&atilde;o:</td>
            <td><input name="txtDescricao" type="text" class="text" id="txtDescricao" size="40" maxlength="40" value="<%=strDescricao%>"></td>
          </tr>
          <tr>
            <td class="texto1">Data Ata:</td>
            <td><input name="txtDataAta" type="text" class="text" id="txtDataAta" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataAta%>"  title="Click aqui para visualizar o calend&aacute;rio"></td>
          </tr>
          <tr>
            <td class="texto1">Ano Letivo:</td>
            <td><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
          </tr>
          <tr>
            <td class="texto1">Semestre:</td>
            <td><!--#include file="../includes/inc_cmdSemestre.asp"--></td>
          </tr>
          <tr>
            <td colspan="2" class="texto1">&nbsp;</td>
          </tr>
          <tr>
            <td height="19" colspan="2" align="center" bgcolor="#CCCCCC" class="texto1"><strong>Texto da Ata </strong></td>
          </tr>
          <tr>
            <td colspan="2" class="texto1">
            <%
				''Dim oFCKeditor
				''Set oFCKeditor = New FCKeditor
				''oFCKeditor.BasePath	="../../Sistema/fckeditor/"
				''oFCKeditor.Config("DefaultLanguage") = "pt-br"
				''oFCKeditor.Value = strTextoAta
				'oFCKeditor.Width = 540
				''oFCKeditor.Height = 500
				''oFCKeditor.Create "txtTextoAta"
			%>
               <Textarea class="ckeditor" cols="80" rows="20" id="txtTextoAta" name="txtTextoAta"><%=strTextoAta%></textarea> 
            </td>
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
			
			sql = "SELECT Codigo, Cod_empresa, Assunto, descricao, data, TextoAta"
			sql = sql & " FROM SCA_ATA"
			sql = sql & " Where Cod_empresa = " & session("codEmpresa")
			
			if TRIM(Session("NivelPermissao")) <> "A" then
				sql = sql & " And Cod_departamento = " & intCodDepartamento
			end if
			
			sql = sql & " Order by codigo"
			rs.open sql, cnn
							
			if rs.eof = false then
			%>
                <table width="98%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td width="8%" class="celula"><strong>C&oacute;digo </strong></td>
                    <td width="28%" class="celula"><strong>Assunto<span class="TextoForm"></span></strong></td>
                    <td width="30%" class="celula"><strong>Descri<span class="TextoForm">&ccedil;&atilde;o</span></strong></td>
                    <td width="34%" height="21" class="celula"><strong>Data<span class="TextoForm"></span></strong></td>
                  </tr>
                  <%
				while not rs.eof
					cont = cont + 1	
					%>
                  <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
                    <td class="celula"><%=rs("Codigo")%></td>
                    <td class="celula"><%=trim(rs("Assunto"))%></td>
                    <td class="celula"><%=trim(rs("descricao"))%></td>
                    <td height="20" class="celula"><%=formatadataAP(trim(rs("data")))%></td>
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
			  
			  %></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
        </table>

    
    </form>
    </td>
  </tr>
</table>

<!--#include file="../rodape.asp"-->
</body>
</html>