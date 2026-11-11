<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">APO - Controle Ponto</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
	strFuncao = ""
	intCodigo	 				= Trim(Request.Form("txtCodigo"))
	
	if trim(intCodigo) <> "" then
		 
		sql = " Select * "
		sql = sql & " FROM APO_faixa_ip PHC "
		sql = sql & " where id  = " & intCodigo 
		rs.open sql, cnn
	
		if rs.eof = false then
		
			intCodEmpresaGrupo			= rs("Cod_empresa")
			strIP						= rs("numero_ip")
			
			strDesabilitaIncluir		= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 		= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir		= "" 'Desabilita o botão Excluir
		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if
	%>    
<!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Faixa de IP</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                <input name="txtCodigo" value="<%=intCodigo%>" type="hidden" id="txtCodigo" >
                    <div class="form-group">
                        <label class="form-label">Unidade</label>
                         <!--#include file="../includes/inc_cmbEmpresaGrupo.asp" --> 
                    </div>
                    
                  <div class="form-group">
                      <label class="form-label">&nbsp;</label>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Número do IP</label>
                        <input name="txtIP" type="text" class="form-control" id="txtIP" value="<%=strIP%>" size="30" maxlength="15" >
                    </div>
                     <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i>Lista das faixas de IP cadastradas</h3>
          </div>
      <div class="panel-body">
            	<div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="28%" bgcolor="#95A5A6">Unidade</th>
                          <th width="62%" bgcolor="#95A5A6">Link de Acesso</th>
                          <th width="62%" bgcolor="#95A5A6">IP</th>
                          <th width="10%" bgcolor="#95A5A6" align="center"><div align="center">Editar</div></th>
                      </tr>
                    </thead>
                    <%
					sql = " select i.id, e.RAZAOSOCIAL, i.numero_ip, 'http://www.gemul.com.br/Sistema/apo/ponto.asp?grupo=' + cast(e.COD_GRUPO as varchar) + '&UNIDADE=' + cast(e.CODIGO as varchar) as link_acesso from APO_faixa_ip i "
					sql = sql & " inner join seg_empresa e on e.codigo=i.cod_empresa"
					sql = sql & " WHERE e.Cod_grupo = " & Session("CodGrupo")	
					sql = sql & " order by e.RAZAOSOCIAL"
					rs.open sql, cnn
					if rs.eof = false then
					
					while not rs.eof
						cont = cont + 1	
						
						%>
						<tbody>
							<tr>
								<td><%=trim(rs("razaosocial"))%></td>
								<td><a href="<%=trim(rs("link_acesso"))%>" target="_blank"><%=trim(rs("link_acesso"))%></a></td>
								<td><%=trim(rs("numero_ip"))%></td>
							  <td align="center" >
								<button class="btn-u btn-u-sea" onclick="resultadoConsulta(<%=trim(rs("id"))%>)" type="button"><i class="fa fa-file-text-o"></i></button>								
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
            
            var frm = document.getElementById("frm");
            frm.txtCodigo.value=intCodigo;
            frm.submit();
        }
        
        function salvar(acao){
            
            var frm = document.getElementById("frm");
            
            if (frm.cmbEmpresaGrupo.value == "0") {
                alert("A Unidade deve ser informada!");
                frm.cmbEmpresaGrupo.focus();
                return false;
            }

            if (frm.txtIP.value == "") {
                alert("O IP deve ser informado!");
                frm.txtIP.focus();
                return false;
            }
            
            frm.action="ip_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 