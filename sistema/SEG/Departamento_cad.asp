<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
    <!--#include file="../../includes/inc_formatadata.asp"-->
    <!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
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
	
	strExecutarSubmitEmpresa = "S"
	
	intCodEmpresa 		= Session("CodEmpresa")
	intCodDepto			= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strSigla			= Trim(Request.Form("txtSigla"))
	strSituacao			= Trim(Request.Form("cmbSituacao"))
		
	if trim(intCodDepto) <> "" then
	
		sql = "SELECT CODIGO, DESCRICAO, SIGLA, SITUACAO "
		sql = sql & " FROM SEG_DEPARTAMENTO"
		sql = sql & " WHERE CODIGO= " & intCodDepto
		rs.open sql, cnn
		
		if rs.eof = false then
			
			strDescricao		= rs("DESCRICAO")
			strSigla			= rs("SIGLA")
			strSituacao			= rs("SITUACAO")
			
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir

		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 
	%>
     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Departamento</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" method="post">
                	<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodDepto%>" maxlength="10" style="width:300pt">
                    <div class="form-group">
                        <label class="form-label">Descrição</label>
                         <input name="txtDescricao" type="text" class="form-control" id="txtDescricao" value="<%=strDescricao%>" size="80" maxlength="100" style="width:300pt">
                    </div>
                   
                    <div class="form-group">
                        <label class="form-label">Sigla</label>
                          <input name="txtSigla" type="text" class="form-control" id="txtSigla" size="15" maxlength="10" value="<%=strSigla%>" style="width:100pt">
                    </div>
                   
                    <div class="form-group">
                        <label class="form-label">Situa&ccedil;&atilde;o</label>
                           <!--#include file="../includes/inc_cmdSituacao.asp" -->
                    </div>
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
                <div class="panel panel-grey margin-bottom-40">
                    <div class="panel-heading">
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Departamentos</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="5%" bgcolor="#95A5A6">#</th>
                                    <th width="86%" bgcolor="#95A5A6">Descrição</th>
                                    <th width="86%" bgcolor="#95A5A6">Situação</th>
                                    <th width="9%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                                </tr>
                            </thead>
                            <%
							
							sql = "SELECT CODIGO, DESCRICAO, SIGLA, SITUACAO "
							sql = sql & " FROM SEG_DEPARTAMENTO"

							if strCompartilharDados = "S" then
								sql = sql & " WHERE Cod_grupo = " & Session("CodGrupo")	
							else   
								sql = sql & " WHERE cod_empresa=" & Session("CodEmpresa")
							end if   

							sql = sql & " Order by DESCRICAO"
							rs.open sql, cnn
					
							cont=0
							if rs.eof = false then
							
							while not rs.eof
							cont = cont + 1	
							
							if trim(rs("Situacao")) = "A" then
								strSituacao = "Ativo"
							else
								strSituacao = "Inativo"
							end if	
							%>
                            <tbody>
                                <tr>
                                    <td><%=trim(rs("CODIGO"))%></td>
                                    <td><%=trim(rs("DESCRICAO"))%></td>
                                    <td align="center"><%=trim(strSituacao)%></td>
                                    <td align="center" >
                                    <button class="btn-u btn-u-sea" onClick="resultadoConsulta(<%=trim(rs("CODIGO"))%>)" type="button"><i class="fa fa-file-text-o"></i></button>  
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
                <!--End Table Bordered-->	
       <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
    <script>
	
		function resultadoConsulta(intCodigo){
	
		var frm = document.getElementById("frm");
		
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtDescricao.value == "") {
			alert("O Departamento deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		
		if (frm.txtSigla.value == "") {
			alert("A Sigla deve ser informada !");
			frm.txtSigla.focus();
			return false;
		}
		
		if (frm.cmbSituacao.value == "0") {
			alert("A Situação deve ser informada !");
			frm.cmbSituacao.focus();
			return false;
		}
		
		frm.action="Departamento_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 