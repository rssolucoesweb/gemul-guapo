<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<script type="text/javascript" src="../../js/js_funcoes_gerais.js"></script>
<!--=== Breadcrumbs ===-->
<div class="breadcrumbs">
  <div class="container">
    <h1 class="pull-left">Modulo Biblioteca</h1>
    <ul class="pull-right breadcrumb">
      <li><a href="Default.asp">Home</a></li>
      <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
    </ul>
  </div><!--/container-->
</div><!--/breadcrumbs-->
<!--=== End Breadcrumbs ===-->
<%
	strMostraArtigo	 		= ""
	strMostraExemplares		= ""
	strAlterarExemplares	= ""
	strPagina 				= "Publicacao_cad.asp"
	
	if request.QueryString("CodPublicacao") <> "" then
		intCodPublicacao 		= request.QueryString("CodPublicacao")
	else
		intCodPublicacao		= Trim(Request.Form("txtCodigo"))
	end if
	
	'Dados da Publicação
	
	intCodLocalizacaoGeografica = Trim(Request.Form("cmbLocalizacaoGeografica"))
	intCodTipoPublicacao		= Trim(Request.Form("cmbTipoPublicacao"))
	intCodAutoria				= Trim(Request.Form("cmbAutoria"))
	intCodEditora				= Trim(Request.Form("cmbEditora"))
	
	if trim(Trim(Request.Form("txtCodCDU"))) <> "" then
		intCodCDU 					= Trim(Request.Form("txtCodCDU"))
	else
		intCodCDU 					= Trim(Request.Form("cmbCDU"))
	end if
	
	strCodCutter				= Trim(Request.Form("txtCodCutter"))
	intCodPeriodicidade			= Trim(Request.Form("cmdPeriodicidade"))
	strInstituicao				= Trim(Request.Form("txtInstituicao"))
	strOrientador				= Trim(Request.Form("txtOrientador"))
	strCurso					= Trim(Request.Form("txtCurso"))
		
	strMesReferencia		= Trim(Request.Form("txtMesReferencia"))
	strSerie				= Trim(Request.Form("txtSerie"))
	strNota					= Trim(Request.Form("txtNota"))
	intCodTipoAquisicao		= Trim(Request.Form("cmbTipoAquisicao"))
	strNumeroNotaFiscal		= Trim(Request.Form("txtNumeroNotaFiscal"))
	strFornecedor			= Trim(Request.Form("txtFornecedor"))

	intCodGenero			= Trim(Request.Form("cmbGenero"))
	strTitulo 				= Trim(Request.Form("txtTitulo"))
	strSubTitulo 			= Trim(Request.Form("txtSubTitulo"))
	strLocalPublicacao		= Trim(Request.Form("txtLocalPublicacao"))
	intAno					= Trim(Request.Form("txtAno"))
	intCodEdicao			= Trim(Request.Form("cmbEdicao"))
	strVolume				= Trim(Request.Form("txtVolume"))
	strISBN					= Trim(Request.Form("txtISBN"))
	strISSN					= Trim(Request.Form("txtISSN"))
	strDataInclusao			= Trim(Request.Form("txtDataInclusao"))
	strEtiqueta				= Trim(Request.Form("cmbEtiqueta"))
	intPaginas				= Trim(Request.Form("txtPaginas"))
	strOrigem				= Trim(Request.Form("txtOrigem"))
	strDestino				= Trim(Request.Form("txtDestino"))
	srtResumo				= Trim(Request.Form("txtResumo"))
	
	'Dados Complementares
	strDataContrato			= Trim(Request.Form("txtDataContrato"))
	strContato				= Trim(Request.Form("txtContato"))
	strEndereco				= Trim(Request.Form("txtEndereco"))
	strBairro				= Trim(Request.Form("txtBairro"))
	strCidade				= Trim(Request.Form("txtCidade"))
	strUF					= Trim(Request.Form("txtUF"))
	strCep					= Trim(Request.Form("txtCep"))
	strNumero				= Trim(Request.Form("txtNumero"))
	strEmail				= Trim(Request.Form("txtEmail"))
	
	'Dados Exemplares
	intQtdeExemplares		= Trim(Request.Form("txtQtdeExemplares"))
	
	strDataInclusao			= formataDataAP(date)
	strEtiqueta				= "N"
		
	if trim(intCodPublicacao) <> "" then
	
		sql = "SELECT Cod_Publicacao, Cod_TipoPublicacao, Cod_Autoria, Cod_Editora, Cod_CDU, Cod_Cutter, Cod_Periodicidade, "
		sql = sql & " Instituicao, Orientador, Curso, MesReferencia, Serie, Nota, CodTipoAquisicao, NumeroNotaFiscal, Fornecedor, CodGenero, "
		sql = sql & " Titulo, SubTitulo, LocalPublicacao, AnoPublicacao, EdicaoPublicacao, VolumePublicacao, ISBN, ISSN, DataInclusao, Etiqueta, "
		sql = sql & " NumPaginas, Origem, Destino, Resumo, DataContrato, Contato, Endereco, Bairro, Cidade, UF, CEP, Numero, Email, Cod_LocalizacaoGeografica"
		sql = sql & " FROM SCB_PUBLICACAO"
		sql = sql & " Where Cod_Publicacao = " & intCodPublicacao
		sql = sql & " And Cod_empresa = " & session("codEmpresa")
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodLocalizacaoGeografica = rs("Cod_LocalizacaoGeografica")	
			intCodPublicacao			= rs("Cod_Publicacao")
			intCodTipoPublicacao		= rs("Cod_TipoPublicacao")
			intCodAutoria				= rs("Cod_Autoria")
			intCodEditora				= rs("Cod_Editora")

			if trim(Trim(Request.Form("txtCodCDU"))) = "0" then
			   intCodCDU 					= rs("Cod_CDU")
			end if   

			strCodCutter				= rs("Cod_Cutter")
			intCodPeriodicidade			= rs("Cod_Periodicidade")
			strInstituicao				= rs("Instituicao")	
			strOrientador				= rs("Orientador")	
			strCurso					= rs("Curso")
			strMesReferencia			= rs("MesReferencia")
			strSerie					= rs("Serie")
			strNota						= rs("Nota")
			intCodTipoAquisicao			= rs("CodTipoAquisicao")
			strNumeroNotaFiscal			= rs("NumeroNotaFiscal") 
			strFornecedor				= rs("Fornecedor") 

			intCodGenero				= rs("CodGenero")
			strTitulo 					= rs("Titulo")
			strSubTitulo 				= rs("SubTitulo")
			strLocalPublicacao			= rs("LocalPublicacao")
			intAno						= rs("AnoPublicacao")
			intCodEdicao				= rs("EdicaoPublicacao")
			strVolume					= rs("VolumePublicacao")
			strISBN						= rs("ISBN")
			strISSN						= rs("ISSN")	
			strDataInclusao				= formatadataAP(rs("DataInclusao"))
			strEtiqueta					= rs("Etiqueta")
			intPaginas					= rs("NumPaginas")
			strOrigem					= rs("Origem")
			strDestino					= rs("Destino")
			strResumo					= rs("Resumo")
			
			strDataContrato				= formatadataAP(rs("DataContrato"))
			strContato					= rs("Contato")
			strEndereco					= rs("Endereco")
			strBairro					= rs("Bairro")
			strCidade					= rs("Cidade")
			strUF						= rs("UF")
			strCep						= rs("CEP")
			strNumero					= rs("Numero")
			strEmail					= rs("Email")
			
			' Consulta os Autores
			sql = " SELECT SCB_PUBLICACAOAUTORES.Cod_Autor, SCB_AUTORES.Nome_Autor "
			sql = sql & " FROM SCB_PUBLICACAOAUTORES INNER JOIN SCB_AUTORES "
			sql = sql & " ON (SCB_PUBLICACAOAUTORES.Cod_Autor = SCB_AUTORES.Cod_Autor) "
			sql = sql & " WHERE SCB_PUBLICACAOAUTORES.Cod_Publicacao = " & intCodPublicacao
			rsAux.open sql, cnn		
			
			if rsAux.eof = false then
				
				while not rsAux.eof
				
					if trim(strDescAutor) = "" then
						strDescAutor	= rsAux("Nome_Autor")
						intCodAutor		= rsAux("Cod_Autor")
					else
						intCodAutor		= intCodAutor & " , " & rsAux("Cod_Autor")
						strDescAutor	= strDescAutor & " | " & rsAux("Nome_Autor")
					end if
					rsAux.movenext
			
				wend
			end if
			rsAux.close
					
			' Consulta Palavra Chave
			sql = " SELECT SCB_PUBLICACAOPALAVRACHAVE.Cod_PalavraChave, SCB_PalavraChave.Nome_Palavra " 
			sql = sql & " FROM SCB_PUBLICACAOPALAVRACHAVE INNER JOIN SCB_PalavraChave "
			sql = sql & " ON (SCB_PUBLICACAOPALAVRACHAVE.Cod_PalavraChave = SCB_PalavraChave.Cod_Palavra)  "
			sql = sql & " WHERE SCB_PUBLICACAOPALAVRACHAVE.Cod_Publicacao = " & intCodPublicacao
			rsAux.open sql, cnn		
			
			if rsAux.eof = false then
				
				while not rsAux.eof
				
					if trim(strDescPalavra) = "" then
						intCodPalavra		= rsAux("Cod_PalavraChave")
						strDescPalavra		= rsAux("Nome_Palavra")
					else
						intCodPalavra		= intCodPalavra & " , " & rsAux("Cod_PalavraChave")
						strDescPalavra		= strDescPalavra & " | " & rsAux("Nome_Palavra")
					end if
					rsAux.movenext
			
				wend
			end if
			rsAux.close
			
			' quantidade de exemplares
			sql = " SELECT count(Cod_PublicacaoExemplares) AS qtde "
			sql = sql & " FROM SCB_PUBLICACAOEXEMPLARES "
			sql = sql & " WHERE Cod_Publicacao = " & intCodPublicacao
			rsAux.open sql, cnn		
			intTotalExemplares = 0
			
			if rsAux.eof = false then
				intTotalExemplares = rsAux("qtde")
			end if
			rsAux.close			
			
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			
			if intCodPeriodicidade <> 0 then
				strDesabilitaArtigo	= "" 'Desabilita o botão Periodico
			else
				strDesabilitaArtigo	= "disabled" 'Desabilita o botão Periodico
			end if
		
		else
		
			strDataInclusao			= formataDataAP(date)
			strEtiqueta				= "N"
			
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaArtigo		= "disabled" 'Desabilita o botão Excluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExemplares = "" 'Desabilita o botão Excluir


		end if 
		rs.close

	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaArtigo		= "disabled" 'Desabilita o botão Excluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExemplares = "disabled" 'Desabilita o botão Excluir
	end if 
	
	if intCodPublicacao = "" then intCodPublicacao = 0
	if intCodAutoria = "" then  intCodAutoria = 0
	if intCodEditora = "" then  intCodEditora = 0
	if intCodCDU = "" then  intCodCDU = 0
	if intCodTipoAquisicao = "" then  intCodTipoAquisicao = 0
%>
<!--=== Content Part ===-->
<div class="container content">
  <!-- Grey Panel -->
  <div class="panel panel-grey">
    <div class="panel-heading">
      <h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Publicação</h3>
    </div>
    <!-- Inicia o Painel do Formulario -->
    <div class="panel-body">
      <!-- Inicia o Form -->
      <div class="panel-body">
        <form id="frm" method="post">

          <input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">

          <div class="headline"><h2>Consulta Publicação</h2></div>

          <div class="row">
            <div class="col-lg-4 col-md-4">
              <label>Consulta Registro</label>
              <div class="form-group">
                <ul class="list-inline">
                  <li>
                    <input name="txtCodigo" id="txtCodigo" onKeyPress="return formataCampo(this,2,10)" class="form-control" value="<%=intCodPublicacao%>" maxlength="5" onChange="submit()">
                  </li>
                  <li>
                    <button style="display: inline-block;" class="btn-u btn-u-green" onClick="return abreConsulta('Publicacao_con.asp')" type="button"><i class="fa fa-search"></i></button>
                  </li>
                </ul>
              </div>
            </div>
          </div>
          <p>- Obs: Para gerar uma replicação de registro basta carregar o registro a ser replicado e esvaziar o campo acima marcado com (*), clicando em seguida no botão incluir.</p>

          <div class="headline"><h2>Dados Publica&ccedil;&atilde;o </h2></div>

          <div class="row">
            <div class="col-lg-4 col-md-4">
              <label for="localizacaoGeografica">Localiza&ccedil;&atilde;o Geográfica:</label>
              <div class="form-group">
                <!--#include file="../includes/inc_cmbLocalizacaoGeografica.asp" -->
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-4 col-md-4">
              <label for="tipoPublicacao">Tipo Publica&ccedil;&atilde;o</label>
              <div class="form-group">
                <!--#include file="../includes/inc_cmdTipoPublicacao.asp" -->
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-4 col-md-4">
              <label>Autoria</label>
              <div class="form-group">
                <ul class="list-inline">
                  <li>
                    <!--#include file="../includes/inc_cmdAutoria.asp" -->
                  </li>
                  <li>
                    <button class="btn-u btn-u-green" style="display: inline-block;" onClick="return abreConsulta('Autoria_cad.asp')" type="button"><i class="fa fa-plus"></i></button>
                  </li>
                </ul>
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-4 col-md-4">
              <label>Editora</label>
              <div class="form-group">
                <ul class="list-inline">
                  <li>
                    <!--#include file="../includes/inc_cmdEditora.asp" -->
                  </li>
                  <li>
                    <button class="btn-u btn-u-green" style="display: inline-block;" onClick="return abreConsulta('Editora_cad.asp')" type="button"><i class="fa fa-plus"></i></button>
                  </li>
                </ul>
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-6 col-md-6">
              <label for="instituicao">Institui&ccedil;&atilde;o:</label><br>
              <div class="form-group">
                <input name="txtInstituicao" type="text" class="form-control" id="txtInstituicao" maxlength="100" value="<%=strInstituicao%>">
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-6 col-md-6">
              <label for="orientador">Orientador(a):</label><br>
              <div class="form-group">
                <input name="txtOrientador" type="text" class="form-control" id="txtOrientador" maxlength="100" value="<%=strOrientador%>">
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-6 col-md-6">
              <label for="curso">Curso</label><br>
              <div class="form-group">
                <input name="txtCurso" type="text" class="form-control" id="txtCurso" maxlength="100" value="<%=strCurso%>">
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-4 col-md-4">
              <label for="tipoAquisicao">Tipo de Aquisi&ccedil;&atilde;o</label><br>
              <div class="form-group">
                <!--#include file="../includes/inc_cmdTipoAquisicao.asp" -->
              </div>
            </div>
          </div>


          <%if intCodTipoAquisicao =  1 then%>
          <div class="row">
            <div class="col-lg-4 col-md-4">
              <label for="numeroNotaFiscal">N&uacute;mero Nota Fiscal</label><br>
              <div class="form-group">
                <input name="txtNumeroNotaFiscal" type="text" class="form-control" id="txtNumeroNotaFiscal"  maxlength="13" value="<%=strNumeroNotaFiscal%>">
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-4 col-md-4">
              <div class="form-group">
                <label for="fornecedor">Fornecedor</label><br>
                <input name="txtFornecedor" type="text" class="form-control" id="txtFornecedor" maxlength="40" value="<%=strFornecedor%>">
              </div>
            </div>
          </div>
          <%end if%>

          <div class="row">
            <div class="col-lg-6 col-md-6">
              <label>CDU</label>
              <div class="form-group">
                <ul class="list-inline">
                  <li>
                    <input name="txtCodCDU" type="text" id="txtCodCDU" class="form-control" style="width:50pt" value="<%=intCodCDU%>" maxlength="20" onBlur="ListaCDU()">
                  </li>
                  <li>
                    <!--#include file="../includes/inc_cmdCDU.asp" -->
                  </li>
                  <li>
                    <button class="btn-u btn-u-green" onClick="return abreConsulta('Cdu_cad.asp')" type="button"><i class="fa fa-plus"></i></button>
                  </li>
                </ul>
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-4 col-md-4">
              <label for="cutter">Cutter</label><br>
              <div class="form-group">
                <input name="txtCodCutter" type="text" class="form-control" id="txtCodCutter" maxlength="30" value="<%=strCodCutter%>">
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-4 col-md-4">
              <label for="periodicidade">Periodicidade</label><br>
              <div class="form-group">
                <!--#include file="../includes/inc_cmdPeriodicidade.asp" -->
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-4 col-md-4">
              <label for="mesReferencia">M&ecirc;s Refer&ecirc;ncia:</label><br>
              <div class="form-group">
                <input name="txtMesReferencia" type="text" style="width:250pt" class="form-control" id="txtMesReferencia" maxlength="40" value="<%=strMesReferencia%>">
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-4 col-md-4">
              <div class="form-group">
                <label for="genero">G&ecirc;nero:</label><br>
                <!--#include file="../includes/inc_cmdGenero.asp" -->
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-12 col-md-12">
              <label>Autores</label>
              <div class="form-group">
                <ul class="list-inline">
                  <li style="width: 350px">
                    <input name="txtCodAutor" type="hidden" class="form-control" id="txtCodAutor" value="<%=intCodAutor%>" onKeyPress="return formataCampo(this,2,10)" maxlength="8">
                    <input name="txtDescAutor" type="text" class="form-control" id="txtDescAutor" maxlength="50" value="<%=strDescAutor%>" readonly />
                  </li>
                  <li>
                    <button class="btn-u btn-u-green" onClick="return abreConsulta('Autores_con.asp?CodPublicacao=<%=intCodPublicacao%>')" type="button"><i class="fa fa-search"></i></button>
                  </li>
                  <li>
                  <button class="btn-u btn-u-green" onClick="return abreConsulta('Autores_cad.asp')" type="button"><i class="fa fa-plus"></i></button>
                  </li>
                </ul>
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-12 col-md-12">
              <label>Palavra Chave</label>
              <div class="form-group">
                <ul class="list-inline">
                  <li style="width: 350px">
                    <input name="txtCodPalavra" type="hidden" class="form-control" id="txtCodPalavra" value="<%=intCodPalavra%>" size="8" onKeyPress="return formataCampo(this,2,10)" maxlength="8">
                    <input name="txtDescPalavra" type="text" class="form-control" id="txtDescPalavra" maxlength="50" value="<%=strDescPalavra%>" readonly />
                  </li>
                  <li>
                    <button class="btn-u btn-u-green" onClick="return abreConsulta('PalavraChave_con.asp?CodPublicacao=<%=intCodPublicacao%>')" type="button"><i class="fa fa-search"></i></button>
                  </li>
                  <li>
                    <button class="btn-u btn-u-green" onClick="return abreConsulta('PalavraChave_cad.asp')" type="button"><i class="fa fa-plus"></i></button>
                  </li>
                </ul>
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-6 col-md-6">
              <label for="titulo">Titulo</label><br>
              <div class="form-group">
                <input name="txtTitulo" type="text" class="form-control" id="txtTitulo" maxlength="120" value="<%=strTitulo%>">
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-6 col-md-6">
              <label for="subTitulo">Sub Titulo</label><br>
              <div class="form-group">
                <input name="txtSubTitulo" type="text" class="form-control" id="txtSubTitulo" maxlength="120" value="<%=strSubTitulo%>">
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-3 col-md-3">
              <label for="localPublicacao">Local Publica&ccedil;&atilde;o</label><br>
              <div class="form-group">
                <input name="txtLocalPublicacao" type="text" class="form-control" id="txtLocalPublicacao" maxlength="30" value="<%=strLocalPublicacao%>">
              </div>
            </div>
            <div class="col-lg-3 col-md-3">
              <label for="anoPublicacao">Ano Publica&ccedil;&atilde;o</label><br>
              <div class="form-group">
                <input  name="txtAno" type="text" class="form-control" id="txtAno" onKeyPress="return formataCampo(this,2,10)"  value="<%=intAno%>" maxlength="5">
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-3 col-md-3">
              <label for="edicao">Edi&ccedil;&atilde;o</label><br>
              <div class="form-group">
                <!--#include file="../includes/inc_cmdEdicao.asp" -->
              </div>
            </div>
            <div class="col-lg-3 col-md-3">
              <label for="volume">Volume</label><br>
              <div class="form-group">
                <input name="txtVolume" type="text" class="form-control" id="txtVolume" maxlength="11" value="<%=strVolume%>">
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-3 col-md-3">
              <label for="isbn">ISBN</label><br>
              <div class="form-group">
                <input name="txtISBN" type="text" class="form-control" id="txtISBN" maxlength="13" value="<%=strISBN%>">
              </div>
            </div>
            <div class="col-lg-3 col-md-3">
              <label for="serie"> S&eacute;rie</label><br>
              <div class="form-group">
                <input name="txtSerie" type="text" class="form-control" id="txtSerie" maxlength="13" value="<%=strSerie%>">
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-3 col-md-3">
              <label for="issn">ISSN</label><br>
              <div class="form-group">
                <input name="txtISSN" type="text" class="form-control" id="txtISSN" maxlength="13" value="<%=strISSN%>">
              </div>
            </div>
            <div class="col-lg-3 col-md-3">
              <label for="dataInclusao">Data Inclus&atilde;o</label><br>
              <div class="form-group">
                <input name="txtDataInclusao" type="text" class="form-control" id="txtDataInclusao" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" maxlength="10" value="<%=strDataInclusao%>">
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-3 col-md-3">
              <label for="etiquetasImpressas">Etiquetas j&aacute; impressas</label><br>
              <div class="form-group">
                <!--#include file="../includes/inc_cmdEtiqueta.asp" -->
              </div>
            </div>
            <div class="col-lg-3 col-md-3">
              <div class="form-group">
                <label for="numeroPaginas">N. Paginas </label><br>
                <input  name="txtPaginas" type="text" class="form-control" id="txtPaginas"  value="<%=intPaginas%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-3 col-md-3">
              <label for="origem">Origem </label><br>
              <div class="form-group">
                <input name="txtOrigem" type="text" class="form-control" id="txtOrigem" size="30" maxlength="30" value="<%=strOrigem%>">
              </div>
            </div>
            <div class="col-lg-3 col-md-3">
              <label for="destino">Destino </label><br>
              <div class="form-group">
                <input name="txtDestino" type="text" class="form-control" id="txtDestino" size="30" maxlength="30" value="<%=strDestino%>">
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-6 col-md-6">
              <label for="resumo">Resumo </label><br>
              <div class="form-group">
                <textarea name="txtResumo" cols="60" rows="5" class="form-control" id="txtResumo"> <%=strResumo%> </textarea>
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-6 col-md-6">
              <label for="notas">Notas </label><br>
              <div class="form-group">
                <textarea name="txtNota" cols="60" rows="5" class="form-control" id="txtNota"><%=strNota%></textarea>
              </div>
            </div>
          </div>

          <div class="headline"><h2>Dados Complementares</h2></div>

          <div class="row">
            <div class="col-lg-3 col-md-3">
              <label for="dataContrato">Data Contrato </label><br>
              <div class="form-group">
                <input name="txtDataContrato" type="text" class="form-control" id="txtDataContrato" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataContrato%>">
              </div>
            </div>
            <div class="col-lg-3 col-md-3">
              <label for="contato">Contato </label><br>
              <div class="form-group">
                <input name="txtContato" type="text" class="form-control" id="txtContato" size="30" maxlength="30" value="<%=strContato%>">
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-3 col-md-3">
              <label for="endereco">Endere&ccedil;o </label><br>
              <div class="form-group">
                <input name="txtEndereco" type="text" class="form-control" id="txtEndereco" maxlength="30" value="<%=strEndereco%>">
              </div>
            </div>
            <div class="col-lg-3 col-md-3">
              <div class="form-group">
                <label for="bairro">Bairro </label><br>
                <input name="txtBairro" type="text" class="form-control" id="txtBairro" maxlength="30" value="<%=strBairro%>">
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-3 col-md-3">
              <label for="cidade">Cidade </label><br>
              <div class="form-group">
                <input name="txtCidade" type="text" class="form-control" id="txtCidade" maxlength="30" value="<%=strCidade%>">
              </div>
            </div>
            <div class="col-lg-3 col-md-3">
              <label for="uf">UF </label><br>
              <div class="form-group">
                <input name="txtUF" type="text" class="form-control" id="txtUF" maxlength="5" value="<%=strUF%>">
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-3 col-md-3">
              <label for="cep">Cep </label><br>
              <div class="form-group">
                <input name="txtCep" type="text" class="form-control" id="txtCep" maxlength="15" value="<%=strCep%>">
              </div>
            </div>
            <div class="col-lg-3 col-md-3">
              <label for="numero">Numero </label><br>
              <div class="form-group">
                <input name="txtNumero" type="text" class="form-control" id="txtNumero" maxlength="15" value="<%=strNumero%>">
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-6 col-md-6">
              <label for="email">Email </label><br>
              <div class="form-group">
                <input name="txtEmail" type="text" class="form-control" id="txtEmail" maxlength="30" value="<%=strEmail%>">
              </div>
            </div>
          </div>

          <div class="headline"><h2>Dados Exemplares</h2></div>

          <div class="row">
            <div class="col-lg-3 col-md-3">
              <label for="novosExemplares">Novos Exemplares </label><br>
              <div class="form-group">
                <input  name="txtQtdeExemplares" type="text" class="form-control" id="txtQtdeExemplares"  value="<%=intQtdeExemplares%>" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
              </div>
            </div>
            <div class="col-lg-3 col-md-3">
              <label for="qtdeExemplares">Qtde Exemplares  </label><br>
              <div class="form-group">
                <input disabled="disabled"  name="txtQtdeExemplares2" type="text" class="form-control" id="txtQtdeExemplares2"  value="<%=intTotalExemplares%>" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-3 col-md-3">
              <label for="bloqueioUltimoExemplar">Bloq. Ultimo Exemplar </label><br>
              <div class="form-group">
                <select  name="cmbBloqueiaUltimoExemplar" class="form-control" id="cmbBloqueiaUltimoExemplar">
                  <option value="S" <%if strAtendimentoespecial = "S" then response.Write("selected") %>>Sim</option>
                  <option  selected  value="N" <%if strAtendimentoespecial = "N" then response.Write("selected") %>>N&atilde;o</option>
                </select>
              </div>
            </div>
          </div>
          <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
        </form>
      </div>
    </div>
    <!-- Fecha o Form -->
  </div>
  <!--/container-->
  <!--Table Bordered-->
  <div class="panel panel-grey margin-bottom-40">
    <div class="panel-heading">
      <h3 class="panel-title"><i class="fa fa-globe"></i>Lista de Exemplares </h3>
    </div>
    <div class="panel-body">
      <table class="table table-bordered">
        <thead>
          <tr>
            <th width="5%" bgcolor="#95A5A6">Ordem</th>
            <th width="86%" bgcolor="#95A5A6">N. Registro</th>
            <th width="86%" bgcolor="#95A5A6">Exemplar</th>
            <th width="86%" bgcolor="#95A5A6">T&iacute;tulo</th>
            <th width="86%" bgcolor="#95A5A6">Localiza&ccedil;&atilde;o</th>
            <th width="86%" bgcolor="#95A5A6">Situa&ccedil;&atilde;o</th>
            <th width="86%" bgcolor="#95A5A6">Empr&eacute;stimo</th>
          </tr>
        </thead>
		  <%
            if intCodPublicacao <> 0 then 
                cont =0
                
                sql = " Select PE.Cod_Publicacao, PE.Cod_PublicacaoExemplares, "
                sql = sql & " P.Titulo, PE.Cod_SituacaoExemplar, "
                sql = sql & " LG.descricao AS localizacao, "
                sql = sql & " SE.Descricao, SE.Situacao, PE.Data_Devolucao"
                sql = sql & " From SCB_PUBLICACAO P "
                sql = sql & " inner join SCB_PUBLICACAOEXEMPLARES PE on PE.Cod_Publicacao = P.Cod_Publicacao "
                sql = sql & " left join SCB_SITUACAOEXEMPLAR SE on SE.Codigo = PE.Cod_SituacaoExemplar "
                sql = sql & " left join SCB_LOCALIZACAOGEOGRAFICA LG on LG.Codigo = PE.Cod_LocalizacaoGeografica "
                sql = sql & " Where P.Cod_Publicacao = " & intCodPublicacao
                sql = sql & " And P.Cod_Empresa = " & session("codEmpresa")
                rs.open sql, cnn
                
                if rs.eof = false then
                
                    while not rs.eof
                        cont = cont + 1	
                        selecionado = ""
                        
                        if trim(rs("Situacao")) = "A" then
                            strSituacao = "Ativo"
                        else
                            strSituacao = "Inativo"
                        end if	
                        
                        if not isnull(rs("Data_Devolucao")) then
                           strSituacao = "Emprestado" & " Devolver:" & formataDataAP(rs("Data_Devolucao"))
                           strCorSituacao = "#FF0000"
                        else
                           strSituacao	= "Disponível"   
                           strCorSituacao = "#000000"
                        end if   
                        
                        %>
        <tbody>
          <tr>
            <td><%=cont%></td>
            <td><%=trim(rs("Cod_Publicacao"))%></td>
            <td><%=trim(rs("Cod_PublicacaoExemplares"))%></td>
            <td><%=trim(rs("Titulo"))%></td>
            <td><%=trim(rs("localizacao"))%></td>
            <td><%=trim(rs("Descricao"))%>-<%=trim(strSituacao)%></td>
            <td><%=strSituacao%></td>
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
  <!--End Table Bordered-->
  <!-- Fecha o Painel do Formulario -->
</div>
</div>
<!--/container-->
<script>

	function abreConsulta(caminho){
		window.open(caminho,"abreConsulta","top=5,left=5,height=650,width=700,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}	
	
	function ListaCDU(){
		frm.txtCodCDU.value=frm.txtCodCDU.value;
		frm.submit();
	}
	
	function resultadoConsulta(intCodigo){
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	function abreArtigo(){
		window.open("PublicacaoArtigo_cad.asp?CodPublicacao="+frm.txtCodigo.value + "&Titulo="+frm.txtTitulo.value,"consulta", "top=0,left=0,height=510,width=550,menubar=no,toolbar=no,scrollbars=yes,status=yes");
		return true;
	}
	
	function abreExemplares(){
		window.open("PublicacaoExemplar_cad.asp?CodPublicacao="+frm.txtCodigo.value,"consulta", "top=0,left=0,height=510,width=700,menubar=no,toolbar=no,scrollbars=yes,status=yes");
		return true;
	}
	
	function AlterarExemplares(){
		window.open("PublicacaoAlterarExemplar_cad.asp?CodPublicacao="+frm.txtCodigo.value,"consulta", "top=0,left=0,height=510,width=700,menubar=no,toolbar=no,scrollbars=yes,status=yes");
		return true;
	}
	
	function ConsultaPublicacao()
	{
		window.open('Publicacao_con.asp','ConsultaExemplares','top=0,left=0,height=510,width=800,menubar=no,toolbar=no,scrollbars=yes,status=yes');
	}

	function salvar(acao){
			
		if (frm.cmbTipoPublicacao.value == "0") {
			alert("O Tipo Publicação deve ser informado !");
			frm.cmbTipoPublicacao.focus();
			return false;
		}

		if (frm.cmbPeriodicidade.value == "0") {
			alert("A Periodicidade deve ser informada !");
			frm.cmbPeriodicidade.focus();
			return false;
		}
		
		if (frm.cmbAutoria.value == "0") {
			alert("A Autoria deve ser informada !");
			frm.cmbAutoria.focus();
			return false;
		}
		
		if (frm.cmbEditora.value == "0") {
			alert("A Editora deve ser informada !");
			frm.cmbEditora.focus();
			return false;
		}
		
		if (frm.cmbCDU.value == "0") {
			alert("O CDU deve ser informado !");
			frm.cmbCDU.focus();
			return false;
		}
		
		if (frm.txtDescAutor.value == "") {
			alert("O Autor deve ser informado !");
			frm.txtDescAutor.focus();
			return false;
		}
		
		if (frm.txtDescPalavra.value == "") {
			alert("A Palavra Chave deve ser informada !");
			frm.txtDescPalavra.focus();
			return false;
		}
		
		if (frm.txtTitulo.value == "") {
			alert("O Titulo deve ser informado !");
			frm.txtTitulo.focus();
			return false;
		}
		
		if (frm.txtLocalPublicacao.value == "") {
			alert("O Local de Publicação deve ser informado !");
			frm.txtLocalPublicacao.focus();
			return false;
		}
				
		if (frm.txtAno.value == "") {
			alert("O Ano deve ser informado !");
			frm.txtAno.focus();
			return false;
		}
		
		if (frm.txtDataInclusao.value == "") {
			alert("A Data de Inclusão deve ser informada !");
			frm.txtDataInclusao.focus();
			return false;
		}
		
		if (frm.cmbEtiqueta.value == "0") {
			alert("A Etiqueta deve ser informada !");
			frm.cmbEtiqueta.focus();
			return false;
		}
		
		if (frm.txtPaginas.value == "") {
			alert("O Número de Paginas deve ser informado !");
			frm.txtPaginas.focus();
			return false;
		}
		
		if (acao=="I") {
			if (frm.txtQtdeExemplares.value == "") {
				alert("A Qtde de Exemplares deve ser informado !");
				frm.txtQtdeExemplares.focus();
				return false;
			}
		}
				
		frm.action="Publicacao_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<!--=== End Content Part ===-->
<!--#include file="../RodapeModulo.asp"-->
<!--#include file="../jsModulo.asp"-->
</body>
</html>
