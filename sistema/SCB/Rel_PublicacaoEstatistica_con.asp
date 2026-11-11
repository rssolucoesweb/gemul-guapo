	<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Biblioteca</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	 <%
        strPaginaTitulo 	= "Rel_DemonstrativoSintetico_Devolucao_con.asp"
        strTipoUsuario		= Trim(Request("cmbTipoUsuario"))
        
        ' Aluno
        strAnoLetivo		= session("strAnoLetivo")
        intSemestre			= session("strSemestre")
        intCodCurso			= Trim(Request.Form("cmbCurso"))
        intCodTurma			= Trim(Request.Form("cmbTurma"))
        
        ' Colaborador , Aluno e Comunidade
        intCodAutoria		= Trim(Request.Form("cmbAutoria"))
        strAutor			= Trim(Request.Form("txtAutor"))
        strPalavraChave		= Trim(Request.Form("txtPalavraChave"))
        strTitulo			= Trim(Request.Form("txtTitulo"))
        strCdu				= Trim(Request.Form("txtCdu"))
        strDataInicial		= Trim(Request.Form("txtDataInicial"))
        strDataFinal		= Trim(Request.Form("txtDataFinal"))
    
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Relatório Empréstimos por Publicação</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                
                 <div class="form-group">
                	<label class="form-label">Tipo de Usuário:</label>
                    <select name="cmbTipoUsuario" id="cmbTipoUsuario" class="form-control" style="width:250pt">
                    <option value="TOD">Todos</option>
                    <option value="ALU">Alunos</option>
                    <option value="COL">Colaboradores</option>
                    <option value="COM">Comunidade</option>
                  </select>
                 </div>
                
                 <div class="form-group">
                 <label class="form-label">Per&iacute;odo de Empr&eacute;stimo:</label>
                	<input name="txtDataI" type="text" class="form-control" id="txtDataI" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataI%>"> a
                    <input name="txtDataF" type="text" class="form-control" id="txtDataF" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataF%>">
                    - ( Caso n&atilde;o seja informado uma das datas, ser&aacute; realizada uma classifica&ccedil;&atilde;o total )
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
            frm.action = "Rel_PublicacaoEstatistica_rel.asp";
            frm.submit();
            return true;	
        }
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 