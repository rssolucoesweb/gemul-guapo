	<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--#include file="../../includes/inc_formataData.asp"-->
    <!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Matrícula</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        strAlunoEncontrado					= ""
        strPagina							= "EfetivacaoAluno_con.asp"
        Session("MatriculaInformatizada") 	= "SIM"
		
        strCod_empresa 		= Session("CodEmpresa")
        intCodAluno			= Trim(Request("txtCodAluno"))
        
		IF intCodAluno = "" THEN intCodAluno = "0"
			sql = "SELECT nomeAluno, dataNascimento, Mae "
			sql = sql & " FROM SCA_ALUNO A"
			sql = sql & " Where COD_EMPRESA = " & strCod_empresa
			sql = sql & " And 	CODIGO = " & intCodAluno
			rs.open sql, cnn
			if rs.eof = false then
				strAlunoEncontrado				= "S"
				strNomealuno 					= TRIM(rs("Nomealuno"))
				strDatanascimento 				= formataDataAP(TRIM(rs("Datanascimento")))
				strMae 							= TRIM(rs("Mae"))
			end if
        rs.close
        
        if strAlunoEncontrado = "" then
            %>
   			 <script>
                alert("Aluno não foi encontrado.");
                window.history.back();
            </script>
            <%
            response.End()
        end if
    %>
     <!--=== Content Part ===-->
    <div class="container content">		
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Matr&iacute;cula <%=year(date)%> - CONFIRMA&Ccedil;&Atilde;O DE DADOS</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                <input name="txtCodAluno" type="hidden" id="txtCodAluno" value="<%=intCodAluno%>" >
                    <div class="form-group">
                        <label for="exampleInputEmail1">NOME COMPLETO DO ALUNO</label>
                          <input name="txtNomealuno" type="text" class="form-control" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>"  onKeyPress="return formataCampo(this, 1, 50)">
                    </div>
                    
                    <div class="form-group">
                        <label for="exampleInputEmail1">DATA DE NASCIMENTO DO ALUNO</label>
                           <input name="txtDatanascimento" type="text" class="form-control" id="txtDatanascimento" onblur="return validaData(this)" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDatanascimento%>">
                    </div>
                    
                    <div class="form-group">
                        <label for="exampleInputEmail1">NOME COMPLETO DA M&Atilde;E:</label>
                        <input name="txtMae" type="text" class="form-control" id="txtMae" size="50" maxlength="50" value="<%=strMae%>" onkeypress="return formataCampo(this, 1, 50)">
                    </div>
                    <legend></legend>
                    <input class="btn-u float-shadow" type="button" value="Confirmar Dados para Efetiva&ccedil;&atilde;o" <%=strDesabilitaConsultar%>  name="cmdConfirmar" onclick="return DadosDoAluno('<%=intCodAluno%>')">
                    <input type="button" name="cmdLimpar"  style="cursor:hand"  value="Voltar"   class="btn-u btn-u-orange float-shadow" <%=strDesabilitaLimpar%> onclick="window.location='<%=strPagina%>'">
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
    </div>
    <!--/container-->		
    <script>
	function DadosDoAluno(){
	
		var frm = document.getElementById("frm");
		
		if (frm.txtNomealuno.value==""){
			alert("O Nome do Aluno deve ser informado.")
			frm.txtNomealuno.focus()
			return false;
		}
		
		if (frm.txtDatanascimento.value==""){
			alert("A Data de Nascimento deve ser informada.")
			frm.txtDatanascimento.focus()
			return false;
		}
		
		if (frm.txtMae.value==""){
			alert("Nome da Mãe deve ser informada.")
			frm.txtMae.focus()
			return false;
		}
		frm.action = "ConfirmacaoAluno_cod.asp";
		frm.submit();
		return true;	
	}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 