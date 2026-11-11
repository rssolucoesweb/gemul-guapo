<!--
    ::	Data de Criação...: 15/02/2017
    ::	Desenvolvedores...: Sérgio Borges - sergio@rssolucoesweb.com.br
    ::	Objetivo Pagina...: Registro de Ponto
-->
<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8"> <![endif]-->
<!--[if IE 9]> <html lang="en" class="ie9"> <![endif]-->
<!--[if !IE]><!--> <html lang="pt-br"> <!--<![endif]-->  
<head>
    <title>:: Gemul - Gestor de Município :: </title>

    <!-- Meta -->
    <meta http-equiv="X-UA-Compatible" content="IE=10, IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
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
		.form-control{
		    font-size: 24px !important;
		}
		.btn-u{
		    font-size: 28px !important;
		}
	</style>
</head>
<body onload="moveRelogio()">
<!--#include file="../../includes/inc_cnn.asp"-->
 
<div class="wrapper">
    <!--=== Header ===-->
    <div class="header">
    	<!-- Topbar -->
        <div class="topbar">
            <div class="container">
                <!-- Topbar Navigation -->
                <ul class="loginbar pull-right">
                	<li class="topbar-devider"></li>
                	
                </ul>
                <!-- End Topbar Navigation -->
            </div>
        </div>
        <!-- End Topbar -->
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
                        <!-- Sair do sistema -->
                        <li class="dropdown active">
                            <li class="page-scroll">
                              <H1><strong> REGISTRO DE PONTO </strong></H1>
                            </li>
                        </li>
                        <!-- End Contacts -->
                    </ul>
                </div><!--/navbar-collapse-->
            </div>
        </div>
        <!-- End Navbar -->
    </div>
    <!--=== End Header ===-->
<%
	intCodGrupo = request("Grupo")
	intCodEmpresa = request("Unidade")
	
	if not isnumeric(intCodGrupo) then intCodGrupo = "0"
	if not isnumeric(intCodEmpresa) then intCodGrupo = "0"
	
	if trim(intCodGrupo) <> "0" and trim(intCodEmpresa) <> "0" and trim(intCodGrupo) <> "" and trim(intCodEmpresa) <> "" then
	
		sql = "SELECT Codigo, upper(razaosocial ) as empresa"
		sql = sql & " FROM seg_empresa"
		sql = sql & " where Codigo = " & intCodEmpresa
		sql = sql & " and Cod_Grupo = " & intCodGrupo
		rs.open sql, cnn
		if rs.eof = false then
			strEmpresa = rs("empresa")
			rs.close
		else
			rs.close
			%>
			<script>
				alert("Parametros informados são inválidos!")
			</script>
			<%
			response.End()
		end if 
	end if
	
	if intCodGrupo = "0" or intCodEmpresa = "0" or intCodGrupo = "" or intCodEmpresa = "" then
		%>
		<script>
			alert("Parametros informados são inválidos!")
		</script>
		<%
		response.End()
	end if

	meuIP = replace(Request.ServerVariables("REMOTE_ADDR"),".","")
	strAutorizado = "N"
	sql = "SELECT id "
	sql = sql & " FROM APO_faixa_IP"
	sql = sql & " where cod_empresa = " & intCodEmpresa
	sql = sql & " and replace(numero_ip,'.','')='" & meuIP & "'"
	rs.open sql, cnn
	if rs.eof = false then
		strAutorizado			= "S"
	end if 
	rs.close
	
	if strAutorizado = "N" then
		%>
		<script>
			alert("Acesso não autorizado!!")
		</script>
		<%
		response.End()
	end if
	
%>
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">SRH - Recurso Humano</h1>
            <ul class="pull-right breadcrumb">
                <H3>
                <li class="active"><strong><%=intCodEmpresa%> - <%=strEmpresa%></strong></li>
                </H3>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
		strClassBotaoIncluir = "btn-u btn-u-default"
		strClassBotaoLimpar  = "btn-u btn-u-default"
		strBotaoAcaoIncluir = ""
    
        intMatricula = Trim(Request.Form("txtMatricula"))
            
        if trim(intMatricula) <> "" then
        
            sql = "SELECT codigo, upper(nome) as colaborador "
            sql = sql & " FROM SRH_COLABORADOR"
            sql = sql & " where codFuncional = " & intMatricula
            rs.open sql, cnn
            if rs.eof = false then
                strNome			= rs("colaborador")
                
				strClassBotaoIncluir = "btn-u btn-u-default"
				strClassBotaoIncluir = "btn-u float-shadow"
				strBotaoAcaoIncluir = "return registrar()"
				strClassBotaoLimpar  = "btn-u btn-u-orange float-shadow"
			end if 
            rs.close
        end if 
		
    %>
     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Dados do Colaborador</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" name="frm" class="margin-bottom-10" method="post" action="ponto.asp">
                	<input name="Grupo"   type="hidden" id="Grupo"   value="<%=intCodGrupo%>">
                	<input name="Unidade" type="hidden" id="Unidade" value="<%=intCodEmpresa%>">
              		<div class="form-group">
                        <label class="form-label"><h3>Horário</h3></label>
                          <input readonly type="text" class="form-control"  name="relogio" size="10"> 
                    </div>
                    <div class="form-group">
                        <label class="form-label"><h3>Matrícula</h3></label>
                          <input name="txtMatricula" type="text" class="form-control" id="txtMatricula" size="15" maxlength="30" value="<%=intMatricula%>"  onkeypress="return formataCampo(this, 2, 15)" onBlur="submit()">
                    </div>
                    <div class="form-group">
                        <label class="form-label"><h3>Nome</h3></label>
                          <input readonly name="txtNome" type="text" class="form-control" id="txtNome" style="width:100%" value="<%=strNome%>">
                    </div>
   
                    <legend></legend>
                    
                     <div class="margin-bottom-30">
						<input type="button" name="cmdIncluir" style="cursor:hand"  value="Salvar"  class="<%=strClassBotaoIncluir%>" 	<%=strDesabilitaIncluir%> onclick="<%=strBotaoAcaoIncluir%>">
						<input type="button" name="cmdlimpar" style="cursor:hand"  value="Limpar"  class="<%=strClassBotaoLimpar%>" 	<%=strDesabilitaLimpar%> onclick="window.location='ponto.asp?Grupo=<%=intCodGrupo%>&Unidade=<%=intCodEmpresa%>'">
					</div>
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
    <!--/container-->		
	<script>
		function moveRelogio(){ 
			var frm = document.getElementById("frm");
			momentoAtual = new Date() 
			hora = momentoAtual.getHours() 
			minuto = momentoAtual.getMinutes() 
			segundo = momentoAtual.getSeconds() 
			
			horaImprimivel = hora + " : " + minuto + " : " + segundo 
			
			frm.relogio.value = horaImprimivel;
			
			setTimeout("moveRelogio()",1000) 
		} 
		
        function registrar(){
            
            var frm = document.getElementById("frm");
            
            if (frm.txtMatricula.value == "") {
                alert("Matrícula deve ser informada!");
                frm.txtMatricula.focus();
                return false;
            }
            
            frm.action="ponto_cod.asp";
            frm.submit();
            return true;
        }
    
    </script>
    <!--=== End Content Part ===-->
</body>
</html> 