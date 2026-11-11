<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../menuModulos.asp"--> 
<script src="../../js/js_funcoes_gerais.js"></script> 
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Senso</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
		strFuncao = ""
		strPaginaTitulo 						= "Cadastro de Profissional Escolar em Sala de Aula - Dados de Docência - Registro 51"
		
		intCodEmpresa							= Trim(Request("CodEscola"))
		strTipoRegistro							= Trim(Request.Form("txtTipoRegistro"))
		intCodEscolaInep	 					= Trim(Request.Form("txtCodEscolaInep"))
		strIdentificacaoProssionalInep			= Trim(Request.Form("txtIdentificacaoProssionalInep"))
		strCodProfissionalEscola				= Trim(Request.Form("txtCodProfissionalEscola"))
		
		strCodTurmaINEP							= Trim(Request.Form("txtCodTurmaINEP"))
		strCodTurmaEntidadeEscola				= Trim(Request.Form("txtCodTurmaEntidadeEscola"))
		strFuncaoExerceEscolaTurma				= Trim(Request.Form("cmbFuncaoExerceEscolaTurma"))
		strSituacaoTipoVinculo					= Trim(Request.Form("cmbSituacaoTipoVinculo"))
		strCodDisciplina1						= Trim(Request.Form("cmbCodDisciplina1"))
		strCodDisciplina2						= Trim(Request.Form("cmbCodDisciplina2"))
		strCodDisciplina3						= Trim(Request.Form("cmbCodDisciplina3"))
		strCodDisciplina4						= Trim(Request.Form("cmbCodDisciplina4"))
		strCodDisciplina5						= Trim(Request.Form("cmbCodDisciplina5"))
		strCodDisciplina6						= Trim(Request.Form("cmbCodDisciplina6"))
		strCodDisciplina7						= Trim(Request.Form("cmbCodDisciplina7"))
		strCodDisciplina8						= Trim(Request.Form("cmbCodDisciplina8"))
		strCodDisciplina9						= Trim(Request.Form("cmbCodDisciplina9"))
		strCodDisciplina10						= Trim(Request.Form("cmbCodDisciplina10"))
		strCodDisciplina11						= Trim(Request.Form("cmbCodDisciplina11"))
		strCodDisciplina12						= Trim(Request.Form("cmbCodDisciplina12"))
		strCodDisciplina13						= Trim(Request.Form("cmbCodDisciplina13"))
		
		if trim(intCodEmpresa) <> "" then
			 
			sql = "SELECT CodEmpresa, TipoRegistro, CodEscolaInep, IdentificacaoProssionalInep, CodProfissionalEscola, "
			sql = sql & " CodTurmaINEP, CodTurmaEntidadeEscola, FuncaoExerceEscolaTurma, SituacaoTipoVinculo,  "
			sql = sql & " CodDisciplina1, CodDisciplina2, CodDisciplina3, CodDisciplina4, CodDisciplina5, "
			sql = sql & " CodDisciplina6, CodDisciplina7, CodDisciplina8, CodDisciplina9, CodDisciplina10, "
			sql = sql & " CodDisciplina11, CodDisciplina12, CodDisciplina13 "
			sql = sql & " FROM REGISTRO51"
			sql = sql & " WHERE CodEmpresa = " & intCodEmpresa
			rs.open sql, cnn
		
			if rs.eof = false then
			
				intCodEmpresa							= rs("CodEmpresa")
				strTipoRegistro							= rs("TipoRegistro")
				intCodEscolaInep	 					= rs("CodEscolaInep")
				strIdentificacaoProssionalInep			= rs("IdentificacaoProssionalInep")
				strCodProfissionalEscola				= rs("CodProfissionalEscola")
				
				strCodTurmaINEP							= rs("CodTurmaINEP")
				strCodTurmaEntidadeEscola				= rs("CodTurmaEntidadeEscola")
				strFuncaoExerceEscolaTurma				= rs("FuncaoExerceEscolaTurma")
				strSituacaoTipoVinculo					= rs("SituacaoTipoVinculo")
				strCodDisciplina1						= rs("CodDisciplina1")
				strCodDisciplina2						= rs("CodDisciplina2")
				strCodDisciplina3						= rs("CodDisciplina3")
				strCodDisciplina4						= rs("CodDisciplina4")
				strCodDisciplina5						= rs("CodDisciplina5")
				strCodDisciplina6						= rs("CodDisciplina6")
				strCodDisciplina7						= rs("CodDisciplina7")
				strCodDisciplina8						= rs("CodDisciplina8")
				strCodDisciplina9						= rs("CodDisciplina9")
				strCodDisciplina10						= rs("CodDisciplina10")
				strCodDisciplina11						= rs("CodDisciplina11")
				strCodDisciplina12						= rs("CodDisciplina12")
				strCodDisciplina13						= rs("CodDisciplina13")
	
				strDesabilitaIncluir		= "" 'Desabilita o botão Incluir
				strDesabilitaAlterar 		= "disabled" 'Desabilita o botão Excluir
				strDesabilitaExcluir		= "disabled" 'Desabilita o botão Excluir
				
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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Profissional Escolar em Sala de Aula - Dados de Docência - Registro 51</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                    <table width="98%" border="0" cellpadding="0" cellspacing="0">
                    <tr valign="top">
                    <td width="98%" align="center" class="tituloSistema"><%=strPaginaTitulo%></td>
                    </tr>
                    </table>
                    <br>
                    <table width="98%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                    <td height="25" class="texto1">Empresa:</td>
                    <td><input style="width:100pt" name="txtCodEmpresa" type="text" class="form-control"  id="txtCodEmpresa" size="8" maxlength="8" value="<%=trim(intCodEmpresa)%>"></td>
                    </tr>
                    <tr>
                    <td width="424" height="25" class="texto1">Tipo de Registro</td>
                    <td width="857"><input style="width:100pt" name="txtTipoRegistro" type="text" class="form-control"  id="txtTipoRegistro" size="2" maxlength="5" value="<%=trim(strTipoRegistro)%>">            </td>
                    </tr>
                    <tr>
                    <td height="25" class="texto1">C&oacute;digo da Escola - INEP</td>
                    <td><input style="width:100pt" name="txtCodEscolaInep" type="text" class="form-control"  id="txtCodEscolaInep" size="8" maxlength="8" value="<%=trim(intCodEscolaInep)%>"></td>
                    </tr>
                    <tr>
                    <td height="25" class="texto1">              Indentifica&ccedil;&atilde;o &uacute;nica (INEP)</td>
                    <td><input style="width:100pt" name="txtIdentificacaoProssionalInep" type="text" class="form-control"  id="txtIdentificacaoProssionalInep" size="8" maxlength="8" value="<%=trim(strIdentificacaoProssionalInep)%>"></td>
                    </tr>
                    <tr>
                    <td height="25" class="texto1">C&oacute;digo do Profissional escolar em Sala de Aula na Entidade/Escola</td>
                    <td><input style="width:100pt" name="txtCodProfissionalEscola" type="text" class="form-control"  id="txtCodProfissionalEscola" size="8" maxlength="8" value="<%=trim(strCodProfissionalEscola)%>"></td>
                    </tr>
                    <tr>
                    <td height="25" class="texto1">Codigo da Turma no INEP</td>
                    <td><input style="width:100pt" name="txtCodTurmaINEP" type="text" class="form-control"  id="txtCodTurmaINEP" size="8" maxlength="8" value="<%=trim(strCodTurmaINEP)%>"></td>
                    </tr>
                    <tr>
                    <td height="25" class="texto1">C&oacute;digo da Turma na Entidade/escola</td>
                    <td><input style="width:100pt" name="txtCodTurmaEntidadeEscola" type="text" class="form-control"  id="txtCodTurmaEntidadeEscola" size="8" maxlength="8" value="<%=trim(strCodTurmaEntidadeEscola)%>"></td>
                    </tr>
                    <tr>
                    <td height="25" class="texto1"> Fun&ccedil;&atilde;o que exerce na escola/Turma</td>
                    <td><select name="cmbFuncaoExerceEscolaTurma" id="cmbFuncaoExerceEscolaTurma" class="form-control" style="width:100pt" >
                    <option value="0">Selecione...</option>
                    <option <%if strFuncaoExerceEscolaTurma = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                    <option <%if strFuncaoExerceEscolaTurma = "1" then%> selected <%end if%> value="1">Sim</option>
                    </select></td>
                    </tr>
                    <tr>
                    <td height="25" class="texto1">Situa&ccedil;&atilde;o Funcional/Regime de contrata&ccedil;&atilde;o/Tipo de Vinculo</td>
                    <td><select name="cmbSituacaoTipoVinculo" id="cmbSituacaoTipoVinculo" class="form-control" style="width:100pt" >
                    <option value="0">Selecione...</option>
                    <option <%if strSituacaoTipoVinculo = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                    <option <%if strSituacaoTipoVinculo = "1" then%> selected <%end if%> value="1">Sim</option>
                    </select></td>
                    </tr>
                    <tr>
                    <td height="25" class="texto1"> C&oacute;digo da Disciplina 1 (*)</td>
                    <td><select name="cmbCodDisciplina1" id="cmbCodDisciplina1" class="form-control" style="width:100pt" >
                    <option value="0">Selecione...</option>
                    <option <%if strCodDisciplina1 = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                    <option <%if strCodDisciplina1 = "1" then%> selected <%end if%> value="1">Sim</option>
                    </select></td>
                    </tr>
                    <tr>
                    <td height="25" class="texto1">C&oacute;digo da Disciplina 2 (*)</td>
                    <td><select name="cmbCodDisciplina2" id="cmbCodDisciplina2" class="form-control" style="width:100pt" > 
                    <option value="0">Selecione...</option>
                    <option <%if strCodDisciplina2 = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                    <option <%if strCodDisciplina2 = "1" then%> selected <%end if%> value="1">Sim</option>
                    </select></td>
                    </tr>
                    <tr>
                    <td height="25" class="texto1">C&oacute;digo da Disciplina 3 (*)</td>
                    <td><select name="cmbCodDisciplina3" id="cmbCodDisciplina3" class="form-control" style="width:100pt" >
                    <option value="0">Selecione...</option>
                    <option <%if strCodDisciplina3 = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                    <option <%if strCodDisciplina4 = "1" then%> selected <%end if%> value="1">Sim</option>
                    </select></td>
                    </tr>
                    <tr>
                    <td height="25" class="texto1">C&oacute;digo da Disciplina 4 (*)</td>
                    <td><select name="cmbCodDisciplina4" id="cmbCodDisciplina4" class="form-control" style="width:100pt" >
                    <option value="0">Selecione...</option>
                    <option <%if strCodDisciplina4 = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                    <option <%if strCodDisciplina4 = "1" then%> selected <%end if%> value="1">Sim</option>
                    </select></td>
                    </tr>
                    <tr>
                    <td height="25" class="texto1">C&oacute;digo da Disciplina 5 (*)</td>
                    <td><select name="cmbCodDisciplina5" id="cmbCodDisciplina5" class="form-control" style="width:100pt" >
                    <option value="0">Selecione...</option>
                    <option <%if strCodDisciplina5 = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                    <option <%if strCodDisciplina5 = "1" then%> selected <%end if%> value="1">Sim</option>
                    </select></td>
                    </tr>
                    <tr>
                    <td height="25" class="texto1">C&oacute;digo da Disciplina 6 (*)</td>
                    <td><select name="cmbCodDisciplina6" id="cmbCodDisciplina6" class="form-control" style="width:100pt" >
                    <option value="0">Selecione...</option>
                    <option <%if strCodDisciplina6 = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                    <option <%if strCodDisciplina6 = "1" then%> selected <%end if%> value="1">Sim</option>
                    </select></td>
                    </tr>
                    <tr>
                    <td height="25" class="texto1">C&oacute;digo da Disciplina 7 (*)</td>
                    <td><select name="cmbCodDisciplina7" id="cmbCodDisciplina7" class="form-control" style="width:100pt" >
                    <option value="0">Selecione...</option>
                    <option <%if strCodDisciplina7 = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                    <option <%if strCodDisciplina7 = "1" then%> selected <%end if%> value="1">Sim</option>
                    </select></td>
                    </tr>
                    <tr>
                    <td height="25" class="texto1">C&oacute;digo da Disciplina 8 (*)</td>
                    <td><select name="cmbCodDisciplina8" id="cmbCodDisciplina8" class="form-control" style="width:100pt" >
                    <option value="0">Selecione...</option>
                    <option <%if strCodDisciplina8 = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                    <option <%if strCodDisciplina8 = "1" then%> selected <%end if%> value="1">Sim</option>
                    </select></td>
                    </tr>
                    <tr>
                    <td height="25" class="texto1">C&oacute;digo da Disciplina 9 (*)</td>
                    <td><select name="cmbCodDisciplina9" id="cmbCodDisciplina9" class="form-control" style="width:100pt" >
                    <option value="0">Selecione...</option>
                    <option <%if strCodDisciplina9 = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                    <option <%if strCodDisciplina9 = "1" then%> selected <%end if%> value="1">Sim</option>
                    </select></td>
                    </tr>
                    <tr>
                    <td height="25" class="texto1">C&oacute;digo da Disciplina 10 (*)</td>
                    <td><select name="cmbCodDisciplina10" id="cmbCodDisciplina10" class="form-control" style="width:100pt" >
                    <option value="0">Selecione...</option>
                    <option <%if strCodDisciplina10 = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                    <option <%if strCodDisciplina10 = "1" then%> selected <%end if%> value="1">Sim</option>
                    </select></td>
                    </tr>
                    <tr>
                    <td height="25" class="texto1">C&oacute;digo da Disciplina 11 (*)</td>
                    <td><select name="cmbCodDisciplina11" id="cmbCodDisciplina11" class="form-control" style="width:100pt" >
                    <option value="0">Selecione...</option>
                    <option <%if strCodDisciplina11 = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                    <option <%if strCodDisciplina11 = "1" then%> selected <%end if%> value="1">Sim</option>
                    </select></td>
                    </tr>
                    <tr>
                    <td height="25" class="texto1">C&oacute;digo da Disciplina 12 (*)</td>
                    <td><select name="cmbCodDisciplina12" id="cmbCodDisciplina12" class="form-control" style="width:100pt" >
                    <option value="0">Selecione...</option>
                    <option <%if strCodDisciplina12 = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                    <option <%if strCodDisciplina12 = "1" then%> selected <%end if%> value="1">Sim</option>
                    </select></td>
                    </tr>
                    <tr>
                    <td height="25" class="texto1">C&oacute;digo da Disciplina 13 (*)</td>
                    <td><select name="cmbCodDisciplina13" id="cmbCodDisciplina13" class="form-control" style="width:100pt" >
                    <option value="0">Selecione...</option>
                    <option <%if strCodDisciplina1 = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
                    <option <%if strCodDisciplina1 = "1" then%> selected <%end if%> value="1">Sim</option>
                    </select></td>
                    </tr>
                    <tr>
                    <td colspan="2" bgcolor="#CCCCCC" class="texto1">&nbsp;</td>
                    </tr>
                    <tr>
                    <td colspan="2" class="texto1">&nbsp;</td>
                    </tr>
                    <tr>
                    <td colspan="2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
                    </tr>
                    </table>
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
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
		frm.action="Registro51_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 