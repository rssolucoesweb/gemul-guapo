<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"--> 
<!--#include file="../../includes/inc_replaceRequest.asp"-->
<!--=== Breadcrumbs ===-->
  
<div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Gerencial</h1>
            <ul class="pull-right breadcrumb">
                <li>Consulta Grade Curricular </li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
		strAnoLetivo 	= request("txtAnoLetivo")
		intSemestre 	= request("cmbSemestre")
		if intSemestre = "" then intSemestre = 0
	%>
    <!--=== Content Part ===-->
   <form id="frm" class="margin-bottom-10" method="post">
    <div class="container content">		
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Consulta Grade Curricular</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
               
                    <div class="form-group">
                        <label class="form-label">Ano</label>
                         <input  name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Semestre</label>
                         <!--#include file="../includes/inc_cmdSemestre.asp" -->
                    </div>
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_consulta1.asp"-->
                
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
        <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Grades Curriculares</h3>
            </div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th width="5%" bgcolor="#95A5A6">Código</th>
                            <th width="27%" bgcolor="#95A5A6">Curso</th>
                            <th width="21%" bgcolor="#95A5A6">Perido</th>
                            <th width="17%" bgcolor="#95A5A6">Ano</th>
                            <th width="26%" bgcolor="#95A5A6">Semestre</th>
                       	  <th width="4%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                        </tr>
                    </thead>
                    <%
					cont =0

				sql = "SELECT     	SCA_GRADECURRICULAR.Cod_Empresa, SCA_GRADECURRICULAR.Cod_GradeCurricular, SCA_PERIODO.Cod_Curso, "
					sql = sql & "     	SCA_CURSO.Descricao as descCurso, SCA_GRADECURRICULAR.Cod_Periodo, SCA_PERIODO.Descricao, "
					sql = sql & " 	  	SCA_GRADECURRICULAR.AnoReferencia, SCA_GRADECURRICULAR.SemestreReferencia, SCA_GRADECURRICULAR.Situacao"
					sql = sql & " FROM  SCA_GRADECURRICULAR INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo "
					sql = sql & " INNER JOIN SCA_CURSO ON SCA_PERIODO.Cod_Curso = SCA_CURSO.Cod_curso			"
					sql = sql & " where SCA_GRADECURRICULAR.cod_empresa = " & Session("CodEmpresa")	
					if strAnoLetivo <> "" then
						sql = sql & " and SCA_GRADECURRICULAR.AnoReferencia = " & strAnoLetivo
					end if
					if intSemestre <> "0" then
						sql = sql & " and SCA_GRADECURRICULAR.SemestreReferencia = " & intSemestre
					end if
					sql = sql & " ORDER BY SCA_PERIODO.Cod_Curso, 	SCA_PERIODO.Descricao"	
					rs.open sql, cnn
						
					if rs.eof = false then
	
					while not rs.eof
						cont = cont + 1	
						Semestre = rs("SemestreReferencia")
						if Semestre = "1" then Semestre = "1º Semestre"
						if Semestre = "2" then Semestre = "2º Semestre"
						if Semestre = "3" then Semestre = "Anual"
                    %>
                    <tbody>
                        <tr>
                            <td><%=trim(rs("Cod_GradeCurricular"))%></td>
                            <td><%=trim(rs("descCurso"))%></td>
                            <td><%=trim(rs("Descricao"))%></td>
                            <td><%=trim(rs("AnoReferencia"))%></td>
                            <td><%=Semestre%></td>
                            <td><button class="btn-u btn-u-sea" onClick="resultadoConsulta('<%=trim(rs("Cod_GradeCurricular"))%>')" type="button"><i class="fa fa-file-text-o"></i></button> 
                            </td> 
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
    </form>
    <!--/container-->		
	<script>
		function resultadoConsulta(intCodigo){
			window.opener.frm.txtCodigo.value = intCodigo;
			window.opener.frm.submit();
			window.close();
		}
    </script>
    <!--#include file="../jsModulo.asp"-->
</body>
</html> 