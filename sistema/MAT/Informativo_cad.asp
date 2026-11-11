<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnnDocumento.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <script src="../ckeditor/ckeditor.js"></script>
	<script src="../ckeditor/config.js"></script>

    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Matrícula</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	
    <%
	strPaginaTitulo 		= "Informativo_cad.asp"
	strPagina				= "Informativo_cad.asp"
	
	intCodGrupo	 			= Session("CodGrupo")
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	intCodTipoEmpresa		= Trim(Request("cmbTipoEmpresa"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	strDados 				= Trim(Request.Form("txtDados"))
		
	if trim(intCodigo) <> "" then
	
		sql = "SELECT Codigo, Cod_grupo, CodTipoEmpresa, Descricao, Dados"
		sql = sql & " FROM MAT_Dados"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And Cod_grupo = " & Session("CodGrupo")
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 			= rs("codigo")
			intCodTipoEmpresa 		= rs("CodTipoEmpresa")
			strDescricao	 		= rs("Descricao")
			strDados	 			= rs("Dados")
	
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			
		else
				
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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Informativo - Matrícula </h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="txtCodigo" type="hidden" class="text" id="txtCodigo" value="<%=intCodigo%>" size="10">
                    
                    <div class="form-group">
                        <label class="form-label">Tipo Empresa</label>
                          <!--#include file="../includes/inc_cmbTipoEmpresa.asp"-->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Descrição</label>
                         <input name="txtDescricao" type="text" class="form-control" id="txtDescricao" style="width:350pt" value="<%=strDescricao%>" size="80" maxlength="100">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Dados</label>
                        <Textarea class="ckeditor" cols="80" id="txtDados" name="txtDados"><%=strDados%></textarea>
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
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Informativos</h3>
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
							sql = "SELECT Codigo, Cod_grupo, CodTipoEmpresa, Descricao, Dados"
							sql = sql & " FROM MAT_Dados"
							sql = sql & " Where Cod_grupo = " & session("CodGrupo")
							sql = sql & " Order by codigo"
							rs.open sql, cnn
							cont=0
							if rs.eof = false then
							
							while not rs.eof
							cont = cont + 1	
							%>
                            <tbody>
                                <tr>
                                    <td><%=trim(rs("Codigo"))%></td>
                                    <td><%=trim(rs("Descricao"))%></td>
                                    <td align="center" >
                                    <button class="btn-u btn-u-sea" onClick="resultadoConsulta(<%=trim(rs("CODIGO"))%>)" type="button"><i class="fa fa-file-text-o"></i></button>  
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
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmbTipoEmpresa.value == "0") {
			alert("O  Tipo Empresa deve ser informado !");
			frm.cmbTipoEmpresa.focus();
			return false;
		}
		
		if (frm.txtDescricao.value == "") {
			alert("A Descrição deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		
		frm.action="Informativo_cod.asp?acao=" + acao;
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