<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_formataCPF.asp"-->
<!--#include file="../../includes/inc_replaceRequest.asp"-->
<!--#include file="../../js/Calendario/Calendario.asp"-->
<!--#include file="../menuModulos.asp"-->
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
	'RESPONSE.WRITE SQL
	cnn.execute sql

	sql = " UPDATE SRH_MODULACAO_DISCIPLINAR_DOCENTE  SET Status = 'I' where Ano_Letivo < YEAR(GETDATE()) AND Status = 'A' "
	cnn.execute sql

	' Inativa todas as substituicoes vencidas
	sql = " Update SRH_COLABORADOR_SUBSTITUTO "
	sql = sql & " set SITUACAO = 'I' "
	sql = sql & " where Cod_Grupo = " & Session("CodGrupo")
	sql = sql & " and convert(datetime,convert(varchar, DataFinal, 103),103) < convert(datetime, ' " & date & "',103) "
	sql = sql & " and SITUACAO = 'A' "
	cnn.execute sql

	strBotaoInativaModulacao		= ""
	strPaginaTitulo = "ModulacaoNovo_cad.asp"
	session("voltarPaginaParaColaboradorModulacao") = ""
	strExecutarSubmitCurso = "S"
	strExecutarSubmitPeriodo = "S"
	strExecutarSubmitTurno = "S"
	strReloadDisciplinaQuadro = "S"
	strEmpresaGrupo_submit = "S"
	strExecutarSubmitColaborador = "S"
	strSubmitFuncao = "S"
	strAnoAtual = "S"

	strPagina						= "ModulacaoNovo_cad.asp"
	intCodColaborador				= Trim(Request("txtCodFuncionario"))
	strcpf  						= Trim(Request.Form("txtcpf"))
	intCodFuncional  				= Trim(Request.Form("txtCodigoFuncional"))
	intCodFuncao					= Trim(Request("cmbFuncao"))
	intCodPeriodo					= Trim(Request("cmbPeriodo"))
	intCodCursoCombo				= Trim(Request("cmbCursoCombo"))
	strTipo_Funcao					= Trim(Request("txtHiddenTipo_Funcao"))
	strAno							= Trim(Request("cmbAno"))
	
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
	
	strSemestre 					= session("strSemestre")
	if Trim(Request.form("txtCodFuncionario")) = "" then
		intCodColaborador 					= Trim(Request("txtCodFuncionario"))
	else
		intCodColaborador 					= Trim(Request.form("txtCodFuncionario"))
	end if	
	strnome 						= Trim(Request.Form("txtNomeFuncionario"))

	intCodEmpresa 					= Session("CodEmpresa")
	intCodigo	 					= Trim(Request.Form("txtCodigo"))
	pesquisa						= Trim(Request("p"))
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

	
	intCodDisciplina 					= Trim(Request.Form("cmbDisciplina"))
	intTotalAulas 						= Trim(Request.Form("txtTotalAulas"))
	strSituacao							= Trim(Request.Form("cmbSituacao"))	
	if strSituacao = "0" or strSituacao = "" then strSituacao = "A"
	strTipoLancamento					= Trim(Request.Form("optTipoLancamento"))	
	strTipoModulacao					= Trim(Request.Form("optTipoModulacao"))	
	intCodNivel = request("cmbNivel")
	
	strTipoContratacao					= "C" 'Trim(Request("tipoContratacao"))	
	strPeriodoInicial					= Trim(Request.Form("txtPeriodoInicial"))	
	strPeriodoFinal						= Trim(Request.Form("txtPeriodoFinal"))	
	strDataInicio 						= Trim(Request.Form("txtDataInicio"))
	strDataFinal 						= Trim(Request.Form("txtDataFinal"))
	
	bolColaboradorEncontrato = "N"
	intCodFuncaoColaborador = ""
	intContratado = ""

	if session("NivelPermissao") = "A" then
		PorPeriodo = Trim(Request.Form("PorPeriodo"))
	else
		PorPeriodo = ""
		strAno			= year(date)
		strAnoLetivo	= year(date)

	end if
	
	if Trim(Request.Form("LocalizarMatricula")) = "S" and intCodFuncional <> "" then
		sql = "select f.cod_funcao, tu.Cod_Turno, f.Situacao_Disciplinar, c.codigo, c.nome, c.cpf, f.Tipo_Funcao, c.cod_nivel, c.codFuncao, c.situacao, c.codFuncional, tu.Desc_Turno as turno, c.cpf, n.Descricao as nivel, f.Desc_Funcao as funcao, ca.desc_categoria as categoria, isnull(n.total_aulas,0) as total_aulas_nivel, isnull(c.total_aulas,0) as total_aulas, c.cod_empresa"
		sql = sql & " from srh_colaborador c"
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
		'sql = sql & " And C.total_aulas  > 0"
		sql = sql & " And C.Situacao = 'A'"
		sql = sql & " and E.COD_GRUPO = " & session("codGrupo")
		if session("NivelPermissao") = "A" then
		else
			sql = sql & " and c.codLotacao = " & session("codEmpresa")
		end if
		'response.write sql 
		rs.open sql, cnn
		if rs.eof = false then

			Situacao_Disciplinar = rs("Situacao_Disciplinar")
			Cod_Turno 			 = rs("Cod_Turno")
			cod_funcao			 = rs("cod_funcao")
			
			intCodColaborador	= rs("Codigo")
			intCodEmp           = rs("Cod_Empresa")
			strnome 			= Trim(Rs("nome"))
			intCodFuncional		= Trim(Rs("CodFuncional"))
			strNivel			= Trim(Rs("nivel"))
			intCodNivel			= Trim(Rs("cod_nivel"))
			strFuncao			= Trim(Rs("funcao"))
			intcodFuncaoCadastro= Trim(Rs("codFuncao"))
			strTurnoContratado	= rs("turno")
			strCategoria		= Trim(Rs("categoria"))
			intContratado	 	= rs("total_aulas")
			intContratadoNivel	= rs("total_aulas_nivel")
			strTipo_Funcao		= rs("Tipo_Funcao")
			
			strDesabilitaProfessor = ""
			if strTipo_Funcao = "PROFESSOR" and Trim(Request.Form("optTipoModulacao"))="" then
				strTipoModulacao = "PROFESSOR"
			end if
			if strTipo_Funcao = "FUNCIONARIO" and Trim(Request.Form("optTipoModulacao"))="" then
				strTipoModulacao = "FUNCIONARIO"
				strDesabilitaProfessor = " disabled "
			end if
			if strTipo_Funcao <> "FUNCIONARIO" OR intContratadoNivel > 0 THEN
				strDesabilitaProfessor = ""
			end if	
			strCPF  			= formataCPFap(Trim(Rs("CPF")))
			strSituacaoColaborador = rs("situacao")
			intCodFuncaoColaborador		= rs("codFuncao")
			bolColaboradorEncontrato = "S"
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
			
		else
			%>
			<!--script>
				alert("Matrícula não Localizada, colaborador não contempla as regras para modulação. Verifique!")
				window.location='ModulacaoNovo_cad.asp';
			</script-->
			<%
			'response.end	
		end if
		rs.close
	end if
	
	if trim(intCodColaborador) <> "" and bolColaboradorEncontrato = "N" then
	
		sql = "select f.cod_funcao, tu.Cod_Turno, f.Situacao_Disciplinar, c.codigo, c.nome, f.Tipo_Funcao, c.codFuncional, c.cod_nivel, c.situacao, c.cpf, tu.Desc_Turno as turno, c.codFuncao, isnull(n.Descricao,'NAO_INFORMADO') as nivel, f.Desc_Funcao as funcao, ca.desc_categoria as categoria, isnull(n.total_aulas,0) as total_aulas_nivel,  isnull(c.total_aulas,0) as total_aulas, isnull(c.carga_horario_contratada,0) as carga_horario_contratada,c.cod_empresa"
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
				Situacao_Disciplinar = rs("Situacao_Disciplinar")
				Cod_Turno 			 = rs("Cod_Turno")
				cod_funcao			 = rs("cod_funcao")
				
				intCodColaborador	= rs("Codigo")
				intCodEmp           = rs("Cod_Empresa")
				strnome 			= Trim(Rs("nome"))
				intCodFuncional		= Trim(Rs("CodFuncional"))
				strNivel			= Trim(Rs("nivel"))
				
				if request("cmbNivel")<>"0" and request("cmbNivel")<>"" then	
				   if session("NivelPermissao") = "A" then
						intCodNivel = request("cmbNivel")
				   else
						intCodNivel			= Trim(Rs("cod_nivel"))
				   end if
				else
					intCodNivel			= Trim(Rs("cod_nivel"))
				end if
				
				strFuncao						= Trim(Rs("funcao"))
				intcodFuncaoCadastro			= Trim(Rs("codFuncao"))
				strCategoria					= Trim(Rs("categoria"))
				intContratado	 				= rs("total_aulas")
				intCargaHorariaContratada	 	= rs("carga_horario_contratada")
				intContratadoNivel				= rs("total_aulas_nivel")
				strCPF  						= formataCPFap(Trim(Rs("CPF")))
				strTipo_Funcao					= rs("Tipo_Funcao")
				strDesabilitaProfessor = ""
				
				if strTipo_Funcao = "PROFESSOR" and Trim(Request.Form("optTipoModulacao"))="" then
					strTipoModulacao = "PROFESSOR"
				end if
				if strTipo_Funcao = "FUNCIONARIO" and Trim(Request.Form("optTipoModulacao"))="" then
					strTipoModulacao = "FUNCIONARIO"
					strDesabilitaProfessor = " disabled "
				end if
				
				if strTipo_Funcao <> "FUNCIONARIO" OR intContratadoNivel > 0 THEN
					strDesabilitaProfessor = ""
				end if	

				intCodFuncaoColaborador		= rs("codFuncao")
				strSituacaoColaborador = rs("situacao")
				strTurnoContratado	= rs("turno")
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
			sql = "select f.cod_funcao, tu.Cod_Turno, f.Situacao_Disciplinar, c.codigo, c.nome, f.Tipo_Funcao, c.codFuncional, c.cod_nivel, c.situacao, c.cpf, tu.Desc_Turno as turno, c.codFuncao, isnull(n.Descricao,'NAO_INFORMADO') as nivel, f.Desc_Funcao as funcao, ca.desc_categoria as categoria, isnull(n.total_aulas,0) as total_aulas_nivel, c.total_aulas, isnull(c.carga_horario_contratada,0) as carga_horario_contratada, c.cod_empresa"
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
			if session("NivelPermissao") = "A" then
			else
				sql = sql & " and c.codLotacao = " & session("codEmpresa")
			end if
			rs.open sql, cnn
			if rs.eof = false then
				Situacao_Disciplinar = rs("Situacao_Disciplinar")
				Cod_Turno 			 = rs("Cod_Turno")
				cod_funcao			 = rs("cod_funcao")

				intCodColaborador	= rs("Codigo")
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
				if strTipo_Funcao = "PROFESSOR" and Trim(Request.Form("optTipoModulacao"))="" then
					strTipoModulacao = "PROFESSOR"
				end if
				if strTipo_Funcao = "FUNCIONARIO" and Trim(Request.Form("optTipoModulacao"))="" then
					strTipoModulacao = "FUNCIONARIO"
					strDesabilitaProfessor = " disabled "
				end if
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
	strNomeFuncao = ""
	
	if trim(intCodigo) <> "" then
	
		sql = "SELECT m.Codigo, Cod_Colaborador, m.Cod_empresa, m.Cod_Curso, M.Cod_periodo, C.Descricao AS Curso, P.Descricao AS PERIODO, F.Desc_Funcao, M.cod_funcao, Cod_turno, cod_turno_opcional, "
		sql = sql & "Cod_Disciplina, Total_Aulas, tipo_contratacao, m.Situacao_disciplinar, Ano_letivo, Semestre, status, "
		sql = sql & "periodo_inicial, periodo_final, DataInicial, DataFinal, e.razaosocial"
		sql = sql & " FROM SRH_MODULACAO_DISCIPLINAR_DOCENTE m"
		sql = sql & " inner join seg_empresa e on e.codigo = m.cod_empresa"
		sql = sql & " inner join SRH_FUNCAOCOLABORADOR F on F.Cod_Funcao = m.cod_funcao"
		sql = sql & " left  join SCA_PERIODO P on P.Cod_periodo = m.Cod_periodo"
		sql = sql & " left  join SCA_CURSO C on C.COD_CURSO=P.COD_CURSO"
		sql = sql & " where m.codigo = " & intCodigo	
		rs.open sql, cnn
		if rs.eof = false then
			intCodPeriodoSelecionadoClick	= rs("Cod_periodo")
			strBotaoInativaModulacao		= "S"
			strDesabilitaBotaoInativar		= ""
			intCodigo	 					= rs("Codigo")
			strEmpresaGrupo					= rs("razaosocial")
			if Trim(Request.Form("cmbEmpresaGrupo")) = "0" or Trim(Request.Form("cmbEmpresaGrupo")) = "" or pesquisa="s" then
				intCodEmpresa 					= rs("Cod_empresa")
				intCodEmpresaGrupo				= rs("Cod_empresa")
			end if
			intCodColaborador				= rs("Cod_Colaborador")
			if Trim(Request.Form("cmbCursoCombo")) = "0" or Trim(Request.Form("cmbCursoCombo")) = "" or pesquisa="s" then
				intCodCurso 					= rs("Cod_Curso")
				intCodCursoCombo				= rs("Cod_Curso")
			end if
			
			strNomeFuncao					= Trim(Rs("Desc_Funcao"))
			if Trim(Request.Form("cmbFuncao")) = "0" or Trim(Request.Form("cmbFuncao")) = "" or pesquisa="s" then
				intCodFuncao					= rs("Cod_Funcao")
				intcodFuncaoCadastro			= Trim(Rs("Cod_Funcao"))
			end if
			if Trim(Request("cmbPeriodo")) = "0" or Trim(Request("cmbPeriodo")) = "" or pesquisa="s" then
				intCodPeriodo 					= rs("Cod_periodo")
			end if
			
			strNomeCurso 					= Trim(Rs("CURSO"))
			if Trim(Request("cmbCursoCombo")) = "0" or Trim(Request("cmbCursoCombo")) = "" or pesquisa="s" then
				intCodCursoCombo				= rs("Cod_Curso")
			end if
			
			if Trim(Request("cmbPeriodo")) = "0" or Trim(Request("cmbPeriodo")) = "" or pesquisa="s" then
				intCodPeriodo 					= rs("Cod_periodo")
			end if
			
			if Trim(Request.Form("cmbTurno")) = "0" or Trim(Request.Form("cmbTurno")) = "" or pesquisa="s" then
				intCodTurnoColaborador 			= rs("Cod_turno")
			end if
			strTipoLancamento 				= rs("Situacao_disciplinar")
			if Trim(Request.Form("cmbDisciplina")) = "0" or Trim(Request.Form("cmbDisciplina")) = "" then
				intCodDisciplina				= rs("Cod_Disciplina")
			end if
			intTotalAulas					= rs("Total_Aulas")
			strSituacao						= trim(rs("status"))
			strTipoContratacao				= trim(rs("tipo_contratacao"))
			if strTipoContratacao = "A" then PorPeriodo = "S"
			strPeriodoInicial				= formataDataAP(rs("periodo_inicial"))
			strPeriodoFinal					= formataDataAP(rs("periodo_final"))
			strDataInicio					= formataDataAP(rs("DataInicial"))
			strDataFinal					= formataDataAP(rs("DataFinal"))
			intTotalAulasAlteracao			= rs("Total_Aulas")
			if strSituacao = "I" then
				strDesabilitaBotaoInativar = "disabled" 'Desabilita o botão Excluir
			end if
			
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			if session("NivelPermissao") = "A" then
				strDesabilitaAlterar 	= "" 'Habilita  o botão Alterar
			else
				strDesabilitaAlterar 	= "disabled" 'Habilita  o botão Alterar
			end if
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
		
		else
			strDesabilitaBotaoInativar= "disabled"
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir

		end if 
		rs.close
		
		'response.write "<br>intCodigo:" & intCodigo
		'response.write "<br>cmbPeriodo:" & Trim(Request.Form("cmbPeriodo"))
		'response.write "<br>intCodPeriodoSelecionadoClick:" & intCodPeriodoSelecionadoClick				
		
		if intCodigo <> "" and Trim(Request.Form("cmbPeriodo"))<> intCodPeriodoSelecionadoClick and pesquisa="" then
			sql = "SELECT Total_Aulas"
			sql = sql & " FROM SRH_MODULACAO_DISCIPLINAR_DOCENTE m"
			sql = sql & " inner join seg_empresa e on e.codigo = m.cod_empresa"
			sql = sql & " inner join SRH_FUNCAOCOLABORADOR F on F.Cod_Funcao = m.cod_funcao"
			sql = sql & " left  join SCA_PERIODO P on P.Cod_periodo = m.Cod_periodo"
			sql = sql & " left  join SCA_CURSO C on C.COD_CURSO=P.COD_CURSO"
			sql = sql & " where m.cod_colaborador = " & intCodColaborador	
			sql = sql & " and m.Cod_periodo = " & Trim(Request.Form("cmbPeriodo"))	
			sql = sql & " and m.ano_letivo = " & strAno
			sql = sql & " and m.cod_empresa = " & intCodEmpresa
			rs.open sql, cnn
			if rs.eof = false then
				intTotalAulasAlteracao			= 0
			end if
			rs.close
		end if
	end if 

	sql = " SELECT CodTipoEmpresa "  
	sql = sql & " FROM SEG_EMPRESA " 
	sql = sql & " Where codigo = " & intCodEmpresaGrupo
	rs.open sql, cnn
	if rs.eof = false then
		intCodTipoEmpresa 	= TRIM(rs("CodTipoEmpresa"))
	end if
	rs.close	

	'regras
	IF trim(strSituacaoColaborador) = "I" and intCodColaborador<>"" then
		%>
		<script>
			alert("O colaborador inativo, verifique!");
			window.location="ModulacaoNovo_cad.asp?tipoContratacao=C";
		</script>
		<%
		response.end
		
	end if
	IF strNivel = "NAO_INFORMADO" and intCodColaborador<>"" then
		%>
		<script>
			alert("O colaborador informado não está vinculado a um nível.");
			window.location="ModulacaoNovo_cad.asp?tipoContratacao=C";
		</script>
		<%
		response.end
	end if
	if strTipo_Funcao = "FUNCIONARIO" then
		intContratado = intCargaHorariaContratada
	end if
	if intContratado = "" then intContratado = 0
	if intContratadoNivel = "" then intContratadoNivel = 0
	
	if  Trim(Request.Form("LocalizarMatricula")) <> "S"  then
		IF intContratadoNivel <= 0 and intCodColaborador <> ""  then
			%>
			<script>
				alert("Carga horária não informado para o Colaborador.");
				window.location="ModulacaoNovo_cad.asp?tipoContratacao=C";
			</script>
			<%
			response.end
		end if
	end if
	
	
	intModulado = "0"
	intPorPeriodo = "0"
	if intCodColaborador <> "" then
		sql = "select " 
		if session("codGrupo") = "7" then
			sql = sql & " isnull(sum(CASE WHEN MD.cod_turno = 4 and situacao_disciplinar = 'I' then MD.Total_Aulas * 42 " 
		else
			sql = sql & " isnull(sum(CASE WHEN MD.cod_turno = 4 and situacao_disciplinar = 'I' then MD.Total_Aulas * 42 " 	
		end if
		sql = sql & " 				WHEN MD.cod_turno <> 4 and situacao_disciplinar = 'I' then MD.Total_Aulas * 21 " 
		sql = sql & " 			else MD.Total_Aulas end),0) as modulado, " 
		sql = sql & " MD.situacao_disciplinar, tipo_contratacao " 
		sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE MD "
		sql = sql & " INNER JOIN SEG_EMPRESA E ON E.CODIGO = MD.Cod_empresa " 
		sql = sql & " where Cod_Colaborador = " & intCodColaborador
		sql = sql & " and status = 'A'"
		'sql = sql & " and tipo_contratacao <> 'A'"
		sql = sql & " and cod_turno is not null "
		sql = sql & " and isnull(Cod_Substituicao,'0') = 0 "
		sql = sql & " and ano_letivo = " & strAnoLetivo
		sql = sql & " and tipo_contratacao is not null group by tipo_contratacao, situacao_disciplinar"
		rs.open sql, cnn
		if rs.eof = false then
			while not rs.eof
				if rs("tipo_contratacao") = "A" then
					intPorPeriodo = intPorPeriodo + rs("modulado")
				else
					intModulado = intModulado + rs("modulado")
				end if
				rs.movenext
			wend
		end if
		rs.close
	end if
	if intCodFuncao = "" then intCodFuncao = "0"
	strSomenteProfessor = ""
	if strTipoModulacao = "FUNCIONARIO" then strSomenteProfessor = "style='display:none'"
	strMostraPeriodo = "style='display:none'"
	strMostraContrato = "style='display:none'"
	
	if PorPeriodo = "S" then strMostraPeriodo = "style='display:blobk'"
	if strTipoContratacao = "A" then strMostraPeriodo = "style='display:blobk'"
	if PorPeriodo = "" then strMostraContrato = "style='display:blobk'"
	
	if intContratadoNivel = "" then intContratadoNivel = 0
	if session("codGrupo") = "7" then
	
		if cInt(intContratadoNivel) = 14 then
			intContratadoMaximo = 20
		elseif cInt(intContratadoNivel) = 21 then
			intContratadoMaximo = 27
		elseif cInt(intContratadoNivel) = 28 then
			intContratadoMaximo = 42
		elseif cInt(intContratadoNivel) >= 42 then
			intContratadoMaximo = 42
		end if
	else
	
		if cInt(intContratadoNivel) = 14 then
			intContratadoMaximo = 20
		elseif cInt(intContratadoNivel) = 21 then
			intContratadoMaximo = 27
		elseif cInt(intContratadoNivel) = 28 then
			intContratadoMaximo = 42
		elseif cInt(intContratadoNivel) >= 42 then
			intContratadoMaximo = 42
		end if
	end if

	intSaldoContratado = 0
	if intContratado<>"" and intModulado<>"" then
		intSaldoContratado = intContratadoMaximo - intModulado - intPorPeriodo
	end if	
	if strTipoModulacao = "PROFESSOR" and intCodTurnoColaborador<>"0" and strDesabilitaExcluir<>"" and intCodCursoCombo<>"0" and intCodTurnoColaborador<>"0" then
		'validar no interdisciplinar:
		'só pode lançar 1 por turno não importa a unidade
		sql = "select isnull(count(*),0) as qtde"
		sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE"
		sql = sql & " where cod_colaborador = "&intCodColaborador
		sql = sql & " and status = 'A'"
		sql = sql & " and ano_letivo = "&strAnoLetivo
		sql = sql & " and semestre = "&intSemestre
		sql = sql & " and situacao_disciplinar = 'I'"
		sql = sql & " and cod_turno =" & intCodTurnoColaborador
		rs.open sql, cnn
		if rs.eof = false then
			IF rs("qtde") > 0 then
				%>
				<script>
					alert("Professor já modulado nesse turno.");
				</script>
				<%

				strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
				strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
				strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
			end if
		end if
		rs.close
	end if
	
	if intCodTurnoColaborador <> "" then 	
		strChecaTurnoIntegral = ""
		sql = " select UPPER(SUBSTRING(DESC_TURNO,1,1)) AS SIGLA "
		sql = sql & " from srh_turno "
		sql = sql & " WHERE Cod_Turno = "& intCodTurnoColaborador
		rs.open sql, cnn
		if rs.eof = false then
			strChecaTurnoIntegral = rs("SIGLA")
		end if
		rs.close
		strChecaTurnoII = trim(strChecaTurnoIntegral) & trim(strChecaTurnoIntegralOpcional)
	end if
	'Fim Cheque turno integra
	if intCodColaborador<>"" then
		'ATUALIZA PONTO - FAIXA 
		if session("codGrupo") = "7" then

			sql = "EXECUTE SP_APO_Atualiza_Faixa_Horario " & strAnoLetivo & "," & session("CodGrupo") & "," & intCodColaborador
			'cnn.execute sql
			
			'ATUALIZA PONTO - LOTACAO
			sql = "EXECUTE SP_APO_Atualiza_Lotacao_Ponto " & strAnoLetivo & "," & session("CodGrupo") & "," & intCodColaborador
			'cnn.execute sql
		
		end if
	end if

%>
	<form method="post" name="frm" id="frm" action="ModulacaoNovo_cad.asp">	
	<input name="txtCodigo" id="txtCodigo" value="<%=intCodigo%>" type="hidden" >
    <input name="tipoContratacao" id="tipoContratacao" value="<%=strTipoContratacao%>" type="hidden" >
    <input name="txtCarregado" id="txtCarregado" value="<%=strCarregado%>" type="hidden" >
    <input name="txtHiddenTipo_Funcao" id="txtHiddenTipo_Funcao" value="<%=strTipo_Funcao%>" type="hidden" >
    <input value="<%=strChecaTurnoII%>" id="txtChecaTurnoII" name="txtChecaTurnoII" type="hidden">

    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Modulação de Professores</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            	<div class="panel-body">                                                        
                    
                    <div class="form-group">
					
                    <table width="96%" border="0" cellpadding="0" cellspacing="0" >
        <tr valign="top">
          <td align="left" >
            <!-- inicio tabela de cadastro de funcionario -->
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td colspan="3" class="TextoForm" align="center"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
                </tr>
              <tr>
                <td colspan="3" class="TextoForm">&nbsp;</td>
                </tr>
              <tr> 
                <td height="24" colspan="3" bgcolor="#CCCCCC" class="TextoForm"><strong>Dados do Colaborador </strong></td>
                </tr>
              
              <tr>
                <td height="33" class="TextoForm"><strong>CPF:</strong></td>
                <td width="591" height="33" class="TextoForm"><input name="txtcpf" type="text" class="text" id="txtcpf" size="15" maxlength="70" value="<%=strCPF%>" onkeypress="return formataCampo(this,5,14)" onblur="return validaCPFColaborador(this)"></td>
                <td width="507" rowspan="3" class="TextoForm">
                <table width="85%" border="0" cellspacing="0" cellpadding="0" class="tabela">
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
                    <td class="celula"><%'=strNivel%>
                      <!--#include file="../includes/inc_cmbNivel.asp" --></td>
                  </tr>
                  <tr>
                    <td class="celula">Turno</td>
                    <td class="celula"><%=strTurnoContratado%>&nbsp;</td>
                  </tr>
                  <tr>
                    <td width="22%" class="celula">Contratado</td>
                    <td width="78%" class="celula"><%=intContratadoNivel%><input name="txtTotalContratual" id="txtTotalContratual" value="<%=intContratadoNivel%>" type="hidden" >&nbsp;</td>
                  </tr>
				  <tr>
                    <td width="22%" class="celula">Por período</td>
                    <td width="78%" class="celula"><%=intPorPeriodo%><input name="txtTotalContratualPeriodo" id="txtTotalContratualPeriodo" value="<%=intPorPeriodo%>" type="hidden" >&nbsp;</td>
                  </tr>
                  <tr>
                    <td class="celula">M&aacute;ximo</td>
                    <td class="celula"><%=intContratadoMaximo%>&nbsp;</td>
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
                  <%
					if session("NivelPermissao") = "A" then
					%>
                    Por Per&iacute;odo
                    <input type="checkbox" name="PorPeriodo" <%if PorPeriodo="S" or strTipoContratacao = "A" then response.Write("checked") %> value="S" onClick='submit()'>
					<%
					else
					%>
					<input type="hidden" name="PorPeriodo" value="">
					<%
                  	end if
					%>
					<input type="button" name="cmdAbonoFaltas" style="cursor:hand"   value="Substituição" class="btn-u float-shadow" onclick="return  ChamarSubstituicao('<%=intCodColaborador%>')" />
					</td>
					
                </tr>
              <tr> 
                <td width="183" height="33" class="TextoForm">Nome:</td>
                <td height="33" class="TextoForm"><input name="txtCodFuncionario" value="<%=intCodColaborador%>" type="hidden" id="txtCodFuncionario" >
                  <input name="txtCodEmpresa" value="<%=intCodEmp%>" type="hidden" id="txtCodEmpresa" >
                  <input name="txtcodLotacaoAnterior" value="<%=intcodLotacaoAnterior%>" type="hidden" id="txtcodLotacaoAnterior" >
                  <input name="txtNomeFuncionario" type="text" class="text" id="txtNomeFuncionario" size="50" maxlength="70" value="<%=strNome%>">
                  <button class="btn btn-success" onclick="return abreConsultaColaborador('Colaborador_con.asp?PaginaOrigem=ModulacaoNovo_cad&Tipo=P')" type="button"><i class="fa fa-search"></i></button>
                  
                  <% if session("NivelPermissao") = "A" then %>
                  	<button class="btn btn-success" onclick="return acessarColaborador('Colaborador_cad.asp?txtCodFuncionario=<%=intCodColaborador%>&paginaVoltar=ModulacaoNovo_cad.asp?txtCodFuncionario=<%=intCodColaborador%>')" type="button"><i class="icon-users"></i></button>
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
                <input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" value="<%=strAnoLetivo%>" size="5" maxlength="5" onkeypress="return formataCampo(this,2,10)" onchange="submit()">
                </span></td>
                <td valign="top" align="left" ></td>
              </tr>
              <tr>
                <td width="183" height="24" class="texto2">Semestre: </td>
                <td height="24" ><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
                <td valign="top" align="left" >                </td>
            </tr>
              <tr>
                <td height="24" class="texto2">Modula&ccedil;&atilde;o:</td>
                <td height="24" ><span class="texto2">
                 <%if strTipo_Funcao <> "FUNCIONARIO" OR intContratadoNivel > 0 THEN%>
                 <input <%if strTipoModulacao = "PROFESSOR" then response.Write("checked")%>  type="radio" name="optTipoModulacao" id="optTipoModulacao" <%=strDesabilitaProfessor%> value="PROFESSOR" onclick="submit()"> 
                 Professor 
                &nbsp;&nbsp;&nbsp;&nbsp;
                <%END IF%>
                <input type="radio" <%if strTipoModulacao = "FUNCIONARIO" then response.Write("checked")%> name="optTipoModulacao" id="optTipoModulacao" value="FUNCIONARIO"  onClick="submit()"> 
                Funcion&aacute;rio
</span></td>
                <td valign="top" align="left" ></td>
              </tr>
              <tr>
                <td height="24" class="texto">Fun&ccedil;&atilde;o:</td>
                <td height="24"  class="texto"><!--#include file="../includes/inc_cmdFuncaoModulacaoNova.asp" --></td>
                <td align="left" valign="top" ></td>
              </tr>
              <tr <%=strMostraPeriodo%> >
              <td height="24" class="texto">Per&iacute;odo:</td>
              <td height="24"  class="texto"><span class="TextoForm">
                <input name="txtPeriodoInicial" type="text" class="text" id="txtPeriodoInicial" onblur="return validaData(this)" onkeypress="return formataCampo(this, 3, 10)" size="11" value="<%=strPeriodoInicial%>" style="cursor:hand" title="Click aqui para visualizar o calend&aacute;rio">
                </span>a <span class="TextoForm">
                  <input name="txtPeriodoFinal" type="text" class="text" id="txtPeriodoFinal" onblur="return validaData(this)" onkeypress="return formataCampo(this, 3, 10)" size="11" value="<%=strPeriodoFinal%>" style="cursor:hand" title="Click aqui para visualizar o calend&aacute;rio" onchange="return verificaDatas(frm.txtPeriodoInicial.value, frm.txtPeriodoFinal.value)">
                  </span></td>
              <td align="left" valign="top" >              </td>
            </tr>
            <tr>
              <td height="24" class="texto">Unidade Escolar:</td>
              <td height="24"  class="texto"><!--#include file="../includes/inc_cmbEmpresaGrupoModulacao.asp"--></td>
              <td rowspan="11" align="left" valign="top" >
                 
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
             <tr <%=strSomenteProfessor%>>
              <td height="24" class="texto">Tipo:</td>
              <td height="24"  class="texto"><span class="texto2">
                <input <%if strTipoLancamento = "D" then response.Write("checked")%>  type="radio" name="optTipoLancamento" id="optTipoLancamento" value="D" onclick="submit()">
                Disciplinar 
                &nbsp;&nbsp;&nbsp;&nbsp;
                <input type="radio" <%if strTipoLancamento = "I" then response.Write("checked")%> name="optTipoLancamento" id="optTipoLancamento" value="I"  onClick="submit()">
                Interdisciplinar</span></td>
              </tr>
            <tr>
              <td height="24" class="texto">Turno:</td>
              <td height="24"  class="texto"><!--#include file="../includes/inc_cmdTurnoModulacaoNova.asp" --></td>
            </tr>
            <tr>
              <td height="31" class="texto">Curso:</td>
              <td height="31"  class="texto"><!--#include file="../includes/inc_cmdCursoModulacao.asp" --></td>
            </tr>
            
            <%
			IF strTipo_Funcao = "FUNCIONARIO" AND strTipo_FuncaoSelecionadaCombo<>"" and intContratadoNivel <= 0 then
				if strTipo_Funcao <> strTipo_FuncaoSelecionadaCombo then
					%>
					<script>
						alert("Não é permitido modular um administrativo como docente.");
						window.location="ModulacaoNovo_cad.asp?tipoContratacao=C";
					</script>
					<%
					response.end
				end if
			END IF
			
			%>
            
            <tr>
                <td height="32" class="TextoForm">Per&iacute;odo:</td>
                <td class="TextoForm"><span class="texto">
                  <!--#include file="../includes/inc_cmdPeriodoModulacao.asp" -->
                </span></td>
             </tr>
           <% if strTipoLancamento = "D" then %>
                 <tr>
                   <td height="32" class="TextoForm">Disciplinas:</td>
                   <td class="TextoForm"><span class="texto">
                     <!--#include file="../includes/inc_cmdDisciplinaModulacao.asp" -->
                   </span></td>
                   </tr>
                 <tr>
				<%
				if intCodEmpresaGrupo<>"0" and intCodEmpresaGrupo<>"" then
					''
					'''' Total de Aulas Oferecidas
					''
					strVagasFuncao = "0"
					sql = " select distinct isnull(SUM(  GCDT.Total_Vaga_Funcao),'0') as VagasFuncao "

					'unidades normais
					if intCodTipoEmpresa <> "4" then
						SQL = SQL & " FROM SCA_GRADECURRICULARDISCIPLINA GCD " 								
						SQL = SQL & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA_TURNO GCDT ON GCDT.Cod_GradeCurricularDisciplina = GCD.Cod_GradeCurricularDisciplina "
						SQL = SQL & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = GCD.Cod_GradeCurricular AND GC.Situacao = 'A' "
						SQL = SQL & " INNER JOIN SCA_TURMA T ON T.Cod_GradeCurricular = GC.Cod_GradeCurricular AND T.Situacao = 'A' "
						SQL = SQL & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.COD_TURNO AND TU.Cod_empresa = T.Cod_Empresa "
						SQL = SQL & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) and TRH.Cod_Grupo = " & Session("CodGrupo")  
						SQL = SQL & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = GCDT.Cod_Funcao "
						SQL = SQL & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo "
						SQL = SQL & " INNER JOIN SCA_CURSO C ON C.Cod_curso = P.Cod_Curso "
						SQL = SQL & " INNER JOIN SEG_EMPRESA E ON E.CODIGO = GC.Cod_Empresa "
						SQL = SQL & " LEFT JOIN SEG_GRUPO GR ON GR.CODIGO = E.COD_GRUPO "
					else
						SQL = SQL & " FROM SCA_GRADECURRICULARDISCIPLINA GCD " 
						SQL = SQL & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA_TURNO GCDT ON GCDT.Cod_GradeCurricularDisciplina = GCD.Cod_GradeCurricularDisciplina "
						SQL = SQL & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = GCD.Cod_GradeCurricular AND GC.Situacao = 'A'  "
						SQL = SQL & " INNER JOIN SCA_TURMA T ON T.Cod_GradeCurricular = GC.Cod_GradeCurricular AND T.Situacao = 'A' "
						SQL = SQL & " INNER JOIN SRH_TURNO TRH ON TRH.Cod_Turno = GCDT.Cod_Turnofuncao and TRH.Cod_Grupo = " & Session("CodGrupo")  
						SQL = SQL & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = GCDT.Cod_Funcao " 
						sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo "
						sql = sql & " INNER JOIN SCA_CURSO C ON C.Cod_curso = P.Cod_Curso " 
						sql = sql & " INNER JOIN SEG_EMPRESA E ON E.CODIGO = GC.Cod_Empresa " 
						sql = sql & " LEFT JOIN  SEG_GRUPO GR ON GR.CODIGO = E.COD_GRUPO "
					end if
					
					sql = sql & " WHERE ISNULL(GCDT.COD_FUNCAO,'0')<>'0' " 
					SQL = SQL & " AND T.Situacao_modulacao='A'"
					SQL = SQL & " AND FC.Cod_grupo = " & Session("CodGrupo") 
					SQL = SQL & " AND T.AnoLetivo = " & strAnoLetivo
					SQL = SQL & " AND T.Cod_Semestre = " & intSemestre 
					if trim(strTipoModulacao) <> "" then 
						sql = sql & " AND FC.Tipo_Funcao = '" & trim(strTipoModulacao) & "'"
					end if
					if intCodFuncao <> "0" then 
						sql = sql & " AND FC.Cod_Funcao = " & intCodFuncao 
					end if
					if intCodEmpresaGrupo <> "0" then 
						sql = sql & " AND T.Cod_Empresa = " & intCodEmpresaGrupo 
					end if
					if intCodTurnoColaborador <> "0" then 
						sql = sql & " AND TRH.Cod_Turno  = " & intCodTurnoColaborador 
						sql = sql & " AND GCDT.Cod_TurnoFuncao = " & intCodTurnoColaborador 
					end if
					if intCodCursoCombo <> "0" and intCodCursoCombo <> "" then 
						sql = sql & " AND C.Cod_curso = " & intCodCursoCombo 
					end if
					if intCodPeriodo <> "0" and intCodPeriodo <> "" then 
						sql = sql & " AND P.Cod_Periodo  = " & intCodPeriodo 
					end if
					if intCodDisciplina <> "0" AND intCodDisciplina <> "" then 
						sql = sql & " AND GCD.Cod_Disciplina  = " & intCodDisciplina 
					end if
							'response.write sql & "<hr>"					
					
				    rs.open sql, cnn
					if rs.eof = false then
						strVagasFuncao = rs("VagasFuncao")
					end if
					rs.close  
					'''' fim  
					''
					'''' Total de Aulas Modulada
					''
					saldo = "0"
					strTotalModulado = "0"
					if intCodEmpresaGrupo <> "0" and intCodDisciplina <> "0" and intCodDisciplina <> "" then 
						sql = " select isnull(SUM(MD.Total_Aulas),'0') as Total_Modulado from SRH_MODULACAO_DISCIPLINAR_DOCENTE MD "
						sql = sql & " WHERE MD.Cod_Empresa = " & intCodEmpresaGrupo
						sql = sql & " and MD.ano_letivo = " & strAnoLetivo
						sql = sql & " and MD.semestre = " & intSemestre
						sql = sql & " and MD.status = 'A'"
						sql = sql & " and MD.Cod_Substituicao is null"						
						if intCodFuncao <> "0" then 
							sql = sql & " AND MD.Cod_Funcao = " & intCodFuncao 
						end if
						if intCodTurnoColaborador <> "0" then 
							sql = sql & " AND MD.Cod_Turno  = " & intCodTurnoColaborador 
						end if
						if intCodCursoCombo <> "0" then 
							sql = sql & " AND MD.Cod_curso = " & intCodCursoCombo 
						end if
						if intCodPeriodo <> "0" then 
							sql = sql & " AND MD.Cod_Periodo  = " & intCodPeriodo 
						end if
						if intCodDisciplina <> "0" then 
							sql = sql & " AND MD.Cod_Disciplina  = " & intCodDisciplina 
						end if
							'response.write sql & "<hr>"					
						
						rs.open sql, cnn
						if rs.eof = false then
							strTotalModulado = rs("Total_Modulado")
						end if
						rs.close
					end if
				end if
			else
				if intCodEmpresaGrupo<>"0" and intCodEmpresaGrupo<>"" then
					''
					'''' Total de Aulas Oferecidas
					''
					strVagasFuncao = "0"
					SQL = " select  isnull(SUM(TMF.Total_Vaga_Funcao),'0') as VagasFuncao "
					SQL = SQL & " from SRH_TURMA_MODULACAO_FUNCAO TMF " 
					SQL = SQL & " INNER JOIN SCA_TURMA T ON T.Cod_Turma = TMF.Cod_Turma AND T.Situacao = 'A' "
					SQL = SQL & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular AND GC.Situacao = 'A' " 
					SQL = SQL & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GC.Cod_Periodo " 
					SQL = SQL & " INNER JOIN SCA_CURSO C ON C.Cod_curso = P.Cod_Curso " 
					SQL = SQL & " INNER JOIN SRH_TURNO TRH ON TRH.Cod_Turno = TMF.cod_TurnoFuncao and TRH.Cod_Grupo = " & Session("CodGrupo")  
					SQL = SQL & " INNER JOIN SRH_FUNCAOCOLABORADOR FC ON FC.Cod_Funcao = TMF.Cod_Funcao "
					SQL = SQL & " INNER JOIN SEG_EMPRESA E ON E.CODIGO = T.Cod_Empresa " 
					SQL = SQL & " LEFT JOIN  SEG_GRUPO GR ON GR.CODIGO = E.COD_GRUPO "
					SQL = SQL & " WHERE FC.Cod_grupo = " & Session("CodGrupo")
					SQL = SQL & " AND T.Situacao_modulacao='A'"
					SQL = SQL & " AND T.AnoLetivo = " & strAnoLetivo
					SQL = SQL & " AND T.Cod_Semestre = " & intSemestre 
					if trim(strTipoModulacao) <> "" then 
						sql = sql & " AND FC.Tipo_Funcao = '" & trim(strTipoModulacao) & "'"
					end if
					if intCodFuncao <> "0" then 
						sql = sql & " AND FC.Cod_Funcao = " & intCodFuncao 
					end if
					if intCodEmpresaGrupo <> "0" then 
						sql = sql & " AND T.Cod_Empresa = " & intCodEmpresaGrupo 
					end if
					if intCodTurnoColaborador <> "0" then 
						sql = sql & " AND TRH.Cod_Turno  = " & intCodTurnoColaborador 
					end if
					if intCodCursoCombo <> "0" and intCodCursoCombo <> "" then  
						sql = sql & " AND C.Cod_curso = " & intCodCursoCombo 
					end if
					rs.open sql, cnn
					if rs.eof = false then
						strVagasFuncao = rs("VagasFuncao")
					end if
					rs.close 
					'''' fim  
					''
					'''' Total de Aulas Modulada
					''
					saldo = "0"
					strTotalModulado = "0"
					if intCodEmpresaGrupo <> "0" then 
						sql = " select isnull(SUM(MD.Total_Aulas),'0') as Total_Modulado from SRH_MODULACAO_DISCIPLINAR_DOCENTE MD "
						sql = sql & " WHERE MD.Cod_Empresa = " & intCodEmpresaGrupo
						sql = sql & " and MD.ano_letivo = "&strAnoLetivo
						sql = sql & " and MD.semestre = "&intSemestre
						sql = sql & " AND isnull(MD.Cod_Disciplina,'0')  = 0 " 
						sql = sql & " and MD.status = 'A' "
						sql = sql & " and MD.Cod_Substituicao is null"
						if intCodFuncao <> "0" then 
							sql = sql & " AND MD.Cod_Funcao = " & intCodFuncao 
						end if
						if intCodTurnoColaborador <> "0" then 
							sql = sql & " AND MD.Cod_Turno  = " & intCodTurnoColaborador 
						end if
						if intCodCursoCombo <> "0" then 
							sql = sql & " AND MD.Cod_curso = " & intCodCursoCombo 
						end if
						if intCodPeriodo <> "0" then 
							sql = sql & " AND MD.Cod_Periodo  = " & intCodPeriodo 
						end if
						 rs.open sql, cnn
						if rs.eof = false then
							strTotalModulado = rs("Total_Modulado")
						end if
						rs.close
					end if
                end if
			end if
			
			saldo = strVagasFuncao - strTotalModulado
			%>
                <td height="25" class="TextoForm">&nbsp;</td>
                <td class="TextoForm">
                  
                  <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#C0C0C0">
                    <tr>
                      <td width="7" class="texto">&nbsp;</td>
                      <td width="244" height="22" class="texto">Vagas - Existente:&nbsp;<%=strVagasFuncao%></td>
                      <td width="193" class="texto">Modulada: <%=strTotalModulado%></td>
                      <td width="173" class="texto">Disponível: <%=saldo+intTotalAulasAlteracao%><input name="txtSaldoDisponivelFuncao" id="txtSaldoDisponivelFuncao" value="<%=saldo+intTotalAulasAlteracao%>" type="hidden" ></td>
                      </tr>
                    </table>                </td>
                </tr>
                 <tr>
                   <td height="25" class="TextoForm"><span class="texto">Aulas (Entradas):</span></td>
                   <td class="TextoForm"><% 

				if strChecaTurnoIntegral = "I" and strChecaTurnoIntegralOpcional = "I" and intCodTipoEmpresa = "4" then 
					intTotalAulas = 1
					strOCulta = "hidden"
					%>
					1
					<%
				elseif strChecaTurnoIntegral = "I" and strChecaTurnoIntegralOpcional = "I"  and intCodTipoEmpresa = "1" then 
					intTotalAulas = 2
					strOCulta = "hidden"
					%>
					1
					<%
				elseif strTipoLancamento = "I" then 
					intTotalAulas = 1
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
                   <td height="25" class="TextoForm">Data Inicio:</td>
                   <td class="TextoForm"><input name="txtDataInicio" type="text" class="text" id="txtDataInicio" onblur="return validaData(this)" onkeypress="return formataCampo(this, 3, 10)" size="11" value="<%=strDataInicio%>" style="cursor:hand" title="Click aqui para visualizar o calend&aacute;rio">
a
  <input name="txtDataFinal" type="text" class="text" id="txtDataFinal" onblur="return validaData(this)" onkeypress="return formataCampo(this, 3, 10)" size="11" value="<%=strDataFinal%>" style="cursor:hand" title="Click aqui para visualizar o calend&aacute;rio" ></td>
                 </tr>
                <tr <%=strMostraContrato%>>
                <td height="25" class="TextoForm">Modula&ccedil;&atilde;o Anos Anteriores:</td>
                <td class="TextoForm"><span class="texto">
                  <!--#include file="../includes/inc_cmbAno.asp" -->
                </span></td>
                </tr>

            <% end if %>    
              </table>
            <!-- fim tabela de cadastro de funcionario -->		  </td>
        </tr>
        <tr valign="top">
          <td height="24" align="center" class="tituloPrincipal style2"></td>
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
		  
			sql = "select dd.tipoModulacao, dd.Codigo, dd.Situacao_disciplinar, p.Descricao as periodo, t.desc_turno as turno, "
			sql = sql & " dd.Total_Aulas, dd.tipo_contratacao, dd.periodo_inicial, case	when ss.DataFinal is not null then ss.DataFinal else dd.periodo_final end as periodo_final, dd.status, "
			sql = sql & " dd.Ano_letivo, dd.Semestre, e.codigo as codemp, e.RAZAOSOCIAL, dd.DataInicial, case	when ss.DataFinal is not null then ss.DataFinal else dd.DataFinal end as DataFinal, "
			sql = sql & " f.Desc_Funcao as funcao, isnull(dd.Cod_Substituicao,'0') as Cod_Substituicao, "
			sql = sql & " d.Desc_Disciplina as disciplina, dd.status, e.CodTipoEmpresa "
			sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE dd "
			sql = sql & " inner join SEG_EMPRESA e on e.CODIGO = dd.Cod_empresa "
			sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = dd.cod_funcao"
			sql = sql & " left join SCA_disciplina d on d.cod_disciplina = dd.cod_disciplina"
			sql = sql & " left join SRH_TURNO t on t.cod_turno = dd.cod_turno"
			sql = sql & " left join SCA_periodo p on p.cod_periodo = dd.cod_periodo"
			sql = sql & " left join SRH_COLABORADOR_SUBSTITUTO ss on ss.codColaboradorSubstituto = dd.Cod_Colaborador and ss.codigo = dd.Cod_Substituicao"
			sql = sql & " where dd.Cod_Colaborador = " & intCodColaborador	
			sql = sql & " and dd.ano_letivo = " & strAnoLetivo
			'sql = sql & " or dd.ano_letivo = " & strAnoLetivo - 1 & ")"
			''sql = sql & " and dd.status = 'A'"
			sql = sql & " order by dd.ano_letivo desc , dd.tipoModulacao desc, Cod_Substituicao, dd.tipo_contratacao desc, dd.codigo"
			'response.Write(sql)
			rs.open sql, cnn
			if rs.eof = false then
		        %>
			  <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
	            <tr bgcolor="#E5E5E5" class="celula">
	              <td height="26" class="celula">Unidade</td>
		        <td class="celula">Fun&ccedil;&atilde;o</td>
		        <td class="celula">Ano</td>
		        <td class="celula">Situa&ccedil;&atilde;o</td>
		        <td align="center" class="celula">Data Inicial / Final</td>
		        <td class="celula">Per&iacute;odo</td>
		        <td class="celula">Turno</td>
		        <td class="celula">Sit. Disciplinar</td>
		        <td class="celula">Disciplina</td>
		        <td width="94" class="celula">Aulas/Entrada</td>
		        <td class="celula">Origem</td>
	            </tr>
			    <%
				Total_Aulas = 0
			    while not rs.eof
				   cont = cont + 1	
				   strSituacaoDisciplinar = rs("Situacao_disciplinar")
				   if strSituacaoDisciplinar = "D" then strSituacaoDisciplinar = "Disciplinar"
				   if strSituacaoDisciplinar = "I" then strSituacaoDisciplinar = "Interdisciplinar"
				   codigo = rs("codigo")
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
						if trim(ucase(rs("turno"))) = "INTEGRAL" then
							if session("codGrupo") = "7" then
								intTAulas = rs("Total_Aulas")*42
							else
								intTAulas = rs("Total_Aulas")*42
							end if
						else
							intTAulas = rs("Total_Aulas")*21
                        end if                        
					else
						intTAulas = rs("Total_Aulas")
					end if
                    
					turno = rs("turno")
					
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
					if not isnull(rs("DataInicial")) then
						periodoMod = formatadataAP(rs("DataInicial"))
					end if
					if not isnull(rs("DataFinal")) then
						periodoMod = periodoMod & " - " & formatadataAP(rs("DataFinal"))
					end if
					acesso = "style='cursor:hand' onMouseOver='return linhaMouseOver(this)' onMouseOut='return linhaMouseOut(this)' "
					
					if rs("tipoModulacao") = "FUNCIONARIO" and cor<>"#C0C0C0"  then
						cor = "#C99494"
						link = ""
						acesso = ""
					end if
					if rs("tipoModulacao") = "FUNCIONARIO" and cor="#C0C0C0"  then
						link = ""
						acesso = ""
					end if
					   %>
					   <tr   bgcolor="<%=cor%>" class="celula"  >
                           <td <%=acesso%>  <%=link%> width="196" class="celula9">&nbsp;<%=trim(rs("RAZAOSOCIAL"))%></td>
                           <td width="293" class="celula9">&nbsp;<%=trim(rs("funcao"))%><%=periodo%></td>
                           <td width="51" class="celula9"><div align="center">&nbsp;<%=trim(rs("Ano_letivo"))%></div></td>
                           <td width="61" class="celula9">&nbsp;<%=strStatus%></td>
                           <td width="192" align="center" class="celula9"><%=periodoMod%>&nbsp;</td>
                           <td width="63" class="celula9">&nbsp;<%=trim(rs("periodo"))%></td>
                           <td width="62" class="celula9">&nbsp;<%=trim(turno)%>                           </td>
                           <td width="93" class="celula9">&nbsp;<%=strSituacaoDisciplinar%></td>
                           <td width="73" height="26" class="celula9">&nbsp;<%=trim(rs("disciplina"))%></td>
                           <td height="26" align="center" class="celula9">&nbsp;<%=trim(intTAulas)%></td>
                         <td width="79" class="celula" style="cursor:hand" onclick="return gerarImpressao('<%=rs("codemp")%>','<%=TipoModSub%>','<%=left(strStatus,1)%>','<%=rs("Ano_letivo")%>','<%=intCodColaborador%>','<%=trim(rs("tipo_contratacao"))%>')">&nbsp;<%=trim(strorigem)%><span class="celula" style="cursor:hand"><img src="../../images/impressora_on.gif" width="26" height="26"></span></td>
	            </tr>
                   <% 
				   	if rs("status") = "A" then
				   		Total_Aulas = Total_Aulas + intTAulas
					end if
				   rs.movenext
			    wend
			    %>
			    <tr> 

			    <td height="21" colspan="2" class="celula"><span class="texto"><strong>Total Registros :</strong></span> <strong><%=cont%></strong></td>
			    <td height="21" colspan="7" align="right" class="celula"><span class="texto"><strong>Total:</strong></span></td>
			    <td height="21" align="center" class="celula"><strong><%=Total_Aulas%></strong></td>
			    <td height="21" class="celula">&nbsp;</td>
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
                    <td class="celula">&nbsp;Modula&ccedil;&atilde;o de Funcion&aacute;rio</td>
                  </tr>
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
    <%if intTotalAulasAlteracao = "" then intTotalAulasAlteracao = 0%>
    <br>
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
				frm.action= "ModulacaoInativar_cod.asp?acao=I";
				frm.submit();
			} else {
				return false;
			}
	}
	
	function ChamarSubstituicao(CodColaboradorSubstituto){
		if (CodColaboradorSubstituto == ""){
			alert("O Colaborador deve ser informado.")
			return false;		
		}else{
			frm.action= "ColaboradorSubstitutoModulacao_cad.asp?txtCodColaboradorSubstituto="+CodColaboradorSubstituto;
			frm.submit();
		}
	}

	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.action="ModulacaoNovo_cad.asp?p=s";
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	function salvar(acao){
	
		var frm = document.getElementById("frm");
		if (acao=="E"){
			
			var frm = document.getElementById("frm");
			var men = 'ATENÇÃO: Deseja realmente excluir este colaborador'
			if (confirm(men)) {
				frm.action= "ModulacaoNovo_cod.asp?acao="+acao;
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

				if(frm.optTipoModulacao.value == ""){
					alert("O Tipo de Modulacao deve ser informado!");
					frm.optTipoModulacao.focus();
					return false		
				}
				if(frm.optTipoLancamento.value == "" && frm.optTipoModulacao[0].checked == true){
					alert("O tipo deve ser informado!");
					frm.optTipoLancamento.focus();
					return false		
				}

				if (frm.optTipoLancamento[0].checked == false && frm.optTipoLancamento[1].checked == false && frm.optTipoModulacao[0].checked == true) {
					alert("O tipo deve ser informado!");
					frm.optTipoLancamento[0].focus();
					return false;
				}		

				var saldoContratual = frm.txtSaldoContratual.value;
				if (saldoContratual == '') saldoContratual = 0;

				if(frm.cmbTurno.value == "0"){
					alert("O turno deve ser informado!");
					frm.cmbTurno.focus();
					return false		
				}
				if (frm.cmbCursoCombo.value == "0") {
					alert("O Curso deve ser informado !");
					frm.cmbCursoCombo.focus();
					return false;
				}
				if (frm.cmbPeriodo.value == "0") {
					alert("O período deve ser informado !");
					frm.cmbPeriodo.focus();
					return false;
				}

				if (frm.optTipoLancamento[0].checked == true ) {
					if (frm.cmbDisciplina.value == "0") {
						alert("A Disciplina deve ser informada !");
						frm.cmbDisciplina.focus();
						return false;
					}
				}				
				
				if(frm.txtTotalAulas.value == "" && frm.optTipoModulacao[0].checked == true){
					alert("O Aulas (entradas) deve ser informado!");
					frm.txtTotalAulas.focus();
					return false		
				}
				if(frm.txtTotalAulas.value == "0" && frm.optTipoModulacao[0].checked == true){
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
				
				/*if (frm.tipoContratacao.value=="C" && parseInt(totalAulas)>parseInt(saldoContratual)){
					alert("Para a inclusão da modulação (contratual) o campo aulas (entradas) não poderá ser maior que o saldo contratual restante!");
					frm.txtTotalAulas.focus();
					return false		
				}*/
				var TotalModulado = frm.Total_Aulas_Grid.value;
				if (TotalModulado == '') TotalModulado = 0;
				var totalModulacaoMaisDigitado = parseInt(TotalModulado) + parseInt(totalAulas);
				<%if session("codGrupo") = "7" then%>
				if (parseInt(totalModulacaoMaisDigitado)>42){ //  && frm.optTipoModulacao[0].checked == true){
					alert("O total modulado não pode ultrapassar 42 aulas.");
					return false		
				}
				<%else%>
				if (parseInt(totalModulacaoMaisDigitado)>42){ //  && frm.optTipoModulacao[0].checked == true){
					alert("O total modulado não pode ultrapassar 42 aulas.");
					return false		
				}
				<%end if%>
				if (parseInt(saldoContratual)<0){
					alert("Saldo não pode ser negativo, verifique o nível!");
					frm.cmbNivel.focus();
					return false		
				}
				
				var saldoDisponivelFuncao = frm.txtSaldoDisponivelFuncao.value;
				if (saldoDisponivelFuncao=="") saldoDisponivelFuncao = 0;
				if (parseInt(saldoDisponivelFuncao)<=0){
					alert("Não existe mais saldo disponível para essa função!");
					return false		
				}
				frm.action= "ModulacaoNovo_cod.asp?acao="+acao;
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
	
		if(datInicio <= datFim){
			//alert('Cadastro Completo!');
			return true;
		} else {
			alert('ATENÇÃO: Data Inicial é maior que Data Final');
			document.all.frm.txtPeriodoFinal.focus();
			document.all.frm.txtPeriodoFinal.select();
			frm.txtPeriodoFinal.value = "";
			frm.txtPeriodoFinal.focus();
			return false;
		}    
	}
	
	function gerarImpressao(codEmp, TipoModSub, Status, AnoLetivo, codColaborador, origem){
		var frm = document.getElementById("frm");
//		window.open("ColaboradorSubstitutoDeficit_rel.asp?TipoModSub="+TipoModSub+"&Status="+Status+"&AnoLetivo="+AnoLetivo+"&CodColaborador="+codColaborador +"&origem="+ origem,"abreConsulta","top=5,left=5,height=600,width=800,menubar=no,toolbar=no,scrollbars=yes,status=yes");
 		
		window.open("ColaboradorSubstitutoTexto_rel.asp?codEmp="+codEmp+"&TipoModSub="+TipoModSub+"&Status="+Status+"&AnoLetivo="+AnoLetivo+"&CodColaborador="+codColaborador +"&origem="+ origem,"abreConsulta","top=5,left=5,height=600,width=800,menubar=no,toolbar=no,scrollbars=yes,status=yes");
		return false	
	}
</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 