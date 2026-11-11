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

    <!--=== Content Part ===-->
    <form method="post" id="frm" action="rel_apontamento_con.asp">
    <div class="container content">		
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Relatório de Apontamento</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                                        
                    <div class="form-group">
                        <label class="form-label">Per&iacute;odo</label>
                    	<input name="txtData" type="text" class="form-control" id="txtData" onblur="return validaData(this);" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=formatadataap(date)%>" title="Click aqui para visualizar o calend&aacute;rio">
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Unidade 
                        </label>
                        Sem batida&nbsp;<input checked type="radio" name="marcou" id="marcou" value="N">&nbsp;&nbsp;&nbsp;
                        Com batida&nbsp;<input type="radio" name="marcou" id="marcou" value="S">
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
            var form = window.document.forms[0];
            var intContMarcado=0;

            if (frm.txtData.value==""){
				alert("Data deve ser informada!")	;
				frm.txtData.focus();
				return false
			}
			if (frm.marcou[1].checked==true) {
				frm.action = "Rel_ResumoBatida_rel.asp";
				frm.submit();
				return true;	
			}
			else 
			{
				frm.action = "Rel_SemApontamento_rel.asp";
				frm.submit();
				return true;	
			}
        }
		
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 