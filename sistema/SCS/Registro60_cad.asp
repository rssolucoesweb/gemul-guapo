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
	strPaginaTitulo 						= "Cadastro de Aluno - Indentifica&ccedil;&atilde;o - Regsitro 60"
	
	intCodEmpresa							= Trim(Request("CodEscola"))
	strTipoRegistro							= Trim(Request.Form("txtTipoRegistro"))
	intCodEscolaInep	 					= Trim(Request.Form("txtCodEscolaInep"))
	strIdentificacaoUnicaAlunoInep			= Trim(Request.Form("txtIdentificacaoUnicaAlunoInep"))
	strCodAlunoEntidadeEscola				= Trim(Request.Form("txtCodAlunoEntidadeEscola"))
	strNomeCompleto							= Trim(Request.Form("txtNomeCompleto"))
	strNumeroIndenticacaoSocialNIS			= Trim(Request.Form("txtNumeroIndenticacaoSocialNIS"))
	strDataNascimento						= Trim(Request.Form("txtDataNascimento"))
	strSexo									= Trim(Request.Form("cmbSexo"))
	strCorRoca								= Trim(Request.Form("cmbCorRoca"))
	strFiliacao								= Trim(Request.Form("txtFiliacao"))
	strNomeMae								= Trim(Request.Form("txtNomeMae"))
	strNomePai								= Trim(Request.Form("txtNomePai"))
	strNacionalidadeAluno					= Trim(Request.Form("txtNacionalidadeAluno"))
	strPaisOrigem							= Trim(Request.Form("txtPaisOrigem"))
	strUFNascimento							= Trim(Request.Form("txtUFNascimento"))
	strMunicipioNascimento					= Trim(Request.Form("txtMunicipioNascimento"))
	
	strSuperdotacao							= Trim(Request.Form("cmbSuperdotacao"))
	strCegueira								= Trim(Request.Form("cmbCegueira"))
	strBaixaVisao							= Trim(Request.Form("cmbBaixaVisao"))
	strSupedotacaoSurdez					= Trim(Request.Form("cmbSupedotacaoSurdez"))
	strDeficienciaAuditiva					= Trim(Request.Form("cmbDeficienciaAuditiva"))
	strSurdocegueira						= Trim(Request.Form("cmbSurdocegueira"))
	strDeficienciaFisica					= Trim(Request.Form("cmbDeficienciaFisica"))
	strDeficienciaIntelectual				= Trim(Request.Form("cmbDeficienciaIntelectual"))
	strDeficienciaMultipla					= Trim(Request.Form("cmbDeficienciaMultipla"))
	strAutismoInfantil						= Trim(Request.Form("cmbAutismoInfantil"))
	strSindromeAsperger						= Trim(Request.Form("cmbSindromeAsperger"))
	strSindromeRett							= Trim(Request.Form("cmbSindromeRett"))
	strTranstornoInfacia					= Trim(Request.Form("cmbTranstornoInfacia"))
	strAltashabilidadesSuperdotacao			= Trim(Request.Form("cmbAltashabilidadesSuperdotacao"))
	
	strAuxilioLedor							= Trim(Request.Form("cmbAuxilioLedor"))
	strAuxilioTranscricao					= Trim(Request.Form("cmbAuxilioTranscricao"))
	strGuiaInterprete						= Trim(Request.Form("cmbGuiaInterprete"))
	strInterpreteLibras						= Trim(Request.Form("cmbInterpreteLibras"))
	strLeituraLabial						= Trim(Request.Form("cmbLeituraLabial"))
	strProvaAmpliadaTamanho16				= Trim(Request.Form("cmbProvaAmpliadaTamanho16"))
	strProvaAmpliadaTamanho20				= Trim(Request.Form("cmbProvaAmpliadaTamanho20"))
	strProvaAmpliadaTamanho24				= Trim(Request.Form("cmbProvaAmpliadaTamanho24"))
	strProvaBraille							= Trim(Request.Form("cmbProvaBraille"))
	strNenhum								= Trim(Request.Form("cmbNenhum"))
	
	
	if trim(intCodEmpresa) <> "" then
	
	
	
		sql = "SELECT CodEmpresa, TipoRegistro, CodEscolaInep, IdentificacaoUnicaAlunoInep, CodAlunoEntidadeEscola, "
		sql = sql & " NomeCompleto, NumeroIndenticacaoSocialNIS, DataNascimento, Sexo, CorRoca, Filiacao,    "
		sql = sql & " NomeMae, NomePai, NacionalidadeAluno, PaisOrigem, UFNascimento, MunicipioNascimento, "
		sql = sql & " Superdotacao, Cegueira, BaixaVisao, SupedotacaoSurdez, DeficienciaAuditiva, "
		sql = sql & " Surdocegueira, DeficienciaFisica, DeficienciaIntelectual, DeficienciaMultipla, "
		sql = sql & " AutismoInfantil, SindromeAsperger, SindromeRett, TranstornoInfacia, AltashabilidadesSuperdotacao, "
		sql = sql & " AuxilioLedor, AuxilioTranscricao, GuiaInterprete,  "
		sql = sql & " InterpreteLibras, LeituraLabial, ProvaAmpliadaTamanho16,  "
		sql = sql & " ProvaAmpliadaTamanho20, ProvaAmpliadaTamanho24, ProvaBraille,  Nenhum"
		sql = sql & " FROM REGISTRO60"
		sql = sql & " WHERE CodEmpresa = " & intCodEmpresa
		rs.open sql, cnn
	
		if rs.eof = false then
		
			intCodEmpresa							= rs("CodEmpresa")
			strTipoRegistro							= rs("TipoRegistro")
			intCodEscolaInep	 					= rs("CodEscolaInep")
			strIdentificacaoUnicaAlunoInep			= rs("IdentificacaoUnicaAlunoInep")
			strCodAlunoEntidadeEscola				= rs("CodAlunoEntidadeEscola")
			
			strNomeCompleto							= rs("NomeCompleto")
			strNumeroIndenticacaoSocialNIS			= rs("NumeroIndenticacaoSocialNIS")
			strDataNascimento						= rs("DataNascimento")
			strSexo									= rs("Sexo")
			strCorRoca								= rs("CorRoca")
			strFiliacao								= rs("Filiacao")
			strNomeMae								= rs("NomeMae")
			strNomePai								= rs("NomePai")
			strNacionalidadeAluno					= rs("NacionalidadeAluno")
			strPaisOrigem							= rs("PaisOrigem")
			strUFNascimento							= rs("UFNascimento")
			strMunicipioNascimento					= rs("MunicipioNascimento")
			
			strSuperdotacao							= rs("Superdotacao")
			strCegueira								= rs("Cegueira")
			strBaixaVisao							= rs("BaixaVisao")
			strSupedotacaoSurdez					= rs("SupedotacaoSurdez")
			strDeficienciaAuditiva					= rs("DeficienciaAuditiva")
			strSurdocegueira						= rs("Surdocegueira")
			strDeficienciaFisica					= rs("DeficienciaFisica")
			strDeficienciaIntelectual				= rs("DeficienciaIntelectual")
			strDeficienciaMultipla					= rs("DeficienciaMultipla")
			strAutismoInfantil						= rs("AutismoInfantil")
			strSindromeAsperger						= rs("SindromeAsperger")
			strSindromeRett							= rs("SindromeRett")
			strTranstornoInfacia					= rs("TranstornoInfacia")
			strAltashabilidadesSuperdotacao			= rs("AltashabilidadesSuperdotacao")
			
			strAuxilioLedor							= rs("AuxilioLedor")
			strAuxilioTranscricao					= rs("AuxilioTranscricao")
			strGuiaInterprete						= rs("GuiaInterprete")
			strInterpreteLibras						= rs("InterpreteLibras")
			strLeituraLabial						= rs("LeituraLabial")
			strProvaAmpliadaTamanho16				= rs("ProvaAmpliadaTamanho16")
			strProvaAmpliadaTamanho20				= rs("ProvaAmpliadaTamanho20")
			strProvaAmpliadaTamanho24				= rs("ProvaAmpliadaTamanho24")
			strProvaBraille							= rs("ProvaBraille")
			strNenhum								= rs("Nenhum")
	

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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Aluno - Indentifica&ccedil;&atilde;o - Regsitro 60</h3>
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
            <td><input style="width:100pt" name="txtCodEmpresa" type="text" class="form-control" id="txtCodEmpresa" size="8" maxlength="8" value="<%=trim(intCodEmpresa)%>"></td>
          </tr>
          <tr>
            <td width="424" height="25" class="texto1">Tipo de Registro</td>
            <td width="857"><input style="width:100pt" name="txtTipoRegistro" type="text" class="form-control" id="txtTipoRegistro" size="2" maxlength="5" value="<%=trim(strTipoRegistro)%>">            </td>
          </tr>
          <tr>
            <td height="25" class="texto1">C&oacute;digo da Escola - Inep</td>
            <td><input style="width:100pt" name="txtCodEscolaInep" type="text" class="form-control" id="txtCodEscolaInep" size="8" maxlength="8" value="<%=trim(intCodEscolaInep)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Identifica&ccedil;&atilde;o &uacute;nica do aluno (Inep)</td>
            <td><input style="width:100pt" name="txtIdentificacaoUnicaAlunoInep" type="text" class="form-control" id="txtIdentificacaoUnicaAlunoInep" size="8" maxlength="8" value="<%=trim(strIdentificacaoUnicaAlunoInep)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">C&oacute;digo do aluno na Entidade/Escola</td>
            <td><input style="width:100pt" name="txtCodAlunoEntidadeEscola" type="text" class="form-control" id="txtCodAlunoEntidadeEscola" size="8" maxlength="8" value="<%=trim(strCodAlunoEntidadeEscola)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Nome Completo</td>
            <td><input style="width:100pt" name="txtNomeCompleto" type="text" class="form-control" id="txtNomeCompleto" size="8" maxlength="8" value="<%=trim(strNomeCompleto)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">N&uacute;mero de Indentifica&ccedil;&atilde;o Social (NIS)</td>
            <td><input style="width:100pt" name="txtNumeroIndenticacaoSocialNIS" type="text" class="form-control" id="txtNumeroIndenticacaoSocialNIS" size="8" maxlength="8" value="<%=trim(strNumeroIndenticacaoSocialNIS)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Data de Nascimento</td>
            <td><input style="width:100pt" name="txtDataNascimento" type="text" class="form-control" id="txtDataNascimento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="8" maxlength="10" value="<%=trim(strDataNascimento)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Sexo</td>
            <td><select name="cmbSexo" id="cmbSexo" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strSexo = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strSexo = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Cor/Ro&ccedil;a</td>
            <td><select name="cmbCorRoca" id="cmbCorRoca" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strCorRoca = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strCorRoca = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Filia&ccedil;&atilde;o</td>
            <td><input style="width:100pt" name="txtFiliacao" type="text" class="form-control" id="txtFiliacao" size="8" maxlength="8" value="<%=trim(strFiliacao)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Nome da M&atilde;e</td>
            <td><input style="width:100pt" name="txtNomeMae" type="text" class="form-control" id="txtNomeMae" size="8" maxlength="8" value="<%=trim(strNomeMae)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Nome do pai</td>
            <td><input style="width:100pt" name="txtNomePai" type="text" class="form-control" id="txtNomePai" size="8" maxlength="8" value="<%=trim(strNomePai)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Nacionalidade do aluno</td>
            <td><input style="width:100pt" name="txtNacionalidadeAluno" type="text" class="form-control" id="txtNacionalidadeAluno" size="8" maxlength="8" value="<%=trim(strNacionalidadeAluno)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Pa&iacute;s de Origem (*)</td>
            <td><input style="width:100pt" name="txtPaisOrigem" type="text" class="form-control" id="txtPaisOrigem" size="8" maxlength="8" value="<%=trim(strPaisOrigem)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">UF de nascimento (*)</td>
            <td><input style="width:100pt" name="txtUFNascimento" type="text" class="form-control" id="txtUFNascimento" size="8" maxlength="8" value="<%=trim(strUFNascimento)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Munic&iacute;pio de Nascimento (*)</td>
            <td><input style="width:100pt" name="txtMunicipioNascimento" type="text" class="form-control" id="txtMunicipioNascimento" size="8" maxlength="8" value="<%=trim(strMunicipioNascimento)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Aluno com defici&ecirc;ncia, transtorno global do desenvolvimento ou altas habilidades/superdota&ccedil;&atilde;o</td>
            <td><select name="cmbSuperdotacao" id="cmbSuperdotacao" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strSuperdotacao = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strSuperdotacao = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Tipos de defici&ecirc;ncia, transtorno global do desenvolvimento ou altas habilidades/superdota&ccedil;&atilde;o - Cegueira</td>
            <td><select name="cmbCegueira" id="cmbCegueira" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strCegueira = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strCegueira = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Tipos de defici&ecirc;ncia, transtorno global do desenvolvimento ou altas habilidades/superdota&ccedil;&atilde;o - Baixa vis&atilde;o</td>
            <td><select name="cmbBaixaVisao" id="cmbBaixaVisao" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strBaixaVisao = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strBaixaVisao = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Tipos de defici&ecirc;ncia, transtorno global do desenvolvimento ou altas habilidades/superdota&ccedil;&atilde;o - Surdez</td>
            <td><select name="cmbSupedotacaoSurdez" id="cmbSupedotacaoSurdez" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strSupedotacaoSurdez = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strSupedotacaoSurdez = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Tipos de defici&ecirc;ncia, transtorno global do desenvolvimento ou altas habilidades/superdota&ccedil;&atilde;o - Defici&ecirc;ncia auditiva</td>
            <td><select name="cmbDeficienciaAuditiva" id="cmbDeficienciaAuditiva" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDeficienciaAuditiva = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDeficienciaAuditiva = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Tipos de defici&ecirc;ncia, transtorno global do desenvolvimento ou altas habilidades/superdota&ccedil;&atilde;o - Surdocegueira</td>
            <td><select name="cmbSurdocegueira" id="cmbSurdocegueira" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strSurdocegueira = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strSurdocegueira = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Tipos de defici&ecirc;ncia, transtorno global do desenvolvimento ou altas habilidades/superdota&ccedil;&atilde;o - Defici&ecirc;ncia F&iacute;sica</td>
            <td><select name="cmbDeficienciaFisica" id="cmbDeficienciaFisica" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDeficienciaFisica = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDeficienciaFisica = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Tipos de defici&ecirc;ncia, transtorno global do desenvolvimento ou altas habilidades/superdota&ccedil;&atilde;o - Defici&ecirc;ncia Intelectual</td>
            <td><select name="cmbDeficienciaIntelectual" id="cmbDeficienciaIntelectual" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDeficienciaIntelectual = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDeficienciaIntelectual = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Tipos de defici&ecirc;ncia, transtorno global do desenvolvimento ou altas habilidades/superdota&ccedil;&atilde;o - Defici&ecirc;ncia M&uacute;ltipla</td>
            <td><select name="cmbDeficienciaMultipla" id="cmbDeficienciaMultipla" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDeficienciaMultipla = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDeficienciaMultipla = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Tipos de defici&ecirc;ncia, transtorno global do desenvolvimento ou altas habilidades/superdota&ccedil;&atilde;o - Autismo Infantil </td>
            <td><select name="cmbAutismoInfantil" id="cmbAutismoInfantil" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strAutismoInfantil = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strAutismoInfantil = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Tipos de defici&ecirc;ncia, transtorno global do desenvolvimento ou altas habilidades/superdota&ccedil;&atilde;o - S&iacute;ndrome de Asperger</td>
            <td><select name="cmbSindromeAsperger" id="cmbSindromeAsperger" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strSindromeAsperger = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strSindromeAsperger = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Tipos de defici&ecirc;ncia, transtorno global do desenvolvimento ou altas habilidades/superdota&ccedil;&atilde;o - S&iacute;ndrome Rett</td>
            <td><select name="cmbSindromeRett" id="cmbSindromeRett" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strSindromeRett = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strSindromeRett = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Tipos de defici&ecirc;ncia, transtorno global do desenvolvimento ou altas habilidades/superdota&ccedil;&atilde;o - Transtorno desintegrativo da inf&acirc;ncia</td>
            <td><select name="cmbTranstornoInfacia" id="cmbTranstornoInfacia" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strTranstornoInfacia = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strTranstornoInfacia = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Tipos de defici&ecirc;ncia, transtorno global do desenvolvimento ou altas habilidades/superdota&ccedil;&atilde;o - Altas habilidades/Superdota&ccedil;&atilde;o</td>
            <td><select name="cmbAltashabilidadesSuperdotacao" id="cmbAltashabilidadesSuperdotacao" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strAltashabilidadesSuperdotacao = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strAltashabilidadesSuperdotacao = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Aux&iacute;lio ledor</td>
            <td><select name="cmbAuxilioLedor" id="cmbAuxilioLedor" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strAuxilioLedor = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strAuxilioLedor = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Aux&iacute;lio Transcri&ccedil;&atilde;o</td>
            <td><select name="cmbAuxilioTranscricao" id="cmbAuxilioTranscricao" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strAuxilioTranscricao = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strAuxilioTranscricao = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Guia-Int&eacute;rprete</td>
            <td><select name="cmbGuiaInterprete" id="cmbGuiaInterprete" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strGuiaInterprete = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strGuiaInterprete = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Int&eacute;rprete de Libras</td>
            <td><select name="cmbInterpreteLibras" id="cmbInterpreteLibras" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strInterpreteLibras = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strInterpreteLibras = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Leitura labial</td>
            <td><select name="cmbLeituraLabial" id="cmbLeituraLabial" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strLeituraLabial = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strLeituraLabial = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Prova Ampliada (Fonte Tamanho 16)</td>
            <td><select name="cmbProvaAmpliadaTamanho16" id="cmbProvaAmpliadaTamanho16" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strProvaAmpliadaTamanho16 = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strProvaAmpliadaTamanho16 = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Prova Ampliada (Fonte Tamanho 20)</td>
            <td><select name="cmbProvaAmpliadaTamanho20" id="cmbProvaAmpliadaTamanho20" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strProvaAmpliadaTamanho20 = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strProvaAmpliadaTamanho20 = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Prova Ampliada (Fonte Tamanho 24)</td>
            <td><select name="cmbProvaAmpliadaTamanho24" id="cmbProvaAmpliadaTamanho24" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strProvaAmpliadaTamanho24 = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strProvaAmpliadaTamanho24 = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Prova em Braille</td>
            <td><select name="cmbProvaBraille" id="cmbProvaBraille" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strProvaBraille = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strProvaBraille = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Nenhum</td>
            <td><select name="cmbNenhum" id="cmbNenhum" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strNenhum = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strNenhum = "1" then%> selected <%end if%> value="1">Sim</option>
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
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
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
		frm.action="Registro60_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 