<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
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
        strExecutarSubmitCurso	= "S"
        strPaginaTitulo 	= "Regencia_cad.asp"
        intCodigo			= Trim(Request.Form("txtCodigo"))
        intCodEmpresa 		= session("codEmpresa")
        intCodGrupo			= Session("CodGrupo")
        intCodCurso	 		= Trim(Request.Form("cmbCurso"))
        intCodPeriodo 		= Trim(Request.Form("cmbPeriodo"))
        strRegencia 		= Trim(Request.Form("txtRegencia"))
        strDescricao 		= Trim(Request.Form("txtDescricao"))
        
        if trim(intCodigo) <> "" then
        
            sql = "SELECT Codigo, Cod_Empresa, Cod_Grupo, Cod_Curso, Periodo, Regencia, Descricao"
            sql = sql & " FROM SRH_REGENCIACOLABORADOR"
            sql = sql & " where Cod_grupo = " & intCodGrupo			
            sql = sql & " and Codigo = " & intCodigo
            rs.open sql, cnn
            
            if rs.eof = false then
                
                intCodigo	 		= rs("Codigo")
                intCodEmpresa 		= rs("Cod_Empresa")
                intCodGrupo			= rs("Cod_Grupo")
                intCodCurso			= rs("Cod_Curso")
                intCodPeriodo 		= rs("Periodo")
                strRegencia			= formatnumber(rs("Regencia"),2)
                strDescricao		= rs("Descricao")
            
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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Regência</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                
                	<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
                    
                    <div class="form-group">
                        <label class="form-label">Curso</label>
                        
                        <!--#include file="../includes/inc_cmdCurso.asp"-->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Periodo</label>
                        <!--#include file="../includes/inc_cmdPeriodo.asp"-->
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Regencia</label>
                        <input name="txtRegencia" type="text" class="form-control" id="txtRegencia"  onKeyPress="return currencyFormat(this,event)" size="11" maxlength="11" value="<%=strRegencia%>" >
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Descri&ccedil;&atilde;o</label>
                   		<input name="txtDescricao" type="text" class="form-control" id="txtDescricao" size="40" maxlength="40" value="<%=strDescricao%>">
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
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Regência</h3>
            </div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="7%" bgcolor="#95A5A6">C&oacute;digo</th>
                          <th width="73%" bgcolor="#95A5A6">Descrição</th>
                          <th width="16%" bgcolor="#95A5A6">Regencia</th>
                          <th width="4%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                      </tr>
                    </thead>
                     <tbody>
                    <%
                    cont =0
					sql = "SELECT Codigo, Cod_Empresa, Cod_Grupo, Cod_Curso, Periodo, Regencia, Descricao"
					sql = sql & " FROM SRH_REGENCIACOLABORADOR"
					sql = sql & " where Cod_grupo = " & intCodGrupo			
                    rs.open sql, cnn
                    if rs.eof = false then
                    
                    while not rs.eof
                        cont = cont + 1	
                    	%>
                        <tr>
                            <td><%=trim(rs("Codigo"))%></td>
                            <td><%=trim(rs("Descricao"))%></td>
                            <td><%=formatnumber(trim(rs("Regencia")),2)%></td>
                            <td align="center" >
                            <button class="btn-u btn-u-sea" onClick="resultadoConsulta(<%=trim(rs("Codigo"))%>)" type="button"><i class="fa fa-file-text-o"></i></button>                            </td> 
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
            
            if (frm.cmbCurso.value == "0") {
                alert("O Curso deve ser informado !");
                frm.cmbCurso.focus();
                return false;
            }
            
            if (frm.cmbPeriodo.value == "0") {
                alert("O Periodo deve ser informado !");
                frm.cmbPeriodo.focus();
                return false;
            }
            
            if (frm.txtRegencia.value == "") {
                alert("A Regencia deve ser informada !");
                frm.txtRegencia.focus();
                return false;
            }
            
            if (frm.txtDescricao.value == "") {
                alert("A Descrição deve ser informada !");
                frm.txtDescricao.focus();
                return false;
            }
            
            frm.action="Regencia_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
    </script>

    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 