<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
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
        strPaginaTitulo = "Rel_MapaVagas_rel.asp"
        strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
        if strAnoLetivo = "" then strAnoLetivo = session("strAnoLetivo")
        strCodGrupo 			= Session("CodGrupo")
        'controla os botões
        strDesabilitaIncluir = "disabled"
        strDesabilitaExcluir = "disabled"
        strDesabilitaAlterar = ""
        strDesabilitaLimpar = ""
    
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Mapa Geral de Vagas</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                    <div class="form-group">
                        <label class="form-label">Ano Letivo</label>
                         <input  name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" onblur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" style=" width:80pt"  >
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Tipo</label>
                        <select name="cmbTipoVaga" class="form-control" id="cmbTipoVaga"  style="width:190pt" >
                            <option value="C">Capacidade</option>
                            <option value="P">Vagas Preenchidas</option>
                            <option value="D">Vagas Existentes</option>
                            <option value="L">Vagas Liberadas</option>
                            <option value="E">Vagas Efetivadas</option>
                            <%if Session("UsuarioWeb") = "SERGIO" OR Session("UsuarioWeb") = "NIVALDO.SILVA" OR Session("UsuarioWeb") = "FERNANDO.DOMINGOS" OR Session("UsuarioWeb") = "CLEOVIS" OR Session("UsuarioWeb") = "DOMINGOS.SILVA" OR Session("UsuarioWeb") = "CECILIA.HONORIA" then%>
                            <option value="R">Vagas Reservadas</option>
                            <%end if%>
                        </select>
                    </div>
                   
                    <div class="form-group">
                        <label class="form-label">Curso</label>
                        <!--#include file="../includes/inc_cmbTipoCursoRel.asp"-->
                    </div>
                    <div class="form-group">
                        <label class="form-label">Ordem</label>
                        <select name="cmbOrdem" class="form-control" id="cmbOrdem"  style="width:190pt" >
                            <option value="E">Escola</option>
                            <option value="A">Ano Letivo</option>
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
		var caminho;
		
		if (frm.cmbTipoCurso.value == "0") {
			alert("O  Curso deve ser informado !");
			frm.cmbTipoCurso.focus();
			return false;
		}
	
		caminho = "Rel_MapaVagas_rel.asp"
		frm.action = caminho;
		frm.submit();
		return true;	
	}
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 