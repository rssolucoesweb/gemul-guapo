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
	strPaginaTitulo 								= "Cadastro de Profissional Escolar em Sala de Aula - Dados Variáveris - Registro 50"
	
	intCodEmpresa									= Trim(Request("CodEscola"))
	strTipoRegistro									= Trim(Request.Form("txtTipoRegistro"))
	intCodEscolaInep	 							= Trim(Request.Form("txtCodEscolaInep"))
	strIdentificacaoProssionalInep					= Trim(Request.Form("txtIdentificacaoProssionalInep"))
	strCodProfissionalEscola						= Trim(Request.Form("txtCodProfissionalEscola"))
	strEscolaridade									= Trim(Request.Form("cmbEscolaridade"))
	strSituacaoCursoSuperior1						= Trim(Request.Form("cmbSituacaoCursoSuperior1"))
	strFormacaoComplentacaoPedagogica1				= Trim(Request.Form("cmbFormacaoComplentacaoPedagogica1"))
	strCodigoCursoSuperior1							= Trim(Request.Form("txtCodigoCursoSuperior1"))
	strAnoInicioCursoSuperior1						= Trim(Request.Form("txtAnoInicioCursoSuperior1"))
	strAnoConclusaoCursoSuperior1					= Trim(Request.Form("txtAnoConclusaoCursoSuperior1"))
	strTipoInstituicaoCursoSuperior1				= Trim(Request.Form("cmbTipoInstituicaoCursoSuperior1"))
	strInstituicaoCursoSuperior1					= Trim(Request.Form("txtInstituicaoCursoSuperior1"))
	strSituacaoCursoSuperior2						= Trim(Request.Form("cmbSituacaoCursoSuperior2"))
	strFormacaoComplementacaoPedagogica2			= Trim(Request.Form("cmbFormacaoComplementacaoPedagogica2"))
	strCodigoSuperior2								= Trim(Request.Form("txtCodigoSuperior2"))
	strAnoInicioCursoSuperior						= Trim(Request.Form("txtAnoInicioCursoSuperior"))
	strAnoConclusaoCursoSuperior2					= Trim(Request.Form("txtAnoConclusaoCursoSuperior2"))
	strTipoInstituicaoCursoSuperior2				= Trim(Request.Form("cmbTipoInstituicaoCursoSuperior2"))
	strInstituicaoCursoSuperior2					= Trim(Request.Form("txtInstituicaoCursoSuperior2"))
	strSituacaoCursoSuperior3						= Trim(Request.Form("cmbSituacaoCursoSuperior3"))
	strFormacaoComplentacaoPedagogica3				= Trim(Request.Form("cmbFormacaoComplentacaoPedagogica3"))
	strCodigoCursoSuperior3							= Trim(Request.Form("txtCodigoCursoSuperior3"))
	strAnoInicioCursoSuperior3						= Trim(Request.Form("txtAnoInicioCursoSuperior3"))
	strAnoConclusaoCursoSuperior3					= Trim(Request.Form("txtAnoConclusaoCursoSuperior3"))
	strTipoInstituicaoCursoSuperior3				= Trim(Request.Form("cmbTipoInstituicaoCursoSuperior3"))
	strInstituicaoCursoSuperior3					= Trim(Request.Form("txtInstituicaoCursoSuperior3"))
	strPosGraduacaoEspecializacao					= Trim(Request.Form("cmbPosGraduacaoEspecializacao"))
	strPosGraduacaoMestrado							= Trim(Request.Form("cmbPosGraduacaoMestrado"))
	strPosGraduacaoDoutorado						= Trim(Request.Form("cmbPosGraduacaoDoutorado"))
	strPosGraduacaoNenhum							= Trim(Request.Form("cmbPosGraduacaoNenhum"))
	strEspecializacaoCreche0a3anos					= Trim(Request.Form("cmbEspecializacaoCreche0a3anos"))
	strEspecializacaoPreEscola						= Trim(Request.Form("cmbEspecializacaoPreEscola"))
	strEspecificoParaAnoIniciaisEnsinoFundamental	= Trim(Request.Form("cmbEspecificoParaAnoIniciaisEnsinoFundamental"))
	strEspecificoFinaisEnsinoFundamental			= Trim(Request.Form("cmbEspecificoFinaisEnsinoFundamental"))
	strEspecificoEnsinoMedio						= Trim(Request.Form("cmbEspecificoEnsinoMedio"))
	strEspecificoEducacaoJovensAdultos				= Trim(Request.Form("cmbEspecificoEducacaoJovensAdultos"))
	strEspecificoEducacaoEspecial					= Trim(Request.Form("cmbEspecificoEducacaoEspecial"))
	strEspecificoEducacaoIndigena					= Trim(Request.Form("cmbEspecificoEducacaoIndigena"))
	strEspecificoEducacaoCampo						= Trim(Request.Form("cmbEspecificoEducacaoCampo"))
	strEspecificoEducacaoAmbiental					= Trim(Request.Form("cmbEspecificoEducacaoAmbiental"))
	strEspecificoEducacaoDireitosHumanos			= Trim(Request.Form("cmbEspecificoEducacaoDireitosHumanos"))
	strGeneroDiversidadeSexual						= Trim(Request.Form("cmbGeneroDiversidadeSexual"))
	strDireitosCriancasAdolescente					= Trim(Request.Form("cmbDireitosCriancasAdolescente"))
	strAfricana										= Trim(Request.Form("cmbAfricana"))
	strOutros										= Trim(Request.Form("cmbOutros"))
	strNenhum										= Trim(Request.Form("cmbNenhum"))
	
	if trim(intCodEmpresa) <> "" then
	     
		sql = "SELECT CodEmpresa, TipoRegistro, CodEscolaInep, IdentificacaoProssionalInep, CodProfissionalEscola, "
		sql = sql & " Escolaridade, SituacaoCursoSuperior1, FormacaoComplentacaoPedagogica1, CodigoCursoSuperior1, "
		sql = sql & " AnoInicioCursoSuperior1, AnoConclusaoCursoSuperior1, TipoInstituicaoCursoSuperior1, InstituicaoCursoSuperior1, "
		sql = sql & " SituacaoCursoSuperior2, FormacaoComplementacaoPedagogica2, CodigoSuperior2, AnoInicioCursoSuperior, "
		sql = sql & " AnoConclusaoCursoSuperior2, TipoInstituicaoCursoSuperior2, InstituicaoCursoSuperior2, SituacaoCursoSuperior3, "
		sql = sql & " FormacaoComplentacaoPedagogica3, CodigoCursoSuperior3, AnoInicioCursoSuperior3, AnoConclusaoCursoSuperior3, "
		sql = sql & " TipoInstituicaoCursoSuperior3, InstituicaoCursoSuperior3, PosGraduacaoEspecializacao, PosGraduacaoMestrado, "
		sql = sql & " PosGraduacaoDoutorado, PosGraduacaoNenhum, EspecializacaoCreche0a3anos, EspecializacaoPreEscola, "
		sql = sql & " EspecificoParaAnoIniciaisEnsinoFundamental, EspecificoFinaisEnsinoFundamental, EspecificoEnsinoMedio, EspecificoEducacaoJovensAdultos, "
		sql = sql & " EspecificoEducacaoEspecial, EspecificoEducacaoIndigena, EspecificoEducacaoCampo, EspecificoEducacaoAmbiental, "
		sql = sql & " EspecificoEducacaoDireitosHumanos, GeneroDiversidadeSexual, DireitosCriancasAdolescente, Africana, "
		sql = sql & " Outros, Nenhum"
		
		sql = sql & " FROM REGISTRO50"
		sql = sql & " WHERE CodEmpresa = " & intCodEmpresa
		rs.open sql, cnn
	
		if rs.eof = false then
		
			intCodEmpresa									= rs("CodEmpresa")
			strTipoRegistro									= rs("TipoRegistro")
			intCodEscolaInep	 							= rs("CodEscolaInep")
			strIdentificacaoProssionalInep					= rs("IdentificacaoProssionalInep")
			strCodProfissionalEscola						= rs("CodProfissionalEscola")
			strEscolaridade									= rs("Escolaridade")
			strSituacaoCursoSuperior1						= rs("SituacaoCursoSuperior1")
			strFormacaoComplentacaoPedagogica1				= rs("FormacaoComplentacaoPedagogica1")
			strCodigoCursoSuperior1							= rs("CodigoCursoSuperior1")
			strAnoInicioCursoSuperior1						= rs("AnoInicioCursoSuperior1")
			strAnoConclusaoCursoSuperior1					= rs("AnoConclusaoCursoSuperior1")
			strTipoInstituicaoCursoSuperior1				= rs("TipoInstituicaoCursoSuperior1")
			strInstituicaoCursoSuperior1					= rs("InstituicaoCursoSuperior1")
			strSituacaoCursoSuperior2						= rs("SituacaoCursoSuperior2")
			strFormacaoComplementacaoPedagogica2			= rs("FormacaoComplementacaoPedagogica2")
			strCodigoSuperior2								= rs("CodigoSuperior2")
			strAnoInicioCursoSuperior						= rs("AnoInicioCursoSuperior")
			strAnoConclusaoCursoSuperior2					= rs("AnoConclusaoCursoSuperior2")
			strTipoInstituicaoCursoSuperior2				= rs("TipoInstituicaoCursoSuperior2")
			strInstituicaoCursoSuperior2					= rs("InstituicaoCursoSuperior2")
			strSituacaoCursoSuperior3						= rs("SituacaoCursoSuperior3")
			strFormacaoComplentacaoPedagogica3				= rs("FormacaoComplentacaoPedagogica3")
			strCodigoCursoSuperior3							= rs("CodigoCursoSuperior3")
			strAnoInicioCursoSuperior3						= rs("AnoInicioCursoSuperior3")
			strAnoConclusaoCursoSuperior3					= rs("AnoConclusaoCursoSuperior3")
			strTipoInstituicaoCursoSuperior3				= rs("TipoInstituicaoCursoSuperior3")
			strInstituicaoCursoSuperior3					= rs("InstituicaoCursoSuperior3")
			strPosGraduacaoEspecializacao					= rs("PosGraduacaoEspecializacao")
			strPosGraduacaoMestrado							= rs("PosGraduacaoMestrado")
			strPosGraduacaoDoutorado						= rs("PosGraduacaoDoutorado")
			strPosGraduacaoNenhum							= rs("PosGraduacaoNenhum")
			strEspecializacaoCreche0a3anos					= rs("EspecializacaoCreche0a3anos")
			strEspecializacaoPreEscola						= rs("EspecializacaoPreEscola")
			strEspecificoParaAnoIniciaisEnsinoFundamental	= rs("EspecificoParaAnoIniciaisEnsinoFundamental")
			strEspecificoFinaisEnsinoFundamental			= rs("EspecificoFinaisEnsinoFundamental")
			strEspecificoEnsinoMedio						= rs("EspecificoEnsinoMedio")
			strEspecificoEducacaoJovensAdultos				= rs("EspecificoEducacaoJovensAdultos")
			strEspecificoEducacaoEspecial					= rs("EspecificoEducacaoEspecial")
			strEspecificoEducacaoIndigena					= rs("EspecificoEducacaoIndigena")
			strEspecificoEducacaoCampo						= rs("EspecificoEducacaoCampo")
			strEspecificoEducacaoAmbiental					= rs("EspecificoEducacaoAmbiental")
			strEspecificoEducacaoDireitosHumanos			= rs("EspecificoEducacaoDireitosHumanos")
			strGeneroDiversidadeSexual						= rs("GeneroDiversidadeSexual")
			strDireitosCriancasAdolescente					= rs("DireitosCriancasAdolescente")
			strAfricana										= rs("Africana")
			strOutros										= rs("Outros")
			strNenhum										= rs("Nenhum")

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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Profissional Escolar em Sala de Aula - Dados Variáveris - Registro 50</h3>
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
            <td height="25" class="texto1">C&oacute;digo da Escola - INEP</td>
            <td><input style="width:100pt" name="txtCodEscolaInep" type="text" class="form-control" id="txtCodEscolaInep" size="8" maxlength="8" value="<%=trim(intCodEscolaInep)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">              Indentifica&ccedil;&atilde;o &Uacute;nica do Profissional escolar em sala de Aula (INEP)</td>
            <td><input style="width:100pt" name="txtIdentificacaoProssionalInep" type="text" class="form-control" id="txtIdentificacaoProssionalInep" size="8" maxlength="8" value="<%=trim(strIdentificacaoProssionalInep)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">C&oacute;digo do Profissional escolar em sala de Aula na Entidade/Escola</td>
            <td><input style="width:100pt" name="txtCodProfissionalEscola" type="text" class="form-control" id="txtCodProfissionalEscola" size="8" maxlength="8" value="<%=trim(strCodProfissionalEscola)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Escolaridade</td>
            <td><select name="cmbEscolaridade" id="cmbEscolaridade" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEscolaridade = "1" then%> selected <%end if%> value="1">1 - Fundamental Incompleto</option>
              <option <%if strEscolaridade = "2" then%> selected <%end if%> value="2">2 - Fundamental Completo</option>
              <option <%if strEscolaridade = "3" then%> selected <%end if%> value="3">3 - Ensino Médio - Normal/Magistério</option>
              <option <%if strEscolaridade = "4" then%> selected <%end if%> value="4">4 - Ensino Médio - Normal/Magistério Indígena</option>
              <option <%if strEscolaridade = "5" then%> selected <%end if%> value="5">5 - Ensino Médio</option>
              <option <%if strEscolaridade = "6" then%> selected <%end if%> value="6">6 - Superior</option>
            </select>
            </td>
          </tr>
          <tr>
            <td height="25" class="texto1">Situa&ccedil;&atilde;o do Curso Superior 1</td>
            <td><select name="cmbSituacaoCursoSuperior1" id="cmbSituacaoCursoSuperior1" class="form-control" style="width:100pt" > 
              <option value="0">Selecione...</option>
              <option <%if strSituacaoCursoSuperior1 = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strSituacaoCursoSuperior1 = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Forma&ccedil;&atilde;o/Complementa&ccedil;&atilde;o pedag&oacute;gica 1</td>
            <td><select name="cmbFormacaoComplentacaoPedagogica1" id="cmbSexo3" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strFormacaoComplentacaoPedagogica1 = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strFormacaoComplentacaoPedagogica1 = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">C&oacute;digo do Curso Superior 1</td>
            <td><input style="width:100pt" name="txtCodigoCursoSuperior1" type="text" class="form-control" id="txtCodigoCursoSuperior1" size="8" maxlength="8" value="<%=trim(strCodigoCursoSuperior1)%>"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Ano de In&iacute;cio do curso Superior 1</td>
            <td><input style="width:100pt" name="txtAnoInicioCursoSuperior1" type="text" class="form-control" id="txtAnoInicioCursoSuperior1" size="8" maxlength="8" value="<%=trim(strAnoInicioCursoSuperior1)%>" /></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Ano de Conclus&atilde;o do Curso Superior 1</td>
            <td><input style="width:100pt" name="txtAnoConclusaoCursoSuperior1" type="text" class="form-control" id="txtAnoConclusaoCursoSuperior1" size="50" maxlength="50" value="<%=trim(strAnoConclusaoCursoSuperior1)%>" /></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Tipo de Institui&ccedil;&atilde;o do Curso Superior 1</td>
            <td><select name="cmbTipoInstituicaoCursoSuperior1" id="cmbTipoInstituicaoCursoSuperior1" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strTipoInstituicaoCursoSuperior1 = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strTipoInstituicaoCursoSuperior1 = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Institui&ccedil;&atilde;o do Curso Superior 1 </td>
            <td><input style="width:100pt" name="txtInstituicaoCursoSuperior1" type="text" class="form-control" id="txtInstituicaoCursoSuperior1" size="8" maxlength="8" value="<%=trim(strInstituicaoCursoSuperior1)%>" /></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Situa&ccedil;&atilde;o do Curso Superior 2</td>
            <td><select name="cmbSituacaoCursoSuperior2" id="cmbSituacaoCursoSuperior2" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strSituacaoCrusoSuperior2 = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strSituacaoCrusoSuperior2 = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Forma&ccedil;&atilde;o/Complemeta&ccedil;&atilde;o Pedag&oacute;gica 2</td>
            <td><select name="cmbFormacaoComplementacaoPedagogica2" id="cmbFormacaoComplementacaoPedagogica2" class="form-control" style="width:100pt" > 
              <option value="0">Selecione...</option>
              <option <%if strFormacaoComplementacaoPedagogica2 = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strFormacaoComplementacaoPedagogica2 = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">C&oacute;digo do Superior 2</td>
            <td><input style="width:100pt" name="txtCodigoSuperior2" type="text" class="form-control" id="txtCodigoSuperior2" size="8" maxlength="8" value="<%=trim(strCodigoSuperior2)%>" /></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Ano de In&iacute;cio do Curso Superior</td>
            <td><input style="width:100pt" name="txtAnoInicioCursoSuperior" type="text" class="form-control" id="txtAnoInicioCursoSuperior" size="8" maxlength="8" value="<%=trim(strAnoInicioCursoSuperior)%>" /></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Ano de Conclus&atilde;o do Curso Superior 2</td>
            <td><input style="width:100pt" name="txtAnoConclusaoCursoSuperior2" type="text" class="form-control" id="txtAnoConclusaoCursoSuperior2" size="8" maxlength="8" value="<%=trim(strAnoConclusaoCursoSuperior2)%>" /></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Tipo de Institui&ccedil;&atilde;o do Curso Superior 2</td>
            <td><select name="cmbTipoInstituicaoCursoSuperior2" id="cmbTipoInstituicaoCursoSuperior2" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strTipoInstituicaoCursoSuperior2 = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strTipoInstituicaoCursoSuperior2 = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Institui&ccedil;&atilde;o do Curso Superior 2</td>
            <td><input style="width:100pt" name="txtInstituicaoCursoSuperior2" type="text" class="form-control" id="txtInstituicaoCursoSuperior2" size="50" maxlength="50" value="<%=trim(strInstituicaoCursoSuperior2)%>" /></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Situa&ccedil;&atilde;o do Curso Superior 3</td>
            <td><select name="cmbSituacaoCursoSuperior3" id="cmbSituacaoCursoSuperior3" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strSituacaoCursoSuperior3 = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strSituacaoCursoSuperior3 = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Forma&ccedil;&atilde;o/Complementa&ccedil;&atilde;o pedag&oacute;gica 3</td>
            <td><select name="cmbFormacaoComplentacaoPedagogica3" id="cmbFormacaoComplentacaoPedagogica3" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strFormacaoComplentacaoPedagogica3 = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strFormacaoComplentacaoPedagogica3 = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">C&oacute;digo do Curso Superior 3</td>
            <td><input style="width:100pt" name="txtCodigoCursoSuperior3" type="text" class="form-control" id="txtCodigoCursoSuperior3" size="8" maxlength="8" value="<%=trim(strCodigoCursoSuperior3)%>" /></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Ano de In&iacute;cio do Curso Superior 3</td>
            <td><input style="width:100pt" name="txtAnoInicioCursoSuperior3" type="text" class="form-control" id="txtAnoInicioCursoSuperior3" size="8" maxlength="8" value="<%=trim(strAnoInicioCursoSuperior3)%>" /></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Ano de Conclus&atilde;o do Curso Superior 3</td>
            <td><input style="width:100pt" name="txtAnoConclusaoCursoSuperior3" type="text" class="form-control" id="txtAnoConclusaoCursoSuperior3" size="8" maxlength="8" value="<%=trim(strAnoConclusaoCursoSuperior3)%>" /></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Tipo de Institui&ccedil;&atilde;o do Curso Superior 3</td>
            <td><select name="cmbTipoInstituicaoCursoSuperior3" id="cmbTipoInstituicaoCursoSuperior3" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strTipoInstituicaoCursoSuperior3 = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strTipoInstituicaoCursoSuperior3 = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Institui&ccedil;&atilde;o do Curso Superior 3</td>
            <td><input style="width:100pt" name="txtInstituicaoCursoSuperior3" type="text" class="form-control" id="txtInstituicaoCursoSuperior3" size="8" maxlength="8" value="<%=trim(strInstituicaoCursoSuperior3)%>" /></td>
          </tr>
          <tr>
            <td height="25" class="texto1">P&oacute;s-Gradua&ccedil;&atilde;o - Especializa&ccedil;&atilde;o</td>
            <td><select name="cmbPosGraduacaoEspecializacao" id="cmbPosGraduacaoEspecializacao" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strPosGraduacaoEspecializacao = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strPosGraduacaoEspecializacao = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">P&oacute;s-Gradua&ccedil;&atilde;o - Mestrado</td>
            <td><select name="cmbPosGraduacaoMestrado" id="cmbPosGraduacaoMestrado" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strPosGraduacaoMestrado = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strPosGraduacaoMestrado = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">P&oacute;s-Gradua&ccedil;&atilde;o - Doutorado</td>
            <td><select name="cmbPosGraduacaoDoutorado" id="cmbPosGraduacaoDoutorado" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strPosGraduacaoDoutorado = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strPosGraduacaoDoutorado = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">P&oacute;s-Gradua&ccedil;&atilde;o - Nenhum</td>
            <td><select name="cmbPosGraduacaoNenhum" id="cmbPosGraduacaoNenhum" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strPosGraduacaoNenhum = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strPosGraduacaoNenhum = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Espec&iacute;fico para Creche (0 a 3 anos )</td>
            <td><select name="cmbEspecializacaoCreche0a3anos" id="cmbEspecializacaoCreche0a3anos" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEspecializacaoCreche0a3anos = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEspecializacaoCreche0a3anos = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Espec&iacute;fico para Pr&eacute;-Escola (4 e 5 anos)</td>
            <td><select name="cmbEspecializacaoPreEscola" id="cmbEspecializacaoPreEscola" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEspecializacaoPreEscola = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEspecializacaoPreEscola = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Espec&iacute;fico para anos iniciais do ensino fundamental</td>
            <td><select name="cmbEspecificoParaAnoIniciaisEnsinoFundamental" id="cmbSexo17" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEspecificoParaAnoIniciaisEnsinoFundamental = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEspecificoParaAnoIniciaisEnsinoFundamental = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Espec&iacute;fico para finais do ensino fundamental</td>
            <td><select name="cmbEspecificoFinaisEnsinoFundamental" id="cmbSexo18" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEspecificoFinaisEnsinoFundamental = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEspecificoFinaisEnsinoFundamental = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1"> Espec&iacute;fico para ensino m&eacute;dio</td>
            <td><select name="cmbEspecificoEnsinoMedio" id="cmbEspecificoEnsinoMedio" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEspecificoEnsinoMedio = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEspecificoEnsinoMedio = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Espec&iacute;fico para educa&ccedil;&atilde;o de jovens e adultos</td>
            <td><select name="cmbEspecificoEducacaoJovensAdultos" id="cmbEspecificoEducacaoJovensAdultos" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEspecificoEducacaoJovensAdultos = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEspecificoEducacaoJovensAdultos = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Espec&iacute;fico para educa&ccedil;&atilde;o especial</td>
            <td><select name="cmbEspecificoEducacaoEspecial" id="cmbEspecificoEducacaoEspecial" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strSexo = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strSexo = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Espec&iacute;fico para educa&ccedil;&atilde;o ind&iacute;gena</td>
            <td><select name="cmbEspecificoEducacaoIndigena" id="cmbEspecificoEducacaoIndigena" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEspecificoEducacaoIndigena = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEspecificoEducacaoIndigena = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Espec&iacute;fico para educa&ccedil;&atilde;o do campo</td>
            <td><select name="cmbEspecificoEducacaoCampo" id="cmbEspecificoEducacaoCampo" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEspecificoEducacaoCampo = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEspecificoEducacaoCampo = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Espec&iacute;fico para educa&ccedil;&atilde;o ambiental</td>
            <td><select name="cmbEspecificoEducacaoAmbiental" id="cmbEspecificoEducacaoAmbiental" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEspecificoEducacaoAmbiental = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEspecificoEducacaoAmbiental = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Espec&iacute;fico para educa&ccedil;&atilde;o em direitos humanos</td>
            <td><select name="cmbEspecificoEducacaoDireitosHumanos" id="cmbEspecificoEducacaoDireitosHumanos" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strEspecificoEducacaoDireitosHumanos = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strEspecificoEducacaoDireitosHumanos = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">G&ecirc;nero e diversidade sexual</td>
            <td><select name="cmbGeneroDiversidadeSexual" id="cmbGeneroDiversidadeSexual" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strGeneroDiversidadeSexual = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strGeneroDiversidadeSexual = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Direitos de crian&ccedil;as e adolescente</td>
            <td><select name="cmbDireitosCriancasAdolescente" id="cmbDireitosCriancasAdolescente" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strDireitosCriancasAdolescente = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strDireitosCriancasAdolescente = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Educa&ccedil;&atilde;o para as rela&ccedil;&otilde;es etnicorraciais e Hist&oacute;ria e Cultura afro-Brasileira e Africana</td>
            <td><select name="cmbAfricana" id="cmbAfricana" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strAfricana = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strAfricana = "1" then%> selected <%end if%> value="1">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Outros</td>
            <td><select name="cmbOutros" id="cmbOutros" class="form-control" style="width:100pt" >
              <option value="0">Selecione...</option>
              <option <%if strOutros = "0" then%> selected <%end if%> value="0">N&atilde;o</option>
              <option <%if strOutros = "1" then%> selected <%end if%> value="1">Sim</option>
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
		frm.action="Registro50_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 