<%strNomeDaPaginaPortal = "Devolver Solicitação para o Solicitante"%>
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

	function devolver(req){

		var men = 'ATENÇÃO: Deseja devolver a solicitação número ' + req + ' para o solicitante?\n';
		if (confirm(men)) {
			var frm = document.getElementById("frm");
			frm.action="devolverRequisicao_cod.asp?req="+req;
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
        <tr valign="top">
          <td class="tituloPrincipal style2" width="100%">
          <span class="TextoForm">Se&ccedil;&atilde;o:
              <!--#include file="../../../includes/inc_cmbSecaoProduto.asp" -->
          </span>
        <%
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
					sql = sql & " where _r.codSituacao = 2 "
					sql = sql & " and _r.cod_secao = " & intSecaoProduto
					sql = sql & " order by 1"
					rs.open sql, cnn
					if rs.eof = false then
						
						%>
                        <br>
                        <br>
                        <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                        <tr bgcolor="#E5E5E5">
                          <td align="center" class="celula">&nbsp;</td>
                        <td align="center" class="celula"><strong>C&oacute;digo</strong></td>
                        <td width="16%" align="center" class="celula"><strong>Data</strong></td>
                        <td width="40%" align="center" class="celula"><strong>Departamento/Unidade</strong></td>
                        <td width="36%" height="21" align="center" class="celula"><strong>Solicitante</strong></td>
                        </tr>
              			<%
						while not rs.eof
							cont = cont + 1	
							%>
                            <tr id="mostraDescricaoLinhaSolicicao<%=rs("codigo")%>" style="cursor:hand" onClick="return Descricao('<%=rs("codigo")%>')">
                                <td width="2%" class="celula"><img style="cursor:hand"  id="imgDescricao<%=rs("codigo")%>" src="../../../images/down.jpg"></td>
                                <td class="celula" align="center"><strong><%=rs("Codigo")%></strong></td>
                                <td align="center" class="celula"><%=trim(rs("dataentrada"))%></td>
                                <td class="celula"><%=trim(rs("depto"))%></td>
                                <td height="21" class="celula"><%=trim(rs("nome"))%></td>
                            </tr>
                            <tr >
                                <td height="4" colspan="5" class="celula" width="100%">
                                    <!-- execucao -->
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabela"  id="mostraDescricao<%=rs("codigo")%>" style="display:none">
                                      <tr>
                                        <td width="100%">
												<%if not isnull(rs("obs")) and rs("obs")<>"" then%>
                                               <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabela">
                                                  <tr bgcolor="#FFB7B7">
                                                    <td width="26%" height="35" rowspan="2" align="center" class="celula"><STRONG>Observa&ccedil;&atilde;o/Justificativa</STRONG></td>
                                                    <td width="74%" rowspan="2" align="left" class="celula"><STRONG><font color="#0033CC"><%=rs("obs")%></font></STRONG>&nbsp;</td>
                                                  </tr>
                                                 </table>
                                                 <%end if%>
                                                <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabela">
                                                  <tr>
                                                    <td width="26%" rowspan="3" align="center" class="celula"><STRONG>Material</STRONG></td>
                                                    <td width="6%" rowspan="3" align="center" class="celula"><STRONG>Unidade</STRONG></td>
                                                    <td width="19%" rowspan="3" align="center" class="celula"><STRONG>Grupo</STRONG></td>
                                                    <td colspan="2" align="center" class="celula"><strong>Saldo </strong></td>
                                                    <td colspan="4" align="center" class="celula"><STRONG>Quantidade</STRONG></td>
                                                  </tr>
                                                  <tr>
                                                    <td width="8%" rowspan="2" align="center" class="celula"><strong>Real</strong></td>
                                                    <td width="8%" rowspan="2" align="center" class="celula"><strong>Dispon&iacute;vel</strong></td>
                                                    <td colspan="3" align="center" class="celula"><strong>Solicita&ccedil;&atilde;o</strong></td>
                                                  </tr>
                                                  <tr>
                                                    <td width="10%" align="center" class="celula" bgcolor="#FFFFCC"><%=ucase(monthname(strMes2))%></td>
                                                    <td width="10%" align="center" class="celula" bgcolor="#C1E0FF"><%=ucase(monthname(strMes1))%></td>
                                                    <td width="10%" align="center" class="celula" bgcolor="#64FF64"><strong><%=ucase(monthname(month(date)))%></strong></td>
                                                  </tr>
                                                  <%
                                                
                                                sql = "execute EST_ListaProdutosAutorizacao " & rs("codigo") & "," & intCodEmpresa
                                                'response.write sql & "<hr>"
                                                rsAux.open sql, cnn
                                                if not rsAux.eof then
                                                    while not rsAux.eof
                                                      %>
                                                      <tr>
                                                        <td  class="celula"><%=rsAux("produto")%></td>
                                                        <td class="celula"><%=UCASE(rsAux("unidade"))%></td>
                                                        <td class="celula"><%=rsAux("grupo")%></td>
                                                        <td class="celula" align="center"><%=rsAux("QTD_ATUAL_ESTOQUE")%></td>
                                                        <td class="celula" align="center"><%=rsAux("QTD_ATUAL_DISPONIVEL")%></td>
                                                        <td class="celula" align="center"  bgcolor="#FFFFCC"><%=rsAux("quantidade_liberada_mes2")%></td>
                                                        <td class="celula" align="center"  bgcolor="#C1E0FF"><%=rsAux("quantidade_liberada_mes1")%></td>
                                                        <td class="celula" align="center"  bgcolor="#64FF64"><%=rsAux("quantidade")%></td>
                                                      </tr>
                                                       <%
                                                      rsAux.movenext
                                                    wend
                                                end if
                                                rsAux.close
                                                  %>
                                                </table>
                                             <br>
                                           <div align="center"><input <%=strDesabilitaLiberacao%> name="cmbAutorizar" type="button" class="botaoIncluir" value="Clique para DEVOLVER a solicitação para o solicitante" onClick="devolver('<%=rs("codigo")%>')"></div>                                        
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
			  Não existe solicitação para serem devolvidas.<br><br><br></div>
			  <%
			  end if
			  rs.close%></td>
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
<!--include file="rodape.asp"-->
</body>
</html>
<script>aguarde.style.display="none";</script>