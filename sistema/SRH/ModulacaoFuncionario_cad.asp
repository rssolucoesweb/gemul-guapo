<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->

<!--#include file="../../includes/inc_formataCPF.asp"-->
<!--#include file="../../includes/inc_replaceRequest.asp"-->
<!--#include file="../../js/Calendario/Calendario.asp"-->

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

	' Inativa todas as Modulacoes Vencidas vencidas
	sql = " Update SRH_MODULACAO_DISCIPLINAR_DOCENTE "
	sql = sql & " set status = 'I' "
	sql = sql & " where convert(datetime,convert(varchar, DataFinal, 103),103) < convert(datetime, ' " & date & "',103) "
	cnn.execute sql

	' Inativa todas as substituicoes vencidas
	sql = " Update SRH_COLABORADOR_SUBSTITUTO "
	sql = sql & " set SITUACAO = 'I' "
	sql = sql & " where Cod_Grupo = " & Session("CodGrupo")
	sql = sql & " and convert(datetime,convert(varchar, DataFinal, 103),103) < convert(datetime, ' " & date & "',103) "
	sql = sql & " and SITUACAO = 'A' "
	cnn.execute sql

	strBotaoInativaModulacao		= ""
	strPaginaTitulo = "ModulacaoFuncionario_cad.asp"
	session("voltarPaginaParaColaboradorModulacao") = ""
	strExecutarSubmitCurso = "S"
	strExecutarSubmitPeriodo = "S"
	strExecutarSubmitTurno = "S"
	strReloadDisciplinaQuadro = "S"
	strEmpresaGrupo_submit = "S"
	strExecutarSubmitColaborador = "S"
	strSubmitFuncao = "S"

	strPagina						= "ModulacaoFuncionario_cad.asp"
	intCodColaborador				= Trim(Request("txtCodFuncionario"))
	strcpf  						= Trim(Request.Form("txtcpf"))
	intCodFuncional  				= Trim(Request.Form("txtCodigoFuncional"))
	intCodFuncao					= Trim(Request("cmbFuncao"))
	strTipo_Funcao					= Trim(Request("txtHiddenTipo_Funcao"))

	strAnoLetivo 					= session("strAnoLetivo")
	strSemestre 					= session("strSemestre")
	
	strAno							= Trim(Request("cmbAno"))
	strAnoAtual = "S"
	if strAno = "" then
		if Trim(Request("txtAnoLetivo"))  = "" then
			strAno			= session("strAnoLetivo")
			strAnoLetivo	= session("strAnoLetivo")
		else
			strAnoLetivo	= Trim(Request("txtAnoLetivo"))
		end if
	else
		strAno			= Trim(Request("cmbAno"))
		strAnoLetivo	= Trim(Request("cmbAno"))
	end if
	
	if Trim(Request.form("txtCodFuncionario")) = "" then
		intCodColaborador 					= Trim(Request("txtCodFuncionario"))
	else
		intCodColaborador 					= Trim(Request.form("txtCodFuncionario"))
	end if	
	strnome 						= Trim(Request.Form("txtNomeFuncionario"))

	intCodEmpresa 					= Session("CodEmpresa")
	intCodigo	 					= Trim(Request.Form("txtCodigo"))
	intCodEmpresaGrupo				= Trim(Request.Form("cmbEmpresaGrupo"))
	if intCodEmpresaGrupo="" then intCodEmpresaGrupo = "0"

	if intCodEmp = "" then intCodEmp = session("codEmpresa")
	
	if trim(request("cmbSemestre")) = "0" or trim(request("cmbSemestre")) = ""  then 
		intSemestre = session("strSemestre")
	else
		intSemestre = request.Form("cmbSemestre")
	end if
	
	intCodTurnoColaborador		 	= Trim(Request.Form("cmbTurno"))
	if intCodTurnoColaborador = "" then intCodTurnoColaborador = "0"
	intCodTurnoOpcional		 	= Trim(Request.Form("cmbTurnoOpcional"))
	if intCodTurnoOpcional = "" then intCodTurnoOpcional = "0"
	
	intCodDisciplina 				= Trim(Request.Form("cmbDisciplina"))
	intTotalAulas 					= Trim(Request.Form("txtTotalAulas"))
	strDataInicio 					= Trim(Request.Form("txtDataInicio"))
	strDataFinal 					= Trim(Request.Form("txtDataFinal"))
	strSituacao						= Trim(Request.Form("cmbSituacao"))	

	if strSituacao = "0" or strSituacao = "" then strSituacao = "A"
	
	intCodNivel = request("cmbNivel")
	
	strTipoContratacao					= "C" 'Trim(Request("tipoContratacao"))	
	strPeriodoInicial					= Trim(Request.Form("txtPeriodoInicial"))	
	strPeriodoFinal						= Trim(Request.Form("txtPeriodoFinal"))	
	
	bolColaboradorEncontrato = "N"
	intCodFuncaoColaborador = ""
	intContratado = ""
	PorPeriodo = Trim(Request.Form("PorPeriodo"))
	
	if  intCodFuncional <> "" then ''Trim(Request.Form("LocalizarMatricula")) = "S" and
		
		sql = "select c.codigo, c.nome, c.cpf, f.Tipo_Funcao,n.MaximoModulado,  c.cod_nivel, c.codFuncao, c.situacao, c.codFuncional, "
		sql = sql & " tu.Desc_Turno as turno, c.cpf, n.Descricao as nivel, f.Desc_Funcao as funcao, ca.desc_categoria as categoria, "
		sql = sql & " isnull(n.total_aulas,0) as total_aulas_nivel, isnull(c.total_aulas,0) as total_aulas, c.cod_empresa"
		sql = sql & " From srh_colaborador c"
		
		if request("cmbNivel")<>"0" and request("cmbNivel")<>"" then
			sql = sql & " left join srh_nivel n on n.codigo = " & request("cmbNivel")
		else
			sql = sql & " left join srh_nivel n on n.codigo = c.cod_nivel"
		end if
		
		sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = c.codfuncao"
		sql = sql & " left join SRH_CATEGORIA ca on ca.Cod_Categoria = c.CodCategoria "
		sql = sql & " left join SRH_TURNO tu on tu.Cod_Turno = c.CodTurno "
		sql = sql & " INNER JOIN SEG_EMPRESA E ON E.CODIGO = C.CODLOTACAO "
		sql = sql & " where C.CodFuncional = " & intCodFuncional
		sql = sql & " and E.COD_GRUPO = " & session("codGrupo")
		'sql = sql & " And C.total_aulas  > 0"
		sql = sql & " And C.Situacao = 'A'"
		rs.open sql, cnn
		if rs.eof = false then
				MaximoModulado		= rs("MaximoModulado")
		
			intCodColaborador	= rs("Codigo")
			intCodEmp           = rs("Cod_Empresa")
			strnome 			= Trim(Rs("nome"))
			intCodFuncional		= Trim(Rs("CodFuncional"))
			strNivel			= Trim(Rs("nivel"))
			intCodNivel			= Trim(Rs("cod_nivel"))
			if request("cmbNivel")<>"0" then	
				intCodNivel = request("cmbNivel")
			end if
		
			strFuncao			= Trim(Rs("funcao"))
			strTurnoContratado	= rs("turno")
			strCategoria		= Trim(Rs("categoria"))
			intContratado	 	= rs("total_aulas")
			intContratadoNivel	= rs("total_aulas_nivel")
			strTipo_Funcao		= rs("Tipo_Funcao")
			
			strDesabilitaProfessor = ""
			
			if strTipo_Funcao = "PROFESSOR"  then
				strTipoModulacao = "PROFESSOR"
			end if
			
			if strTipo_Funcao = "FUNCIONARIO"  then
				strTipoModulacao = "FUNCIONARIO"
				strDesabilitaProfessor = " disabled "
			end if
			
			if strTipo_Funcao <> "FUNCIONARIO" OR intContratadoNivel > 0 THEN
				strDesabilitaProfessor = ""
			end if	

			strCPF  					= formataCPFap(Trim(Rs("CPF")))
			strSituacaoColaborador 		= rs("situacao")
			intCodFuncaoColaborador		= rs("codFuncao")
			bolColaboradorEncontrato 	= "S"
			
			
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		else
			%>
			<!--script>
				alert("Funcionario não contempla as regras para modulação. Verifique!")
				window.location='ModulacaoFuncionario_cad.asp';
			</script-->
<%
		'	response.end	
		end if
		rs.close
	end if
	
	if trim(intCodColaborador) <> "" and bolColaboradorEncontrato = "N" then
	
		sql = "select c.codigo, c.nome, f.Tipo_Funcao, c.codFuncional, c.cod_nivel,n.MaximoModulado,  c.situacao, c.cpf, tu.Desc_Turno as turno, c.codFuncao, isnull(n.Descricao,'NAO_INFORMADO') as nivel, f.Desc_Funcao as funcao, ca.desc_categoria as categoria, isnull(n.total_aulas,0) as total_aulas_nivel,  isnull(c.total_aulas,0) as total_aulas, isnull(c.carga_horario_contratada,0) as carga_horario_contratada,c.cod_empresa"
		sql = sql & " from srh_colaborador c"
		if request("cmbNivel")<>"0" and request("cmbNivel")<>"" then
			sql = sql & " left join srh_nivel n on n.codigo = " & request("cmbNivel")
		else
			sql = sql & " left join srh_nivel n on n.codigo = c.cod_nivel"
		end if
		sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = c.codfuncao"
		sql = sql & " left join SRH_CATEGORIA ca on ca.Cod_Categoria = c.CodCategoria "
		sql = sql & " left join SRH_TURNO tu on tu.Cod_Turno = c.CodTurno "
		sql = sql & " Where c.Codigo = " & intCodColaborador
		rs.open sql, cnn
		if rs.eof = false then
			IF strCarregado = "" THEN
				intCodColaborador	= rs("Codigo")
				MaximoModulado		= rs("MaximoModulado")
				intCodEmp           = rs("Cod_Empresa")
				strnome 			= Trim(Rs("nome"))
				intCodFuncional		= Trim(Rs("CodFuncional"))
				strNivel			= Trim(Rs("nivel"))
				
				if request("cmbNivel")<>"0" then	
					intCodNivel = request("cmbNivel")
				else
					intCodNivel			= Trim(Rs("cod_nivel"))
				end if
				
				strFuncao						= Trim(Rs("funcao"))
				strCategoria					= Trim(Rs("categoria"))
				intContratado	 				= rs("total_aulas")
				intCargaHorariaContratada	 	= rs("carga_horario_contratada")
				intContratadoNivel				= rs("total_aulas_nivel")
				strCPF  						= formataCPFap(Trim(Rs("CPF")))
				strTipo_Funcao					= rs("Tipo_Funcao")
				strDesabilitaProfessor = ""
				intCodFuncaoColaborador			= rs("codFuncao")
				strSituacaoColaborador 			= rs("situacao")
				strTurnoContratado				= rs("turno")
				
				strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
				strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
				strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
			
			ELSE
				strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
				strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
				strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
			END IF
		end if 
		rs.close
		
	else
		
		'busca pelo cpf
		if bolColaboradorEncontrato = "N" then
			sql = "select c.codigo, c.nome, f.Tipo_Funcao, c.codFuncional, n.MaximoModulado, c.cod_nivel, c.situacao, c.cpf, tu.Desc_Turno as turno, c.codFuncao, isnull(n.Descricao,'NAO_INFORMADO') as nivel, f.Desc_Funcao as funcao, ca.desc_categoria as categoria, isnull(n.total_aulas,0) as total_aulas_nivel, c.total_aulas, isnull(c.carga_horario_contratada,0) as carga_horario_contratada, c.cod_empresa"
			sql = sql & " from srh_colaborador c"
			if request("cmbNivel")<>"0" and request("cmbNivel")<>"" then
				sql = sql & " left join srh_nivel n on n.codigo = " & request("cmbNivel")
			else
				sql = sql & " left join srh_nivel n on n.codigo = c.cod_nivel"
			end if
			sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = c.codfuncao"
			sql = sql & " left join SRH_CATEGORIA ca on ca.Cod_Categoria = c.CodCategoria "
			sql = sql & " left join SRH_TURNO tu on tu.Cod_Turno = c.CodTurno "
			sql = sql & " Where c.cpf = '" & strCPF & "'"
			rs.open sql, cnn
			if rs.eof = false then
				intCodColaborador	= rs("Codigo")
				MaximoModulado		= rs("MaximoModulado")
				intCodEmp           = rs("Cod_Empresa")
				strnome 			= Trim(Rs("nome"))
				intCodFuncional		= Trim(Rs("CodFuncional"))
				strNivel			= Trim(Rs("nivel"))
				if request("cmbNivel")<>"0" and request("cmbNivel")<>"" then	
					intCodNivel = request("cmbNivel")
				else
					intCodNivel			= Trim(Rs("cod_nivel"))
				end if
				strFuncao			= Trim(Rs("funcao"))
				strCategoria		= Trim(Rs("categoria"))
				intContratado 		= rs("total_aulas")
				intCargaHorariaContratada	 = rs("carga_horario_contratada")
				intContratadoNivel	= rs("total_aulas_nivel")
				strTipo_Funcao		= rs("Tipo_Funcao")
				strDesabilitaProfessor = ""
				'if strTipo_Funcao = "PROFESSOR" then
					strTipoModulacao = "PROFESSOR"
				'end if
				'if strTipo_Funcao = "FUNCIONARIO" then
					strTipoModulacao = "FUNCIONARIO"
					strDesabilitaProfessor = " disabled "
				'end if
				if strTipo_Funcao <> "FUNCIONARIO" OR intContratadoNivel > 0 THEN
					strDesabilitaProfessor = ""
				end if	
				intCodFuncaoColaborador		= rs("codFuncao")
				strSituacaoColaborador = rs("situacao")
				strTurnoContratado	= rs("turno")
				bolColaborador		=  true
				
				strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
				strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
				strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
			else
				strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
				strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
				strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
			end if 
			rs.close
		end if		
	end if 
	intTotalAulasAlteracao = 0
	if trim(intCodigo) <> "" then
	
		sql = "SELECT Codigo, Cod_Colaborador, Cod_empresa, Cod_Curso, Cod_periodo, cod_funcao, Cod_turno, cod_turno_opcional, Cod_Disciplina, "
		sql = sql & " Total_Aulas, tipo_contratacao, Situacao_disciplinar, Ano_letivo, Semestre, status, periodo_inicial, periodo_final, DataInicial, DataFinal"
		sql = sql & " FROM SRH_MODULACAO_DISCIPLINAR_DOCENTE"
		sql = sql & " where codigo = " & intCodigo			
		rs.open sql, cnn
		if rs.eof = false then
			strBotaoInativaModulacao		= "S"
			strDesabilitaBotaoInativar		= ""
			intCodigo	 					= rs("Codigo")

			if Trim(Request.Form("cmbEmpresaGrupo")) = "0" or Trim(Request.Form("cmbEmpresaGrupo")) = "" then
				intCodEmpresa 					= rs("Cod_empresa")
				intCodEmpresaGrupo				= rs("Cod_empresa")
			end if
			intCodColaborador				= rs("Cod_Colaborador")
			if Trim(Request.Form("cmbCursoCombo")) = "0" or Trim(Request.Form("cmbCursoCombo")) = "" then
				intCodCurso 					= rs("Cod_Curso")
				intCodCursoCombo				= rs("Cod_Curso")
			end if
			if Trim(Request.Form("cmbFuncao")) = "0" or Trim(Request.Form("cmbFuncao")) = "" then
				intCodFuncao					= rs("Cod_Funcao")
			end if
			if Trim(Request("cmbPeriodo")) = "0" or Trim(Request("cmbPeriodo")) = "" then
				intCodPeriodo 					= rs("Cod_periodo")
			end if
			if Trim(Request.Form("cmbTurno")) = "0" or Trim(Request.Form("cmbTurno")) = "" then
				intCodTurnoColaborador 			= rs("Cod_turno")
			end if
			if Trim(Request.Form("cmbTurnoOpcional")) = "0" or Trim(Request.Form("cmbTurnoOpcional")) = "" then
				intCodTurnoOpcional 			= rs("Cod_turno_opcional")
			end if
			strTipoLancamento 				= rs("Situacao_disciplinar")
			if Trim(Request.Form("cmbDisciplina")) = "0" or Trim(Request.Form("cmbDisciplina")) = "" then
				intCodDisciplina				= rs("Cod_Disciplina")
			end if

			intTotalAulas					= rs("Total_Aulas")
			strSituacao						= trim(rs("status"))
			strTipoContratacao				= trim(rs("tipo_contratacao"))
			strPeriodoInicial				= formataDataAP(rs("periodo_inicial"))
			strPeriodoFinal					= formataDataAP(rs("periodo_final"))
			strDataInicio					= formataDataAP(rs("DataInicial"))
			strDataFinal					= formataDataAP(rs("DataFinal"))
			intTotalAulasAlteracao			= rs("Total_Aulas")
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
		
		else
			strDesabilitaBotaoInativar= "disabled"
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir

		end if 
		rs.close
	end if 

	'regras
	IF trim(strSituacaoColaborador) = "I" and intCodColaborador<>"" then
		%>
		<script>
			alert("O colaborador inativo, verifique!");
			window.location="ModulacaoFuncionario_cad.asp?tipoContratacao=C";
		</script>
		<%
		response.end
	end if
	IF strNivel = "NAO_INFORMADO" and intCodColaborador<>"" then
		%>
		<script>
			alert("O colaborador informado não está vinculado a um nível.");
			window.location="ModulacaoFuncionario_cad.asp?tipoContratacao=C";
		</script>
		<%
		response.end
	end if
	
	if intContratado = "" then intContratado = 0
	if intContratadoNivel = "" then intContratadoNivel = 0
	if intCodTurnoOpcional = "" then intCodTurnoOpcional = 0
	
	intModulado = "0"
	
	if intCodColaborador <> "" then
		
		sql = "select isnull(sum(dd.Total_Aulas),0) as modulado, dd.situacao_disciplinar, trh.Desc_Turno as turno, f.Tipo_Funcao "
		sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE dd"

		sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = dd.cod_funcao"
		sql = sql & " left join SRH_TURNO trh on trh.cod_turno = dd.cod_turno"

		sql = sql & " where dd.Cod_Colaborador = " & intCodColaborador
		sql = sql & " and dd.status = 'A'"
		sql = sql & " and dd.cod_turno is not null "
		sql = sql & " and isnull(dd.Cod_Modulacao_Substituicao,'0') = 0 "
		sql = sql & " and dd.ano_letivo = " & strAnoLetivo
		sql = sql & " AND dd.tipo_contratacao = 'C'"
		sql = sql & " and dd.tipo_contratacao is not null group by dd.situacao_disciplinar, trh.Desc_Turno, f.Tipo_Funcao"
		rs.open sql, cnn
		if rs.eof = false then
			intModulado = rs("modulado")
			if isnull(intModulado) then intModulado = "0"
			if trim(rs("situacao_disciplinar")) = "I" then
				intModulado = rs("modulado") * 21 ' intContratadoNivel
			end if
			
			if rs("Situacao_disciplinar") = "I" then
				
				intModulado = rs("modulado")*21
				
				if trim(ucase(rs("turno"))) = "INTEGRAL" and trim(ucase(rs("Tipo_Funcao"))) = "PROFESSOR" then
					intModulado = rs("modulado")*21
				end if      
				
				if trim(ucase(rs("turno"))) = "INTEGRAL" and trim(ucase(rs("Tipo_Funcao"))) = "FUNCIONARIO" then
					intModulado = rs("modulado")*42
				end if  
			end if
			
		end if
		rs.close
		
	end if
	if intCodFuncao = "" then intCodFuncao = "0"
	
	strSomenteProfessor = ""
	
	if strTipoModulacao = "FUNCIONARIO" then strSomenteProfessor = "style='display:none'"
	strMostraPeriodo = "style='display:none'"
	strMostraContrato = "style='display:none'"
	
	if PorPeriodo = "S" then strMostraPeriodo = "style='display:blobk'"
	if PorPeriodo = "" then strMostraContrato = "style='display:blobk'"
	
	if strTipoContratacao = "A" then strMostraPeriodo = "style='display:blobk'"
	if intContratadoNivel = "" then intContratadoNivel = 0
		
	if cInt(intContratadoNivel) = 14 then
		intContratadoMaximo = 20
	elseif cInt(intContratadoNivel) = 21 then
		intContratadoMaximo = 27
	elseif cInt(intContratadoNivel) = 28 then
		intContratadoMaximo = 42
	elseif cInt(intContratadoNivel) >= 42  then
		intContratadoMaximo = 42
	else
		intContratadoMaximo = MaximoModulado
	end if
	
	intSaldoContratado = 0
	if intContratado<>"" and intModulado<>"" then
		intSaldoContratado = intContratadoMaximo - intModulado - intPorPeriodo
	end if	
	
	if strTipoModulacao = "PROFESSOR" and intCodTurnoColaborador<>"0" and strDesabilitaExcluir<>"" and intCodCursoCombo<>"0" then
		'validar no interdisciplinar:
		'só pode lançar 1 por turno não importa a unidade
		sql = "select isnull(count(*),0) as qtde"
		sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE"
		sql = sql & " where cod_colaborador = "&intCodColaborador
		sql = sql & " and status = 'A'"
		sql = sql & " and ano_letivo = "&strAnoLetivo
		sql = sql & " and semestre = "&intSemestre
		if intCodTurnoOpcional <> "0" then
			sql = sql & " and cod_turno_opcional = "&intCodTurnoOpcional
		else
			sql = sql & " and cod_turno = " & intCodTurnoColaborador
		end if
		sql = sql & " and situacao_disciplinar = 'I'"
		rs.open sql, cnn
		if rs.eof = false then
			IF rs("qtde") > 0 then
				%>
				<script>
					alert("Funcionário já modulado nesse turno.");
				</script>
				<%

				strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
				strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
				strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
			end if
		end if
		rs.close
	end if
	strMostraPeriodo = "style='display:none'"
	if PorPeriodo = "S" then strMostraPeriodo = "style='display:blobk'"
	if strTipoContratacao = "A" then strMostraPeriodo = "style='display:blobk'"

	'response.write intTotalAulas
%>

    <!--=== Content Part ===-->
	<form method="post" name="frm" id="frm">	
	<input name="txtCodigo" id="txtCodigo" value="<%=intCodigo%>" type="hidden" >
    <input name="tipoContratacao" id="tipoContratacao" value="<%=strTipoContratacao%>" type="hidden" >
    <input name="txtCarregado" id="txtCarregado" value="<%=strCarregado%>" type="hidden" >
    <input name="txtHiddenTipo_Funcao" id="txtHiddenTipo_Funcao" value="<%=strTipo_Funcao%>" type="hidden" >
    <input value="<%=strChecaTurnoII%>" id="txtChecaTurnoII" name="txtChecaTurnoII" type="hidden">
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Modulação de Funcionário</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->  
             
             <table width="100%" border="0" cellpadding="0" cellspacing="0" >
        <tr valign="top">
          <td align="left" >
            <!-- inicio tabela de cadastro de funcionario -->
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td colspan="3" class="TextoForm"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
                </tr>
              <tr>
                <td colspan="3" class="TextoForm">&nbsp;</td>
                </tr>
              <tr> 
                <td height="24" colspan="3" bgcolor="#CCCCCC" class="TextoForm"><strong>Dados do Colaborador </strong></td>
                </tr>
              
              <tr>
                <td height="33" class="TextoForm"><strong>CPF:</strong></td>
                <td width="452" height="33" class="TextoForm"><input name="txtcpf" type="text" class="text" id="txtcpf" size="15" maxlength="70" value="<%=strCPF%>" onkeypress="return formataCampo(this,5,14)" onblur="return validaCPFColaborador(this)"></td>
                <td width="650" rowspan="3" align="right" class="TextoForm">
                <table width="95%" border="0" cellspacing="0" cellpadding="0" class="tabela">
                  <tr>
                    <td colspan="2" align="center" class="celula"><strong>Resumo da Contrata&ccedil;&atilde;o</strong></td>
                    </tr>
                  <tr>
                    <td class="celula">Categoria</td>
                    <td class="celula"><%=strCategoria%>&nbsp;</td>
                  </tr>
                  <tr>
                    <td class="celula">Fun&ccedil;&atilde;o</td>
                    <td class="celula"><%=strFuncao%>&nbsp;</td>
                  </tr>
                  <tr>
                    <td class="celula">Nivel</td>
                    <td class="celula">
                      <!--#include file="../includes/inc_cmbNivel.asp" --></td>
                  </tr>
                  <tr>
                    <td class="celula">Turno</td>
                    <td class="celula"><%=strTurnoContratado%>&nbsp;</td>
                  </tr>
                  <tr>
                    <td width="28%" class="celula">Contratado</td>
                    <td width="72%" class="celula"><%=intContratadoNivel%><input name="txtTotalContratual" id="txtTotalContratual" value="<%=intContratadoNivel%>" type="hidden" ></td>
                  </tr>
                  <tr>
                    <td class="celula">M&aacute;ximo</td>
                    <td class="celula"><%=intContratadoMaximo%><input name="txtContratadoMaximo" id="txtContratadoMaximo" value="<%=intContratadoMaximo%>" type="hidden" ></td>
                  </tr>
				  <tr>
                    <td class="celula"><font color="blue"><strong>Modulado</strong></font></td>
                    <td class="celula"><font color="blue"><strong><%=intModulado+intPorPeriodo%></strong></font><input name="txtTotalModulado" id="txtTotalModulado" value="<%=intModulado%>" type="hidden" >&nbsp;</td>
                  </tr>
                   <tr>
                    <td class="celula">
					<strong>
					<% if intSaldoContratado > 0 then%>
						<font color="green">Saldo</font>
					<% else %>
						<font color="red">Saldo</font>
					
					<% end if%>
					</strong>
					</td>
                    <td class="celula"><strong>
					<% if intSaldoContratado > 0 then%>
					
						<font color="green"><%=intSaldoContratado%></font>
					<% else %>
						<font color="red"><%=intSaldoContratado%></font>
					
					<% end if%>
					</strong>
					&nbsp;<input name="txtSaldoContratual" id="txtSaldoContratual" value="<%=intSaldoContratado%>" type="hidden" ></td>
                  </tr>
                </table></td>
                </tr>
              <tr>
                <td height="33" class="TextoForm">Matr&iacute;cula Funcional</td>
                <td height="33" class="TextoForm"><input name="txtCodigoFuncional" type="text" class="text" id="txtCodigoFuncional" size="12" maxlength="8" value="<%=intCodFuncional%>"  onKeyPress="return formataCampo(this, 2, 8)">
                  <input type="checkbox" name="LocalizarMatricula" value="S" onClick='submit()'>
                  Localizar?&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  <input type="checkbox" name="PorPeriodo"<%if PorPeriodo="S" then response.Write("checked")%>  value="S" onClick='submit()'>
Por Per&iacute;odo</td>
                </tr>
              <tr> 
                <td width="170" height="33" class="TextoForm">Nome:  </td>
                <td height="33" class="TextoForm">
                <input name="txtCodFuncionario" value="<%=intCodColaborador%>" type="hidden" id="txtCodFuncionario" >
                  <input name="txtCodEmpresa" value="<%=intCodEmp%>" type="hidden" id="txtCodEmpresa" >
                  <input name="txtcodLotacaoAnterior" value="<%=intcodLotacaoAnterior%>" type="hidden" id="txtcodLotacaoAnterior" >
                  <input name="txtNomeFuncionario" type="text" class="text" id="txtNomeFuncionario" size="50" maxlength="70" value="<%=strNome%>">
                  <button class="btn btn-success" onclick="return abreConsultaColaborador('Colaborador_con.asp?PaginaOrigem=ModulacaoFuncionario_cad&Tipo=F')" type="button"><i class="fa fa-search"></i></button>
                   <% if session("NivelPermissao") = "A" then %>
                  	<button class="btn btn-success" onclick="return acessarColaborador('Colaborador_cad.asp?txtCodFuncionario=<%=intCodColaborador%>&paginaVoltar=ModulacaoFuncionario_cad.asp?txtCodFuncionario=<%=intCodColaborador%>')" type="button"><i class="icon-users"></i></button>
                  <% end if %>
                  </td>
                </tr>
              <tr> 
                <td height="24" colspan="3" bgcolor="#CCCCCC" class="TextoForm"><strong>Dados da Modula&ccedil;&atilde;o</strong></td>
              </tr>
              <% if intCodColaborador <> "" then %>
              <tr>
                <td height="24" class="texto2">Ano Letivo:</td>
                <td height="24" ><span class="texto2">
                <input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" value="<%=strAnoLetivo%>" size="5" maxlength="5" onkeypress="return formataCampo(this,2,10)">
                </span></td>
                <td valign="top" align="left" ></td>
              </tr>
              <tr>
                <td width="170" height="24" class="texto2">Semestre: </td>
                <td height="24" ><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
                <td valign="top" align="left" >                </td>
            </tr>
              <tr>
                <td height="24" class="texto">Fun&ccedil;&atilde;o:</td>
                <td height="24"  class="texto"><!--#include file="../includes/inc_cmdFuncaoModulacaoFuncionario.asp" --></td>
                <td align="left" valign="top" ></td>
              </tr>
              <tr <%=strMostraPeriodo%> >
              <td height="24" class="texto">Per&iacute;odo:</td>
              <td height="24"  class="texto">
                <input name="txtPeriodoInicial" type="text" class="text" id="txtPeriodoInicial" onblur="return validaData(this)" onkeypress="return formataCampo(this, 3, 10)" size="11" value="<%=strPeriodoInicial%>" style="cursor:hand" title="Click aqui para visualizar o calend&aacute;rio">
                </span>a <span class="TextoForm">
                  <input name="txtPeriodoFinal" type="text" class="text" id="txtPeriodoFinal" onblur="return validaData(this)" onkeypress="return formataCampo(this, 3, 10)" size="11" value="<%=strPeriodoFinal%>" style="cursor:hand" title="Click aqui para visualizar o calend&aacute;rio" onchange="return verificaDatas(frm.txtPeriodoInicial.value, frm.txtPeriodoFinal.value)">
                  </td>
              <td align="left" valign="top" >              </td>
            </tr>
            <tr>
              <td height="24" class="texto">Unidade Escolar:</td>
              <td height="24"  class="texto"><!--#include file="../includes/inc_cmbEmpresaGrupoModulacaoFuncionario.asp"--></td>
              <td rowspan="9" align="left" valign="top" >
                 
              <!-- substituição -->
            <%
			if intCodColaborador <> "" then
				sql = " SELECT "
				sql = sql & " e.RAZAOSOCIAL, "
				sql = sql & " c.descricao as curso, "
				sql = sql & " p.descricao as periodo, "
				sql = sql & " T.Desc_turno, "
				sql = sql & " d.Desc_Disciplina as disciplina, "
				sql = sql & " cs.Total_Aulas "
				sql = sql & " FROM SRH_COLABORADOR_SUBSTITUTO_ITENS cs "
				sql = sql & " inner join SRH_COLABORADOR_SUBSTITUTO dd on dd.Codigo = cs.Cod_Substituicao "
				sql = sql & " inner join SCA_CURSO c on c.cod_curso = cs.cod_curso " 
				sql = sql & " inner join SEG_EMPRESA e on e.CODIGO = dd.Cod_empresa " 
				sql = sql & " left join SCA_periodo p on p.cod_periodo = cs.cod_periodo " 
				sql = sql & " left join SCA_disciplina d on d.cod_disciplina = cs.cod_disciplina "
				sql = sql & " left join SCA_TURNO T on T.cod_turno = cs.cod_turno "
				sql = sql & " where dd.CodColaboradorSubstituto = " & intCodColaborador
				sql = sql & " and dd.situacao = 'A'"
				rs.open sql, cnn
				if rs.eof = false then
					%>
				  <table width = "85%" border="1" align="left" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
					<tr bgcolor="#E5E5E5" class="celula">
					  <td height="21" colspan="6" bgcolor="#FFFFFF" class="celula"><div align="center"><strong>Substitui&ccedil;&atilde;o</strong></div></td>
					  </tr>
					<tr bgcolor="#E5E5E5" class="celula">
					  <td class="celula">Unidade</td>
					  <td class="celula">Curso</td>
					  <td class="celula">Turno</td>
					<td width="68" height="14" class="celula">Per&iacute;odo</td>
					<td class="celula">Disciplina</td>
					<td width="42" class="celula">Aulas</td>
					</tr>
					<%
					while not rs.eof
					   cont = cont + 1	
					   %>
					   <tr bgcolor="#FFFFFF" class="celula" >
						 <td width="299" class="celula9">&nbsp;<%=trim(rs("RAZAOSOCIAL"))%></td>
						 <td width="209" class="celula9"><%=trim(rs("curso"))%></td>
						 <td width="59" class="celula9">&nbsp;<%=trim(rs("Desc_turno"))%></td>
					   <td height="26" class="celula9">&nbsp;<%=trim(rs("periodo"))%></td>
					   <td width="203" height="26" class="celula9">&nbsp;<%=trim(rs("disciplina"))%></td>
					   <td height="26" class="celula9" align="center"><%=trim(rs("Total_Aulas"))%></td>
					   </tr>
					   <%				
					   rs.movenext
					wend
					%>
					</table>
					<br>
					<%
				end if
				rs.close
			end if
			%>              </td>
              </tr>
            <tr>
              <td height="24" class="texto">Turno:</td>
              <td height="24"  class="texto"><!--#include file="../includes/inc_cmdTurnoModulacaoFuncionario.asp" --></td>
            </tr>
            
   			<%
			saldo = "0"
			''
			'''' Total de Vagas Oferecidas
			''
			strVagasFuncao = "0"
			sql = " SELECT ISNULL(SUM(D1.VagasOferecidas),'0') as VagasFuncao  "   
			sql = sql & " FROM SRH_DIRETRIZES D1 "  
			sql = sql & " INNER JOIN SEG_EMPRESA E1 ON E1.CODIGO = D1.Cod_Empresa "  
			sql = sql & " INNER JOIN SEG_GRUPO GR1 ON GR1.CODIGO = E1.COD_GRUPO " 
			sql = sql & " LEFT JOIN SRH_TURNO TU ON TU.cod_Turno = D1.Cod_turno " 
			sql = sql & " WHERE GR1.Codigo = " & Session("CodGrupo") 
			sql = sql & " AND D1.Ano_Letivo = " & strAnoLetivo
			sql = sql & " AND D1.Semestre = " & intSemestre
			if intCodEmpresaGrupo <> "0" then 
				sql = sql & " AND D1.Cod_Empresa = " & intCodEmpresaGrupo
			end if
			if intCodFuncao <> "0" then 
				sql = sql & " AND D1.CodFuncao = " & intCodFuncao
			end if
			if intCodTurnoColaborador <> "0" then 
				sql = sql & " AND D1.Cod_Turno  = " & intCodTurnoColaborador 
			end if
			rs.open sql, cnn
			if rs.eof = false then
				strVagasFuncao = rs("VagasFuncao")
			end if
			rs.close 
			'''' fim  
			''
			'''' Total de Vagas Modulada
			''
			strTotalModulado = "0"
			sql = " SELECT ISNULL(SUM(M2.Total_Aulas),'0') as Total_Modulado "   
			sql = sql & " FROM SRH_MODULACAO_DISCIPLINAR_DOCENTE M2 "  
			sql = sql & " INNER JOIN SEG_EMPRESA E2 ON E2.CODIGO = M2.Cod_Empresa  " 
			sql = sql & " INNER JOIN SEG_GRUPO GR2 ON GR2.CODIGO = E2.COD_GRUPO " 
			sql = sql & " WHERE GR2.Codigo = " & Session("CodGrupo")
			sql = sql & " AND M2.Ano_Letivo = " & strAnoLetivo
			sql = sql & " AND M2.Semestre = " & intSemestre
			sql = sql & " AND M2.tipoModulacao = 'FUNCIONARIO' "
			sql = sql & " AND M2.Status = 'A' "
			if intCodEmpresaGrupo <> "0" then   
				sql = sql & " AND M2.Cod_Empresa = " & intCodEmpresaGrupo 
			end if
			if intCodFuncao <> "0" then 
				sql = sql & " AND M2.Cod_Funcao = " & intCodFuncao 
			end if
			if intCodTurnoColaborador <> "0" then 
				sql = sql & " AND M2.Cod_Turno  = " & intCodTurnoColaborador 
			end if
			rs.open sql, cnn
			if rs.eof = false then
				strTotalModulado = rs("Total_Modulado")
			end if
			rs.close
			
			saldo = strVagasFuncao - strTotalModulado

			%>
                <td height="25" class="TextoForm">&nbsp;</td>
                <td class="TextoForm">
                  
                  <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#C0C0C0">
                    <tr>
                      <td width="7" class="texto">&nbsp;</td>
                      <td width="244" height="22" class="texto">Vagas - Existente:&nbsp;<%=strVagasFuncao%></td>
                      <td width="193" class="texto">Modulada: <%=strTotalModulado%></td>
                      <td width="173" class="texto">Dispon&iacute;vel: <%=saldo%><input name="txtSaldoDisponivelFuncao" id="txtSaldoDisponivelFuncao" value="<%=saldo%>" type="hidden" ></td>
                      </tr>
                    </table>                </td>
                </tr>
                <tr>
                  <td height="25" class="TextoForm"><span class="texto">Entradas:</span></td>
                  <td class="TextoForm"><% 
				if strChecaTurnoIntegral = "I" and strChecaTurnoIntegralOpcional = "I" and strTipoLancamento = "I" then 
                        intTotalAulas = 2
						strOCulta = "hidden"
						%>
                    1
                      <%
                else 
						strOCulta = "text"
						intTotalAulas = ""
				end if
				%>
                      <input <%=strDesbilitaAulas%> name="txtTotalAulas"  type="<%=strOCulta%>" id="txtTotalAulas" class="text" size="10" value="<%=intTotalAulas%>" onkeypress="return formataCampo(this, 2, 5)" maxlength="10" onblur="validaEntrada(this.value)"></td>
                </tr>
                <tr <%=strMostraContrato%>>
                <td height="25" class="TextoForm">Data Inicio: </td>
                <td class="TextoForm">
                  <input name="txtDataInicio" type="text" class="text" id="txtDataInicio" onblur="return validaData(this)" onkeypress="return formataCampo(this, 3, 10)" size="11" value="<%=strDataInicio%>" style="cursor:hand" title="Click aqui para visualizar o calend&aacute;rio">
a
<input name="txtDataFinal" type="text" class="text" id="txtDataFinal" onblur="return validaData(this)" onkeypress="return formataCampo(this, 3, 10)" size="11" value="<%=strDataFinal%>" style="cursor:hand" title="Click aqui para visualizar o calend&aacute;rio" ></td>
                </tr>
				<tr <%=strMostraContrato%>>
                  <td height="25" class="TextoForm">Modula&ccedil;&atilde;o Anos Anteriores:</td>
                  <td colspan="2" class="TextoForm"><%strAnoAtual="S"%><!--#include file="../includes/inc_cmbAno.asp" --></td>
                </tr>
            <% end if %>    
              </table>
            <!-- fim tabela de cadastro de funcionario -->		  </td>
        </tr>
        <tr valign="top">
          <td height="17" align="center" class="tituloPrincipal style2"></td>
        </tr>
        <tr valign="top">
          <td height="18" align="center" class="tituloPrincipal style2"></td>
        </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
        </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2">&nbsp;</td>
        </tr>
        
		<tr valign="top">
          <td align="center" class="tituloPrincipal style2">
          
          
          <%
		  if trim(intCodColaborador) <> "" then
	
			sql = "select dd.Codigo, dd.Situacao_disciplinar, p.Descricao as periodo, t.desc_turno as turno, "
			sql = sql & " tur.desc_turno as Desc_turno_opcional, dd.Total_Aulas, dd.tipo_contratacao, dd.periodo_inicial, dd.periodo_final, dd.status, "
			sql = sql & " dd.Ano_letivo, dd.Semestre, e.RAZAOSOCIAL, dd.DataInicial,  dd.DataFinal, "
			sql = sql & " f.cod_funcao, f.Desc_Funcao as funcao, f.Tipo_Funcao, isnull(dd.Cod_Modulacao_Substituicao,'0') as Cod_Substituicao, "
			sql = sql & " d.Desc_Disciplina as disciplina, dd.status, dd.TipoModulacao"
			sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE dd "
			sql = sql & " inner join SEG_EMPRESA e on e.CODIGO = dd.Cod_empresa "
			sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = dd.cod_funcao"
			sql = sql & " left join SCA_disciplina d on d.cod_disciplina = dd.cod_disciplina"
			sql = sql & " left join SCA_periodo p on p.cod_periodo = dd.cod_periodo"
			sql = sql & " left join SRH_TURNO t on t.cod_turno = dd.cod_turno"
			sql = sql & " left join SRH_TURNO tur on tur.cod_turno = dd.cod_turno_opcional "
			sql = sql & " where dd.Cod_Colaborador = " & intCodColaborador	
			sql = sql & " and dd.ano_letivo = " & strAnoLetivo
			''sql = sql & " and dd.status = 'A'"
			sql = sql & " order by dd.tipo_contratacao desc, dd.codigo"
			rs.open sql, cnn
			if rs.eof = false then
		        %>
			  <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
	            <tr bgcolor="#E5E5E5" class="celula">
	              <td height="26" class="celula">Unidade</td>
		        <td class="celula">Fun&ccedil;&atilde;o</td>
		        <td class="celula">Data Inicial / Final</td>
		        <td class="celula">Situa&ccedil;&atilde;o</td>
		        <td class="celula">Turno</td>
		        <td width="94" class="celula">Aulas/Entrada</td>
		        <td colspan="2" class="celula">Origem</td>
	            </tr>
			    <%
				Total_Aulas = 0
			    while not rs.eof
				   cont = cont + 1	
				   strSituacaoDisciplinar = rs("Situacao_disciplinar")
				   if strSituacaoDisciplinar = "D" then strSituacaoDisciplinar = "Disciplinar"
				   if strSituacaoDisciplinar = "I" then strSituacaoDisciplinar = "Interdisciplinar"
				   
				   if rs("Cod_Substituicao") = "0" then 
					   strorigem = "CONTRATUAL"	
					   TipoModSub = "C"
				   else				
					   strorigem = "SUBSTITUICAO"	
					   TipoModSub = "S"
				   end if
				   
					link = "onClick='return resultadoConsulta(" & rs("codigo") & ")'"
					strStatus = "Ativo"
				   	if trim(rs("status")) <> "A" then 
						cor = "#C0C0C0"
						link = ""
						strStatus = "Inativo"
					end if
				   
				   periodo = ""
				   tipo = "Contratual"
				   cor = "#FFFFFF"
				   if rs("tipo_contratacao") = "A" then 
				   		periodo = "&nbsp;(" & formatadataAP(rs("periodo_inicial")) & " a " & formatadataAP(rs("periodo_final")) & ")"
						tipo = "Adicional"
						cor = "#C6E2FF"
						strorigem = "PERÍODO"	
						link = ""
						TipoModSub = "P"
					end if
					link = "onClick='return resultadoConsulta(" & rs("codigo") & ")'"
					if rs("Cod_Substituicao") <> "0" then 
						cor = "#C0C0C0"
						link = ""
					end if
					
					if rs("Situacao_disciplinar") = "I" then
						
						intTAulas = rs("Total_Aulas")*21
						
						if trim(ucase(rs("turno"))) = "INTEGRAL" and trim(ucase(rs("Tipo_Funcao"))) = "PROFESSOR" then
		                    intTAulas = rs("Total_Aulas")*21
                        end if      
						
						if trim(ucase(rs("turno"))) = "INTEGRAL" and trim(ucase(rs("Tipo_Funcao"))) = "FUNCIONARIO" then
		                    intTAulas = rs("Total_Aulas")*42
                        end if  
						                     
					else
						intTAulas = rs("Total_Aulas")
					end if
                
					turno = rs("turno")
					'turno = rs("Desc_turno_opcional")
					
                    if not isnull(rs("Desc_turno_opcional")) then
                       	turno = rs("Desc_turno_opcional")
					end if
					if rs("Cod_Substituicao") <> "0" then
					    cor = "#6699FF"
					end if
					if strStatus = "Inativo" then
					    cor = "#C0C0C0"
					end if
					if not isnull(rs("periodo_final")) then
						strPeriodoFinalComparar = replace(formataDataCalc(rs("periodo_final")),"/","")
						strDataAtualComparar 	= replace(formataDataCalc(date),"/","")
						
						if cCur(strPeriodoFinalComparar)<cCur(strDataAtualComparar) then 
							sql = "update SRH_MODULACAO_DISCIPLINAR_DOCENTE set status = 'I' where codigo = " & rs("codigo") 
							cnn.execute sql
							strStatus = "Inativo" 
							cor = "#C0C0C0"
						end if
					end if
					DataInicial = ""
					if not isnull(rs("DataInicial")) then
						DataInicial = formatadataAP(rs("DataInicial"))
					end if
					DataFinal = ""
					if not isnull(rs("DataFinal")) then
						DataFinal = formatadataAP(rs("DataFinal"))
					end if
					acesso = "style='cursor:hand' onMouseOver='return linhaMouseOver(this)' onMouseOut='return linhaMouseOut(this)' "
					if rs("tipoModulacao") = "PROFESSOR" and cor<>"#C0C0C0"  then
						cor = "#C99494"
						link = ""
						acesso = ""
					end if
					if rs("tipoModulacao") = "PROFESSOR" and cor="#C0C0C0"  then
						link = ""
						acesso = ""
					end if
					   %>
					   <tr  bgcolor="<%=cor%>" class="celula"  >
                           <td <%=acesso%>  <%=link%> width="339" class="celula9">&nbsp;<%=trim(rs("RAZAOSOCIAL"))%></td>
                           <td width="314" class="celula9">&nbsp;<%=trim(rs("funcao"))%><%=periodo%></td>
                           <td width="277" class="celula9"><%=trim(DataInicial)%> - <%=trim(DataFinal)%>&nbsp;</td>
                           <td class="celula9">&nbsp;<%=strStatus%></td>
                         <td height="26" class="celula9">&nbsp;<%=trim(turno)%>                           </td>
                         <td height="26" align="center" class="celula9">&nbsp;<%=trim(intTAulas)%></td>
                           <td width="27" class="celula" style="cursor:hand">&nbsp;<%=trim(strorigem)%></td>
				           <td width="25" class="celula" style="cursor:hand" onclick="return gerarImpressao('<%=TipoModSub%>','<%=left(strStatus,1)%>','<%=rs("Ano_letivo")%>','<%=intCodColaborador%>','<%=trim(rs("tipo_contratacao"))%>')"><img src="../../images/impressora_on.gif" width="26" height="26"></td>
                       </tr>
                   <% 
				   	if rs("status") = "A" then
				   		Total_Aulas = Total_Aulas + intTAulas
					end if
				   rs.movenext
			    wend
			    %>
			    <tr> 

			    <td height="21" class="celula"><span class="texto"><strong>Total Registros :</strong></span> <strong><%=cont%></strong></td>
			    <td height="21" colspan="2" class="celula">&nbsp;</td>
			    <td height="21" colspan="2" align="right" class="celula"><span class="texto"><strong>Total:</strong></span></td>
			    <td height="21" align="center" class="celula"><strong><%=Total_Aulas%></strong></td>
			    <td height="21" colspan="2" class="celula">&nbsp;</td>
			    <%
		    end if
		    rs.close
			 %>

              </table> 
			  <br>
			  <table align="center" width="40%" border="0" cellspacing="0" cellpadding="0" class="tabela">
                  <tr>
                    <td class="celula" width="17%" bgcolor="#COCOCO">&nbsp;</td>
                    <td class="celula" width="83%">&nbsp;Modula&ccedil;&atilde;o Inativa</td>
                  </tr>
                  <tr>
                    <td class="celula" bgcolor="#C99494">&nbsp;</td>
                    <td class="celula">&nbsp;Modula&ccedil;&atilde;o de Professores</td>
                  </tr>
                </table>
			  <%	
		 end if	
		 %>          </td>
        </tr>
    </table>   
            
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
        <!-- Fecha o Painel do Formulario -->        
    </div>
    <%if intTotalAulasAlteracao = "" then intTotalAulasAlteracao = 0%>
    <%if intTotalAulasAlteracao = "1" then intTotalAulasAlteracao = 21%>
    
    <input value="<%=Total_Aulas-intTotalAulasAlteracao%>" id="Total_Aulas_Grid_alter" name="Total_Aulas_Grid_alter" type="hidden">
    <input value="<%=Total_Aulas%>" id="Total_Aulas_Grid" name="Total_Aulas_Grid" type="hidden">
    </form>
    <!--/container-->		
	<script>
	
	function abreConsultaColaborador(caminho){
		frm.cmbNivel.value=0;
		
		window.open(caminho,"abreConsulta","top=5,left=5,height=510,width=719,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}

	function validaCPFColaborador(campo) {
		var pcpf=campo.value;
		
		pcpf = pcpf.replace(".","");
		pcpf = pcpf.replace(".","");
		pcpf = pcpf.replace("-","");
		
		if (pcpf != "") {
		
			if (pcpf.length != 11){
				sim=false;
			}
			else{
				sim=true;
			}
			
			if ( (pcpf==11111111111) || (pcpf==22222222222) ||
				(pcpf==33333333333) || (pcpf==44444444444) || (pcpf==55555555555) ||
				(pcpf==66666666666) || (pcpf==77777777777) || (pcpf==88888888888) ||
				(pcpf==99999999999) || (pcpf==00000000000) ){
					sim=false;
			}
			
			if(sim){
				for (i=0; i<=(pcpf.length-1) && sim; i++){
					val = pcpf.charAt(i);
					if((val!="9")&&(val!="0")&&(val!="1")&&(val!="2")&&(val!="3")&&(val!="4")&&( val!="5")&&(val!="6")&&(val!="7")&&(val!="8")){
						sim=false;
					}
				}
			
				if(sim){
					soma=0;
					for (i=0;i<=8;i++){
						val = eval(pcpf.charAt(i));
						soma = soma + (val*(i+1));
					}
				
					resto = soma % 11;
					
					if (resto>9)
						dig = resto -10;
					else
						dig = resto;
					
				
					if (dig != eval(pcpf.charAt(9))){
						sim=false
					}else{
						soma = 0
						for (i=0;i<=7;i++){
							val = eval(pcpf.charAt(i+1))
							soma = soma +	(val*(i+1))
						}
						soma = soma + (dig * 9)
						resto = soma % 11
						if (resto>9){
							dig = resto -10
						}else{
							dig = resto
						}
				
						if (dig != eval(pcpf.charAt(10))){
							sim = false
						}else{
							sim = true
						}
					}
				}
			}
			
			if (!sim){
				alert("CPF inválido!");
				campo.focus();
				campo.select();
			}else{
				if (campo.value!="")
					frm.submit();				
					
			}
					
		}
	}

	function limpar(Pagina){
		
		var frm = document.getElementById("frm");
		
		frm.action= Pagina;
		document.getElementById('frm').submit();
		return true;
		
	}
	function acessarColaborador(PaginaDestino){
		
		var frm = document.getElementById("frm");
		
		frm.action = PaginaDestino;
		document.getElementById('frm').submit();
		return true;
		
	}
	function InativarModucacao(){
		var frm = document.getElementById("frm");
		var men = 'ATENÇÃO: Deseja realmente inativar essa modulação?'
			if (confirm(men)) {
				frm.action= "ModulacaoInativarFuncionario_cod.asp?acao=I";
				frm.submit();
			} else {
				return false;
			}
	}
	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	function salvar(acao){
		
		
		
		
		var frm = document.getElementById("frm");
		if (acao=="E"){
			
			var frm = document.getElementById("frm");
			var men = 'ATENÇÃO: Deseja realmente excluir este colaborador'
			if (confirm(men)) {
				frm.action= "ModulacaoFuncionario_cod.asp?acao="+acao;
				frm.submit();
			} else {
				return false;
			}
		
		}else
			{
			
				
				
				if(frm.txtcpf.value == ""){
					alert("O CPF do colaborador deve ser informado!");
					frm.txtcpf.focus();
					return false		
				}
				
				if(frm.txtCodigoFuncional.value == ""){
					alert("A MATRÍCULA Funcional deve ser informada!");
					frm.txtCodigoFuncional.focus();
					return false		
				}

				if(frm.txtNomeFuncionario.value == ""){
					alert("O NOME do Colaborador deve ser informado!");
					frm.txtNomeFuncionario.focus();
					return false		
				}
				
				if (frm.tipoContratacao.value=="A" && (frm.txtPeriodoInicial=="" || frm.txtPeriodoFinal.value=="")){
					alert("O período da modulação adicional deverá ser informado!");
					frm.txtPeriodoInicial.focus();
					return false		
				}
				
				if(frm.txtAnoLetivo.value == ""){
					alert("O Ano deve ser informado!");
					frm.txtAnoLetivo.focus();
					return false		
				}

				if(frm.cmbSemestre.value == "0"){
					alert("O Semestre deve ser informado!");
					frm.cmbSemestre.focus();
					return false		
				}

				if(frm.cmbFuncao.value == "0"){
					alert("A função do Colaborador deve ser informada!");
					frm.cmbFuncao.focus();
					return false		
				}
				
				if(frm.PorPeriodo.checked == true){
					
					if(frm.txtPeriodoInicial.value == ""){
						alert("A Data do Periodo Inicial deve ser informada!");
						frm.txtPeriodoInicial.focus();
						return false		
					}
					
					if(frm.txtPeriodoFinal.value == ""){
						alert("A Data Periodo Final deve ser informada!");
						frm.txtPeriodoFinal.focus();
						return false		
					}
					
				}else {
					
					if(frm.txtDataInicio.value == ""){
						alert("A Data Inicio deve ser informado!");
						frm.txtDataInicio.focus();
						return false		
						}
				
				}

				if(frm.cmbEmpresaGrupo.value == "0"){
					alert("A unidade escolar deve ser informada!");
					frm.cmbEmpresaGrupo.focus();
					return false		
				}
			
				var saldoContratual = frm.txtSaldoContratual.value;
				if (saldoContratual == '') saldoContratual = 0;

				if(frm.cmbTurno.value == "0"){
					alert("O turno deve ser informado!");
					frm.cmbTurno.focus();
					return false		
				}
				
				if(frm.txtTotalAulas.value == ""){
					alert("O Aulas (entradas) deve ser informado!");
					frm.txtTotalAulas.focus();
					return false		
				}
				if(frm.txtTotalAulas.value == "0"){
					alert("O Aulas (entradas) não pode ser zero!");
					frm.txtTotalAulas.focus();
					return false		
				}
			
				var totalAulas = frm.txtTotalAulas.value;
				var strChecaTurnoIntegral = frm.txtChecaTurnoII.value;
				if (totalAulas=="") totalAulas = 0;
				
				if (strChecaTurnoIntegral != 'II'){ 
					if( parseInt(totalAulas) > 1  && frm.optTipoLancamento[1].checked ){
						alert("O Aulas (entradas) não pode ser maior que 1!");
						frm.txtTotalAulas.focus();
						return false		
					}
				}
				
				var TotalModulado = frm.Total_Aulas_Grid_alter.value;
				if (TotalModulado == '') TotalModulado = 0;
				var totalModulacaoMaisDigitado = parseInt(TotalModulado) + parseInt(totalAulas);
				if (parseInt(totalModulacaoMaisDigitado)>42){ //  && frm.optTipoModulacao[0].checked == true){
					alert("O total modulado não pode ultrapassar 42 aulas.");
					return false		
				}
				if (acao != "A"){
					if (parseInt(saldoContratual)<0){
						alert("Saldo não pode ser negativo, verifique o nível!");
						frm.cmbNivel.focus();
						return false		
					}
				}
				frm.action= "ModulacaoFuncionario_cod.asp?acao="+acao;
				frm.submit();
			}
	
	}
	function validaEntrada(digitado){
		
		var frm = document.getElementById("frm");
		if (digitado!=""){
			saldoDisponivelFuncao = frm.txtSaldoDisponivelFuncao.value;
			if (saldoDisponivelFuncao=="") saldoDisponivelFuncao = 0;
			if (parseInt(digitado)>parseInt(saldoDisponivelFuncao)){
				alert("O valor digitado no campo aulas (entradas) não pode ser maior que o saldo disponível para essa função ( disponível: "+saldoDisponivelFuncao+") !");
				frm.txtTotalAulas.focus();
				return false		
			}
		}
	}
	
	// VERIFICA SE DATA FINAL É MAIOR QUE INICIAL
	function verificaDatas(dtInicial, dtFinal){
		
		var dtini = dtInicial;
		var dtfim = dtFinal;
		
		if ((dtini == '') && (dtfim == '')) {
			alert('Complete os Campos.');
			campos.inicial.focus();
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
	
		
	}
	
	function gerarImpressao(TipoModSub, Status, AnoLetivo, codColaborador, origem){
		var frm = document.getElementById("frm");
		window.open("ColaboradorSubstitutoDeficit_rel.asp?TipoModSub="+TipoModSub+"&Tipo=F&Status="+Status+"&AnoLetivo="+AnoLetivo+"&CodColaborador="+codColaborador +"&origem="+ origem,"abreConsulta","top=5,left=5,height=600,width=800,menubar=no,toolbar=no,scrollbars=yes,status=yes");
 		return false	
	}	
</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 