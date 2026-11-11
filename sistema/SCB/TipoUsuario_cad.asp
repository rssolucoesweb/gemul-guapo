	<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <script src="../../js/js_funcoes_gerais.js"></script>
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
        intCodTipoUsuario	 	= Trim(Request.Form("txtCodigo"))
        strNome 				= Trim(Request.Form("txtNome"))
        intQtdeExemplar 		= Trim(Request.Form("txtQtdeExemplar"))
        strValor	 			= Trim(Request.Form("txtValor"))
            
        if trim(intCodTipoUsuario) <> "" then
        
            sql = "SELECT Cod_TipoUsuario, Nome, QtdeExemplar, Valor"
            sql = sql & " FROM SCB_TIPOUSUARIO"
            sql = sql & " Where Cod_TipoUsuario = " & intCodTipoUsuario
            sql = sql & " And Cod_empresa = " & session("codEmpresa")
            rs.open sql, cnn
            
            if rs.eof = false then
                
                intCodTipoUsuario		= rs("Cod_TipoUsuario")
                strNome					= rs("Nome")
                intQtdeExemplar			= rs("QtdeExemplar")
                strValor				= formatnumber(rs("Valor"),2)
                
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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Tipo Usuários</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="txtCodigo" type="hidden" class="text" id="txtCodigo" value="<%=intCodTipoUsuario%>" size="10">
                    <div class="form-group">
                        <label class="form-label">Nome </label>
                         <input name="txtNome" type="text" class="form-control" id="txtNome" style="width:350pt" value="<%=strNome%>" size="80" maxlength="100">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Qtde Exemplar</label>
                         <input name="txtQtdeExemplar" type="text" class="form-control" onKeyPress="return formataCampo(this,2,10)" id="txtQtdeExemplar" style="width:100pt" value="<%=intQtdeExemplar%>" size="80" maxlength="10">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Valor</label>
                         <input name="txtValor" type="text" class="form-control" id="txtValor" style="width:100pt" onKeyPress="return currencyFormat(this,event)" value="<%=strValor%>" size="80" maxlength="10">
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
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Tipo Usuários</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="3%" bgcolor="#95A5A6">#</th>
                                    <th width="18%" bgcolor="#95A5A6">Nome</th>
                                    <th width="23%" bgcolor="#95A5A6">Qtde Exemplar</th>
                                    <th width="19%" bgcolor="#95A5A6">R$ Valor</th>
                                  <th width="10%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                              </tr>
                            </thead>
                            <%
							cont =0
							sql = "SELECT Cod_TipoUsuario, Nome, QtdeExemplar, Valor"
							sql = sql & " FROM SCB_TIPOUSUARIO"
							'sql = sql & " Where Cod_empresa = " & session("codEmpresa")
							sql = sql & " Order by Cod_TipoUsuario"
							rs.open sql, cnn
							cont=0
							if rs.eof = false then
							
							while not rs.eof
							cont = cont + 1	
							%>
                            <tbody>
                                <tr>
                                    <td><%=trim(rs("Cod_TipoUsuario"))%></td>
                                    <td><%=trim(rs("Nome"))%></td>
                                    <td><%=trim(rs("QtdeExemplar"))%></td>
                                    <td><%=formatnumber(trim(rs("Valor")),2)%></td>
                                    <td align="center" > <button class="btn-u btn-u-sea" onClick="resultadoConsulta(<%=trim(rs("Cod_TipoUsuario"))%>)" type="button"><i class="fa fa-file-text-o"></i></button> 
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
		
		if (frm.txtNome.value == "") {
			alert("O Nome deve ser informada !");
			frm.txtNome.focus();
			return false;
		}
		
		if (frm.txtQtdeExemplar.value == "") {
			alert("A Qtde de Exemplar deve ser informada !");
			frm.txtQtdeExemplar.focus();
			return false;
		}
		
		if (frm.txtValor.value == "") {
			alert("O Valor deve ser informada !");
			frm.txtValor.focus();
			return false;
		}
		
		frm.action="TipoUsuario_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 