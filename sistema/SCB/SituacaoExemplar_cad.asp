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
        strPaginaTitulo 	= "SituacaoExemplar_cad.asp"
        intCodSituacao 		= Trim(Request.Form("txtCodigo"))
        strDescricao 		= Trim(Request.Form("txtDescricao"))
        strSituacao 		= Trim(Request.Form("cmbSituacao"))
            
        if trim(intCodSituacao) <> "" then
        
            sql = "SELECT Codigo, Cod_empresa, Descricao, Situacao"
            sql = sql & " FROM SCB_SITUACAOEXEMPLAR"
            sql = sql & " where Cod_empresa = " & Session("CodEmpresa")			
            sql = sql & " and Codigo = " & intCodSituacao
            rs.open sql, cnn
            
            if rs.eof = false then
                
                intCodSituacao	 	= rs("Codigo")
                strDescricao		= rs("Descricao")
                strSituacao			= rs("Situacao")
                
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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Situação Exemplar</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="txtCodigo" type="hidden" class="text" id="txtCodigo" value="<%=intCodSituacao%>" size="10">
                    <div class="form-group">
                        <label class="form-label">Descrição</label>
                         <input name="txtDescricao" type="text" class="form-control" id="txtDescricao" style="width:350pt" value="<%=strDescricao%>" size="80" maxlength="100">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Situação</label>
                        <select name="cmbSituacao" class="form-control" id="cmbSituacao"  style="width:130pt">
                          <option value="A" <%if strSituacao = "A" then response.Write("selected") %>>Ativo</option>
                          <option value="I" <%if strSituacao = "I" then response.Write("selected") %>>Inativo</option>
                        </select>
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
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Situação Exemplar</h3>
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
							sql = "SELECT Codigo, Cod_empresa, Descricao, Situacao"
							sql = sql & " FROM SCB_SITUACAOEXEMPLAR"
							sql = sql & " where Cod_empresa = " & Session("CodEmpresa")	
							rs.open sql, cnn
							cont=0
							if rs.eof = false then
							
							while not rs.eof
							cont = cont + 1	
							
							if trim(rs("Situacao")) = "A" then
								strSituacao = "Ativo"
							else
								strSituacao = "Inativo"
							end if		
					
							%>
                            <tbody>
                                <tr>
                                    <td><%=trim(rs("CODIGO"))%></td>
                                    <td><%=trim(rs("DESCRICAO"))%></td>
                                    <td align="center"><%=trim(strSituacao)%></td>
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
		
		if (frm.cmbSituacao.value == "0") {
			alert("A Situação deve ser informada !");
			frm.cmbSituacao.focus();
			return false;
		}
		
		frm.action="SituacaoExemplar_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 