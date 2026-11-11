<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8"> <![endif]-->
<!--[if IE 9]> <html lang="en" class="ie9"> <![endif]-->
<!--[if !IE]><!--> <html lang="pt-br"> <!--<![endif]--><head>
    <title>:: Gemul - Gestor de Município :: </title>

    <!-- Meta -->
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=10, IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <!-- Favicon -->
    <link rel="shortcut icon" href="favicon.ico">

    <!-- CSS Global Compulsory -->
    <link rel="stylesheet" href="../../assets/plugins/bootstrap/css/bootstrap.css">
    <link rel="stylesheet" href="../../assets/css/style.css">
    
    <!-- CSS Implementing Plugins -->
    <link rel="stylesheet" href="../../assets/plugins/line-icons/line-icons.css">
    <link rel="stylesheet" href="../../assets/plugins/font-awesome/css/font-awesome.min.css">
    <link rel="stylesheet" href="../../assets/plugins/flexslider/flexslider.css">  
    <link rel="stylesheet" href="../../assets/plugins/ladda-buttons/css/custom-lada-btn.css">
    <link rel="stylesheet" href="../../assets/plugins/sky-forms/version-2.0.1/css/custom-sky-forms.css">
	<link rel="stylesheet" href="../../assets/css/plugins/hover-effect/css/custom-hover-effects.css"> 
	<style>
		.margin-bottom-30 {
		margin-left: 30px;
		}
		.pointer {cursor: pointer;}
		.tamanho9 { font-size: 9px; }
		.tamanho11 { font-size: 11px; }
	</style>
<!--#include file="../../includes/inc_cnndocumento.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->

<!-- menu -->
    <!--=== Header ===-->
    <div class="header">
    	<!-- Topbar -->
        <div class="topbar">
            <div class="container">
                <!-- Topbar Navigation -->
                <!-- Navbar -->
        <div class="navbar navbar-default mega-menu" role="navigation">
            <div class="container">
                <!-- Brand and toggle get grouped for better mobile display -->
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-responsive-collapse">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="fa fa-bars"></span>
                    </button>
                    <a class="navbar-brand" href="Default.asp">
                        <img id="logo-header" src="../../assets/img/logo1.png" alt="Logo">
                    </a>
                </div>
                <!-- Collect the nav links, forms, and other content for toggling -->
                <div class="collapse navbar-collapse navbar-responsive-collapse">
                    <ul class="nav navbar-nav">
                        <!-- Menu -->
                        <!--#include file="../../includes/inc_validaPermissao.asp"-->
						<%
						
						strNomeSistema 	= Session("strNomeSistema") 	
						Sistema 		= Session("strSistema") 
						Modulo 			= Session("strModulo") 
						
						'select para contar a quantidade de menus que ir� existir
						strPerfil =  validaPermissao(session("usuarioweb"), Sistema)
						
						if  session("CodCategoriaExcessoes") = "1" then 
							strPerfil =  "11"
						end if
						if  Session("Seg_Perfil") <> "" and Session("Seg_Perfil") <> "0" then 
							strPerfil =  Session("Seg_Perfil")
						end if
						
						contMenu = 0 
						
						'carrega menu do sistema
						sql = "SELECT DISTINCT SEG_MENUS_SISTEMA.MENU_DESC,  SEG_MENUS_SISTEMA.MENU_NUMR_POSICAO, SEG_MENUS_SISTEMA.MENU_CODG "
						sql = sql & " FROM SEG_MENUS_SISTEMA INNER JOIN (SEG_ITENS_SISTEMA INNER JOIN SEG_PERFIS_ITENS_SISTEMA ON SEG_ITENS_SISTEMA.ITEM_CODG = SEG_PERFIS_ITENS_SISTEMA.PITE_ITEM_CODG) ON (SEG_MENUS_SISTEMA.MENU_SIST_SIGL = SEG_ITENS_SISTEMA.ITEM_SIST_SIGL) AND (SEG_MENUS_SISTEMA.MENU_MODU_SIGL = SEG_ITENS_SISTEMA.ITEM_MENU_MODU_SIGL) AND (SEG_MENUS_SISTEMA.MENU_CODG = SEG_ITENS_SISTEMA.ITEM_MENU_CODG) "
						sql = sql & " WHERE     (SEG_PERFIS_ITENS_SISTEMA.PITE_PERF_CODG in (" & strPerfil &")) "
						sql = sql & " AND (SEG_MENUS_SISTEMA.MENU_SIST_SIGL = '" & Sistema & "')"
						sql = sql & " AND SEG_MENUS_SISTEMA.MENU_MODU_SIGL = '"& Modulo & "'"
						sql = sql & " AND SEG_MENUS_SISTEMA.SITUACAO = 'A'"
						sql = sql & " AND SEG_ITENS_SISTEMA.ITEM_STAT='A' "
						sql = sql & "  AND SEG_MENUS_SISTEMA.MENU_DESC <> 'Sair'"
						sql = sql & "  ORDER BY SEG_MENUS_SISTEMA.MENU_NUMR_POSICAO"
						rs.open sql, cnn
						if rs.eof then
							rs.close
							%>
							<script>
								//alert("Usu�rio sem permiss�es no sistema!"); 
								//window.history.back();
							</script>
							 <%
						 ' response.End()
						else
							while not rs.eof
								
								contMenu = contMenu + 1
								
								if Trim(rs("MENU_CODG")) = "29" then 
									strAtivaMenu = "class='dropdown active'"
								else
									strAtivaMenu = "class='dropdown'"
								end if
							%>
                            <li <%=strAtivaMenu%>>
                                <a href="javascript:void(0);" class="dropdown-toggle" data-toggle="dropdown"><%=trim(rs("MENU_DESC"))%></a>
                                <ul class="dropdown-menu">
                                	
                                    <%
									'carrega sub menu do sistema
									cont = 0 
									
									sql = "SELECT SEG_ITENS_SISTEMA.ITEM_DESC, SEG_ITENS_SISTEMA.ITEM_INFO_URL, SEG_ITENS_SISTEMA.ITEM_NUMR_POSICAO, SEG_MENUS_SISTEMA.MENU_NUMR_POSICAO, SEG_MENUS_SISTEMA.MENU_DESC "
									sql = sql & " FROM SEG_MENUS_SISTEMA INNER JOIN (SEG_PERFIS_SISTEMA INNER JOIN (SEG_ITENS_SISTEMA INNER JOIN SEG_PERFIS_ITENS_SISTEMA ON SEG_ITENS_SISTEMA.ITEM_CODG = SEG_PERFIS_ITENS_SISTEMA.PITE_ITEM_CODG) ON SEG_PERFIS_SISTEMA.PERF_CODG = SEG_PERFIS_ITENS_SISTEMA.PITE_PERF_CODG) ON SEG_MENUS_SISTEMA.MENU_CODG = SEG_ITENS_SISTEMA.ITEM_MENU_CODG "
									sql = sql & " WHERE (((SEG_PERFIS_SISTEMA.PERF_CODG) In (" & strPerfil &")) "
									sql = sql & " AND SEG_ITENS_SISTEMA.ITEM_STAT='A' "
									sql = sql & " AND ((SEG_ITENS_SISTEMA.ITEM_SIST_SIGL)='"& Sistema & "') "
									sql = sql & " AND ((SEG_ITENS_SISTEMA.ITEM_MENU_MODU_SIGL)='" & Modulo & "')) "
									sql = sql & " AND ((SEG_MENUS_SISTEMA.MENU_DESC) ='" & trim(rs("MENU_DESC")) & "')"
									sql = sql & " GROUP BY SEG_ITENS_SISTEMA.ITEM_DESC, SEG_ITENS_SISTEMA.ITEM_INFO_URL, SEG_ITENS_SISTEMA.ITEM_NUMR_POSICAO, SEG_MENUS_SISTEMA.MENU_NUMR_POSICAO, SEG_MENUS_SISTEMA.MENU_DESC "
									'sql = sql & " ORDER BY SEG_ITENS_SISTEMA.ITEM_NUMR_POSICAO, SEG_ITENS_SISTEMA.ITEM_DESC "
									sql = sql & " ORDER BY SEG_MENUS_SISTEMA.MENU_NUMR_POSICAO, SEG_ITENS_SISTEMA.ITEM_DESC"
									strMenuDesc = ""
									rsAux.open sql, cnn
									if not rsAux.eof then
									while not rsAux.eof
										cont = cont + 1
										
										if rsAux("ITEM_INFO_URL") = "frequenciaColaborador_cad.asp" then 
											strAtiva = "class='active'"
										else
											strAtiva = ""
										end if
										%>
                                        	<li <%=strAtiva%>><a href="<%=trim(rsAux("ITEM_INFO_URL"))%>"><%=trim(rsAux("ITEM_DESC"))%></a></li>
                                    	<%
										rsAux.movenext
										wend
									end if
									rsAux.close
									%>
                                </ul>
                            </li>
                       	   <%
							rs.movenext
						wend
						rs.close
						end if
						%>
                        <!-- End Contacts -->
                        <!-- Sair do sistema -->
                        <li class="dropdown active">
                            <li class="page-scroll">
                                <a href="../Default.asp">Sair</a>
                            </li>
                        </li>
                        <!-- End Contacts -->
                    </ul>
                </div><!--/navbar-collapse-->
            </div>
        </div>
        <!-- End Navbar -->
                <!-- End Topbar Navigation -->
            </div>
        </div>
        <!-- End Topbar -->
        
    </div>
    <!--=== End Header ===-->

<!-- fim menu -->
<link href="http://netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/css/bootstrap-combined.no-icons.min.css" rel="stylesheet">
<link href="http://netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/css/bootstrap-responsive.min.css" rel="stylesheet">
<link href="http://netdna.bootstrapcdn.com/font-awesome/3.0.2/css/font-awesome.css" rel="stylesheet">
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"></script>
<script src="external/jquery.hotkeys.js"></script>
<script src="http://netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/js/bootstrap.min.js"></script>
<script src="external/google-code-prettify/prettify.js"></script>
<link href="index.css" rel="stylesheet">
<script src="bootstrap-wysiwyg.js"></script>

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
	acao = "I"

	strPaginaTitulo                  			= "frequenciaColaborador_cad.asp"
	strPagina						 			= "frequenciaColaborador_cad.asp"
	strExecutarSubmitModulacaoReferencia        = "S"

	strExecutarSubmitProfessorTurma             = "S"
	strExecutarSubmitTurma	 		            = "S"
	strExecutarSubmitDisciplinaProfessorTurma   = "S"
	strSimouNao_submit                          = "S"
	strExecutarSubmitColaborador				= "S"
	strExecutarSubmitColaboradorFrequencia		= "S"
	strExecutarSubmitTurnoFaltas				= "S"

	intCodigo_SRH_COLABORADOR_FREQUENCIA_FOLHA           	  					= Trim(Request.Form("txtCodigo_SRH_COLABORADOR_FREQUENCIA_FOLHA"))
	intCodModulacaoReferencia 					= Trim(Request("cmbModulacaoReferencia"))
	intCodJustificativaFaltas					= Trim(Request.form("cmbJustificativaFaltas"))
	strDataLancamento         					= Trim(Request("txtDataLancamento"))
	strDataLancamentoFinal        				= Trim(Request("txtDataLancamentoFinal"))
	intCodColaborador        	 				= Trim(Request("cmbColaborador")) 
	strComparaDataLancamento 					= formataDataCalc(Trim(Request("txtDataLancamento")))
	strTipoLancamento          					= Trim(Request("optTipoLancamento"))
	strOptTipoColaborador     					= Trim(Request("optTipoColaborador"))
	strAnoLetivo								= session("strAnoLetivo")
	strAnoLetivo								= session("strAnoLetivo")
	strJustificativaAbono    					= Trim(Request("txtJustificativaAbono"))
	strObservacao	          					= Trim(Request("txtObservacao"))
	strFechamento             					= Trim(Request("cmbFechamento"))
	strOptListarFaltas     						= Trim(Request.form("OptListarFaltas"))
	intCodTurnoFaltas 							= Trim(Request.form("cmbTurnoFaltas"))
	intCodTurnoTurma							= intCodTurnoFaltas
	intCodColaboradorJustificativa				= Trim(Request.form("CodColaboradorJustificativa"))
	if strOptListarFaltas = "" then strOptListarFaltas = "1"

	if strSimouNao = "" or strSimouNao = "0" then strSimouNao = "N"
	
	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	
	if intCodigo_SRH_COLABORADOR_FREQUENCIA_FOLHA <> "" and intCodigo_SRH_COLABORADOR_FREQUENCIA_FOLHA <> "0"  then
	
		cont =0
		sql = " SELECT * "
		sql = sql & " from SRH_COLABORADOR_FREQUENCIA_FOLHA F "
		sql = sql & " left JOIN SRH_COLABORADOR_FREQUENCIA_FOLHA_IMAGEM FI ON FI.cod_colaborador_frequencia_folha = F.CODIGO"
		sql = sql & " WHERE F.CODIGO = " & intCodigo_SRH_COLABORADOR_FREQUENCIA_FOLHA
		rs.open sql, cnn
		if rs.eof = false then
		
			intCodigo           	  					= rs("CODIGO")
			intCodModulacaoReferencia 					= trim(rs("codReferencia"))
			strDataLancamento         					= trim(rs("DATALANCAMENTO"))
			strDataLancamentoFinal        				= trim(rs("DATALANCAMENTOFINAL"))
			intCodColaborador	         	 			= Trim(rs("COD_COLABORADOR"))
			strComparaDataLancamento 					= formataDataCalc(trim(rs("DATALANCAMENTO")))
			strObservacao		    					= Trim(rs("OBSERVACAO"))
			strFechamento             					= trim(rs("FECHAMENTO"))
			strAnoLetivo								= trim(rs("ANO_LETIVO"))
			intSemestre									= trim(rs("SEMESTRE_LETIVO"))
			intCodTurnoFaltas							= trim(rs("COD_TURNO_lancamento"))
			strimagem									= trim(rs("imagem"))
			acao = "A"
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
		end if	
		rs.close
		
		
	end if	

	
		
	if intCodModulacaoReferencia <> "" then

		sql = "select AnoReferencia, SemestreReferencia from SRH_MODULACAO_REFERENCIA WHERE CODIGO = " & intCodModulacaoReferencia
		rs.open sql, cnn
		if rs.eof = false then
			strAnoLetivoReferencia  = rs("AnoReferencia")
			intSemestreReferencia 	= rs("SemestreReferencia")
		end if
		rs.close
		
		if intCodColaborador <> "" then
			sql = " select TOP 1 COD_TURNO, COD_FUNCAO "
			sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE " 
			sql = sql & " where Status = 'A' and Cod_Colaborador = " & intCodColaborador
			sql = sql & " ORDER BY ANO_LETIVO "
			rs.open sql, cnn
			if rs.eof = false then
				strCodFuncaoFuncionario 		= rs("COD_FUNCAO")
				strCodTurnoFuncionario			= rs("COD_TURNO")
				intCodTurnoFaltas				= rs("COD_TURNO")
			else
				sql = "select CODTURNO, CODFUNCAO "
				sql = sql & " from SRH_COLABORADOR "
				sql = sql & " where SITUACAO = 'A' "
				sql = sql & " and CODIGO = " & intCodColaborador 
				rsAux.open sql, cnn
				if rsAux.eof = false then
					strCodFuncaoFuncionario 		= rsAux("CODFUNCAO")
					strCodTurnoFuncionario			= rsAux("CODTURNO")
					intCodTurnoFaltas				= rsAux("CODTURNO")
				end if
				rsAux.close
			end if	
			rs.close
		end if
	end if
	
	if trim(strFechamento) = "S" then
		strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if

	if trim(strDataLancamento) = "" then
		'strDataLancamento = formatadataAP(date)
	end if
	if trim(strDataLancamentoFinal) = "" then
		'strDataLancamentoFinal = formatadataAP(date)
	end if

%>
    <!--=== Content Part ===-->
<form id="frm" method="post" action="frequenciaColaborador_cad.asp">
<input name="txtCodFuncaoFuncionario" type="hidden" id="txtCodFuncaoFuncionario" class="text" size="10" value="<%=strCodFuncaoFuncionario%>" >
<input name="txtCodTurnoFuncionario" type="hidden" id="txtCodTurnoFuncionario" class="text" size="10" value="<%=strCodTurnoFuncionario%>" >
<input name="txtCodigo_SRH_COLABORADOR_FREQUENCIA_FOLHA" type="hidden" id="txtCodigo_SRH_COLABORADOR_FREQUENCIA_FOLHA" class="text" size="10" value="<%=intCodigo_SRH_COLABORADOR_FREQUENCIA_FOLHA%>" maxlength="10">

<input name="txtAnoLetivo" type="hidden" id="txtAnoLetivo" value="<%=strAnoLetivoReferencia%>">
<input name="txtSemestre" type="hidden" id="txtSemestre" value="<%=intSemestreReferencia%>">
			
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Lançamento de Frequencia Funcionário</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            	<div class="panel-body">                                                        

                    <div class="form-group">
                    
<table width="98%" border="0" cellspacing="0"  align="center" cellpadding="0">
  
  <tr>
    <td height="27" class="texto1">Refer&ecirc;ncia:</td>
    <td class="texto1"><!--#include file="../includes/inc_PeriodoModulacao.asp" -->
     <%if intCodModulacaoReferencia <> "" then%> - De: <%=formataDataAP(strDataInicialModulacao)%> a <%=formataDataAP(strDataFinalModulacao)%><%end if%></td>
  </tr>

       
    
    <tr>
        <td height="27" class="texto1"> Colaborador:</td>
        <td class="texto1"><!--#include file="../includes/inc_cmdFuncionarioFrequencia.asp" --></td>
    </tr>
     <tr>
          <td height="27" class="texto1">Turno: </td> 
          <td class="texto1"><!--#include file="../includes/inc_cmbTurnoRHfaltas.asp" --></td>
        </tr>
  
  <tr>
    <td height="64" class="texto1">Observação:</td>
    <td class="texto1"><textarea name="txtObservacao" style="width:520px" cols="120"  rows="3" class="text" id="txtObservacao"><%=strObservacao%></textarea></td>
  </tr>
<tr>
    <td height="13" class="texto1">Imagem do documento<br>
      <em>(Tipo: JPG e PNG) <br>
      (máximo de 2MB)</em></td>
    <td>
        <input type="hidden" name="txtTexto" id="txtTexto">
        <div class="btn-toolbar" data-role="editor-toolbar" data-target="#editor">
            <div class="btn-group">
                <a class="btn" title="Insert picture (or just drag & drop)" id="pictureBtn"><i class="icon-picture"></i></a>
                <input type="file" data-role="magic-overlay" data-target="#pictureBtn" data-edit="insertImage" />
            </div>
            <div class="btn-group">
                <span class="btn"><i class="icon-arrow-left"></i>&nbsp;Clique aqui para inserir a imagem (ou simplesmente arrastar e soltar)</span>
            </div>
            <input type="text" data-edit="inserttext" id="voiceBtn" x-webkit-speech="">
        </div>
        
        <div id="editor">
        <%=strimagem%>
        </div>    
    </td>
  </tr>  
  <%
  if acao = "A" then
	strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
  end if
  
  'RESPONSE.WRITE "LIMPADATADATELA:" & LIMPADATADATELA 
	IF LIMPADATADATELA = "S" THEN
		strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	END IF
  %>
  
  <tr>
    <td colspan="2"><br><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
  </tr>
  <tr>
    <td colspan="2">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="2" class="texto1"> 
		<%if intCodModulacaoReferencia <> "" then%><div align="center"><strong>Lista de Frequencia já lançadas</strong><%end if%></td>
    </tr>
  <tr>
    <td colspan="2">
	<%
	if intCodModulacaoReferencia <> "" then
		sql = "select f.codigo, c.nome as colaborador, t.desc_turno as turno, f.fechamento, c.codFuncional, f.DataLancamento, f.DataLancamentoFinal, f.situacao, f.usuario_inclusao, f.data_inclusao"
		sql=sql & " from SRH_COLABORADOR_FREQUENCIA_FOLHA f"
		sql=sql & " inner join SRH_COLABORADOR c on c.codigo = f.cod_colaborador"
		sql=sql & " inner join SRH_TURNO t on t.cod_turno = f.cod_turno_lancamento"
		sql=sql & " where convert(datetime,convert(varchar, f.DATALANCAMENTO , 103),103) >= convert(datetime, ' " & strDataInicialModulacao & " ',103)"
		sql=sql & " and convert(datetime,convert(varchar, f.DATALANCAMENTO, 103),103) <= convert(datetime, ' " & strDataFinalModulacao & " ',103)"
		sql=sql & " and f.cod_empresa = " & session("codEmpresa")
		sql=sql & " order by f.DataLancamento, f.DataLancamentoFinal"
		'response.write sql
		RS.OPEN SQL, CNN
		IF NOT RS.EOF THEN
		%> 
		   <table width = "100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
				<tr  bgcolor="#E2E2E2">
					<th width="1%" align="center"><input name="chkTodos" type="checkbox" value="" onClick="return marcaTodos()"></th>
					<th width="30%" align="center" class="tamanho11">Colaborador</th>
					<th width="2%"  align="center" class="tamanho11">Matrícula</th>
					<th width="5%"  align="center" class="tamanho11">Inicio</th>
					<th width="5%"  align="center" class="tamanho11"><strong>Final</strong></td>
					<th width="13%" align="center" class="tamanho11"><strong>Inclusão</strong></td>
					<th width="16%" align="center" class="tamanho11"><strong>Data</strong></td>
					<th width="5%" align="center" class="tamanho11"><strong>Situação</strong></td>
					<th width="5%" align="center" class="tamanho11"><strong>Imagem</strong></td>
					<th width="5%" align="center" class="tamanho11"><strong>Enviada</strong></td>
					<th width="5%" align="center" class="tamanho11"><strong>Enviar</strong></td>
					<th width="5%" align="center" class="tamanho11"><strong>Devolver</strong></td>
				</tr>
				<%
				
				Total_Aulas = 0
				while not rs.eof
					cont = cont + 1	
					strDataLancamento          = formatadataAp(rs("DATALANCAMENTO"))
					strDataLancamentoFinal     = formatadataAp(rs("DATALANCAMENTOFINAL"))
					if trim(rs("situacao")) = "S" then
						strSituacao = "Abonada"
					elseif trim(rs("situacao")) = "D" then
						strSituacao = "Devolvido"
					else
						strSituacao = "Edição"
					end if

					if trim(rs("fechamento")) = "S" then
						strEnviouFalta = "<strong>Sim</strong>"
						strCorlinha = "C1FFC1"
						strSituacao = "Enviada"
					else
						strEnviouFalta = "Não"
						strCorlinha = "FFFFFF"
					end if
			
					%>
					<tr <%if trim(rs("fechamento")) <> "S"  then%> class="pointer" <%end if%> bgcolor="#<%=strCorlinha%>"  onmouseover="return linhaMouseOver(this)" onmouseout="return linhaMouseOut(this)">
						<td><input name="chkCodigo" type="checkbox" value="<%=rs("codigo")%>"></td>
						<td <%if trim(rs("fechamento")) <> "S" then%> onclick="return resultadoConsulta('<%=rs("CODIGO")%>')" <%end if%>><%=RS("colaborador")%>&nbsp;<i class="tamanho9">(<%=rs("turno")%>)</i></td>
						<td <%if trim(rs("fechamento")) <> "S" then%> onclick="return resultadoConsulta('<%=rs("CODIGO")%>')" <%end if%>><%=RS("codfuncional")%></td>
						<td <%if trim(rs("fechamento")) <> "S" then%> onclick="return resultadoConsulta('<%=rs("CODIGO")%>')" <%end if%>><%=strDataLancamento%></td>
						<td <%if trim(rs("fechamento")) <> "S" then%> onclick="return resultadoConsulta('<%=rs("CODIGO")%>')" <%end if%>><%=strDataLancamentoFinal%></td>
						<td <%if trim(rs("fechamento")) <> "S" then%> onclick="return resultadoConsulta('<%=rs("CODIGO")%>')" <%end if%>><%=RS("usuario_inclusao")%></td>
						<td <%if trim(rs("fechamento")) <> "S" then%> onclick="return resultadoConsulta('<%=rs("CODIGO")%>')" <%end if%>><%=RS("data_inclusao")%></td>
						<td <%if trim(rs("fechamento")) <> "S" then%> onclick="return resultadoConsulta('<%=rs("CODIGO")%>')" <%end if%>><%=strSituacao%></td>
						<td align="center"><a href="#" onclick="mostraImagem('<%=rs("codigo")%>')"><img src="../../images/document.png" width="24" height="24" alt="Consultar Imagem da Frequencia."></a></td>
						<td <%if trim(rs("fechamento")) <> "S" then%> onclick="return resultadoConsulta('<%=rs("CODIGO")%>')" <%end if%>><%=strEnviouFalta%></td>
						<td>
						<%if trim(rs("fechamento")) <> "S" then%>
						<a href="#" onclick="enviarFaltas('<%=rs("CODIGO")%>')" ><img src="../../images/botao_azul_normal.gif" alt="Enviar faltas" width="26" height="26" border="0"></a>
						<%else%>
						-
						<%end if%></td>
						<%if session("nivelPermissao")="A" then%> 
						<td width="8%" align="center" class="celula"><%if trim(rs("fechamento")) <> "S" then%>-<%else%><a href="#" onclick="devolverFaltas('<%=rs("CODIGO")%>')" ><img src="../../images/botao_azul_normal.gif" alt="Devolver faltas" width="26" height="26" border="0"></a><%end if%></td>
						<%end if%>
					</tr>
					<%				
						rs.movenext
					wend
				%>
			</table>
	
		<%
		RS.CLOSE
	else
	%>
	<br>
	<table width = "100%" border="0" cellpadding="0" cellspacing="0" class="tabela">
		<tr>
			<td colspan="2" class="texto1" align="center" > 
				Nenhum registro lançado!
			</tr>
		<tr>
	</table>
  <%
	end if
end if
%>
	  
	  
	  
	</td>
  </tr>
</table>
<input name="txtDataLancamento" type="hidden" id="txtDataLancamento" value="<%=strDataInicialModulacao%>">
<input name="txtDataLancamentoFinal" type="hidden" id="txtDataLancamentoFinal" value="<%=strDataFinalModulacao%>">
                     
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
  $(function(){
    function initToolbarBootstrapBindings() {
      var fonts = ['Serif', 'Sans', 'Arial', 'Arial Black', 'Courier', 
            'Courier New', 'Comic Sans MS', 'Helvetica', 'Impact', 'Lucida Grande', 'Lucida Sans', 'Tahoma', 'Times',
            'Times New Roman', 'Verdana'],
            fontTarget = $('[title=Font]').siblings('.dropdown-menu');
      $.each(fonts, function (idx, fontName) {
          fontTarget.append($('<li><a data-edit="fontName ' + fontName +'" style="font-family:\''+ fontName +'\'">'+fontName + '</a></li>'));
      });
      $('a[title]').tooltip({container:'body'});
    	$('.dropdown-menu input').click(function() {return false;})
		    .change(function () {$(this).parent('.dropdown-menu').siblings('.dropdown-toggle').dropdown('toggle');})
        .keydown('esc', function () {this.value='';$(this).change();});

      $('[data-role=magic-overlay]').each(function () { 
        var overlay = $(this), target = $(overlay.data('target')); 
        overlay.css('opacity', 0).css('position', 'absolute').offset(target.offset()).width(target.outerWidth()).height(target.outerHeight());
      });
      if ("onwebkitspeechchange"  in document.createElement("input")) {
        var editorOffset = $('#editor').offset();
        $('#voiceBtn').css('position','absolute').offset({top: editorOffset.top, left: editorOffset.left+$('#editor').innerWidth()-35});
      } else {
        $('#voiceBtn').hide();
      }
	};
	function showErrorAlert (reason, detail) {
		var msg='';
		if (reason==='unsupported-file-type') { msg = "Unsupported format " +detail; }
		else {
			console.log("error uploading file", reason, detail);
		}
		$('<div class="alert"> <button type="button" class="close" data-dismiss="alert">&times;</button>'+ 
		 '<strong>File upload error</strong> '+msg+' </div>').prependTo('#alerts');
	};
    initToolbarBootstrapBindings();  
	$('#editor').wysiwyg({ fileUploadError: showErrorAlert} );
    window.prettyPrint && prettyPrint();
  });
</script>    	
    
<script>
	function enviarFaltas(CodRegistroMestre){
		var selecionado = "N";
		for (var i = 0; i < frm.elements.length; i++) {
			if (frm.elements[i].type == "checkbox"){				
				if (frm.elements[i].name == "chkCodigo"){	
					if (frm.elements[i].checked) {
						selecionado = "S";
					}			
				}
			}
		}
		if (selecionado == "N"){
			alert("Nenhum registro foi selecionado para ser enviado!")
			return false
		}
		
		var men = 'ATENÇÃO: Deseja enviar as frequencias desses colaboradores selecionados?'
		if (confirm(men)) {
			frm.action="frequenciaColaborador_cod.asp?enviarFalta=S&acao=ENVIAR";
			frm.submit();
			return true;
		} else {
			return false;
		}
	}
	
	function devolverFaltas(){
		var selecionado = "N";
		for (var i = 0; i < frm.elements.length; i++) {
			if (frm.elements[i].type == "checkbox"){				
				if (frm.elements[i].name == "chkCodigo"){	
					if (frm.elements[i].checked) {
						selecionado = "S";
					}			
				}
			}
		}
		if (selecionado == "N"){
			alert("Nenhum registro foi selecionado para ser devolvido!")
			return false
		}
		var men = 'ATENÇÃO: Deseja devolver a frequencia desses colaboradores selecionados?'
		if (confirm(men)) {
			frm.action="frequenciaColaborador_cod.asp?devolverFalta=S";
			frm.submit();
			return true;
		} else {
			return false;
		}
	}
	
	function resultadoConsulta(intCodigo){
		var frm = document.getElementById("frm");
		frm.txtCodigo_SRH_COLABORADOR_FREQUENCIA_FOLHA.value=intCodigo;
		frm.action = "frequenciaColaborador_cad.asp";
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (acao=="E"){
			frm.action="frequenciaColaborador_cod.asp?acao=" + acao;
			frm.submit();
			return true;
		}
		else
		{
			if (frm.cmbModulacaoReferencia.value == "0") {
				alert("A Referência deve ser informada!");
				frm.cmbModulacaoReferencia.focus();
				return false;
			}
			if (frm.cmbColaborador.value == "0" && acao!="E" ) {
				alert("O colaborador deverá ser informado.");
				frm.cmbColaborador.focus();
				return false;
			}
			if (frm.cmbTurnoFaltas.value == "0") {
				alert("O Turno deve ser informado !");
				frm.cmbTurnoFaltas.focus();
				return false;
			}
			
			$("#txtTexto").val($("#editor").cleanHtml());
			
			if (frm.txtTexto.value == "") {
				alert("A Imagem da frequencia deve ser inserida!");
				return false;
			}
			var textoInicial = frm.txtTexto.value.substring(1,4);
			var tamanho = parseInt(frm.txtTexto.value.length);
			if (textoInicial != "img" && acao=="I"){
				alert("Imagem invalida, devera ser enviado somente documento do tipo IMAGEM!");
				return false;
			}	
			if (tamanho >= 3116802){ 
				alert("Imagem deve ter no máximo 2MB, diminua a imagem e tente enviar novamente!");
				return false;
			}			
			frm.action="frequenciaColaborador_cod.asp?acao=" + acao;
			frm.submit();
			return true;
		}
 	}
	
	function marcaTodos(){
		var frm = document.getElementById("frm");
		if(frm.chkTodos.checked == true){ 
		  for (var i = 0; i < frm.elements.length; i++) {
					//verifica todos os checkbox
					if (frm.elements[i].type == "checkbox"){				
						frm.elements[i].checked = true;				
					}
		  }
		}else{

		  for (var i = 0; i < frm.elements.length; i++) {
					//verifica todos os checkbox
					if (frm.elements[i].type == "checkbox"){				
						frm.elements[i].checked = false;				
					}
		  }
		}
		return true;
	}
	function mostraImagem(id, tipo){
			window.open("frequenciaColaborador_img.asp?id=" + id,"abreConsultaImagem","top=5,left=5,height=600,width=1000,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}
</script>

<!--=== End Content Part ===-->
<!--#include file="../RodapeModulo.asp"-->
<!--include file="../jsModulo.asp"-->
</body>
</html> 