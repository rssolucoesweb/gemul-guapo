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
        strEmpresaSecaoProduto_submit = "S"
        
        principal			= "principal.asp"
        intCodEmpresa		= session("CodEmpresa")	
        intCodigo 			= Trim(Request.Form("txtCodigo"))
        strTipoPessoa 		= Trim(Request.Form("cmbTipoPessoa"))
        strNumero	 		= Trim(Request.Form("txtNumero"))
        strRazaoSocialNome	= Trim(Request.Form("txtRazaoSocialNome"))
        strEndereco	 		= Trim(Request.Form("txtEndereco"))
        strTelefone	 		= Trim(Request.Form("txtTelefone"))
        strResponsavel	 	= Trim(Request.Form("txtResponsavel"))
        intSecaoProduto		= Trim(Request.Form("cmbSecaoProduto"))
		
       ' if intSecaoProduto = "" then intSecaoProduto = Session("CodSecao")
	    if intSecaoProduto = "" then intSecaoProduto = "0"
		
        if trim(intCodigo) <> "" then
        
            sql = "SELECT Codigo, CodEmpresa, TipoPessoa, Numero, RazaoSocialNome, Endereco, Telefone, Responsavel"
            sql = sql & " FROM EST_fornecedor"
            sql = sql & " Where Codigo = " & intCodigo
            sql = sql & " And CodEmpresa = " & intCodEmpresa
            sql = sql & " and cod_secao = " & intSecaoProduto
            rs.open sql, cnn
            
            if rs.eof = false then
                
                intCodigo	 		= rs("Codigo")
                strTipoPessoa		= rs("TipoPessoa")
                strNumero			= rs("Numero")
                strRazaoSocialNome	= rs("RazaoSocialNome")
                strEndereco	 		= rs("Endereco")
                strTelefone	 		= rs("Telefone")
                strResponsavel	 	= rs("Responsavel")
                            
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
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Fornecedor</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	
                  <input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
                    
                  <div class="form-group">
                    <label class="form-label">Se&ccedil;&atilde;o</label>
                    <!--#include file="../includes/inc_cmbSecaoProduto.asp" -->
                  </div>
                  
                   <div class="form-group">
                    <label class="form-label">Tipo Pessoa</label>
                    <select name="cmbTipoPessoa" class="form-control" id="cmbTipoPessoa">
                        <option value="0">Selecione...</option>
                        <option value="F" <%if strTipoPessoa = "F" then response.Write("selected") %>>F&iacute;sica</option>
                        <option value="J" <%if strTipoPessoa = "J" then response.Write("selected") %>>Jur&iacute;dica</option>
                    </select>
                  </div>
                  
                   <div class="form-group">
                    <label class="form-label">CPF/CNPJ</label>
                    <input name="txtNumero" type="text" class="form-control" id="txtNumero" size="30" maxlength="30" value="<%=strNumero%>">
                  </div>
                  
                   <div class="form-group">
                    <label class="form-label">Raz&atilde;o Social/ Nome</label>
                    <input name="txtRazaoSocialNome" type="text" class="form-control" id="txtRazaoSocialNome" size="40" maxlength="100" value="<%=strRazaoSocialNome%>">
                  </div>
                  
                  <div class="form-group">
                    <label class="form-label">Endere&ccedil;o</label>
                    <input name="txtEndereco" type="text" class="form-control" id="txtEndereco" size="40" maxlength="100" value="<%=strEndereco%>">
                  </div>
                  
                  <div class="form-group">
                    <label class="form-label">Telefone</label>
                    <input name="txtTelefone" type="text" class="form-control" id="txtTelefone" size="40" maxlength="40" value="<%=strTelefone%>">
                  </div>
                  
                   <div class="form-group">
                    <label class="form-label">Responsavel</label>
                    <input name="txtResponsavel" type="text" class="form-control" id="txtResponsavel" size="40" maxlength="40" value="<%=strResponsavel%>">
                  </div>


                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                </form>
       	  </div>
   	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
       <%if intSecaoProduto <> "0" then %>
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Fornecedor</h3>
          	</div>
            <div class="panel-body">
            	<div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="9%" bgcolor="#95A5A6">C&oacute;digo</th>
                          <th width="83%" bgcolor="#95A5A6">Razão Social / Nome</th>
                          <th width="8%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                      </tr>
                    </thead>
                  <%
                    cont =0
					
					sql = "SELECT Codigo, CodEmpresa, TipoPessoa, Numero, RazaoSocialNome"
					sql = sql & " FROM EST_fornecedor"
					sql = sql & " Where CodEmpresa	= " & session("codEmpresa")	
					sql = sql & " and COD_SECAO = "& intSecaoProduto	
					sql = sql & " Order by Codigo"
				    rs.open sql, cnn

                    if rs.eof = false then
                    
                    while not rs.eof
						cont = cont + 1	
						%>
						<tbody>
							<tr>
								<td><%=trim(rs("Codigo"))%></td>
								<td><%=trim(rs("RazaoSocialNome"))%></td>
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
         <%end if%>
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
		if (frm.cmbSecaoProduto.value == "0") {
			alert("Seção deve ser informada!");
			frm.cmbSecaoProduto.focus();
			return false;
		}
		
		
		if (frm.cmbTipoPessoa.value == "0") {
			alert("O Tipo Pessoa deve ser informado !");
			frm.cmbTipoPessoa.focus();
			return false;
		}
		
		
		if (frm.txtNumero.value == "") {
			alert("O Numero deve ser informado !");
			frm.txtNumero.focus();
			return false;
		}
		
		if (frm.txtRazaoSocialNome.value == "") {
			alert("A Razão Social Nome deve ser informada !");
			frm.txtRazaoSocialNome.focus();
			return false;
		}
		
		if (frm.txtEndereco.value == "") {
			alert("O Endereco deve ser informado !");
			frm.txtEndereco.focus();
			return false;
		}
		
		if (frm.txtTelefone.value == "") {
			alert("O Telefone deve ser informado !");
			frm.txtTelefone.focus();
			return false;
		}
		
		if (frm.txtResponsavel.value == "") {
			alert("O Responsavel deve ser informado !");
			frm.txtResponsavel.focus();
			return false;
		}
		
		frm.action="fornecedor_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 