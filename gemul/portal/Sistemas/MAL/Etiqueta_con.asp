<%strNomeDaPaginaPortal = "Gerar Etiqueta"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>
	function gerar(){
		
		var caminho;
		
		if (frm.cmbTipoContato.value == "0") {
			alert("O Tipo Contato deve ser informada !");
			frm.cmbTipoContato.focus();
			return false;
		}
		
		
		caminho = "Etiqueta_rel.asp?cmbCidade1="+frm.cmbCidade1.value + "&cmbBairro1=" + frm.cmbBairro1.value + "&cmbCidade2=" + frm.cmbCidade2.value + "&cmbBairro2=" + frm.cmbBairro2.value + "&cmbTipoContato=" + frm.cmbTipoContato.value ;
		window.open(caminho,"consulta","top=0,left=0,height=700,width=900,menubar=no,toolbar=no,scrollbars=yes,status=yes");
		return true;	
	}	
</script>
<%  
	
	principal			= "principal.asp"
	strPaginaLimpar		= "Etiqueta_con.asp"
	strDesabilitaGerar	= "Gerar Etiqueta"
	
	intCodTipoContato	= Trim(Request.Form("cmbTipoContato"))
	strCidade1		= Trim(Request.Form("cmbCidade1"))
	strBairro1		= Trim(Request.Form("cmbBairro1"))
	strCidade2		= Trim(Request.Form("cmbCidade2"))
	strBairro2		= Trim(Request.Form("cmbBairro2"))

%>
<!-- fim do codigo asp da pagina -->
<table width="900" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td height="365" bgcolor="#FFFFFF" valign="top" align="center">

        <hr size="1" color="#FFFFFF">
        <table width="97%" cellpadding="0" cellspacing="0" class="TabelaDoCadastro" bgcolor="#F5F5F5">
            <tr>
                <td width="97%" class="CelulaDoCadastro" align="center" valign="top">
    <form id="frm" name="frm" action="#" method="post">
   	<!-- inicio do formulario da pagina-->
	  <table width="98%" border="0"  align="center" cellpadding="0" cellspacing="0" >
          <tr>
            <td height="23" class="TextoForm">Tipo Contato:</td>
            <td class="TextoForm"><select name="cmbTipoContato" id="cmbTipoContato" class="combo"  style="width:200pt">
              <option value="0">Selecione...</option>
              <%
            sql = " Select Codigo, Descricao "
            sql = sql & " from MAL_TipoContato"
            sql = sql & " order by Codigo"
            rs.open sql, cnn
            if rs.eof = false then
                while not rs.eof
                    if cstr(intCodTipoContato) = cstr(rs("codigo")) then
                        strSelecionado = "selected"
                    else
                        strSelecionado = ""
                    end if
                    response.write "<option value=" & rs("codigo") & " " & strSelecionado & ">" & rs("Descricao") & "</option>" & vbcrlf
                    rs.movenext
                wend
            end if
            rs.close
            %>
            </select></td>
          </tr>
          <tr>
            <td height="23" colspan="2" bgcolor="#CCCCCC" class="TextoForm">Dados Endere&ccedil;o I</td>
            </tr>
          <tr>
            <td width="16%" height="23" class="TextoForm">Cidade:</td>
            <td width="25" class="TextoForm"><select name="cmbCidade1" id="cmbCidade1" class="combo"  style="width:200pt" onChange="submit()">
              <option value="0">Selecione...</option>
              <%
            sql = " Select distinct cidade1 "
            sql = sql & " from MAL_cliente"
            sql = sql & " order by cidade1"
            rs.open sql, cnn
            if rs.eof = false then
                while not rs.eof
                    if trim(strCidade1) = trim(rs("cidade1")) then
                        strSelecionado = "selected"
                    else
                        strSelecionado = ""
                    end if
                    response.write "<option value=" & rs("cidade1") & " " & strSelecionado & ">" & rs("cidade1") & "</option>" & vbcrlf
                    rs.movenext
                wend
            end if
            rs.close
            %>
            </select></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Bairro: </td>
            <td class="TextoForm"><select name="cmbBairro1" id="cmbBairro1" class="combo"  style="width:200pt">
              <option value="0">Selecione...</option>
              <%
			  if strCidade1 <> "" then 
				  
				sql = " Select distinct cidade1, Bairro1 "
				sql = sql & " from MAL_cliente"
				sql = sql & " Where cidade1 = '" & strCidade1 & "'"
				sql = sql & " order by Bairro1"
				rs.open sql, cnn
				if rs.eof = false then
					while not rs.eof
						if trim(strBairro1) = trim(rs("Bairro1")) then
							strSelecionado = "selected"
						else
							strSelecionado = ""
						end if
						response.write "<option value=" & rs("Bairro1") & " " & strSelecionado & ">" & rs("Bairro1") & "</option>" & vbcrlf
						rs.movenext
					wend
				end if
				rs.close
			end if
				%>
            </select></td>
          </tr>
          <tr>
            <td height="23" colspan="2" bgcolor="#CCCCCC" class="TextoForm">Dados Endere&ccedil;o II</td>
            </tr>
          <tr>
            <td height="23" class="TextoForm">Cidade:</td>
            <td class="TextoForm"><select name="cmbCidade2" id="cmbCidade2" class="combo"  style="width:200pt" onChange="submit()">
              <option value="0">Selecione...</option>
              <%
            sql = " Select distinct cidade2 "
            sql = sql & " from MAL_cliente"
            sql = sql & " order by cidade2"
            rs.open sql, cnn
            if rs.eof = false then
                while not rs.eof
                    if trim(strCidade2) = trim(rs("cidade2")) then
                        strSelecionado = "selected"
                    else
                        strSelecionado = ""
                    end if
                    response.write "<option value=" & rs("cidade2") & " " & strSelecionado & ">" & rs("cidade2") & "</option>" & vbcrlf
                    rs.movenext
                wend
            end if
            rs.close
            %>

            </select></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Bairro: </td>
            <td class="TextoForm"><select name="cmbBairro2" id="cmbBairro2" class="combo"  style="width:200pt">
              <option value="0">Selecione...</option>
              <%
			  if strCidade2 <> "" then 
				  
				sql = " Select distinct cidade2, Bairro2 "
				sql = sql & " from MAL_cliente"
				sql = sql & " Where cidade2 = '" & strCidade2 & "'"
				sql = sql & " order by Bairro2"
				rs.open sql, cnn
				if rs.eof = false then
					while not rs.eof
						if trim(strBairro2) = trim(rs("Bairro2")) then
							strSelecionado = "selected"
						else
							strSelecionado = ""
						end if
						response.write "<option value=" & rs("Bairro2") & " " & strSelecionado & ">" & rs("Bairro2") & "</option>" & vbcrlf
						rs.movenext
					wend
				end if
				rs.close
			end if
				%>
            </select></td>
          </tr>
          <tr>
            <td height="24" colspan="2" class="TextoForm">&nbsp;</td>
            </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2" colspan="2"><!--#include file="../../../includes/inc_botoes_geraRelatorio.asp"-->&nbsp;</td>
        </tr>
        
        <tr valign="top">
          <td class="tituloPrincipal style2" colspan="2">&nbsp;</td>
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