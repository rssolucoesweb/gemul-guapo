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
        consultar			= Trim(Request.Form("consultar"))
        intCodigo			= Trim(Request.Form("txtNumero"))
        intSecaoProduto		= Trim(Request.Form("cmbSecaoProduto"))
		
        if intSecaoProduto = "" then intSecaoProduto = "0"
		
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Andamento da Solicitação</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	
                  <input name="consultar" value="S" type="hidden">
                    
                  <div class="form-group">
                    <label class="form-label">N&uacute;mero Solicita&ccedil;&atilde;o</label>
                  	<input name="txtNumero" type="text" class="form-control" id="txtNumero" size="7" maxlength="10" value="<%=intCodigo%>"  onKeyPress="return formataCampo(this,2,5)">
                  	<input name="Submit" type="submit" class="btn btn-u float-shadow" id="button" value="   Consultar Andamento da Solicitação">
                  </div>
                  
                  <%if trim(session("codPerfil")) <> "15" then%>
                      <div class="form-group">
                        <label class="form-label">Se&ccedil;&atilde;o</label>
                        <!--#include file="../includes/inc_cmbSecaoProduto.asp" -->
                      </div>
                  <%end if%>

                </form>
       	  </div>
   	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
       <%if consultar<>"" then%>
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i>Solicitação em Andamento</h3>
          </div>
            <div class="panel-body">
            	<div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="3%" bgcolor="#95A5A6">#</th>
                          <th width="5%" bgcolor="#95A5A6">C&oacute;digo</th>
                          <th width="43%" bgcolor="#95A5A6">Data</th>
                          <th width="38%" bgcolor="#95A5A6">Departamento/Unidade</th>
                          <th width="11%" bgcolor="#95A5A6">Solicitante</th>
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

					sql = "select _r.codigo, _r.dataentrada, _u.USUA_NOME_COMPLETO as nome, _r.obs,"
					sql = sql & " case "
					sql = sql & " 	when _di.codigo is null then _d.descricao "
					sql = sql & " 	else _dd.descricao "
					sql = sql & " 	end as depto "	
					sql = sql & " from est_requisicao _r"
					sql = sql & " inner join SEG_USUARIOS_SISTEMA _u on _u.USUA_CPF = _r.solicitante"
					sql = sql & " inner join EST_departamento _d on _d.codigo = _u.CODIGO_DEPARTAMENTO"
					sql = sql & " left  join EST_departamento _dd				on _dd.codigo = _r.codDepartamento "
					sql = sql & " left  join est_requisicaoDistribuicao _di	on _di.codRequisicao = _r.codigo "
					sql = sql & " where 1=1 "
					if trim(session("codPerfil")) = "17" or session("strNomeUsuario")="76143139172" then
					else
						if intSecaoProduto <> "0" then
							sql = sql & " and _r.cod_secao = " & intSecaoProduto
						end if
						if trim(session("codPerfil")) = "11" or trim(session("codPerfil")) = "16" or trim(session("codPerfil")) = "17" or trim(session("codPerfil")) = "19" or trim(session("codPerfil")) = "21" or trim(session("codPerfil")) = "22" or  trim(session("codPerfil")) = "23" or  session("strNomeUsuario")="76143139172" then 
						else
							sql = sql & " and _r.usuario_incl = '"&session("strNomeUsuario")&"'"
							sql = sql & " and _r.cod_secao = 8"
						end if
					end if
					if intCodigo<>"" then
						sql = sql & " and _r.codigo = " & intCodigo
					end if
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
                          	<td><%=trim(rs("nome"))%></td> 
                        </tr>
                        <tr id="tr1" style="display:none;">
                          <td colspan="5">
                          
                          
                                      <table class="table table-bordered">
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
												<td width="23%" height="25"  align="center"><STRONG><font color="#0033CC"><%=rsAux("data_hora_incl")%></font></STRONG></td>
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
                                    <table class="table table-bordered">
                                    	<tr bgcolor="#FFB7B7">
                                    	<td width="23%" height="35" rowspan="2" align="center"><STRONG>Observa&ccedil;&atilde;o/Justificativa</STRONG></td>
                                    	<td width="77%" rowspan="2" align="left"><STRONG><font color="#0033CC"><%=rs("obs")%></font></STRONG>&nbsp;</td>
                                   		</tr>
                                    </table>
                                    <%end if%>
                          
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
        <%end if%>
        <!--End Table Bordered-->	
        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
	<script>
    
    	function resultadoConsulta(intCodigo){
            frm.txtCodigo.value=intCodigo
            frm.submit();
        }
		
		function showTr(id){
			var elemento = document.getElementById("tr" + id);
			if(elemento.style.display == ''){
				elemento.style.display = 'none';
			}else{
				elemento.style.display = '';
			}
		}
    
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 