<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../menuModulos.asp"-->  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Gerencial</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        strPaginaTitulo		= "FuncaoColaborador_cad.asp"
        intCodFuncao 		= Trim(Request.Form("txtCodigo"))
        strDescricao 		= Trim(Request.Form("txtDescricao"))
            
        if trim(intCodFuncao) <> "" then
        
            sql = "SELECT DISTINCT COD_FUNCAO, DESC_FUNCAO"
            sql = sql & " FROM SRH_FUNCAOCOLABORADOR"
            sql = sql & " where COD_FUNCAO = " & intCodFuncao
	        rs.open sql, cnn
            
            if rs.eof = false then
                
                intCodFuncao	 		= rs("COD_FUNCAO")
                strDescricao			= rs("DESC_FUNCAO")
                
                strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
                strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
                strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
    
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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Função</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="txtCodigo" type="hidden" class="text" id="txtCodigo" value="<%=intCodFuncao%>" size="10">
                    
                    <div class="form-group">
                        <label class="form-label">Fun&ccedil;&atilde;o </label>
                         <input name="txtDescricao" type="text" class="form-control" id="txtDescricao" style="width:350pt" value="<%=strDescricao%>" size="80" maxlength="100">
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
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Função</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                  <th width="4%" bgcolor="#95A5A6">#</th>
                                  <th width="63%" bgcolor="#95A5A6">Descrição</th>
                                  <th width="12%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                                </tr>
                            </thead>
                            <tbody>
                            <%
							sql = "SELECT COD_FUNCAO, DESC_FUNCAO"
							sql = sql & " FROM SRH_FUNCAOCOLABORADOR"
							sql = sql & " Order by DESC_FUNCAO"
							rs.open sql, cnn
							cont=0
							if rs.eof = false then
							
							while not rs.eof
							cont = cont + 1	
							%>
                                <tr>
                                    <td><%=trim(rs("COD_FUNCAO"))%></td>
                                    <td align="left"><%=trim(rs("DESC_FUNCAO"))%></td>
                                    <td align="center" >
                                    <button class="btn-u btn-u-sea" onClick="resultadoConsulta(<%=trim(rs("COD_FUNCAO"))%>)" type="button"><i class="fa fa-file-text-o"></i></button>                                    </td> 
                                </tr>
                                
                            <%				
								rs.movenext
								wend
							end if
							rs.close
						%>
<tr>
                                  <td bgcolor="#95A5A6"><strong>Total:</strong></td>
              <td colspan="2" align="left" bgcolor="#95A5A6"><strong><%=cont%></strong></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>                      
                </div>
                <!--End Table Bordered-->	   	   
      </div>
       <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
    <script>
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtDescricao.value == "") {
			alert("A Função deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		
		frm.action="FuncaoColaborador_cod.asp?acao=" + acao;
		frm.submit();
		return true;
		
	}
	
		function resultadoConsulta(intCodigo){
			var frm = document.getElementById("frm");
			frm.txtCodigo.value=intCodigo;
			frm.submit();
		}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 