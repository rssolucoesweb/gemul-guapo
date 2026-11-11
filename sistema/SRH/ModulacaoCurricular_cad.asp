<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"--> 
<!--#include file="../../includes/inc_replaceRequest.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  

   <!--=== Breadcrumbs ===-->
	  
<div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo RH </h1>
            <ul class="pull-right breadcrumb">
                <li>Consulta de Funcionários </li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
    strPaginaTitulo									= "ModulacaoCurricular_cad.asp"
	strPagina 										= "ModulacaoCurricular_cad.asp"
	strExecutarDisciplinaGrade						= "S"	
	strVerificaTipoFuncao							= "PROFESSOR" ' Habilita o filtro tipo de funcao na combo cmbFuncao
	
	intCodEmp 										= Session("CodEmpresa")
	intCodGradeCurricularDisciplina	 				= Trim(Request.form("txtCodGradeCurricularDisciplina")) 
	if Trim(Request("CodigoTurma")) <> "" then  
		intCodTurma	 								= Trim(Request("CodigoTurma"))
	else
		intCodTurma	 								= Trim(Request.form("txtCodTurma"))
	end if
	intCodFuncao 	    							= TRIM(Request.Form("cmbFuncao"))
	intCodTurno 	    							= TRIM(Request.Form("cmbTurnoRH"))
	intCodTurnoTurma    							= TRIM(Request("txtCodTurnoTurma"))
	strVagas	 									= TRIM(Request.Form("cmbVagas"))

	if trim(intCodTurma) <> "" then
	
		sql = " SELECT C.Cod_curso, P.Cod_Periodo, T.Cod_GradeCurricular, C.Descricao AS Desc_Curso, P.Descricao as Desc_Periodo, T.NomeTurma, tu.desc_turno as turnoTurma, TURH.cod_turno as TurnoRH "
		sql = sql & " FROM SCA_TURMA T " 
		sql = sql & " INNER JOIN SCA_TURNO TU ON TU.cod_turno = T.cod_turno "
		sql = sql & " INNER JOIN SRH_TURNO TURH ON SUBSTRING(TURH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) and TURH.Cod_Grupo = " & Session("CodGrupo")	  
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON T.Cod_GradeCurricular = GC.Cod_GradeCurricular " 
		sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
		sql = sql & " INNER JOIN SCA_CURSO C ON C.Cod_curso = P.Cod_Curso "
		sql = sql & " where T.Cod_Turma = " & trim(intCodTurma)
		rs.open sql, cnn
		if rs.eof = false then
			
			intCodGrade				= rs("Cod_GradeCurricular")
			intCodCurso				= rs("Cod_Curso")
			intCodPeriodo			= rs("Cod_Periodo")
			strNomeTurma 			= rs("NomeTurma")
			strDescricaoCurso		= rs("Desc_Curso")
			strDescricaoPeriodo		= rs("Desc_Periodo")
			intCodTurnoRH			= rs("TurnoRH")
			turnoTurma				= rs("turnoTurma")
		
			strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar = "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir= "disabled" 'Desabilita o botão Excluir

		end if 
		rs.close
		
	end if 

	if trim(intCodGradeCurricularDisciplina) <> "" then

		sql = " SELECT GCD.Cod_GradeCurricularDisciplina, GCD.COD_Disciplina, D.Desc_Disciplina "
		sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA GCD " 
		sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.Cod_Disciplina = GCD.COD_Disciplina "
		sql = sql & " WHERE GCD.Cod_GradeCurricularDisciplina = " &  intCodGradeCurricularDisciplina
		rs.open sql, cnn
		if rs.eof = false then
			
			strDescricaoDisciplina			= rs("Desc_Disciplina")

			strDesabilitaIncluir 	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir

		end if 
		rs.close
		
	end if 

	if intCodigo = "" then intCodigo = 0
        
    %>
    <!--=== Content Part ===-->
    <div class="container content">	
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Modulação Disciplinar</h3>
        </div>
        
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">    
            
           	  <form id="frm1" method="post">
          <input name="txtCodGradeCurricularDisciplina" type="hidden" id="txtCodGradeCurricularDisciplina" class="text" size="10" value="<%=intCodGradeCurricularDisciplina%>" maxlength="10">
          <input name="txtCodTurma" type="hidden" id="txtCodTurma" class="text" size="10" value="<%=intCodTurma%>" maxlength="10">
          <input name="txtCodTurnoTurma" type="hidden" id="txtCodTurnoTurma" class="text" size="10" value="<%=intCodTurnoTurma%>" maxlength="10">   
		  <table width="98%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td colspan="2" bgcolor="#E6E6E6" class="texto1"><strong>Dados da Grade de Origem</strong></td>
            </tr>
          <tr>
            <td height="24" class="texto1">Grade: </td>
            <td class="texto1"><strong><%=intCodGrade%>&nbsp;</strong></td>
          </tr>
          <tr>
            <td height="24" class="texto1">Curso/Período: </td>
            <td class="texto1"><strong><%=strDescricaoCurso%> - <%=strDescricaoPeriodo%></strong></td>
          </tr>
          <tr>
            <td height="24" class="texto1">Turma: </td>
            <td class="texto1"><strong><%=strNomeTurma%></strong></td>
          </tr>
		  <tr>
            <td height="24" class="texto1">Turno: </td>
            <td class="texto1"><strong><%=turnoTurma%></strong></td>
          </tr>
          <tr>
            <td class="texto1">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2" bgcolor="#E6E6E6" class="texto1"><strong>Dados da Modula&ccedil;&atilde;o</strong></td>
            </tr>
          <% 
		  
		  if trim(intCodGradeCurricularDisciplina) <> "" then %>
               <tr>
                <td width="146" height="24" class="texto1">Disciplina: </td>
                <td width="557" class="texto1"><strong><%=strDescricaoDisciplina%></strong></td>
              </tr>
             <tr>
                <td height="23" class="texto1">Fun&ccedil;&atilde;o:</td>
                <td><!--#include file="../includes/inc_cmbFuncao.asp" --></td>
              </tr>
             <tr>
                <td height="23" class="texto1">Turno:</td>
                <td><!--#include file="../includes/inc_cmbTurnoModulacaoTurmasFuncao.asp" --> </td>
              </tr>
              <tr>
                <td height="23" class="texto1">Vagas Necess&aacute;rias:</td>
                <td><select name="cmbVagas"  class="form-control" id="cmbVagas">
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
                <td height="23" class="texto1">Gerar Replica&ccedil;&atilde;o:</td>
                <td><span class="TextoForm">
                  <input type="checkbox" disabled name="ModularGrupoGrade" value="S">
    - Para o Grupo</span></td>
              </tr>
             <tr>
            	<td colspan="2">
				<%
			
				sql = " SELECT GCDT.Codigo, GCDT.Cod_GradeCurricularDisciplina, FC.DESC_FUNCAO, GCDT.Total_Vaga_Funcao, ISNULL(TU.DESC_TURNO,'------') AS DESC_TURNO " 
				sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA_TURNO GCDT " 
				sql = sql & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = GCDT.Cod_Funcao "  
				sql = sql & " INNER JOIN SRH_TURNO TU ON TU.COD_TURNO = GCDT.cod_TurnoFuncao "  
				sql = sql & " where GCDT.Cod_GradeCurricularDisciplina = " & trim(intCodGradeCurricularDisciplina) 
				if mid(strNomeTurma,6,1) <> "I" then
					sql = sql & " and GCDT.cod_TurnoFuncao = " & intCodTurnoRH
				end if
				sql = sql & " Order by FC.DESC_FUNCAO " 				
				'RESPONSE.WRITE SQL
				rs.open sql, cnn
				if rs.eof = false then
				%>
					<table width = "46%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
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
						<td height="20" class="celula"><div align="center"><a href="#" onclick="ExcluirFuncao('<%=rs("codigo")%>')" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image<%=rs("Cod_GradeCurricularDisciplina")%>','','<%=session("strCaminhoRaiz")%>/images/botao_vermelho_over.gif',1)"><img alt="Clique para excluir." align="middle" src="<%=session("strCaminhoRaiz")%>/images/botao_vermelho_normal.gif" name="Image<%=rs("codigo")%>" width="26" height="26" border="0"></a></div></td>
					  </tr>
					  <%				
						rs.movenext
						wend
					%>
					  </table>
				  <%
				end if
				rs.close
	        end if %>            </td>
          	</tr>
           <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td> 
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2">			
			<% if trim(intCodGrade) <> "" then %>
			
              <table width="98%" border="1" cellspacing="0" cellpadding="0" align="center" class="tabela" >
                <tr bgcolor="#D3D3D3">
                  <td width="27%" align="center" class="celula"><strong>Disciplina</strong></td>
                  <td width="68%" align="center" class="celula"><strong>Func&atilde;o(&otilde;es) e Vagas Moduladas</strong></td>
                  <td width="5%" align="center" class="celula"><strong>Ação</strong></td>
                  </tr>
                
                <%
				
				sql = " SELECT SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina, SCA_DISCIPLINA.DESC_Disciplina "
				sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA " 
				sql = sql & " INNER JOIN SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina "
				sql = sql & " WHERE SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR = " &  intCodGrade
				sql = sql & " order by SCA_DISCIPLINA.DESC_Disciplina"
				rs.open sql, cnn		
				if not rs.eof then
				while not rs.eof 
					strClassBotaoEditar = "btn-u btn-u-gree"
					bloqBotaoEditar=""
					if strDescricaoDisciplina=rs("DESC_Disciplina") then 
						bloqBotaoEditar = "disabled"
						strClassBotaoEditar = "btn-u btn-u-default"
					end if
					%>
                    <tr onmouseover="return linhaMouseOver(this)" onmouseout="return linhaMouseOut(this)" >
						<td height="35" class="celula"><strong>&nbsp;<%=rs("DESC_Disciplina")%>&nbsp;</strong></td>
						<td align="left" class="celula">&nbsp;
						<%
						sql = " SELECT GCDF.Codigo, FC.DESC_FUNCAO, GCDF.Total_Vaga_Funcao, ISNULL(TU.DESC_TURNO,'------') AS DESC_TURNO " 
						sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA_TURNO GCDF " 
						sql = sql & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = GCDF.Cod_Funcao "  
						sql = sql & " INNER JOIN SRH_TURNO TU ON TU.COD_TURNO = GCDF.cod_TurnoFuncao "  
						sql = sql & " where GCDF.Cod_GradeCurricularDisciplina = " & rs("Cod_GradeCurricularDisciplina") 
						if mid(strNomeTurma,6,1) <> "I" then
							sql = sql & " and GCDF.cod_TurnoFuncao = " & intCodTurnoRH
						end if
						sql = sql & " and FC.TIPO_FUNCAO = 'PROFESSOR' "
						sql = sql & " Order by FC.DESC_FUNCAO " 				
						rsaux.open sql, cnn
						if rsaux.eof = false then
							while not rsaux.eof
								response.write "<strong><font color='#FF0000'><li>" & rsaux("DESC_FUNCAO") & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-> " & rsaux("Total_Vaga_Funcao") & " Vaga(s) " & rsaux("DESC_TURNO") & "</font></strong><br>&nbsp;"
								rsaux.movenext
							wend
						  end if
						  rsaux.close
						%>
                        						
                        </td>
						<td align="center" class="celula"><input <%=bloqBotaoEditar%>  type="button" name="cmdEditar" style="cursor:hand" onclick="return resultadoConsulta('<%=rs("Cod_GradeCurricularDisciplina")%>')"  value="  EDITAR  " class="<%=strClassBotaoEditar%>" ></td>
					  </tr>

                <%
					rs.movenext
				wend 
				%>

                <%
			end if			
			rs.close
		%>
              </table>
              <%end if%></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><div align="center"><span class="texto1">
              <input name="cmdModulacaoTurmas" type="button"  class="<%=strClassBotaoLimpar%>" id="cmdModulacaoTurmas" style="cursor:hand" onclick="window.location='ModulacaoTurmas_cad.asp'"   value="Voltar - Modulacao de Turmas"/>
            </span></div></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
        </table>
		</form>
                                                             
              
       	  	</div>
        </div>     
         
      </div>  
           
   
        <!--End Table Bordered-->	
       <!-- Fecha o Painel do Formulario -->    
      </div>
    <!-- Fecha o Form -->  
    </form>
    <!--/container-->		
	<script>
        function ExcluirFuncao(Codigo){
		var men = 'ATENCAO: \nA Função Modulada sera excluida, deseja continuar?';
		if (confirm(men)) {
			var acao ="EF";
			frm1.action="ModulacaoCurricular_cod.asp?acao=" + acao + "&CodigoItem=" + Codigo;
			frm1.submit();
		return true;
		}
	}

	function VoltarModulacaoTurmas(CodigoTurma){
		frm1.action = "ModulacaoTurmas_cad.asp?txtCodigo="+CodigoTurma;
		frm1.submit();
	}

	function resultadoConsulta(intCodigo){
		
		var frm1 = document.getElementById("frm1");
		frm1.txtCodGradeCurricularDisciplina.value=intCodigo;
		frm1.txtCodGradeCurricularDisciplina.value=intCodigo;
		frm1.action = "ModulacaoCurricular_cad.asp";
		frm1.submit();
	}

	function salvar(acao){

		if (frm1.cmbFuncao.value == "0") {
			alert("A Funcao deve ser informada !");
			frm1.cmbFuncao.focus();
			return false;
		}

		if (frm1.cmbTurnoRH.value == "0") {
			alert("O turno deve ser informado !");
			frm1.cmbTurnoRH.focus();
			return false;
		}
		
		if (frm1.cmbVagas.value == "0") {
			alert("A quantidade de Vagas deve ser informada !");
			frm1.cmbVagas.focus();
			return false;
		}
	
		frm1.action="ModulacaoCurricular_cod.asp?acao=" + acao;
		frm1.submit();
		return true;

	}
    </script>
<!--#include file="../jsModulo.asp"-->
</body>
</html> 