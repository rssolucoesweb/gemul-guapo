<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../menuModulos.asp"-->  
<script src="../../js/js_funcoes_gerais.js"></script>
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
        strPaginaTitulo = "Horario_cad.asp"
        strExecutarSubmitSemestre = "S"
        intSemestre 			= request("cmbSemestre")
        if trim(request("txtAnoLetivo")) = "" then 
            strAnoLetivo = session("strAnoLetivo")
        else
            strAnoLetivo = request("txtAnoLetivo")
        end if
    
        intCodHorario 		= Trim(Request.Form("txtCodigo"))
        strDescricao 		= Trim(Request.Form("txtDescricao"))
        strTurno	       	= Trim(Request.Form("cmbTurno"))
        strDescricaoAntiga	= Trim(Request.Form("txtDescricaoAntiga"))
        strNumeroAula       = request("txtNumeroAula")
        strHoraRelogio      = request("txtHoraRelogio")
        intCodSequenciaAula	= Trim(Request.Form("cmbSequenciaAula"))
        intCodTempoAula		= Trim(Request.Form("cmbTempoAula"))
    
            
        if trim(intCodHorario) <> "" then
        
            sql = "SELECT H.Codigo, H.horario, H.anoletivo, H.semestre, H.numero_aula, H.hora_relogio, H.CodTurno, H.Sequencia_Aulas, H.Tempo, T.DESC_TURNO"
            sql = sql & " FROM SCA_horario H"
            sql = sql & " left join SCA_TURNO T on T.COD_TURNO = H.CodTurno"
            sql = sql & " where H.cod_empresa = " & Session("CodEmpresa")			
            sql = sql & " and H.codigo = " & intCodHorario
            rs.open sql, cnn
            
            if rs.eof = false then
                
                intCodHorario	 		= rs("codigo")
                strAnoLetivo	 		= rs("anoletivo")
                intSemestre			    = rs("semestre")
                strDescricao			= rs("horario")
                strDescricaoAntiga		= rs("horario")
                strNumeroAula			= rs("numero_aula")
                intCodSequenciaAula		= rs("Sequencia_Aulas")
                strHoraRelogio			= rs("hora_relogio")
                strTurno				= trim(rs("DESC_TURNO"))
                intCodTempoAula			= rs("Tempo")
                
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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro Faixas de Horários </h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="txtCodigo" type="hidden" class="text" id="txtCodigo" value="<%=intCodHorario%>" size="10">
                   
                   
                    <div class="form-group">
                        <label class="form-label"> Ano Letivo</label>
                         <input name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" style="width:50pt" value="<%=strAnoLetivo%>" size="80" maxlength="100">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label"> Semestre</label>
                         <!--#include file="../includes/inc_cmdSemestre.asp" -->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Hor&aacute;rio</label>
                         <input name="txtDescricao" type="text" class="form-control" id="txtDescricao" style="width:350pt" value="<%=strDescricao%>" size="80" maxlength="100">
                         <input name="txtDescricaoAntiga" type="hidden" class="text" id="txtDescricaoAntiga" size="40" maxlength="40" value="<%=strDescricaoAntiga%>">
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Turno</label>
                        <select name="cmbTurno" id="cmbTurno" class="form-control" style="width:150pt">
                        <option value="0">Selecione...</option>
                        <option <%if strTurno="MATUTINO" then response.Write("selected") %> value="MATUTINO">MATUTINO</option>
                        <option <%if strTurno="NOTURNO" then response.Write("selected") %> value="NOTURNO">NOTURNO</option>
                        <option <%if strTurno="VESPERTINO" then response.Write("selected") %> value="VESPERTINO">VESPERTINO</option>
                        <option <%if strTurno="INTEGRAL" then response.Write("selected") %> value="INTEGRAL">INTEGRAL</option>
                        </select>
                     </div>
                     
                     <div class="form-group">
                        <label class="form-label">  Sequ&ecirc;ncia</label>
                         <!--#include file="../includes/inc_cmdSequenciaAula.asp"-->
                     </div>
                     
                     <div class="form-group">
                        <label class="form-label">  Tempo</label>
                        <select name="cmbTempoAula" id="cmbTempoAula" class="form-control" style="width:150pt">
                        <option value="0">Selecione...</option>
                        <option <%if intCodTempoAula="1" then response.Write("selected") %> value="1">1&deg; tempo (Antes do intervalo)</option>
                        <option <%if intCodTempoAula="2" then response.Write("selected") %> value="2">2&deg; tempo (Depois do intervalo)</option>
                        </select>
                     </div>
                     
                     <div class="form-group">
                        <label class="form-label">Total Aulas</label>
                         <input name="txtNumeroAula" type="text" class="form-control" onKeyPress="return formataCampo(this,2,10)" id="txtNumeroAula" style="width:50pt" value="<%=strNumeroAula%>"  size="80" maxlength="100">
                     </div>
                     
                     <div class="form-group">
                        <label class="form-label">Total Minutos</label>
                         <input name="txtHoraRelogio" type="text" class="form-control" onKeyPress="return formataCampo(this,2,10)" id="txtHoraRelogio" style="width:50pt" value="<%=strHoraRelogio%>" size="80" maxlength="100">
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
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Faixas de Horários </h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="5%" bgcolor="#95A5A6">>Ano Letivo</th>
                                    <th width="33%" bgcolor="#95A5A6">Semestre</th>
                                  <th width="7%" bgcolor="#95A5A6">Sequência</th>
                                    <th width="14%" bgcolor="#95A5A6">Hor&aacute;rio</th>
                                    <th width="10%" bgcolor="#95A5A6">Turno</th>
                                    <th width="11%" bgcolor="#95A5A6">Total de Aulas</th>
                                    <th width="11%" bgcolor="#95A5A6">Total de Minutos</th>
                                  <th width="9%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                                </tr>
                            </thead>
                            <%
							
							if intSemestre = "" then intSemestre = session("strSemestre")
							
							sql = "SELECT H.*, T.DESC_TURNO "
							sql = sql & " FROM SCA_HORARIO H"
							sql = sql & " left join SCA_TURNO T on T.COD_TURNO = H.CodTurno"
							sql = sql & " Where H.cod_empresa = " & Session("CodEmpresa")	
							sql = sql & " and H.ANOletivo = " & strAnoLetivo		
							sql = sql & " and H.semestre in (" & intSemestre & ")"
							sql = sql & " Order by AnoLetivo, semestre, T.DESC_TURNO, horario"
							rs.open sql, cnn
							cont=0
							if rs.eof = false then
							
							while not rs.eof
							cont = cont + 1	
					
							strCorLinha = ""
							
							if ucase(trim(rs("DESC_TURNO"))) = "MATUTINO" then
								strCorLinha = "bgcolor='#FFFFCC'"
							end if
							
							if ucase(trim(rs("DESC_TURNO"))) = "VESPERTINO" then
								strCorLinha = "bgcolor='#CAFEB4'"
							end if
							
							if ucase(trim(rs("DESC_TURNO"))) = "NOTURNO" then
								strCorLinha = "bgcolor='#D8D8D8'"
							end if
							
							if ucase(trim(rs("DESC_TURNO"))) = "INTEGRAL" then
								strCorLinha = "bgcolor='#C2CAFC'"
							end if
							%>
                            <tbody>
                                <tr <%=strCorLinha%>>
                                    <td><%=trim(rs("anoletivo"))%></td>
                                    <td><%=trim(rs("semestre"))%></td>
                                    <td><%=trim(rs("Sequencia_Aulas"))%></td>
                                    <td><%=trim(rs("horario"))%></td>
                                    <td><%=trim(rs("DESC_TURNO"))%></td>
                                    <td><%=trim(rs("numero_aula"))%></td>
                                    <td><%=trim(rs("hora_relogio"))%></td>
                                   <td align="center" >
                                    <button class="btn-u btn-u-sea" onClick="resultadoConsulta(<%=trim(rs("Codigo"))%>)" type="button"><i class="fa fa-file-text-o"></i></button> 
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
    <!--/container-->		
    <script>
	function salvar(acao){
		
			var frm = document.getElementById("frm");
		
		if (frm.cmbSemestre.value == "0") {
			alert("O Semestre deve ser informado !");
			frm.cmbSemestre.focus();
			return false;
		}

		if (frm.txtDescricao.value == "") {
			alert("O horario deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		
		if (frm.cmbTurno.value == "0") {
			alert("O Turno deve ser informado !");
			frm.cmbTurno.focus();
			return false;
		}
		
		if (frm.cmbSequenciaAula.value == "0") {
			alert("A Sequência de ordem do Horário deve ser informada !");
			frm.cmbSequenciaAula.focus();
			return false;
		}

		if (frm.cmbTempoAula.value == 0){
			alert("Tempo de Aulo deve ser informado.");
			frm.cmbTempoAula.focus();
			return false;
		}	

		frm.action="Horario_cod.asp?acao=" + acao;
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