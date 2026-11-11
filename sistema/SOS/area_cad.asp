<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    
    <div class="breadcrumbs">
        <div class="container">
         <%if Session("mobile")<>"S" then%>
            <h1 class="pull-left">OS - Ordem de Serviço</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
          <%end if%>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        strPaginaTitulo = "area_cad.asp"
    
        intCodigo	 			= Trim(Request.Form("txtCodigo"))
        strDescricao 			= Trim(Request.Form("txtDescricao"))
            
        if trim(intCodigo) <> "" then
        
            sql = "SELECT Codigo, Descricao, usua_codg "
            sql = sql & " FROM SOS_AREA"
            sql = sql & " where Codigo = " & intCodigo
            rs.open sql, cnn
            
            if rs.eof = false then
                
                intCodCargo	 			= rs("Codigo")
                strDescricao			= rs("Descricao")
                strUsuarioPortal		= rs("usua_codg")
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
        
        <div class="row">
            <!-- Begin Content -->
            <div class="col-md-12" >     
        
            <!-- Inicia o Painel do Formulario -->     
        
            <form id="frm" class="sky-form  panel-body0" method="post">
                
                <input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
                
                <div style="background:#95a5a6;height:40px;padding-top: 8px;" class="panel-title">&nbsp;&nbsp;<font color="#FFFFFF"><i class="fa fa-tasks"></i>&nbsp;Cadastro de Departamento</font></div>
    
                <fieldset>
                    <div class="row">
                         <section class="col col-12">
                            <label class="form-label">Nome do Departamento</label>
                          
                            <label class="input">
                                <input name="txtDescricao" type="text" class="form-control" id="txtDescricao" size="70" maxlength="70" value="<%=strDescricao%>">
                            </label>
                         </section>
                    </div>    
		    <div class="row">
                         <section class="col col-6">
                            <label class="form-label">Gestor/Responsável</label>
                          
                            <label class="input">
                                <input readonly name="txtUsuarioPortal" type="text" class="form-control" id="txtUsuarioPortal" value="<%=strUsuarioPortal%>" size="70" maxlength="30" onBlur="submit()">
                            </label>
                         </section>

			<section class="col col-6">
                            <label class="form-label">Consultar Gestor</label>
                            <label class="input">
                                 <%if Session("mobile")<>"S" then%>
                    			<button class="btn-u btn-u-sea" onclick="return abreConsulta('Usuario_con.asp')" type="button"><i class="fa fa-search"></i></button> 
                                 <%end if%>
                            </label>
                         </section>                    </div>    

     			</fieldset>
    				
                    <div class="margin-left-40">
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
					</DIV>
                          
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Departamento</h3>
            </div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="5%" bgcolor="#95A5A6">Código</th>
                          <th width="35%" bgcolor="#95A5A6">Departamento/Gestor</th>
                          <th width="6%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                      </tr>
                    </thead>
                     <tbody>
                    <%
                    cont =0
					sql = "SELECT Codigo, Descricao, usua_codg "
					sql = sql & " FROM Sos_area"
					sql = sql & " WHERE Cod_grupo = " & Session("CodGrupo")	
					sql = sql & " Order by codigo"
			        rs.open sql, cnn
                    if rs.eof = false then
                    
                    while not rs.eof
                        cont = cont + 1	
                    	%>
                        <tr>
                            <td><%=trim(rs("Codigo"))%></td>
                            <td><%=trim(rs("Descricao"))%><br>
                            <font color="#0000FF"><%=trim(rs("usua_codg"))%></font></td>
                            <td align="center" >
                            <button class="btn-u btn-u-sea" onclick="resultadoConsulta(<%=trim(rs("Codigo"))%>)" type="button"><i class="fa fa-file-text-o"></i></button>                            </td> 
                        </tr>
                    	<%				
                        rs.movenext
                        wend
                    end if
                    rs.close
                	%>
                    	<tr>
                    		<td colspan="4">Total Registros : <%=cont%></td>
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
            
            if (frm.txtDescricao.value == "") {
                alert("Departamento deve ser informado!");
                frm.txtDescricao.focus();
                return false;
            }
            
            frm.action="area_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
    
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 