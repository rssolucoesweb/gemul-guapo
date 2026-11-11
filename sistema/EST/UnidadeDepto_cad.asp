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
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strSituacao	 		= Trim(Request.Form("cmbSituacao"))

	if trim(intCodigo) <> "" then
	
		sql = "SELECT CODIGO, DESCRICAO,tipo"
		sql = sql & " FROM EST_departamento"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And Cod_Empresa = " & intCodEmpresa
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 		= rs("Codigo")
			strDescricao		= rs("Descricao")
			strSituacao			= rs("tipo")
						
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir

		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		BotaoPDF   				= "disabled"
	end if 
	strLiberaAlteracao		= "S"
%>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Escola/Departamento</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	
                  <input  name="txtCodigo" type="hidden" class="text" id="txtCodigo"  value="<%=intCodigo%>" size="10" maxlength="10" onKeyPress="return formataCampo(this,2,10)">
                    
                  <div class="form-group">
                    <label class="form-label">Descri&ccedil;&atilde;o</label>
                    <input name="txtDescricao" type="text" class="form-control" id="txtDescricao" size="40" maxlength="40" value="<%=strDescricao%>">
                  </div>
                  
                  <div class="form-group">
                    <label class="form-label">Tipo</label>
                    <select name="cmbSituacao" class="form-control" id="cmbSituacao">
                        <option value="ADMINISTRACAO" 	<%if strSituacao = "ADMINISTRACAO" 	then response.Write("selected") %>>ADMINISTRAÇÃO</option>
                        <option value="SECRETARIA" 		<%if strSituacao = "SECRETARIA" 	then response.Write("selected") %>>SECRETARIA</option>
                        <option value="UNIDADE_ESCOLA"  <%if strSituacao = "UNIDADE_ESCOLA" then response.Write("selected") %>>UNIDADE ESCOLAR</option>
                        <option value="CMEIS" 			<%if strSituacao = "CMEIS" 			then response.Write("selected") %>>CMEIS</option>
                        <option value="EMEI" 			<%if strSituacao = "EMEI" 			then response.Write("selected") %>>EMEI</option>
                        <option value="CONVENIADA" 		<%if strSituacao = "CONVENIADA" 	then response.Write("selected") %>>CONVENIADA</option>
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
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Escola/Departamento</h3>
          </div>
            <div class="panel-body">
            	<div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="5%" bgcolor="#95A5A6">C&oacute;digo</th>
                          <th width="37%" bgcolor="#95A5A6">Descrição</th>
                          <th width="48%" bgcolor="#95A5A6">Tipo</th>
                          <th width="10%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                      </tr>
                    </thead>
                  <%
                    cont =0
					
					sql = "SELECT Codigo, Cod_Empresa, Descricao, TIPO"
					sql = sql & " FROM EST_departamento"
					sql = sql & " Where Cod_Empresa	= " & session("codEmpresa")	
					sql = sql & " Order by tipo, Descricao"
				    rs.open sql, cnn
                    if rs.eof = false then
                    
                    while not rs.eof
						cont = cont + 1	
						tipo = ""
						if rs("tipo") = "UNIDADE_ESCOLA" then tipo = "UNIDADE ESCOLAR"
						if rs("tipo") = "ADMINISTRACAO" then tipo = "ADMINISTRAÇÃO"
						if rs("tipo") = "SECRETARIA" then tipo = "SECRETARIA MUNICIPAL"
						if rs("tipo") = "CMEIS" then tipo = "CMEIS"
						if rs("tipo") = "EMEI" then tipo = "EMEI"
						if rs("tipo") = "CONVENIADA" then tipo = "CONVENIADA"
			        %>
                    <tbody>
                        <tr>
                            <td><%=trim(rs("Cod_curso"))%></td>
                            <td><%=trim(rs("Descricao"))%></td>
                            <td><%=trim(tipo)%></td>
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
            
            if (frm.txtDescricao.value == "") {
                alert("A Descrição deve ser informada !");
                frm.txtDescricao.focus();
                return false;
            }
            
            if (frm.cmbSituacao.value == "0") {
                alert("A Situação deve ser informada !");
                frm.cmbSituacao.focus();
                return false;
            }
            
            frm.action="UnidadeDepto_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 