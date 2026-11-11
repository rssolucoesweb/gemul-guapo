<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	codEmpresaUsuario = request.Form("cmdEmpresaUsuario")
	strAnoLetivo = request.Form("txtAno")
		
	' --professor
	SQL = "insert into gemul5.dbo.FUNCIONARIOS (CODI_EMP, CODI_FUNC, NOME_FUNC, EXCLUIDO, MATRICULA_FP, SEXO, CPF, MATRICULA_CRACHA, DATA_UPDATE)"
	SQL = SQL & " select "
	SQL = SQL & " 1 AS CODI_EMP,"
	SQL = SQL & " MIN(CODFUNCIONAL) AS CODI_FUNC,"
	SQL = SQL & " NOME AS NOME_FUNC,"
	SQL = SQL & " 'N' AS EXCLUIDO,"
	SQL = SQL & " MIN(CODFUNCIONAL) AS MATRICULA_FP,"
	SQL = SQL & " SEXO,"
	SQL = SQL & " CPF,"
	SQL = SQL & " MIN(CODFUNCIONAL) AS MATRICULA_CRACHA,"
	SQL = SQL & " GETDATE() AS DATA_UPDATE"
	SQL = SQL & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE dd"
	SQL = SQL & " inner join srh_colaborador c on c.codigo=dd.cod_colaborador  "
	SQL = SQL & " inner join SEG_EMPRESA e on e.CODIGO = dd.Cod_empresa  "
	SQL = SQL & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = dd.cod_funcao "
	SQL = SQL & " left join SCA_disciplina d on d.cod_disciplina = dd.cod_disciplina "
	SQL = SQL & " left join SRH_TURNO t on t.cod_turno = dd.cod_turno "
	SQL = SQL & " left join SCA_periodo p on p.cod_periodo = dd.cod_periodo "
	SQL = SQL & " where dd.ano_letivo = " & strAnoLetivo
	SQL = SQL & " and dd.status = 'A' "
	SQL = SQL & " and e.CODIGO=" & codEmpresaUsuario
	SQL = SQL & " AND C.CODFUNCIONAL<>0"
	SQL = SQL & " AND C.CODFUNCIONAL NOT IN (SELECT CODI_FUNC FROM gemul5.dbo.FUNCIONARIOS)"
	SQL = SQL & " GROUP BY NOME, SEXO, CPF"
	cnn.execute sql
	GravarLog sql

	
	'--funcionario
	SQL = " insert into gemul5.dbo.FUNCIONARIOS (CODI_EMP, CODI_FUNC, NOME_FUNC, EXCLUIDO, MATRICULA_FP, SEXO, CPF, MATRICULA_CRACHA, DATA_UPDATE)"
	SQL = SQL & " select DISTINCT"
	SQL = SQL & " 1 AS CODI_EMP,"
	SQL = SQL & " MIN(C.CODFUNCIONAL) AS CODI_FUNC,"
	SQL = SQL & " NOME AS NOME_FUNC,"
	SQL = SQL & " 'N' AS EXCLUIDO,"
	SQL = SQL & " MIN(C.CODFUNCIONAL) AS MATRICULA_FP,"
	SQL = SQL & " SEXO,"
	SQL = SQL & " CPF,"
	SQL = SQL & " MIN(C.CODFUNCIONAL) AS MATRICULA_CRACHA,"
	SQL = SQL & " GETDATE() AS DATA_UPDATE"
	SQL = SQL & " from srh_colaborador C"
	SQL = SQL & " inner join SEG_EMPRESA e on e.CODIGO = C.CodLOTACAO"
	SQL = SQL & " where C.SITUACAO = 'A' "
	SQL = SQL & " and e.CODIGO = " & codEmpresaUsuario
	SQL = SQL & " AND C.CODFUNCIONAL<>0"
	SQL = SQL & " AND C.CODFUNCIONAL NOT IN (SELECT CODI_FUNC FROM gemul5.dbo.FUNCIONARIOS)"
	SQL = SQL & " GROUP BY C.CodLOTACAO,NOME, SEXO, CPF"
	cnn.execute sql
	GravarLog sql

	
	'--coletor PROFESSOR
	SQL = " INSERT GEMUL5.DBO.FUNC_COLETOR"
	SQL = SQL & " select distinct 1, C.CODFUNCIONAL, DD.COD_EMPRESA, NULL, 0,0,0,0,0,0,1,NULL,NULL"
	SQL = SQL & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE DD"
	SQL = SQL & " inner join srh_colaborador c on c.codigo=dd.cod_colaborador "
	SQL = SQL & " INNER join gemul5.dbo.FUNCIONARIOS FF ON FF.CODI_FUNC = c.codfuncional"
	SQL = SQL & " INNER JOIN SRH_FUNCAOCOLABORADOR F ON F.Cod_Funcao = C.CODFUNCAO"
	SQL = SQL & " inner join SEG_EMPRESA e on e.CODIGO = dd.Cod_empresa  "
	SQL = SQL & " where dd.ano_letivo = " & strAnoLetivo
	SQL = SQL & " and dd.status = 'A' "
	SQL = SQL & " and e.CODIGO = " & codEmpresaUsuario
	SQL = SQL & " and isnull(C.CODFUNCIONAL,0)<>0"
	SQL = SQL & " AND F.MODULAR = 'N'"
	SQL = SQL & " AND C.CODFUNCIONAL NOT IN (SELECT CODI_FUNC FROM GEMUL5.DBO.FUNC_COLETOR WHERE CODI_COLE = " & codEmpresaUsuario & ")"
	cnn.execute sql
	GravarLog sql

	
	' --coletor FUNCIONARIO
	SQL = " INSERT GEMUL5.DBO.FUNC_COLETOR"
	SQL = SQL & " select distinct 1, C.CODFUNCIONAL, C.CodLOTACAO, NULL, 0,0,0,0,0,0,1,NULL,NULL"
	SQL = SQL & " from srh_colaborador c"
	SQL = SQL & " INNER join gemul5.dbo.FUNCIONARIOS FF ON FF.CODI_FUNC = c.codfuncional"
	SQL = SQL & " INNER JOIN SRH_FUNCAOCOLABORADOR F ON F.Cod_Funcao = C.CODFUNCAO"
	SQL = SQL & " inner join SEG_EMPRESA e on e.CODIGO = C.CodLOTACAO"
	SQL = SQL & " where C.SITUACAO = 'A' "
	SQL = SQL & " and e.CODIGO = " & codEmpresaUsuario
	SQL = SQL & " AND C.CODFUNCIONAL<>0"
	SQL = SQL & " AND F.MODULAR = 'N'"
	SQL = SQL & " AND C.CODFUNCIONAL NOT IN (SELECT CODI_FUNC FROM GEMUL5.DBO.FUNC_COLETOR WHERE CODI_COLE = " & codEmpresaUsuario & ")"
	cnn.execute sql
	GravarLog sql

	sql = "UPDATE f set DATA_UPDATE = getdate() "
	sql = sql & " from  gemul5.dbo.FUNCIONARIOS f"
	sql = sql & " inner join  gemul5.dbo.FUNC_COLETOR fc on fc.CODI_FUNC = f.CODI_FUNC"
	sql = sql & " WHERE fc.CODI_COLE = " & codEmpresaUsuario
	CNN.EXECUTE SQL
	GravarLog sql
	%>
	<script>
		alert("Atualização finaliza com sucesso!");
		window.location='AtualizaDataPonto_con.asp';
	</script>
