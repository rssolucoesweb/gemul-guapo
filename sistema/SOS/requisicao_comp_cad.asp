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
            <h1 class="pull-left">OS - Ordem de Serviço</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	
<%
	acao = "I"
	submitArea = "S"
	strPaginaTitulo                  			= "requisicao_cad.asp"
	submitTipoAndamento = "S"
	strPagina						 			= "requisicao_cad.asp"

	intCodigo           	  					= Trim(Request.Form("txtCodigo"))
	intCodArea				 					= Trim(Request("cmbArea"))
	intCodTipoServicoOS							= Trim(Request("cmbTipoServicoOS"))
	intCodPrioridade							= Trim(Request("cmbPrioridade"))
	intCodTipoAndamento							= Trim(Request("cmbTipoAndamento"))
	strResumo          							= Trim(Request("txtResumo"))
	strAnoLetivo								= session("strAnoLetivo")

	
	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	
	if intCodigo <> "" and intCodigo <> "0"  then
	
		cont =0
		sql = " SELECT r.Codigo, r.cod_empresa, r.cod_tipo_servico, t.cod_area, r.resumo, r.data, r.situacao, r.enviado_por, r.data_envio "
		sql = sql & " from sos_requisicao r inner join sos_tipo_servico t on t.codigo=r.cod_tipo_servico"
		sql = sql & " WHERE r.CODIGO = " & intCodigo
		rs.open sql, cnn
		if rs.eof = false then
			intCodigo           	  					= rs("CODIGO")
			intCodTipoServicoOS		 					= trim(rs("cod_tipo_servico"))
			intCodArea									= trim(rs("cod_area"))
			strResumo		         					= trim(rs("resumo"))
			strSituacao		         					= trim(rs("situacao"))
			acao = "A"
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
		end if	
		rs.close
		
		'busca imagem
		sql = " select imagem from SOS_REQUISICAO_IMAGEM where cod_requisicao = " & intCodigo
		rsAux.open sql, cnn
		if rsAux.eof = false then
			strimagem           	  					= rsAux("imagem")
		end if
		rsAux.close
	end if	



%>
    <!--=== Content Part ===-->
<form id="frm" method="post" action="requisicao_comp_cad.asp">

    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Solicitação de Ordem de Serviço</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            	<div class="panel-body">                                                        

                    <div class="form-group">
                    
<table width="98%" border="0" cellspacing="0"  align="center" cellpadding="0">
  <tr>
    <td width="245" class="texto1">&nbsp;</td>
    <td width="1062"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
      </td>
  </tr>
  <tr>
    <td height="27" class="texto1">Departamento</td>
    <td class="texto1"><!--#include file="../includes/inc_cmbArea.asp" --></td>
  </tr>
  <tr>
    <td height="27" class="texto1">Tipo de Serviço</td>
    <td class="texto1"><!--#include file="../includes/inc_cmbTipoServicoOS.asp" -->
  <input name="txtAnoLetivo" type="hidden" class="text" id="txtAnoLetivo"  value="<%=intAnoLetivo%>">
  <input name="cmbSemestre" type="hidden" class="text" id="cmbSemestre"  value="<%=intSemestre%>">
  </td>
  </tr>
  <tr>
    <td height="64" class="texto1">Resumo do serviço</td>
    <td class="texto1"><textarea name="txtResumo" style="width:520px" cols="120"  rows="3" class="text" id="txtResumo"><%=strResumo%></textarea></td>
  </tr>
<tr>
    <td height="13" class="texto1">Imagem do serviço a ser executado<br>
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
	if trim(strSituacao) <> "INCLUIDO" and acao = "A" then
		strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if
	
  	if intCodTipoAndamento = "" then intCodTipoAndamento = "1"
  %>
  <tr>    <td colspan="2"><br><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
  </tr>
  <tr>
    <td colspan="2">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="2" class="texto1"> <div align="center"><strong>Requisições com situação</strong> <!--#include file="../includes/inc_cmbTipoAndamento.asp" -->
    </div></td>
    </tr>
  <tr>
    <td colspan="2">
      <%
	  
	 if trim(intCodTipoAndamento) <> "" then
		cont =0
		
		sql = "select r.CODIGO, tp.item, tp.descricao as tipo_servico,tp.cod_area, (select top 1 t.descricao + '<br>' +  CONVERT(VARCHAR(10), a.data_hora_incl, 103) + ' ' + CONVERT(VARCHAR(8), a.data_hora_incl, 108)  + ' por ' + a.usuario_incl from SOS_REQUISICAO_andamento a inner join sos_tipo_andamento t on t.codigo = a.cod_tipo_andamento where a.cod_requisicao=r.codigo order by a.data_hora_incl desc) as situacao , a.descricao as area, r.data, r.resumo"
		sql = sql & " from SOS_REQUISICAO r "
		sql = sql & " inner join SOS_TIPO_SERVICO tp on tp.codigo = r.cod_tipo_servico "
		sql = sql & " inner join SOS_AREA a on a.codigo = tp.cod_area "
		if intCodTipoAndamento <> "0" then
			sql = sql & " where r.CODIGO in (select cod_requisicao from SOS_REQUISICAO_andamento  where cod_tipo_andamento = " & intCodTipoAndamento & ")"
		end if
		sql = sql & " order by tp.cod_prioridade desc, r.data "
		rs.open sql, cnn
		if rs.eof = false then
  		%>
        <table width = "100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
          <tr bgcolor="#E5E5E5">
            <td width="12%" height="21" class="celula"><div align="center"><strong>Data</strong></div></td>
            <td width="23%" class="celula"><div align="center"><strong>Área/Tipo de Serviço</strong></div></td>
            <td width="30%" class="celula"><div align="center"><strong>Resumo do Serviço</strong></div></td>
            <td width="12%" align="center" class="celula"><div align="center"><strong>Situa&ccedil;&atilde;o</strong></div></td>
            <td width="2%" align="center" class="celula"><strong>Foto</strong></td>
            <td width="2%" align="center" class="celula"><strong>Editar</strong></td>
          </tr>
          <%
	   while not rs.eof
			cont = cont + 1	
			%>	
            <tr style="cursor:hand" onmouseover="return linhaMouseOver(this)" onmouseout="return linhaMouseOut(this)">
                <td class="celula"><%=RS("DATA")%></td>
                <td class="celula"><%=RS("cod_area")%>. <%=RS("AREA")%><br><%=RS("cod_area")%>.<%=RS("item")%>. <%=RS("TIPO_SERVICO")%></td>
                <td height="20" class="celula"><%=RS("RESUMO")%></td>
                <td height="20" class="celula"><%=RS("SITUACAO")%></td>
                <td align="center" class="celula"><a href="#" onclick="mostraImagem('<%=rs("codigo")%>')"><img src="../../images/consultarImagem.png" width="32" height="32" alt="Consultar Imagem da OS."></a></td>
                 <td align="center" >
                	<button class="btn-u btn-u-sea" onclick="resultadoConsulta(<%=trim(rs("codigo"))%>)" type="button"><i class="fa fa-file-text-o"></i></button>                            
                </td>
            </tr>
                <%
				RS.MOVENEXT
		   wend
		   rs.close
		   %>
          <tr>
            <td height="32" colspan="7" class="celula">Total Registros : <%=cont%></td>
          </table>
          <%
			
	else
		   %>
        <table width = "100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
          <tr bgcolor="#E5E5E5">
          <tr>
            <td height="32" colspan="11" class="celula"><div align="center">N&atilde;o h&aacute; lan&ccedil;amentos</div></td>
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
		window.open("requisicao_img.asp?id=" + id,"abreConsultaImagem","top=5,left=5,height=600,width=1000,menubar=no,toolbar=no,scrollbars=yes,status=yes");

	}
	function resultadoConsulta(intCodigo){
	
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.action = "requisicao_comp_cad.asp";
		frm.submit();
	}
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (acao=="E"){
			frm.action="requisicao_cod.asp?pg=comp&acao=" + acao;
			frm.submit();
			return true;
		}
		else
		{
			if (frm.cmbArea.value == "0") {
				alert("Area deve ser informada!");
				frm.cmbArea.focus();
				return false;
			}
	
			if (frm.cmbTipoServicoOS.value == "0") {
				alert("O tipo de serviço deve ser informado!");
				frm.cmbTipoServicoOS.focus();
				return false;
			}
			if (frm.txtResumo.value == "") {
				alert("O resumo da requisição da ordem de serviço deve ser informada!");
				frm.txtResumo.focus()
				return false;
			}
			$("#txtTexto").val($("#editor").cleanHtml());
			
			/*
			if (frm.txtTexto.value == "") {
				alert("A Imagem do documento deve ser informada !");
				return false;
			}
			*/

			var textoInicial = frm.txtTexto.value.substring(1,4);
			var tamanho = parseInt(frm.txtTexto.value.length);
			/*
			if (textoInicial != "img" && acao=="I"){
				alert("Imagem do documento invalida, devera ser enviado somente documento do tipo IMAGEM!");
				return false;
			}	
			*/
			if (tamanho >= 3116802){ 
				alert("Imagem do documento deve ter no máximo 2MB, diminua a imagem e tente enviar novamente!");
				return false;
			}			
			frm.action="requisicao_cod.asp?pg=comp&acao=" + acao;
			frm.submit();
			return true;
		}
 	}
	
</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--include file="../jsModulo.asp"-->
</body>
</html> 