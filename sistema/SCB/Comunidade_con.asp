<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>
        <!--=== Breadcrumbs ===-->
      
<div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Biblioteca</h1>
            <ul class="pull-right breadcrumb">
                <li>Consulta Comunidade</li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        strAluno				= Trim(Request("txtAluno"))
        strMatricula			= Trim(Request("txtMatricula"))
        strcpf					= Trim(Request("txtcpf"))
        strConsultar			= Trim(Request("strConsultar"))
        strMostraTurmas			= Trim(Request.Form("MostraTurmas"))
    %>
    <!--=== Content Part ===-->
     <form id="frm" class="margin-bottom-10" method="post">
    <input name="strConsultar" type="hidden" value="S">
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Consulta de Comunidade</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <div class="form-group">
                    <label for="exampleInputEmail1">Nome</label>
                    <input name="txtNome" type="text" class="form-control" id="txtNome" size="50" maxlength="50" value="<%=strNome%>" />
                </div>
                <legend></legend>
                <!--#include file="../../includes/inc_botoes_consultaPopap.asp"-->
            </div>
           
       <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Comunidade</h3>
            </div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th width="5%" bgcolor="#95A5A6">Codigo</th>
                            <th width="86%" bgcolor="#95A5A6">Nome</th>
                            <th width="9%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                        </tr>
                    </thead>
 					<%
					
					cont =0
			
					sql = "SELECT Codigo, Nome"
					sql = sql & " FROM SCB_COMUNIDADE"
					sql = sql & " Where Cod_empresa = " & session("codEmpresa")
					
					if strTitulo <> "" then
						sql = sql & " and Nome LIKE '" & strNome & "%'"
					end if
					
					sql = sql & " order by Nome"
					rs.open sql, cnn
					if rs.eof = false then
						while not rs.eof
							cont = cont + 1	
							%>
							<tbody>
								<tr>
									<td><%=trim(rs("Codigo"))%></td>
									<td><%=trim(rs("Nome"))%></td>
									<td><button class="btn-u btn-u-sea" onClick="resultadoConsulta('<%=rs("Codigo")%>','<%=rs("Nome")%>')" type="button"><i class="fa fa-file-text-o"></i></button> 
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
         	<!-- Fecha o Form -->  
      </div>
	  <div id="divRetorno"></div>
       <!-- Fecha o Painel do Formulario -->        
    </div>
    </form>
    <!--/container-->		
	<script>
	function resultadoConsulta(intCodigo, strNome){
		window.opener.frm.txtCodComunidade.value = intCodigo;
		window.opener.frm.txtNomeComunidade.value = strNome;
		window.opener.frm.txtNomeComunidade.value = strNome;
		//window.opener.frm.submit();
		window.close();
	}
	</script>
<!--#include file="../jsModulo.asp"-->
</body>
</html> 