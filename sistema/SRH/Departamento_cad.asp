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
        strExecutarSubmitEmpresa = "S"
        intCodEmpresa 		= Session("CodEmpresa")
        intCodDepto			= Trim(Request.Form("txtCodigo"))
        strDescricao 		= Trim(Request.Form("txtDescDepto"))
        strSigla			= Trim(Request.Form("txtSigla"))
        strSituacao			= Trim(Request.Form("cmbSituacao"))
            
        if trim(intCodDepto) <> "" then
        
            sql = "SELECT CODIGO, DESCRICAO, SIGLA, SITUACAO "
            sql = sql & " FROM SEG_DEPARTAMENTO"
            sql = sql & " WHERE CODIGO= " & intCodDepto
            rs.open sql, cnn
            
            if rs.eof = false then
                
                strDescricao		= rs("DESCRICAO")
                strSigla			= rs("SIGLA")
                strSituacao			= rs("SITUACAO")
                
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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Departamento</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                
                	<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodDepto%>" maxlength="10">
                    
                    <div class="form-group">
                        <label class="form-label">Descri&ccedil;&atilde;o</label>
                        <input name="txtDescDepto" type="text" class="form-control" id="txtDescDepto" size="70" maxlength="70" value="<%=strDescricao%>">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Sigla</label>
                    	<input name="txtSigla" type="text" class="form-control" id="txtSigla" size="15" maxlength="10" value="<%=strSigla%>">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Situa&ccedil;&atilde;o</label>
                         <!--#include file="../includes/inc_cmdSituacao.asp" -->
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
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Departamento</h3>
            </div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="5%" bgcolor="#95A5A6">C&oacute;digo</th>
                          <th width="59%" bgcolor="#95A5A6">Descrição</th>
                          <th width="19%" bgcolor="#95A5A6">Sigla</th>
                          <th width="11%" bgcolor="#95A5A6">Situação</th>
                          <th width="6%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                      </tr>
                    </thead>
                     <tbody>
                    <%
                    cont =0
					sql = "SELECT CODIGO, DESCRICAO, SIGLA, SITUACAO "
					sql = sql & " FROM SEG_DEPARTAMENTO"
					if strCompartilharDados = "S" then
						sql = sql & " WHERE Cod_grupo = " & Session("CodGrupo")	
					else   
						sql = sql & " WHERE cod_empresa=" & Session("CodEmpresa")
					end if   
					sql = sql & " Order by DESCRICAO"
                    rs.open sql, cnn
                    if rs.eof = false then
                    
                    while not rs.eof
                        cont = cont + 1	
                    	%>
                        <tr>
                            <td><%=trim(rs("CODIGO"))%></td>
                            <td><%=trim(rs("DESCRICAO"))%></td>
                            <td><%=trim(rs("SIGLA"))%></td>
                            <td><%=trim(rs("SITUACAO"))%></td>
                            <td align="center" >
                            <button class="btn-u btn-u-sea" onClick="resultadoConsulta(<%=trim(rs("CODIGO"))%>)" type="button"><i class="fa fa-file-text-o"></i></button>                            </td> 
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
            frm.txtCodigo.value=intCodigo;
            frm.submit();
        }
    
        function salvar(acao){
            
            if (frm.txtDescDepto.value == "") {
                alert("O Departamento deve ser informada !");
                frm.txtDescDepto.focus();
                return false;
            }
            
            if (frm.txtSigla.value == "") {
                alert("A Sigla deve ser informada !");
                frm.txtSigla.focus();
                return false;
            }
            
            frm.action="Departamento_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
    
    </script>

    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 