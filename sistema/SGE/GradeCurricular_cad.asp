<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"--> 
    <!--#include file="../includes/inc_buscaGrupoDeEmpresas.asp"--> 
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
	strPaginaTitulo = "GradeCurricular_cad.asp"
	strExecutarSubmitCurso		                 = "S"

	intCodEmp = Session("CodEmpresa")

	strPagina = "GradeCurricular_cad.asp"
	
	
	if trim(request.querystring("nCodigo")) <> "" then
		intCodigo 		= trim(request.querystring("nCodigo"))
	else
		intCodigo	 	= Trim(Request.Form("txtCodigo"))
	end if
	
	intCodCurso			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo		= Trim(Request.Form("cmbPeriodo"))
	intSemestre 		= Trim(Request.Form("cmbSemestre"))
	strSituacao			= Trim(Request.Form("cmbSituacao"))
	intAno				= Trim(Request.Form("txtAno"))
	intCodDisciplina	= Trim(Request("txtCodDisciplina"))
	intCodAgrupamento   = Trim(Request("txtCodAgrupamento"))

	
	'intCodGradeEquivalente 		= Trim(Request.Form("cmbGradeEquivalente"))
				
	if trim(intCodigo) <> "" then
	
		sql = "SELECT     	SCA_GRADECURRICULAR.Cod_GradeCurricular, "
		sql = sql & " 		SCA_PERIODO.Cod_Curso, "
		sql = sql & " 		SCA_GRADECURRICULAR.AnoReferencia, "
		sql = sql & "       SCA_GRADECURRICULAR.SemestreReferencia, "
		sql = sql & " 		SCA_GRADECURRICULAR.Situacao, "
		sql = sql & " 		SCA_GRADECURRICULAR.Cod_Periodo, "
		sql = sql & "       SCA_GRADECURRICULAR.Cod_Empresa, "
		sql = sql & "       SCA_GRADECURRICULAR.dataInicioVigencia, "
		sql = sql & "       SCA_GRADECURRICULAR.dataFimVigencia, "
		sql = sql & "       SCA_GRADECURRICULAR.Cod_Agrupamento "
		sql = sql & " FROM  SCA_GRADECURRICULAR INNER "
		sql = sql & " JOIN 	SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
		sql = sql & " WHERE SCA_GRADECURRICULAR.Cod_Empresa = " & intCodEmp
		sql = sql & " AND 	COD_GRADECURRICULAR = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 		= rs("COD_GRADECURRICULAR")
			intCodCurso			= rs("Cod_Curso")
			intCodPeriodo		= rs("Cod_Periodo")
			intAno				= rs("AnoReferencia")
			intSemestre 		= rs("SemestreReferencia")
			strSituacao			= rs("Situacao")
			
			'vingecia
			strDataInicio		= rs("dataInicioVigencia")
			strDataFim			= rs("dataFimVigencia")
			intCodAgrupamento   = rs("Cod_Agrupamento")

			strDesabilitaIncluir= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir= "disabled" 'Desabilita o botão Excluir

		end if 
		rs.close
		
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 
%>
    <!--=== Content Part ===-->
    <form id="frm" class="margin-bottom-10" method="post">	
    <div class="container content">	
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Grade Curricular</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                
                    <div class="form-group">
                        <label class="form-label">Grade de origem</label>
                         <input name="txtCodigo" type="text" class="form-control" id="txtCodigo" value="<%=intCodigo%>" size="10"  onBlur="submit()">
                         <button class="btn-u btn-u-sea" onClick="return abreConsulta('GradeCurricular_con.asp')" type="button"><i class="fa fa-search"></i></button> 
                    </div>
                    
                    <%	
					if intCodCurso = "" then intCodCurso ="0"
						sql = "SELECT Cod_curso, Descricao, Desc_Abreviada, Sigla, Cod_Grau"
						sql = sql & " FROM SCA_CURSO"
						SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
						SQL = SQL & " AND cod_curso =" & intCodCurso
						sql = sql & " Order by Descricao"
					RS.OPEN SQL, CNN
					if not rs.eof then
						strDescricao = rs("descricao")
					end if
					RS.CLOSE
					%>
                     <input type="hidden" name="cmbCurso" id="cmbCurso" value="<%=intCodCurso%>" >
                     <div class="form-group">
                        <label for="exampleInputEmail1">Curso</label>
                         <%=response.Write(strDescricao)%>
                    </div>
                    
                    <%
						if trim(intCodCurso) = "" then intCodCurso = "0"
						if trim(intCodPeriodo) = "" then intCodPeriodo = "0"
						sql = "SELECT Cod_Periodo, Cod_Curso, Descricao, Sequencia"
						sql = sql & " FROM SCA_PERIODO"
						sql = sql & " where cod_empresa = " & Session("CodEmpresa") 
						sql = sql & " and cod_curso = " & intCodCurso
						sql = sql & " and Cod_Periodo = " & intCodPeriodo
						sql = sql & " Order by Sequencia"
						RS.OPEN SQL, CNN
						if not rs.eof then
							strDescricao = rs("descricao")
						end if
						RS.CLOSE
						%>
                        
                        <input type="hidden" name="cmbPeriodo" id="cmbPeriodo" value="<%=intCodPeriodo%>">
                        <div class="form-group">
                        <label for="exampleInputEmail1">Periodo</label>
                        	<%=response.Write(strDescricao)%>
                        </div>
                        
                        <div class="form-group">
                        <label for="exampleInputEmail1">Disciplinas</label>
						
                        <%
				if intCodigo<>"" then
					sql = "	SELECT DISTINCT "
					SQL = SQL & " SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina as Cod_disciplina_grade, "
					SQL = SQL & " SCA_DISCIPLINA.COD_Disciplina,"
					SQL = SQL & " SCA_DISCIPLINA.DESC_Disciplina"
					SQL = SQL & " FROM SCA_GRADECURRICULARDISCIPLINA "
					SQL = SQL & " INNER JOIN SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina"
					SQL = SQL & " WHERE 1=1"
					SQL = SQL & " AND SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR = " &  intCodigo
					SQL = SQL & " AND SCA_DISCIPLINA.Cod_Empresa = " & intCodEmp

					sql = SQL & " UNION SELECT "
					SQL = SQL & " NULL as Cod_disciplina_grade, "
					SQL = SQL & " SCA_DISCIPLINA.COD_Disciplina,"
					SQL = SQL & " SCA_DISCIPLINA.DESC_Disciplina"
					SQL = SQL & " FROM SCA_DISCIPLINA "
					SQL = SQL & " WHERE 1=1"
					SQL = SQL & " AND SCA_DISCIPLINA.COD_Disciplina NOT IN ("
					
					SQL = SQL & " 		SELECT DISTINCT "
					SQL = SQL & " 		SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina"
					SQL = SQL & " 		FROM SCA_GRADECURRICULARDISCIPLINA "
					SQL = SQL & " 		INNER JOIN SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina"
					SQL = SQL & " 		WHERE 1=1"
					SQL = SQL & " 		AND SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR = " &  intCodigo
					SQL = SQL & " 		AND SCA_DISCIPLINA.Cod_Empresa = " & intCodEmp
					SQL = SQL & " 										)"
					SQL = SQL & " AND SCA_DISCIPLINA.Cod_Empresa = " & intCodEmp
					
					SQL = SQL & " Order by 3"
					end if
					rs.open sql, cnn
					if not rs.eof then  
					%>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
					<%	
					cont = 0
					while not rs.eof
						if cint(cont) = 2 then 
							%>
					<tr>
					<%
						end if
					
						selecionaDisciplina = ""
						if not isnull(rs("Cod_disciplina_grade")) then selecionaDisciplina = " checked "
						%>
					<td width="33%" class="texto1"><%=trim(ucase(rs("DESC_Disciplina")))%></td>
					<%
						cont = cont + 1
						if cint(cont) = 2 then 
							%>
					</tr>
					<tr>
					<%
							cont  = 0
						end if
						
						rs.movenext
					wend
					%>
					</tr>
					</table>
					<%
					end if
					rs.close				  
					%>                
                    </div>
                        
                    
                    <div class="form-group">
                    <label for="exampleInputEmail1">Ano Refer&ecirc;ncia</label>
                        <%=intAno%></strong><input readonly  name="txtAno" type="hidden" class="text" id="txtAno"  value="<%=intAno%>" >
                    </div>
                    
                     <div class="form-group">
                    <label for="exampleInputEmail1">Semestre Refer&ecirc;ncia </label>
                        
                        <strong><%
						if intSemestre = "" then intSemestre = "0"
						sql = "SELECT CODIGO, SIGLA, DESCRICAO "
						sql = sql & " FROM SCA_SEMESTRE"
						sql = sql & " where codigo = "& intSemestre  
						sql = sql & " Order by Codigo"
						RS.OPEN SQL, CNN
						if not rs.eof then
							response.Write(rs("descricao"))
						end if
						RS.CLOSE
						%></strong>
            			<input readonly  name="cmbSemestre" type="hidden" class="text" id="cmbSemestre"  value="<%=intSemestre%>" >
            
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
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Selecione as unidades que serão incluida a nova grade</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="5%" bgcolor="#95A5A6"><input name="chkTodos" type="checkbox" <%=strAbilita%> value="" onClick="return marcaTodos()"></th>
                                    <th width="86%" bgcolor="#95A5A6">Unidade</th>
                                </tr>
                            </thead>
                            <%
							if intCodigo<>"" then
							
							sql = "select codigo, razaosocial as empresa"
							sql = sql & " from SEG_EMPRESA"
							sql = sql & " where codigo in ("&Session("CodTodasEmpresaGrupo")&")"
							sql = sql & " and codigo <> " & intCodEmp
							sql = sql & " order by 2"
							rs.open sql, cnn
							cont=0
							if rs.eof = false then
							
							while not rs.eof
							cont = cont + 1	
							%>
                            <tbody>
                                <tr>
                                    <td><input id="chkEmpresa" name="chkEmpresa" type="checkbox" value="<%=rs("codigo")%>"></td>
                                    <td><%=ucase(rs("empresa"))%></td>
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
       </form>     
    </div>
    <!--/container-->		
    <script>
	
	function abreConsulta(caminho){
		window.open(caminho,"abreConsulta","top=5,left=5,height=600,width=1000,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}	
	
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
		var form = window.document.forms[0];
		if (acao == "I") {	
			
			if (frm.txtCodigo.value == "") {
				alert("A grade de origem deve ser informada!");
				frm.txtCodigo.focus();
				return false;
			}
			var intContMarcado=0;
			
			for (var i = 0; i < form.elements.length; i++) {
				//verifica todos os checkbox
				if (form.elements[i].type == "checkbox"){
					if (form.elements[i].name == "chkEmpresa"){
						//verifica se o checkbox está marcado
						if (form.elements[i].checked){
							intContMarcado = intContMarcado + 1;
						}
					}
				}
			}
			
			if (intContMarcado==0){
				alert("A unidade deve ser selecionada!");
				return false;
			}
			
			frm.action = "GradeCurricular_cod.asp?acao="+acao;
			frm.submit();
			return true;				
		}

		
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