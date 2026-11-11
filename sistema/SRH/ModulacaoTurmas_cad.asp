<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">SRH - Recurso Humano</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
<%
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitTurma	  = "S"
	strBotaoAcaoLimpar		  = "ModulacaoTurmas_cad.asp"
	strVerificaTipoFuncao	  = "PROFESSOR" ' Habilita o filtro tipo de funcao na combo cmbFuncao

	strPaginaTitulo 			= "ModulacaoTurmas_cad.asp"
	intCodEmpresa				= session("codEmpresa")

	intCodTurma 			= Trim(Request("txtCodigo"))
	intCodItem 				= Trim(Request.Form("txtintCodigoItem"))

	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
	end if

	if trim(request("cmbSemestre")) = "0" or trim(request("cmbSemestre")) = ""  then 
		intSemestre = session("strSemestre")
	else
		intSemestre  = Trim(Request.Form("cmbSemestre"))
	end if

	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))

	intCodFuncao 	    	= TRIM(Request.Form("cmbFuncao"))
	intCodTurnoRH 	    	= TRIM(Request.Form("cmbTurnoRH"))

	strVagas	 		    = TRIM(Request.Form("cmbVagas"))
	intCodTipoEmpresa		= Trim(Request.Form("cmbTipoEmpresa"))

	if strTipoModulacao 		= "0" then strTipoModulacao = "I"
	strDesabilitaBotaoPatrimonioColaborador = " " 
	if trim(intCodTurma) = "" then strDesabilitaBotaoPatrimonioColaborador = " Disabled "
	
	if trim(intCodTurma) <> "" then
		sql = " SELECT T.Cod_Turma, P.Cod_Curso, P.Cod_Periodo, T.Cod_Semestre, T.AnoLetivo,  T.Cod_Tipo_Unidade, T.Cod_Tipo_Modulacao, T.NomeTurma, TRH.cod_turno " 
		sql = sql & " FROM SCA_TURMA T " 
		sql = sql & " LEFT JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular " 
		sql = sql & " LEFT JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo "  
		sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
		sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) and TRH.Cod_Grupo = " & Session("CodGrupo")	  
		sql = sql & " where T.cod_empresa = " & intCodEmpresa	
		sql = sql & " AND T.Cod_Turma = " & intCodTurma	
		rs.open sql, cnn
		
		if rs.eof = false then

			strAnoLetivo 			= rs("AnoLetivo")
			intSemestre 			= rs("Cod_Semestre")
			intCodTurma 			= rs("Cod_Turma")
			intCodCurso	 			= rs("Cod_Curso")
			intCodPeriodo 			= rs("Cod_Periodo")
			strTipoModulacao		= rs("Cod_Tipo_Modulacao")
			strNomeTurma 			= rs("NomeTurma")
			'if mid(strNomeTurma,6,1) <> "I" then
				intCodTurnoRH 	    = rs("cod_turno")
			'end if
			intCodTipoEmpresa		= rs("Cod_Tipo_Unidade")
	
			strDesabilitaIncluir			= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 			= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir			= "" 'Desabilita o botão Excluir

		end if 
		rs.close
		
	else
		strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if
%>
    <!--=== Content Part ===-->
    <form id="frm" method="post" action="ModulacaoTurmas_cad.asp">
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Modulação de Turmas</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                
                    
                    <div class="form-group">
					<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodTurma%>" maxlength="10">
					<input name="txtCodigoItem" type="hidden" id="txtCodigoItem" class="text" size="10" value="<%=intCodItem%>" maxlength="10">
					<input name="txtFLagTurnoTurma" type="hidden" id="txtFLagTurnoTurma" class="text" size="10" value="<%=mid(strNomeTurma,6,1)%>" maxlength="10">          

                    <table border="0" width="98%" cellspacing="0" cellpadding="0">
						  <tr>
							<td height="25" class="texto1">Ano Letivo:</td>
							<td><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onblur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onkeypress="return formataCampo(this,2,10)"></td>
						  </tr>
						  <tr>
							<td height="25" class="texto1">Semestre:</td>
							<td><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
						  </tr>
						  <tr>
							<td height="25" class="texto1">Curso</td>
							<td><span class="texto1"><!--#include file="../includes/inc_cmdCurso.asp"--></span></td>
						  </tr>
						  <tr>
							<td height="25" class="texto1">Per&iacute;odo:</td>
							<td><!--#include file="../includes/inc_cmdPeriodo.asp"--></td>
						  </tr>
						  <tr>
							<td height="25" class="texto1">Turma:</td>
							<td><!--#include file="../includes/inc_cmdTurma.asp"--></td>
						  </tr>
						  
						  <tr>
							<td height="25" class="texto1">Tipo Unidade:</td>
							<td><!--#include file="../includes/inc_cmbTipoEmpresa.asp"--></td>
						  </tr>
						  <tr>
							<td height="25" class="texto1">&nbsp;</td>
							<td>&nbsp;</td>
						  </tr>
						  <tr>
							<td width="191" height="25" class="texto1">Fun&ccedil;&atilde;o:</td>
							<td width="1103" class="texto1"><!--#include file="../includes/inc_cmbFuncao.asp" --> 
							  - Modular Fun&ccedil;&atilde;o na Reg&ecirc;ncia</td>
						  </tr>
						  <tr>
							<td width="191" height="25" class="texto1">Turno da Fun&ccedil;&atilde;o:
							<input name="txtCodTurnoTurma" type="hidden" id="txtCodTurnoTurma" class="text" size="10" value="<%=intCodTurno%>" maxlength="10">
					
						  </td>
							<td width="1103" class="texto1"><!--#include file="../includes/inc_cmbTurnoModulacaoTurmasFuncao.asp" --> 
						  </tr>

						  <tr>
							<td height="25" class="texto1">Vagas Necess&aacute;rias:</td>
							<td><select name="cmbVagas" id="cmbVagas" class="form-control">
							  <option value="0">Selecione...</option>
							  <option value="1" <%if strVagas = "1" then response.Write("selected") %>>01</option>
							  <option value="2" <%if strVagas = "2" then response.Write("selected") %>>02</option>
							  <option value="3" <%if strVagas = "3" then response.Write("selected") %>>03</option>
							  <option value="4" <%if strVagas = "4" then response.Write("selected") %>>04</option>
							  <option value="5" <%if strVagas = "5" then response.Write("selected") %>>05</option>
							  <option value="6" <%if strVagas = "6" then response.Write("selected") %>>06</option>
							  <option value="7" <%if strVagas = "7" then response.Write("selected") %>>07</option>
							  <option value="8" <%if strVagas = "8" then response.Write("selected") %>>08</option>
							  <option value="9" <%if strVagas = "9" then response.Write("selected") %>>09</option>
							  <option value="10" <%if strVagas = "10" then response.Write("selected") %>>10</option>
							  <option value="11" <%if strVagas = "11" then response.Write("selected") %>>11</option>
							  <option value="12" <%if strVagas = "12" then response.Write("selected") %>>12</option>
							  <option value="13" <%if strVagas = "13" then response.Write("selected") %>>13</option>
							  <option value="14" <%if strVagas = "14" then response.Write("selected") %>>14</option>
							  <option value="15" <%if strVagas = "15" then response.Write("selected") %>>15</option>
							  <option value="16" <%if strVagas = "16" then response.Write("selected") %>>16</option>
							  <option value="17" <%if strVagas = "17" then response.Write("selected") %>>17</option>
							  <option value="18" <%if strVagas = "18" then response.Write("selected") %>>18</option>
							  <option value="19" <%if strVagas = "19" then response.Write("selected") %>>19</option>
							  <option value="20" <%if strVagas = "20" then response.Write("selected") %>>20</option>
							  <option value="21" <%if strVagas = "21" then response.Write("selected") %>>21</option>
							  <option value="22" <%if strVagas = "22" then response.Write("selected") %>>22</option>
							</select></td>
						  </tr>
						  <tr>
							<td height="25" class="texto1">Modula&ccedil;&atilde;o Complementar?</td>
							<td class="texto1">
							  <input name="cmdModulacaoComplementar" type="button"  class="btn-u btn-u-blue float-shadow" id="cmdModulacaoComplementar" style="cursor:hand" onclick="ModulacaoComplementar()"   value="Modulação Disciplinar" <%=strDesabilitaBotaoPatrimonioColaborador%>/>
							 - Modular func&atilde;o na disciplina da grade Curricular</td>
						  </tr class="texto1">
						  <tr>
							<td class="texto1">Gerar Replica&ccedil;&atilde;o:</td>
							<td class="texto1"><span class="TextoForm">
							  <input type="checkbox" name="ModularGrupo" value="S">
							  - Para o Grupo</span></td>
						  </tr class="texto1">
						  <tr>
							<td class="texto1">&nbsp;</td>
							<td class="texto1">&nbsp;</td>
						  </tr class="texto1">
						  <tr>
							<td colspan="2">
							
						
							<%
							if trim(intCodTurma) <> "" then
								sql = " SELECT TMF.Codigo, FC.DESC_FUNCAO, TMF.Total_Vaga_Funcao, ISNULL(TU.DESC_TURNO,'------') AS DESC_TURNO "
								sql = sql & " FROM SRH_TURMA_MODULACAO_FUNCAO TMF " 
								sql = sql & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = TMF.Cod_Funcao "
								sql = sql & " INNER JOIN SRH_TURNO TU ON TU.COD_TURNO = TMF.cod_TurnoFuncao "
								sql = sql & " where TMF.Cod_turma = " & intCodTurma
								sql = sql & " Order by FC.DESC_FUNCAO "
								rs.open sql, cnn
												
								if rs.eof = false then
								%>
									<table width = "70%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
									  <tr bgcolor="#E5E5E5">
										<td width="72%" height="21" class="celula"><div align="center"><strong>Fun&ccedil;&atilde;o<span class="TextoForm"></span></strong></div></td>
										<td width="21%" class="celula"><div align="center"><strong>Turno</strong></div></td>
										<td width="21%" class="celula"><div align="center"><strong>Vagas</strong></div></td>
										<td width="7%" class="celula"><strong>Excluir</strong></td>
									  </tr>
									  <%
									while not rs.eof
										%>
									  <tr>
										<td height="20" class="celula"><%=trim(rs("DESC_FUNCAO"))%></td>
										<td class="celula"><%=trim(rs("DESC_TURNO"))%></td>
										<td height="20" class="celula"><div align="center"><%=trim(rs("Total_Vaga_Funcao"))%></div></td>
										<td height="20" class="celula"><div align="center"><a href="#" onclick="ExcluirFuncao('<%=rs("codigo")%>')" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image<%=rs("codigo")%>','','<%=session("strCaminhoRaiz")%>/images/botao_vermelho_over.gif',1)"><img alt="Clique para excluir a Funcão." align="middle" src="<%=session("strCaminhoRaiz")%>/images/botao_vermelho_normal.gif" name="Image<%=rs("codigo")%>" width="26" height="26" border="0"></a></div></td>
									  </tr>
									  <%				
										rs.movenext
										wend
									%>
									  </table>
								  <%
								  end if
								  rs.close
							end if	  
							%>           
							<br>
							</td>
						  </tr>
						  <tr>
							<td colspan="2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
						  </tr>
						  <tr>
							<td colspan="2">&nbsp;</td>
						  </tr>
						  <tr>
							<td colspan="2" class="texto1"><%
							cont =0  
							sql = "SELECT SCA_TURMA.Cod_Turma, SCA_TURMA.nomeTurma, SCA_TURMA.TurmaAluno, SCA_TURMA.AnoLetivo, "
							sql = sql & " SCA_TURMA.Cod_Semestre, SCA_TURNO.Desc_turno, SCA_TURMA.Cod_GradeCurricular, "
							sql = sql & " SCA_TURNO.cod_turno as TurnoRH, SCA_TURMA.Situacao_modulacao "
							sql = sql & " FROM SCA_TURMA"
							sql = sql & " INNER JOIN SCA_TURNO ON SCA_TURNO.cod_turno = SCA_TURMA.cod_turno "
							sql = sql & " LEFT JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
							sql = sql & " LEFT JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
							sql = sql & " where SCA_TURMA.cod_empresa = " & Session("CodEmpresa")			
							sql = sql & " and 	AnoLetivo = " & strAnoLetivo
							sql = sql & " and 	SCA_TURMA.Cod_Semestre = " & intSemestre
							sql = sql & " and 	sca_turma.situacao = 'A'"			
							sql = sql & " and 	ISNULL(cod_turma_grupo,'0')=0 "
							if intCodTurnoRH <> "0" AND intCodTurnoRH <> "" then
								sql = sql & " and SCA_TURNO.cod_turno = " & intCodTurnoRH
							end if
							if intCodCurso <> "0" then
								sql = sql & " and 	SCA_PERIODO.Cod_Curso = " & intCodCurso
							end if
							if intCodPeriodo <> "0" then
								sql = sql & " and 	SCA_PERIODO.Cod_Periodo = " & intCodPeriodo
							end if
							sql = sql & " Order by SCA_TURMA.AnoLetivo, SCA_TURMA.nomeTurma"
							rs.open sql, cnn
											
							if rs.eof = false then
							  %>
							  <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
								<tr bgcolor="#E5E5E5">
								  <td width="8%" bgcolor="#E5E5E5" class="celula"><strong>Turma </strong></td>
								  <td width="8%" height="21" class="celula"><strong>Ano Letivo <span class="TextoForm"></span></strong></td>
								  <td width="10%" class="celula"><strong>Semestre Letivo </strong></td>
								  <td width="10%" class="celula"><strong>Turno</strong></td>
								  <td width="56%" class="celula"><div align="center"><strong>Func&atilde;o(&otilde;es) e Vagas Moduladas</strong></div></td>
								  <td width="8%" align="center" class="celula"><strong>Editar</strong></td>
								  <td width="8%" class="celula"><div align="center"><strong>Ativar/Inativar Modula&ccedil;&atilde;o</strong></div></td>
								</tr>
								
								<%
								ContaPrimeiraLinha = 0
								while not rs.eof
									cont = cont + 1	
									strSituacao = "<strong><font color='#FF0000'>Sem Fechamento</font></strong>"
									strSituacao = "<strong><font color='#FF0000'>Inativa</font></strong>"
									if rs("Situacao_modulacao") = "A" then
										strNomeBotao = "INATIVAR"
										strMarcaInativado = " "
									else
										strNomeBotao = "ATIVAR"
										strMarcaInativado = " bgcolor='#FF9966' "
									end if
									%>
									<tr onmouseover="return linhaMouseOver(this)" onmouseout="return linhaMouseOut(this)"  <%=strMarcaInativado%> >
									  <td class="celula"><strong><%=trim(rs("NomeTurma"))%></strong>&nbsp;&nbsp;&nbsp;<%=trim(rs("TurmaAluno"))%></td>
									  <td height="20" class="celula"><div align="center"><%=trim(rs("AnoLetivo"))%>&nbsp;</div></td>
									  <td height="20" class="celula"><div align="center"><%=trim(rs("Cod_Semestre"))%>&nbsp;</div></td>
									  <td height="20" class="celula"><%=trim(rs("Desc_turno"))%>&nbsp;</td>
									  <td height="20" class="celula">
									  <%
										sql = " SELECT FC.DESC_FUNCAO, TMF.Total_Vaga_Funcao, ISNULL(TU.DESC_TURNO,'') AS DESC_TURNO "
										sql = sql & " FROM SRH_TURMA_MODULACAO_FUNCAO TMF " 
										sql = sql & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = TMF.Cod_Funcao "
										sql = sql & " INNER JOIN SRH_TURNO TU ON TU.COD_TURNO = TMF.cod_TurnoFuncao "
										sql = sql & " where TMF.Cod_turma = " & rs("Cod_Turma")
										sql = sql & " and FC.TIPO_FUNCAO = 'PROFESSOR' "
										sql = sql & " Order by FC.DESC_FUNCAO "
										rsaux.open sql, cnn
										if rsaux.eof = false then
											while not rsaux.eof
												response.write "<br><strong><font color='#FF0000'><li>" & rsaux("DESC_FUNCAO") & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-> " & rsaux("Total_Vaga_Funcao") & " Vaga(s) " & rsaux("DESC_TURNO") & " <li></font></strong>"
												rsaux.movenext
											wend
										  end if
										  rsaux.close

										  sql = " SELECT D.DESC_Disciplina, FC.DESC_FUNCAO, GCDT.Total_Vaga_Funcao, ISNULL(TU.DESC_TURNO,'------') AS DESC_TURNO "
										  sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA GCD " 
										  sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA_TURNO GCDT ON GCDT.Cod_GradeCurricularDisciplina = GCD.Cod_GradeCurricularDisciplina "
										  sql = sql & " INNER JOIN SRH_TURNO TU ON TU.COD_TURNO = GCDT.cod_TurnoFuncao "  
										  sql = sql & " INNER JOIN SCA_DISCIPLINA D ON GCD.Cod_Disciplina = D.COD_Disciplina "
										  sql = sql & " LEFT JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = GCDT.Cod_Funcao "
										  sql = sql & " WHERE GCD.COD_GRADECURRICULAR = " & rs("Cod_GradeCurricular")
										  if mid(trim(rs("NomeTurma")),6,1) <> "I" then
											sql = sql & " and GCDT.Cod_TurnoFuncao = " & rs("TurnoRH")
										  end if
										  sql = sql & " and ISNULL(GCDT.Cod_Funcao,'0')<> '0' "
										  sql = sql & " and FC.TIPO_FUNCAO = 'PROFESSOR' "
										  sql = sql & " order by D.DESC_Disciplina" 
										  rsaux.open sql, cnn		
										  if not rsaux.eof then
											  while not rsaux.eof 
												response.write "<br><strong><font color='#FF0000'><li>" & rsaux("DESC_FUNCAO") & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-> " & rsaux("Total_Vaga_Funcao") & " Vaga(s) " & rsaux("DESC_TURNO") & "</font></strong><br>&nbsp;"
												   rsaux.movenext
											  wend 
										   end if
										   rsaux.close
										  
									  %>
									 &nbsp;</td>
									  <td class="celula" align="center"><input type="button" name="cmdEditar" style="cursor:hand" onclick="return resultadoConsulta('<%=rs("Cod_Turma")%>')"  value="  EDITAR  " class="btn-u btn-u-gree float-shadow" ></td>
									  <td class="celula" align="center"><input type="button" name="cmdStatusModulacao" style="cursor:hand"   value="<%=strNomeBotao%>" class="btn-u btn-u-blue float-shadow" onclick="return AtivaInativaModulacao('<%=rs("Cod_Turma")%>','<%=rs("Situacao_modulacao")%>')"></td>
									</tr>
									  <%
									rs.movenext
								wend
								%>
								<tr>
								  <td height="21" colspan="7" bgcolor="#E5E5E5" class="celula">Total Registros : <%=cont%></td>
								</table>
								<%
							end if
							rs.close%></td>
						  </tr>
						</table>
                    
                    	
             		 </div>
                    
                    
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
      <!-- Fecha o Painel do Formulario -->        
    </div>
    </form>
    <!--/container-->		
<script>

	function ExcluirFuncao(Codigo){
		var men = 'ATENCAO: \nA Função Modulada sera exluida, deseja continuar?';
		if (confirm(men)) {
			var acao ="EF";
			window.open("ModulacaoTurmas_cod.asp?acao=" + acao + "&CodigoItem=" + Codigo,"Item_Modulacao", "top=0,left=0,height=10,width=10,menubar=no,toolbar=no,scrollbars=yes,status=yes");
		}
	}

	function AtivaInativaModulacao(Codturma, Status){
		var men = 'ATENÇÃO: \nDeseja realmente mudar o STATUS desta Modulação?';
		if (confirm(men)) {
			window.open("ModulacaoTurmaMudaStatus_cod.asp?Codturma="+Codturma+"&Status="+Status,"excluir", "top=0,left=0,height=150,width=150,menubar=no,toolbar=no,scrollbars=no,status=no");
			return true;
		} else {
			return false;
		}
	
 	}

	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.action = "ModulacaoTurmas_cad.asp";
		frm.submit();
	}

	function resultadoConsultaItem(intCodigoItem){
		
		var frm = document.getElementById("frm");
		frm.txtintCodigoItem.value=intintCodigoItem;
		frm.action = "ModulacaoTurmas_cad.asp";
		frm.submit();
	}
	
	function salvar(acao){
		
		if (frm.txtAnoLetivo.value == "") {
			alert("O Ano Letivo deve ser informado !");
			frm.txtAnoLetivo.focus();
			return false;
		}

		if (frm.cmbSemestre.value == "0") {
			alert("O Semestre deve ser informado !");
			frm.cmbSemestre.focus();
			return false;
		}

		if (frm.cmbTurma.value == "0") {
			alert("A Turma deve ser informada !");
			frm.cmbTurma.focus();
			return false;
		}

		if (frm.cmbTipoEmpresa.value == "0") {
			alert("O Tipo de Unidade deve ser informado !");
			frm.cmbTipoEmpresa.focus();
			return false;
		}

		if (frm.cmbFuncao.value == "0") {
			alert("A Funcao deve ser informada !");
			frm.cmbFuncao.focus();
			return false;
		}

		if (frm.cmbVagas.value == "0") {
			alert("A quantidade de Vagas deve ser informada !");
			frm.cmbVagas.focus();
			return false;
		}

		frm.action="ModulacaoTurmas_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
	
	function ModulacaoComplementar(){
		frm.action="ModulacaoCurricular_cad.asp?CodigoTurma="+frm.txtCodigo.value;
		frm.submit();
		return true;
	}

</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 