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
                <li>Consulta de Rubricas</li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        strNome 		= Trim(Request("txtNome"))
    %>
    <!--=== Content Part ===-->
	<form method="POST" id="frm" action="#">
    <div class="container content">		
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Consulta de Rubricas </h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
            <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
           
                <div class="form-group">
                    <label for="exampleInputEmail1">Rubrica</label>
                     <input name="txtnome" type="text" class="text" id="txtnome" size="50" maxlength="70" value="<%=strnome%>">
                </div>
                            
                <legend></legend>
                 <!--#include file="../../includes/inc_botoes_consultaPopap.asp"-->
            
            </div>
           
       <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Rubricas</h3>
            </div>
            <div class="panel-body">
            	<div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th width="5%" bgcolor="#95A5A6">Código</th>
                            <th width="86%" bgcolor="#95A5A6">Rubrica </th>
                            <th width="86%" bgcolor="#95A5A6">Con<span class="TextoForm">v&ecirc;nio</th>
                            <th width="9%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                        </tr>
                    </thead>
 					<%
					cont = 0
					sql = " SELECT SRH_RUBRICA.CODIGO, SRH_RUBRICA.DESCRICAO, SRH_CONVENIO.DESCRICAO AS CONVENIO"
					sql = sql & " FROM SRH_RUBRICA"
					sql = sql & " LEFT JOIN SRH_CONVENIO ON SRH_CONVENIO.CODIGO = SRH_RUBRICA.COD_CONVENIO "
					sql = sql & " Where SRH_RUBRICA.Cod_grupo = " & session("codGrupo")
					
					if strNome <> "" then
						sql = sql & " And SRH_RUBRICA.DESCRICAO LIke '%" & strNome & "%' COLLATE SQL_Latin1_General_CP1_CI_AI "
					end if
					
					sql = sql & " Order by SRH_RUBRICA.DESCRICAO"
					
					rs.open sql, cnn
					
					if rs.eof = false then
					
						while not rs.eof
						cont = cont + 1		
 						%>
                        <tbody>
                        <tr>
                            <td><%=trim(rs("Codigo"))%></td>
                            <td><%=trim(rs("DESCRICAO"))%></td>
                           	<td><%=trim(rs("CONVENIO"))%></td>
                            <td><button class="btn-u btn-u-sea" onClick="resultadoConsulta('<%=rs("Codigo")%>','<%=rs("DESCRICAO")%>')" type="button"><i class="fa fa-file-text-o"></i></button> 
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
        function resultadoConsulta(intCodigo, strNome){
            window.opener.document.getElementById('txtCodRubrica').value = intCodigo;
            window.opener.document.getElementById('txtNomeRubrica').value =  strNome; 
            window.opener.document.getElementById('frm').submit();
            window.close();
        }
    </script>
<!--#include file="../jsModulo.asp"-->
</body>
</html> 