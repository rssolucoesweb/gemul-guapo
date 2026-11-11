<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<style>
.margin-bottom-30 {
    margin-left: 30px;
}
.pointer {cursor: pointer;}
.tamanho7 { font-size: 9px; }
</style>
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

	strPaginaTitulo                  			= "faltas_nao_justificadas_funcionario_cad.asp"
	strPagina						 			= "faltas_nao_justificadas_funcionario_cad.asp"
	strExecutarSubmitModulacaoReferencia        = "S"

	strExecutarSubmitProfessorTurma             = "S"
	strExecutarSubmitTurma	 		            = "S"
	strExecutarSubmitDisciplinaProfessorTurma   = "S"
	strSimouNao_submit                          = "S"
	strExecutarSubmitColaborador				= "S"
	strExecutarSubmitColaboradorFrequencia		= "S"
	strExecutarSubmitTurnoFaltas				= "S"

	tipo_colaborador							= Trim(Request("tipo_colaborador"))
	if tipo_colaborador = "" then tipo_colaborador = "P"
	if tipo_colaborador = "P" then
		response.Redirect("faltas_nao_justificadas_professor_cad.asp")
		response.End()
	end if

	intCodigo           	  					= Trim(Request.Form("txtCodigo"))
	intCodModulacaoReferencia 					= Trim(Request("cmbModulacaoReferencia"))
	intCodJustificativaFaltas					= Trim(Request.form("cmbJustificativaFaltas"))
	strDataLancamento         					= Trim(Request("txtDataLancamento"))
	strDataLancamentoFinal        				= Trim(Request("txtDataLancamentoFinal"))
	intCodColaborador	         	 			= Trim(Request("cmbColaborador")) 
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

	if intCodModulacaoReferencia <> "" and intCodModulacaoReferencia<>"0" then

		sql = "select AnoReferencia, SemestreReferencia from SRH_MODULACAO_REFERENCIA WHERE CODIGO = " & intCodModulacaoReferencia
		rs.open sql, cnn
		if rs.eof = false then
			strAnoLetivoReferencia  = rs("AnoReferencia")
			intSemestreReferencia 	= rs("SemestreReferencia")
		end if
		rs.close
		IF intCodColaborador = "" THEN intCodColaborador = "0"
		sql = " select codFuncao, CodTurno "
		sql = sql & " from SRH_COLABORADOR " 
		sql = sql & " where situacao = 'A' and codigo = " & intCodColaborador 
		rs.open sql, cnn
		if rs.eof = false then
			strCodFuncaoFuncionario 		= rs("codFuncao")
			strCodTurnoFuncionario			= rs("CodTurno")
		end if	
		rs.close
		
		sql = " select TOP 1 COD_TURNO, COD_FUNCAO "
		sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE " 
		sql = sql & " where Status = 'A' and Cod_Colaborador = " & intCodColaborador 
		sql = sql & " ORDER BY ANO_LETIVO "
		rs.open sql, cnn
		if rs.eof = false then
			strCodFuncaoFuncionario 		= rs("COD_FUNCAO")
			strCodTurnoFuncionario			= rs("COD_TURNO")
		end if	
		rs.close
	end if
	bloqueaBotoes = "N"
	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	
	intCodigo 		= Trim(Request.Form("txtCodigo"))
		
	if trim(intCodigo) <> "" then
		sql = "SELECT *"
		sql = sql & " FROM SRH_COLABORADOR_FALTAS"
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
		sql = sql & " and codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			strDataLancamento       = formatadataAP(rs("DataLancamento"))
			strDataLancamentoFinal 	= formatadataAP(rs("DataLancamentoFinal"))
			intCodColaborador			= rs("cod_colaborador")
			intCodTurnoFaltas		= rs("cod_turno_lancamento")
			intCodTurnoTurma		= rs("cod_turno_lancamento")
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir

		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 
	
	if trim(strFechamento) = "S" then
		bloqueaBotoes = "S"
	end if

	intSemestre = intSemestreReferencia
    %>
<!--=== Content Part ===-->
    <div class="container content">
        <div class="row">
            <!-- Begin Content -->
            <div class="col-md-12" >     

       		<!-- Inicia o Painel do Formulario -->   

					<form id="frm" method="post" action="faltas_nao_justificadas_funcionario_cad.asp"  class="sky-form panel-body0">
					<input name="dtf" type="hidden" id="dtf" class="text" size="10" value="<%=request("dtf")%>" >
					<input name="tpl" type="hidden" id="tpl" class="text" size="10" value="<%=request("tpl")%>" >
					<input name="txtCodFuncaoFuncionario" type="hidden" id="txtCodFuncaoFuncionario" class="text" size="10" value="<%=strCodFuncaoFuncionario%>" >
					<input name="txtCodTurnoFuncionario" type="hidden" id="txtCodTurnoFuncionario" class="text" size="10" value="<%=strCodTurnoFuncionario%>" >
					<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
					<input name="txtCodColaboradorJustificativa" type="hidden" id="txtCodColaboradorJustificativa" class="text" size="10" value="<%=CodColaboradorJustificativa%>" maxlength="10">    
					<input name="cmbSemestre" type="hidden" class="text" id="cmbSemestre"  value="<%=intSemestre%>">
					<input name="txtAnoLetivo" type="hidden" class="text" id="txtAnoLetivo"  value="<%=strAnoLetivo%>">
                    <div style="background:#95a5a6;height:40px;padding-top: 8px;" class="panel-title">&nbsp;&nbsp;<font color="#FFFFFF"><i class="fa fa-tasks"></i>&nbsp;Lançamento de faltas não justificadas - Funcionário</font></div>

                    <fieldset>
						<div class="row">
                             <section class="col col-2">
                                <label class="form-label">Tipo colaborador:</label>
                              
                                <label>
                                    <input type="radio" name="tipo_colaborador" id="tipo_colaborador" value="P" onclick="carregaTelaProfessor()"  <%if tipo_colaborador = "P" then response.Write("checked")%> > Professor
                                </label>
                             </section>
							 <section class="col col-10">
                                <label class="form-label">&nbsp;&nbsp;</label>
                              
                                <label>
                                    <input type="radio" name="tipo_colaborador" id="tipo_colaborador" value="F" onclick="carregaTelaFuncionario()"  <%if tipo_colaborador = "F" then response.Write("checked")%> > Funcionário
                                </label>
                             </section>
                        </div>
                        <div class="row">
                             <section class="col col-6">
                                <label class="form-label">Refer&ecirc;ncia:</label>
                              
                                <label class="input">
                                     <!--#include file="../includes/inc_PeriodoModulacao.asp" -->
									- De: <%=formataDataAP(strDataInicialModulacao)%> a <%=formataDataAP(strDataFinalModulacao)%>
                                </label>
                             </section>
                        </div>
                       	<div class="row">
							<section class="col col-2">
                                <label class="form-label">Data Inicial</label>
                              
                                <label class="input">
                                    <input name="txtDataLancamento" type="text" class="form-control" id="txtDataLancamento" onblur="return validaData(this)" onblur="return validaData(this); reloadDtFinal()" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataLancamento%>"  onChange='reloadDtFinal()'>
                                </label>
                             </section>
							 
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
										bloqueaBotoes = "S"
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
											bloqueaBotoes = "S"
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
										bloqueaBotoes = "S"
										'response.end
									end if
								end if
								%>
								 
								  <section class="col col-2">
									<label class="form-label">Data Final</label>
								  
									<label class="input">
										<input <%=bloqcampodatafinal%> name="txtDataLancamentoFinal" type="text" class="<%=classcampodatafinal%>" id="txtDataLancamentoFinal" onblur="validaData(this);verificaDatas();" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataLancamentoFinal%>">
									</label>
								 </section>
							 </div>
							 
							 <div class="row">
								 <section class="col col-2">
									<label class="form-label">Turno</label>
								  
									<label class="input">
										<!--#include file="../includes/inc_cmbTurnoRHfaltas.asp" -->
									</label>
									
								 </section>
								 
								 <section class="col col-4">
									<label class="form-label">Titular</label>
								  
									<label class="input">
										 <!--#include file="../includes/inc_cmdFuncionarioJustificativaModulacao.asp" -->
									</label>
								 </section>
							</div>
						
                       
						</fieldset><fieldset>
					 
					 </fieldset>
					 <%
                     if trim(bloqueaBotoes) = "S" then
						strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
						strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
						strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
					end if
					%>
					<div class="margin-left-60">
	                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
					</div>
                    
				<%
				if intCodModulacaoReferencia <> "" then
					sql = "select f.codigo, c.nome as colaborador, t.desc_turno as turno, f.fechamento, c.codFuncional, f.DataLancamento, f.DataLancamentoFinal, f.situacao, f.usuario_inclusao, f.data_inclusao, count(*) as faltas"
					sql=sql & " from SRH_COLABORADOR_FALTAS f"
					sql=sql & " inner join SRH_COLABORADOR c on c.codigo = f.cod_colaborador"
					sql=sql & " inner join SRH_COLABORADOR_FALTAS_DIARIA d on d.cod_colaborador_faltas = f.codigo"
					sql=sql & " inner join SRH_TURNO t on t.cod_turno = f.cod_turno_lancamento"
					sql=sql & " where convert(datetime,convert(varchar, f.DATALANCAMENTO , 103),103) >= convert(datetime, ' " & strDataInicialModulacao & " ',103)"
					sql=sql & " and convert(datetime,convert(varchar, f.DATALANCAMENTO, 103),103) <= convert(datetime, ' " & strDataFinalModulacao & " ',103)"
					sql=sql & " and f.cod_empresa = " & session("codEmpresa")
					sql=sql & " and tela_inclusao = 'TELA_FUNCIONARIO'"
					sql=sql & " group by f.codigo, c.nome, t.desc_turno, f.fechamento, c.codFuncional, f.DataLancamento, f.DataLancamentoFinal, f.situacao, f.usuario_inclusao, f.data_inclusao"
					sql=sql & " order by f.DataLancamento, f.DataLancamentoFinal"
                    RS.OPEN SQL, CNN
                    IF NOT RS.EOF THEN
                    %> 
                  <div class="panel panel-grey">
                        <div class="panel-heading">
                            <h3 class="panel-title"><i class="fa fa-tasks"></i> Faltas lançadas em <strong><%=year(date)%></strong>
                            </h3>
                        </div>
                        <div class="panel-body">
                        <table class="table table-bordered" >
                            <thead>
								<tr  bgcolor="#E2E2E2">
                                    <th width="1%" align="center"><input name="chkTodos" type="checkbox" value="" onClick="return marcaTodos()"></th>
									<th width="30%" align="center">Funcionário</th>
                                    <th width="2%"  align="center">Matrícula</th>
                                    <th width="5%"  align="center">Inicio</th>
                                    <th width="5%"  align="center"><strong>Final</strong></td>
									<th width="1%"  align="center"><strong>Faltas</strong></td>
                                    <th width="13%" align="center"><strong>Inclusão</strong></td>
                                    <th width="16%" align="center"><strong>Data</strong></td>
									<th width="5%" align="center"><strong>Situação</strong></td>
									<th width="5%" align="center"><strong>Enviada</strong></td>
									<th width="5%" align="center"><strong>Enviar</strong></td>
									<th width="5%" align="center"><strong>Devolver</strong></td>
                                </tr>
                            </thead>
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
									<td <%if trim(rs("fechamento")) <> "S" then%> onclick="return resultadoConsulta('<%=rs("CODIGO")%>')" <%end if%>><%=RS("colaborador")%>&nbsp;<i class="tamanho7">(<%=rs("turno")%>)</i></td>
                                    <td <%if trim(rs("fechamento")) <> "S" then%> onclick="return resultadoConsulta('<%=rs("CODIGO")%>')" <%end if%>><%=RS("codfuncional")%></td>
                                    <td <%if trim(rs("fechamento")) <> "S" then%> onclick="return resultadoConsulta('<%=rs("CODIGO")%>')" <%end if%>><%=strDataLancamento%></td>
                                    <td <%if trim(rs("fechamento")) <> "S" then%> onclick="return resultadoConsulta('<%=rs("CODIGO")%>')" <%end if%>><%=strDataLancamentoFinal%></td>
									<td <%if trim(rs("fechamento")) <> "S" then%> onclick="return resultadoConsulta('<%=rs("CODIGO")%>')" <%end if%>><%=RS("faltas")%></td>
                                    <td <%if trim(rs("fechamento")) <> "S" then%> onclick="return resultadoConsulta('<%=rs("CODIGO")%>')" <%end if%>><%=RS("usuario_inclusao")%></td>
                                    <td <%if trim(rs("fechamento")) <> "S" then%> onclick="return resultadoConsulta('<%=rs("CODIGO")%>')" <%end if%>><%=RS("data_inclusao")%></td>
									<td <%if trim(rs("fechamento")) <> "S" then%> onclick="return resultadoConsulta('<%=rs("CODIGO")%>')" <%end if%>><%=strSituacao%></td>
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
                      </div>
				</div>
                    <%
                    RS.CLOSE
                END IF
			end if
            %> 
			</div>
			</form>
         	<!-- Fecha o Form -->  
      </div>

        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
      
   	   
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
		
		var men = 'ATENÇÃO: Deseja enviar as faltas desses colaboradores selecionados?'
		if (confirm(men)) {
			frm.action="faltas_nao_justificadas_funcionario_cod.asp?enviarFalta=S&acao=ENVIAR";
			frm.submit();
			return true;
		} else {
			return false;
		}
	}
	function carregaTelaFuncionario(){
		var frm = document.getElementById("frm");
		frm.action = "faltas_nao_justificadas_funcionario_cad.asp?tipo_colaborador=F";
		frm.submit();
	}
	function carregaTelaProfessor(){
	
		var frm = document.getElementById("frm");
		frm.action = "faltas_nao_justificadas_professor_cad.asp?tipo_colaborador=P";
		frm.submit();
	}
	function devolverFaltas(CodRegistroMestre){
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
		var men = 'ATENÇÃO: Deseja devolver a falta desses colaboradores selecionados?'
		if (confirm(men)) {
			frm.action="faltas_nao_justificadas_funcionario_cod.asp?devolverFalta=S";
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
		frm.action = "faltas_nao_justificadas_funcionario_cad.asp?dtf=";
		frm.submit();
	}
	function reloadDtFinal(){
	
		frm.action = "faltas_nao_justificadas_funcionario_cad.asp?dtf=s";
		frm.submit();
	}
	function reloadTpLanc(){
	
		frm.action = "faltas_nao_justificadas_funcionario_cad.asp?tpl=s";
		frm.submit();
	}
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (acao=="E"){
			frm.action="faltas_nao_justificadas_funcionario_cod.asp?acao=" + acao;
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
	
			if (frm.cmbColaborador.value == "0" && acao!="E" ) {
				alert("O Funcionário Titular deverá ser informado.");
				frm.cmbColaborador.focus();
				return false;
			}
	
			frm.action="faltas_nao_justificadas_funcionario_cod.asp?acao=" + acao;
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
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 