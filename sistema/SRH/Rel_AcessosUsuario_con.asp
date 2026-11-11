<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<!--#include file="../../js/Calendario/Calendario.asp"-->
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
        strPaginaTitulo 			= "Rel_acessosUsuario_con.asp"
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
        intCodEmpresaUsuario = Session("CodEmpresa")
        intCodGrupo = Session("CodGrupo")
    %>
    <!--=== Content Part ===-->
	<form method="post" id="frm" action="#">
    <div class="container content">		
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Mapa de Acessos - Sistema</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                    
                    <div class="form-group">
                        <label class="form-label">M&ecirc;s/Ano</label>
                        <!--#include file="../includes/inc_cmbMes.asp"--> / 
            			<input  name="txtAno" type="text" class="form-control" id="txtAno" onBlur="submit()"  value="<%=strAno%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Usu&aacute;rio</label>
                    	<!--#include file="../includes/inc_cmbUsuario.asp"-->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Relat&oacute;rio</label>
                    	<select name="cmbClassificacao" id="cmbClassificacao" onChange="submit()" class="form-control">
                          <option <%if strClassificacao = "SI" then%> selected <%end if%> value="SI">Sint&eacute;tico por Usuário </option>
                        </select>
                    </div>
                    
                    <% 	if strClassificacao = "AN" then %>
                    <div class="form-group">
                        <label class="form-label">Ordem</label>
                    	<select name="cmbOrdem" class="form-control" id="cmbOrdem"  style="width:100pt" >
                        <option value="1" >Registro</option>
                        <option value="3" >Data de Acesso</option>
                        <option value="4" >Login</option>
                        </select>
                        -
                        <select name="cmbSequencia" class="Combo" id="cmbSequencia"  style="width:100pt" >
                        <option value="asc" >Ascendente</option>
                        <option value="desc" >Descentente</option>
                        </select>
                    </div>
                    <%end if%>
                    
                    <div class="form-group">
                        <label class="form-label">&Uacute;ltimos Lan&ccedil;amentos</label>
                    	<input  name="txtTotalLancamentos" type="text" class="form-control" id="txtTotalLancamentos" onBlur="submit()"  value="<%=strTotalLancamentos%>" size="6" maxlength="6" onKeyPress="return formataCampo(this,2,10)">
                    </div>
                    
                    <div class="form-group">
                    	 <input type="checkbox" name="chkMesDia" id="strMesDia" value="S"> M&ecirc;s /Dia
                    </div>
     
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
    <!-- Fecha o Painel do Formulario -->        
    </div>
    </form>
    <!--/container-->		
	<script>
        function gerar(){
            
            var frm = document.getElementById("frm");
            frm.action = "Rel_acessosUsuario_rel.asp";
            frm.submit();
            return true;	
        }	
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 