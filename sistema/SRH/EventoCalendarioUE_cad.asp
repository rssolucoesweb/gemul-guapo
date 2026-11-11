<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../menuModulos.asp"-->
<style>
	input[type=text]{     
		border-radius:4px;
		background: #fff; 
		border:1px solid #cococo;
		width:120px;
		height:20px
	}
</style>
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">SCA - Controle Acadêmico</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
    <%
	strMostraBotaoCalendarioEvento = "N"
	strMostraBotaoCalendarioRel = "S"
	strDesabilitaBotaoCalendarioEvento = "disabled"
    strExecutarSubmitMes 		= "S"
	strExecutarSubmitEvento		= "S"
    strPaginaTitulo 			= "EventoCalendarioUE_cad.asp"
	
    intCodCalendario = Trim(Request("txtCodigo"))
	if intCodCalendario = "" then  intCodCalendario = Trim(Request("txtCodigoRetorno"))
	
    strAno	 					= Trim(Request("txtAno"))
	intCodEvento 				= Trim(Request("cmbEvento"))
	if intCodEvento = "" then  intCodEvento = Trim(Request("cmbEventoRetorno"))
	strMes				 		= Trim(Request("cmbMes"))
	if strMes = "" then  strMes = Trim(Request("cmbMesRetorno"))	
	
    if trim(intCodCalendario) <> "" then
    
        sql = "SELECT *"
        sql = sql & " FROM SCA_CALENDARIO_ue"
        sql = sql & " Where cod_calendario_ue = " & intCodCalendario
        rs.open sql, cnn
        
        if rs.eof = false then
            strAno					= rs("ano_letivo")
            strNome		 			= rs("nome_calendario")
            
            strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
            strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
            strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
            BotaoSeguimento		 	= "" 'Desabilita o botão Excluir
			strDesabilitaBotaoCalendarioEvento = ""
            
        end if 
        rs.close
    else
        strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
        strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
        strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
        BotaoSeguimento		 	= "disabled" 'Desabilita o botão Excluir
    end if 
    
	mes = strMes
	ano = strAno
	 strDesabilitaIncluir	= "disabled"
    %>
     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>ESCOLA | Eventos do Calendário Escolar -<strong> <%=strNome%></strong></h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodCalendario%>" maxlength="10">
                    <input name="txtAno" type="hidden" id="txtAno" class="text" size="10" value="<%=strAno%>" maxlength="10">
                    <div class="form-group">
                        <label class="form-label">Evento</label>
                         <!--#include file="../includes/inc_cmbEvento.asp"-->
                    </div>
                   
                    <div class="form-group">
                        <label class="form-label">Mês</label>
                        <!--#include file="../includes/inc_cmbMes.asp"-->
                    </div>
                                        				
					<div class="form-group">
                        <label class="form-label" >Dias</label>
                         
                      <% 
						 
						 if strMes<>"" and strMes<>"0" then
						 
						 
						Session.LCID = 1046 'BRASIL
						Dim URL,Dia, Mes, Ano, Agora, PrimeiroDiaMes, UltimoDiaMes 
						Dim Inicio,Fim, Start, TheEnd,i, j
						
						URL= Request.ServerVAriables("SCRIPT_NAME")

						dia = day(now)
						
						Agora = DateSerial(Ano, mes, dia)
						
						PrimeiroDiaMes = DateSerial(strAno,Mes,1)
						UltimoDiaMes   = DateSerial(strAno,Mes+1,1-1)
						Inicio         = ABS(1 - WeekDay(PrimeiroDiaMes))
						Fim            = 7 - WeekDay(UltimoDiaMes)
						Start          = 1 - Inicio
						TheEnd         = Day(UltimoDiaMes) + Fim 
						J=1
						 
						 
						 
						 %>
                         <table width="80%" border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td align="center" class="text-danger"><strong>Importante: </strong>Com um duplo clique no dia do calendário, você poderá alterar o evento já definido anteriormente. </td>
                          </tr>
                        </table>

                         <table width="80%" border="1" cellpadding="0" cellspacing="0" bordercolor="#999999">
                            <tr>
                              <td>
                              
                              <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#BDE1D9">
                                <tr>
                                  <td width="20%" class="TextoForm">                                  </td>
                                  <td class="TextoForm" width="60%"><div align="center"><font color="#666666"><strong><%=ucase(monthname(mes)) & " de " & ano%></strong></font></div></td>
                                  <td class="TextoForm" width="20%">     </td>
                                </tr>
                                </table></td>
                           </tr>
                            <tr>
                              <td><table width="100%" border="1" cellpadding="2" cellspacing="0" bordercolor="#FFFFFF">
                                <tr>
                                  <td align="center" class="TextoForm"><font color="#8C8C8C"><strong>DOM</strong></font></td>
                                  <td align="center" class="TextoForm"><font color="#0066CC"><strong>SEG</strong></font></td>
                                  <td align="center" class="TextoForm"><font color="#0066CC"><strong>TER</strong></font></td>
                                  <td align="center" class="TextoForm"><font color="#0066CC"><strong>QUA</strong></font></td>
                                  <td align="center" class="TextoForm"><font color="#0066CC"><strong>QUI</strong></font></td>
                                  <td align="center" class="TextoForm"><font color="#0066CC"><strong>SEX</strong></font></td>
                                  <td align="center" class="TextoForm"><font color="#8C8C8C"><strong>SAB</strong></font></td>
                                </tr>
                                <%
								controle = 0
								posicao = 0
								For i= Start to TheEnd
									cod_calendario_evento = ""
									Data = DateSerial(ano,Mes,i)
									bloqueio = ""
									sql="select e.cod_calendario_evento, e.cor, d.detalhes "
									sql=sql & " from sca_calendario_dia_ue d "
									sql=sql & " inner join sca_calendario_ue c on c.cod_calendario_ue = d.cod_calendario_ue "
									sql=sql & " inner join sca_calendario_evento e on e.cod_calendario_evento = d.cod_calendario_evento "
									sql=sql & " where c.cod_empresa = " & session("CodEmpresa")
									sql=sql & " and ("
									sql=sql & " 	dia_mes =" & day(DateSerial(ano,Mes,i)) 
									sql=sql & " 	and mes =" & month(DateSerial(ano,Mes,i))
									sql=sql & " 	and ano =" & year(DateSerial(ano,Mes,i))
									sql=sql & " )"	
									rs.open sql, cnn
									if rs.eof = false then
										corFundo = rs("cor")
										strDetalhe = rs("detalhes")
										if trim(intCodEvento) = trim(rs("cod_calendario_evento")) then
											bloqueio = ""
										else
											bloqueio = "disabled"
											cod_calendario_evento = trim(rs("cod_calendario_evento"))
										end if
										strDiaMarcado = "checked"
									else
										corFundo = ""
										strDiaMarcado = ""
										strDetalhe = ""
									end if
									rs.close
									if trim(i) = trim(day(now)) and trim(Mes)=trim(Month(now)) and trim(Ano) = trim(year(now)) Then
										'Dia Hoje
										IF corFundo = "" THEN corFundo = "#ffffff"
										posicao = posicao + 1	
										Response.Write "<TD align='center' height='60' width='10%' bgcolor='" & corFundo & "' onDblClick='habilitaDia(""chkEventoDia"&posicao & """,""txtDetalhe_"&posicao & ""","""& Day(DateSerial(ano,Mes,i)) & ""","""& cod_calendario_evento & """)'><FONT COLOR=BLUE><strong>"& Day(DateSerial(ano,Mes,i)) & "</strong></font><br><input " & bloqueio & " type='checkbox' name='chkEventoDia' id='chkEventoDia"&posicao&"' " & strDiaMarcado & " value='"&Day(DateSerial(ano,Mes,i))&"' /><br><input " & bloqueio & " name='txtDetalhe_" & Day(DateSerial(ano,Mes,i)) & "' type='text' id='txtDetalhe_" & Day(DateSerial(ano,Mes,i)) & "' class='text' size='10' value='" & strDetalhe & "' maxlength='150'></TD>"

									Elseif (i<1) or (i > Day(UltimoDiaMes)) Then
										'mes anterior e posterior
										if (Weekday(DateSerial(ano,Mes,i)) = 7 or Weekday(DateSerial(ano,Mes,i))=1) and corFundo="" then corFundo = "#COCOCO"
										if corFundo="" then corFundo="#fff"
										Response.Write "<TD align='center' height='60' width='10%' bgcolor='" & corFundo & "'><FONT COLOR='#8C8C8C'><strong>"& Day(DateSerial(ano,Mes,i)) & "</strong></font><br></TD>"
									Else
										if (Weekday(DateSerial(ano,Mes,i)) = 7 or Weekday(DateSerial(ano,Mes,i))=1) and corFundo="" then corFundo = "#COCOCO"
										'Dias do m&ecirc;s
										posicao = posicao + 1	
										Response.Write "<TD align='center' height='60' width='10%' bgcolor='" & corFundo & "' onDblClick='habilitaDia(""chkEventoDia"&posicao & """,""txtDetalhe_"&posicao & ""","""& Day(DateSerial(ano,Mes,i)) & ""","""& cod_calendario_evento & """)'><FONT COLOR='#000'>"& Day(DateSerial(ano,Mes,i)) & "</font><br><input " & bloqueio & " type='checkbox' name='chkEventoDia' id='chkEventoDia"&posicao&"' " & strDiaMarcado & " value='"&Day(DateSerial(ano,Mes,i))&"' /><br><input " & bloqueio & " name='txtDetalhe_" & Day(DateSerial(ano,Mes,i)) & "' type='text' id='txtDetalhe_" & Day(DateSerial(ano,Mes,i)) & "' class='text' size='10' value='" & strDetalhe & "' maxlength='150'></TD>"
										
									End if
									
									If j = 7 then
										 J = 0
										 Response.Write "</tr><TR>"
									end if
									J = j + 1	
								NEXT%>
                                </table></td>
                           </tr>
                      </table>
                         
                         
                          <%end if%>
                         
                         
                         
                         
                         
                         
                </div>
                <%
				strPaginaVoltar = "CalendarioUE_cad.asp"
				strMostraBotaoVoltar = "S"
				strMostraBotaoCadastroPrincipal = "N"
				%>
                    <input type="hidden" name="txtEventoEditado" size="30">
                    <input type="hidden" name="txtCodEventoEditado" size="30">
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
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Legenda dos Eventos</h3>
                    </div>
                    <div class="panel-body">
                    	<div class="table-responsive">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="50%" bgcolor="#95A5A6">Evento</th>
                                    <th width="10%" bgcolor="#95A5A6">Cor</th>
                              </tr>
                            </thead>
                            <%
							cont = 0
		
							sql = "SELECT *"
							sql = sql & " FROM sca_Calendario_evento"
							sql = sql & " where cod_grupo = " & Session("Codgrupo")			
							sql = sql & " ORDER BY nome "
							rs.open sql, cnn
							if rs.eof = false then
							
							while not rs.eof
								
							%>
                            <tbody>
                                <tr>
                                    <td><%=trim(rs("nome"))%></td>
                                    <td bgcolor="<%=rs("cor")%>"></td>
                                    </td> 
                                </tr>
                            </tbody>
                            <%				
								rs.movenext
								wend
							end if
							rs.close
						%>
                        </table>
                        </div>
                    </div>                      
                </div>
                <!--End Table Bordered-->	
       <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
    <!--=== End Content Part ===-->
	<script>
        function habilitaDia(campo,campodetalhe,dia,cod_evento_atual){
           document.getElementById(campo).disabled=false;
		   document.getElementById(campodetalhe).disabled=false;
		   var frm = document.getElementById("frm");
		   if (frm.txtEventoEditado.value==""){
			   frm.txtEventoEditado.value = dia
			   frm.txtCodEventoEditado.value = cod_evento_atual
		   }
		   else
		   {
		        frm.txtEventoEditado.value = frm.txtEventoEditado.value + "," + dia
				frm.txtCodEventoEditado.value = frm.txtCodEventoEditado.value + "," + cod_evento_atual
		   }
        }
		function visualizarCalendario(intCodigo){
            
            var frm = document.getElementById("frm");
            frm.action="EventoCalendarioUE_cad.asp"
            frm.submit();
        }
		function emitirCalendario(){
            
            var frm = document.getElementById("frm");
            frm.action="EventoCalendarioUE_rel.asp?txtCodigo="+frm.txtCodigo.value;
            frm.submit();
        }
		
		
        function salvar(acao){
                
			var frm = document.getElementById("frm");
			if (frm.cmbEvento.value == "0") {
				alert("O evento deve ser informado!");
				frm.cmbEvento.focus();
				return false;
			}
			
			if (frm.cmbMes.value == "0") {
				alert("o mês deve ser informado!");
				frm.cmbSituacao.focus();
				return false;
			}			
			frm.action="EventoCalendarioUE_cod.asp?acao=" + acao;
			frm.submit();
			return true;
            
        }
    </script>
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 