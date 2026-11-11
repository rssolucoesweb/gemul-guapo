<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>
<!--=== Breadcrumbs ===-->
  
<div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">EST - Controle Almoxarifado</h1>
            <ul class="pull-right breadcrumb">
                <li>Consulta de Entradas </li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        strNome = Request.Form("txtNome")
    %>
    <!--=== Content Part ===-->
    <form method="POST" id="frm" name="frm" action="#">
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
       
       <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Consulta de Entradas </h3>
            </div>
            <div class="panel-body">
            	<div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="6%" bgcolor="#95A5A6">Codigo</th>
                          <th width="38%" bgcolor="#95A5A6">Fornecedor</th>
                          <th width="26%" bgcolor="#95A5A6">N/Nota</th>
                          <th width="18%" bgcolor="#95A5A6">Valor</th>
                          <th width="12%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                      </tr>
                    </thead>
 					<%
						cont =0
						sql = " SELECT E.Codigo, E.CodEmpresa, E.CodFornecedor, E.Numero, E.Data_Entrada, E.Valor_Total, "
						sql = sql & " F.razaosocialNome as NOME_FANTASIA"
						sql = sql & " FROM EST_Entrada E "
						sql = sql & " inner join EST_FORNECEDOR F on F.Codigo = E.CodFornecedor"
						sql = sql & " Where E.CodEmpresa = " & session("codEmpresa")
						sql = sql & " Order by codigo desc "
						rs.open sql, cnn

						if rs.eof = false then
							while not rs.eof
							cont = cont + 1		
							%>
							<tbody>
								<tr>
									<td><%=rs("Codigo")%></td>
									<td><%=rs("NOME_FANTASIA")%></td>
									<td><%=rs("Numero")%></td>
                                    <td><%=formatnumber(rs("Valor_Total"),2)%></td>
									<td><button class="btn-u btn-u-sea" onClick="resultadoConsulta('<%=rs("Codigo")%>')" type="button"><i class="fa fa-file-text-o"></i></button> 
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
	function Consulta(){
		frm.submit();
	}

	function resultadoConsulta(intCodigo){
		window.opener.document.getElementById("txtCodigo").value=intCodigo
		window.opener.document.getElementById("frm").submit();
		window.close();
	}
	</script>
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 