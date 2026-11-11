<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body>
<!--#include file="../../../includes/inc_verificaSession.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formatadata.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<script>
		function limpar(){
			
			var frm = document.getElementById("frm");
			
			frm.action="EnqueteOpcoes_cad.asp?CodEnquete=" + frm.txtCodEnquete.value;
			frm.submit();
			return true;
		}
		
		function resultadoConsulta(intCodOpcaoEnquete){
			
			var frm = document.getElementById("frm");
			
			frm.txtCodOpcaoEnquete.value=intCodOpcaoEnquete;
			frm.submit();
		}

		function salvar(acao){
			
			var frm = document.getElementById("frm");
			
			if (frm.txtCodEnquete.value == "") {
				alert("A Pergunta da Enquete deve ser informada!");
				frm.txtCodEnquete.focus();
				return false;
			}
			
			if (frm.txtOpcao.value == "") {
				alert("A Opção deve ser informada!");
				frm.txtOpcao.focus();
				return false;
			}
		
			frm.action="EnqueteOpcoes_cod.asp?acao=" + acao;
			frm.submit();
			return true;
		}
</script>
<%
	intCodEmpresa	= session("codEmpresa")	
	
	if Trim(Request.QueryString("CodEnquete")) <> "" then 
		intCodEnquete 		= Trim(Request.QueryString("CodEnquete"))
	else
		intCodEnquete 		= Trim(Request.Form("txtCodEnquete"))
	end if
	
	strPergunta  		= Trim(Request.Form("txtPergunta"))
	intCodOpcaoEnquete 	= Trim(Request.Form("txtCodOpcaoEnquete"))
	strOpcao 			= Trim(Request.Form("txtOpcao"))
 	
	if intCodEnquete <> "" then

		sql = "SELECT Codigo, Pergunta"
		sql = sql & " FROM SIT_Enquete"
		sql = sql & " Where Codigo = " & intCodEnquete
		sql = sql & " And CodEmpresa = " & intCodEmpresa
		rs.open sql, cnn
		
		if rs.eof = false then
			strPergunta		= rs("Codigo") & " - " & rs("Pergunta")
		end if
		rs.close
			
	end if
			
	if intCodEnquete <> "" and intCodOpcaoEnquete <> "" then
		
		sql = "SELECT Codigo, CodEnquete, Opcao "
		sql = sql & " FROM SIT_EnqueteOpcao"
		sql = sql & " Where CodEnquete = " & intCodEnquete
		sql = sql & " and Codigo = " & intCodOpcaoEnquete
		
		rs.open sql, cnn
		if rs.eof = false then

			strOpcao 				= rs("Opcao")
			
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
<table width="100%" height="355" border="0" cellpadding="0" cellspacing="0"  bgcolor="#FFFFFF">
  <tr valign="top">
    <td width="746" align="center">

        <hr size="1" color="#FFFFFF">
        <table width="97%" cellpadding="0" cellspacing="0" class="TabelaDoCadastro" bgcolor="#F5F5F5">
            <tr>
                <td width="97%" class="CelulaDoCadastro" align="center" valign="top">

	<form method="post" id="frm">
	  <table width="100%" border="0">
        <tr>
          <td colspan="2" align="center" class="style4"><strong><font color="#000000">Op&ccedil;&otilde;es <span class="TextoForm"></span> Enquete</font></strong></td>
        </tr>
        <tr>
          <td width="14%" class="TextoForm">Enquete: </td>
          <td width="86%"><input name="txtCodEnquete" type="hidden" class="text" id="txtCodEnquete" size="5" maxlength="5" value="<%=intCodEnquete%>">
            <input name="txtCodOpcaoEnquete" type="hidden" class="text" id="txtCodOpcaoEnquete" size="5" maxlength="5" value="<%=intCodOpcaoEnquete%>">
              <input readonly name="txtPergunta" type="text" class="textDesabilitado" id="txtPergunta" size="50" maxlength="50" value="<%=strPergunta%>"></td>
        </tr>
        <tr>
          <td class="TextoForm">Op&ccedil;&atilde;o : </td>
          <td><input name="txtOpcao" type="text" class="text" id="txtOpcao" size="20" maxlength="20" value="<%=strOpcao%>"></td>
        </tr>

        <tr>
          <td colspan="2" class="TextoForm">Obs : Coloque no maximo 6 op&ccedil;&atilde;o de resposta. </td>
        </tr>
        <tr>
          <td colspan="2" class="TextoForm">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" class="TextoForm"><!--#include file="../../../includes/inc_botoes_cadastroPopap.asp"--></td>
        </tr>
        <tr>
          <td colspan="2" class="TextoForm">&nbsp;</td>
          </tr>
        <tr>
          <td colspan="2" class="TextoForm">
		  <%
			if intCodEnquete <> "" then
				
				cont =0
				
				sql = " SELECT Codigo, CodEnquete, Opcao" 
				sql = sql & " FROM SIT_EnqueteOpcao "
				sql = sql & " Where CodEnquete = " & intCodEnquete
				sql = sql & " Order by Codigo"
				rs.open sql, cnn
								
				if rs.eof = false then
						
				%>
              <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                <tr bgcolor="#E5E5E5">
                  <td class="celula"><strong>Codigo</strong></td>
                  <td height="21" class="celula"><strong>Op&ccedil;&atilde;o</strong></td>
                </tr>
                <%
				while not rs.eof
					cont = cont + 1	
					%>
                <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
                  <td width="9%" class="celula"><%=rs("Codigo")%></td>
                  <td height="20" class="celula"><%=trim(rs("Opcao"))%>&nbsp;</td>
                </tr>
                <%				
				rs.movenext
				wend
				%>
                <tr>
                  <td height="21" colspan="2" class="celula">Total 
                    Registros : <%=cont%></td>
              </table>
				<%
				end if
				rs.close
				end if
				%></td>
        </tr>
        <tr>
          <td colspan="2" class="TextoForm">&nbsp;</td>
        </tr>
      </table>
	</form>
    
                </td>
            </tr>
        </table>
        <hr size="1" color="#FFFFFF">
    
    
	</td>
  </tr>
</table>
</body>
</html>