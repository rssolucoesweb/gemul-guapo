<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
<script src="../ckeditor4.4.7/ckeditor.js"></script>
<script src="../ckeditor4.4.7/config.js"></script>
<script src="../../js/js_funcoes_gerais.js"></script>  
<script src="../../js/js_barra_movel_documento.js"></script>
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
        strPaginaTitulo 	= "Documento_cad.asp"
    
        strPagina			= "Documento_cad.asp"
        intCodDocumento		= Trim(Request("txtCodigo"))
        strTitulo	 		= Trim(Request.Form("txtTitulo"))
        strDescricao 		= Trim(Request.Form("txtDescricao"))
        if TRIM(Session("NivelPermissao")) = "A" then
           strMostraSomenteDeptoAtual = "" 'mostra todos os deptos
        else   
           strMostraSomenteDeptoAtual = "S" 'mostra somente o depto atual
        end if	
        if trim(intCodDocumento) <> "" then
        
            sql = "SELECT codigo, titulo, Documento, campos, cod_departamento, situacao"
            sql = sql & " FROM SRH_DOCUMENTO"
            sql = sql & " Where codigo = " & intCodDocumento
            sql = sql & " And cod_empresa = " & Session("CodEmpresa")			
            rs.open sql, cnn
            
            if rs.eof = false then
                
                strTitulo 				= rs("Titulo")
                strDescricao			= rs("Documento")
                strCampos				= rs("campos")
                intCodDepartamento		= rs("cod_departamento")
                strsituacao				= rs("situacao")
                
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
        
        strMarcaNome 			= ""
        strMarcaMatricula 		= ""
        strMarcaDataNascimento 	= ""
        strMarcaCidadeNascimento= ""
        strMarcaUfNascimento 	= ""
        strMarcaIdentidade	 	= ""
        strMarcaCPF 			= ""
        strMarcaTitulo		 	= ""
        strEstadoCivil			= ""
        strMarcaPai 			= ""
        strMarcaMae 			= ""
        strNacionalidade		= ""
        strLogradouro 			= ""
        strNumeroEndereco		= ""
        strCompEndereco 		= ""
        strBairro 			= ""
    
        strMarcaCargo	 		= ""
        strMarcaFuncao 			= ""
        strMarcaDataAdimissao 	= ""
        strMarcaDataAfastamento = ""
        strMarcaFormaNomeacao 	= ""
        strNivel				= ""
        strTurno				= ""
        strHorasContratada		= ""
        strAulasContratada 		= ""
        strDataLotacao			= ""
        strRegencia				= ""
        strObservacoes			= ""
    
        strMarcaCidade	 		= ""
        strMarcaDia 			= ""
        strMarcaMes 			= ""
        strMarcaAno 			= ""
    
        strMarcaSecretario 		= ""
        strMarcaDiretor 		= ""
    
    
        strMarcaSituacao		= ""
        strMarcaPERIODOLETIVO		= ""
        strMarcaSemestre		= ""
        strMarcaQuinquenio	 	= ""
        strDataAulasCumprida	= ""
        
        
        estiloInicialNome = "style='display:none'"
        estiloInicialMatricula = "style='display:none'"
        estiloInicialDataNascimento = "style='display:none'"
        estiloInicialCidadeNascimento = "style='display:none'"
        estiloInicialUfNascimento = "style='display:none'"
        estiloInicialIdentidade = "style='display:none'"
        estiloInicialCPF 		= "style='display:none'"
        estiloInicialTitulo 	= "style='display:none'"
        estiloInicialEstadoCivil = "style='display:none'"
        estiloInicialPai = "style='display:none'"
        estiloInicialMae = "style='display:none'"
        estiloInicialNacionalidade = "style='display:none'"
        estiloInicialLogradouro = "style='display:none'"
        estiloInicialNumero_Endereco = "style='display:none'"
        estiloInicialComp_Endereco = "style='display:none'"
        estiloInicialBairro = "style='display:none'"
    
        estiloInicialCargo = "style='display:none'"
        estiloInicialFuncao = "style='display:none'"
        estiloInicialDataAdimissao = "style='display:none'"
        estiloInicialDataAfastamento = "style='display:none'"
        estiloInicialFormaNomeacao = "style='display:none'"	
        estiloInicialNivel = "style='display:none'"
        estiloInicialTurno = "style='display:none'"
        estiloInicialHorasContratada = "style='display:none'"
        estiloInicialAulasContratada  = "style='display:none'"
        estiloInicialDataLotacao = "style='display:none'"
        estiloInicialRegencia = "style='display:none'"
        estiloInicialObservacoes = "style='display:none'"
    
        estiloInicialCidade = "style='display:none'"
        estiloInicialDia = "style='display:none'"
        estiloInicialMes = "style='display:none'"
        estiloInicialAno = "style='display:none'"
    
        estiloInicialSecretario = "style='display:none'"
        estiloInicialDiretor = "style='display:none'"
     
        estiloInicialSituacao = "style='display:none'"
        estiloInicialPERIODOLETIVO = "style='display:none'"
        estiloInicialSemestre = "style='display:none'"
        estiloInicialQuinquenio = "style='display:none'"
        estiloInicialAulasCumprida = "style='display:none'"
        
        '
        '
    
        if strCampos <> "" then
    
            vetCampos = split(strCampos,",")
            for i=0 to ubound(vetCampos)
    
                'Bloco 01	
                if trim(vetCampos(i)) = "NOME" then 
                    strMarcaNome = "checked"
                    estiloInicialNome = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "MATRICULA" then 
                    strMarcaMatricula = "checked"
                    estiloInicialMatricula = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "DATANASCIMENTO" then 
                    strMarcaDataNascimento = "checked"
                    estiloInicialDataNascimento = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "CIDADENASCIMENTO" then 
                    strMarcaCidadeNascimento = "checked"
                    estiloInicialCidadeNascimento = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "UFNASCIMENTO" then 
                    strMarcaUfNascimento = "checked"
                    estiloInicialUfNascimento = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "IDENTIDADE" then 
                    strMarcaIdentidade = "checked"
                    estiloInicialIdentidade = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "CPF" then 
                    strMarcaCPF = "checked"
                    estiloInicialCPF = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "TITULO" then 
                    strMarcaTitulo = "checked"
                    estiloInicialTitulo = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "ESTADOCIVIL" then 
                    strMarcaEstadoCivil = "checked"
                    estiloInicialEstadoCivil = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "PAI" then 
                    strMarcaPai = "checked"
                    estiloInicialPai = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "MAE" then 
                    strMarcaMae = "checked"
                    estiloInicialMae = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "NACIONALIDADE" then 
                    strMarcaNacionalidade = "checked"
                    estiloInicialNacionalidade = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "LOGRADOURO" then 
                    strLogradouro = "checked"
                    estiloInicialLogradouro = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "NUMERO_ENDERECO" then 
                    strNumeroEndereco = "checked"
                    estiloInicialNumero_Endereco = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "COMP_ENDERECO" then 
                    strCompEndereco = "checked"
                    estiloInicialComp_Endereco = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "BAIRRO" then 
                    strBairro = "checked"
                    estiloInicialBairro = "style='display:block'"
                end if
    
                'Bloco 02
                if trim(vetCampos(i)) = "CARGO" then 
                    strMarcaCargo = "checked"
                    estiloInicialCargo = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "FUNCAO" then 
                    strMarcaFuncao = "checked"
                    estiloInicialFuncao = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "DATAADIMISSAO" then 
                    strMarcaDataAdimissao = "checked"
                    estiloInicialDataAdimissao = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "DATAAFASTAMENTO" then 
                    strMarcaDataAfastamento = "checked"
                    estiloInicialDataAfastamento = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "FORMANOMEACAO" then 
                    strMarcaFormaNomeacao = "checked"
                    estiloInicialFormaNomeacao = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "NIVEL" then 
                    strMarcaNivel = "checked"
                    estiloInicialNivel = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "TURNO" then 
                    strMarcaTurno = "checked"
                    estiloInicialTurno = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "HORASCONTRATADA" then 
                    strMarcaHorasContratada = "checked"
                    estiloInicialHorasContratada = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "AULASCONTRATADA" then 
                    strMarcaAulasContratada  = "checked"
                    estiloInicialAulasContratada  = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "DATALOTACAO" then 
                    strMarcaDataLotacao = "checked"
                    estiloInicialDataLotacao = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "REGENCIA" then 
                    strMarcaRegencia = "checked"
                    estiloInicialRegencia = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "OBSERVACOES" then 
                    strMarcaObservacoes = "checked"
                    estiloInicialObservacoes = "style='display:block'"
                end if
    
                'Bloco 03
                if trim(vetCampos(i)) = "CIDADE" then 
                    strMarcaCidade = "checked"
                    estiloInicialCidade = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "DIA" then 
                    strMarcaDia = "checked"
                    estiloInicialDia = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "MES" then 
                    strMarcaMes = "checked"
                    estiloInicialMes = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "ANO" then 
                    strMarcaAno = "checked"
                    estiloInicialAno = "style='display:block'"
                end if
                
                'Bloco 04
                if trim(vetCampos(i)) = "SECRETARIO" then 
                    strMarcaSecretario = "checked"
                    estiloInicialSecretario = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "DIRETOR" then 
                    strMarcaDiretor = "checked"
                    estiloInicialDiretor = "style='display:block'"
                end if
                '
                
                if trim(vetCampos(i)) = "SITUACAO" then 
                    strMarcaSituacao = "checked"
                    estiloInicialSituacao = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "PERIODOLETIVO" then 
                    strMarcaPERIODOLETIVO = "checked"
                    estiloInicialPERIODOLETIVO = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "SEMESTRE" then 
                    strMarcaSemestre = "checked"
                    estiloInicialSemestre = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "QUINQUENIO" then 
                    strMarcaQuinquenio = "checked"
                    estiloInicialQuinquenio  = "style='display:block'"
                end if
                if trim(vetCampos(i)) = "AULASCUMPRIDA" then 
                    strMarcaAulasCumprida = "checked"
                    estiloInicialAulasCumprida = "style='display:block'"
                end if
    
                
            next
        end if
        
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Emissão de Documentos</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" method="post">
                    
                    <div class="form-group">
                   		
                        <table class="table table-bordered">
                              <tr>
                                <td width="939" height="80" class="texto1">
                                
                                <table class="table table-bordered">
                                      <tr>
                                        <td height="23" class="texto1"><strong>T&iacute;tulo : </strong></td>
                                        <td><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodDocumento%>" maxlength="10">
                                          <input name="txtTitulo" type="text" class="text" id="txtTitulo" size="50" maxlength="50" value="<%=strTitulo%>"></td>
                                      </tr>
                                      <tr>
                                        <td height="23" class="texto1"><strong>Departamento : </strong></td>
                                        <td><!--#include file="../includes/inc_cmdDepartamento.asp" --></td>
                                  </tr>
                                      <tr bgcolor="#EEEEEE">
                                        <td height="20" colspan="2" bgcolor="#EEEEEE" class="texto1" style="cursor:hand" onclick="return dadosAluno()"><img id="imgDadosAluno" src="<%=session("strCaminhoRaiz")%>/images/up.jpg" width="12" height="12">&nbsp;&nbsp;<strong>Informa&ccedil;&otilde;es Pessoais</strong></td>
                                      </tr>
                                      <tr>
                                        <td colspan="2" class="texto1" >
                                        <!-- INICIO CAMPO - DADOS ALUNO-->
                                            <table style="display:none" width="100%" border="0" cellpadding="0" cellspacing="0" id="mostraDadosAluno">					
                                              <tr>
                                                <td width="158" class="texto1"><strong><input onclick="mostraCampoInserir('NOME',this.checked)" type="checkbox" name="campos" value="NOME" <%=strMarcaNome%>>Nome do Colaborador</strong></td>
                                                <td width="181" class="texto1"><strong><input  onClick="mostraCampoInserir('MATRICULA',this.checked)" type="checkbox" name="campos" value="MATRICULA" <%=strMarcaMatricula%>>Matrícula</strong></td>
                                                <td width="164" class="texto1"><strong><input onclick="mostraCampoInserir('DATANASCIMENTO',this.checked)"  type="checkbox" name="campos" value="DATANASCIMENTO" <%=strMarcaDataNascimento%>>Data Nascimento</strong></td>
                                                <td width="200" class="texto1"><strong><input onclick="mostraCampoInserir('CIDADENASCIMENTO',this.checked)"  type="checkbox" name="campos" value="CIDADENASCIMENTO" <%=strMarcaCidadeNascimento%>>Cidade de Nascimento</strong></td>
                                              </tr>
                                              <tr>
                                                <td width="158" class="texto1"><strong><input onclick="mostraCampoInserir('UFNASCIMENTO',this.checked)"  type="checkbox" name="campos" value="UFNASCIMENTO" <%=strMarcaUfNascimento%>>Estado de Nasc.</strong></td>
                                                <td class="texto1"><strong><input onclick="mostraCampoInserir('IDENTIDADE',this.checked)"  type="checkbox" name="campos" value="IDENTIDADE" <%=strMarcaIdentidade%>>Identidade</strong></td>
                                                <td class="texto1"><strong><input onclick="mostraCampoInserir('CPF',this.checked)"  type="checkbox" name="campos" value="CPF" <%=strMarcaCPF%>>CPF</strong></td>
                                                <td class="texto1"><strong><input onclick="mostraCampoInserir('TITULO',this.checked)"  type="checkbox" name="campos" value="TITULO" <%=strMarcaTitulo%>>T&iacute;tulo de Eleitor</strong></td>
                                              </tr>
                                              <tr>
                                                <td width="158" class="texto1"><strong><input onclick="mostraCampoInserir('ESTADOCIVIL',this.checked)"  type="checkbox" name="campos" value="ESTADOCIVIL" <%=strMarcaEstadoCivil%>>Estado Civil </strong></td>
                                                <td class="texto1"><strong><input onclick="mostraCampoInserir('PAI',this.checked)"  type="checkbox" name="campos" value="PAI" <%=strMarcaPai%>>Pai</strong></td>
                                                <td class="texto1"><strong><input onclick="mostraCampoInserir('MAE',this.checked)"  type="checkbox" name="campos" value="MAE" <%=strMarcaMae%>>Mãe</strong></td>
                                                <td class="texto1"><strong><input onclick="mostraCampoInserir('NACIONALIDADE',this.checked)"  type="checkbox" name="campos" value="NACIONALIDADE" <%=strMarcaNacionalidade%>>Nacionalidade</strong></td>
                                              </tr>
                                              <tr>
                                                <td width="158" class="texto1"><strong><input onclick="mostraCampoInserir('LOGRADOURO',this.checked)"  type="checkbox" name="campos" value="LOGRADOURO" <%=strLogradouro%>>Logradouro</strong></td>
                                                <td class="texto1"><strong><input onclick="mostraCampoInserir('NUMERO_ENDERECO',this.checked)"  type="checkbox" name="campos" value="NUMERO_ENDERECO" <%=strNumeroEndereco%>>Numero</strong></td>
                                                <td class="texto1"><strong><input onclick="mostraCampoInserir('COMP_ENDERECO',this.checked)"  type="checkbox" name="campos" value="COMP_ENDERECO" <%=strCompEndereco%>>Complemento</strong></td>
                                                <td class="texto1"><strong><input onclick="mostraCampoInserir('BAIRRO',this.checked)"  type="checkbox" name="campos" value="BAIRRO" <%=strBairro%>>Bairro</strong></td>
                                              </tr>
                                            </table>                                        </td>
                                      </tr>
                                      <tr bgcolor="#EEEEEE">
                                        <td height="20" colspan="2" bgcolor="#EEEEEE" class="texto1" style="cursor:hand" onclick="return dadosEscolares()"><img id="imgDadosEscolares" src="<%=session("strCaminhoRaiz")%>/images/up.jpg" width="12" height="12">&nbsp;&nbsp;<strong>Informa&ccedil;&otilde;es Contratuais</strong></td>
                                      </tr>
                                      <tr>
                                        <td colspan="2" class="texto1" >
                                        <!-- INICIO CAMPO - DADOS ESCOLARES-->
                                            <table style="display:none" width="100%" border="0" cellpadding="0" cellspacing="0" id="mostraDadosEscolares">					
                                              <tr>
                                                <td class="texto1"><strong><input onclick="mostraCampoInserir('CARGO',this.checked)"  type="checkbox" name="campos" value="CARGO" <%=strMarcaCargo%>>Cargo</strong></td>
                                                <td class="texto1"><strong><input onclick="mostraCampoInserir('FUNCAO',this.checked)"  type="checkbox" name="campos" value="FUNCAO" <%=strMarcaFuncao%>>Função</strong></td>
                                                <td class="texto1"><strong><input onclick="mostraCampoInserir('DATAADIMISSAO',this.checked)"  type="checkbox" name="campos" value="DATAADIMISSAO" <%=strMarcaDataAdimissao%>>Data de Admissão</strong></td>
                                                <td class="texto1"><strong><input onclick="mostraCampoInserir('DATAAFASTAMENTO',this.checked)"  type="checkbox" name="campos" value="DATAAFASTAMENTO" <%=strMarcaDataAfastamento%>>Data de Afastamento</strong></td>
                                              </tr>
                                              <tr>
                                                <td class="texto1"><strong><input onclick="mostraCampoInserir('FORMANOMEACAO',this.checked)"  type="checkbox" name="campos" value="FORMANOMEACAO" <%=strMarcaFormaNomeacao%>>Forma de Nomea&ccedil;&atilde;o</strong></td>
                                                <td class="texto1"><strong><input onclick="mostraCampoInserir('NIVEL',this.checked)"  type="checkbox" name="campos" value="NIVEL" <%=strMarcaNivel%>>N&iacute;vel</strong></td>
                                                <td class="texto1"><strong><input onclick="mostraCampoInserir('TURNO',this.checked)"  type="checkbox" name="campos" value="TURNO" <%=strMarcaTurno%>>Turno </strong></td>
                                                <td class="texto1"><strong><input onclick="mostraCampoInserir('HORASCONTRATADA',this.checked)"  type="checkbox" name="campos" value="HORASCONTRATADA" <%=strMarcaHorasContratada%>>Horas Contratadas</strong></td>
                                              </tr>
                                              <tr>
                                                <td class="texto1"><strong><input onclick="mostraCampoInserir('AULASCONTRATADA',this.checked)"  type="checkbox" name="campos" value="AULASCONTRATADA" <%=strMarcaAulasContratada%>>Aulas Contratadas</strong></td>
                                                <td class="texto1"><strong><input onclick="mostraCampoInserir('DATALOTACAO',this.checked)"  type="checkbox" name="campos" value="DATALOTACAO" <%=strMarcaDataLotacao%>>Data da Lota&ccedil;&atilde;o  </strong></td>
                                                <td class="texto1"><strong><input onclick="mostraCampoInserir('REGENCIA',this.checked)"  type="checkbox" name="campos" value="REGENCIA" <%=strMarcaRegencia%>>Reg&ecirc;ncia </strong></td>
                                                <td class="texto1"><strong><input onclick="mostraCampoInserir('OBSERVACOES',this.checked)"  type="checkbox" name="campos" value="OBSERVACOES" <%=strMarcaObservacoes%>>Observa&ccedil;&otilde;es</strong></td>
                                              </tr>
                                           </table>                                        </td>
                                      </tr>
                                      <tr bgcolor="#EEEEEE">
                                        <td height="20" colspan="2" bgcolor="#EEEEEE" class="texto1" style="cursor:hand" onclick="return dadosDataAtual()"><img id="imgDadosDataAtual" src="<%=session("strCaminhoRaiz")%>/images/up.jpg" width="12" height="12">&nbsp;&nbsp;<strong>Informa&ccedil;&otilde;es Data atual</strong></td>
                                      </tr>
                                      <tr>
                                        <td colspan="2" class="texto1" >
                                        <!-- INICIO CAMPO - DADOS DATA ATUAL-->
                                            <table style="display:none" width="100%" border="0" cellpadding="0" cellspacing="0" id="mostraDadosDataAtual">					
                                              <tr>
                                                <td class="texto1"><strong><input onclick="mostraCampoInserir('CIDADE',this.checked)"  type="checkbox" name="campos" value="CIDADE" <%=strMarcaCidade%>>Cidade</strong></td>
                                                <td class="texto1"><strong><input onclick="mostraCampoInserir('DIA',this.checked)"  type="checkbox" name="campos" value="DIA" <%=strMarcaDia%>>Dia</strong></td>
                                                <td class="texto1"><strong><input onclick="mostraCampoInserir('MES',this.checked)"  type="checkbox" name="campos" value="MES" <%=strMarcaMes%>>M&ecirc;s</strong></td>
                                                <td class="texto1"><strong><input onclick="mostraCampoInserir('ANO',this.checked)"  type="checkbox" name="campos" value="ANO" <%=strMarcaAno%>>Ano</strong></td>
                                              </tr>
                                           </table>                                        </td>
                                      </tr>
                                      <tr bgcolor="#EEEEEE">
                                        <td height="20" colspan="2" bgcolor="#EEEEEE" class="texto1" style="cursor:hand" onclick="return dadosRepresentantes()"><img id="imgDadosRepresentantes" src="<%=session("strCaminhoRaiz")%>/images/up.jpg" width="12" height="12">&nbsp;&nbsp;<strong>Informa&ccedil;&otilde;es dos Representantes Legais</strong></td>
                                      </tr>
                                      <tr>
                                        <td colspan="2" class="texto1" >
                                        <!-- INICIO CAMPO - DADOS REPRESENTANTES-->
                                        <table style="display:none" width="100%" border="0" cellpadding="0" cellspacing="0" id="mostraDadosRepresentantes">					
                                          <tr>
                                            <td class="texto1"><strong><input onclick="mostraCampoInserir('SECRETARIO',this.checked)"  type="checkbox" name="campos" value="SECRETARIO" <%=strMarcaSecretario%>>Secretario(a)</strong></td>
                                            <td class="texto1"><strong><input onclick="mostraCampoInserir('DIRETOR',this.checked)"  type="checkbox" name="campos" value="DIRETOR" <%=strMarcaDiretor%>>Diretor(a)</strong></td>
                                            <td class="texto1">&nbsp;</td>
                                            <td class="texto1">&nbsp;</td>
                                          </tr>
                                        </table>                                        </td>
                                      </tr>
                                      <tr bgcolor="#EEEEEE">
                                        <td height="20" colspan="2" bgcolor="#EEEEEE" class="texto1" style="cursor:hand" onclick="return dadosVinculo()"><img id="imgdadosVinculo" src="<%=session("strCaminhoRaiz")%>/images/up.jpg" width="12" height="12">&nbsp;&nbsp;<strong>Informa&ccedil;&otilde;es de  V&iacute;nculos</strong></td>
                                      </tr>
                                      <tr>
                                        <td colspan="2" class="texto1" >
                                        <!-- INICIO CAMPO - DADOS AUTORIZAÇÃO-->
                                        <table style="display:none" width="100%" border="0" cellpadding="0" cellspacing="0" id="mostradadosVinculo">					
                                              <tr>
                                                <td class="texto1"><strong><input onclick="mostraCampoInserir('SITUACAO',this.checked)"  type="checkbox" name="campos" value="SITUACAO" <%=strMarcaSituacao%>>Situa&ccedil;&atilde;o</strong></td>
                                                <td class="texto1"><strong><input onclick="mostraCampoInserir('PERIODOLETIVO',this.checked)"  type="checkbox" name="campos" value="PERIODOLETIVO" <%=strMarcaPERIODOLETIVO%>>
                                                Período Letivo </strong></td>
                                                <td class="texto1"><strong><input onclick="mostraCampoInserir('SEMESTRE',this.checked)"  type="checkbox" name="campos" value="SEMESTRE" <%=strMarcaSemestre%>>Semestre Letivo</strong></td>
                                                <td class="texto1"><strong>
                                                  <input onclick="mostraCampoInserir('QUINQUENIO',this.checked)"  type="checkbox" name="campos" value="QUINQUENIO" <%=strMarcaQuinquenio%>>
                                                  Quinqu&ecirc;nio</strong></td>
                                              </tr>
                                              <tr>
                                                <td class="texto1"><strong>
                                                  <input onclick="mostraCampoInserir('AULASCUMPRIDA',this.checked)"  type="checkbox" name="campos" value="AULASCUMPRIDA" <%=strMarcaAulasCumprida%>>Aulas Cumprida </strong></td>
                                                <td colspan="3" class="texto1">&nbsp;</td>
                                          </tr>
                                        </table>                                        </td>
                                      </tr>
                                      <tr bgcolor="#EEEEEE">
                                        <td height="20" colspan="2" bgcolor="#EEEEEE" class="texto1" style="cursor:hand" onclick="return dadosValidacao()"><img id="imgDadosValidacao" src="<%=session("strCaminhoRaiz")%>/images/up.jpg" width="12" height="12">&nbsp;&nbsp;<strong>Validações</strong></td>
                                      </tr>
                                      <tr>
                                        <td colspan="2" class="texto1" >
                                        <!-- INICIO CAMPO - DADOS AUTORIZAÇÃO-->
                                        <table style="display:none" width="100%" border="0" cellpadding="0" cellspacing="0" id="mostraDadosValidacao">					
                                              <tr>
                                                <td class="texto1"><strong>Situa&ccedil;&atilde;o cadastral: </strong></td>
                                                <td colspan="3" class="texto1">
                                                <strong>
                                                 <input name="Situacao" type="radio" value="A" > Ativo
                                                <input name="Situacao" type="radio" value="I" > Inativo                                                </strong></td>
                                          </tr>
                                        </table>                                        </td>
                                      </tr>
                                      <tr>
                                        <td colspan="2" class="texto1"><span class="style1">Obs: 
                                        * 
                                          Todos os campos selecionados dever&atilde;o ser utilizados no texto do documento.</span></td>
                                  </tr>
                                      <tr>
                                        <td height="19" colspan="2" align="center" bgcolor="#EFEFDE"><span class="texto1"><strong>Texto do Documento </strong></span></td>
                                      </tr>
                                      <tr>
                                        <td colspan="2">
                                        <Textarea class="ckeditor" cols="80" id="txtDescricao" name="txtDescricao"><%=strDescricao%></textarea>                                        </td>
                                      </tr>
                                </table></td>
                                <td width="291" class="texto1" valign="top">
                                <div id="documento" style="position:absolute;">
                                <table width="200" border="0" cellspacing="2" cellpadding="2">
                                  <tr>
                                    <td class="texto1" align="center" bgcolor="#F0F0F0"><strong>Campos a serem inseridos </strong></td>
                                  </tr>
                    
                    
                                  <tr id="NOME" <%=estiloInicialNome%>>
                                    <td class="texto1">&lt;a id=NOME&gt;&lt;/a&gt;</td>
                                  </tr>
                                  <tr id="MATRICULA" <%=estiloInicialMatricula%>>
                                    <td class="texto1" bgcolor="#F0F0F0">&lt;a id=MATRICULA&gt;&lt;/a&gt;</td>
                                  </tr>
                                  <tr id="DATANASCIMENTO" <%=estiloInicialDataNascimento%>>
                                    <td class="texto1">&lt;a id=DATANASCIMENTO&gt;&lt;/a&gt;</td>
                                  </tr>
                                  <tr id="CIDADENASCIMENTO" <%=estiloInicialCidadeNascimento%>>
                                    <td class="texto1" bgcolor="#F0F0F0">&lt;a id=CIDADENASCIMENTO&gt;&lt;/a&gt;</td>
                                  </tr>
                                  <tr id="UFNASCIMENTO" <%=estiloInicialUfNascimento%>>
                                    <td class="texto1">&lt;a id=UFNASCIMENTO&gt;&lt;/a&gt;</td>
                                  </tr>
                                  <tr id="IDENTIDADE" <%=estiloInicialIdentidade%>>
                                    <td class="texto1">&lt;a id=IDENTIDADE&gt;&lt;/a&gt;</td>
                                  </tr>
                                  <tr id="CPF" <%=estiloInicialCPF%>>
                                    <td class="texto1">&lt;a id=CPF&gt;&lt;/a&gt;</td>
                                  </tr>
                                  <tr id="TITULO" <%=estiloInicialTitulo%>>
                                    <td class="texto1">&lt;a id=TITULO&gt;&lt;/a&gt;</td>
                                  </tr>
                                  <tr id="ESTADOCIVIL" <%=estiloInicialEstadoCivil%>>
                                    <td class="texto1"   bgcolor="#F0F0F0">&lt;a id=ESTADOCIVIL&gt;&lt;/a&gt;</td>
                                  </tr>
                                  <tr id="PAI" <%=estiloInicialPai%>>
                                    <td class="texto1">&lt;a id=PAI&gt;&lt;/a&gt;</td>
                                  </tr>
                                  <tr id="MAE" <%=estiloInicialMae%>>
                                    <td class="texto1" bgcolor="#F0F0F0">&lt;a id=MAE&gt;&lt;/a&gt;</td>
                                  </tr>
                                  <tr id="NACIONALIDADE" <%=estiloInicialNacionalidade%>>
                                    <td class="texto1" >&lt;a id=NACIONALIDADE&gt;&lt;/a&gt;</td>
                                  </tr>
                                  <tr id="LOGRADOURO" <%=estiloInicialLogradouro%>>
                                    <td class="texto1" >&lt;a id=LOGRADOURO&gt;&lt;/a&gt;</td>
                                  </tr>
                                  <tr id="NUMERO_ENDERECO" <%=estiloInicialNumero_Endereco%>>
                                    <td class="texto1" >&lt;a id=NUMERO_ENDERECO&gt;&lt;/a&gt;</td>
                                  </tr>
                                  <tr id="COMP_ENDERECO" <%=estiloInicialComp_Endereco%>>
                                    <td class="texto1" >&lt;a id=COMP_ENDERECO&gt;&lt;/a&gt;</td>
                                  </tr>
                                   <tr id="BAIRRO" <%=estiloInicialBairro%>>
                                    <td class="texto1" >&lt;a id=BAIRRO&gt;&lt;/a&gt;</td>
                                  </tr>
                                 
                                  <tr id="CARGO" <%=estiloInicialCargo%>>
                                    <td class="texto1" bgcolor="#F0F0F0">&lt;a id=CARGO&gt;&lt;/a&gt;</td>
                                  </tr>
                                  <tr id="FUNCAO" <%=estiloInicialFuncao%>>
                                    <td class="texto1">&lt;a id=FUNCAO&gt;&lt;/a&gt;</td>
                                  </tr>
                                  <tr id="DATAADIMISSAO" <%=estiloInicialDataAdimissao%>>
                                    <td class="texto1" bgcolor="#F0F0F0">&lt;a id=DATAADIMISSAO&gt;&lt;/a&gt;</td>
                                  </tr>
                                  <tr id="DATAAFASTAMENTO" <%=estiloInicialDataAfastamento%>>
                                    <td class="texto1" >&lt;a id=DATAAFASTAMENTO&gt;&lt;/a&gt;</td>
                                  </tr>
                                  <tr id="FORMANOMEACAO" <%=estiloInicialFormaNomeacao%>>
                                    <td class="texto1"  bgcolor="#F0F0F0">&lt;a id=FORMANOMEACAO&gt;&lt;/a&gt;</td>
                                  </tr>
                                  <tr id="NIVEL" <%=estiloInicialNivel%>>
                                    <td class="texto1" >&lt;a id=NIVEL&gt;&lt;/a&gt;</td>
                                  </tr>
                                  <tr id="TURNO" <%=estiloInicialTurno%>>
                                    <td class="texto1"   bgcolor="#F0F0F0">&lt;a id=TURNO&gt;&lt;/a&gt;</td>
                                  </tr>
                                  <tr id="HORASCONTRATADA" <%=estiloInicialHorasContratada%>>
                                    <td class="texto1" >&lt;a id=HORASCONTRATADA&gt;&lt;/a&gt;</td>
                                  </tr>
                                  <tr id="AULASCONTRATADA" <%=estiloInicialAulasContratada %>>
                                    <td class="texto1"   bgcolor="#F0F0F0">&lt;a id=AULASCONTRATADA&gt;&lt;/a&gt;</td>
                                  </tr>
                                  <tr id="DATALOTACAO" <%=estiloInicialDataLotacao%>>
                                    <td class="texto1" >&lt;a id=DATALOTACAO&gt;&lt;/a&gt;</td>
                                  </tr>
                                  <tr id="REGENCIA" <%=estiloInicialRegencia%>>
                                    <td class="texto1" >&lt;a id=REGENCIA&gt;&lt;/a&gt;</td>
                                  </tr>
                                  <tr id="OBSERVACOES" <%=estiloInicialObservacoes%>>
                                    <td class="texto1" >&lt;a id=OBSERVACOES&gt;&lt;/a&gt;</td>
                                  </tr>
                                  
                     
                                  <tr id="CIDADE" <%=estiloInicialCidade%>>
                                    <td class="texto1"  bgcolor="#F0F0F0">&lt;a id=CIDADE&gt;&lt;/a&gt;</td>
                                  </tr>
                                  <tr id="DIA" <%=estiloInicialDia%>>
                                    <td class="texto1" >&lt;a id=DIA&gt;&lt;/a&gt;</td>
                                  </tr>
                                  <tr id="MES" <%=estiloInicialMes%>>
                                    <td class="texto1" bgcolor="#F0F0F0" >&lt;a id=MES&gt;&lt;/a&gt;</td>
                                  </tr>
                                  <tr id="ANO" <%=estiloInicialAno%>>
                                    <td class="texto1" >&lt;a id=ANO&gt;&lt;/a&gt;</td>
                                  </tr>
                     
                                  <tr id="SECRETARIO" <%=estiloInicialSecretario%>>
                                    <td class="texto1"  bgcolor="#F0F0F0">&lt;a id=SECRETARIO&gt;&lt;/a&gt;</td>
                                  </tr>
                                  <tr id="DIRETOR" <%=estiloInicialDiretor%>>
                                    <td class="texto1" >&lt;a id=DIRETOR&gt;&lt;/a&gt;</td>
                                  </tr>
                             
                                  <tr id="SITUACAO" <%=estiloInicialSituacao%>>
                                    <td class="texto1"   bgcolor="#F0F0F0">&lt;a id=SITUACAO&gt;&lt;/a&gt;</td>
                                  </tr>
                                  <tr id="PERIODOLETIVO" <%=estiloInicialPERIODOLETIVO%>>
                                    <td class="texto1" >&lt;a id=PERIODOLETIVO&gt;&lt;/a&gt;</td>
                                  </tr>
                                  <tr id="SEMESTRE" <%=estiloInicialSemestre%>>
                                    <td class="texto1"   bgcolor="#F0F0F0">&lt;a id=SEMESTRE&gt;&lt;/a&gt;</td>
                                  </tr>
                                  <tr id="QUINQUENIO" <%=estiloInicialQuinquenio%>>
                                    <td class="texto1" >&lt;a id=QUINQUENIO&gt;&lt;/a&gt;</td>
                                  </tr>
                                  <tr id="AULASCUMPRIDA" <%=estiloInicialAulasCumprida%>>
                                    <td class="texto1"   bgcolor="#F0F0F0">&lt;a id=AULASCUMPRIDA&gt;&lt;/a&gt;</td>
                                  </tr>
                    
                                </table>
                                </div>
                                </td>
                          </tr>
                        </table> 	
                   
                        
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
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Documentos</h3>
            </div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="5%" bgcolor="#95A5A6">Código</th>
                          <th width="59%" bgcolor="#95A5A6">Título</th>
                          <th width="6%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                      </tr>
                    </thead>
                     <tbody>
                    <%
                    cont =0
					sql = "SELECT CODIGO, TITULO"
					sql = sql & " FROM SRH_DOCUMENTO"
					sql = sql & " where cod_empresa = " & Session("CodEmpresa")	
					
					if strMostraSomenteDeptoAtual = "S" then
					   SQL = SQL & " AND (cod_departamento=" & Session("CodDeptoUsuario") & " or cod_departamento is null)"
					end if   
					sql = sql & " Order by TITULO"
					
                    rs.open sql, cnn
                    if rs.eof = false then
                    
                    while not rs.eof
                        cont = cont + 1	
                    	%>
                        <tr>
                            <td><%=trim(rs("codigo"))%></td>
                            <td><%=trim(rs("titulo"))%></td>
                            <td align="center" >
                            <button class="btn-u btn-u-sea" onclick="resultadoConsulta(<%=trim(rs("codigo"))%>)" type="button"><i class="fa fa-file-text-o"></i></button>                            </td> 
                        </tr>
                    	<%				
                        rs.movenext
                        wend
                    end if
                    rs.close
                	%>
                    	<tr>
                    		<td colspan="5">Total Registros : <%=cont%></td>
                    	</tr>
                    </tbody>
                </table>
            </div>                      
        </div>
        <!--End Table Bordered-->	
        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
	<script>
        function dadosAluno(){
            if (mostraDadosAluno.style.display=="none"){
                mostraDadosAluno.style.display="block"
                frm.imgDadosAluno.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
            }
            else{
                mostraDadosAluno.style.display="none"
                frm.imgDadosAluno.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
            }
        }
        function dadosEscolares(){
            if (mostraDadosEscolares.style.display=="none"){
                mostraDadosEscolares.style.display="block"
                frm.imgDadosEscolares.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
            }
            else{
                mostraDadosEscolares.style.display="none"
                frm.imgDadosEscolares.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
            }
        }
        function dadosDataAtual(){
            if (mostraDadosDataAtual.style.display=="none"){
                mostraDadosDataAtual.style.display="block"
                frm.imgDadosDataAtual.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
            }
            else{
                mostraDadosDataAtual.style.display="none"
                frm.imgDadosDataAtual.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
            }
        }
        function dadosRepresentantes(){
            if (mostraDadosRepresentantes.style.display=="none"){
                mostraDadosRepresentantes.style.display="block"
                frm.imgDadosRepresentantes.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
            }
            else{
                mostraDadosRepresentantes.style.display="none"
                frm.imgDadosRepresentantes.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
            }
        }		
        function dadosVinculo(){
            if (mostradadosVinculo.style.display=="none"){
                mostradadosVinculo.style.display="block"
                frm.imgdadosVinculo.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
            }
            else{
                mostradadosVinculo.style.display="none"
                frm.imgdadosVinculo.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
            }
        }
        function dadosValidacao(){
            if (mostraDadosValidacao.style.display=="none"){
                mostraDadosValidacao.style.display="block"
                frm.imgDadosValidacao.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
            }
            else{
                mostraDadosValidacao.style.display="none"
                frm.imgDadosValidacao.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
            }
        }
        function mostraCampoInserir(linhacampo,marcou){
            if (marcou) {
                document.all[linhacampo].style.display="block";
            } else {
                document.all[linhacampo].style.display="none";
            }
        }
    
        function resultadoConsulta(intCodigo){
            frm.txtCodigo.value=intCodigo;
            frm.submit();
        }
    
        function salvar(acao){
            
            if (frm.txtTitulo.value == "") {
                alert("Titulo deve ser informado!");
                frm.txtTitulo.focus();
                return false;
            }
            
            if (frm.cmbDepartamento.value == "0") {
                alert("O departamento deve ser informado!");
                frm.cmbDepartamento.focus();
                return false;
            }
            
            frm.action="Documento_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
    </script>

    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 