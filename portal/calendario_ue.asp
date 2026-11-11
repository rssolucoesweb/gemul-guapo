<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSession.asp"-->
<!--#include file="includes/inc_cnn_gemulEAD.asp"-->
<!--#include file="includes/inc_log_ead.asp"-->
<!DOCTYPE html>
<html lang="pt">
    <head>
        <meta charset="utf-8">
        <title>
            GEMUL - Calendario
        </title>
        <meta name="description" content="SweetAlert2">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no, minimal-ui">
        <!-- Call App Mode on ios devices -->
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <!-- Remove Tap Highlight on Windows Phone IE -->
        <meta name="msapplication-tap-highlight" content="no">
        <!-- base css -->
        <link rel="stylesheet" media="screen, print" href="css/vendors.bundle.css">
        <link rel="stylesheet" media="screen, print" href="css/app.bundle.css">
        <!-- Place favicon.ico in the root directory -->
        <link rel="apple-touch-icon" sizes="180x180" href="img/favicon/apple-touch-icon.png">
        <link rel="icon" type="image/png" sizes="32x32" href="img/favicon/favicon-32x32.png">
        <link rel="mask-icon" href="img/favicon/safari-pinned-tab.svg" color="#5bbad5">
        <link rel="stylesheet" media="screen, print" href="css/	/sweetalert2/sweetalert2.bundle.css">
        <link rel="stylesheet" media="screen, print" href="css/theme-demo.css">
		<link type="text/css" rel="stylesheet" href="../Estilo/Estilo_Impressao.css">
		<link href="css/calendario.css" rel="stylesheet" type="text/css" />
		<link href="css/impressaoCalendario.css?v1" rel="stylesheet" type="text/css" />
		<link id="myskin" rel="stylesheet" media="screen, print" href="css/themes/cust-theme-4.css">
		
		<script type="text/javascript">
			$("div.sis").hide();

			$(document).ready(function () {
				$("div.sis").show();
				$(".bottom").css("margin-bottom", $("#legenda").height());

			});
		</script>
    </head>
    <body class="mod-bg-1 ">
        <!-- DOC: script to save and load page settings -->
        <script>
            /**
             *	This script should be placed right after the body tag for fast execution 
             *	Note: the script is written in pure javascript and does not depend on thirdparty library
             **/
            'use strict';

            var classHolder = document.getElementsByTagName("BODY")[0],
                /** 
                 * Load from localstorage
                 **/
                themeSettings = (localStorage.getItem('themeSettings')) ? JSON.parse(localStorage.getItem('themeSettings')) :
                {},
                themeURL = themeSettings.themeURL || '',
                themeOptions = themeSettings.themeOptions || '';
            /** 
             * Load theme options
             **/
            if (themeSettings.themeOptions)
            {
                classHolder.className = themeSettings.themeOptions;
                console.log("%c✔ Theme settings loaded", "color: #148f32");
            }
            else
            {
                console.log("Heads up! Theme settings is empty or does not exist, loading default settings...");
            }
            if (themeSettings.themeURL && !document.getElementById('mytheme'))
            {
                var cssfile = document.createElement('link');
                cssfile.id = 'mytheme';
                cssfile.rel = 'stylesheet';
                cssfile.href = themeURL;
                document.getElementsByTagName('head')[0].appendChild(cssfile);
            }
            /** 
             * Save to localstorage 
             **/
            var saveSettings = function()
            {
                themeSettings.themeOptions = String(classHolder.className).split(/[^\w-]+/).filter(function(item)
                {
                    return /^(nav|header|mod|display)-/i.test(item);
                }).join(' ');
                if (document.getElementById('mytheme'))
                {
                    themeSettings.themeURL = document.getElementById('mytheme').getAttribute("href");
                };
                localStorage.setItem('themeSettings', JSON.stringify(themeSettings));
            }
            /** 
             * Reset settings
             **/
            var resetSettings = function()
            {
                localStorage.setItem("themeSettings", "");
            }

        </script>
        <!-- BEGIN Page Wrapper -->
        <div class="page-wrapper">
            <div class="page-inner">
                <%item_ativo_calendario 		= " class='active' "%>
				<!--#include file="inc_menu.asp"-->
				
                <div class="page-content-wrapper">
                    
					
					
					<!--#include file="inc_cabecalho_pagina.asp"-->
					<%
					sql = "SELECT cod_calendario_ue,ano_letivo,nome_calendario "
					sql = sql & " FROM SCA_CALENDARIO_ue"
					sql = sql & " Where cod_empresa = " & Session("CodEmpresaAluno_GemulEad")
					sql = sql & " and situacao = 'A' order by ano_letivo desc"
					rs.open sql, cnn
					if rs.eof = false then
						strAno					= rs("ano_letivo")
						strNome		 			= rs("nome_calendario")
						intCodCalendario		= rs("cod_calendario_ue")
						cod_grupo				= 1
					end if 
					rs.close
					GravarLogEaD "Acesso ao " & strNome,0,0,0,0
					%>
                    <!-- BEGIN Page Content -->
                    <!-- the #js-page-content id is needed for some plugins to initialize -->
                    <main id="js-page-content" role="main" class="page-content">
                        <ol class="breadcrumb page-breadcrumb">
                            <li class="breadcrumb-item"><a href="javascript:void(0);">GEMUL - Calendário</a></li>
                            <li class="breadcrumb-item">Painel</li>
                            <li class="breadcrumb-item active">Inicial</li>
                            <li class="position-absolute pos-top pos-right d-none d-sm-block"></li>
                        </ol>
                        <div class="subheader">
                            <h1 class="subheader-title">
                                <i class='subheader-icon fal fa-envelope'></i> Calendário <sup class='badge badge-primary fw-500'><%=strAno%></sup>
                            </h1>
                        </div>
						
                        <div class="row">
                            <div class="col-xl-12">
                                <div id="panel-1" class="panel">
                                    <div class="panel-hdr">
                                        <h2>
                                            <%=strNome%>
                                        </h2>
                                        <div class="panel-toolbar">
                                            <button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
                                            <button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
                                        </div>
                                    </div>
                                    <div class="panel-container show">
                                        <div class="panel-content">
											<div class="table-responsive-lg">								
                                            
												<form method="post" name="frm" id="frm">
											
											
											
											
<%


sub montaCalendario (MesCal, AnoCal)

	PrimeiroDiaMes = DateSerial(AnoCal,MesCal,1)
	UltimoDiaMes   = DateSerial(AnoCal,MesCal+1,1-1)
	Inicio         = ABS(1 - WeekDay(PrimeiroDiaMes))
	Fim            = 7 - WeekDay(UltimoDiaMes)
	Start          = 1 - Inicio
	TheEnd         = Day(UltimoDiaMes) + Fim 
	J=1
				
	%>

             <table class="table table-bordered table-hover m-0">
                    <tr>
                      <td width="20%" align="center" colspan="7">
						<font size="1"><strong><%=ucase(monthname(MesCal))%></strong></font>
					  </td>
                    </tr>
                    <tr>
                      <td align="center"><strong>Dom</strong></td>
                      <td align="center"><strong>Seg</strong></td>
                      <td align="center"><strong>Ter</strong></td>
                      <td align="center"><strong>Qua</strong></td>
                      <td align="center"><strong>Qui</strong></td>
                      <td align="center"><strong>Sex</strong></td>
                      <td align="center"><strong>Sab</strong></td>
                    </tr>
                    <%
                    controle = 0
                    posicao = 0
                    For i= Start to TheEnd
                        cod_calendario_evento = ""
                        Data = DateSerial(AnoCal,MesCal,i)
                        bloqueio = ""
                        sql="select e.cod_calendario_evento, e.cor, d.detalhes "
						sql=sql & " from sca_calendario_dia_ue d "
						sql=sql & " inner join sca_calendario_ue c on c.cod_calendario_ue = d.cod_calendario_ue "
						sql=sql & " inner join sca_calendario_evento e on e.cod_calendario_evento = d.cod_calendario_evento "
						sql=sql & " where c.cod_empresa = " & Session("CodEmpresaAluno_GemulEad")			
                        sql=sql & " and ("
                        sql=sql & " 	dia_mes =" & day(DateSerial(AnoCal,MesCal,i)) 
                        sql=sql & " 	and mes =" & month(DateSerial(AnoCal,MesCal,i))
                        sql=sql & " 	and ano =" & year(DateSerial(AnoCal,MesCal,i))
                        sql=sql & " )"	
                        rs.open sql, cnn
                        if rs.eof = false then
                            corFundo = rs("cor")
                            strDetalhe = rs("detalhes")
                        else
                            corFundo = ""
                            strDetalhe = ""
                        end if
                        rs.close
                        if trim(i) = trim(day(now)) and trim(MesCal)=trim(Month(now)) and trim(AnoCal) = trim(year(now)) Then
                            'Dia Hoje
                            IF corFundo = "" THEN corFundo = "#ffffff"
                            posicao = posicao + 1	
                            Response.Write "<TD align='center' height='15' width='10' bgcolor='" & corFundo & "'  class='celula'><FONT COLOR=BLUE><strong>"& Day(DateSerial(AnoCal,MesCal,i)) & "</strong></font></TD>"

                        Elseif (i<1) or (i > Day(UltimoDiaMes)) Then
                            'mes anterior e posterior
                            if (Weekday(DateSerial(AnoCal,MesCal,i)) = 7 or Weekday(DateSerial(AnoCal,MesCal,i))=1) and corFundo="" then corFundo = "#COCOCO"
                            if corFundo="" then corFundo="#fff"
                            Response.Write "<TD align='center' height='15' width='10'  class='celula'>&nbsp;</TD>"
                        Else
                            if (Weekday(DateSerial(AnoCal,MesCal,i)) = 7 or Weekday(DateSerial(AnoCal,MesCal,i))=1) and corFundo="" then corFundo = "#COCOCO"
                            'Dias do m&ecirc;s
                            posicao = posicao + 1	
                            Response.Write "<TD align='center' height='15' width='10' bgcolor='" & corFundo & "'  class='celula'><FONT COLOR='#000'>"& Day(DateSerial(AnoCal,MesCal,i)) & "</font></TD>"
                            
                        End if
                        
                        If j = 7 then
                             J = 0
                             Response.Write "</tr><TR>"
                        end if
                        J = j + 1	
                    NEXT%>
           </tr>
      </table>
<%end sub%>


	<% 
	
	mes = strMes
	ano = strAno	 
			 
	Session.LCID = 1046 'BRASIL
	Dim URL,Dia, Mes, Ano, PrimeiroDiaMes, UltimoDiaMes 
	Dim Inicio,Fim, Start, TheEnd,i, j
	
	URL= Request.ServerVAriables("SCRIPT_NAME")

	dia = day(now)
	
	%>
	
<table class="table table-bordered table-hover m-0">
	<%
	controleCal = 0
	for cal = 1 to 4
		controleCal = controleCal + 1
		MesCalendario  = controleCal
		MesCalendario1 = controleCal+1
		MesCalendario2 = controleCal+2
		controleCal = MesCalendario2
		%>
          <tr>
            <td height="130" valign="top">
    			<%
                montaCalendario MesCalendario, strAno
    			%>
          	</td>
    	     <td height="130" valign="top">
    			<%
                montaCalendario MesCalendario1, strAno
    			%>
          	</td>
	      	<td height="130" valign="top">
    			<%
                montaCalendario MesCalendario2, strAno
    			%>
          	</td>
  		</tr>
   
         
<%next%>

</table>

<br />

<table class="table table-bordered table-hover m-0">
  <tr>
    <td width="33%" height="130" valign="top">
    
    	<%
		
		SQL = "select cor, nome, letivo from SCA_CALENDARIO_EVENTO"
		SQL = SQL & " where cod_grupo ="& cod_grupo
		SQL = SQL & " order by 1"
		rs.open sql, cnn
		if not rs.eof then
			%>
			<table width="80%" border="0" cellspacing="0" cellpadding="0" class="tabela">
			  <tr>
				<td align="center" colspan="2"><font size="1"><strong>LEGENDA</strong></font></td>
				<td align="center"><strong>Letivo</strong></td>
			  </tr>
              <%
			  while not rs.eof
				letivo = " "
				if rs("letivo") = "S" then letivo = "Sim"
				if rs("letivo") = "N" then letivo = "Não"
				%>
				<tr>
                    <td  height="15" bgcolor="<%=rs("cor")%>" width="20">&nbsp;</td>
                    <td>&nbsp;&nbsp;<%=rs("nome")%></td>
					<td>&nbsp;&nbsp;<%=letivo%></td>
                </tr>
				<%
			   	rs.movenext
			  wend
			  %>
			</table>
			<%
		end if
		rs.close
		%>
    
    </td>
    <td width="33%" valign="top">
    
<%
		SQL = "SELECT MES, DIA_MES, DETALHES  "
		SQL = SQL & " FROM SCA_CALENDARIO_DIA_ue d"
		SQL = SQL & " inner join sca_calendario_ue c on c.cod_calendario_ue = d.cod_calendario_ue "
		SQL = SQL & " inner join sca_calendario_evento e on e.cod_calendario_evento = d.cod_calendario_evento "
		SQL = SQL & " where c.cod_empresa = " & Session("CodEmpresaAluno_GemulEad")			
		SQL = SQL & " and e.cod_calendario_evento=1"'FERIADO
		SQL = SQL & " and d.ano = " & strAno 
		SQL = SQL & " ORDER BY ANO, MES, dia_mes"
		rs.open sql, cnn
		if not rs.eof then
			%>
			<table class="table table-bordered table-hover m-0">
			  <tr>
				<td colspan="3" align="center"><font size="1"><strong>FERIADOS</strong></font></td>
			  </tr>
              <%
			  flag_mes = ""
			  while not rs.eof
			  	if flag_mes <> left(ucase(monthname(RS("MES"))),3) then
					nome_mes = left(ucase(monthname(RS("MES"))),3)
					'cor = "style='background-color:#CCC'"
				else
					nome_mes = ""
					'cor = "style='background-color:#FFF'"
				end if
				if cor = "" then
					if nome_mes <> "" then cor = "style='background-color:#CCC'"
				else
					if nome_mes <> "" then cor = ""
				end if
				%>
				<tr <%=cor%>>
					<td width="20%" height="15" align="center"><%=left(ucase(monthname(RS("MES"))),3)%></td>
           	    <td align="center"  width="5%"><%=RS("DIA_MES")%></td>
                    <td align="center" width="75%"><%=RS("DETALHES")%></td>
                </tr>
				<%
			   	rs.movenext
			  wend
			  %>
			</table>
			<%
		end if
		rs.close
		%>
        
    </td>
    <td width="33%" valign="top">
    
    <%

		SQL = "SELECT MES, COUNT(*) AS QTDE "
		SQL = SQL & " from sca_calendario_dia_ue d "
		SQL = SQL & " inner join sca_calendario_ue c on c.cod_calendario_ue = d.cod_calendario_ue "
		SQL = SQL & " inner join sca_calendario_evento e on e.cod_calendario_evento = d.cod_calendario_evento "
		SQL = SQL & " where c.cod_empresa = " & Session("CodEmpresaAluno_GemulEad")	
		SQL = SQL & " and d.ano = " & strAno & " and e.letivo = 'S'"'DIA LETIVO
		SQL = SQL & " GROUP BY d.MES"
		SQL = SQL & " order by 1"
		rs.open sql, cnn
		if not rs.eof then
			%>
			<table class="table table-bordered table-hover m-0">
			  <tr>
				<td colspan="2"  align="center"><font size="1"><strong>DIAS LETIVOS</strong></font></td>
			  </tr>
              <%
			  	total=0
				totalGeral=0
			  while not rs.eof
			  	IF CINT(rs("MES")) = 8 THEN
				%>
				<tr bgcolor="#CCCCCC">
                    <td height="15" align="center"><strong>1º Semestre</strong></td>
                    <td align="center"><strong><%=total%></strong></td>
                </tr>
				<%
					total=0
				END IF
				%>
				<tr>
                    <td align="center"><%=ucase(monthname(RS("MES")))%></td>
                    <td align="center"><%=rs("QTDE")%></td>
                </tr>
				<%
				total = total + rs("QTDE")
				totalGeral = totalGeral + rs("QTDE")
			   	rs.movenext
			  wend
			  
			  %>
				<tr bgcolor="#CCCCCC">
                    <td align="center"><strong>2º Semestre</strong></td>
                    <td align="center"><strong><%=total%></strong></td>
                </tr>
				<tr bgcolor="#CCCCCC">
                    <td align="center"><strong>Total</strong></td>
                    <td align="center"><strong><%=totalGeral%></strong></td>
                </tr>
                              
			</table>
			<%
		end if
		rs.close
		%>
    </td>
  </tr>
</table>											
											
											
											
											
											
											
												</form>
											</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
						</div>
                    </main>
                    <!-- this overlay is activated only when mobile menu is triggered -->
                    <div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-no"></div> <!-- END Page Content -->
                    
					<!--#include file="inc_rodape.asp"-->
					
					<!--#include file="inc_acesso_top.asp"-->
					
                </div>
            </div>
        </div>
        <!-- END Page Wrapper -->
		
		<!--#include file="inc_menu_impressao.asp"-->
		
        
        <!-- base vendor bundle: 
			 DOC: if you remove pace.js from core please note on Internet Explorer some CSS animations may execute before a page is fully loaded, resulting 'jump' animations 
						+ pace.js (recommended)
						+ jquery.js (core)
						+ jquery-ui-cust.js (core)
						+ popper.js (core)
						+ bootstrap.js (core)
						+ slimscroll.js (extension)
						+ app.navigation.js (core)
						+ ba-throttle-debounce.js (core)
						+ waves.js (extension)
						+ smartpanels.js (extension)
						+ src/../jquery-snippets.js (core) -->
        <script src="js/vendors.bundle.js"></script>
        <script src="js/app.bundle.js"></script>
		<script src="js/mensagem.js"></script>
        <!-- Include a polyfill for ES6 Promises (optional) for IE11, UC Browser and Android browser support -->
        <script>
            $(document).ready(function()
            {

              

            });

        </script>
    </body>
</html>
