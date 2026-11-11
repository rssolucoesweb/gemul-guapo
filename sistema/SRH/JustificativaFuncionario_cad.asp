<%
Response.Buffer = False
RESPONSE.Expires=0
Server.ScriptTimeout = 1200 'valor em segundos
%>
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
										
										if rsAux("ITEM_INFO_URL") = "JustificativaFuncionario_cad.asp" then 
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
	strPaginaTitulo                  			= "JustificativaFuncionario_cad.asp"
	strPagina						 			= "JustificativaFuncionario_cad.asp"
	strExecutarSubmitModulacaoReferencia        = "S"

	strExecutarSubmitProfessorTurma             = "S"
	strExecutarSubmitTurma	 		            = "S"
	strExecutarSubmitDisciplinaProfessorTurma   = "S"
	strSimouNao_submit                          = "S"
	strExecutarSubmitColaborador				= "S"
	strExecutarSubmitColaboradorFrequencia		= "S"
	tipo_colaborador							= Trim(Request("tipo_colaborador"))
	if tipo_colaborador = "" then tipo_colaborador = "F"
	if tipo_colaborador = "P" then
		%>
		<script>
			window.location="JustificativaProfessor_cad.asp";
		</script>
		<%
		response.End()
	end if
	
	intCodigo           	  					= Trim(Request.Form("txtCodigo"))
	intCodModulacaoReferencia 					= Trim(Request("cmbModulacaoReferencia"))
	if intCodModulacaoReferencia = "" then intCodModulacaoReferencia = "0"
	intCodJustificativaFaltas					= Trim(Request.form("cmbJustificativaFaltas"))
	if intCodJustificativaFaltas = "" then intCodJustificativaFaltas = "0"

	strDataLancamento         					= Trim(Request("txtDataLancamento"))
	strDataLancamentoFinal        				= Trim(Request("txtDataLancamentoFinal"))
	intCodColaborador	         	 			= Trim(Request("cmbColaborador")) 
	intCodProfessor								= intCodColaborador
	strComparaDataLancamento 					= formataDataCalc(Trim(Request("txtDataLancamento")))
	strTipoLancamento          					= Trim(Request("optTipoLancamento"))
	strOptTipoColaborador     					= Trim(Request("optTipoColaborador"))
	strJustificativaAbono    					= Trim(Request("txtJustificativaAbono"))
	strJustificativa          					= Trim(Request("txtJustificativa"))
	strSimouNao               					= Trim(Request("cmbSimouNao"))
	strFechamento             					= Trim(Request("cmbFechamento"))
	strOptListarFaltas     						= Trim(Request.form("OptListarFaltas"))
	if strOptListarFaltas = "" then strOptListarFaltas = "1"

	if strSimouNao = "" or strSimouNao = "0" then strSimouNao = "N"
	
	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir

	if intCodigo <> "" and intCodigo <> "0"  then
	
		cont =0
		sql = " SELECT J.CODIGO, "
		sql = sql & " cod_empresa, "
		sql = sql & " Cod_JustificativaFaltas, "
		sql = sql & " CodReferencia, "
		sql = sql & " periodo_modulacao, "
		sql = sql & " ano_letivo, "
		sql = sql & " semestre_letivo, "
		sql = sql & " DataLancamento, "
		sql = sql & " DataLancamentoFinal, "
		sql = sql & " DataDiaLancamento, "
		sql = sql & " tipo_colaborador, "
		sql = sql & " j.cod_colaborador, "
		sql = sql & " Cod_Funcao, "
		sql = sql & " justificativa, "
		sql = sql & " situacao, "
		sql = sql & " Fechamento, CFI.imagem, "
		sql = sql & " Fechamento_devolvido, "
		sql = sql & " tipoLancamento "
		sql = sql & " from SRH_COLABORADOR_JUSTIFICATIVA J"
		sql = sql & " INNER JOIN SRH_COLABORADOR_JUSTIFICATIVA_IMAGEM CFI ON CFI.COD_COLABORADOR_JUSTIFICATIVA = J.CODIGO"
		sql = sql & " WHERE J.CODIGO = " & intCodigo
		rs.open sql, cnn
		if rs.eof = false then
		
			intCodigo           	  					= rs("CODIGO")
			intCodModulacaoReferencia 					= trim(rs("codReferencia"))
			intCodJustificativaFaltas					= trim(rs("Cod_JustificativaFaltas"))
			strDataLancamento         					= trim(rs("DATALANCAMENTO"))
			strDataLancamentoFinal        				= trim(rs("DATALANCAMENTOFINAL"))
			intCodColaborador         	 				= Trim(rs("COD_COLABORADOR"))
			strComparaDataLancamento 					= formataDataCalc(trim(rs("DATALANCAMENTO")))
			strTipoLancamento          					= Trim(rs("tipoLancamento"))
			strOptTipoColaborador     					= Trim(rs("TIPO_COLABORADOR"))
			strJustificativa          					= Trim(rs("JUSTIFICATIVA"))
			strFechamento             					= trim(rs("FECHAMENTO"))
			intAnoLetivo								= trim(rs("ANO_LETIVO"))
			strAnoLetivo								= trim(rs("ANO_LETIVO"))
			intSemestre									= trim(rs("SEMESTRE_LETIVO"))
			strimagem									= trim(rs("imagem"))
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
		end if	
		rs.close
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
    <form id="frm" method="post" action="JustificativaFuncionario_cad.asp">
    <input name="dtf" type="hidden" id="dtf" class="text" size="10" value="<%=request("dtf")%>" >
    <input name="tpl" type="hidden" id="tpl" class="text" size="10" value="<%=request("tpl")%>" >
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Lançamento de Justificativa/Abono de Faltas</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                
                <div class="form-group">
            	
                	<table width="98%" border="0" cellspacing="0"  align="center" cellpadding="0">
  <tr>
    <td width="245" class="texto1">&nbsp;</td>
    <td width="1062"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10"></td>
  </tr>
  
  <tr style="background:#CCC">
    <td height="20" class="texto1">Tipo de Colaborador</td>
    <td class="texto1">
    <input type="radio" name="tipo_colaborador" id="tipo_colaborador" value="F" <%if tipo_colaborador = "F" then response.Write("checked")%> onclick="submit()">
    <strong>Funcionário</strong>&nbsp;&nbsp;&nbsp;&nbsp;
    <input type="radio" name="tipo_colaborador" id="tipo_colaborador" value="P" <%if tipo_colaborador = "P" then response.Write("checked")%> onclick="submit()"> 
    <strong>Professor</strong>
</td>
  </tr>
  <tr>
    <td height="13" class="texto1">&nbsp;</td>
    <td class="texto1">&nbsp;</td>
  </tr>
  <tr>
    <td height="27" class="texto1">Refer&ecirc;ncia:</td>
    <td class="texto1"><!--#include file="../includes/inc_PeriodoModulacao.asp" -->
      - De: <%=formataDataAP(strDataInicialModulacao)%> a <%=formataDataAP(strDataFinalModulacao)%></td>
  </tr>
  <tr>
    <td height="27" class="texto1">Tipo de Falta</td>
    <td class="texto1"><!--#include file="../includes/inc_cmbJustificativaFaltas.asp" -->

  </tr>
  <tr>
    <td height="27" class="texto1">Data Inicial do Lan&ccedil;amento</td>
    <td class="texto1"><input name="txtDataLancamento" type="text" class="text" id="txtDataLancamento" onblur="return validaData(this)" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataLancamento%>"  onChange='reloadDtFinal()' title="Click aqui para visualizar o calend&aacute;rio"></td>
  </tr>
  <%

	
	'calculando da data final
	bloqcampodatafinal=""
	classcampodatafinal = "text"
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

	if strDataLancamento <> "" and intCodModulacaoReferencia <> "0" and intCodModulacaoReferencia <> "" and intCodigo ="" then

		if cCur(strComparaDataLancamento) < cCur(strComparaDataInicialModulacao) then
			%>
			<script>
				alert("ATENÇÃO: A data informada não confere com o período de referência. Verifique!");
				//window.location='FaltaFuncionario_Cad.asp';
			</script>
			<% 
			
			strDataLancamento = formataDataAP(strDataInicialModulacao)
			strDataLancamentoFinal = formataDataAP(strDataFinalModulacao)
		  	'response.end
		else
			if cCur(strComparaDataLancamento) > cCur(strComparaDataFinalModulacao) then
				%>
				<script>
					alert("ATENÇÃO: A data informada não confere com o período de referência. Verifique!");
					//window.location='FaltaFuncionario_Cad.asp';
				</script>
				<% 
				strDataLancamento = formataDataAP(strDataInicialModulacao)
				strDataLancamentoFinal = formataDataAP(strDataFinalModulacao)
			  	'response.end
			end if
		end if
	end if
	if strDataLancamento <> "" and intCodModulacaoReferencia <> "0" and intCodModulacaoReferencia <> "" then
		if strComparaDataLancamentoFinal<>"" and strComparaDataInicialModulacao<>"" then
			if cCur(strComparaDataLancamentoFinal) < cCur(strComparaDataInicialModulacao) then
				%>
				<script>
					alert("ATENÇÃO: A data informada não confere com o período de referência. Verifique!");
					//window.location='FaltaFuncionario_Cad.asp';
				</script>
				<% 
				strDataLancamento = formataDataAP(strDataInicialModulacao)
				strDataLancamentoFinal = formataDataAP(strDataFinalModulacao)
				'response.end
			end if
		end if
	end if
	%>
    <tr>
        <td height="27" class="texto1">Data Final do Lan&ccedil;amento</td>
        <td class="texto1"><input <%=bloqcampodatafinal%> name="txtDataLancamentoFinal" type="text" class="<%=classcampodatafinal%>" id="txtDataLancamentoFinal" onblur="validaData(this);verificaDatas();" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataLancamentoFinal%>" title="Click aqui para visualizar o calend&aacute;rio"></td>
    </tr>
    <tr>
        <td height="27" class="texto1"> Titular</td>
        <td class="texto1"><!--#include file="../includes/inc_cmdFuncionarioJustificativaModulacao.asp" -->
        &nbsp;Colaborador que enviará a justificativa.</td>
    </tr>
  <tr>
    <td height="64" class="texto1">Justificativa de Falta</td>
    <td class="texto1"><textarea name="txtJustificativa" style="width:520px" cols="120" rows="3" class="text" id="txtJustificativa"><%=strJustificativa%></textarea>
     </td>
  </tr>
    
    <input  <% if strOptTipoColaborador = "1" then response.Write("checked")%> name="optTipoColaborador" type="hidden" value="1" onClick='submit()'>
        <input <% if strOptTipoColaborador = "0" then response.Write("checked")%> name="optTipoColaborador" type="hidden" value="0" onClick='submit()'>
        <input <%if strTipoLancamento = "D" then response.Write("checked")%>  type="hidden" name="optTipoLancamento" id="optTipoLancamento" value="D" onclick="reloadTpLanc()">
        <input type="hidden" <%if strTipoLancamento = "I" then response.Write("checked")%> name="optTipoLancamento" id="optTipoLancamento" value="I"  onClick="reloadTpLanc()">

  <% 

  if intCodProfessor <> "" and intCodProfessor <> "0"  then
		
		if intCodModulacaoReferencia <> "" then
		
			sql = "select AnoReferencia, SemestreReferencia from SRH_MODULACAO_REFERENCIA WHERE CODIGO = " & intCodModulacaoReferencia
			rs.open sql, cnn
			if rs.eof = false then
				strAnoLetivoReferencia  = rs("AnoReferencia")
				intSemestreReferencia 	= rs("SemestreReferencia")
			end if
			rs.close
			
			if intAnoLetivo = strAnoLetivoReferencia and intSemestre = intSemestreReferencia then
				'Será permitido o lancamento, pois a modulação confere com o período de referencia escolhido.
			else
				%>
				<script>
					alert("ATENÇÃO: Período de REFERÊNCIA não confere com Período de MODULAÇÃO. Verifique!");
					window.location='JustificativaFuncionario_Cad.asp';
				</script>
				<%
				response.end 
			end if	
	
		end if

	end if
%>
<input name="txtCodFuncaoFuncionario" type="hidden" id="txtCodFuncaoFuncionario" class="text" size="10" value="<%=strCodFuncaoFuncionario%>" >
<input name="txtCodTurnoFuncionario" type="hidden" id="txtCodTurnoFuncionario" class="text" size="10" value="<%=strCodTurnoFuncionario%>" >
  <input name="txtAnoLetivo" type="hidden" class="text" id="txtAnoLetivo"  value="<%=intAnoLetivo%>">
  <input name="cmbSemestre" type="hidden" class="text" id="cmbSemestre"  value="<%=intSemestre%>"></td>


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
  <tr>
    <td colspan="2"><br>
      <!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
  </tr>
  <tr>
    <td colspan="2">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="2" class="texto1"> <div align="center"><strong>Listar Justificativas</strong></div></td>
    </tr>
  <tr>
    <td colspan="2">
      <%
	  
	 if intCodModulacaoReferencia <> "" or intCodModulacaoReferencia <> "0" then
		cont =0

		sql = "SELECT cf.CODIGO, "
		sql = sql & " CF.ANO_LETIVO, CF.SEMESTRE_LETIVO, CF.Cod_JustificativaFaltas, CF.CodReferencia, CF.DATALANCAMENTO, "
		sql = sql & " CF.DATALANCAMENTOFINAL, CF.DataDiaLancamento, CF.COD_COLABORADOR, CF.TIPO_COLABORADOR, C.NOME, C.codFuncional, CS.NOME AS COLABORADOR_SUBSTITUTO,"
		sql = sql & "  CF.SITUACAO as STATUS, isnull(CF.fechamento,'') as fechamento, "
		sql = sql & " (SELECT DATEDIFF(day, CF.DATALANCAMENTO, CF.DATALANCAMENTOFINAL)+1) AS NUMERO_JUSTIFICATIVAS "
		sql = sql & " from SRH_COLABORADOR_JUSTIFICATIVA CF "
		sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.CODIGO = CF.COD_COLABORADOR "
		sql = sql & " LEFT JOIN SRH_COLABORADOR CS ON CS.CODIGO = CF.COD_COLABORADORSUBSTITUTO "
		sql = sql & " WHERE CF.COD_EMPRESA = " & session("CodEmpresa")
		sql = sql & " and (CF.incluido_por = 'JustificativaFuncionario_cad.asp' OR CF.incluido_por IS NULL)" 
		sql = sql & " and ((('" & formatadataBD(strDataInicialModulacao) & "' BETWEEN CF.DATALANCAMENTO AND CF.DATALANCAMENTOFINAL) "
		sql = sql & " or ('" & formatadataBD(strDataFinalModulacao) & "' BETWEEN CF.DATALANCAMENTO AND CF.DATALANCAMENTOFINAL) "	
		sql = sql & " )"
		sql = sql & " OR ("
		sql = sql & " ("
		sql = sql & " (CF.DATALANCAMENTO BETWEEN '" & formatadataBD(strDataInicialModulacao) & "' AND '" & formatadataBD(strDataFinalModulacao) & "' )"
		sql = sql & "  OR "
		sql = sql & " (CF.DATALANCAMENTOFINAL BETWEEN '" & formatadataBD(strDataInicialModulacao) & "' AND '" & formatadataBD(strDataFinalModulacao) & "') "
		sql = sql & " )"
		sql = sql & " ))"
		
		sql = sql & " order by DataDiaLancamento DESC, NOME " 
		'response.write sql
		rs.open sql, cnn
		if rs.eof = false then
   %>
        <table width = "100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
          <tr bgcolor="#E5E5E5">
            <td width="7%" class="celula"><div align="center"><strong>Lan&ccedil;amento</strong></div></td>
            <td width="3%" class="celula"><div align="center"><strong>Tipo </strong></div></td>
            <td width="5%" height="21" class="celula"><div align="center"><strong>Exerc&iacute;cio<span class="TextoForm"></span></strong></div></td>
            <td width="34%" class="celula"><div align="center"><strong>Colaborador</strong></div></td>
            <td width="3%" class="celula"><div align="center"><strong>Dias</strong></div></td>
            <td width="21%" class="celula"><div align="center"><strong>Per&iacute;odo Lan&ccedil;amento</strong></div></td>
            <td width="6%" align="center" class="celula"><div align="center"><strong>Situa&ccedil;&atilde;o</strong></div></td>
            <td width="5%" align="center" class="celula"><div align="center"><strong> Enviada</strong></div></td>
            <td width="8%" align="center" class="celula"><div align="center"><strong class="texto1">Enviar </strong></div></td>
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
			strNomeColaborador   	   = rs("NOME")
			intNumeroJustificativas    = rs("NUMERO_JUSTIFICATIVAS")
			strCodProfessorSubstituto  = rs("COLABORADOR_SUBSTITUTO")
			if trim(rs("STATUS")) = "S" then
				strSituacao = "ABONO"
			else
				strSituacao = "-----"
			end if
			if trim(strTipoColaborador) = "F" then
			   DescricaoTipoColaborador = "Func."
			else  
			   DescricaoTipoColaborador = "Prof."
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
			<td height="20" class="celula" onclick="return resultadoConsulta('<%=rs("CODIGO")%>')">&nbsp;<%=strNomeColaborador%> - <%=rs("codFuncional")%></td>
			<td height="20" class="celula" onclick="return resultadoConsulta('<%=rs("CODIGO")%>')">
			  <div align="center">&nbsp;<%=intNumeroJustificativas%></div></td>
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
			<td align="center" class="celula"><a href="#" onclick="mostraImagem('<%=rs("CODIGO")%>')"><img src="../../images/consultarImagem.png" width="32" height="32" alt="Consultar Imagem do Documento de Justificativa."></a></td>
			<%
			  
			rs.movenext

	   wend
	   rs.close
	   %>
	  <tr>
		<td height="32" colspan="10" class="celula">Total Registros : <%=cont%></td>
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
	function enviarFaltas(CodRegistroMestre){
		
		var men = 'ATENÇÃO: Deseja enviar a justificativa desse colaborador?'
		if (confirm(men)) {
			frm.action="justificativaFuncionario_cod.asp?enviarFalta=S&acao=ENVIAR&CodRegistroMestre=" + CodRegistroMestre;
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
		frm.action = "JustificativaFuncionario_cad.asp?dtf=";
		frm.submit();
	}
	
	function mostraImagem(id){
		window.open("JustificativaFuncionario_img.asp?id=" + id,"abreConsultaImagemJustificativa","top=5,left=5,height=600,width=1000,menubar=no,toolbar=no,scrollbars=yes,status=yes");

	}
	function reloadDtFinal(){
		var frm = document.getElementById("frm");
		frm.action = "JustificativaFuncionario_cad.asp?dtf=s";
		frm.submit();
	}
function devolverFaltas(CodRegistroMestre){
		
		var men = 'ATENÇÃO: Deseja devolver a falta desse colaborador?'
		if (confirm(men)) {
			frm.action="JustificativaFuncionario_cod.asp?devolverFalta=S&CodRegistroMestre=" + CodRegistroMestre;
			frm.submit();
			return true;
		} else {
			return false;
		}
	}	
	function reloadTpLanc(){
		var frm = document.getElementById("frm");
		frm.action = "JustificativaFuncionario_cad.asp?tpl=s";
		frm.submit();
	}
	
	function Right(str, n){
		if (n <= 0)
		   return "";
		else if (n > String(str).length)
		   return str;
		else {
		   var iLen = String(str).length;
		   return String(str).substring(iLen, iLen - n);
		}
	}
	function salvar(acao){
		
		var frm = document.getElementById("frm");

		if (acao=="E"){
			frm.action="JustificativaFuncionario_cod.asp?acao=" + acao;
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
	
	
			if (frm.txtDataLancamento.value == "") {
				alert("A Data de Lançamento deve ser informada !");
				frm.txtDataLancamento.focus();
				return false;
			}
			
			if (frm.cmbColaborador.value == "0" && acao!="E" ) {
				alert("O Colaborador deverá ser informado.");
				frm.cmbColaborador.focus();
				return false;
			}
			if (frm.txtJustificativa.value == "") {
				alert("A Justificativa deve ser informada !");
				frm.txtJustificativa.focus();
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
			
			frm.action="JustificativaFuncionario_cod.asp?acao=" + acao;
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
</script>    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--include file="../jsModulo.asp"-->
</body>
</html> 