<%SESSION.Timeout = 1200%>
<%response.Buffer=false%>
<%response.Expires=0%>
<%Server.ScriptTimeout = 5000 %>
<%strNomeDaPaginaPortal = "Andamento da Solicitação "%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file=../../../includes/inc_aguarde.asp-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>
	function Descricao(tipo){
	
		if (document.all["mostraDescricao"+tipo].style.display =="none"){
			document.all["mostraDescricao"+tipo].style.display="block";
			document.all["mostraDescricao"+tipo].style.background="#AAFFAA";
			document.all["mostraDescricaoLinhaSolicicao"+tipo].style.background="#AAFFAA";
			document.all["imgDescricao"+tipo].src="../../../images/up.jpg";
			
		}
		else{
			document.all["mostraDescricao"+tipo].style.display="none";
			document.all["imgDescricao"+tipo].src="../../../images/down.jpg";
			document.all["mostraDescricaoLinhaSolicicao"+tipo].style.background="#FFFFFF";
		}
	}	
	function resultadoConsulta(intCodigo){
			frm.txtCodigo.value=intCodigo
			frm.submit();
		}

</script>
<%  

	strEmpresaSecaoProduto_submit = "S"
	principal			= "principal.asp"
	intCodEmpresa		= session("CodEmpresa")	
	consultar			= Trim(Request.Form("consultar"))
	intCodigo			= Trim(Request.Form("txtNumero"))
	intSecaoProduto			= Trim(Request.Form("cmbSecaoProduto"))
	if intSecaoProduto = "" then intSecaoProduto = Session("CodSecao")
%>
<!-- fim do codigo asp da pagina -->
<table width="900" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td height="365" bgcolor="#FFFFFF" valign="top" align="center">

      <form id="frm" name="frm" action="#" method="post">
      <hr size="1" color="#FFFFFF">
        <table width="97%" cellpadding="0" cellspacing="0" class="TabelaDoCadastro" bgcolor="#F5F5F5">
            <tr>
                <td width="97%" class="CelulaDoCadastro" align="center" valign="top">
    <input name="consultar" value="S" type="hidden">
   	<!-- inicio do formulario da pagina-->
	  <table width="98%" border="0"  align="center" cellpadding="0" cellspacing="0" >
        <tr valign="top">
          <td class="tituloPrincipal style2" width="100%">
        <span class="TextoForm">N&uacute;mero Solicita&ccedil;&atilde;o:</span><span class="TextoForm">
        <input name="txtNumero" type="text" class="text" id="txtNumero" size="7" maxlength="10" value="<%=intCodigo%>"  onKeyPress="return formataCampo(this,2,5)">
        </span>&nbsp;&nbsp;&nbsp;<span class="TextoForm">
        <input name="Submit" type="submit" class="botao" id="button" value="   Consultar Andamento da Solicitação">
        </span><br>
        <%if trim(session("codPerfil")) <> "15" then%>
          <span class="TextoForm">Se&ccedil;&atilde;o:
              <!--#include file="../../../includes/inc_cmbSecaoProduto.asp" -->
          </span>
          <%end if%>
        <%
		if consultar<>"" then
					cont =0


					strMes1 = month(date)-1
					strMes2 = month(date)-2
					strAno1 = year(date)
					strAno2 = year(date)
					
					if month(date) = 1 then
						strMes1 = 12
						strMes2 = 11
						strAno1 = year(date())-1
						strAno2 = year(date())-1
					end if
					if month(date) = 2 then
						strMes1 = 1
						strMes2 = 12
						strAno1 = year(date)
						strAno2 = year(date)-1
					end if
					if intCodigo="" then intCodigo= 0
					sql = "select _r.codigo, _r.dataentrada, _u.nome, _r.obs,"
					sql = sql & " case "
					sql = sql & " 	when _di.codigo is null then _d.descricao "
					sql = sql & " 	else _dd.descricao "
					sql = sql & " 	end as depto "	
					sql = sql & " from est_requisicao _r"
					sql = sql & " inner join SEG_usuarios _u on _u.cpf = _r.solicitante"
					sql = sql & " inner join EST_departamento _d on _d.codigo = _u.codDepartamento"
					sql = sql & " left  join EST_departamento _dd				on _dd.codigo = _r.codDepartamento "
					sql = sql & " left  join est_requisicaoDistribuicao _di	on _di.codRequisicao = _r.codigo "
					sql = sql & " where 1=1 "
					sql = sql & " and _r.codigo = " & intCodigo
					if trim(session("codPerfil")) = "17" or session("bolUsuarioAcessaTodasRequisicoes")="S" then
					else
						if intSecaoProduto <> "0" then
							sql = sql & " and _r.cod_secao = " & intSecaoProduto
						end if
						if trim(session("codPerfil")) = "11" or trim(session("codPerfil")) = "16" or trim(session("codPerfil")) = "17" or trim(session("codPerfil")) = "19" or trim(session("codPerfil")) = "21" or trim(session("codPerfil")) = "22" or  trim(session("codPerfil")) = "23" or  session("bolUsuarioAcessaTodasRequisicoes")="S" then 
						else
							sql = sql & " and _r.usuario_incl = '"&session("strNomeUsuario")&"'"
							sql = sql & " and _r.cod_secao = 8"
						end if
					end if
					'if intCodigo<>"" then
				'		sql = sql & " and _r.codigo = " & intCodigo
				'	end if
					sql = sql & " order by 1"
					rs.open sql, cnn
					if rs.eof = false then
					%>
                    <br>
                        <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                        <tr bgcolor="#E5E5E5">
                          <td align="center" class="celula">&nbsp;</td>
                        <td align="center" class="celula"><strong>C&oacute;digo</strong></td>
                        <td width="14%" align="center" class="celula"><strong>Data</strong></td>
                        <td width="42%" align="center" class="celula"><strong>Departamento/Unidade</strong></td>
                        <td width="37%" height="21" align="center" class="celula"><strong>Solicitante</strong></td>
                        </tr>
              			<%
						while not rs.eof
							cont = cont + 1	
							%>
                            <tr id="mostraDescricaoLinhaSolicicao<%=rs("codigo")%>" style="cursor:hand" onClick="return Descricao('<%=rs("codigo")%>')">
                                <td width="2%" class="celula"><img style="cursor:hand"  id="imgDescricao<%=rs("codigo")%>" src="../../../images/down.jpg"></td>
                                <td width="5%" class="celula" align="center"><strong><%=rs("Codigo")%></strong></td>
                                <td align="center" class="celula"><%=trim(rs("dataentrada"))%></td>
                                <td class="celula"><%=trim(rs("depto"))%></td>
                                <td height="21" class="celula"><%=trim(rs("nome"))%></td>
                            </tr>
                            <tr >
                                <td height="24" colspan="5" class="celula">
                                    <!-- execucao -->
                                   
                                   <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabela" id="mostraDescricao<%=rs("codigo")%>" style="display:none">
                                      <tr bgcolor="#AAFFAA">
                                        <td height="25" colspan="3" align="center" class="celula"><STRONG>Andamento</STRONG></td>
                                      </tr>
                                     <%
                                       	sql = "select _ra.CODREQUISICAO, _ra.SITUACAO, _ra.data_hora_incl, _u.nome "
										sql = sql & " from EST_RequisicaoAndamento _ra"
										sql = sql & " inner join EST_Requisicao _r on _r.codigo = _ra.CODREQUISICAO"
										sql = sql & " left join SEG_usuarios _u on _u.cpf = _ra.usuario_incl"
										sql = sql & " where _ra.CODREQUISICAO = " & rs("codigo")
										sql = sql & " order by _ra.data_hora_incl"
										rsAux.open sql, cnn
										if rsAux.eof = false then
											while not rsAux.eof
												%>
											   <tr>
												<td width="23%" height="25"  align="center" class="celula"><STRONG><font color="#0033CC"><%=rsAux("data_hora_incl")%></font></STRONG></td>
												<td width="43%" align="left" class="celula"><STRONG><font color="#0033CC"><%=rsAux("situacao")%></font></STRONG>&nbsp;</td>
												<td width="34%" align="left" class="celula"><STRONG><font color="#0033CC"><%=ucase(rsAux("nome"))%></font></STRONG>&nbsp;</td>
										      </tr>
												<%
												rsAux.movenext
											wend
										end if
										rsAux.close
										%>
                                  </table>
                                     
									<%if not isnull(rs("obs")) and trim(rs("obs"))<>"" then%>
                                    <br>
<br>

                                   <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabela">
                                      <tr bgcolor="#FFB7B7">
                                        <td width="23%" height="35" rowspan="2" align="center" class="celula"><STRONG>Observa&ccedil;&atilde;o/Justificativa</STRONG></td>
                                        <td width="77%" rowspan="2" align="left" class="celula"><STRONG><font color="#0033CC"><%=rs("obs")%></font></STRONG>&nbsp;</td>
                                      </tr>
                                  </table>
                                 <%end if%>
                              </td>
                          </tr>
              				<%				
					rs.movenext
					wend
					%>
              </table>
            <%
			  else
			  %>
			  <div align="center"><br><br><br>
              
			  <%if codigo = "" or codigo = "0" then%>
			  	O número da requição deve ser informada!<br>
              <%else%>
			  	Não existe solicitação em andamento para seu usu&aacute;rio!<br>
              <%end if%>
			  
              <br><br><br></div>
			  <%
			  end if
			  rs.close%></td>
        </tr>
        <tr valign="top">
          <td class="tituloPrincipal style2">&nbsp;</td>
        </tr>
      </table>
   	<!-- fim do formulario da pagina-->
      </td>
            </tr>
        </table>
        <hr size="1" color="#FFFFFF">
        <%end if%>
            </form>

    </td>
  </tr>
</table>

</body>
</html>
<script>aguarde.style.display="none";</script>