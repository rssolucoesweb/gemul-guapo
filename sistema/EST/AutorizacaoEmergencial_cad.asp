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
        principal			= "principal.asp"
        intCodEmpresa			= session("CodEmpresa")	
        intCodigo 				= Trim(Request.Form("txtCodigo"))
        intCodDepartamento 		= Trim(Request.Form("cmbDepartamento"))
		
        if intCodDepartamento = "" then intCodDepartamento = 0
        intCodUsuario	 		= Trim(Request.Form("cmbUsuario"))
    
        strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
        strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
        strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Autorização Emergencial</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	
                  <div class="form-group">
                    <label class="form-label">Unidade</label>
                    <%strSubmitDepto = "S"%><!--#include file="../includes/inc_cmbDepartamentoEstoque.asp"-->
                  </div>
                  
                   <div class="form-group">
                    <label class="form-label">Solicitante</label>
                    <!--#include file="../includes/inc_cmbUsuariosDepartamento.asp"-->
                  </div>

                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                </form>
       	  </div>
   	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
       <%if intCodDepartamento <> "0" then %>
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Autorização Emergencial</h3>
          </div>
            <div class="panel-body">
            	<div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="4%" bgcolor="#95A5A6">Aut.</th>
                          <th width="18%" bgcolor="#95A5A6">Unidade</th>
                          <th width="21%" bgcolor="#95A5A6">Solicitante</th>
                          <th width="20%" bgcolor="#95A5A6">Situa&ccedil;&atilde;o</th>
                          <th width="31%" bgcolor="#95A5A6">Data</th>
                          <th width="6%" bgcolor="#95A5A6" align="center"><div align="center">Excluir</div></th>
                      </tr>
                    </thead>
                  <%
                    cont =0
					
					sql = "select a.codigo, upper(u.nome) as nome, d.DESCRICAO as depto, a.situacao, a.data"
					sql = sql & " from EST_RequisicaoEmergencialAutorizacao a"
					sql = sql & " inner join SEG_usuarios u on u.cpf = a.solicitante"
					sql = sql & " inner join EST_departamento d on d.codigo = u.codDepartamento"
					sql = sql & " Where a.CodEmpresa	= " & session("codEmpresa")	
					sql = sql & " order by a.data desc"
				    rs.open sql, cnn
                    if rs.eof = false then
                    
                    while not rs.eof
						cont = cont + 1	
			        %>
                    <tbody>
                        <tr>
                          <td><%=trim(rs("Codigo"))%></td>
                          <td><%=trim(rs("depto"))%></td>
                          <td><%=trim(rs("nome"))%></td>
                          <td><%=trim(rs("situacao"))%></td>
                          <td><%=trim(rs("data"))%></td>
                          <td align="center" >
						  <%if trim(rs("situacao")) = "AUTORIZADO" then%>
                          	<button class="btn-u btn-u-sea" onClick="excluir(<%=trim(rs("Codigo"))%>)" type="button"><i class="fa fa-file-text-o"></i></button> 
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
    
    
        function excluir(codigo){
            
            var frm = document.getElementById("frm");
            
            var men = 'ATENÇÃO: Deseja excluir essa autorização?\n';
            if (confirm(men)) {
                frm.action="AutorizacaoEmergencial_cod.asp?acao=E&txtCodigo=" + codigo;
                frm.submit();
                return true;
            }else{
                return false;
            }
            
        }
        function salvar(acao){
            
            var frm = document.getElementById("frm");
            
            if (frm.cmbDepartamento.value == "0") {
                alert("A Unidade deve ser informada !");
                frm.cmbDepartamento.focus();
                return false;
            }
            
            if (frm.cmbUsuario.value == "0") {
                alert("Usuário deve ser informado!");
                frm.cmbUsuario.focus();
                return false;
            }
            
            frm.action="AutorizacaoEmergencial_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 