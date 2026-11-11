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
            <h1 class="pull-left">APO - Apontamento</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%	intCodColaboradorProfessor=0
		intCodEmpresaUsuario       	= Trim(Request("cmdEmpresaUsuario"))
		if intCodEmpresaUsuario="" then intCodEmpresaUsuario ="0"
        strPaginaTitulo 			= "Rel_RegistroPonto_con.asp"
        strDataInicial         		= Trim(Request("txtDataInicial"))
        strDataFinal            	= Trim(Request("txtDataFinal"))
    %>
    <!--=== Content Part ===-->
    <form method="post" id="frm" action="Rel_RegistroPonto_con.asp">
    <div class="container content">		
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Relatório de Batidas</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                    <div class="form-group">
                        <label class="form-label">Unidade</label>
                    	<!--#include file="../includes/inc_cmdEmpresaUsuario.asp"-->
                    </div>
                                        
                    <div class="form-group">
                        <label class="form-label">Per&iacute;odo</label>
                    	<input name="txtDataInicial" type="text" class="form-control" id="txtDataInicial" onblur="return validaData(this); submit();" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataInicial%>" title="Click aqui para visualizar o calend&aacute;rio">
                        &aacute;
                        <input name="txtDataFinal" type="text" class="form-control" id="txtDataFinal" onblur="return validaData(this);" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataFinal%>" title="Click aqui para visualizar o calend&aacute;rio">
                    </div>

                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->
                
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
     
    </div>
    </form>
    <!--/container-->		
    <script>
        function gerar(){
            
            var frm = document.getElementById("frm");
            var form = window.document.forms[0];
            var intContMarcado=0;

            if (frm.cmdEmpresaUsuario.value=="0"){
				alert("Unidade deve ser informada!")	;
				frm.cmdEmpresaUsuario.focus();
				return false
			}

            frm.action = "Rel_RegistroPonto_rel.asp";
            frm.submit();
            return true;	
        }
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 