<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"--> 
<!--#include file="../../includes/inc_replaceRequest.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
<script src="js/js_funcoes_gerais.js"></script>

<script src="../../js/js_funcoes_gerais.js"></script>
        <!--=== Breadcrumbs ===-->
      
  
<div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo RH</h1>
            <ul class="pull-right breadcrumb">
                <li>Cadastro Excessão - Escola </li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
		intCodigo = request("codExcessao")
		
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
    %>
    <form method="post" id="frm" action="Notas_con.asp">
    <input  name="codExcessao" type="hidden" id="codExcessao" value="<%=intCodigo%>">
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro Excessão - Escola</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
               
                    <div class="form-group">
                    
                    	<table class="table table-bordered">
                        <tr> 
                        <td width="38" align="center" class="celula">
                          <input type="checkbox" name="chkTodos" onClick="return MarcaTodos(this.checked)"></td>
                        <td width="1228" class="celula"><strong>Escola</strong></td>
                        </tr>
                        <%	
                        sql = "select e.codigo, e.razaosocial"
                        sql = sql & " from seg_empresa e "
                        sql = sql & " where e.bloqueio = 'N' and e.codigo not in (108) AND cod_grupo = " & Session("CodGrupo")  
                        sql = sql & " order by 2"
                        rs.open sql, cnn
                        if rs.eof = false then
                           while not rs.eof
                                selecionado=""
                                sql = "select 'checked' as selecionado "
                                sql = sql & " from SRH_EXCESSOES_PERIODOMODULACAO_UNIDADE "
                                sql = sql & " where Cod_SRH_EXCESSOES_PERIODOMODULACAO = " & intCodigo
                                sql = sql & " and Cod_SEG_EMPRESA = " & rs("codigo")
                                rsAux.open sql, cnn
                                if rsAux.eof = false then
                                   selecionado = rsAux("selecionado")
                                end if
                                rsAux.close
                             %>
                             <tr> 
                             <td class="celula" align="center"><input type="checkbox" id="chkEscola" name="chkEscola" <%=selecionado%> value="<%=rs("codigo")%>"></td>
                             <td class="celula"><%=rs("razaosocial")%></td>
                             </tr>
                             <%
                             rs.movenext
                          wend
                      end if
                      rs.close
                   %>
                   </table>
   
                    </div>
                    <legend></legend>
                     <!--#include file="../../includes/inc_botoes_cadastroPopap.asp"-->
            	</div>
	
		       <!-- Fecha o Painel do Formulario -->    
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
	  <div id="divRetorno"></div>
       <!-- Fecha o Painel do Formulario -->        
    </div>
    </form>
    <!--/container-->		
	<script>
        function salvar(){
            frm.action = "ExcessaoModulacaoUnidade_cod.asp";
            frm.submit();
            return true;	
        }
    </script>
<!--#include file="../jsModulo.asp"-->
</body>
</html> 