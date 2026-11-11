<%strNomeDaPaginaPortal = "Analise/Autorização da Solicitação"%>
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
            url: "LiberarRequisicao_Itens.asp",
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
			document.all["mostraDescricao"+tipo].style.display="block";
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
	function resultadoConsulta(intCodigo){
			frm.txtCodigo.value=intCodigo
			frm.submit();
		}
function consultarAutorizacoes(){
			var frm = document.getElementById("frm");
			if (frm.cmbSecaoProduto.value=="0") {
				alert("Seção deve ser selecionada!");
				frm.cmbSecaoProduto.focus();
			}else{
				frm.action="LiberarRequisicao_con.asp?botaopesquisar=S";
				frm.submit();
			}
		}
	function autorizar(req){

		var men = 'ATENÇÃO: Deseja autorizar a requisição número ' + req + '?\n';
		if (confirm(men)) {
			var frm = document.getElementById("frm");
			frm.action="LiberarRequisicao_cod.asp?req="+req;
			frm.submit();
			return true;
		}else{
			return false;
		}
 	}
</script>
<%  
	strEmpresaSecaoProduto_submit = "S"
	principal			= "principal.asp"
	intCodEmpresa		= session("CodEmpresa")	
	intSecaoProduto			= Trim(Request.Form("cmbSecaoProduto"))
	if intSecaoProduto = "" then intSecaoProduto = Session("CodSecao")
	if intSecaoProduto = "" then intSecaoProduto = 0
	intQtdeMostrar			= Trim(Request.Form("txtQtdeMostrar"))
	if intQtdeMostrar = "" then intQtdeMostrar = "5"
	strNomeDaUnidade			= Trim(Request.Form("txtUnidade"))
	botaopesquisar			= Trim(Request("botaopesquisar"))
	
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
          <td class="tituloPrincipal style2" width="100%">
          
          <span class="TextoForm">Se&ccedil;&atilde;o:
              <!--#include file="../../../includes/inc_cmbSecaoProduto.asp" -->
          </span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="../../../images/emergencial.png" width="16" height="16" align="absmiddle"><span class="TextoForm">Solicita&ccedil;&atilde;o Emergencial</span><span class="tituloPagina"><br>
    </span>
	    <span style="display:none" class="TextoForm">
	Mostrar somente: <input value="<%=intQtdeMostrar%>" size="3" type="text" class="text" name="txtQtdeMostrar" id="txtQtdeMostrar">
	    </span>
		<br>
		    <span class="TextoForm">
	Filtrar pelo nome da unidade: <input value="<%=strNomeDaUnidade%>" size="15" type="text" class="text" name="txtUnidade" id="txtUnidade">&nbsp;<input type="button" class="Botao" value="Consultar" name="Consultar" onClick="consultarAutorizacoes()">
	    </span><br><br>
        <%
			if intSecaoProduto <> "0" or botaopesquisar="S" then
					cont =0
					if intQtdeMostrar = "" then intQtdeMostrar = "5"


					

					'sql = "select top " & intQtdeMostrar & " _r.codigo, _r.dataentrada, _u.nome, _d.descricao as depto, _r.obs, _r.tipo"
					sql = "select	"
					sql = sql & " 		_r.codigo, "
					sql = sql & " 		_r.dataentrada, "
					sql = sql & " 		_u.nome, "
					sql = sql & " 		_di.codRequisicao,"
					sql = sql & " case "
					sql = sql & " 	when _di.codigo is null then _d.descricao "
					sql = sql & " 	else _dd.descricao "
					sql = sql & " 	end as depto, "
					sql = sql & " 	_r.obs, _r.tipo"
					sql = sql & " from est_requisicao _r "
					sql = sql & " inner join SEG_usuarios _u					on _u.cpf = _r.solicitante "
					sql = sql & " left  join EST_departamento _d				on _d.codigo = _u.codDepartamento "
					sql = sql & " left  join EST_departamento _dd				on _dd.codigo = _r.codDepartamento "
					sql = sql & " left  join est_requisicaoDistribuicao _di	on _di.codRequisicao = _r.codigo "
					sql = sql & " where _r.codSituacao = 2 "
					sql = sql & " and _r.cod_secao = " & intSecaoProduto
					sql = sql & " and _r.codEmpresa = " & intCodEmpresa
					if strNomeDaUnidade<>"" then
						sql = sql & " and ( _d.descricao like '%" & strNomeDaUnidade & "%' or  _dd.descricao like '%" & strNomeDaUnidade & "%' )"
					end if
					sql = sql & " order by 1"
					rs.open sql, cnn
					if rs.eof = false then
						%>
                        <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                        <tr bgcolor="#E5E5E5">
                          <td align="center" class="celula">&nbsp;</td>
                        <td align="center" class="celula"><strong>C&oacute;digo</strong></td>
                        <td width="16%" align="center" class="celula"><strong>Data</strong></td>
                        <td width="42%" align="center" class="celula"><strong>Departamento/Unidade</strong></td>
                        <td width="35%" height="21" align="center" class="celula"><strong>Solicitante</strong></td>
                        </tr>
              			<%
						while not rs.eof
							cont = cont + 1	
							emergencial = ""
							if rs("tipo") = "E" then emergencial = "<img src='../../../images/emergencial.png' alt='Solicitação Emergencial' width='16' height='16' align='absmiddle'>"
							%>
                            <tr id="mostraDescricaoLinhaSolicicao<%=rs("codigo")%>" style="cursor:hand" onClick="return Descricao('<%=rs("codigo")%>')">
                                <td width="2%" class="celula"><img style="cursor:hand"  id="imgDescricao<%=rs("codigo")%>" src="../../../images/down.jpg"></td>
                                <td width="5%" class="celula" align="center"><strong><%=rs("Codigo")%><%=emergencial%></strong></td>
                                <td align="center" class="celula"><%=trim(rs("dataentrada"))%></td>
                                <td class="celula"><%=trim(rs("depto"))%></td>
                                <td height="21" class="celula"><%=trim(rs("nome"))%></td>
                            </tr>
                            <tr >
                                <td  width="100%" height="4" colspan="5" class="celula">
                                
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabela"  id="mostraDescricao<%=rs("codigo")%>" style="display:none">
                                  <tr>
                                    <td align="center">
                                    
                               		<div align="center" id="aguarde_<%=rs("codigo")%>"><font color="#990033"><STRONG>Os itens estão sendo carregados... aguarde!</STRONG></font></div>
									<%if not isnull(rs("obs")) then%>
                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabela">
                                          <tr bgcolor="#FFB7B7">
                                            <td width="26%" height="35" rowspan="2" align="center" class="celula"><STRONG>Observa&ccedil;&atilde;o/Justificativa</STRONG></td>
                                            <td rowspan="2" align="left" class="celula"><STRONG><font color="#0033CC"><%=rs("obs")%></font></STRONG>&nbsp;</td>
                                          </tr>
                                         </table>
                                    <%end if%>
									
	                                <div id="requisicaoIens_<%=rs("codigo")%>"></div>                                    
                                    
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
			  Não existe solicitação para serem analisadas e autorizadas<br><br><br></div>
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