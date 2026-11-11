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

	function resultadoConsulta(intCodMedico){
		frm.txtCodMedico.value=intCodMedico
		frm.submit();
	}
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtNomeMedico.value == "") {
			alert("O Nome do Médico deve ser informado");
			frm.txtNomeMedico.focus();
			return false;
		}
		
		if (frm.txtFone.value == "") {
			alert("O Telefone deve ser informado");
			frm.txtFone.focus();
			return false;
		}
			
		if (frm.txtEspecialidade.value == "") {
			alert("A Especialidade deve ser informada");
			frm.txtEspecialidade.focus();
			return false;
		}
		
		if (frm.txtEndereco.value == "") {
			alert("O Endereço deve ser informado");
			frm.txtEndereco.focus();
			return false;
		}
		
		frm.action="Medicos_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<%	
	intCodEmpresa	= session("codEmpresa")	
	
	if Trim(Request.QueryString("CodCategoria")) <> "" then 
		intCodCategoria 	= Trim(Request.QueryString("CodCategoria"))
	else
		intCodCategoria 	= Trim(Request.Form("txtCodCategoria"))
	end if

	intCodMedico		= Trim(Request.Form("txtCodMedico"))
	strNomeMedico		= Trim(Request.Form("txtNomeMedico"))
	strFone				= Trim(Request.Form("txtFone"))
	strCRM				= Trim(Request.Form("txtCRM"))
	strEspecialidade	= Trim(Request.Form("txtEspecialidade"))
	strEndereco 		= Trim(Request.Form("txtEndereco"))
	
	if intCodCategoria <> "" then 
		
		sql = " SELECT Codigo, Descricao" 
		sql = sql & " FROM SIT_CategoriaMedica " 
		sql = sql & " Where Codigo = " & intCodCategoria
		sql = sql & " And CodEmpresa = " & intCodEmpresa
		rs.open sql, cnn
					
		if rs.eof = false then
		strDescricaoCategoria 	= rs("Codigo") & " - " & rs("Descricao")
		end if 
		rs.close

	end if
	
	if intCodMedico <> "" then 
	
		sql = " SELECT CodCategoria, Codigo, Nome, Especialidade, Endereco, Fone" 
		sql = sql & " FROM SIT_Medicos " 
		sql = sql & " Where Codigo = " & intCodMedico
		sql = sql & " And CodEmpresa = " & intCodEmpresa
		rs.open sql, cnn
					
		if rs.eof = false then
			
			intCodCategoria 	= rs("CodCategoria")
			intCodMedico		= rs("Codigo")
			strNomeMedico		= rs("Nome")
			strFone				= rs("Fone")
			strEspecialidade 	= rs("Especialidade")
			strEndereco 	 	= rs("Endereco")
			
			strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir'
			strDesabilitaAlterar = "" 'Habilita o botão Alterar'
			strDesabilitaExcluir = "" 'Desabilita o botão Excluir'
			strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
				
		end if 
		rs.close

	else
	
		strDesabilitaIncluir = "" 'Desabilita o botão Incluir'
		strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar'
		strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir'
		strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
		
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
          <td colspan="2" align="center" class="style4"><strong><font color="#000000">Cadastro 
            de M&eacute;dicos</font></strong></td>
        </tr>
        <tr>
          <td colspan="2"><input name="txtCodBoletin" type="hidden" id="txtCodBoletin" class="text" size="10" value="<%=intCodBoletin%>" maxlength="10">          </td>
        </tr>
        <tr>
          <td  class="TextoForm">Categoria M&eacute;dica 
            :</td>
          <td width="78%"><input name="txtCodCategoria" type="hidden" class="text" id="txtCodCategoria" size="5" maxlength="5" value="<%=intCodCategoria%>">
            <input readonly name="txtDescricaoCategoria" type="text" class="textDesabilitado" id="txtDescricaoCategoria" size="50" maxlength="50" value="<%=strDescricaoCategoria%>"></td>
        </tr>
        <tr>
          <td class="TextoForm">Nome M&eacute;dico :</td>
          <td><input name="txtCodMedico" type="hidden" id="txtCodMedico" value="<%=intCodMedico%>">
              <input name="txtNomeMedico" class="text" type="text" id="txtNomeMedico"  value="<%=strNomeMedico%>" size="40" maxlength="40">          </td>
        </tr>
        <tr>
          <td class="TextoForm" >Telefone :</td>
          <td class="TextoForm"><input name="txtFone" class="text" type="text" id="txtFone" size="15" value="<%=strFone%>" maxlength="15">
              <font color="#999999">(xx)xxx-xxxx</font></td>
        </tr>
        <tr>
          <td class="TextoForm">Especialidade :</td>
          <td><input name="txtEspecialidade" class="text" type="text" id="txtEspecialidade" value="<%=strEspecialidade%>" size="60" maxlength="80"></td>
        </tr>
        <tr>
          <td class="TextoForm">Endere&ccedil;o : </td>
          <td><input name="txtEndereco" class="text" type="text" id="txtEndereco" value="<%=strEndereco%>" size="60" maxlength="80"></td>
        </tr>
        <tr>
          <td colspan="2">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2"><!--#include file="../../../includes/inc_botoes_cadastroPopap.asp"--></td>
        </tr>
        <tr>
          <td colspan="2">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2">
		  <%
		  if intCodCategoria <> "" then
		  
		cont =0
		sql = " SELECT SIT_Medicos.Codigo, SIT_Medicos.Nome," 
		sql = sql & " SIT_Medicos.Especialidade, SIT_Medicos.Endereco,  SIT_CategoriaMedica.Descricao" 
		sql = sql & " FROM SIT_Medicos" 
		sql = sql & " inner join SIT_CategoriaMedica on SIT_CategoriaMedica.Codigo = SIT_Medicos.CodCategoria"
		sql = sql & " Where SIT_Medicos.CodEmpresa = " & intCodEmpresa
		sql = sql & " Order by SIT_Medicos.Codigo"
		rs.open sql, cnn
						
		if rs.eof = false then
		%>
              <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                <tr bgcolor="#E5E5E5">
                  <td class="celula"><strong>C&oacute;d. M&eacute;dico</strong></td>
                  <td class="celula"><strong>Nome</strong></td>
                  <td height="21" class="celula"><strong>Categoria</strong></td>
                </tr>
                <%
							while not rs.eof
							cont = cont + 1		
							%>
                <tr  style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
                  <td width="18%" class="celula"><%=rs("Codigo")%></td>
                  <td width="62%" class="celula"><%=rs("Nome")%></td>
                  <td width="20%" height="21" class="celula"><%=rs("Descricao")%></td>
                </tr>
                <%				
								rs.movenext
								wend
							%>
                <tr>
                  <td height="21" colspan="3" class="celula">Total 
                    Registros : <%=cont%> </td>
              </table>
            <%
						  	end if
						rs.close
						  
						  end if
						  %>          </td>
        </tr>

        <tr>
          <td colspan="2">&nbsp;</td>
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