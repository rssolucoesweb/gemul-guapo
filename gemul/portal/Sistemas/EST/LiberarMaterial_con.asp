<%
	response.Expires=0
	Server.ScriptTimeOut = 5000
	response.Buffer = false
%>
<%strNomeDaPaginaPortal = "Liberação das Solicitações Autorizadas"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file=../../../includes/inc_aguarde.asp-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>

   function mostraConsultaItens(idReq){
        $.ajax({
            type: "GET",
            url: "LiberarMaterial_Itens.asp",
            data: { id: idReq },
            contentType: "application/html; charset=utf-8",
            success: function (data) {
                $("#requisicaoIens_"+idReq).empty();
                $("#requisicaoIens_"+idReq).html(data);
            },
            dataType: "html"
        });   
    }
	
</script>
<script>
	function Descricao(tipo){
	
		if (document.all["mostraDescricao"+tipo].style.display =="none"){
			document.all["mostraDescricao"+tipo].style.display="table-row";
			document.all["mostraDescricao"+tipo].style.background="#AAFFAA";
			document.all["mostraDescricaoLinhaSolicicao"+tipo].style.background="#AAFFAA";
			document.all["imgDescricao"+tipo].src="../../../images/up.jpg";
			mostraConsultaItens(tipo);
		}
		else{
			document.all["mostraDescricao"+tipo].style.display="none";
			document.all["imgDescricao"+tipo].src="../../../images/down.jpg";
			document.all["mostraDescricaoLinhaSolicicao"+tipo].style.background="#FFFFFF";
		}
	}	
	
	function consultarAutorizacoes(){
			var frm = document.getElementById("frm");
			if (frm.cmbSecaoProduto.value=="0") {
				alert("Seção deve ser selecionada!");
				frm.cmbSecaoProduto.focus();
			}else{
				frm.action="LiberarMaterial_con.asp?botaopesquisar=S";
				frm.submit();
			}
		}
	function resultadoConsulta(intCodigo){
		frm.txtCodigo.value=intCodigo
		frm.submit();
	}
	function salvarQuantidadeAutorizadaAlteracao(qtde){
		frm.txtCodigo.value=intCodigo
		frm.submit();
	}
	
	function salvarQuantidadeAutorizadaAlteracao(codigo, qtde, acao) {
		iframeAlteracao.location.href='LiberarMaterialAlteracao_cod.asp?acao='+acao+'&codigo='+codigo+'&qtde='+qtde;
		return true;
	}
	function autorizar(req,tombamento,qtdeItens){
		var frm = document.getElementById("frm");
		document.getElementById("cmbAutorizarRequisicao_"+req).disabled = true;
		var men = 'ATENÇÃO: Deseja liberar a requisição número ' + req + '?\n';
		if (confirm(men)) {
			if(tombamento=="S"){
				for (i=0;i<qtdeItens;i++){
					if(document.getElementsByName("txtTombamento_"+req)[i].value==""){
						alert("O tombamento deve ser informado!");
						document.getElementById("cmbAutorizarRequisicao_"+req).disabled = false;
						document.getElementsByName("txtTombamento_"+req)[i].focus();
						return false;	
					}
				}
			}
			frm.action="LiberarMaterial_cod.asp?req="+req;
			frm.submit();
			return true;
		}else{
			document.getElementById("cmbAutorizarRequisicao_"+req).disabled = false;
			return false;
		}
 	}
</script>
<iframe name="iframeAlteracao" height="0" width="0"></iframe>
<%  
	strEmpresaSecaoProduto_submit = "S"
	principal			= "principal.asp"
	intCodEmpresa		= session("CodEmpresa")	
	intSecaoProduto			= Trim(Request.Form("cmbSecaoProduto"))
	if intSecaoProduto = "" then intSecaoProduto = Session("CodSecao")
	strUnidade = request("unidade")
	strTop = request("top")
	if strTop = "" then strTop = "5"
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
    <input value="<%=session("strNomeUsuario")%>" id="usuarioAutorizacao" name="usuarioAutorizacao" type="hidden">
   	<!-- inicio do formulario da pagina-->
	  <table width="98%" border="0"  align="center" cellpadding="0" cellspacing="0" >
        <tr valign="top">
          <td class="tituloPrincipal style2" width="100%"><span class="TextoForm">Se&ccedil;&atilde;o:
              <!--#include file="../../../includes/inc_cmbSecaoProdutoLiberarMaterial.asp" -->
          		</span>
                <br>
                <span class="TextoForm"><strong>Departamento/Unidade</strong></span> <span class="TextoForm">
                <input type="text" name="unidade" id="unidade" value="<%=strUnidade%>" class="texto" size="30">
                </span>
                <input type="button" class="Botao" value="Consultar" name="Consultar" onClick="consultarAutorizacoes()">
                <br>
                <br>
                        
				<%cont=0		
						
				if intSecaoProduto <> "0" or botaopesquisar="S" then
					sql = "select _r.codigo, _r.obs,_u.nome as solicitante, _ua.nome as usuario_autorizacao, _r.data_autorizacao, "
					sql = sql & " case "
					sql = sql & " 	when _di.codigo is null then _d.descricao "
					sql = sql & " 	else _dd.descricao "
					sql = sql & " 	end as depto "	
					sql = sql & " from est_requisicao _r"
					sql = sql & " inner join SEG_usuarios _u on _u.cpf = _r.solicitante"
					sql = sql & " left join SEG_usuarios _ua on _ua.cpf = _r.usuario_autorizacao"
					sql = sql & " left join EST_departamento _d on _d.codigo = _u.codDepartamento"
					sql = sql & " left  join EST_departamento _dd				on _dd.codigo = _r.codDepartamento "
					sql = sql & " left  join est_requisicaoDistribuicao _di	on _di.codRequisicao = _r.codigo "
					sql = sql & " where _r.codSituacao = 3 "
					sql = sql & " and _r.cod_secao = " & intSecaoProduto
					if strUnidade<>"" then
						sql = sql & " and _d.descricao like '%" & strUnidade & "%'"
					end if
					sql = sql & " order by 1"
					rs.open sql, cnn
					if rs.eof = false then					
						%>
						<table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                        <tr bgcolor="#E5E5E5">
                          <td align="center" class="celula">&nbsp;</td>
                        <td align="center" class="celula"><strong>C&oacute;digo</strong></td>
                        <td width="34%" align="center" class="celula"><strong>Departamento/Unidade</strong></td>
                        <td width="37%" align="center" class="celula"><strong>Solicitante</strong></td>
                        <td width="21%" height="21" align="center" class="celula"><strong>Autorizado Por</strong></td>
                        </tr>
              			<%
						while not rs.eof
							cont = cont + 1	
							
							%>
                            <tr id="mostraDescricaoLinhaSolicicao<%=rs("codigo")%>" style="cursor:hand" onClick="return Descricao('<%=rs("codigo")%>')">
                                <td width="2%" class="celula"><img style="cursor:hand"  id="imgDescricao<%=rs("codigo")%>" src="../../../images/down.jpg"></td>
                                <td width="6%" class="celula" align="center"><strong><%=rs("Codigo")%></strong></td>
                                <td class="celula"><%=trim(rs("depto"))%></td>
                                <td class="celula"><%=trim(rs("solicitante"))%></td>
                                <td height="21" align="center" class="celula"><%=trim(Rs("usuario_autorizacao"))%><br><%=trim(Rs("data_autorizacao"))%></td>
                            </tr>
                        	<%if not isnull(rs("obs")) and rs("obs")<>"" then%>
                              <tr bgcolor="#FFB7B7">
                                <td width="26%" colspan="2" align="center" class="celula"><STRONG>Obs./Justificativa</STRONG></td>
                                <td align="left" colspan="3" class="celula"><%=rs("obs")%>&nbsp;</td>
                              </tr>
                            <%end if%>
                            
                            <tr >
                                <td height="24" colspan="5" class="celula">
                                
                                
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabela"  id="mostraDescricao<%=rs("codigo")%>" style="display:none">
                                  <tr>
                                    <td align="center">
                                
                                      <br>
                                      <div id="requisicaoIens_<%=rs("codigo")%>" align="center"></div>
                                      <br>
                                      </td>
                                      </tr>
                                  </table>
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
			  <div align="center"><br><br><br><br><br>
			  Não existe solicitação para serem  liberadas<br><br><br></div>
			  <%
			  end if
			  rs.close
			 end if
			  %></td>
        </tr>
        <tr valign="top">
          <td class="tituloPrincipal style2">&nbsp;</td>
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