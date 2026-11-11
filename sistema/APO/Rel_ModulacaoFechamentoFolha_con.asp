<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
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
	strExecutarSubmitModulacaoReferencia = "S"
	strEmpresaGrupo_submit = "S"
	strExecutarSubmitColaborador = "S"

	strPagina = "Rel_ModulacaoFechamentoFolha_con.asp"
	strPaginaTitulo = "Rel_ModulacaoFechamentoFolha_con.asp"
	Pagina = "Rel_ModulacaoFechamentoFolha_con.asp"
	
	intCodModulacaoReferencia 		= Trim(Request.form("cmbModulacaoReferencia"))
	intCodFuncional  				= Trim(Request.Form("txtCodigoFuncional"))
	intCodColaborador				= Trim(Request.form("txtCodFuncionario"))
	strnome 						= Trim(Request.Form("txtNomeFuncionario"))
	intCodEmpresaGrupo				= Trim(Request.Form("cmbEmpresaGrupo"))
	strOpcaoRelatorio				= Trim(Request.Form("cmbOpcaoRelatorio"))
	intCodCargoCategoria 			= Trim(Request.Form("cmbCargoCategoria"))
	strDataInicialModulacao	= request.Form("txtDataInicial")
	strDataFinalModulacao	= request.Form("txtDataFinal")

	if strTipo_Funcao = ""  then
		strTipoModulacao = Trim(Request.Form("optTipoModulacao"))
	end if
	
	if intCodEmpresaGrupo="" then intCodEmpresaGrupo = "0"
	if intCodEmp = "" then intCodEmp = session("codEmpresa")
	if intCodFuncional <> "" then intCodEmpresaGrupo = "0"

	if intCodModulacaoReferencia <> "" then
		sql = "select AnoReferencia, SemestreReferencia from SRH_MODULACAO_REFERENCIA WHERE CODIGO = " & intCodModulacaoReferencia
		rs.open sql, cnn
		if rs.eof = false then
			strAnoLetivoReferencia  = rs("AnoReferencia")
			intSemestreReferencia 	= rs("SemestreReferencia")
			strAnoLetivo 			= rs("AnoReferencia")
			strSemestre 			= rs("SemestreReferencia")			
		end if
		rs.close
	end if

	if trim(intCodColaborador) <> "" then
	
		sql = "select c.codigo, c.nome, f.Tipo_Funcao, c.codFuncional, c.cod_nivel, c.situacao, c.cpf, tu.Desc_Turno as turno, c.codFuncao, isnull(n.Descricao,'NAO_INFORMADO') as nivel, f.Desc_Funcao as funcao, ca.desc_categoria as categoria, isnull(n.total_aulas,0) as total_aulas_nivel,  isnull(c.total_aulas,0) as total_aulas, isnull(c.carga_horario_contratada,0) as carga_horario_contratada,c.cod_empresa"
		sql = sql & " from srh_colaborador c"
		sql = sql & " left join srh_nivel n on n.codigo = c.cod_nivel"
		sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = c.codfuncao"
		sql = sql & " left join SRH_CATEGORIA ca on ca.Cod_Categoria = c.CodCategoria "
		sql = sql & " left join SRH_TURNO tu on tu.Cod_Turno = c.CodTurno "
		sql = sql & " Where c.Codigo = " & intCodColaborador
		rs.open sql, cnn
		if rs.eof = false then
			intCodColaborador			= rs("Codigo")
			intCodEmp           		= rs("Cod_Empresa")
			intCodEmpresaGrupo			= rs("Cod_Empresa")
			strnome 					= Trim(Rs("nome"))
			intCodFuncional				= Trim(Rs("CodFuncional"))
			strNivel					= Trim(Rs("nivel"))
			strFuncao					= Trim(Rs("funcao"))
			strTurnoContratado			= rs("turno")
			strCategoria				= Trim(Rs("categoria"))
			intContratado	 			= rs("total_aulas")
			intContratadoNivel			= rs("total_aulas_nivel")
			strTipo_Funcao				= rs("Tipo_Funcao")
			strCPF  					= Trim(Rs("CPF"))
			strSituacaoColaborador 		= rs("situacao")
			intCodFuncaoColaborador		= rs("codFuncao")
			
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		end if 
		rs.close
	end if


		
	if Trim(Request.Form("LocalizarMatricula")) = "S" and intCodFuncional <> "" then
	
		sql = " Select c.codigo, c.nome, c.cpf, f.Tipo_Funcao, c.cod_nivel, c.codFuncao, c.situacao, "
		sql = sql & " c.codFuncional, tu.Desc_Turno as turno, c.cpf, n.Descricao as nivel, f.Desc_Funcao as funcao, "
		sql = sql & " ca.desc_categoria as categoria, isnull(n.total_aulas,0) as total_aulas_nivel, isnull(c.total_aulas,0) as total_aulas, c.cod_empresa"
		sql = sql & " from srh_colaborador c"
		sql = sql & " left join srh_nivel n on n.codigo = c.cod_nivel"
		sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = c.codfuncao"
		sql = sql & " left join SRH_CATEGORIA ca on ca.Cod_Categoria = c.CodCategoria "
		sql = sql & " left join SRH_TURNO tu on tu.Cod_Turno = c.CodTurno "
		sql = sql & " where C.CodFuncional = " & intCodFuncional
		
		rs.open sql, cnn
		if rs.eof = false then
			
			intCodColaborador			= rs("Codigo")
			intCodEmp           		= rs("Cod_Empresa")
			intCodEmpresaGrupo			= rs("Cod_Empresa")
			strnome 					= Trim(Rs("nome"))
			intCodFuncional				= Trim(Rs("CodFuncional"))
			strNivel					= Trim(Rs("nivel"))
			strFuncao					= Trim(Rs("funcao"))
			strTurnoContratado			= rs("turno")
			strCategoria				= Trim(Rs("categoria"))
			intContratado	 			= rs("total_aulas")
			intContratadoNivel			= rs("total_aulas_nivel")
			strTipo_Funcao				= rs("Tipo_Funcao")
			strCPF  					= Trim(Rs("CPF"))
			strSituacaoColaborador 		= rs("situacao")
			intCodFuncaoColaborador		= rs("codFuncao")
			
			bolColaboradorEncontrato = "S"
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
			
		else
			%>
				<script>
					alert("Matrícula não Localizada. Verifique!")
					window.location='Rel_ColaboradorSubstituto_con.asp';
				</script>
			<%
			response.end	
		end if
		rs.close
	end if


%>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Modulação Colaborador</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
            <form method="post" id="frm" action="#">
            <input name="txtCarregado" id="txtCarregado" value="<%=strCarregado%>" type="hidden" >

					<div class="form-group">
                        <label class="form-label">Opções de Relatório</label>
                        <select style="width:200px" name="cmbOpcaoRelatorio" id="cmbOpcaoRelatorio" class="form-control">
                            <option <%if strOpcaoRelatorio = "1" then%> selected <%end if%> value="1">Analítico</option>
                            <option <%if strOpcaoRelatorio = "2" then%> selected <%end if%> value="2">Sintético</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Refer&ecirc;ncia</label>
                        <!--#include file="../includes/inc_PeriodoModulacao.asp" --> - De: <%=formataDataAP(strDataInicialModulacao)%> a <%=formataDataAP(strDataFinalModulacao)%>
                    </div>
					<%
                            if request.Form("txtDataInicial") <>"" then strDataInicialModulacao	= request.Form("txtDataInicial")
                            if request.Form("txtDataFinal")	  <>"" then strDataFinalModulacao	= request.Form("txtDataFinal")
                    %>                            
                     <div class="form-group">
                        <label class="form-label">Per&iacute;odo</label>
                        <input name="txtDataInicial" type="text" class="form-control" id="txtDataInicial" onblur="return validaData(this);" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataInicialModulacao%>" title="Click aqui para visualizar o calend&aacute;rio">
                        &aacute;
                        <input name="txtDataFinal" type="text" class="form-control" id="txtDataFinal" onblur="return validaData(this);" onkeypress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataFinalModulacao%>" title="Click aqui para visualizar o calend&aacute;rio">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Matr&iacute;cula Funcional</label>
                    	<input name="txtCodigoFuncional" type="text" class="form-control" id="txtCodigoFuncional" size="12" maxlength="8" value="<%=intCodFuncional%>"  onKeyPress="return formataCampo(this, 2, 8)">
                  		<input type="checkbox" name="LocalizarMatricula" value="S" onClick='submit()'>
						Localizar?
                    </div>
                    
                    <div style="display:none" class="form-group">
                        <label class="form-label">Nome</label>
                         <input name="txtCodFuncionario" value="<%=intCodColaborador%>" type="hidden" id="txtCodFuncionario" >
                          <input name="txtCodEmpresa" value="<%=intCodEmp%>" type="hidden" id="txtCodEmpresa" >
                          <input name="txtcodLotacaoAnterior" value="<%=intcodLotacaoAnterior%>" type="hidden" id="txtcodLotacaoAnterior" >
                          <input readonly name="txtNomeFuncionario" type="text" class="form-control" id="txtNomeFuncionario" size="50" maxlength="70" value="<%=strNome%>">
                          <button class="btn-u btn-u-green" onclick="return abreConsultaColaborador('Colaborador_con.asp?PaginaOrigem=colaborador_cad')" type="button"><i class="fa fa-search"></i></button>
                    </div>
                   
                    <div class="form-group">
                      <label class="form-label">Categoria do Cargo</label>
                        <!--#include file="../includes/inc_cmbCargoCategoria.asp" -->
                    </div>
                    
                    <%'if intCodFuncional = "" then %>
                    <div class="form-group">
                        <label class="form-label">Unidade Escolar</label>
                    	<!--#include file="../includes/inc_cmbEmpresaGrupoDiretrizes.asp"-->
                    </div>
                    <%' end if %>
                    
                    <div class="form-group">
                        <label class="form-label">Classificar</label>
                    	<select name="cmbClassificacao" id="cmbClassificacao" class="form-control">
                        <option <%if strClassificacao = "1" then%> selected <%end if%> value="1">Colaborador</option>
                        <option <%if strClassificacao = "2" then%> selected <%end if%> value="2">Unidade</option>
                        <option <%if strClassificacao = "3" then%> selected <%end if%> value="3">Fun&ccedil;&atilde;o</option>
                        <option <%if strClassificacao = "5" then%> selected <%end if%> value="5">Turno</option>
                      </select>
                    </div>
                    
              <div class="form-group">
                <label class="form-label">Mostrar CH. Contratada/Total Modulado?&nbsp;<input type="checkbox" name="chkCHContratoModulacao" value="S" ></label>
                  	
              </div>

                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
       <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
	<script>
    
        function abreConsultaColaborador(caminho){
            window.open(caminho,"abreConsulta","top=5,left=5,height=510,width=719,menubar=no,toolbar=no,scrollbars=yes,status=yes");
        }
        
        function gerar(){
    
            var frm = document.getElementById("frm");
    
            if (frm.cmbModulacaoReferencia.value == "0") {
                alert("A Referencia deve ser informada!");
                frm.cmbModulacaoReferencia.focus();
                return false;
            }
            if (frm.cmbCargoCategoria.value == "0") {
                alert("A Categoria do cargo deve ser informada!");
                frm.cmbCargoCategoria.focus();
                return false;
            }
            var caminho;
            if (frm.cmbOpcaoRelatorio.value == "1") 
                caminho = "Rel_ModulacaoFechamentoFolhaAnalitico_rel.asp"
                
            if (frm.cmbOpcaoRelatorio.value == "2")
                caminho = "Rel_ModulacaoFechamentoFolhaSintetico_rel.asp"
            
            frm.action = caminho;
            frm.submit();
            return true;	
        }	
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 