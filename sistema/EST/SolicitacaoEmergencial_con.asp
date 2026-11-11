<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">EST - Controle Almoxarifado</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%  
        strEmpresaSecaoProduto_submit = "S"
        principal			= "principal.asp"
        intCodEmpresa		= session("CodEmpresa")	
        intSecaoProduto			= Trim(Request.Form("cmbSecaoProduto"))
        if intSecaoProduto = "" then intSecaoProduto = "0"
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
   	   
       <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i>Consulta Autorização Emergencial   </h3>
          </div>
            <div class="panel-body">
            	<div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="3%" bgcolor="#95A5A6">#</th>
                          <th width="9%" bgcolor="#95A5A6">C&oacute;digo</th>
                          <th width="6%" bgcolor="#95A5A6">Data</th>
                          <th width="51%" bgcolor="#95A5A6">Departamento/Unidade</th>
                          <th width="31%" bgcolor="#95A5A6">Solicitante</th>
                      </tr>
                    </thead>
                  <%
                    cont =0


					strMes1 = month(date)-1
					strMes2 = month(date)-2
					strAno1 = year(date)
					strAno2 = year(date)
					
					if month(date) = 1 then
						strMes1 = 12
						strMes2 = 11
						strAno1 = year(getdate())-1
						strAno2 = year(getdate())-1
					end if
					if month(date) = 2 then
						strMes1 = 1
						strMes2 = 12
						strAno1 = year(date)
						strAno2 = year(date)-1
					end if

					sql = "select _r.codigo, _r.dataentrada, _u.USUA_NOME_COMPLETO as nome, _d.descricao as depto, _r.obs"
					sql = sql & " from est_requisicao _r"
					sql = sql & " inner join SEG_USUARIOS_SISTEMA _u on _u.USUA_CPF = _r.solicitante"
					sql = sql & " inner join EST_departamento _d on _d.codigo = _u.CODIGO_DEPARTAMENTO"
					sql = sql & " where _r.codSituacao = 2 "
					sql = sql & " and _r.cod_secao = " & intSecaoProduto
					sql = sql & " order by 1"
					rs.open sql, cnn
					if rs.eof = false then
					while not rs.eof
						cont = cont + 1	
			        %>
                    <tbody>
                        <tr>
                            <td><div align="center"><a href="javascript:showTr(1)">[+]</a></div></td>
                            <td><%=trim(rs("Codigo"))%></td>
                            <td><%=trim(rs("dataentrada"))%></td>
                          	<td><%=trim(rs("depto"))%></td>
                            <td><%=trim(rs("nome"))%> </td>
                        </tr>
                        <tr id="tr1" style="display:none;">
                          <td colspan="5">
                          
                                         	
                            <table class="table table-bordered">
                            <tr bgcolor="#AAFFAA">
                            <td height="35" colspan="2" align="center" class="celula"><STRONG>Andamento da Solicita&ccedil;&atilde;o n&uacute;mero:<%=rs("Codigo")%></STRONG></td>
                            </tr>
                            <%
                            sql = "select _r.codigo, _r.dataentrada, _u.nome, _d.descricao as depto, _r.obs"
                            sql = sql & " from est_requisicao _r"
                            sql = sql & " inner join EST_RequisicaoAndamento _u on _u.cpf = _r.solicitante"
                            sql = sql & " where _r.usuario_incl = '" & strNao & "'"
                            sql = sql & " order by _u.data_hora_incl"
                            rsAux.open sql, cnn
                            if rsAux.eof = false then
								while not rsAux.eof
								%>
								<tr>
									<td width="26%" height="25"  align="center" class="celula"><STRONG><font color="#0033CC"><%=rsAux("data_hora_incl")%></font></STRONG></td>
									<td align="left" class="celula"><STRONG><font color="#0033CC"><%=rsAux("situacao")%></font></STRONG>&nbsp;</td>
								</tr>
								<%
								rsAux.movenext
								wend
                            end if
                            rsAux.close
                            %>
                            </table>
                            
                            <%if not isnull(rs("obs")) then%>
                            <table class="table table-bordered">
                            	<tr bgcolor="#FFB7B7">
                            		<td width="26%" height="35" rowspan="2" align="center" class="celula"><STRONG>Observa&ccedil;&atilde;o/Justificativa</STRONG></td>
                            		<td rowspan="2" align="left" class="celula"><STRONG><font color="#0033CC"><%=rs("obs")%></font></STRONG>&nbsp;</td>
                            	</tr>
                            </table>
                            <%end if%>
                            
                            <table class="table table-bordered">
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
                            <div align="center"><input <%=strDesabilitaLiberacao%> name="cmbAutorizar" type="button" class="botaoIncluir" value="Clique para DEVOLVER a solicitação para o solicitante" onClick="devolver('<%=rs("codigo")%>')"></div>
                          
                          </td>
                        </tr>
                    </tbody>
                    <%				
                        rs.movenext
                        wend
                    end if
                    rs.close
                %>
                </table>
                </div>
            </div>                      
        </div>
        <!--End Table Bordered-->	
        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
	<script>
	
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

    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 