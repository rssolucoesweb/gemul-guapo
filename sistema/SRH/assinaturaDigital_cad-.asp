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

	strPaginaTitulo                  			= "assinaturaDigital_cad.asp"
	strPagina						 			= "assinaturaDigital_cad.asp"

	intCodigo           	  					= Trim(Request.Form("txtCodigo"))
	intCodColaborador        	 				= Trim(Request("cmbColaborador")) 
	
	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	
	if intCodigo <> "" and intCodigo <> "0"  then
	
		cont =0
		sql = " SELECT * "
		sql = sql & " from SRH_COLABORADOR_ASSINATURA_DIGITAL "
		sql = sql & " WHERE F.CODIGO = " & intCodigo
		rs.open sql, cnn
		if rs.eof = false then
		
			intCodigo           	  					= rs("CODIGO")
			strimagem									= trim(rs("imagem"))
			acao = "A"
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
		end if	
		rs.close
		
		
	end if	
%>
    <!--=== Content Part ===-->
<form id="frm" method="post" action="assinaturaDigital_cad.asp">
<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
<input name="txtAnoLetivo" type="hidden" id="txtAnoLetivo" value="<%=strAnoLetivoReferencia%>">
<input name="txtSemestre" type="hidden" id="txtSemestre" value="<%=intSemestreReferencia%>">
			
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Assinatura digital</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            	<div class="panel-body">                                                        

                    <div class="form-group">
                    
<table width="98%" border="0" cellspacing="0"  align="center" cellpadding="0">
  
    <tr>
        <td height="27" class="texto1"> Colaborador:</td>
        <td class="texto1"><!--#include file="../includes/inc_cmdFuncionarioFrequencia.asp" --></td>
    </tr>
	
	<tr>
    <td height="13" class="texto1">Imagem da assinatura<br>
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
		<%if intCodModulacaoReferencia <> "" then%><div align="center"><strong>Lista de assinturas</strong><%end if%></td>
    </tr>
  <tr>
    <td colspan="2">
	<%
		sql="select c.codigo, c.codFuncional, c.nome as colaborador, a.imagem"
		sql=sql & " from [dbo].[SRH_COLABORADOR_ASSINATURA_DIGITAL] a"
		sql=sql & " inner join SRH_COLABORADOR c on c.codigo = a.codColaborador"
		sql=sql & " order by 1,2"
		RS.OPEN SQL, CNN
		IF NOT RS.EOF THEN
		%> 
		   <table width = "100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
				<tr  bgcolor="#E2E2E2">
					<th width="1%" align="center"><input name="chkTodos" type="checkbox" value="" onClick="return marcaTodos()"></th>
					<th width="30%" align="center" class="tamanho11">Colaborador</th>
					<th width="20%"  align="center" class="tamanho11">Assinatura</th>
				</tr>
				<%
				
				Total_Aulas = 0
				while not rs.eof
					cont = cont + 1	
					%>
					<tr <%if trim(rs("fechamento")) <> "S"  then%> class="pointer" <%end if%> bgcolor="#<%=strCorlinha%>"  onmouseover="return linhaMouseOver(this)" onmouseout="return linhaMouseOut(this)">
						<td><input name="chkCodigo" type="checkbox" value="<%=rs("codigo")%>"></td>
						<td onclick="return resultadoConsulta('<%=rs("CODIGO")%>')"><%=RS("colaborador")%>&nbsp;<i class="tamanho9">(<%=rs("codFuncional")%>)</i></td>
						<td onclick="return resultadoConsulta('<%=rs("CODIGO")%>')"><%=RS("imagem")%></td>
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
				Nenhum assinatura cadastrada!
			</tr>
		<tr>
	</table>
  <%
	end if

%>
	  
	  
	  
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
	
	function resultadoConsulta(intCodigo){
	
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
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
			if (frm.cmbColaborador.value == "0" && acao!="E" ) {
				alert("O colaborador deverá ser informado.");
				frm.cmbColaborador.focus();
				return false;
			}
			
			
			$("#txtTexto").val($("#editor").cleanHtml());
			
			if (frm.txtTexto.value == "") {
				alert("A Imagem da assinatura deve ser inserida!");
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
			frm.action="assinaturaDigital_cod.asp?acao=" + acao;
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
</script>

<!--=== End Content Part ===-->
<!--#include file="../RodapeModulo.asp"-->
<!--include file="../jsModulo.asp"-->
</body>
</html> 