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
        strPaginaTitulo 	= "ColaboradorEventoDossie_cad.asp"
        intCodigo			= Trim(Request.Form("txtCodigo"))
        strDescricao 		= Trim(Request.Form("txtDescricao"))
            
        if trim(intCodigo) <> "" then
        
            sql = "SELECT Codigo, Cod_Empresa, Desc_EventoDossie"
            sql = sql & " FROM SRH_COLABORADOR_EVENTO_DOSSIE"
            sql = sql & " Where Codigo = " & intCodigo
            rs.open sql, cnn
            
            if rs.eof = false then
                
                intCodigo		= rs("Codigo")
                strDescricao	= rs("Desc_EventoDossie")
                
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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Eventos do Dossiê</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
              
                    <div class="form-group">
                        <label class="form-label">Descrição</label>
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
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Eventos do Dossiê</h3>
            </div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="5%" bgcolor="#95A5A6">Código</th>
                          <th width="55%" bgcolor="#95A5A6">Descrição</th>
                          <th width="5%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                      </tr>
                    </thead>
                     <tbody>
                    <%
                    cont =0
					sql = "SELECT Codigo, Cod_Empresa, Desc_EventoDossie"
					sql = sql & " FROM SRH_COLABORADOR_EVENTO_DOSSIE"
					if strCompartilharDados = "S" then
						sql = sql & " WHERE Cod_grupo = " & Session("CodGrupo")	
					else   
						sql = sql & " WHERE cod_empresa=" & Session("CodEmpresa")
					end if   
					sql = sql & " Order by Codigo"
                    rs.open sql, cnn
                    if rs.eof = false then
                    
                    while not rs.eof
                        cont = cont + 1	
                    	%>
                        <tr>
                            <td><%=trim(rs("Codigo"))%></td>
                            <td><%=trim(rs("Desc_EventoDossie"))%></td>
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
                alert("O Evento Dossie deve ser informada !");
                frm.txtDescricao.focus();
                return false;
            }
            
            frm.action="ColaboradorEventoDossie_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
    
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 