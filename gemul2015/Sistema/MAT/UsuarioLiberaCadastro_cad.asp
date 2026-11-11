<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css"></head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<script>
	function salvar(acao){
		
			var intContMarcado=0;
			var frm = document.getElementById("frm");
	
			if (frm.txtUsuarioPortal.value == "" && acao =="I") {
				alert("O usuário deve ser informado!");
				frm.txtUsuarioPortal.focus();
				return false;
			} 
			if (acao=="E") {
				var marcou = "NAO";	
				for (var i = 0; i < frm.elements.length; i++) {
					//verifica todos os checkbox
					if (frm.elements[i].type == "checkbox"){	
						if (frm.elements[i].checked == true){				
							marcou = "SIM";		
						}
					}
				}
				if (marcou == "NAO"){
					alert("Para efetuar a exclusão do(s) usuário(s), você deverá selecionar pelos um na relação abaixo!")	
					return false
				}
			}

			frm.action="UsuarioLiberaCadastro_cod.asp?acao=" + acao;
			frm.submit();
			return true;	 
	}
	
	function marcaTodos(){
		
		var frm = document.getElementById("frm");
		
		if(frm.chkTodos.checked == true){ 
		  for (var i = 0; i < frm.elements.length; i++) {
					//verifica todos os checkbox
					
					if (frm.elements[i].type == "checkbox"){				
						frm.elements[i].checked = true;				
					}
		  }
		}else{
		  for (var i = 0; i < frm.elements.length; i++) {
					//verifica todos os checkbox
					if (frm.elements[i].type == "checkbox"){				
						frm.elements[i].checked = false;				
					}
		  }
		}
		return true;
	}
	
</script>

		<script>
			//alert("Confirmação da matrícula encerrada em 27/01/2016.");
			//window.history.back();
		</script>
		<%
		'response.End()
%>
<%

	pagina	= "EfetivacaoAluno_con.asp"
	strUsuarioPortal 	= Trim(Request("txtUsuarioPortal"))
	
	if strUsuarioPortal <> "" then
		sql = "select USUA_NOME_COMPLETO from SEG_USUARIOS_SISTEMA where usua_codg='" & strUsuarioPortal & "'"
		rs.open sql, cnn
		if rs.eof = false then
			strNomealuno 			= Trim(rs("USUA_NOME_COMPLETO"))

			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
		else	
			strNomealuno 			= "Não encontrado!"
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
		end if
		rs.close		
	end if

	strDesabilitaLimpar  = "" ' Habilita o Botão Limpar
%>
<form method="post" id="frm" action="#">
<div align="center">
<table width="100%" height="266" border="0" align="center" cellpadding="10" cellspacing="10"  class="CorFundo">
	<tr valign="top">
		  <td height="22" colspan="2" align="center" class="tituloSistema">Liberação de acesso ao cadastro de alunos</td>
	</tr>
		<tr valign="top">
		  <td height="15" colspan="2" align="left" valign="middle" bgcolor="#CCCCCC"  class="texto"><strong>Dados da libera&ccedil;&atilde;o</strong></td>
    </tr>
		<tr valign="top">
		  <td height="12" colspan="2" align="right" valign="middle"  class="texto">&nbsp;</td>
    </tr>
		<tr valign="top">
		  <td width="10%" height="24" align="right" valign="baseline"  class="texto">Usu&aacute;rio:</td>
		  <td width="90%" align="left" valign="baseline"><span class="form-group">
	      <input name="txtUsuarioPortal" type="text" class="text" id="txtUsuarioPortal" value="<%=strUsuarioPortal%>" size="30" maxlength="30" onBlur="submit()">&nbsp;<strong><%=strNomealuno%></strong>
		  </span></td>
    </tr>
		<tr valign="top">
		  <td height="12" colspan="2" align="center"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
    </tr>
		<tr valign="top">
		  <td height="15" colspan="2" align="left" bgcolor="#CCCCCC" class="texto"><strong>Libera&ccedil;&otilde;es</strong></td>
    </tr>
		<tr valign="top">
		  <td height="48" colspan="2" align="center"  width="90%">
<br>
            <table class="tabela" width="100%">
                        <tr>
                          <th width="1%" bgcolor="#CCCCCC" class="celula"> <input name="chkTodos" type="checkbox" value="" onClick="return marcaTodos()"> </th>
                          <th width="10%" align="left" bgcolor="#CCCCCC" class="celula">Login</th>
                          <th width="42%" align="left" bgcolor="#CCCCCC" class="celula">Usu&aacute;rio</th>
                          <th width="47%" align="left" bgcolor="#CCCCCC" class="celula">Lota&ccedil;&atilde;o</th>
                      </tr>
                    <%
                    cont =0
					SQL = " SELECT I.CODIGO_SEG_USUARIOS_SISTEMA, U.USUA_NOME_COMPLETO, E.RAZAOSOCIAL AS LOTACAO"
					SQL = SQL & " FROM SEG_USUARIOS_INCLUI_CADASTRO I "
					SQL = SQL & " INNER JOIN SEG_USUARIOS_SISTEMA U ON U.USUA_CODG = I.CODIGO_SEG_USUARIOS_SISTEMA"
					SQL = SQL & " LEFT JOIN SRH_COLABORADOR C ON C.CODIGO_SEG_USUARIOS_SISTEMA = I.CODIGO_SEG_USUARIOS_SISTEMA"
					SQL = SQL & " LEFT JOIN SEG_EMPRESA E ON E.CODIGO = C.CODLOTACAO"
					SQL = SQL & " where I.cod_grupo = '" & SESSION("CODGRUPO") & "'"
					SQL = SQL & " Order by U.USUA_NOME_COMPLETO, E.RAZAOSOCIAL"
										
                    rs.open sql, cnn
                    if rs.eof = false then
                    
                    while not rs.eof
						cont = cont + 1	
                    	%>
                        <tr>
                            <td align="center" class="celula"><input name="chkEmp"  type="checkbox" value="<%=rs("CODIGO_SEG_USUARIOS_SISTEMA")%>" ></td>
                            <td class="celula"><%=trim(rs("CODIGO_SEG_USUARIOS_SISTEMA"))%>&nbsp;</td>
                            <td class="celula"><%=trim(rs("USUA_NOME_COMPLETO"))%>&nbsp;</td>
                            <td class="celula"><%=trim(rs("LOTACAO"))%>&nbsp;</td>
                          <%				
                        rs.movenext
                        wend
                    end if
                    rs.close
                	%>
                    	<tr>
                    		<td colspan="4"  class="celula">Total Registros : <%=cont%></td>
                    	</tr>
            </table>
<br>
<br>		  </td>
	</tr>
  </table>
</div>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>
