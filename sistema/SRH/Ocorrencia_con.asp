<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"--> 
<!--#include file="../../includes/inc_replaceRequest.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>
        <!--=== Breadcrumbs ===-->
  
<div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo RH</h1>
            <ul class="pull-right breadcrumb">
                <li>Consulta de Ocorr&ecirc;ncia </li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        strExecutarSubmitSemestre    = "S"
        strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
        if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
        intSemestre 			= Trim(Request.Form("cmbSemestre"))
        if intSemestre = "" then 	intSemestre  = session("strSemestre")
    
        strDepartamento		= Trim(Request("cmbDepartamento"))
        strColaborador			= Trim(Request("txtColaborador"))
    %>
    <!--=== Content Part ===-->
    <form method="POST" id="frm" action="#">
    <input name="cmbDepartamento" type="hidden" id="cmbDepartamento"  value="<%=strDepartamento%>" />
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Consulta de Ocorr&ecirc;ncia </h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
               
                    <div class="form-group">
                        <label for="exampleInputEmail1">Ano Letivo</label>
                        <input  name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
                    </div>
                    
                     <div class="form-group">
                        <label for="exampleInputEmail1">Semestre</label>
                         <!--#include file="../includes/inc_cmdSemestre.asp" -->
                    </div>
                    
                     <div class="form-group">
                        <label for="exampleInputEmail1">Nome do Colaborador</label>
                        <input name="txtAluno" type="text" class="form-control" id="txtAluno" size="50" maxlength="50" value="<%=strColaborador%>" />
                    </div>
                    
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_consultaPopap.asp"-->
                
            	</div>
           
       <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Ocorrência</h3>
            </div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th width="5%" bgcolor="#95A5A6">Código</th>
                            <th width="86%" bgcolor="#95A5A6">Matrícula </th>
                            <th width="86%" bgcolor="#95A5A6">Colaborador</th>
                            <th width="86%" bgcolor="#95A5A6">Data Ocorrência</th>
                            <th width="9%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                        </tr>
                    </thead>
                    <tbody>
 					<%
					cont = 0
					sql = "SELECT O.COD_OCORRENCIA, O.COD_DEPARTAMENTO, O.COD_Colaborador, A.CPF, A.NOME, O.DATAOCORRENCIA"
					sql = sql & " FROM SRH_OCORRENCIA O"
					sql = sql & " LEFT JOIN SRH_Colaborador A ON A.CODIGO = O.COD_Colaborador"
					sql = sql & " where O.cod_empresa = " & Session("CodEmpresa")			
					sql = sql & " and O.COD_DEPARTAMENTO = " & strDepartamento	
					sql = sql & " and O.ano_letivo = " & strAnoLetivo
					sql = sql & " and O.semestre in (" & intSemestre & ")"
					IF trim(strAluno) <> "" then
						sql = sql & " AND A.NOME LIKE '" & strAluno & "%'"
					END IF
					sql = sql & " order by O.DATAOCORRENCIA DESC"
	
					rs.open sql, cnn
					
					if rs.eof = false then
					
						while not rs.eof
						   	cont = cont + 1	
							%>
                            <tr>
                                <td><%=trim(rs("COD_OCORRENCIA"))%></td>
                                <td><%=trim(rs("CPF"))%></td>
                                <td><%=trim(rs("NOME"))%></td>
                                <td><%=formatadataap(trim(rs("DATAOCORRENCIA")))%></td>
                                <td><button class="btn-u btn-u-sea" onClick="resultadoConsulta('<%=rs("COD_OCORRENCIA")%>')" type="button"><i class="fa fa-file-text-o"></i></button>									</td> 
                            </tr>
							<%				
                        rs.movenext
                        wend
                    end if
                    rs.close
                %>
                	<tr>
                      <td colspan="5">Total Registros :</span> <%=cont%></td>
                  	</tr>
                	</tbody>
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
        function resultadoConsulta(intCodigo){
            window.opener.document.getElementById('txtCodigo').value = intCodigo;
            window.opener.document.getElementById('frm').submit();
            window.close();
        }
    </script>
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 