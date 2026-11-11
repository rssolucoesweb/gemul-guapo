<%strNomeDaPaginaPortal = "Cadastro de Documentos"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>

<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>
	
	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		
		
		frm.action="Documentos_cad.asp?txtCodigo="+intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
	
		if (acao=="I")
		{
			
			if (frm.cmbTipoDocumento.value == "") {
				alert("O Tipo Documento deve ser informado!");
				frm.cmbTipoDocumento.focus();
				return false;
			}
			
			if (frm.txtDescricao.value == "") {
				alert("A Descrição deve ser informada!");
				frm.txtDescricao.focus();
				return false;
			}
			
			if (frm.Arq1.value == "") {
				alert("O Arquivo PDF deve ser informado !");
				frm.Arq1.focus();  
				return false;
			}	
		
			if((frm.Arq1.value.lastIndexOf(".pdf")==-1) && (frm.Arq1.value.lastIndexOf(".PDF")==-1)){  
				alert("Só é permitido fazer Upload de arquivos PDF!"); 
				frm.Arq1.focus();  
				return false  
			} 
		
			if (frm.cmbPublicado.value == "0") {
				alert("Publicado deve ser informado !");
				frm.cmbPublicado.focus();  
				return false;
			}	
		
			frm.action="Documentos_cod.asp?acao=" + acao;
			frm.submit();
			return true;
		}
		
			if (acao=="A"){
				
				var parametro = "Documentos_cod_a.asp?txtCodigo=" + frm.txtCodigo.value + "&cmbTipoDocumento=" + frm.cmbTipoDocumento.value  + "&txtDescricao=" + frm.txtDescricao.value  + "&txtData=" + frm.txtData.value + "&Publicado=" + frm.cmbPublicado.value;
				frm.action=parametro;
				frm.submit();
				return true;
			}
			
			if (acao=="E"){
				
				var parametro = "Documentos_cod_e.asp?txtCodigo=" + frm.txtCodigo.value + "&txtPDF=" + frm.txtPDF.value;
				frm.action=parametro;
				frm.submit();
				return true;
			}
		
 		}


</script>
<%
	principal			= "principal.asp"
	strPagina			= "Documentos_cad.asp"
	intCodEmpresa		= session("codEmpresa")	
	intCodigo 			= Trim(Request("txtCodigo"))
	intCodTipoDocumento	= Trim(Request("cmbTipoDocumento"))
	strData	 			= Trim(Request("txtData"))
	strDescricao		= Trim(Request("txtDescricao"))
	strPublicado		= Trim(Request("cmbPublicado"))

	if trim(intCodigo) <> "" then
	
		sql = "SELECT Codigo, CodTipoDocumento, Descricao, Data, Documento, Publicado"
		sql = sql & " FROM SIT_Documentos"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And CodEmpresa = " & intCodEmpresa
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 		= rs("Codigo")
			intCodTipoDocumento = rs("CodTipoDocumento")
			strDescricao		= rs("Descricao")
			strData				= formatadataAP(rs("Data"))
			strNomeArquivo		= rs("Documento")
			strPublicado		= rs("Publicado")
									
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			BotaoPDF				= ""

		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		BotaoPDF   				= "disabled"
	end if 
	
	if strData = "" then strData = formataDataAP(date)
%>
<!-- fim do codigo asp da pagina -->
<table width="900" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td height="365" bgcolor="#FFFFFF" valign="top" align="center">


        <hr size="1" color="#FFFFFF">
        <table width="97%" cellpadding="0" cellspacing="0" class="TabelaDoCadastro" bgcolor="#F5F5F5">
            <tr>
                <td width="97%" class="CelulaDoCadastro" align="center" valign="top">
    
    
   <form method="post" id="frm" ENCTYPE="multipart/form-data">
   	<!-- inicio do formulario da pagina-->

	
    <table width="98%" border="0">
            <tr>
              <td height="27" class="TextoForm">Tipo Documento:<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10" /></td>
              <td><span class="TextoForm">
                <!--#include file="../../../includes/inc_cmbTipoDocumento.asp"-->
              </span></td>
            </tr>
            <tr>
              <td height="27" class="TextoForm">Descri&ccedil;&atilde;o : </td>
              <td><input name="txtDescricao" type="text" class="text" id="txtDescricao" size="40" maxlength="40" value="<%=strDescricao%>" /></td>
            </tr>
            <tr>
              <td class="TextoForm">Data:</td>
              <td><span class="texto">
                <input name="txtData" type="text" class="text" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strData%>" size="14" maxlength="11">
              </span></td>
            </tr>
            <tr>
              <td class="TextoForm">PDF:</td>
              <td><span class="titulo1">
                <input class="text" name="Arq1" type="file" id="Arq1" size="45">
                <input name="txtPDF" type="hidden" class="text" id="txtPDF" size="40" maxlength="40" value="<%=strNomeArquivo%>" />
              </span></td>
            </tr>
            <tr>
              <td  width="15%" class="TextoForm">Publicado:</td>
              <td width="85%"><span class="textoNoticia">
                <select name="cmbPublicado" id="cmbPublicado" style="width:80pt" class="combo">
                  <option value="0">Selecione...</option>
                  <option value="S" <%if strPublicado = "S" then response.Write("selected") %>>Sim</option>
                  <option value="N" <%if strPublicado = "N" then response.Write("selected") %>>N&atilde;o</option>
                </select>
              </span></td>
            </tr>
            <tr>
              <td colspan="2">&nbsp;</td>
            </tr>
            <tr>
              <td colspan="2"><!--#include file="../../../includes/inc_botoes_cadastro.asp"--></td>
            </tr>
            <tr>
              <td colspan="2">&nbsp;</td>
            </tr>
            <tr>
              <td colspan="2"><%
		
				cont =0
				sql = "SELECT D.Codigo, D.Descricao, D.Data, D.Documento, D.Publicado, TD.Descricao as TipoDocumento"
				sql = sql & " FROM SIT_Documentos D"
				sql = sql & " inner join SIT_TipoDocumento TD on TD.codigo = D.CodTipoDocumento"
				sql = sql & " Where D.CodEmpresa = " & intCodEmpresa
				sql = sql & " Order by data desc"


				rs.open sql, cnn
					if rs.eof = false then
					%>
                  <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                    <tr bgcolor="#CCCCCC">
                      <td class="celula"><strong>C&oacute;digo</strong></td>
                      <td width="28%" class="celula"><strong>Tipo Documento</strong></td>
                      <td width="28%" class="celula"><strong>Descri&ccedil;&atilde;o</strong></td>
                      <td width="28%" class="celula"><strong>Nome Arquivo</strong></td>
                      <td width="9%" height="21" align="center" class="celula"><strong>Publicado </strong></td>
                      </tr>
                    <%
						while not rs.eof
							cont = cont + 1	
							
							strPublicado = rs("Publicado")
							
							if strPublicado = "S" then 
								strPublicado = "Sim"
							else
								strPublicado = "Não"
							end if
							
							
							%>
                    	<tr bgcolor="#FFFFFF" style="cursor:hand" onClick="return resultadoConsulta('<%=rs("Codigo")%>')" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)">
                      <td width="7%" class="celula"><%=rs("Codigo")%></td>
                      <td class="celula"><%=trim(rs("TipoDocumento"))%></td>
                      <td class="celula"><%=trim(rs("Descricao"))%></td>
                      <td class="celula"><%=trim(rs("Documento"))%></td>
                      <td height="21" align="center" class="celula"><%=strPublicado%></td>
                      </tr>
                    <%				
					rs.movenext
					wend
					%>
                    <tr bgcolor="#FFFFFF">
                      <td height="21" colspan="5" class="celula">Total 
                        Registros : <%=cont%></td>
                    </tr>
                  </table>
                <%
			  end if
			  rs.close
			 
			  %>              </td>
            </tr>
          </table>

   	<!-- fim do formulario da pagina-->
    </form>
                  </td>
            </tr>
        </table>
        <hr size="1" color="#FFFFFF">
  
    
    </td>
  </tr>
</table>
<!--#include file="rodape.asp"-->
</body>
</html>
<script>aguarde.style.display="none";</script>
