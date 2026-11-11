<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Gerencial</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
	strPaginaTitulo 		= "Periodo_cad.asp"
	strExecutarSubmitCurso 	= "S"

	intCodPeriodo			= Trim(Request.Form("txtCodigo"))
	intCodCurso				= Trim(Request("cmbCurso"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	strDescricaoAntiga		= Trim(Request.Form("txtDescricaoAntiga"))
	strSequencia 			= Trim(Request.Form("txtSequencia"))
		
	if trim(intCodPeriodo) <> "" then
	
		sql = "SELECT Cod_Periodo, Cod_Curso, Descricao, Sequencia"
		sql = sql & " FROM SCA_PERIODO"
		sql = sql & " where Cod_Empresa = " & Session("CodEmpresa")			
		sql = sql & " and 	Cod_Periodo = " & intCodPeriodo
		rs.open sql, cnn
		if rs.eof = false then
			
			intCodPeriodo	 	= rs("Cod_Periodo")
			intCodCurso			= rs("Cod_Curso")
			strDescricao		= rs("Descricao")
			strDescricaoAntiga	= rs("Descricao")
			strSequencia		= rs("Sequencia")
			
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir

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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Período</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="txtCodigo" type="hidden" class="text" id="txtCodigo" value="<%=intCodigo%>" size="10">
                    
                    <div class="form-group">
                        <label class="form-label">Curso</label>
                         <!--#include file="../includes/inc_cmdCurso.asp" -->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Sequencia</label>
                         <input name="txtSequencia" type="text" class="form-control" id="txtSequencia" style="width:50pt" value="<%=strSequencia%>" size="80" maxlength="100">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Descrição</label>
                         <input name="txtDescricao" type="text" class="form-control" id="txtDescricao" style="width:350pt" value="<%=strDescricao%>" size="80" maxlength="100">
                         <input name="txtDescricaoAntiga" type="hidden" class="text" id="txtDescricaoAntiga" size="40" maxlength="40" value="<%=strDescricaoAntiga%>">
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
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Período</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="5%" bgcolor="#95A5A6">Código</th>
                                    <th width="34%" bgcolor="#95A5A6">Curso</th>
                                    <th width="20%" bgcolor="#95A5A6">Sequencia</th>
                                    <th width="36%" bgcolor="#95A5A6">Descrição</th>
                                    <th width="5%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                                </tr>
                            </thead>
                            <%
							cont =0
							if intCodCurso = "" then intCodCurso = 0
							if intCodCurso <> "0" then
								
								sql = " SELECT SCA_CURSO.Descricao as descCurso, SCA_PERIODO.Descricao, SCA_PERIODO.Cod_Periodo, SCA_PERIODO.Sequencia "
								sql = sql & " FROM SCA_CURSO INNER JOIN SCA_PERIODO ON SCA_CURSO.Cod_curso = SCA_PERIODO.Cod_Curso "
								sql = sql & " AND SCA_CURSO.Cod_Empresa = SCA_PERIODO.Cod_Empresa "
								sql = sql & " where SCA_CURSO.cod_empresa = " & Session("CodEmpresa")	
								if intCodCurso <> "0" then
									sql = sql & " and SCA_PERIODO.Cod_Curso = " & intCodCurso
								end if
								sql = sql & " ORDER BY 	SCA_CURSO.Descricao, SCA_PERIODO.Sequencia, SCA_PERIODO.Descricao"
								
								rs.open sql, cnn
												
								if rs.eof = false then
							while not rs.eof
							cont = cont + 1	
							%>
                            <tbody>
                                <tr>
                                    <td><%=trim(rs("Cod_Periodo"))%></td>
                                    <td><%=trim(rs("descCurso"))%></td>
                                    <td><%=trim(rs("sequencia"))%></td>
                                    <td><%=trim(rs("Descricao"))%></td>
                                    <td align="center" >
                                    <button class="btn-u btn-u-sea" onClick="resultadoConsulta(<%=trim(rs("Cod_Periodo"))%>)" type="button"><i class="fa fa-file-text-o"></i></button> 
                                    </td> 
                                </tr>
                            </tbody>
                            <%				
								rs.movenext
								wend
							end if
							rs.close
							
						end if
						%>
                        </table>
                    </div>                      
                </div>
                <!--End Table Bordered-->	
       <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
    <script>
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmbCurso.value == "0") {
			alert("O Curso deve ser informado !");
			frm.cmbCurso.focus();
			return false;
		}
		
		if (frm.txtSequencia.value == "") {
			alert("A Sequencia deve ser informada !");
			frm.txtSequencia.focus();
			return false;
		}
		if (frm.txtDescricao.value == "") {
			alert("A Descrição deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		
		frm.action="Periodo_cod.asp?acao=" + acao;
		frm.submit();
		return true;
		
	}

	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 