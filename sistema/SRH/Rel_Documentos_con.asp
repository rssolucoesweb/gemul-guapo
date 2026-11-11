<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">SRH - Recurso Humano</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        strPaginaTitulo 		= "Rel_Documentos_con.asp"
        intCodModeloDocumento	= Trim(Request.form("cmbModeloDocumento"))
        strCabecalho			= Trim(Request.form("cmbCabecalho"))
        if strCabecalho = "" then strCabecalho = "S"
    %>
    <!--=== Content Part ===-->
    <form method="post" id="frm" action="#">
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Emissão de Documentos</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
			
					  <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Documentos</label>
                        <div class="col-lg-10">
                        	<!--#include file="../includes/inc_cmbModeloDocumentoColaborador.asp"-->
                        </div>
               		 </div>
                     
                     <div class="form-group">
                    	<label for="inputEmail1" class="col-lg-2 control-label">Cabe&ccedil;alho</label>
                        <div class="col-lg-10">
                        	<select name="cmbCabecalho" class="form-control" id="cmbCabecalho"  style="width:50pt" >
                            <option value="0">Selecione...</option>
                            <option value="S" <%if strCabecalho = "S" then response.Write("selected") %>>Sim</option>
                            <option value="N" <%if strCabecalho = "N" then response.Write("selected") %>>Não</option>
                          </select>
                        </div>
               		 </div>
                 
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->
                
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
      
       <!--Table Bordered-->
       <%if strMatricula = "" then%> 
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Colaboradores</h3>
            </div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="4%" bgcolor="#95A5A6"><input type="checkbox" name="chkTodos" onClick="return MarcaTodos(this.checked)"></th>
                          <th width="20%" bgcolor="#95A5A6">Matricula</th>
                          <th width="76%" bgcolor="#95A5A6">Colaborador</th>
                      </tr>
                    </thead>
                     <tbody>
                    <%
                    cont =0

					sql = "SELECT CODIGO, CODFUNCIONAL AS MATRICULA, NOME"
					sql = sql & " FROM SRH_COLABORADOR "
					sql = sql & " where cod_empresa = " & session("CodEmpresa")
					sql = sql & " Order By NOME"

                    rs.open sql, cnn
                    if rs.eof = false then
                    
                    while not rs.eof
                        cont = cont + 1
				    	%>
                        <tr>
                            <td><input type="checkbox" id="chkColaborador" name="chkColaborador" <%=strDesabilitaColaborador%> value="<%=rs("codigo")%>"></td>
                            <td><%=rs("MATRICULA")%></td>
                            <td><%=rs("NOME")%></td>
                        </tr>
                    	<%				
                        rs.movenext
                        wend
                    end if
                    rs.close
                	%>
                    <tr>
                        <td colspan="5">Total Registros : <%=cont%></td>
                    </tr>
                    </tbody>
                </table>
            </div>                      
        </div>
        <%end if%>
        <!--End Table Bordered-->	
        
     <!-- Fecha o Painel do Formulario -->        
    </div>
    </form>
    <!--/container-->		
	<script>
        function gerar(){
            var form = window.document.forms[0];
            var intContMarcado=0;
            var strColaboradors='';
            if (frm.cmbModeloDocumento.value == "0") {
                alert("O Modelo do Documento deve ser informado!");
                frm.cmbModeloDocumento.focus();
                return false;
            }
            //*****verifica se um Colaborador foi selecionado
            intContMarcado=0;
            for (var i = 0; i < form.elements.length; i++) {
                //verifica todos os checkbox
                if (form.elements[i].type == "checkbox"){
                    if (form.elements[i].name == "chkColaborador"){
                        //verifica se o checkbox está marcado
                        if (form.elements[i].checked){
                            intContMarcado = intContMarcado + 1;
                        }
                    }
                }
            }	
            if (intContMarcado==0){
                alert("O Colaborador deve ser informado ou selecionado!");
                return false;
            }
            frm.action = "Rel_Documentos_rel.asp";
            frm.submit();
            
            return true;	
        }
    </script>

    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 