<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Seguran&ccedil;a</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        strPaginaTitulo 			= "Rel_acessos_con.asp"
        intCodEmpresaUsuario	 	= request.Form("cmdEmpresaUsuario")
        intCodGrupo 				= request.Form("cmdGrupo")
        strMes		 		        = Trim(Request("cmbMes"))
        if Trim(Request("txtAno")) <> "" then
           strAno		 			    = Trim(Request("txtAno"))
        else
           strAno                       = year(date)
        end if   
        strClassificacao			= request.Form("cmbClassificacao")
        intCodUsuario               = request.Form("cmbUsuario")
        
        if strClassificacao = "AN" then   
           intCodOrdem 				= request.Form("cmbOrdem")
           intCodSequencia 			= request.Form("cmbSequencia")
        end if   
        strTotalLancamentos	    = Trim(Request("txtTotalLancamentos"))
       
        strExecutarSubmitGrupo				= "S"
        
        if trim(intCodEmpresaUsuario) = "" then intCodEmpresaUsuario = "0"
        if trim(intCodEmpresaUsuario) = "0" and trim(Session("CodEmpresa"))<>"" then intCodEmpresaUsuario = Session("CodEmpresa")
        if trim(intCodGrupo) = "0" and trim(Session("CodGrupo"))<>"" then intCodGrupo = Session("CodGrupo")
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Acessos de Usuários</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                    <label>Grupo</label>
                    <div class="form-group">
                      <!--#include file="../includes/inc_cmdGrupo.asp"-->
                    </div>
                    <label>Unidades</label>
                    <div class="form-group">
                      <!--#include file="../includes/inc_cmdEmpresaUsuario.asp"-->
                    </div>
                     <label>M&ecirc;s/Ano</label>
                    <div class="form-group">
                     <!--#include file="../includes/inc_cmbMes.asp"--> / <input  name="txtAno" type="text" class="form-control" id="txtAno" onBlur="submit()"  value="<%=strAno%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
                    </div>
                    <label>Usu&aacute;rio</label>
                    <div class="form-group">
                    <!--#include file="../includes/inc_cmbUsuario.asp"-->
                    </div>
                    <label>Relat&oacute;rio</label>
                    <div class="form-group">
                    <select name="cmbClassificacao" id="cmbClassificacao" onChange="submit()" class="form-control">
                      <option <%if strClassificacao = "AN" then%> selected <%end if%> value="AN">Anal&iacute;tico </option>
                      <option <%if strClassificacao = "SI" then%> selected <%end if%> value="SI">Sint&eacute;tico por Usuário </option>
                      <option <%if strClassificacao = "RE" then%> selected <%end if%> value="RE">Sint&eacute;tico por Empresa </option>
                    </select>
            
                    </div>
                    <label>Ordem</label>
                    <div class="form-group">
                    <select name="cmbOrdem" class="form-control" id="cmbOrdem"  style="width:100pt" >
                    <option value="1" >Registro</option>
                    <option value="2" >Alfabetica por instrução Sql</option>
                    <option value="3" >Data de Acesso</option>
                    <option value="4" >Login</option>
                    </select>
                    </div>
                    <label>Sequencia</label>
                    <div class="form-group">
                   	<select name="cmbSequencia" class="form-control" id="cmbSequencia"  style="width:100pt" >
                    <option value="asc" >Ascendente</option>
                    <option value="desc" >Descentente</option>
                    </select>
                    </div>
                    <label>&Uacute;ltimos Lan&ccedil;amentos</label>
                    <div class="form-group">
                    <input  name="txtTotalLancamentos" type="text" class="form-control" id="txtTotalLancamentos" onBlur="submit()"  value="<%=strTotalLancamentos%>" size="6" maxlength="6" onKeyPress="return formataCampo(this,2,10)">
                    </div>
                    <br>
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
		
		frm.action = "Rel_acessos_rel.asp";
		frm.submit();
		return true;	
	}	
</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 