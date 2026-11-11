<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">APO - Controle Ponto</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        intCodEmpresa		= Session("CodEmpresa")
        intCodigo	 		= Trim(Request.Form("txtCodigo"))
        strTipo	 			= Trim(Request.Form("cmbTipo"))
        intHora	 			= Trim(Request.Form("cmbHora"))
        intMinuto 			= Trim(Request.Form("cmbMinuto"))
        intSegundo			= Trim(Request.Form("cmbSegundo"))
        intCodTurno			= Trim(Request.Form("cmbTurno"))
        strSituacao 		= Trim(Request.Form("cmbSituacao"))
        strPagina = "PontoHorario_cad.asp"
        if trim(intCodigo) <> "" then
        
            sql = "SELECT Codigo, Tipo, Hora, Minuto, Segundo, Situacao, Cod_turno "
            sql = sql & " FROM APO_PONTOHORARIO"
            sql = sql & " Where Codigo = " & intCodigo
            rs.open sql, cnn
            
            if rs.eof = false then
                
                intCodigo	 		= rs("Codigo")
                strTipo		 		= rs("Tipo")
                intHora	 			= rs("Hora")
                intMinuto	 		= rs("Minuto")
                intSegundo	 		= rs("Segundo")
                intCodTurno 		= rs("Cod_turno")
                strSituacao 		= rs("Situacao")
            
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
        <div class="row">
            <!-- Begin Content -->
            <div class="col-md-12" >     

       		<!-- Inicia o Painel do Formulario -->     

                <form id="frm" class="sky-form  panel-body0" method="post">
                	
                    <input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
                    
					<div style="background:#95a5a6;height:40px;padding-top: 8px;" class="panel-title">&nbsp;&nbsp;<font color="#FFFFFF"><i class="fa fa-tasks"></i>&nbsp;Tabela de Horário</font></div>

                    <fieldset>
                    
                    
                    <div class="row">
                         <section class="col col-4">
                            <label class="form-label">Horas</label>
                            <label class="input">
                                <select name="cmbHora" id="cmbHora" style="width:50pt" class="form-control">
                                    <option value="0">0</option>
                                    <% for i=1 to 23%>
                                        <option value="<%=i%>" <%if TRIM(intHora) = TRIM(i) then response.Write("selected") %>><%=i%></option>
                                    <% next%>
                                  </select>
                            </label>
                        </section>
                        <section class="col col-4">
                             <label class="form-label">Minutos</label>
                            <label class="input">
                                <select name="cmbMinuto" id="cmbMinuto" style="width:50pt" class="form-control">
                                  <option value="0">0</option>
                                  <% for i=1 to 59%>
                                  <option value="<%=i%>" <%if TRIM(intMinuto) = TRIM(i) then response.Write("selected") %>><%=i%></option>
                                  <% next%>
                                </select>
                            </label>
                        </section>
                        <section class="col col-4">
                            <label class="form-label">Tipo</label>
                            <label class="input">
                                <select name="cmbTipo" class="form-control" id="cmbTipo" style="width:100pt">
                                <option value="E" <%if strTipo = "E" then response.Write("selected") %>>ENTRADA</option>
                                <option value="S" <%if strTipo = "S" then response.Write("selected") %>>SAIDA</option>
                                </select> 
                            </label>
                        </section>
                    </div>
                    
                    
                    <div class="row">
                         <section class="col col-4">
                             <label class="form-label">Turno</label>
                            <label class="input">
                                <!--#include file="../includes/inc_cmbTurnoRH.asp" -->
                            </label>
                        </section>
                        <section class="col col-4">
                            <label class="form-label">Situação</label>
                            <label class="input">
                                <!--#include file="../includes/inc_cmdSituacao.asp" --> 
                            </label>
                        </section>
                        <section class="col col-4">
                             <label class="form-label">&nbsp;</label>
                        </section>
                    </div>
					
                    </fieldset>
					
					<div class="margin-left-40" style="padding-left: 16px">
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
					</DIV>
                    
                 </form>                
                
			</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i>Lista de Horários</h3>
          </div>
      <div class="panel-body">
            	<div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="20%" bgcolor="#95A5A6">Horas</th>
                          <th width="20%" bgcolor="#95A5A6">Minuto</th>
                          <th width="40%" bgcolor="#95A5A6">Tipo</th>
                          <th width="40%" bgcolor="#95A5A6">Turno</th>
                          <th width="40%" bgcolor="#95A5A6">Situa&ccedil;&atilde;o</th>
                          <th width="5%" bgcolor="#95A5A6" align="center"><div align="center">Editar</div></th>
                      </tr>
                    </thead>
                    <%
					sql = "SELECT PH.Codigo, PH.Tipo, PH.Hora, PH.Minuto, PH.Situacao, TU.Desc_Turno, PH.COD_TURNO, (select distinct cod_pontoHorario from APO_PONTOHORARIO_FUNCAO where cod_pontoHorario = PH.Codigo) as existe"
					sql = sql & " FROM APO_PONTOHORARIO PH"
					sql = sql & " INNER JOIN SRH_TURNO TU ON TU.COD_TURNO = PH.COD_TURNO "
					sql = sql & " WHERE PH.Cod_Grupo=" & Session("CodGrupo")
					sql = sql & " ORDER BY TU.Desc_Turno, PH.Tipo, PH.Hora, PH.Minuto"
					rs.open sql, cnn
                    if rs.eof = false then
                    
                    while not rs.eof
						cont = cont + 1	
						
						strSituacao = trim(rs("Situacao"))
						
						if trim(rs("Situacao")) = "A" then
							strSituacao = "Ativo"
						else
							strSituacao = "Inativo"
						end if
						if trim(rs("tipo")) = "E" then
							strNomeTipo = "Entrada"
						else
							strNomeTipo = "Saída"
						end if
						if rs("cod_turno") = "1" then cor = "#9FFFCF"
						if rs("cod_turno") = "2" then cor = "#FFFFC1"
						if rs("cod_turno") = "3" then cor = "#FFD5BF"
						if rs("cod_turno") = "4" then cor = "#9BCFF7"
						
						%>
						<tbody>
							<tr style="background-color:<%=cor%>">
								<td><%=trim(rs("Hora"))%></td>
								<td><%=trim(rs("Minuto"))%></td>
								<td><%=trim(strNomeTipo)%></td>
								<td><%=trim(rs("Desc_Turno"))%></td>
								<td><%=trim(strSituacao)%></td>
							  <td align="center" >
                              <%if isnull(rs("existe")) then%>
								<button class="btn-u btn-u-sea" onclick="resultadoConsulta(<%=trim(rs("Codigo"))%>)" type="button"><i class="fa fa-file-text-o"></i></button> 
                               <%end if%>
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
        </div>
        <!--End Table Bordered-->	
        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
	<script>
        function resultadoConsulta(intCodigo){
            frm.txtCodigo.value=intCodigo;
            frm.submit();
        }
        
        function salvar(acao){
            
            
            if (frm.cmbHora.value == "") {
                alert("A Hora deve ser informada !");
                frm.cmbHora.focus();
                return false;
            }
            if (frm.cmbMinuto.value == "") {
                alert("O Minuto deve ser informado !");
                frm.cmbMinuto.focus();
                return false;
            }
            if (frm.cmbTurno.value == "0") {
                alert("O Turno deve ser informado !");
                frm.cmbTurno.focus();
                return false;
            }
            if (frm.cmbSituacao.value == "0") {
                alert("A Situação deve ser informada !");
                frm.cmbSituacao.focus();
                return false;
            }
            
            frm.action="PontoHorario_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 