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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Relatório Demonstrativo Sintetico - Devolução</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                
                <div class="form-group">
                	<label class="form-label">Tipo Usu&aacute;rio:</label>
                    <!--#include file="../includes/inc_cmbTipoUsuario.asp"-->
                 </div>
                 
                 <%if strTipoUsuario = "1" then%>
                    <div class="form-group">
                    <label class="form-label">Ano Letivo</label>
                       <input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
                     </div>
                    <div class="form-group">
                     <label class="form-label">Semestre</label>
                       <!--#include file="../includes/inc_cmdSemestre.asp" -->
                    </div>
                     
                     <div class="form-group">
                     <label class="form-label">Curso</label>
                       <!--#include file="../includes/inc_cmdCurso.asp"-->
                     </div>
                     
                     <div class="form-group">
                     <label class="form-label">Turma</label>
                        <!--#include file="../includes/inc_cmdTurma.asp"-->
                     </div>
              	 <%end if%>
                 
                 <div class="form-group">
                 <label class="form-label">Autoria</label>
                	<!--#include file="../includes/inc_cmdAutoria.asp" -->
                 </div>
                 
                 <div class="form-group">
                 <label class="form-label">Autor</label>
                	<input name="txtAutor" type="text" class="form-control" id="txtAutor" size="50" maxlength="50"  value="<%=strAutor%>" />
                 </div>
                 
                 <div class="form-group">
                 <label class="form-label">Palavra Chave</label>
                	<input name="txtPalavraChave" type="text" class="form-control" id="txtPalavraChave" size="50"  maxlength="50" value="<%=strPalavraChave%>" />
                 </div>
                 
                 <div class="form-group">
                 <label class="form-label">T&iacute;tulo:</label>
                	 <input name="txtTitulo" type="text" class="form-control" id="txtTitulo" size="50" maxlength="50"  value="<%=strTitulo%>" />
                 </div>
                 
                 <div class="form-group">
                 <label class="form-label"> Cdu</label>
                    <input name="txtCodCDU" type="text" id="txtCodCDU" class="form-control" size="10" maxlength="20" >
                  </div>
                  
                   <div class="form-group">
                 <label class="form-label"> Per&iacute;odo:</label>
                   <input name="txtDataInicial" type="text" class="form-control" id="txtDataInicial" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" value="<%=strDataInicial%>"> 		a
					<input name="txtDataFinal" type="text" class="form-control" id="txtDataFinal" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" value="<%=strDataFinal%>">
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
		
		if (frm.cmbTipoUsuario.value == "0") {
			alert("O Tipo Usuário deve ser informado !");
			frm.cmbTipoUsuario.focus();
			return false;
		}
	
		frm.action = "Rel_DemonstrativoSintetico_Devolucao_rel.asp";
		frm.submit();
		return true;	

	}
</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 