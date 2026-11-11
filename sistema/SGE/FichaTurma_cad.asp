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
	strEmpresaGrupo_submit			 = "S"
	strExecutarSubmitCurso	         = "S"
	strExecutarSubmitPeriodo         = "S"
	strPaginaTitulo 				 = "FichaTurma_cad.asp"
					
	if Trim(Request.Form("cmbEmpresaGrupo")) <> "" then
	   intCodEmpresaGrupo  = trim(Request.Form("cmbEmpresaGrupo"))
	else
	   intCodEmpresaGrupo = session("codEmpresa")
	end if   
	 
	strAnoLetivo 				= session("strAnoLetivo")
	intSemestre 				= session("strSemestre")
	intCodCurso	 				= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 				= Trim(Request.Form("cmbPeriodo"))
	intCodFichaDescritiva		= Trim(Request.form("cmbFichaDescritiva"))
	
	if Trim(Request.Form("txtAnoLetivo")) <> "" then
	   strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	else
	   strAnoLetivo = session("strAnoLetivo")   
	end if   
	
	if intCodPeriodo = "" then intCodPeriodo = "0"
	
	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
%>

    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->       
      <form id="frm" class="margin-bottom-10" method="post">       
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>SCA - Vincula Ficha a Turma</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->   
         
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
               
                	<input name="txtCodigo" type="hidden" class="text" id="txtCodigo" value="<%=intCodigo%>" size="10">
                    <div class="form-group">
                        <label class="form-label">Unidade Escolar</label>
                         <!--#include file="../includes/inc_cmbEmpresaGrupoDiretrizes.asp"-->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Ano Letivo</label>
                         <input name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" style="width:50pt" value="<%=strAnoLetivo%>" size="80" maxlength="100">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Semestre Letivo</label>
                         <!--#include file="../includes/inc_cmdSemestreTodos.asp" -->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Curso</label>
                         <!--#include file="../includes/inc_cmdCurso.asp" -->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Per&iacute;odo</label>
                         <!--#include file="../includes/inc_cmdPeriodo.asp" -->
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Ficha Descritiva</label>
                         <!--#include file="../includes/inc_cmdFichaDescritiva.asp" -->
                    </div>
                    
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
               
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
                <div class="panel panel-grey margin-bottom-40">
                    <div class="panel-heading">
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Turmas</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="5%" bgcolor="#95A5A6"><input name="chkTodos" type="checkbox" <%=strAbilita%> value="" onClick="return marcaTodos()"></th>
                                    <th width="86%" bgcolor="#95A5A6">Nome da Turma</th>
                                    <th width="86%" bgcolor="#95A5A6">Sala</th>
                                    <th width="86%" bgcolor="#95A5A6">Ano Letivo</th>
                                    <th width="86%" bgcolor="#95A5A6">Per&iacute;odo</th>
                                    <th width="86%" bgcolor="#95A5A6">Semestre Letivo</th>
                                    <th width="86%" bgcolor="#95A5A6">Turno</th>
                                    <th width="86%" bgcolor="#95A5A6">Capacidade</th>
                                </tr>
                            </thead>
                            <%
							
							sql = "SELECT SCA_TURMA.Cod_Turma, SCA_TURMA.Cod_GradeCurricular, SCA_TURMA.Cod_Semestre, SCA_TURMA.Cod_Turno, SCA_TURNO.Desc_turno, SCA_TURMA.Capacidade,"
							sql = sql & "SCA_TURMA.nomeTurma, SCA_TURMA.Sala, SCA_TURMA.Ano, SCA_TURMA.AnoLetivo, SCA_TURMA.TurmaAluno,  "
							sql = sql & "SCA_PERIODO.Descricao, SCA_TURMA.Cod_FichaDescritiva "
							sql = sql & " FROM SCA_TURMA"
							sql = sql & " INNER JOIN SCA_TURNO ON sCA_TURNO.cod_turno = SCA_TURMA.cod_turno"
							sql = sql & " LEFT JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
							sql = sql & " LEFT JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
							sql = sql & " where 1 = 1 " 	
							sql = sql & " and 	AnoLetivo = " & strAnoLetivo
							sql = sql & " and 	SCA_TURMA.Cod_Semestre = " & intSemestre	
							
							if intCodEmpresaGrupo <> "0" then
							   sql = sql & " and SCA_TURMA.cod_empresa = " & intCodEmpresaGrupo
							end if

							if strSerie <> "" then  
							   sql = sql & " and SCA_PERIODO.Descricao = '" & strSerie & "'"
							end if
							
							sql = sql & " Order by SCA_TURMA.AnoLetivo, SCA_TURMA.nomeTurma"
							rs.open sql, cnn
							cont=0
							if rs.eof = false then
							
							while not rs.eof
							cont = cont + 1	
							
							strMarca = ""
							strAbilita = ""
							strCor = ""
							%>
                            <tbody>
                                <tr>
                                    <td><input name="chkCodTurma" type="checkbox" value="<%=rs("Cod_Turma")%>"<%=strMarca%>></td>
                                    <td><%=trim(rs("NomeTurma"))%></td>
                                    <td><%=trim(rs("Sala"))%></td>
                                    <td><%=trim(rs("AnoLetivo"))%></td>
                                    <td><%=trim(rs("Descricao"))%></td>
                                    <td><%=trim(rs("Cod_Semestre"))%></td>
                                    <td><%=trim(rs("Desc_turno"))%></td>
                                    <td><%=trim(rs("Capacidade"))%></td>
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
            </form>        
    </div>

    <!--/container-->		
<script>

	function marcaTodos(){
	
	   var frm = document.getElementById("frm");
	   
	  if(frm.chkTodos.checked == true){ 
	
		  if(!confirm("Deseja selecionar todos os registros?")){
				return false;    
		  }
		  for (var i = 0; i < frm.elements.length; i++) {
					//verifica todos os checkbox
					if (frm.elements[i].type == "checkbox"){				
						frm.elements[i].checked = true;				
					}
		  }
	  }else{
	  
		 if(!confirm("Deseja desmarcar todos os registros selecionados?")){
				return false;    
		  }
		  for (var i = 0; i < frm.elements.length; i++) {
					//verifica todos os checkbox
					if (frm.elements[i].type == "checkbox"){				
						frm.elements[i].checked = false;				
					}
		  }
	  }
	  
	  return true;
	
	}
	
	
	function salvar(acao){
	
		var frm = document.getElementById("frm");
		
		if (frm.cmbCurso.value == "0") {
			alert("O Curso deve ser informado!");
			frm.cmbCurso.focus();
			return false;
		}
		
		if (frm.cmbPeriodo.value == "0") {
			alert("O Periodo deve ser informado!");
			frm.cmbPeriodo.focus();
			return false;
		}
		
		if (frm.cmbFichaDescritiva.value == "0") {
			alert("A Ficha deve ser informada!");
			frm.cmbFichaDescritiva.focus();
			return false;
		}
		
		var intContMarcado=0;
			var intCodReserva="0";
			for (var i = 0; i < frm.elements.length; i++) 
			{
				//verifica todos os checkbox
				if (frm.elements[i].name.substring(0,19) == "chkCodTurma"){				
					if (frm.elements[i].checked) {
						intContMarcado = intContMarcado + 1;
						intCodReserva = intCodReserva + "," + frm.elements[i].value;
					}
				}
			}
		
			if (intContMarcado==0){
				alert("Pelo menos uma Turma deve ser selecionado!");
				return false;
			}

		frm.action="FichaTurma_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 