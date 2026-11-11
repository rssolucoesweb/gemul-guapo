	<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Biblioteca</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
	
	intCodConhecimento	= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
		
	if trim(intCodConhecimento) <> "" then
	
		sql = "SELECT Cod_Conhecimento, Nome_Conhecimento"
		sql = sql & " FROM SCB_AreaConhecimento"
		sql = sql & " Where Cod_Conhecimento = " & intCodConhecimento
		sql = sql & " And Cod_empresa = " & session("codEmpresa")
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo				= rs("Cod_Conhecimento")
			strDescricao			= rs("Nome_Conhecimento")
			
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir

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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Area do Conhecimento</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="txtCodigo" type="hidden" class="text" id="txtCodigo" value="<%=intCodigo%>" size="10">
                    <div class="form-group">
                        <label class="form-label">Descrição</label>
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
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Area do Conhecimento</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="5%" bgcolor="#95A5A6">#</th>
                                    <th width="86%" bgcolor="#95A5A6">Descrição</th>
                                    <th width="9%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                                </tr>
                            </thead>
                            <%
							sql = "SELECT Cod_Conhecimento, Nome_Conhecimento"
							sql = sql & " FROM SCB_AreaConhecimento"
							sql = sql & " Where Cod_empresa = " & session("codEmpresa")
							sql = sql & " Order by Cod_Conhecimento"
							rs.open sql, cnn
							cont=0
							if rs.eof = false then
							
							while not rs.eof
							cont = cont + 1	
							%>
                            <tbody>
                                <tr>
                                    <td><%=trim(rs("Cod_Conhecimento"))%></td>
                                    <td><%=trim(rs("Nome_Conhecimento"))%></td>
                                    <td align="center" >
                                    <button class="btn-u btn-u-sea" onClick="resultadoConsulta(<%=trim(rs("Cod_Conhecimento"))%>)" type="button"><i class="fa fa-file-text-o"></i></button> 
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
		
		if (frm.txtDescricao.value == "") {
			alert("A Descrição deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		
		frm.action="AreaConhecimento_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 