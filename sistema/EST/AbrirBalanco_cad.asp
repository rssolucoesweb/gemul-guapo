<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">EST - Controle Almoxarifado</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%  
        principal			= "principal.asp"
        intCodEmpresa		= session("CodEmpresa")	
        intCodigo 			= Trim(Request.Form("txtCodigo"))
        strSituacao	 		= Trim(Request.Form("cmbSituacao"))
    
        if trim(intCodigo) <> "" then
        
            sql = "SELECT CODIGO, DATA, Situacao"
            sql = sql & " FROM EST_BALANCO"
            sql = sql & " Where Codigo = " & intCodigo
            sql = sql & " And Cod_Empresa = " & intCodEmpresa
            rs.open sql, cnn
            
            if rs.eof = false then
                
                intCodigo	 		= rs("Codigo")
                strData				= formataDataAP(rs("DATA"))
                strSituacao			= rs("Situacao")
                if strSituacao = "I" then
                    strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
                    strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
                    strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
                else
                    strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
                    strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
                    strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
                end if
                            
    
            end if 
            rs.close
        else
            strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
            strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
            strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
            BotaoPDF   				= "disabled"
        end if 
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Abrir Balanço</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	
                  <input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
                    
                  <div class="form-group">
                    <label class="form-label">Data</label>
                    <input name="txtData" id="txtData" type="text" class="form-control" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strData%>" size="15" maxlength="10">
                  </div>
                  
                  <div class="form-group">
                    <label class="form-label">Situa&ccedil;&atilde;o</label>
                    <select name="cmbSituacao" class="form-control" id="cmbSituacao">
                    <option value="0">Selecione...</option>
                    <option value="A" <%if strSituacao = "A" then response.Write("selected") %>>Aberto</option>
                    <option value="I" <%if strSituacao = "I" then response.Write("selected") %>>Fechado</option>
                    </select>
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
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Balanço</h3>
          </div>
            <div class="panel-body">
            	<div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="9%" bgcolor="#95A5A6">C&oacute;digo</th>
                          <th width="83%" bgcolor="#95A5A6">Data</th>
                          <th width="83%" bgcolor="#95A5A6">Situação</th>
                          <th width="8%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                      </tr>
                    </thead>
                  <%
                    cont =0
					sql = "SELECT Codigo, Cod_Empresa, Data, Situacao"
					sql = sql & " FROM EST_balanco"
					sql = sql & " Where Cod_Empresa	= " & session("codEmpresa")	
					sql = sql & " Order by data"
				    rs.open sql, cnn
                    if rs.eof = false then
                    
                    while not rs.eof
						cont = cont + 1	
						situacao = rs("situacao")
						if situacao="A" then 
							situacao = "Aberto"
						elseif situacao="I" then
							situacao = "Fechado"							
						end if
			        %>
                    <tbody>
                        <tr>
                            <td><%=trim(rs("Codigo"))%></td>
                            <td><%=trim(rs("Data"))%></td>
                            <td><%=trim(rs("Situacao"))%></td>
                          <td align="center" >
                            <button class="btn-u btn-u-sea" onClick="resultadoConsulta(<%=trim(rs("Codigo"))%>)" type="button"><i class="fa fa-file-text-o"></i></button> 
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
    <!--/container-->		
	<script>
        function resultadoConsulta(intCodigo){
                frm.txtCodigo.value=intCodigo
                frm.submit();
            }
    
        function salvar(acao){
            
            var frm = document.getElementById("frm");
            
            if (frm.txtData.value == "") {
                alert("A data deve ser informada !");
                frm.txtData.focus();
                return false;
            }
            
            if (frm.cmbSituacao.value == "0") {
                alert("A Situação deve ser informada !");
                frm.cmbSituacao.focus();
                return false;
            }
            
            frm.action="AbrirBalanco_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 