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
    strPaginaTitulo = "Situacao_cad.asp"
    
    intCodigo	 		    = Trim(Request.Form("txtCodigo"))
    strDescricao 		    = Trim(Request.Form("txtDescricao"))
    strDescricaoAntiga 		= Trim(Request.Form("txtDescricaoAntiga"))
        
    if trim(intCodigo) <> "" then
    
        sql = "SELECT Cod_SituacaoAluno, Desc_SituacaoAluno"
        sql = sql & " FROM SCA_SITUACAOALUNO"
        sql = sql & " where Cod_SituacaoAluno = " & intCodigo
        rs.open sql, cnn
        
        if rs.eof = false then
            
            intCodigo	 			= rs("Cod_SituacaoAluno")
            strDescricao			= rs("Desc_SituacaoAluno")
            strDescricaoAntiga 		= rs("Desc_SituacaoAluno")
            
            strDesabilitaIncluir = ""'Desabilita o botão Incluir
            strDesabilitaAlterar = "disabled" 'Desabilita o botão Alterar
            strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
            strDesabilitaLimpar  = "" 'Habilita o Botão Limpar
    
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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Situação</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="txtCodigo" type="hidden" class="text" id="txtCodigo" value="<%=intCodigo%>" size="10">
                    <div class="form-group">
                        <label class="form-label">Situação</label>
                         <input name="txtDescricao" type="text" class="form-control" id="txtDescricao" style="width:350pt" value="<%=strDescricao%>" size="80" maxlength="100">
                         <input name="txtDescricaoAntiga" type="hidden" class="text" id="txtDescricaoAntiga" size="40" maxlength="40" value="<%=strDescricaoAntiga%>">
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
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Situação</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="5%" bgcolor="#95A5A6">#</th>
                                    <th width="86%" bgcolor="#95A5A6">Descrição</th>
                                    <th width="86%" bgcolor="#95A5A6">Situação</th>
                                    <th width="9%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                                </tr>
                            </thead>
                            <%
							sql = "SELECT  Cod_SituacaoAluno, Desc_SituacaoAluno"
							sql = sql & " FROM SCA_SITUACAOALUNO"
							sql = sql & " Order by Desc_SituacaoAluno"
							rs.open sql, cnn
							cont=0
							if rs.eof = false then
							
							while not rs.eof
							cont = cont + 1	
							%>
                            <tbody>
                                <tr>
                                    <td><%=trim(rs("Cod_SituacaoAluno"))%></td>
                                    <td><%=trim(rs("Cod_SituacaoAluno"))%></td>
                                    <td align="center"><%=trim(rs("Desc_SituacaoAluno"))%></td>
                                    <td align="center" >
                                    <button class="btn-u btn-u-sea" onClick="resultadoConsulta(<%=trim(rs("Cod_SituacaoAluno"))%>)" type="button"><i class="fa fa-file-text-o"></i></button> 
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
		
		if (frm.txtDescricao.value == "") {
			alert("A Situação deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		
		frm.action="Situacao_cod.asp?acao=" + acao;
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