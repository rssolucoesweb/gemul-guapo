<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_formataCPF.asp"-->
<!--#include file="../../includes/inc_replaceRequest.asp"-->
<!--#include file="../../js/Calendario/Calendario.asp"-->
<!--#include file="../menuModulos.asp"-->

<style>

#txtCodigoFuncional{
  color: blue;
}
#txtNomeFuncionario{
  color: blue;
}
#txtcpf{
  color: blue;
}

.letra10{
  font-size: 10px;
}
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
	Session("CodPerfilAcessoRH") = ""
	sql = "select ACES_USUA_CODG "
	sql = sql & " from SEG_ACESSOS_USUARIO "
	sql = sql & " where ACES_PERF_CODG=72"
	sql = sql & " and ACES_USUA_CODG = '" & session("usuarioWeb") & "'"
	rs.open sql, cnn
	if not rs.eof then
		Session("CodPerfilAcessoRH") = "72"
	end if
	rs.close
	
	' Inativa todas as Modulacoes Vencidas vencidas
	sql = " Update SRH_MODULACAO_DISCIPLINAR_DOCENTE "
	sql = sql & " set status = 'I', data_inativacao = getdate(), usuario_inativacao = 'Sistema' "
	sql = sql & " where convert(varchar, DataFinal,111) < convert(varchar, getdate(),111) "
	sql = sql & " AND Status = 'A' "
	cnn.execute sql

	sql = " UPDATE SRH_MODULACAO_DISCIPLINAR_DOCENTE  SET Status = 'I', data_inativacao = getdate(), usuario_inativacao = 'Sistema' where Ano_Letivo < YEAR(GETDATE()) AND Status = 'A' "
	cnn.execute sql

	'Inativa todas as substituicoes vencidas
	sql = " Update SRH_COLABORADOR_SUBSTITUTO "
	sql = sql & " set SITUACAO = 'I' "
	sql = sql & " where Cod_Grupo = " & Session("CodGrupo")
	sql = sql & " and convert(varchar, DataFinal,111) < convert(varchar, getdate(),111) "
	sql = sql & " and SITUACAO = 'A' "
	cnn.execute sql

	'atualiza saldo substituicao
	sql = " update s set s.Saldo_Substituicao = null"
	sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE m"
	sql = sql & " inner join SRH_MODULACAO_DISCIPLINAR_DOCENTE s on s.codigo = m.Cod_Modulacao_Substituicao"
	sql = sql & " where m.Status = 'I'"
	sql = sql & " and m.Cod_Modulacao_Substituicao is not null"
	cnn.execute sql

	strBotaoAutorizarModulacao = "S"
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
		sql = "select f.cod_funcao, tu.Cod_Turno, f.Situacao_Disciplinar, c.codigo, c.nome, c.cpf, f.Tipo_Funcao, c.codFuncao, c.situacao, c.codFuncional, tu.Desc_Turno as turno, c.cpf, f.Desc_Funcao as funcao, ca.desc_categoria as categoria, isnull(c.total_aulas,0) as total_aulas, c.cod_empresa"
		sql = sql & " from srh_colaborador c"
		sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = c.codfuncao"
		sql = sql & " left join SRH_CATEGORIA ca on ca.Cod_Categoria = c.CodCategoria "
		sql = sql & " left join SRH_TURNO tu on tu.Cod_Turno = c.CodTurno "
		sql = sql & " INNER JOIN SEG_EMPRESA E ON E.CODIGO = C.CODLOTACAO "
		sql = sql & " where C.CodFuncional = " & intCodFuncional
		sql = sql & " And C.Situacao = 'A'"
		sql = sql & " and E.COD_GRUPO = " & session("codGrupo")
		rs.open sql, cnn
		if rs.eof = false then
		
			Situacao_Disciplinar = rs("Situacao_Disciplinar")
			Cod_Turno 			 = rs("Cod_Turno")
			cod_funcao			 = rs("cod_funcao")
			
			intCodColaborador	= rs("Codigo")
			intCodEmp           = rs("Cod_Empresa")
			strnome 			= Trim(Rs("nome"))
			intCodFuncional		= Trim(Rs("CodFuncional"))
			strFuncao			= Trim(Rs("funcao"))
			intcodFuncaoCadastro= Trim(Rs("codFuncao"))
			strTurnoContratado	= rs("turno")
			strCategoria		= Trim(Rs("categoria"))
			intContratado	 	= rs("total_aulas")
			strTipo_Funcao		= rs("Tipo_Funcao")
			
			strDesabilitaProfessor = ""
			if strTipo_Funcao = "PROFESSOR" and Trim(Request.Form("optTipoModulacao"))="" then
				strTipoModulacao = "PROFESSOR"
			end if
			if strTipo_Funcao = "FUNCIONARIO" and Trim(Request.Form("optTipoModulacao"))="" then
				strTipoModulacao = "FUNCIONARIO"
				strDesabilitaProfessor = " disabled "
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
	
		sql = "select f.cod_funcao, tu.Cod_Turno, f.Situacao_Disciplinar, c.codigo, c.nome, f.Tipo_Funcao, c.codFuncional, c.situacao, c.cpf, tu.Desc_Turno as turno, c.codFuncao, f.Desc_Funcao as funcao, ca.desc_categoria as categoria, isnull(c.total_aulas,0) as total_aulas, isnull(c.carga_horario_contratada,0) as carga_horario_contratada,c.cod_empresa"
		sql = sql & " from srh_colaborador c"
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
				
				strFuncao						= Trim(Rs("funcao"))
				intcodFuncaoCadastro			= Trim(Rs("codFuncao"))
				strCategoria					= Trim(Rs("categoria"))
				intContratado	 				= rs("total_aulas")
				intCargaHorariaContratada	 	= rs("carga_horario_contratada")
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
				
				'if strTipo_Funcao <> "FUNCIONARIO" OR intContratadoNivel > 0 THEN
				'	strDesabilitaProfessor = ""
				'end if	

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
			sql = "select f.cod_funcao, tu.Cod_Turno, f.Situacao_Disciplinar, c.codigo, c.nome, f.Tipo_Funcao, c.codFuncional, c.situacao, c.cpf, tu.Desc_Turno as turno, c.codFuncao, f.Desc_Funcao as funcao, ca.desc_categoria as categoria, c.total_aulas, isnull(c.carga_horario_contratada,0) as carga_horario_contratada, c.cod_empresa"
			sql = sql & " from srh_colaborador c"
			sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = c.codfuncao"
			sql = sql & " left join SRH_CATEGORIA ca on ca.Cod_Categoria = c.CodCategoria "
			sql = sql & " left join SRH_TURNO tu on tu.Cod_Turno = c.CodTurno "
			sql = sql & " Where c.cpf = '" & strCPF & "'"
'			if Session("CodPerfilAcessoRH") <> "72" then
'				sql = sql & " AND c.codLotacao = " & session("CodEmpresa")
'			end if
			rs.open sql, cnn
			if rs.eof = false then
				Situacao_Disciplinar = rs("Situacao_Disciplinar")
				Cod_Turno 			 = rs("Cod_Turno")
				cod_funcao			 = rs("cod_funcao")

				intCodColaborador	= rs("Codigo")
				intCodEmp           = rs("Cod_Empresa")
				strnome 			= Trim(Rs("nome"))
				intCodFuncional		= Trim(Rs("CodFuncional"))
				strFuncao			= Trim(Rs("funcao"))
				strCategoria		= Trim(Rs("categoria"))
				intContratado 		= rs("total_aulas")
				intCargaHorariaContratada	 = rs("carga_horario_contratada")
				strTipo_Funcao		= rs("Tipo_Funcao")
				
				strDesabilitaProfessor = ""
				if strTipo_Funcao = "PROFESSOR" and Trim(Request.Form("optTipoModulacao"))="" then
					strTipoModulacao = "PROFESSOR"
				end if
				if strTipo_Funcao = "FUNCIONARIO" and Trim(Request.Form("optTipoModulacao"))="" then
					strTipoModulacao = "FUNCIONARIO"
					strDesabilitaProfessor = " disabled "
				end if
				'if strTipo_Funcao <> "FUNCIONARIO" OR intContratadoNivel > 0 THEN
				'	strDesabilitaProfessor = ""
				'end if	
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
	
		sql = "SELECT m.Codigo, m.Cod_Colaborador, co.nome, co.situacao, co.CPF, f.Tipo_Funcao, co.Total_Aulas, co.CodFuncional,f.Desc_Funcao as funcao, ca.desc_categoria as categoria, tu.Desc_Turno as turno, m.Cod_empresa, m.Cod_Curso, M.Cod_periodo, C.Descricao AS Curso, P.Descricao AS PERIODO, F.Desc_Funcao, co.codfuncao as cod_funcao_cadastro, M.cod_funcao, m.Cod_turno, "
		sql = sql & " m.Cod_Disciplina, m.tipo_contratacao, m.Situacao_disciplinar, m.Ano_letivo, m.Semestre, m.status, "
		sql = sql & " periodo_inicial, periodo_final, DataInicial, DataFinal, e.razaosocial"
		sql = sql & " FROM SRH_MODULACAO_DISCIPLINAR_DOCENTE m"
		sql = sql & " inner join seg_empresa e on e.codigo = m.cod_empresa"
		sql = sql & " inner join SRH_COLABORADOR co on co.codigo = m.Cod_Colaborador"
		sql = sql & " inner join SRH_FUNCAOCOLABORADOR F on F.Cod_Funcao = m.cod_funcao"
		sql = sql & " left  join SCA_PERIODO P on P.Cod_periodo = m.Cod_periodo"
		sql = sql & " left  join SCA_CURSO C on C.COD_CURSO=P.COD_CURSO"
		sql = sql & " left join SRH_CATEGORIA ca on ca.Cod_Categoria = co.CodCategoria "
		sql = sql & " left join SRH_TURNO tu on tu.Cod_Turno = co.CodTurno "
		sql = sql & " where m.codigo = " & intCodigo	
'		if Session("CodPerfilAcessoRH") <> "72" then
'			sql = sql & " AND m.cod_empresa = " & session("CodEmpresa")
'		end if
		rs.open sql, cnn
		if rs.eof = false then
		
			intCodColaborador	= rs("Cod_Colaborador")
			intCodEmp           = rs("Cod_Empresa")
			strnome 			= Trim(Rs("nome"))
			intCodFuncional		= Trim(Rs("CodFuncional"))
			strFuncao			= Trim(Rs("funcao"))
			intcodFuncaoCadastro= Trim(Rs("cod_funcao_cadastro"))
			strTurnoContratado	= rs("turno")
			strCategoria		= Trim(Rs("categoria"))
			intContratado	 	= rs("total_aulas")
			strTipo_Funcao		= rs("Tipo_Funcao")
			
			strDesabilitaProfessor = ""
			if strTipo_Funcao = "PROFESSOR" and Trim(Request.Form("optTipoModulacao"))="" then
				strTipoModulacao = "PROFESSOR"
			end if
			if strTipo_Funcao = "FUNCIONARIO" and Trim(Request.Form("optTipoModulacao"))="" then
				strTipoModulacao = "FUNCIONARIO"
				strDesabilitaProfessor = " disabled "
			end if

			strCPF  			= formataCPFap(Trim(Rs("CPF")))
			strSituacaoColaborador = rs("situacao")
			intCodFuncaoColaborador		= rs("cod_Funcao")
		
		
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
	
	if strTipo_Funcao = "FUNCIONARIO" then
		intContratado = intCargaHorariaContratada
	end if
	if intContratado = "" then intContratado = 0
	
	intModulado = 0
	intPorPeriodo = 0
	if intCodColaborador <> "" then
		sql = "select " 
		sql = sql & " isnull(sum(MD.Total_Aulas),0) AS modulado, " 
		sql = sql & " MD.situacao_disciplinar, tipo_contratacao " 
		sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE MD "
		sql = sql & " INNER JOIN SEG_EMPRESA E ON E.CODIGO = MD.Cod_empresa " 
		sql = sql & " where Cod_Colaborador = " & intCodColaborador
		sql = sql & " and status = 'A'"
		'sql = sql & " and tipo_contratacao <> 'A'"
		sql = sql & " and cod_turno is not null "
		sql = sql & " and isnull(Cod_ColaboradorSubstituido,'0') = 0 "
		sql = sql & " and ano_letivo = " & strAnoLetivo
		sql = sql & " and tipo_contratacao is not null group by tipo_contratacao, situacao_disciplinar"
		'response.write sql
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
	

	intSaldoContratado = 0
	
 
	
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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Modulação</h3>
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
                <td height="24" colspan="3" bgcolor="#CCCCCC" class="TextoForm"><strong>Dados do Colaborador </strong></td>
                </tr>
              
              <tr>
                <td height="33" class="TextoForm"><strong>CPF:</strong></td>
                <td width="591" height="33" class="TextoForm"><input name="txtcpf" type="text" class="text" id="txtcpf" size="15" maxlength="70" value="<%=strCPF%>" <%if strCPF<>"" then%>readonly style="background: #d5d2d2;" <%end if%> onkeypress="return formataCampo(this,5,14)" onblur="return validaCPFColaborador(this)"></td>
                <td width="507" rowspan="3" class="TextoForm">
				
				<%if intCodColaborador<>"" then%>
                <table width="100%" border="0" cellspacing="2" cellpadding="2">
                  <tr>
                    <td colspan="2" align="center" class="celula"><strong>Resumo da Contrata&ccedil;&atilde;o</strong></td>
                    </tr>
                  <tr>
                    <td class="celula">Categoria:</td>
                    <td class="celula"><strong><%=strCategoria%></strong>&nbsp;</td>
                  </tr>
                  <tr>
                    <td class="celula">Fun&ccedil;&atilde;o: <%=intContratadoMaximo%></td>
                    <td class="celula"><strong><%=strFuncao%></strong>&nbsp;</td>
                  </tr>
                  
				  
                  <tr>
                    <td class="celula">Turno Contratado:</td>
                    <td class="celula"><strong><%=strTurnoContratado%></strong>&nbsp;</td>
                  </tr>
				  <tr>
                    <td width="25%" class="celula">Contrato:</td>
                    <td width="48%" class="celula"><strong><%=intModulado%></strong><input name="txtTotalContratualPeriodo" id="txtTotalContratualPeriodo" value="<%=intPorPeriodo%>" type="hidden" >&nbsp;</td>
                  </tr>
				  <tr>
                    <td width="22%" class="celula">Por período:</td>
                    <td width="48%" class="celula"><strong><%=intPorPeriodo%></strong><input name="txtTotalContratualPeriodo" id="txtTotalContratualPeriodo" value="<%=intPorPeriodo%>" type="hidden" >&nbsp;</td>
                  </tr>
                  <tr>
                    <td class="celula"><font color="blue"><strong>Total Modulado</strong></font></td>
                    <td class="celula"><font color="blue"><strong><%=intModulado+intPorPeriodo%></strong></font><input name="txtTotalModulado" id="txtTotalModulado" value="<%=intModulado%>" type="hidden" >&nbsp;</td>
                  </tr>
                  
                </table>
				
				<%end if%>
				</td>
                </tr>
              <tr>
                <td height="33" class="TextoForm">Matr&iacute;cula Funcional</td>
                <td height="33" class="TextoForm"><input name="txtCodigoFuncional" type="text" class="text" id="txtCodigoFuncional" <%if intCodFuncional<>"" then%>readonly style="background: #d5d2d2;" <%end if%> size="12" maxlength="8" value="<%=intCodFuncional%>"  onKeyPress="return formataCampo(this, 2, 8)">
                  <input type="checkbox" name="LocalizarMatricula" value="S" onClick='submit()'>
                    Localizar?&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    Por Per&iacute;odo
                    <input type="checkbox" name="PorPeriodo" <%if PorPeriodo="S" or strTipoContratacao = "A" then response.Write("checked") %> value="S" onClick='submit()'>
					<% if Session("CodPerfilAcessoRH") = "72" then%>
					<input type="button" name="cmdAbonoFaltas" style="cursor:hand"   value="Substituição" class="btn-u float-shadow" onclick="return  ChamarSubstituicao('<%=intCodColaborador%>')" />
					<% end if %>
					</td>
                </tr>
              <tr> 
                <td width="183" height="33" class="TextoForm">Nome:</td>
                <td height="33" class="TextoForm"><input name="txtCodFuncionario" value="<%=intCodColaborador%>" type="hidden" id="txtCodFuncionario" >
                  <input name="txtCodEmpresa" value="<%=intCodEmp%>" type="hidden" id="txtCodEmpresa" >
                  <input name="txtcodLotacaoAnterior" value="<%=intcodLotacaoAnterior%>" type="hidden" id="txtcodLotacaoAnterior" >
                  <input name="txtNomeFuncionario" type="text" class="text" id="txtNomeFuncionario" <%if strNome<>"" then%>readonly style="background: #d5d2d2;" <%end if%> size="50" maxlength="70" value="<%=strNome%>">
                  <%if strNome="" then%>
				  <button class="btn btn-success" onclick="return abreConsultaColaborador('Colaborador_con.asp?PaginaOrigem=ModulacaoNovo_cad&Tipo=P')" type="button"><i class="fa fa-search"></i></button>
                  <%end if%>
                  <% if session("NivelPermissao") = "A" then %>
                  	<button class="btn btn-success" onclick="return acessarColaborador('Colaborador_cad.asp?txtCodFuncionario=<%=intCodColaborador%>&paginaVoltar=ModulacaoNovo_cad.asp?txtCodFuncionario=<%=intCodColaborador%>')" type="button"><i class="icon-users"></i></button>
                  <% end if %>
				  <%if strNome<>"" then%>
				  <br><strong><font color="red">Para trocar de colaborador, clique no botão limpar!</font></strong>
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
                 <input <%if strTipoModulacao = "PROFESSOR" then response.Write("checked")%>  type="radio" name="optTipoModulacao" id="optTipoModulacao" <%=strDesabilitaProfessor%> value="PROFESSOR" onclick="submit()"> 
                 Professor 
                &nbsp;&nbsp;&nbsp;&nbsp;
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
              <td rowspan="11" align="left" valign="top" ></td>
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
            <tr >
              <td height="24" class="texto">Turno:</td>
              <td height="24"  class="texto"><!--#include file="../includes/inc_cmdTurnoModulacaoNova.asp" -->
			  </td>
            </tr>
            <tr <%if strTipoModulacao = "FUNCIONARIO" then RESPONSE.WRITE " style='display:none' " %>>
              <td height="31" class="texto">Curso:</td>
              <td height="31"  class="texto"><!--#include file="../includes/inc_cmdCursoModulacao.asp" --></td>
            </tr>
            
            <tr <%if strTipoModulacao = "FUNCIONARIO" then RESPONSE.WRITE " style='display:none' " %>>
                <td height="32" class="TextoForm">Per&iacute;odo:</td>
                <td class="TextoForm"><span class="texto">
                  <!--#include file="../includes/inc_cmdPeriodoModulacao.asp" -->
                </span></td>
             </tr>
			 
			 <%
			'SQL = "SELECT "
			'SQL = SQL & " 	FU.Cod_Funcao,"
			'SQL = SQL & " 	FU.Desc_Funcao,"
			'SQL = SQL & " 	ISNULL(v.total_vagas, 0) AS total_vagas,"
			'SQL = SQL & " 	ISNULL(m.total_modulado, 0) AS total_modulado,"
			'SQL = SQL & " 	ISNULL(v.total_vagas, 0) - ISNULL(m.total_modulado, 0) AS vagas_disponiveis"
			'SQL = SQL & " FROM "
			'SQL = SQL & " 	SRH_FUNCAOCOLABORADOR FU"
			'SQL = SQL & " LEFT JOIN ("
			'SQL = SQL & " 	SELECT "
			'SQL = SQL & " 		CodFuncao,"
			'SQL = SQL & " 		SUM("
			'SQL = SQL & " 			CASE "
			'SQL = SQL & " 				WHEN AulasOferecidas > 0 THEN AulasOferecidas"
			'SQL = SQL & " 				WHEN VagasOferecidas > 0 THEN VagasOferecidas"
			'SQL = SQL & " 				ELSE 0"
			'SQL = SQL & " 			END"
			'SQL = SQL & " 		) AS total_vagas"
			'SQL = SQL & " 	FROM SRH_DIRETRIZES"
			'SQL = SQL & " 	WHERE "
			'SQL = SQL & " 		Ano_Letivo = " & strAnoLetivo
			'SQL = SQL & " 		AND Semestre = " & intSemestre 
			'SQL = SQL & " 		AND CodFuncao = " & intCodFuncao
			'SQL = SQL & " 		AND Cod_Empresa = " & intCodEmpresaGrupo
			'SQL = SQL & " 		AND Cod_Turno = " & intCodTurnoColaborador 
			'if intCodPeriodo <> "0" AND intCodPeriodo <> "" then 
			'	SQL = SQL & " AND Cod_periodo  = " & intCodPeriodo 
			'end if
			'if intCodDisciplina <> "0" AND intCodDisciplina <> "" then 
			'	SQL = SQL & " AND Cod_Disciplina  = " & intCodDisciplina 
			'end if
			'SQL = SQL & " 	GROUP BY CodFuncao"
			'SQL = SQL & " ) v ON v.CodFuncao = FU.Cod_Funcao"
			'SQL = SQL & " LEFT JOIN ("
			'SQL = SQL & " 	SELECT "
			'SQL = SQL & " 		Cod_Funcao,"
			'SQL = SQL & " 		SUM(Total_Aulas) AS total_modulado"
			'SQL = SQL & " 	FROM SRH_MODULACAO_DISCIPLINAR_DOCENTE"
			'SQL = SQL & " 	WHERE "
			'SQL = SQL & " 		Ano_Letivo = " & strAnoLetivo
			'SQL = SQL & " 		AND Semestre = " & intSemestre 
			'SQL = SQL & " 		AND Status = 'A'"
			'SQL = SQL & " 		AND ISNULL(Cod_Modulacao_Substituicao, 0) = 0"
			'SQL = SQL & " 		AND Cod_Funcao = " & intCodFuncao
			'SQL = SQL & " 		AND Total_Aulas IS NOT NULL"
			'SQL = SQL & " 		AND Cod_empresa = " & intCodEmpresaGrupo
			'SQL = SQL & " 		AND Cod_Turno = " & intCodTurnoColaborador 
			'if intCodPeriodo <> "0" AND intCodPeriodo <> "" then 
			'	SQL = SQL & " AND Cod_periodo  = " & intCodPeriodo 
			'end if
			'if intCodDisciplina <> "0" AND intCodDisciplina <> "" then 
			'	SQL = SQL & " AND Cod_Disciplina  = " & intCodDisciplina 
			'end if
			'SQL = SQL & " 	GROUP BY Cod_Funcao"
			'SQL = SQL & " ) m ON m.Cod_Funcao = FU.Cod_Funcao"
			'SQL = SQL & " WHERE "
			'SQL = SQL & " 	ISNULL(v.total_vagas, 0) - ISNULL(m.total_modulado, 0) > 0"
			'rs.open sql, cnn
			'if rs.eof = false then
			'	strTotalModulado = rs("total_modulado")
			'	saldo = rs("vagas_disponiveis")
			'	strVagasFuncao = rs("total_vagas")
			'end if
			'rs.close 
			if intCodEmpresaGrupo<>"0" then
				if strTipoModulacao = "FUNCIONARIO" then
					sql = "exec [dbo].[SP_Rel_MapaModulacao_Funcionario] " & session("codGrupo") & "," & strAnoLetivo & "," & intSemestre & ",0," & intCodEmpresaGrupo & "," & intCodTurnoColaborador & "," & intCodFuncao
					rs.open sql, cnn
					if rs.eof = false then
						strVagasFuncao = rs("VagasLiberadasDiretriz")
						strTotalModulado = rs("modulados_contrato")+rs("modulados_periodo")
						saldo = rs("saldo")
					end if
					rs.close 
				else
					sql = "exec [dbo].[SP_Rel_MapaModulacao_Professor] " & session("codGrupo") & "," & strAnoLetivo & "," & intSemestre & ",3,'T'," & intCodEmpresaGrupo & "," & intCodPeriodo & "," & intCodTurnoColaborador & "," & intCodFuncao
					rs.open sql, cnn
					if rs.eof = false then
						if rs("vagas_necessarias")>0 then
							strVagasFuncao = rs("vagas_necessarias")
						else
							strVagasFuncao = rs("aulas_necessarias")
						end if
						strTotalModulado = rs("modulado_contratual")+rs("modulado_periodo")
						saldo = rs("saldo")
					end if
					rs.close 
				end if
			end if
			 %>
			 
			 
           <% if strTipoLancamento = "D" then %>
                 <tr>
                   <td height="32" class="TextoForm">Disciplinas:</td>
                   <td class="TextoForm"><span class="texto">
                     <!--#include file="../includes/inc_cmdDisciplinaModulacao.asp" -->
                   </span></td>
                   </tr>
                 <tr>
				<%
			end if
			%>
                <td height="25" class="TextoForm">&nbsp;</td>
                <td class="TextoForm">
                <%if intCodEmpresaGrupo<>"0" then%>
                  <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#C0C0C0">
                    <tr>
                      <td width="7" class="texto">&nbsp;</td>
                      <td width="244" height="22" class="texto">Vagas - Existente:&nbsp;<%=strVagasFuncao%></td>
                      <td width="193" class="texto">Modulada: <%=strTotalModulado%></td>
                      <td width="173" class="texto">Disponível: <strong><%=saldo+intTotalAulasAlteracao%></strong>
					  <input name="txtSaldoDisponivelFuncao" id="txtSaldoDisponivelFuncao" value="<%=saldo+intTotalAulasAlteracao%>" type="hidden" ></td>
                      </tr>
                    </table>                
				<%end if%>
					</td>
                </tr>
                 <tr>
                   <td height="25" class="TextoForm">
				   <input name="tipo" type="hidden" id="tipo" value="<%=tipo%>">
				   <input name="Ch_Semanal" type="hidden" id="Ch_Semanal" value="<%=Ch_Semanal%>">				   
				   <%if tipo="" or tipo="A" then %>
				   <span class="texto">Aulas (Entradas):</span>
				   <%else%>
				   <span class="texto">Dias (Entradas):</span>
				   <%end if%>
				   </td>
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
		  
			sql = "select dd.tipoModulacao, dd.justificativa, dd.Codigo, dd.Situacao_disciplinar, p.Descricao as periodo, t.desc_turno as turno, dd.usuario_inativacao, dd.Data_Inativacao,  "
			sql = sql & " dd.Total_Aulas, dd.tipo_contratacao, dd.periodo_inicial, dd.usuario_incl, dd.data_hora_incl, dd.usuario_altr, dd.data_hora_altr, dd.usuario_situacao, dd.data_hora_situacao,"
			sql = sql & " case when dd.periodo_final is not null then dd.periodo_final "
			sql = sql & " else dd.DataFinal end as periodo_final, "
			sql = sql & " dd.status, dd.Ano_letivo, dd.Semestre, e.codigo as codemp, e.RAZAOSOCIAL, dd.DataInicial, "
			sql = sql & " case when dd.DataFinal is not null then dd.DataFinal "
			sql = sql & " else dd.periodo_final end as DataFinal, "
			sql = sql & " f.Desc_Funcao as funcao, isnull(dd.Cod_ColaboradorSubstituido,'0') as Cod_Substituicao, dd.Cod_ColaboradorSubstituido, "
			sql = sql & " d.Desc_Disciplina as disciplina, dd.status, e.CodTipoEmpresa, dd.DataInicial_Substituicao, dd.DataFinal_Substituicao "
			sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE dd "
			sql = sql & " inner join SEG_EMPRESA e on e.CODIGO = dd.Cod_empresa "
			sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = dd.cod_funcao"
			sql = sql & " left join SCA_disciplina d on d.cod_disciplina = dd.cod_disciplina"
			sql = sql & " left join SRH_TURNO t on t.cod_turno = dd.cod_turno"
			sql = sql & " left join SCA_periodo p on p.cod_periodo = dd.cod_periodo"
			sql = sql & " left join SRH_COLABORADOR_SUBSTITUTO ss on ss.codColaboradorSubstituto = dd.Cod_Colaborador and ss.codigo = dd.Cod_ColaboradorSubstituido"
			sql = sql & " where dd.Cod_Colaborador = " & intCodColaborador	
			sql = sql & " and dd.ano_letivo = " & strAnoLetivo
			sql = sql & " and dd.status <> 'X'" 'excluido
			sql = sql & " order by dd.ano_letivo desc , dd.tipoModulacao desc, Cod_ColaboradorSubstituido, dd.tipo_contratacao desc, dd.codigo"
			'response.Write(sql)
			if Session("UsuarioWeb") = "SERGIO" then
				'response.write sql
				'response.end
			end if
			rs.open sql, cnn
			if rs.eof = false then
		        %>
			  <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
	            <tr bgcolor="#E5E5E5" class="letra10">
	              <td height="26" class="letra10">Editar</td>
				  <td height="26" class="letra10">Unidade</td>
		        <td class="letra10">Fun&ccedil;&atilde;o</td>
		        <td align="center" class="letra10">Data Inicial / Final</td>
		        <td class="letra10">Per&iacute;odo</td>
		        <td class="letra10">Turno</td>
		        <td class="letra10">Sit. Disciplinar</td>
		        <td class="letra10">Disciplina</td>
		        <td width="50" class="letra10">Aulas/Entrada</td>
		        <td class="letra10">Origem</td>
				<td class="letra10">Ação</td>
	            </tr>
			    <%
				Total_Aulas = 0
				cont = 0
			    while not rs.eof
				   cont = cont + 1	
				   strSituacaoDisciplinar = rs("Situacao_disciplinar")
				   if strSituacaoDisciplinar = "D" then strSituacaoDisciplinar = "Disciplinar"
				   if strSituacaoDisciplinar = "I" then strSituacaoDisciplinar = "Interdisciplinar"
				   codigo = rs("codigo")
				   if isnull(rs("Cod_ColaboradorSubstituido")) then  
					   strorigem = "MODULAÇÃO"	
					   TipoModSub = "C"
				   else				
					   strorigem = "SUBSTITUICAO"	
					   TipoModSub = "S"
				   end if
				   
					link = "onClick='return resultadoConsulta(" & rs("codigo") & ")'"
					inativado=""
					strStatus = "Ativo"
				   	if trim(rs("status")) = "A" then 
						cor = "#deffe1"
						strStatus = "Autorizado"
					elseif trim(rs("status")) = "E" then 
						cor = "#def6ff"
						strStatus = "Aguardando Autorização"
					elseif trim(rs("status")) = "N" then 
						cor = "#fdc68e"
						strStatus = "Não Autorizado"
					elseif trim(rs("status")) = "I" then 
						cor = "#C0C0C0"
						link = ""
						strStatus = "Inativo"
						inativado = "&nbsp;&nbsp;&nbsp;&nbsp; Inativado por: " & rs("usuario_inativacao") & " em " & rs("Data_Inativacao")
					end if
				   
				   periodo = ""
				   tipo = "Contratual"
				   
				   if rs("tipo_contratacao") = "A" then 
				   		periodo = "&nbsp;(" & formatadataAP(rs("periodo_inicial")) & " a " & formatadataAP(rs("periodo_final")) & ")"
						tipo = "Adicional"
						cor = "#faf4c1"
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
							intTAulas = rs("Total_Aulas")*28
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
						'response.write rs("periodo_final") & "<br>|"
						'response.write strPeriodoFinalComparar & "<br>|"
						'response.write strDataAtualComparar
						
						if cCur(strPeriodoFinalComparar)<cCur(strDataAtualComparar) then 
							sql = "update SRH_MODULACAO_DISCIPLINAR_DOCENTE set status = 'I', data_inativacao = getdate(), usuario_inativacao = 'Sistema' where codigo = " & rs("codigo") 
							'response.write sql
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
					if rs("Cod_Substituicao") <> "0" then 
						periodoMod = formatadataAP(rs("DataInicial_Substituicao")) & " - " & formatadataAP(rs("DataFinal_Substituicao"))
					end if
					
					acesso = "style='cursor:hand' onMouseOver='return linhaMouseOver(this)' onMouseOut='return linhaMouseOut(this)' "
					inclusoes = ""
					IF NOT ISNULL(rs("data_hora_incl")) THEN inclusoes = "Incluído por: " & rs("usuario_incl") & " | " & rs("data_hora_incl")
					IF NOT ISNULL(rs("data_hora_altr")) THEN inclusoes = inclusoes & " | Alterado por: " & rs("usuario_altr") & " | " & rs("data_hora_altr")
					IF NOT ISNULL(rs("data_hora_situacao")) THEN inclusoes = inclusoes & " | Autorização/Justifiado por: " & rs("usuario_situacao") & " | " & rs("data_hora_situacao")
					
					   %>
					   <tr   bgcolor="<%=cor%>" class="celula"  >
							<td rowspan="2"<%if rs("status") <> "N" then%> <%=acesso%>  <%=link%><%end if%> width="26" class="celula8" valign="middle">
								<%if Session("CodPerfilAcessoRH") = "72" then%>
									<%if rs("status") <> "N" then%>
										<button class="btn btn-primary" type="button"><i class="fa fa-edit"></i></button>
									<%end if%>
								<%end if%>
							</td>
                           <td width="196" class="letra10">&nbsp;<%=trim(rs("RAZAOSOCIAL"))%></td>
                           <td width="220" class="letra10">&nbsp;<%=trim(rs("funcao"))%><%=periodo%></td>
                           <td width="170" align="center" class="letra10"><%=periodoMod%>&nbsp;</td>
                           <td width="63" class="letra10">&nbsp;<%=trim(rs("periodo"))%></td>
                           <td width="62" class="letra10">&nbsp;<%=trim(turno)%>                           </td>
                           <td width="93" class="letra10">&nbsp;<%=strSituacaoDisciplinar%></td>
                           <td width="73" height="26" class="letra10">&nbsp;<%=trim(rs("disciplina"))%></td>
                           <td height="26" align="center" class="letra10">&nbsp;<%=trim(intTAulas)%></td>
                         <td width="79" class="letra10" style="cursor:hand" 
						 <%if rs("status") = "A" then%>
						 <%if TipoModSub <> "S" then %>
							onclick="return gerarImpressao('<%=rs("codemp")%>','<%=TipoModSub%>','<%=left(strStatus,1)%>','<%=rs("Ano_letivo")%>','<%=intCodColaborador%>','<%=trim(rs("tipo_contratacao"))%>')"
						 <%end if%>
						 
						 <%if TipoModSub = "S" then %>
							onclick="return gerarImpressaoSub('<%=rs("codigo")%>')"
						 <%end if%>
						 <%end if%>
						 >&nbsp;<%=trim(strorigem)%><%if rs("status") = "A" then%><span class="letra10" style="cursor:hand"><img src="../../images/impressora_on.gif" width="26" height="26"></span><%end if%></td>
						<td align="left"  class="letra10"  width="60">
							<%if rs("status") = "E" and Session("CodPerfilAcessoRH") = "72" then %>
								<button class="btn-u btn-u-blue" onclick="autorizar('<%=trim(rs("codigo"))%>','A')" type="button"><i class="fa fa-check-circle-o"></i></button>Autorizar
								<br>
								<br>
								<button class="btn-u btn-u-red" onclick="autorizar('<%=trim(rs("codigo"))%>','E')" type="button"><i class="fa fa-close"></i></button>Não Autorizar
								<br>Justificativa: <br>
								<input name="txtJustificativa<%=trim(rs("codigo"))%>" type="text" class="form-control" id="txtJustificativa<%=trim(rs("codigo"))%>" size="20" maxlength="100" >
							<%else%>
								<%if rs("status") = "E" and isnull(rs("justificativa")) then %>
								Aguardando Autorização
								<%else%>
								<%=rs("justificativa")%>
								<%end if%>
							<%end if%>
						</td> 
	            </tr>
				<TR   bgcolor="<%=cor%>" >
						<td colspan="11" align="center" class="letra10"><%=inclusoes%>&nbsp;<%=inativado%></td>
						</TR>
                   <% 
				   	if rs("status") = "A" then
				   		Total_Aulas = Total_Aulas + intTAulas
					end if
				   rs.movenext
			    wend
			    %>
			    <tr> 

			    <td height="21" class="letra10" colspan="2"><span class="texto"><strong>Total Registros :</strong></span> <strong><%=cont%></strong></td>
			    <td height="21" colspan="6" align="right" class="celula"><span class="texto"><strong>Total:</strong></span></td>
			    <td height="21" align="center" class="letra10"><strong><%=Total_Aulas%></strong></td>
			    <td height="21" colspan="2" class="letra10">&nbsp;</td>
			    <%
		    end if
		    rs.close
			 %>
              </table> 
              <br>
			  <table align="center" width="40%" border="0" cellspacing="0" cellpadding="0" class="tabela">
                  <tr>
                    <td class="celula" bgcolor="#deffe1">&nbsp;</td>
                    <td class="celula">&nbsp;Modula&ccedil;&atilde;o Autorizada</td>
                  </tr>
				  <tr>
                    <td class="celula" bgcolor="#def6ff">&nbsp;</td>
                    <td class="celula">&nbsp;Modula&ccedil;&atilde;o Aguardando Autorização</td>
                  </tr>
				  <tr>
                    <td class="celula" width="17%" bgcolor="#fdc68e">&nbsp;</td>
                    <td class="celula" width="83%">&nbsp;Modula&ccedil;&atilde;o Não Autorizada</td>
                  </tr>
				  <tr>
                    <td class="celula" width="17%" bgcolor="#faf4c1">&nbsp;</td>
                    <td class="celula" width="83%">&nbsp;Por Período</td>
                  </tr>
				  <tr>
                    <td class="celula" width="17%" bgcolor="#6699FF">&nbsp;</td>
                    <td class="celula" width="83%">&nbsp;Substituição</td>
                  </tr>
				  <tr>
                    <td class="celula" width="17%" bgcolor="#COCOCO">&nbsp;</td>
                    <td class="celula" width="83%">&nbsp;Modula&ccedil;&atilde;o Inativa</td>
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

				if(frm.cmbTurno.value == "0"){
					alert("O turno deve ser informado!");
					frm.cmbTurno.focus();
					return false		
				}
				
				if (frm.optTipoLancamento[0].checked == true ) {
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
					if (frm.cmbDisciplina.value == "0") {
						alert("A Disciplina deve ser informada !");
						frm.cmbDisciplina.focus();
						return false;
					}
				}				
				
				if(frm.txtTotalAulas.value == "" && frm.optTipoModulacao[0].checked == true){
					alert("O Aulas (entradas) deve ser informado!");
					frm.txtTotalAulas.value = "";
					frm.txtTotalAulas.focus();
					return false		
				}
				if(frm.txtTotalAulas.value == "0" && frm.optTipoModulacao[0].checked == true){
					alert("O Aulas (entradas) não pode ser zero!");
					frm.txtTotalAulas.value = "";
					frm.txtTotalAulas.focus();
					return false		
				}
				
				if(frm.PorPeriodo.checked == false){
				
					if (frm.optTipoModulacao[0].checked) {
						var saldoDisponivelFuncao = frm.txtSaldoDisponivelFuncao.value;
						var totalAulas = Number(frm.txtTotalAulas.value);
						var chSemanal = Number(frm.Ch_Semanal.value);
						if (totalAulas=="1" && saldoDisponivelFuncao=="0"){
							alert("O valor no campo aulas (entradas) não pode ser maior que o saldo disponível para essa função ( disponível: "+saldoDisponivelFuncao+") !");
							frm.txtTotalAulas.value = "";
							frm.txtTotalAulas.focus();
						} else {
						
							if (totalAulas!="1" && saldoDisponivelFuncao!="1"){
								if (!totalAulas || !chSemanal || totalAulas % chSemanal !== 0) {
									alert("O número de aulas deve ser " + chSemanal + " ou um múltiplo dele.");
									frm.txtTotalAulas.value = "";
									frm.txtTotalAulas.focus();
									return false;
								}
							}
						}
					}
				}
				var totalAulas = frm.txtTotalAulas.value;
				var strChecaTurnoIntegral = frm.txtChecaTurnoII.value;
				if (totalAulas=="") totalAulas = 0;
				
				if (strChecaTurnoIntegral != 'II'){ 
					if( parseInt(totalAulas) > 1  && frm.optTipoLancamento[1].checked ){
						alert("O Aulas (entradas) não pode ser maior que 1!");
						frm.txtTotalAulas.value = "";
						frm.txtTotalAulas.focus();
						return false		
					}
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
				frm.txtTotalAulas.value = "";
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
	function gerarImpressaoSub(CodSubstituicao){
		window.open("ColaboradorSubstitutoModulacao_rel.asp?CodSubstituicao="+CodSubstituicao,"abreConsulta","top=5,left=5,height=600,width=800,menubar=no,toolbar=no,scrollbars=yes,status=yes");
		return false	
	}
	
	function autorizar(intCodigo, acao){
		var frm = document.getElementById("frm");
	
		var justificativa = document.getElementById("txtJustificativa" + intCodigo).value;
		if (acao=="A"){
			if(confirm("Deseja Autorizar essa modulação?")) {
				frm.action="ModulacaoNovo_cod.asp?acao=AUTORIZAR&txtCodigo=" + intCodigo + "&txtJustificativa=" + justificativa;
				frm.submit();
				return true;
			}			
		}
		if (acao=="E"){
			
			if (justificativa==""){
				alert("A justificativa deve ser informada!")
				return false;
			}
		
			frm.action="ModulacaoNovo_cod.asp?acao=NAO_AUTORIZAR&txtCodigo=" + intCodigo + "&txtJustificativa=" + justificativa;
			frm.submit();
			return true;
		}
	}
	function consultarModulacao(){
		window.location="ModulacaoNovoAutorizar_con.asp";
	}
</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 