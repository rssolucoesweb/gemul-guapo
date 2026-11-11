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
										
										if rsAux("ITEM_INFO_URL") = "faltas_nao_justificadas_professor_cad.asp" then 
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

	strPaginaTitulo                  			= "faltas_nao_justificadas_professor_cad.asp"
	strPagina						 			= "faltas_nao_justificadas_professor_cad.asp"
	strExecutarSubmitModulacaoReferencia        = "S"

	strExecutarSubmitProfessorTurma             = "S"
	strExecutarSubmitTurma	 		            = "S"
	strExecutarSubmitDisciplinaProfessorTurma   = "S"
	strSimouNao_submit                          = "S"
	strExecutarSubmitColaborador				= "S"
	strExecutarSubmitColaboradorFrequencia		= "S"
	strExecutarSubmitTurnoFaltas				= "S"

	tipo_colaborador							= Trim(Request.Form("tipo_colaborador"))
	if tipo_colaborador = "" then tipo_colaborador = "P"
	if tipo_colaborador = "F" then
		response.Redirect("faltas_nao_justificadas_professor_cad.asp")
		response.End()
	end if

	intCodigo           	  					= Trim(Request.Form("txtCodigo"))
	intCodModulacaoReferencia 					= Trim(Request("cmbModulacaoReferencia"))
	intCodJustificativaFaltas					= Trim(Request.form("cmbJustificativaFaltas"))
	strDataLancamento         					= Trim(Request("txtDataLancamento"))
	strDataLancamentoFinal        				= Trim(Request("txtDataLancamentoFinal"))
	intCodProfessor	         	 				= Trim(Request("cmbColaboradorFrequencia")) 
	strComparaDataLancamento 					= formataDataCalc(Trim(Request("txtDataLancamento")))
	strTipoLancamento          					= Trim(Request("optTipoLancamento"))
	strOptTipoColaborador     					= Trim(Request("optTipoColaborador"))
	strAnoLetivo								= session("strAnoLetivo")
	strJustificativaAbono    					= Trim(Request("txtJustificativaAbono"))
	strJustificativa          					= Trim(Request("txtJustificativa"))
	strSimouNao               					= Trim(Request("cmbSimouNao"))
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
	
	if intCodigo <> "" and intCodigo <> "0"  then
	
		cont =0
		sql = " SELECT F.CODIGO, "
		sql = sql & " F.ANO_LETIVO, "
		sql = sql & " F.Cod_JustificativaFaltas, "
		sql = sql & " F.SEMESTRE_LETIVO, "
		sql = sql & " F.DATALANCAMENTO, "
		sql = sql & " F.DATALANCAMENTOFINAL, "
		sql = sql & " F.DataDiaLancamento, "
		sql = sql & " F.TIPO_COLABORADOR, "
		sql = sql & " F.COD_TURMA, "
		sql = sql & " F.COD_COLABORADOR, "
		sql = sql & " F.COD_DISCIPLINA, "
		sql = sql & " F.NUMERO_FALTA, "
		sql = sql & " F.JUSTIFICATIVA, "
		sql = sql & " F.COD_COLABORADORSUBSTITUTO, "
		sql = sql & " F.NUMERO_AULA, "
		sql = sql & " F.CONTEUDO_SUBSTITUICAO, F.COD_TURNO,"
		sql = sql & " F.SITUACAO as STATUS, F.CodColaboradorJustificativa,"
		sql = sql & " F.JUSTIFICATIVA_ABONO, tipoLancamento, codReferencia, "
		sql = sql & " F.FECHAMENTO, ISNULL(T.COD_TURNO,'0') AS TURNO_SCA, F.COD_TURNO "
		sql = sql & " from SRH_COLABORADOR_FREQUENCIA F "
		sql = sql & " LEFT join sca_turma t on t.cod_turma = f.cod_turma "
		sql = sql & " WHERE CODIGO = " & intCodigo
	if ucase(session("usuarioWeb")) = "SERGIO"  THEN
		'response.write "<hr>" & sql
		'response.write "<hr>"
		'response.end	
	end if			
		
		rs.open sql, cnn
		if rs.eof = false then
		
			intCodigo           	  					= rs("CODIGO")
			intCodModulacaoReferencia 					= trim(rs("codReferencia"))
			intCodJustificativaFaltas					= trim(rs("Cod_JustificativaFaltas"))
			strDataLancamento         					= trim(rs("DATALANCAMENTO"))
			strDataLancamentoFinal        				= trim(rs("DATALANCAMENTOFINAL"))
			intCodProfessor	         	 				= Trim(rs("COD_COLABORADOR"))
			strComparaDataLancamento 					= formataDataCalc(trim(rs("DATALANCAMENTO")))
			strTipoLancamento          					= Trim(rs("tipoLancamento"))
			''if Trim(Request("optTipoColaborador")) = "" then
			strOptTipoColaborador     					= Trim(rs("TIPO_COLABORADOR"))
			'end if
			strJustificativaAbono    					= Trim(rs("JUSTIFICATIVA_ABONO"))
			strJustificativa          					= Trim(rs("JUSTIFICATIVA"))
			strSimouNao               					= trim(rs("STATUS"))
			strFechamento             					= trim(rs("FECHAMENTO"))
			strAnoLetivo								= trim(rs("ANO_LETIVO"))
			intSemestre									= trim(rs("SEMESTRE_LETIVO"))
			intCodTurnoTurma							= trim(rs("TURNO_SCA"))
			intCodTurnoFaltas							= trim(rs("COD_TURNO"))
			CodColaboradorJustificativa					= trim(rs("CodColaboradorJustificativa"))
			acao = "A"
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
		end if	
		rs.close
		
		if not isnull(CodColaboradorJustificativa) then
			'busca imagem
			sql = " select justificativa from SRH_COLABORADOR_JUSTIFICATIVA where codigo = " & CodColaboradorJustificativa
			rsAux.open sql, cnn
			if rsAux.eof = false then
				strJustificativaAbono           	  					= rsAux("justificativa")
			end if
			rsAux.close
			
			'busca imagem
			sql = " select imagem from SRH_COLABORADOR_JUSTIFICATIVA_IMAGEM where cod_colaborador_justificativa = " & CodColaboradorJustificativa
			rsAux.open sql, cnn
			if rsAux.eof = false then
				strimagem           	  					= rsAux("imagem")
			end if
			rsAux.close
		end if
	end if	

	if intCodProfessor <> "" and intCodProfessor <> "0"  then
		if trim(acao) = "A" then 
			sql = " select distinct Situacao_disciplinar, tipoModulacao, Ano_Letivo, Semestre "
			sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE " 
			sql = sql & " where Cod_Colaborador = " & intCodProfessor 
			sql = sql & " and Cod_empresa = " & Session("CodEmpresa") 
			sql = sql & " and Status = 'A' "
			sql = sql & " and COD_TURNO=" & intCodTurnoFaltas
			sql = sql & " order by Ano_Letivo desc"
		else
			sql = " select distinct Situacao_disciplinar, tipoModulacao, M.Ano_Letivo, M.Semestre "
			sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE M " 
			sql = sql & " INNER JOIN SRH_TURNO TRH	ON TRH.Cod_Turno = M.Cod_Turno"
			sql = sql & " INNER JOIN SCA_TURNO TU		ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) AND TRH.Cod_Grupo=" & session("codGrupo")
			sql = sql & " where M.Cod_Colaborador = " & intCodProfessor 
			sql = sql & " and M.Cod_empresa = " & Session("CodEmpresa") 
			sql = sql & " and M.Status = 'A' "
			IF intCodTurnoTurma <> "0" and intCodTurnoTurma <> "" THEN
				sql = sql & " and TU.COD_TURNO=" & intCodTurnoTurma
			END IF
			sql = sql & " order by M.Ano_Letivo desc"
		end if
	if ucase(session("usuarioWeb")) = "SERGIO"  THEN
		'response.write "<hr>" & acao
		'response.write "<hr>" & sql
		'response.write "<hr>"
		'response.end	
	end if			
		
		rs.open sql, cnn
		if rs.eof = false then
		    if trim(rs("tipoModulacao")) = "PROFESSOR"  then
				strOptTipoColaborador 	= "1"
			else
				strOptTipoColaborador 	= "0"
			end if
			strTipoLancamento 		= rs("Situacao_disciplinar")
			strAnoLetivo			= rs("Ano_Letivo")
			intSemestre				= rs("Semestre")
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		else
			%>
			<script>
				alert("ATENÇÃO: Professor ainda não modulado. Verifique!");
			</script>
			<%
			'response.end 
		end if	
		rs.close
		
		if intCodModulacaoReferencia <> "" then

			sql = "select AnoReferencia, SemestreReferencia from SRH_MODULACAO_REFERENCIA WHERE CODIGO = " & intCodModulacaoReferencia
			rs.open sql, cnn
			if rs.eof = false then
				strAnoLetivoReferencia  = rs("AnoReferencia")
				intSemestreReferencia 	= rs("SemestreReferencia")
			end if
			rs.close
			
			sql = " select TOP 1 COD_TURNO, COD_FUNCAO "
			sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE " 
			sql = sql & " where Status = 'A' and Cod_Colaborador = " & intCodProfessor 
			sql = sql & " ORDER BY ANO_LETIVO "
			rs.open sql, cnn
			if rs.eof = false then
				strCodFuncaoFuncionario 		= rs("COD_FUNCAO")
				strCodTurnoFuncionario			= rs("COD_TURNO")
			end if	
			rs.close
		end if
	else
		strOptTipoColaborador = ""
		strTipoLancamento = ""
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
<form id="frm" method="post" action="faltas_nao_justificadas_professor_cad.asp">
<input name="dtf" type="hidden" id="dtf" class="text" size="10" value="<%=request("dtf")%>" >
<input name="tpl" type="hidden" id="tpl" class="text" size="10" value="<%=request("tpl")%>" >
<input name="txtCodFuncaoFuncionario" type="hidden" id="txtCodFuncaoFuncionario" class="text" size="10" value="<%=strCodFuncaoFuncionario%>" >
<input name="txtCodTurnoFuncionario" type="hidden" id="txtCodTurnoFuncionario" class="text" size="10" value="<%=strCodTurnoFuncionario%>" >
<input type="hidden" name="tipo_colaborador" id="tipo_colaborador" value="P"> 
<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
<input name="txtCodColaboradorJustificativa" type="hidden" id="txtCodColaboradorJustificativa" class="text" size="10" value="<%=CodColaboradorJustificativa%>" maxlength="10">    
  <input name="txtAnoLetivo" type="hidden" class="text" id="txtAnoLetivo"  value="<%=intAnoLetivo%>">
  <input name="cmbSemestre" type="hidden" class="text" id="cmbSemestre"  value="<%=intSemestre%>">
  
  
  </td>
	
	<div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Lançamento de faltas não justificadas - Professor</h3>
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
      - De: <%=formataDataAP(strDataInicialModulacao)%> a <%=formataDataAP(strDataFinalModulacao)%></td>
  </tr>
  <tr>
    <td height="27" class="texto1">Data Inicial do Lan&ccedil;amento</td>
    <td class="texto1"><input name="txtDataLancamento" type="text" class="form-control" id="txtDataLancamento" onblur="return validaData(this); reloadDtFinal()" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataLancamento%>"  onChange='reloadDtFinal()' title="Click aqui para visualizar o calend&aacute;rio"></td>
  </tr>
  <%
	'calculando da data final
	bloqcampodatafinal=""
	classcampodatafinal = "form-control"
	if intQtdeFaltas<>0 and strDataLancamento<>"" then
	'  response.Write("intQtdeFaltas:" & intQtdeFaltas)

		strDataLancamentoFinal =  formatadataAP(DateAdd("d", intQtdeFaltas, strDataLancamento))
		bloqcampodatafinal = "readonly"
		classcampodatafinal = "textDesabilita"
	end if
	if intCodigo ="" and request("dtf")="" then 
		'strDataLancamentoFinal = strDataLancamento
		strComparaDataLancamento = formatadataCalc(Trim(strDataLancamento))
	end if

	strComparaDataInicialModulacao 	= formatadataCalc(Trim(strDataInicialModulacao))
	strComparaDataFinalModulacao 	= formatadataCalc(Trim(strDataFinalModulacao))
	strComparaDataLancamentoFinal 	= formatadataCalc(Trim(strDataLancamentoFinal))

	if strDataLancamento <> "" and strDataLancamentoFinal <> "" AND intCodModulacaoReferencia <> "0" and intCodModulacaoReferencia <> "" and intCodigo ="" then

		if cCur(strComparaDataLancamento) < cCur(strComparaDataInicialModulacao) then
			%>
			<script>
				alert("ATENÇÃO: A data informada não confere com o período de referência. Verifique!");
			</script>
			<% 
			strDataLancamento = formataDataAP(strDataInicialModulacao)
			strDataLancamentoFinal = formataDataAP(strDataFinalModulacao)
			LIMPADATADATELA = "S"
		  	'response.end
		else
			if cCur(strComparaDataLancamento) > cCur(strComparaDataFinalModulacao) then
				%>
				<script>
					alert("ATENÇÃO: A data informada não confere com o período de referência. Verifique!");
				</script>
				<% 
				strDataLancamento = formataDataAP(strDataInicialModulacao)
				strDataLancamentoFinal = formataDataAP(strDataFinalModulacao)
			  	'response.end
				LIMPADATADATELA = "S"
			end if
		end if
	end if
	if strDataLancamento <> "" and strDataLancamentoFinal <> "" AND intCodModulacaoReferencia <> "0" and intCodModulacaoReferencia <> "" then
		if cCur(strComparaDataLancamentoFinal) < cCur(strComparaDataInicialModulacao) then
			%>
			<script>
				alert("ATENÇÃO: A data informada não confere com o período de referência. Verifique!");
			</script>
			<% 
			strDataLancamento = formataDataAP(strDataInicialModulacao)
			strDataLancamentoFinal = formataDataAP(strDataFinalModulacao)
			LIMPADATADATELA = "S"
		  	'response.end
		end if
	end if
	%>
    <tr>
        <td height="27" class="texto1">Data Final do Lan&ccedil;amento</td>
        <td class="texto1"><input <%=bloqcampodatafinal%> name="txtDataLancamentoFinal" type="text" class="<%=classcampodatafinal%>" id="txtDataLancamentoFinal" onblur="validaData(this);verificaDatas();" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataLancamentoFinal%>" title="Click aqui para visualizar o calend&aacute;rio"></td>
    </tr>
    
    <% 
	if trim(acao) = "A" then 
	%>
        <tr>
          <td height="27" class="texto1">Turno: </td> 
          <td class="texto1"><!--#include file="../includes/inc_cmbTurnoRHfaltas.asp" --></td>
        </tr>
    <% 
	else 
	%>
        <tr>
          <td height="27" class="texto1">Turno:</td> 
          <td class="texto1"><!--#include file="../includes/inc_cmdTurnoFiltroFaltas.asp" --></td>
        </tr>
    <% 
	end if 
	%>
    <tr>
        <td height="27" class="texto1"> Titular:</td>
        <td class="texto1"><!--#include file="../includes/inc_cmdColaboradorFaltasModulacao.asp" -->
        &nbsp;Colaborador modulado. </td>
    </tr>
    <input id="optTipoColaborador" name="optTipoColaborador" type="hidden" value="<%=strOptTipoColaborador%>">
	<input id="optTipoLancamento" name="optTipoLancamento" type="hidden" value="<%=strTipoLancamento%>">
	<% 
	
	'Localizo as faltas interdisciplinar
	if strTipoLancamento = "I" and intCodProfessor <> "" and intCodProfessor <> "0" then 
		%>
	    <tr class="texto1">
        <td height="27" class="texto1">Turmas:</td>
        <td class="texto1">
		<%
		
		sql = " SELECT DISTINCT "
		sql = sql & " HA.cod_turma, " 
		sql = sql & " T.NomeTurma, "
		sql = sql & " '0' as CodColaboradorSubstituido, "
		sql = sql & " '/ Horário' as OrigemLancamento "
		sql = sql & " FROM  SCA_HORARIO_AULA HA "
		sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "  
		sql = sql & " where HA.cod_colaborador = " & intCodProfessor 
		sql = sql & " and T.Situacao = 'A' " 
		sql = sql & " and HA.cod_empresa = " & Session("CodEmpresa") 
		sql = sql & " and HA.anoletivo = " & strAnoLetivo
		sql = sql & " and HA.semestre in (" & intSemestre & ")"
		if intCodTurnoTurma <> "" and intCodTurnoTurma <> "0" then
			''sql = sql & " and t.cod_turno = " & intCodTurnoFaltas
			sql = sql & " and (CASE WHEN SUBSTRING(T.NomeTurma,6,1) <> 'I' then t.cod_turno else " & intCodTurnoTurma & " END) = " & intCodTurnoTurma
		end if

		sql = sql & " UNION "
		
		sql = sql & " SELECT " 
		sql = sql & " (SELECT DISTINCT top 1 HA.cod_turma " 
		sql = sql & " FROM SCA_HORARIO_AULA HA "
		sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
		sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
		sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) "  
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular " 
		sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "  
		sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
		sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "
		sql = sql & " AND HA.Semestre = MD.Semestre "
		sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "
		sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "
		sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "
		sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno ) AS cod_turma, "
		
		sql = sql & " (SELECT DISTINCT top 1 NOMETURMA " 
		sql = sql & " FROM SCA_HORARIO_AULA HA "
		sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
		sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
		sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) "  
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular " 
		sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "  
		sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
		sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "
		sql = sql & " AND HA.Semestre = MD.Semestre "
		sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "
		sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "
		sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "
		sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno ) AS NomeTurma, "
		
		sql = sql & " isnull(CS.CodColaboradorSubstituido,'0') as CodColaboradorSubstituido, "
		sql = sql & " '/ Substituição' as OrigemLancamento "
		sql = sql & " FROM SRH_MODULACAO_DISCIPLINAR_DOCENTE MD "
		sql = sql & " INNER JOIN SRH_COLABORADOR_SUBSTITUTO CS ON CS.CodColaboradorSubstituto = MD.Cod_Colaborador "
		'and convert(datetime,convert(varchar, CS.DATAINICIAL , 103),103) >= convert(datetime, ' " & strDataInicialModulacao & " ',103) and convert(datetime,convert(varchar, CS.DATAFINAL, 103),103) <= convert(datetime, ' " & strDataFinalModulacao & " ',103) "  
		sql = sql & " LEFT JOIN SRH_TURNO TRH ON TRH.Cod_Turno = MD.Cod_Turno "   
		sql = sql & " LEFT JOIN SCA_TURNO TU ON SUBSTRING(TU.Desc_Turno,1,3) = SUBSTRING(TRH.Desc_Turno,1,3) " 
		sql = sql & " WHERE MD.Cod_Colaborador = " & intCodProfessor
		sql = sql & " and ( "
		sql = sql & " 	(CS.DataInicial BETWEEN '"& FORMATADATABD(strDataInicialModulacao) &"' AND '"& FORMATADATABD(strDataFinalModulacao) &"' or CS.DataFinal BETWEEN '"& FORMATADATABD(strDataInicialModulacao) &"' AND '"& FORMATADATABD(strDataFinalModulacao) &"') "
		sql = sql & " 	or"
		sql = sql & " 	('" & FORMATADATABD(strDataInicialModulacao) & "' BETWEEN CS.DataInicial AND CS.DataFinal   or '"& FORMATADATABD(strDataFinalModulacao) &"' BETWEEN CS.DataInicial AND CS.DataFinal)"
		sql = sql & " )		"
		sql = sql & " and MD.Ano_Letivo = " & strAnoLetivo
		sql = sql & " and MD.Semestre in (" & intSemestre & ")"
		'sql = sql & " AND ( MD.Status = 'A' OR "
		'sql = sql & " AND ISNULL(Cod_Modulacao_Substituicao,'0')<> 0 "  
		sql = sql & " and ISNULL((SELECT DISTINCT top 1 NOMETURMA "   
		sql = sql & " FROM SCA_HORARIO_AULA HA "  
		sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "  
		sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "    
		sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) "    
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular "   
		sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "    
		sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo "   
		sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "  
		sql = sql & " AND HA.Semestre = MD.Semestre "  
		sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "  
		sql = sql & " and HA.cod_empresa = " & Session("CodEmpresa") 
		sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "  
		sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "  
		sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno ),'0')<>'0' "  
		if intCodTurnoTurma <> "" and intCodTurnoTurma <> "0" then
			'sql = sql & " and tu.cod_turno = " & intCodTurnoFaltas
			sql = sql & " and (CASE WHEN SUBSTRING( "
			sql = sql & " (SELECT DISTINCT top 1 NOMETURMA " 
			sql = sql & " FROM SCA_HORARIO_AULA HA "
			sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
			sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
			sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) "  
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular " 
			sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "  
			sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
			sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "
			sql = sql & " AND HA.Semestre = MD.Semestre "
			sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "
			sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "
			sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "
			sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno ),6,1) <> 'I' then tu.cod_turno else " & intCodTurnoTurma & " END) = " & intCodTurnoTurma
		end if
		
		if ucase(session("usuarioWeb")) = "SERGIO"  THEN
			'response.write strTipoLancamento & "<hr>" & sql
			'response.write "<hr>"
			'response.end	
		end if
		rs.open sql, cnn
		if rs.eof = false then
		
			 while not rs.eof
		
				strDataLancamentoCompara 		= strDataLancamento
				strDataLancamentoFinalCompara 	= strDataLancamentoFinal
				TotalFaltaTurma 				= 0
				strTurmaLocalizada 				= ""
				
				do while true
	
					sql = " SELECT DISTINCT "
					sql = sql & " HA.cod_turma, " 
					sql = sql & " T.NomeTurma, "
					sql = sql & " HA.DiaSemana "
					sql = sql & " FROM  SCA_HORARIO_AULA HA "
					sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "  
					sql = sql & " where ( HA.cod_colaborador = " & intCodProfessor & " or HA.cod_colaborador = " & trim(rs("CodColaboradorSubstituido")) & ")" 
					sql = sql & " and T.Situacao = 'A' " 
					sql = sql & " and HA.cod_empresa = " & Session("CodEmpresa") 
					sql = sql & " and HA.anoletivo = " & strAnoLetivo
					sql = sql & " and HA.semestre in (" & intSemestre & ")"
					sql = sql & " and HA.diasemana = " & weekday(strDataLancamentoCompara) 
					sql = sql & " UNION"
					sql = sql & " SELECT DISTINCT HA.cod_turma, T.NomeTurma, 0 AS DiaSemana "
					sql = sql & " FROM SCA_HORARIO_AULA_EXTRA HA "
					sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
					sql = sql & " where (HA.cod_colaborador = " & intCodProfessor & " or HA.cod_colaborador = 0) "
					sql = sql & " and T.Situacao = 'A' "
					sql = sql & " and HA.cod_empresa = " & Session("CodEmpresa")
					sql = sql & " and HA.anoletivo = " & strAnoLetivo
					sql = sql & " and HA.semestre in (" & intSemestre & ")"
					sql = sql & " and convert(datetime, HA.DATALANCAMENTO,103) between convert(datetime,convert(varchar, '" & FORMATADATAAP(strDataLancamento) & "' , 103),103) AND convert(datetime,convert(varchar, '" & FORMATADATAAP(strDataLancamentoFinal) & "', 103),103)"

					if ucase(session("usuarioWeb")) = "SERGIO"  THEN
						'response.write sql	
						'response.end
					end if
					
					rsAux.open sql, cnn
					IF rsAux.EOF = false THEN
						TotalFaltaTurma = TotalFaltaTurma + 1
					end if
					rsAux.close  
					strDataLancamentoCompara = DateAdd("d", 1, strDataLancamentoCompara)
					
						'if strDataLancamentoFinal <> "" then
							if formatadataCalc(Trim(strDataLancamentoCompara)) > formatadataCalc(Trim(strDataLancamentoFinalCompara)) then
						'end if
					
						exit do
					end if
					
				loop
				
				if TotalFaltaTurma > 0 then
					if strDataLancamento <> strDataLancamentoFinal then 
						strSelecionado = " checked "
						strBloqueiaCK = " Disabled "
					end if
					strTurmaLocalizada = "OK"
					%>
					<input <%=strSelecionado%> <%=strBloqueiaCK%> name="<%=rs("cod_turma")%>" id="<%=rs("cod_turma")%>" type="checkbox" value="<%=TotalFaltaTurma%>"/><%=rs("NomeTurma")%> - <%=TotalFaltaTurma%> Falta(s) <%=rs("OrigemLancamento")%>  <BR>
					<%
				end if
				rs.movenext
				
			wend
			if strTurmaLocalizada = "" then
				%>
                <strong>Turma(s) não localizada para o per&iacute;odo de lan&ccedil;amento informado.</strong> 
            	<%
			end if 
			%>			</td>
			<%
		else
			%>
			<script>
				alert("ATENÇÃO: Não foi localizado Turmas para Lançamento. Verifique!");
			</script>
			<%
				strDesabilitaIncluir = " Disabled "
				strDesabilitaAlterar = " Disabled "
				strDesabilitaExcluir = " Disabled "
		end if	
		rs.close
	
	end if	
	
	'Localizo as faltas Disciplinares
	if strTipoLancamento = "D" and intCodProfessor <> "" then 
		%>
	    <tr class="texto1">
        <td height="27" class="texto1">Turmas:</td>
        <td class="texto1">
		<%
		
		strTurmaLocalizada  = ""
		
		if strDataLancamento = strDataLancamentoFinal then 
			sql = " SELECT DISTINCT HA.cod_turma, T.NomeTurma, D.Cod_Disciplina, D.Desc_Disciplina, HA.diasemana, HA.Sequencia, '0' as CodColaboradorSubstituido, '' as OrigemLancamento "
		else
			sql = " SELECT DISTINCT HA.cod_turma, T.NomeTurma, D.Cod_Disciplina, D.Desc_Disciplina, '0' as CodColaboradorSubstituido, '' as OrigemLancamento "
		end if
		sql = sql & " FROM SCA_HORARIO_AULA HA " 
		sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma " 
		sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.Cod_Disciplina = HA.Cod_Disciplina " 
		sql = sql & " where HA.cod_colaborador = " & intCodProfessor 
		sql = sql & " and T.Situacao = 'A' " 
		sql = sql & " and HA.cod_empresa = " & Session("CodEmpresa") 
		sql = sql & " and HA.anoletivo = " & strAnoLetivo
		sql = sql & " and HA.semestre in (" & intSemestre & ")"
		if strDataLancamento = strDataLancamentoFinal then 
			sql = sql & " and HA.diasemana = " & weekday(strDataLancamento) 
	    end if
		if intCodTurnoTurma <> "" and intCodTurnoTurma <> "0" then
			sql = sql & " and t.cod_turno = " & intCodTurnoTurma
		end if
		'-
		sql = sql & " UNION "
		'-extra
		if strDataLancamento = strDataLancamentoFinal then 
			sql = sql & " SELECT DISTINCT HA.cod_turma, T.NomeTurma, HA.Cod_Disciplina, D.Desc_Disciplina, '0' as diasemana,'0' as Sequencia, '0' as CodColaboradorSubstituido, '' as OrigemLancamento "
		else
			sql = sql & " SELECT DISTINCT HA.cod_turma, T.NomeTurma, HA.Cod_Disciplina, D.Desc_Disciplina, '0' as CodColaboradorSubstituido, '' as OrigemLancamento "
		end if
		
		sql = sql & " FROM SCA_HORARIO_AULA_EXTRA HA "
		sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
		sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.Cod_Disciplina = HA.Cod_Disciplina "
		sql = sql & " where HA.cod_colaborador = " & intCodProfessor 
		sql = sql & " and T.Situacao = 'A' "
		sql = sql & " and HA.cod_empresa = " & Session("CodEmpresa")
		sql = sql & " and HA.anoletivo = " & strAnoLetivo
		sql = sql & " and HA.semestre in (" & intSemestre & ")"
		sql = sql & " and convert(datetime, HA.DATALANCAMENTO,103) between convert(datetime,convert(varchar, '" & FORMATADATAAP(strDataLancamento) & "' , 103),103) AND convert(datetime,convert(varchar, '" & FORMATADATAAP(strDataLancamentoFinal) & "', 103),103)"

		sql = sql & " UNION "
		sql = sql & " SELECT "
 		'
		if strDataLancamento = strDataLancamentoFinal then 
			sql = sql & " (SELECT DISTINCT top 1 HA.COD_TURMA " 
			sql = sql & " FROM SCA_HORARIO_AULA HA "
			sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
			sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
			sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) "  
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular " 
			sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "  
			sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
			sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "
			sql = sql & " AND HA.Semestre = MD.Semestre "
			sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "
			sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "
			sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "
			sql = sql & " AND HA.Cod_Disciplina = MD.Cod_Disciplina "
			if strDataLancamento = strDataLancamentoFinal then 
				sql = sql & " and HA.diasemana = " & weekday(strDataLancamento) 
			end if
			sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno ) AS cod_turma, "
			'
			sql = sql & " (SELECT DISTINCT top 1 T.NOMETURMA " 
			sql = sql & " FROM SCA_HORARIO_AULA HA "
			sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
			sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
			sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) "  
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular " 
			sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "  
			sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
			sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "
			sql = sql & " AND HA.Semestre = MD.Semestre "
			sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "
			sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "
			sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "
			sql = sql & " AND HA.Cod_Disciplina = MD.Cod_Disciplina "
			if strDataLancamento = strDataLancamentoFinal then 
				sql = sql & " and HA.diasemana = " & weekday(strDataLancamento) 
			end if
			sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno ) AS NomeTurma, "
			'
			sql = sql & " MD.Cod_Disciplina, "
			'
			sql = sql & " D.Desc_Disciplina, "
			'
			sql = sql & " (SELECT DISTINCT top 1 HA.diasemana " 
			sql = sql & " FROM SCA_HORARIO_AULA HA "
			sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
			sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
			sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) "  
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular " 
			sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "  
			sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
			sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "
			sql = sql & " AND HA.Semestre = MD.Semestre "
			sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "
			sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "
			sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "
			sql = sql & " AND HA.Cod_Disciplina = MD.Cod_Disciplina "
			if strDataLancamento = strDataLancamentoFinal then 
				sql = sql & " and HA.diasemana = " & weekday(strDataLancamento) 
			end if
			sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno) AS diasemana, "
			'
			sql = sql & " (SELECT DISTINCT top 1 HA.Sequencia " 
			sql = sql & " FROM SCA_HORARIO_AULA HA "
			sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
			sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
			sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) "  
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular " 
			sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular  " 
			sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
			sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "
			sql = sql & " AND HA.Semestre = MD.Semestre "
			sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "
			sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "
			sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "
			sql = sql & " AND HA.Cod_Disciplina = MD.Cod_Disciplina "
			if strDataLancamento = strDataLancamentoFinal then 
				sql = sql & " and HA.diasemana = " & weekday(strDataLancamento) 
			end if
			sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno) AS Sequencia, "
			'
			sql = sql & " CS.CodColaboradorSubstituido, "
			'
			sql = sql & " '/ Substituição' as OrigemLancamento "
			'
		else
			sql = sql & " (SELECT DISTINCT top 1 HA.COD_TURMA " 
			sql = sql & " FROM SCA_HORARIO_AULA HA "
			sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
			sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
			sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) "  
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular " 
			sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "  
			sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
			sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "
			sql = sql & " AND HA.Semestre = MD.Semestre "
			sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "
			sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "
			sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "
			sql = sql & " AND HA.Cod_Disciplina = MD.Cod_Disciplina "
			if strDataLancamento = strDataLancamentoFinal then 
				sql = sql & " and HA.diasemana = " & weekday(strDataLancamento) 
			end if
			sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno ) AS cod_turma, "
			'
			sql = sql & " (SELECT DISTINCT top 1 T.NOMETURMA " 
			sql = sql & " FROM SCA_HORARIO_AULA HA "
			sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
			sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
			sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) "  
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular " 
			sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "  
			sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
			sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "
			sql = sql & " AND HA.Semestre = MD.Semestre "
			sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "
			sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "
			sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "
			sql = sql & " AND HA.Cod_Disciplina = MD.Cod_Disciplina "
			if strDataLancamento = strDataLancamentoFinal then 
				sql = sql & " and HA.diasemana = " & weekday(strDataLancamento) 
			end if
			sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno ) AS NomeTurma, "
			'
			sql = sql & " MD.Cod_Disciplina, "
			'
			sql = sql & " D.Desc_Disciplina, "
			'
			sql = sql & " CS.CodColaboradorSubstituido, "
			'
			sql = sql & " '/ Substituição' as OrigemLancamento "
			'
		end if
		sql = sql & " FROM SRH_MODULACAO_DISCIPLINAR_DOCENTE MD "
		sql = sql & " INNER JOIN SRH_COLABORADOR_SUBSTITUTO CS ON CS.CodColaboradorSubstituto = MD.Cod_Colaborador AND CS.Situacao = 'A' " 
		sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.Cod_Disciplina = MD.Cod_Disciplina " 
		sql = sql & " WHERE MD.Cod_Colaborador = " & intCodProfessor
		sql = sql & " and MD.Ano_Letivo = " & strAnoLetivo
		sql = sql & " and MD.Semestre in (" & intSemestre & ")"
		sql = sql & " AND MD.Status = 'A' "
		sql = sql & " AND ISNULL(Cod_Modulacao_Substituicao,'0')<> 0 "
		sql = sql & " and ISNULL((SELECT DISTINCT top 1 NOMETURMA " 
		sql = sql & " FROM SCA_HORARIO_AULA HA "
		sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
		sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno "  
		sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) "  
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular " 
		sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular "  
		sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
		sql = sql & " WHERE HA.AnoLetivo = MD.Ano_Letivo "
		sql = sql & " AND HA.Semestre = MD.Semestre "
		sql = sql & " AND HA.Cod_Colaborador = CS.CodColaboradorSubstituido "
		sql = sql & " AND P.Cod_Curso = MD.Cod_Curso "
		sql = sql & " AND P.Cod_Periodo = MD.Cod_periodo "
		sql = sql & " AND HA.Cod_Disciplina = MD.Cod_Disciplina "
		if strDataLancamento = strDataLancamentoFinal then 
			sql = sql & " and HA.diasemana = " & weekday(strDataLancamento) 
	    end if
		if intCodTurnoTurma <> "" and intCodTurnoTurma <> "0" then
			sql = sql & " and t.cod_turno = " & intCodTurnoTurma
		end if

		sql = sql & " AND TRH.Cod_Turno = MD.Cod_Turno ),'0')<>'0' "
		
		if ucase(session("usuarioWeb")) = "SERGIO"  THEN
			'response.write strTipoLancamento & "<hr>" & sql
			'response.write "<hr>"
			'response.end	
		end if
		rs.open sql, cnn
		if rs.eof = false then
		
			 while not rs.eof
			 
				TotalFaltaTurmaDisciplina 		= 0
				intCodHorario 					= 0
				strDataLancamentoCompara 		= strDataLancamento
				strDataLancamentoFinalCompara 	= strDataLancamentoFinal
				
				do while true
	
					sql = " SELECT HA.CODIGO, HA.cod_turma, T.NomeTurma, HA.DiaSemana "
					sql = sql & " FROM SCA_HORARIO_AULA HA " 
					sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma " 
					sql = sql & " where ( HA.cod_colaborador = " & intCodProfessor & " or HA.cod_colaborador = " & trim(rs("CodColaboradorSubstituido")) & ")" 
					sql = sql & " and T.Situacao = 'A' " 
					sql = sql & " and HA.cod_empresa = " & Session("CodEmpresa") 
					sql = sql & " and HA.anoletivo = " & strAnoLetivo
					sql = sql & " and HA.semestre in (" & intSemestre & ")"
					sql = sql & " and HA.diasemana = " & weekday(strDataLancamentoCompara) 
					sql = sql & " and HA.cod_turma = " & trim(rs("cod_turma"))
					sql = sql & " and HA.Cod_Disciplina = " & trim(rs("Cod_Disciplina"))
					if strDataLancamento = strDataLancamentoFinal then 
						sql = sql & " and HA.Sequencia = " & trim(rs("Sequencia"))
					end if
					sql = sql & " UNION"
					sql = sql & " SELECT DISTINCT HA.CODIGO, HA.cod_turma, T.NomeTurma, 0 AS DiaSemana "
					sql = sql & " FROM SCA_HORARIO_AULA_EXTRA HA "
					sql = sql & " INNER JOIN SCA_TURMA T ON T.cod_turma = HA.cod_turma "
					sql = sql & " where (HA.cod_colaborador = " & intCodProfessor & " or HA.cod_colaborador = 0) "
					sql = sql & " and T.Situacao = 'A' "
					sql = sql & " and HA.cod_empresa = " & Session("CodEmpresa")
					sql = sql & " and HA.anoletivo = " & strAnoLetivo
					sql = sql & " and HA.semestre in (" & intSemestre & ")"
					sql = sql & " and HA.cod_turma = " & trim(rs("cod_turma"))
					sql = sql & " and HA.DATALANCAMENTO = '" & formatadataBD(strDataLancamentoCompara) & "'"
					'sql = sql & " and convert(datetime, HA.DATALANCAMENTO,103) between convert(datetime,convert(varchar, '" & FORMATADATAAP(strDataLancamento) & "' , 103),103) AND convert(datetime,convert(varchar, '" & FORMATADATAAP(strDataLancamentoFinal) & "', 103),103)"
					if ucase(session("usuarioWeb")) = "SERGIO"  THEN
						'response.write "111<hr>" & sql
						'response.write "<hr>"
						'response.end	
					end if
					rsAux.open sql, cnn
					IF rsAux.EOF = false THEN
						intCodHorario = trim(rsAux("CODIGO"))
						 while not rsAux.eof
							TotalFaltaTurmaDisciplina = TotalFaltaTurmaDisciplina + 1
							rsAux.movenext
						 wend
					end if
					rsAux.close  
					strDataLancamentoCompara = DateAdd("d", 1, strDataLancamentoCompara)
					
					if cCur(formatadataCalc(Trim(strDataLancamentoCompara))) > cCur(formatadataCalc(Trim(strDataLancamentoFinalCompara))) then
						exit do
					end if
					
				loop
				'TURMAS
				
				if TotalFaltaTurmaDisciplina > 0 then
					if strDataLancamento <> strDataLancamentoFinal then 
						strSelecionado = " checked "
						strBloqueiaCK = " Disabled "
					end if
					strTurmaLocalizada = "OK"
					if strDataLancamento = strDataLancamentoFinal then 
					%>
					<input <%=strSelecionado%> <%=strBloqueiaCK%> name="<%=rs("NomeTurma")%>_<%=rs("Sequencia")%>" id="<%=intCodHorario%>_<%=rs("Sequencia")%>" type="checkbox" value="<%=TotalFaltaTurmaDisciplina%>"/>&nbsp;<%=rs("Desc_Disciplina")%> ( <%=rs("NomeTurma")%> ) - <%=TotalFaltaTurmaDisciplina%> Falta(s) <% if strDataLancamento = strDataLancamentoFinal then %> / <%=rs("Sequencia")%>. Aula <%end if%> <%=rs("OrigemLancamento")%> <BR>
					<%
					else
					%>
					<input <%=strSelecionado%> <%=strBloqueiaCK%> name="<%=rs("NomeTurma")%>" id="<%=rs("NomeTurma")%>" type="checkbox" value="<%=TotalFaltaTurmaDisciplina%>"/>&nbsp;<%=rs("Desc_Disciplina")%> ( <%=rs("NomeTurma")%> ) - <%=TotalFaltaTurmaDisciplina%> Falta(s) <% if strDataLancamento = strDataLancamentoFinal then %> / <%=rs("Sequencia")%>. Aula <%end if%> <%=rs("OrigemLancamento")%> <BR>
					<%
					end if
				end if
				rs.movenext
				
			wend
			if strTurmaLocalizada = "" then
				%>
                <strong>Disciplina(s) não localizada para o per&iacute;odo de lan&ccedil;amento informado.</strong> 
            	<%
			end if %>			</td>
			<%
		else
			%>
			<script>
				alert("ATENÇÃO: Não foi localizado Turmas para o periodo informado. Verifique!");
			</script>
			<%
			response.end 
		end if	
		rs.close
	
	end if	


		%>
        <input name="txtDataFaltasPeriodo" type="hidden" class="text" id="txtDataFaltasPeriodo" value="<%=strDataFaltas%>" size="100">        
        <input name="cmbSimouNao" type="hidden" class="text" id="cmbSimouNao" value="S" > 
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
    <td colspan="2" class="texto1"> <div align="center"><strong>Listar Justificativas</strong><br>
        <input  <% if strOptListarFaltas = "1" then response.Write("checked")%> name="OptListarFaltas" type="radio" value="1" onClick='submit()'>
      Data da Falta&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <input <% if strOptListarFaltas = "0" then response.Write("checked")%> name="OptListarFaltas" type="radio" value="0" onClick='submit()'>
      Dia do lancamento (Conferir Lan&ccedil;amento)</div><br></td>
    </tr>
  <tr>
    <td colspan="2">
      <%
	  
	 if trim(strDataLancamento) <> "" or intCodModulacaoReferencia <> "" or intCodModulacaoReferencia <> "0" then
		cont =0

		sql = " SELECT "
		sql = sql & " (SELECT TOP 1 CODIGO from SRH_COLABORADOR_FREQUENCIA " 
		sql = sql & " where ANO_LETIVO = CF.ANO_LETIVO "
		sql = sql & " and SEMESTRE_LETIVO = CF.SEMESTRE_LETIVO "
		sql = sql & " and Cod_JustificativaFaltas = CF.Cod_JustificativaFaltas "
		sql = sql & " and codReferencia = CF.CodReferencia "
		sql = sql & " and DATALANCAMENTO = CF.DATALANCAMENTO "
		sql = sql & " and DATALANCAMENTOFINAL = CF.DATALANCAMENTOFINAL "
		sql = sql & " and DataDiaLancamento = CF.DataDiaLancamento "
		sql = sql & " and COD_COLABORADOR = CF.COD_COLABORADOR "
		sql = sql & " and COD_TURMA = CF.COD_TURMA "
		sql = sql & " and ISNULL(COD_DISCIPLINA,'0') = ISNULL(CF.COD_DISCIPLINA,'0')) AS CODIGO, "
		
		sql = sql & " CF.ANO_LETIVO, " 
		sql = sql & " CF.SEMESTRE_LETIVO, " 
		sql = sql & " CF.Cod_JustificativaFaltas, " 
		sql = sql & " CF.CodReferencia, " 
		sql = sql & " CF.DATALANCAMENTO, " 
		sql = sql & " CF.DATALANCAMENTOFINAL, " 
		sql = sql & " CF.DataDiaLancamento, " 
		sql = sql & " CF.COD_COLABORADOR, " 
		sql = sql & " CF.TIPO_COLABORADOR, " 
		sql = sql & " CF.COD_TURMA, " 
		sql = sql & " T.NOMETURMA, " 
		sql = sql & " C.NOME, " 
		sql = sql & " D.DESC_DISCIPLINA , " 
		sql = sql & " isnull(CF.COD_DISCIPLINA,'0') as COD_DISCIPLINA , " 
		sql = sql & " CS.NOME AS COLABORADOR_SUBSTITUTO, " 
		sql = sql & " CF.NUMERO_AULA, " 
		sql = sql & " CF.CONTEUDO_SUBSTITUICAO, " 
		sql = sql & " CF.COD_TURNO, " 
		sql = sql & " TUR.DESC_TURNO AS TURNO, " 
		sql = sql & " CF.SITUACAO as STATUS, "
		sql = sql & " isnull(CF.fechamento,'') as fechamento,  CF.CodColaboradorJustificativa,"
		sql = sql & " SUM(CONVERT(INT, CF.NUMERO_FALTA)) AS NUMERO_FALTA "
		sql = sql & " from SRH_COLABORADOR_FREQUENCIA CF " 
		sql = sql & " LEFT JOIN SCA_TURMA T ON T.COD_TURMA=CF.COD_TURMA  "
		sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.CODIGO = CF.COD_COLABORADOR " 
		sql = sql & " LEFT JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA = CF.COD_DISCIPLINA " 
		sql = sql & " LEFT JOIN SRH_COLABORADOR CS ON CS.CODIGO = CF.COD_COLABORADORSUBSTITUTO " 
		sql = sql & " LEFT JOIN SCA_TURNO TUR ON TUR.Cod_Turno = CF.Cod_Turno " 
		sql = sql & " WHERE CF.TIPO_COLABORADOR <> 'F' and CF.COD_EMPRESA = " & session("CodEmpresa")
		sql = sql & " AND CF.incluido_por = 'faltas_nao_justificadas_professor_cad.asp' "
		sql = sql & " AND cf.CodColaboradorJustificativa is not null "
		if strOptListarFaltas = "1" then
			sql = sql & " and convert(datetime,convert(varchar, cf.DataFalta , 103),103) >= convert(datetime, ' " & strDataInicialModulacao & " ',103)"
			sql = sql & " and convert(datetime,convert(varchar, cf.DataFalta, 103),103) <= convert(datetime, ' " & strDataFinalModulacao & " ',103)"
		else
			sql = sql & " and convert(datetime,convert(varchar, cf.DATALANCAMENTO , 103),103) >= convert(datetime, ' " & strDataInicialModulacao & " ',103)"
			sql = sql & " and convert(datetime,convert(varchar, cf.DATALANCAMENTO, 103),103) <= convert(datetime, ' " & strDataFinalModulacao & " ',103)"
		end if
		sql = sql & " group by " 
		sql = sql & " ANO_LETIVO, " 
		sql = sql & " SEMESTRE_LETIVO, " 
		sql = sql & " CF.Cod_JustificativaFaltas, " 
		sql = sql & " CF.CodReferencia, " 
		sql = sql & " CF.DATALANCAMENTO, " 
		sql = sql & " CF.DATALANCAMENTOFINAL, " 
		sql = sql & " CF.DataDiaLancamento, " 
		sql = sql & " CF.COD_COLABORADOR, " 
		sql = sql & " CF.TIPO_COLABORADOR, " 
		sql = sql & " CF.COD_TURMA, " 
		sql = sql & " T.NOMETURMA, " 
		sql = sql & " C.NOME, " 
		sql = sql & " D.DESC_DISCIPLINA , " 
		sql = sql & " CF.COD_DISCIPLINA ,  "
		sql = sql & " CS.NOME , " 
		sql = sql & " CF.NUMERO_AULA,  "
		sql = sql & " CF.CONTEUDO_SUBSTITUICAO,  "
		sql = sql & " CF.COD_TURNO, " 
		sql = sql & " TUR.DESC_TURNO ,  "
		sql = sql & " CF.SITUACAO , "
		sql = sql & " CF.fechamento, CF.CodColaboradorJustificativa "
		sql = sql & " order by NOME " 
					if ucase(session("usuarioWeb")) = "SERGIO"  THEN
						'response.write "<hr>" & sql
						'response.write "<hr>"
						'response.end	
					end if
		rs.open sql, cnn
		if rs.eof = false then
   %>
        <table width = "100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
          <tr bgcolor="#E5E5E5">
            <td width="7%" class="celula"><div align="center"><strong>Lan&ccedil;amento</strong></div></td>
            <td width="3%" class="celula"><div align="center"><strong>Tipo </strong></div></td>
            <td width="5%" height="21" class="celula"><div align="center"><strong>Exerc&iacute;cio<span class="TextoForm"></span></strong></div></td>
            <td width="4%" class="celula"><div align="center"><strong>Turma</strong></div></td>
            <td width="3%" class="celula"><div align="center"><strong>Turno</strong></div></td>
            <td width="15%" class="celula"><div align="center"><strong>Professor</strong></div></td>
            <td width="6%" class="celula"><div align="center"><strong>Disciplina</strong></div></td>
            <td width="4%" class="celula"><div align="center"><strong>Abono</strong></div></td>
            <td width="14%" class="celula"><div align="center"><strong>Per&iacute;odo Lan&ccedil;amento</strong></div></td>
            <td width="5%" align="center" class="celula"><div align="center"><strong>Situa&ccedil;&atilde;o</strong></div></td>
            <td width="8%" align="center" class="celula"><div align="center"><strong>Enviada</strong></div></td>
            <td width="8%" align="center" class="celula"><div align="center"><strong class="texto1">Enviar</strong></div></td>
            <%if session("nivelPermissao")="A" then%> 
            <td width="8%" align="center" class="celula"><strong>Devolver</strong></td>
            <%end if%>
            <td width="8%" align="center" class="celula"><strong>Imagem</strong></td>
          </tr>
          <%
		  TotalFaltaLancamento = 0
	   while not rs.eof
	   
			cont = cont + 1	
			strDataLancamento          = formatadataAp(rs("DATALANCAMENTO"))
			strDataLancamentoFinal     = formatadataAp(rs("DATALANCAMENTOFINAL"))
			strDataDiaLancamento	   = formatadataAp(rs("DataDiaLancamento"))
			
			strTipoColaborador         = rs("TIPO_COLABORADOR")
			strNomeTurma 			   = rs("NOMETURMA")
			strNomeColaborador   	   = rs("NOME")
			if not isnull(rs("DESC_DISCIPLINA")) then
				strDescDisciplina          = rs("DESC_DISCIPLINA")
			else
				strDescDisciplina          = "Interdisciplinar"
			end if			
			intNumeroFalta             = rs("NUMERO_FALTA")
			strCodProfessorSubstituto  = rs("COLABORADOR_SUBSTITUTO")
			strNumeroAula              = rs("NUMERO_AULA") 
			strConteudoSubstituicao    = rs("CONTEUDO_SUBSTITUICAO")
			if trim(rs("STATUS")) = "S" then
				strSituacao = "ABONO"
			else
				strSituacao = "-----"
			end if
			if trim(strTipoColaborador) = "P" or trim(strTipoColaborador) = "1" then
			   DescricaoTipoColaborador = "Prof."
			else  
			   DescricaoTipoColaborador = "Func."
			end if   
			AnoLetivo = rs("ANO_LETIVO")
			if rs("SEMESTRE_LETIVO") = "3" then
			   nomeSemestre = "Anual"
			else  
			   nomeSemestre = intSemestre
			end if  
			if trim(rs("fechamento")) = "S" then
				strEnviouFalta = "<strong>Sim</strong>"
				strCorlinha = "C1FFC1"
			else
				strEnviouFalta = "Não"
				strCorlinha = "FFFFFF"
			end if
	
			%>	
			<tr bgcolor="#<%=strCorlinha%>" style="cursor:hand" onmouseover="return linhaMouseOver(this)" onmouseout="return linhaMouseOut(this)">
			<td class="celula" onclick="return resultadoConsulta('<%=rs("CODIGO")%>')">&nbsp;<%=strDataDiaLancamento%></td>
			<td class="celula" onclick="return resultadoConsulta('<%=rs("CODIGO")%>')">&nbsp;<%=DescricaoTipoColaborador%></td>
			<td height="20" class="celula" onclick="return resultadoConsulta('<%=rs("CODIGO")%>')">&nbsp;<%=AnoLetivo%>/<%=nomeSemestre%></td>
			<td height="20" class="celula" onclick="return resultadoConsulta('<%=rs("CODIGO")%>')">&nbsp;<%=strNomeTurma%></td>
			<td height="20" class="celula" onclick="return resultadoConsulta('<%=rs("CODIGO")%>')">&nbsp;<%=rs("TURNO")%></td>
			<td height="20" class="celula" onclick="return resultadoConsulta('<%=rs("CODIGO")%>')">&nbsp;<%=strNomeColaborador%></td>
			<td height="20" class="celula" onclick="return resultadoConsulta('<%=rs("CODIGO")%>')">&nbsp;<%=strDescDisciplina%></td>
			<td height="20" class="celula" onclick="return resultadoConsulta('<%=rs("CODIGO")%>')">
			<div align="center">&nbsp;<%=intNumeroFalta%></div></td>
			<td height="20" class="celula" onclick="return resultadoConsulta('<%=rs("CODIGO")%>')">
			<div align="center">&nbsp;<%=strDataLancamento%> a <%=strDataLancamentoFinal%></div></td>
			<td height="20" align="center" class="celula" onclick="return resultadoConsulta('<%=rs("CODIGO")%>')"><%=strSituacao%></td>
			<td align="center" class="celula" onclick="return resultadoConsulta('<%=rs("CODIGO")%>')"><%=strEnviouFalta%></td>
			<td align="center" class="celula">
			<%if trim(rs("fechamento")) <> "S" then%>
			<a href="#" onclick="enviarFaltas('<%=rs("CODIGO")%>')" ><img src="../../images/botao_azul_normal.gif" alt="Enviar faltas" width="26" height="26" border="0"></a>
			<%else%>
			------
			<%end if%></td>
            <%if session("nivelPermissao")="A" then%> 
            <td width="8%" align="center" class="celula"><%if trim(rs("fechamento")) <> "S" then%>---<%else%><a href="#" onclick="devolverFaltas('<%=rs("CODIGO")%>')" ><img src="../../images/botao_azul_normal.gif" alt="Enviar faltas" width="26" height="26" border="0"></a><%end if%></td>
            <%end if%>
            <td align="center" class="celula"><a href="#" onclick="mostraImagem('<%=rs("CodColaboradorJustificativa")%>')"><img src="../../images/consultarImagem.png" width="32" height="32" alt="Consultar Imagem do Documento de Justificativa."></a></td>
            
			<%
			
			TotalFaltaLancamento = TotalFaltaLancamento + intNumeroFalta
			strchave = trim(rs("ANO_LETIVO")) & trim(rs("SEMESTRE_LETIVO")) & trim(rs("Cod_JustificativaFaltas")) & trim(rs("codReferencia")) & trim(rs("DATALANCAMENTO")) & trim(rs("DATALANCAMENTOFINAL")) & trim(rs("DataDiaLancamento")) & trim(rs("COD_COLABORADOR")) 
			rs.movenext
			if rs.eof = false then
				strchave1 = trim(rs("ANO_LETIVO")) & trim(rs("SEMESTRE_LETIVO")) & trim(rs("Cod_JustificativaFaltas")) & trim(rs("codReferencia")) & trim(rs("DATALANCAMENTO")) & trim(rs("DATALANCAMENTOFINAL")) & trim(rs("DataDiaLancamento")) & trim(rs("COD_COLABORADOR")) 
			else
				strchave1 = ""
			end if
			if strchave <> strchave1 then
				%>
                </tr>
                <tr bgcolor="#<%=strCorlinha%>" style="cursor:hand" onmouseover="return linhaMouseOver(this)" onmouseout="return linhaMouseOut(this)">
                <td height="20" colspan="14" align="center" class="celula"><strong>Total de Lan&ccedil;amento:&nbsp;<%=TotalFaltaLancamento%></strong></td>
                </tr>
                <%
				TotalFaltaLancamento = 0
			end if
			
		   wend
		   rs.close
		   %>
          <tr>
            <td height="32" colspan="14" class="celula">Total Registros : <%=cont%></td>
          </table>
          <%
			
	else
		   %>
        <table width = "100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
          <tr bgcolor="#E5E5E5">
          <tr>
            <td height="32" colspan="11" class="celula"><div align="center">N&atilde;o h&aacute; lan&ccedil;amento dentro dessa refer&ecirc;ncia</div></td>
          </table>
          <%
	end if   
	
	end if
	
	%></tr>
</table></td>
	</tr>
</table>
	</td>
    </tr>
    </table>
	</td>
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
function mostraImagem(id){
		window.open("JustificativaFuncionario_img.asp?id=" + id,"abreConsultaImagemJustificativa","top=5,left=5,height=600,width=1000,menubar=no,toolbar=no,scrollbars=yes,status=yes");

	}
	function enviarFaltas(CodRegistroMestre){
		
		var men = 'ATENÇÃO: Deseja enviar as faltas desses colaboradores selecionados?'
		if (confirm(men)) {
			frm.action="JustificativaProfessor_cod.asp?enviarFalta=S&acao=ENVIAR&CodRegistroMestre=" + CodRegistroMestre;
			frm.submit();
			return true;
		} else {
			return false;
		}
	}
function devolverFaltas(CodRegistroMestre){
		
		var men = 'ATENÇÃO: Deseja devolver a falta desse colaborador?'
		if (confirm(men)) {
			frm.action="JustificativaProfessor_cod.asp?devolverFalta=S&CodRegistroMestre=" + CodRegistroMestre;
			frm.submit();
			return true;
		} else {
			return false;
		}
	}
	function dadosSubstituicao()
	{
		
		var frm = document.getElementById("frm");
		
		if (mostraSubstituicao.style.display=="none"){
			mostraSubstituicao.style.display="block"
			frm.imgDadosPessoais.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
		}
		else{
			mostraSubstituicao.style.display="none"
			frm.imgDadosPessoais.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
		}
	}
	
	function resultadoConsulta(intCodigo){
	
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.action = "faltas_nao_justificadas_professor_cad.asp?dtf=";
		frm.submit();
	}
	function reloadDtFinal(){
	
		frm.action = "faltas_nao_justificadas_professor_cad.asp?dtf=s";
		frm.submit();
	}
	function reloadTpLanc(){
	
		frm.action = "faltas_nao_justificadas_professor_cad.asp?tpl=s";
		frm.submit();
	}
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (acao=="E"){
			frm.action="JustificativaProfessor_cod.asp?acao=" + acao;
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
	
			if (frm.cmbJustificativaFaltas.value == "0") {
				alert("A Justificativa deve ser informada !");
				frm.cmbJustificativaFaltas.focus();
				return false;
			}
	
			if (frm.txtDataLancamento.value == "") {
				alert("A Data de Lançamento deve ser informada !");
				frm.txtDataLancamento.focus();
				return false;
			}
			if (frm.txtDataLancamento.value == "0") {
				alert("A Data de Lançamento deve ser informada !");
				frm.txtDataLancamento.focus();
				return false;
			}
			
			
			if (frm.cmbTurnoFaltas.value == "0") {
				alert("O Turno deve ser informado !");
				frm.cmbTurnoFaltas.focus();
				return false;
			}
	
			if (frm.cmbColaboradorFrequencia.value == "0" && acao!="E" ) {
				alert("O Professor Titular deverá ser informado.");
				frm.cmbColaboradorFrequencia.focus();
				return false;
			}
	
			if (frm.cmbSimouNao.value == "0") {
				alert("Verifique a situação do Abono do Lançamento!");
				frm.cmbSimouNao.focus();
				return false;
			}
	
			if (frm.cmbSimouNao.value == "S" && frm.txtJustificativaAbono.value=="") {
				alert("Justificativa do abono deve ser informada!");
				frm.txtJustificativaAbono.focus();
				return false;
			}
			
			$("#txtTexto").val($("#editor").cleanHtml());
			
			if (frm.txtTexto.value == "") {
				alert("A Imagem do documento deve ser informada !");
				return false;
			}
			var textoInicial = frm.txtTexto.value.substring(1,4);
			var tamanho = parseInt(frm.txtTexto.value.length);
			if (textoInicial != "img" && acao=="I"){
				alert("Imagem do documento invalida, devera ser enviado somente documento do tipo IMAGEM!");
				return false;
			}	
			if (tamanho >= 3116802){ 
				alert("Imagem do documento deve ter no máximo 2MB, diminua a imagem e tente enviar novamente!");
				return false;
			}			
			frm.action="faltas_nao_justificadas_professor_cod.asp?acao=" + acao;
			frm.submit();
			return true;
		}
 	}
	
	function verificaDatas(){
		
		var dtini = document.all.txtDataLancamento.value;
		var dtfim = document.all.txtDataLancamentoFinal.value;
		if (dtfim=="") return true;
		
		if ((dtini == '') && (dtfim == '')) {
			return false;
		}
		
		datInicio = new Date(dtini.substring(6,10), 
							 dtini.substring(3,5), 
							 dtini.substring(0,2));
		datInicio.setMonth(datInicio.getMonth() - 1); 
		
		
		datFim = new Date(dtfim.substring(6,10), 
						  dtfim.substring(3,5), 
						  dtfim.substring(0,2));
						 
		datFim.setMonth(datFim.getMonth() - 1); 
	
		if(datInicio <= datFim){
			reloadDtFinal();
			return true;
		} else {
			alert('ATENÇÃO: Data Inicial é maior que Data Final');
			document.all.txtDataLancamentoFinal.focus();
			document.all.txtDataLancamentoFinal.select();
			return false;
		}    
	}
</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--include file="../jsModulo.asp"-->
</body>
</html> 