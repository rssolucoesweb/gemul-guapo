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

	strFuncao = ""
	strExecutarSubmitTurno = "S"
	
	intCodigo	 								= Trim(Request.Form("txtCodigo"))
	intCodFuncionario							= Trim(Request.Form("txtCodFuncionario"))
	strNomeFuncionario							= Trim(Request.Form("txtNomeFuncionario"))
	intCodFuncional  							= Trim(Request.Form("txtCodigoFuncional"))
	intCodTurno									= Trim(Request.Form("cmbTurno"))
	intPontoHorarioEntradaManha					= Trim(Request.Form("cmbPontoHorarioEntradaManha"))
	intPontoHorarioSaidaManha					= Trim(Request.Form("cmbPontoHorarioSaidaManha"))
	intPontoHorarioEntradaTarde					= Trim(Request.Form("cmbPontoHorarioEntradaTarde"))
	intPontoHorarioSaidaTarde					= Trim(Request.Form("cmbPontoHorarioSaidaTarde"))
	intPontoHorarioEntradaIntegralMatutino		= Trim(Request.Form("cmbPontoHorarioEntradaIntegralMatutino"))
	intPontoHorarioSaidaIntegralMatutino		= Trim(Request.Form("cmbPontoHorarioSaidaIntegralMatutino"))
	intPontoHorarioEntradaIntegralTarde			= Trim(Request.Form("cmbPontoHorarioEntradaIntegralTarde"))
	intPontoHorarioSaidaIntegralTarde			= Trim(Request.Form("cmbPontoHorarioSaidaIntegralTarde"))

	' Consulta Colaborador
	if Trim(Request.Form("LocalizarMatricula")) = "S" and intCodFuncional <> "" then
	
		sql = "Select Codigo, nome, FoneResidencial, FoneComercial, FoneCelular, email, situacao "
		sql = sql & " from SRH_colaborador"
		sql = sql & " where codFuncional = " & intCodFuncional
		rs.open sql, cnn
		if rs.eof = false then
			intCodFuncionario 		= TRIM(rs("Codigo"))
			strNomeFuncionario 		= TRIM(rs("nome"))
			if Trim(rs("situacao")) = "I" then
				%>
				<script>
					alert("ATENÇÃO: Colaborador está inativo no cadastro.");
				</script>
				<%
			end if
		else
			%>
			<script>
				alert("ATENÇÃO: Colaborador não foi encontrado.");
			</script>
			<%
		end if
		rs.close	
	end if
	
	' Consulta Colaborador
	if trim(intCodFuncionario) <> "" then
	
		sql = "Select Codigo, nome, FoneResidencial, FoneComercial, FoneCelular, email, situacao "
		sql = sql & " from SRH_colaborador"
		sql = sql & " where codigo = " & intCodFuncionario
		rs.open sql, cnn
		if rs.eof = false then
			intCodFuncionario 		= TRIM(rs("Codigo"))
			strNomeFuncionario 		= TRIM(rs("nome"))
			if Trim(rs("situacao")) = "I" then
				%>
				<script>
					alert("ATENÇÃO: Colaborador está inativo no cadastro.");
				</script>
				<%
				intCodFuncionario 		= ""
				strNomeFuncionario 		=""
			end if
		else
				intCodFuncionario 		= ""
				strNomeFuncionario 		=""
			%>
			<script>
				alert("ATENÇÃO: Colaborador não foi encontrado.");
			</script>
			<%
		end if
		rs.close	
	
	else
		intCodFuncionario 		= ""
		strNomeFuncionario 		=""
	end if

	if intCodTurno <> "" then
		str_SiglaTurno = ""
		sql = "SELECT SUBSTRING(DESC_TURNO,1,1) AS SIGLA_TURNO "
		sql = sql & " FROM SRH_TURNO"
		SQL = SQL & " WHERE COD_TURNO = " & intCodTurno
		rs.open sql, cnn
		if rs.eof = false then
			str_SiglaTurno				= rs("SIGLA_TURNO")
		end if 
		rs.close
	end if

	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "" 'Desabilita o botão Excluir

	%>    
<!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Tabela de Horários - Colaborador</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                    <div class="form-group">
                        <label class="form-label">Matrícula</label>
                        <input name="txtCodigoFuncional" type="text" class="text" id="txtCodigoFuncional" size="12" maxlength="8" value="<%=intCodFuncional%>"  onkeypress="return formataCampo(this, 2, 8)" />
                <input type="checkbox" name="LocalizarMatricula" value="S" onClick='submit()'>
                  Localizar?&nbsp;
                  </div>
                    <div class="form-group">
                        <label class="form-label">Nome</label>
                          <input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
             			 <input name="txtCodFuncionario" type="hidden" class="text" id="txtCodFuncionario" size="15" maxlength="20" value="<%=intCodFuncionario%>"  onKeyPress="return formataCampo(this, 2, 6)" onblur="submit()">
                         <input name="txtNomeFuncionario" type="text" class="text" id="txtNomeFuncionario" size="50" maxlength="50" value="<%=strNomeFuncionario%>"  onKeyPress="return formataCampo(this, 1, 50)">
              <a  href="#" onclick="return abreConsulta('Colaborador_con.asp')" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('999','','../../images/botao_verde_over.gif',1)"><img alt="Clique para consultar o Coloborador" src="../../images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a>
              
                    </div>
                    <% 	if intCodFuncionario <> "" then %>
                        <div class="form-group">
                            <label class="form-label">Turno</label>
                             <!--#include file="../includes/inc_cmbTurnoRH.asp" -->
                        </div>
						<% if str_SiglaTurno = "M" then %>
                            <div class="form-group">
                                <label class="form-label">Entrada Manh&atilde;</label>
                                 <!--#include file="../includes/inc_cmdPonto_HorarioEntradaManha.asp" -->
                                <label class="form-label">Sa&iacute;da Manh&atilde;</label>
                                  <!--#include file="../includes/inc_cmdPonto_HorarioSaidaManha.asp" -->
                            </div>
                        <% end if %>
						<% if str_SiglaTurno = "V" then %>
                            <div class="form-group">
                                 <label class="form-label">Entrada Tarde</label>
                                 <!--#include file="../includes/inc_cmdPonto_HorarioEntradaTarde.asp" -->
                                <label class="form-label">Sa&iacute;da Tarde</label>
                                  <!--#include file="../includes/inc_cmdPonto_HorarioSaidaTarde.asp" -->
                           </div>
                        <% end if %>
						<% if str_SiglaTurno = "I" then %>
                            <div class="form-group">
                                <label class="form-label">Entrada Manh&atilde;</label>
                                 <!--#include file="../includes/inc_cmdPonto_HorarioEntradaIntegralMatutino.asp" -->
                                <label class="form-label">Sa&iacute;da Manh&atilde;</label>
                                  <!--#include file="../includes/inc_cmdPonto_HorarioSaidaIntegralMatutino.asp" -->
                            </div>
                             <div class="form-group">
                                 <label class="form-label">Entrada Tarde</label>
                                 <!--#include file="../includes/inc_cmdPonto_HorarioEntradaIntegralTarde.asp" -->
                                <label class="form-label">Sa&iacute;da Tarde</label>
                                  <!--#include file="../includes/inc_cmdPonto_HorarioSaidaIntegralTarde.asp" -->
                           </div>
                       <% end if %>
                    <% end if %>
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
                <h3 class="panel-title"><i class="fa fa-globe"></i>Faixas de Horários ( Especiais ) - Colaborador</h3>
          </div>
      <div class="panel-body">
            	<div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="20%" bgcolor="#95A5A6">Horas</th>
                          <th width="20%" bgcolor="#95A5A6">Minuto</th>
                          <th width="20%" bgcolor="#95A5A6">Segundos</th>
                          <th width="40%" bgcolor="#95A5A6">Tipo</th>
                          <th width="40%" bgcolor="#95A5A6">Turno</th>
                          <th width="40%" bgcolor="#95A5A6">Situa&ccedil;&atilde;o</th>
                      </tr>
                    </thead>
                    <%
					if intCodFuncionario <> "" then
						sql = " SELECT distinct PHC.Cod_Colaborador, PHC. Cod_PontoHorario, "
						sql = sql & " PH.Codigo, PH.Tipo, PH.Hora, PH.Minuto, PH.Segundo, PH.Situacao, TU.Desc_Turno "
						sql = sql & " FROM APO_PONTOHORARIO_COLABORADOR PHC "
						sql = sql & " INNER JOIN APO_PONTOHORARIO PH ON PH.CODIGO = PHC.Cod_PontoHorario "
						sql = sql & " INNER JOIN SRH_TURNO TU ON TU.COD_TURNO = PH.COD_TURNO "
						sql = sql & " WHERE  PHC.Cod_Colaborador = " & intCodFuncionario
						sql = sql & " order by TU.Desc_Turno, PH.Hora "
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
							%>
							<tbody>
								<tr>
									<td><%=trim(rs("Hora"))%></td>
									<td><%=trim(rs("Minuto"))%></td>
								  <td><%=trim(rs("Segundo"))%></td>
									<td><%=trim(strNomeTipo)%></td>
									<td><%=trim(rs("Desc_Turno"))%></td>
									<td><%=trim(strSituacao)%></td>
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
        </div>
        <!--End Table Bordered-->	
        <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i>Faixas de Horários ( Ativas ) </h3>
          </div>
      <div class="panel-body">
            	<div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th colspan="2" bgcolor="#95A5A6"><div align="center">Entrada</div></th>
                          <th colspan="2" bgcolor="#95A5A6"><div align="center">Saida</div></th>
                          <th width="40%" rowspan="2" bgcolor="#95A5A6"><div align="center">Turno</div></th>
                      </tr>
                        <tr>
                          <th width="20%" bgcolor="#95A5A6">Horas</th>
                          <th width="20%" bgcolor="#95A5A6">Minuto</th>
                          <th width="20%" bgcolor="#95A5A6">Horas</th>
                          <th width="20%" bgcolor="#95A5A6">Minuto</th>
                      </tr>
                    </thead>
                    <%
					if intCodFuncionario <> "" then
					
						sql = " SELECT distinct "
						sql = sql & " FHC.COD_EMPRESA, "
						sql = sql & " FHC.COD_COLABORADOR, "
						sql = sql & " FHC.COD_TURNO, "
						sql = sql & " FHC.HORA_INICIO, "
						sql = sql & " FHC.MINUTO_INICIO, "
						sql = sql & " FHC.HORA_TERMINO, "
						sql = sql & " FHC.MINUTO_TERMINO, "
						sql = sql & " TU.Desc_Turno "
						sql = sql & " FROM APO_FAIXA_HORARIO_COLABORADOR FHC " 
						sql = sql & " INNER JOIN SRH_TURNO TU ON TU.COD_TURNO = FHC.COD_TURNO " 
						sql = sql & " WHERE  FHC.Cod_Colaborador = " & intCodFuncionario
						sql = sql & " order by TU.Desc_Turno, FHC.HORA_INICIO  "
						rs.open sql, cnn
						if rs.eof = false then
						
							while not rs.eof
								cont = cont + 1	
								
								%>
								<tbody>
									<tr>
										<td><div align="center"><%=trim(rs("HORA_INICIO"))%></div></td>
										<td><div align="center"><%=trim(rs("MINUTO_INICIO"))%></div></td>
										<td><div align="center"><%=trim(rs("HORA_TERMINO"))%></div></td>
										<td><div align="center"><%=trim(rs("MINUTO_TERMINO"))%></div></td>
										<td><div align="center"><%=trim(rs("Desc_Turno"))%></div></td>
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
            
            if (frm.txtCodFuncionario.value == "") {
                alert("O Funcionario deve ser informado !");
                frm.txtCodFuncionario.focus();
                return false;
            }

            if (frm.cmbTurno.value == "0") {
                alert("O Turno deve ser informado !");
                frm.cmbTurno.focus();
                return false;
            }
           
            frm.action="PontoHorario_Colaborador_Cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 