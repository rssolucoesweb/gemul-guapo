<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">APO - Controle Ponto</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
	strFuncao = ""
	strExecutarSubmitTurno = "S"

	intCodigo	 								= Trim(Request.Form("txtCodigo"))
	intCodFuncao								= Trim(Request("cmbFuncao"))
	strNomeFuncao								= Trim(Request.Form("txtNomeFuncao"))
	intCodTurno									= Trim(Request.Form("cmbTurno"))
	intPontoHorarioEntradaManha					= Trim(Request.Form("cmbPontoHorarioEntradaManha"))
	intPontoHorarioSaidaManha					= Trim(Request.Form("cmbPontoHorarioSaidaManha"))
	intPontoHorarioEntradaTarde					= Trim(Request.Form("cmbPontoHorarioEntradaTarde"))
	intPontoHorarioSaidaTarde					= Trim(Request.Form("cmbPontoHorarioSaidaTarde"))
	intPontoHorarioEntradaIntegralMatutino		= Trim(Request.Form("cmbPontoHorarioEntradaIntegralMatutino"))
	intPontoHorarioSaidaIntegralMatutino		= Trim(Request.Form("cmbPontoHorarioSaidaIntegralMatutino"))
	intPontoHorarioEntradaIntegralTarde			= Trim(Request.Form("cmbPontoHorarioEntradaIntegralTarde"))
	intPontoHorarioSaidaIntegralTarde			= Trim(Request.Form("cmbPontoHorarioSaidaIntegralTarde"))

	strSomenteFuncionario = "S"
	strPagina="PontoHorario_Funcao_cad.asp"
	if intCodFuncao = "" then intCodFuncao = "0"
	if intCodPontoHorario = "" then intCodPontoHorario = "0"
		
	if trim(intCodFuncao) <> "0" then
		sql = " Select Codigo, Cod_Funcao, Cod_PontoHorario, Cod_DiaSemana "
		sql = sql & " FROM APO_PONTOHORARIO_FUNCAO PHC "
		sql = sql & " where Cod_Funcao  = " & intCodFuncao 
		rs.open sql, cnn
		if rs.eof = false then
			intCodFuncao				= rs("Cod_Funcao")
			
			strDesabilitaIncluir		= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 		= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir		= "" 'Desabilita o botão Excluir
		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if
	
	if intCodTurno <> "" then
		str_SiglaTurno = ""
		sql = "SELECT SUBSTRING(DESC_TURNO,1,1) AS SIGLA_TURNO "
		sql = sql & " FROM SRH_TURNO"
		SQL = SQL & " WHERE COD_TURNO = " & intCodTurno
		rs.open sql, cnn
		if rs.eof = false then
			str_SiglaTurno				= rs("SIGLA_TURNO")
		end if 
		rs.close
	end if
	
	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "" 'Desabilita o botão Excluir

	%>    
<!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Tabela de Horários - Função</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post" action="PontoHorario_Funcao_cad.asp">
                <!--#include file="../includes/inc_ListaHistoricoHorarioFuncao.asp" -->
                <input name="txtPontoHorarioAnterior" type="hidden" id="txtPontoHorarioAnterior" value="<%=intCodPontoHorario%>" >
                        <div class="form-group">
                            <label class="form-label">Função</label>
                            <% strSubmitFuncao = "onchange='submit()'"%>
                             <!--#include file="../includes/inc_cmbFuncao.asp" --> 
                        </div>
                        <div class="form-group">
                            <label class="form-label">Turno</label>
                             <!--#include file="../includes/inc_cmbTurnoRH.asp" -->
                        </div>
						<% if str_SiglaTurno = "M" then %>
                            <div class="form-group">
                                <label class="form-label">Entrada Manh&atilde;</label>
                                 <!--#include file="../includes/inc_cmdPonto_HorarioEntradaManha.asp" -->
                                <label class="form-label">Sa&iacute;da Manh&atilde;</label>
                                  <!--#include file="../includes/inc_cmdPonto_HorarioSaidaManha.asp" -->
                            </div>
                        <% end if %>
						<% if str_SiglaTurno = "V" then %>
                            <div class="form-group">
                                 <label class="form-label">Entrada Tarde</label>
                                 <!--#include file="../includes/inc_cmdPonto_HorarioEntradaTarde.asp" -->
                                <label class="form-label">Sa&iacute;da Tarde</label>
                                  <!--#include file="../includes/inc_cmdPonto_HorarioSaidaTarde.asp" -->
                           </div>
                        <% end if %>
						<% if str_SiglaTurno = "I" then %>
                            <div class="form-group">
                                <label class="form-label">Entrada Manh&atilde;</label>
                                 <!--#include file="../includes/inc_cmdPonto_HorarioEntradaIntegralMatutino.asp" -->
                                <label class="form-label">Sa&iacute;da Manh&atilde;</label>
                                  <!--#include file="../includes/inc_cmdPonto_HorarioSaidaIntegralMatutino.asp" -->
                            </div>
                             <div class="form-group">
                                 <label class="form-label">Entrada Tarde</label>
                                 <!--#include file="../includes/inc_cmdPonto_HorarioEntradaIntegralTarde.asp" -->
                                <label class="form-label">Sa&iacute;da Tarde</label>
                                  <!--#include file="../includes/inc_cmdPonto_HorarioSaidaIntegralTarde.asp" -->
                           </div>
                       <% end if %>
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
                <h3 class="panel-title"><i class="fa fa-globe"></i>Lista de Horários - Função</h3>
          </div>
      <div class="panel-body">
            	<div class="table-responsive">
                <%
				if intCodFuncao = "" then intCodFuncao = "0"
				if intCodFuncao = "0" then
				%>
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="60%" bgcolor="#95A5A6">Função</th>
                          <th width="40%" bgcolor="#95A5A6">Faixa de Hor&aacute;rio</th>
                          <th width="40%" bgcolor="#95A5A6">Situa&ccedil;&atilde;o</th>
                          <th width="5%" bgcolor="#95A5A6" align="center"><div align="center">Editar</div></th>
                      </tr>
                    </thead>
                    <%
					sql = " SELECT distinct PHF.Cod_Funcao, PH.Situacao, FC.desc_funcao "
					sql = sql & " FROM APO_PONTOHORARIO_FUNCAO PHF "
					sql = sql & " INNER JOIN APO_PONTOHORARIO PH ON PH.CODIGO = PHF.Cod_PontoHorario "
					sql = sql & " INNER JOIN SRH_TURNO TU ON TU.COD_TURNO = PH.COD_TURNO "
					sql = sql & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = PHF.Cod_Funcao "
					sql = sql & " WHERE PH.Cod_grupo = " & Session("CodGrupo")	
					sql = sql & " ORDER BY FC.desc_funcao"	
					rs.open sql, cnn
					if rs.eof = false then
					while not rs.eof
						cont = cont + 1	
						
						strSituacao = trim(rs("Situacao"))
						
						if trim(rs("Situacao")) = "A" then
							strSituacao = "Ativo"
						else
							strSituacao = "Inativo"
						end if
						if cor = "" then
							cor = " bgcolor='#D7FFEB'"
						else
							cor = ""
						end if
						
						strFaixas = ""
						sql = " SELECT distinct PHF.Cod_Funcao, "
						sql = sql & " PH.Codigo as CodPontoHorario, PH.Tipo, PH.Hora, PH.Minuto, PH.Segundo, PH.Situacao, PH.COD_TURNO, TU.Desc_Turno, FC.Desc_Funcao "
						sql = sql & " FROM APO_PONTOHORARIO_FUNCAO PHF "
						sql = sql & " INNER JOIN APO_PONTOHORARIO PH ON PH.CODIGO = PHF.Cod_PontoHorario "
						sql = sql & " INNER JOIN SRH_TURNO TU ON TU.COD_TURNO = PH.COD_TURNO "
						sql = sql & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = PHF.Cod_Funcao "
						sql = sql & " WHERE PH.Cod_grupo = " & Session("CodGrupo")	
						sql = sql & " and FC.Cod_Funcao  = " & trim(rs("Cod_Funcao"))
						sql = sql & " ORDER BY FC.desc_funcao, TU.Desc_Turno, PH.Hora, PH.Minuto, PH.Tipo "	
						rsaux.open sql, cnn
						if rsaux.eof = false then
							while not rsaux.eof
							
							if trim(rsaux("tipo")) = "E" then
								strNomeTipo = "Entrada"
							else
								strNomeTipo = "Saída"
							end if

								strFaixas = strFaixas & "<br>" & zeroleft(trim(rsaux("Hora")),2) & ":" & zeroleft(trim(rsaux("Minuto")),2) & " - " & trim(strNomeTipo)  & " " & trim(rsaux("Desc_Turno"))
								rsaux.movenext
							wend
						end if
						rsaux.close
						%>
						<tbody>
							<tr <%=cor%>>
								<td><%=trim(rs("Desc_Funcao"))%></td>
								<td><%=trim(strFaixas)%></td>
								<td><%=trim(strSituacao)%></td>
							  <td align="center" >
								<button class="btn-u btn-u-sea" onclick="carregaRegistroFuncao('<%=trim(rs("Cod_Funcao"))%>')" type="button"><i class="fa fa-file-text-o"></i></button>								</td> 
							</tr>
						</tbody>
						<%				
						rs.movenext
						wend
					end if
					rs.close
                %>
                </table>
                <%else
				%>
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="60%" bgcolor="#95A5A6">Função</th>
                          <th width="20%" bgcolor="#95A5A6">Dia Semana</th>
                          <th width="20%" bgcolor="#95A5A6">Horas</th>
                          <th width="20%" bgcolor="#95A5A6">Minuto</th>
                          <th width="40%" bgcolor="#95A5A6">Tipo</th>
                          <th width="40%" bgcolor="#95A5A6">Turno</th>
                          <th width="40%" bgcolor="#95A5A6">Situa&ccedil;&atilde;o</th>
                    </thead>
                    <%
					
					sql = " SELECT distinct PHF.Cod_Funcao, "
					sql = sql & " PH.Codigo as CodPontoHorario, PH.Tipo, PH.Hora, PH.Minuto, PH.Segundo, PH.Situacao, PH.COD_TURNO, TU.Desc_Turno, FC.Desc_Funcao "
					sql = sql & " FROM APO_PONTOHORARIO_FUNCAO PHF "
					sql = sql & " INNER JOIN APO_PONTOHORARIO PH ON PH.CODIGO = PHF.Cod_PontoHorario "
					sql = sql & " INNER JOIN SRH_TURNO TU ON TU.COD_TURNO = PH.COD_TURNO "
					sql = sql & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = PHF.Cod_Funcao "
					sql = sql & " WHERE PH.Cod_grupo = " & Session("CodGrupo")	
					if intCodFuncao <> "0" then
						sql = sql & " and FC.Cod_Funcao  = " & intCodFuncao
					end if
					sql = sql & " ORDER BY FC.desc_funcao, TU.Desc_Turno, PH.Hora, PH.Minuto, PH.Tipo "	
					rs.open sql, cnn
					if rs.eof = false then
					while not rs.eof
						cont = cont + 1	
						
						strSituacao = trim(rs("Situacao"))
						
						if trim(rs("Situacao")) = "A" then
							strSituacao = "Ativo"
						else
							strSituacao = "Inativo"
						end if
						if trim(rs("tipo")) = "E" then
							strNomeTipo = "Entrada"
						else
							strNomeTipo = "Saída"
						end if
						if rs("cod_turno") = "1" then cor = "#9FFFCF"
						if rs("cod_turno") = "2" then cor = "#FFFFC1"
						if rs("cod_turno") = "3" then cor = "#FFD5BF"
						if rs("cod_turno") = "4" then cor = "#9BCFF7"
						
						%>
						<tbody>
							<tr style="background-color:<%=cor%>">
								<td><%=trim(rs("Desc_Funcao"))%></td>
								<td>Seg a Sab</td>
								<td><%=trim(rs("Hora"))%></td>
								<td><%=trim(rs("Minuto"))%></td>
							  <td><%=trim(strNomeTipo)%></td>
								<td><%=trim(rs("Desc_Turno"))%></td>
								<td><%=trim(strSituacao)%></td>
							</tr>
						</tbody>
						<%				
						rs.movenext
						wend
					end if
					rs.close
                %>
                </table>
                <%end if%>                
</div>
            </div>                      
        </div>
        <!--End Table Bordered-->	
        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
	<script>
        

        function carregaRegistroFuncao(codFuncao){
            
            var frm = document.getElementById("frm");
            frm.cmbFuncao.value=codFuncao;
            frm.submit();
        }
        
        function salvar(acao){
            
            var frm = document.getElementById("frm");
            
            if (frm.cmbFuncao.value == "") {
                alert("A Função deve ser informado !");
                frm.cmbFuncao.focus();
                return false;
            }

            if (frm.cmbTurno.value == "0") {
                alert("O Turno deve ser informado !");
                frm.cmbTurno.focus();
                return false;
            }

            frm.action="PontoHorario_Funcao_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 