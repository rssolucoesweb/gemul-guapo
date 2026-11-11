<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnnDocumento.asp"-->
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
	
	strPaginaTitulo 	= "Documento_cad.asp"
	strPagina			= "Documento_cad.asp"
	intCodDocumento		= Trim(Request("txtCodigo"))
	strTitulo	 		= Trim(Request.Form("txtTitulo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
            
	if trim(intCodDocumento) <> "" then
	
		sql = "SELECT codigo, titulo, Documento, campos, cod_departamento, posicaofinanceira, situacaoaluno"
		sql = sql & " FROM SCA_DOCUMENTO"
		sql = sql & " Where codigo = " & intCodDocumento
		rs.open sql, cnn
		
		if rs.eof = false then
			
			strTitulo 				= rs("Titulo")
			strDescricao			= rs("Documento")
			'strDescricao 			= REPLACE(REPLACE(rs("documento"),"&lt;","["),"&gt;","]")
			strCampos				= rs("campos")
			intCodDepartamento		= rs("cod_departamento")
			strSituacaoAluno		= rs("situacaoaluno")
			
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir

		end if 
		rs.close
		
	else
		strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Projetos Sociais</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="txtCodigo" type="hidden" class="text" id="txtCodigo" value="<%=intCodDocumento%>">
                	<input name="txtDescricao" type="hidden" class="text" id="txtDescricao" value="<%=strDescricao%>">
                	<input name="campos" type="hidden" class="text" id="campos" value="<%=strCampos%>">
                	<input name="posicaofinanceira" type="hidden" class="text" id="posicaofinanceira" value="<%=strPosicaoFinanceira%>">
                	<input name="situacaoaluno" type="hidden" class="text" id="situacaoaluno" value="<%=strSituacaoAluno%>">
                	<input name="cmbDepartamento" type="hidden" class="text" id="cmbDepartamento" value="<%=intCodDepartamento%>">
                    <input name="txtDescricaoAntiga" type="hidden" class="text" id="txtDescricaoAntiga" value="<%=strTitulo%>">

                    <div class="form-group">
                        <label class="form-label">Título:</label>
					  	<input name="txtTitulo" type="text" class="text" id="txtTitulo" size="50" maxlength="50" value="<%=strTitulo%>">
                    </div>

                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
                <div class="panel panel-grey margin-bottom-40">
                    <div class="panel-heading">
                        <h3 class="panel-title"><i class="fa fa-globe"></i>Lista Documentos</h3>
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
							sql = "SELECT CODIGO, TITULO"
							sql = sql & " FROM SCA_DOCUMENTO"
							sql = sql & " Order by TITULO"
							rs.open sql, cnn
							cont=0
							if rs.eof = false then
							
							while not rs.eof
							cont = cont + 1	
							%>
                            <tbody>
                                <tr>
                                    <td><%=trim(rs("CODIGO"))%></td>
                                    <td><%=trim(rs("TITULO"))%></td>
                                    <td align="center" >
                                    <button class="btn-u btn-u-sea" onClick="resultadoConsulta(<%=trim(rs("CODIGO"))%>)" type="button"><i class="fa fa-file-text-o"></i></button> 
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
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtTitulo.value == "") {
			alert("Titulo deve ser informado!");
			frm.txtTitulo.focus();
			return false;
		}
		
		if (frm.cmbDepartamento.value == "0") {
			alert("O departamento deve ser informado!");
			frm.cmbDepartamento.focus();
			return false;
		}
		
		frm.action="Documento_cod.asp?acao=" + acao;
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