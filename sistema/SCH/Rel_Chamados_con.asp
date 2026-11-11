	<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
    <!--#include file="../../includes/inc_formataData.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Controle de Chamados</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
    <%
        strExecutarSubmitEmpresaChamado = "S" 
    
        strPaginaTitulo 				= "Rel_Chamados_con.asp"
        intCodEmpresa					= session("codEmpresa")
        strDataI						= formatadataAP(request.Form("txtDataI"))
        strDataF						= formatadataAP(request.Form("txtDataF"))
        intCodEmpresaChamado			= Trim(Request.Form("cmdEmpresaChamado"))
        strResponsavelAbertura			= Trim(session("UsuarioWeb"))
        intCodUsuarioChamado			= Trim(session("cmbUsuarioChamado"))
        srtSituacao						= Trim(session("cmbSituacao"))
        strPrioridade					= Trim(session("cmbPrioridade"))
    %>
     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Relatório de Chamados</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                    <div class="form-group">
                        <label class="form-label">Data de Abertura</label>
                         <input style="width:100pt" name="txtDataI" type="text" class="form-control" id="txtDataI" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataI%>"> a
						 <input style="width:100pt" name="txtDataF" type="text" class="form-control" id="txtDataF" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataF%>">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Unidade Escolar</label>
                         <!--#include file="../includes/inc_cmdEmpresaChamado.asp"-->
                    </div>
                   
                    <div class="form-group">
                        <label class="form-label">Encaminhamento Para</label>
                         <!--#include file="../includes/inc_cmbUsuariosChamadoRelatorio.asp" -->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Situa&ccedil;&atilde;o:</label>
                         <select name="cmbSituacao" class="form-control" id="cmbSituacao" style="width:150pt">
                          <option value="0">Selecione...</option>
                          <option value="A" <%if srtSituacao = "A" then response.Write("selected") %>>Ativo</option>
                          <option value="F" <%if srtSituacao = "F" then response.Write("selected") %>>Fechado</option>
                          <option value="P" <%if srtSituacao = "P" then response.Write("selected") %>>Pendente</option>
                          <option value="S" <%if srtSituacao = "S" then response.Write("selected") %>>Suspen&ccedil;o</option>
                          <option value="E" <%if srtSituacao = "E" then response.Write("selected") %>>Executada</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Prioridade</label>
                         <select name="cmbPrioridade" class="form-control" id="cmbPrioridade" style="width:150pt">
                          <option value="0">Selecione...</option>
                          <option value="A" <%if strPrioridade = "A" then response.Write("selected") %>>Alta</option>
                          <option value="B" <%if strPrioridade = "B" then response.Write("selected") %>>Baixa</option>
                          <option value="M" <%if strPrioridade = "M" then response.Write("selected") %>>Media</option>
                        </select>
                    </div>
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>

    <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
    <script>
	function gerar(){
		var frm = document.getElementById("frm");
		frm.action = "Rel_Chamados_rel.asp";
		frm.submit();
		return true;	
	}	
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 