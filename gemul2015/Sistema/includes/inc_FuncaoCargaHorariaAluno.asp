<!--
	::	SIGE
	::	Data de Criação...: 03/08/2005
	::	Desenvolvedores...: Roberto Júnior - roberto.junior@see.go.gov.br
	::	Objetivo Pagina...: 
		'seleciona o somatório das cargas horárias daS DISCIPLINAS DA matriz curricular
		'menos as disciplinas cadastradas para o aluno como aproveitamento de estudo	
		
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<%
'formata a data para inserir no Banco de Dados
function cargaHorariaAluno(intCodSerie, intCodTurno, intCodSemetre, strCodAluno)
	dim rsAuxCH
	set rsAuxCH = server.CreateObject("adodb.recordset")
	
	'seleciona o somatório das cargas horárias daS DISCIPLINAS DA matriz curricular
	'menos as disciplinas cadastradas para o aluno como aproveitamento de estudo
	sql="SELECT sum(APE_qd_curricular_disciplina.carga_horaria) as total"
	sql=sql & " FROM APE_qd_curricular_disciplina"
	sql=sql & " WHERE APE_qd_curricular_disciplina.codigo_sia_unid_ensino=" & session("strCodigoSia")
	sql=sql & " AND APE_qd_curricular_disciplina.codigo_ape_serie=" & intCodSerie
	sql=sql & " AND APE_qd_curricular_disciplina.codigo_sia_turno=" & intCodTurno
	sql=sql & " AND APE_qd_curricular_disciplina.ano_letivo=" & session("strAnoLetivo")
	sql=sql & " AND APE_qd_curricular_disciplina.SEMESTRE=" & intCodSemetre
	sql=sql & " AND APE_qd_curricular_disciplina.codigo_ape_disciplina"
	sql=sql & " Not In ("
	
	sql=sql & " 	SELECT APE_disciplina_optativa.codigo_ape_disciplinas"
	sql=sql & " 	FROM APE_disciplina_optativa"
	sql=sql & " 	WHERE APE_disciplina_optativa.codigo_sia_unid_ensino=" & session("strCodigoSia")
	sql=sql & " 	AND APE_disciplina_optativa.ano_letivo=" & session("strAnoLetivo")
	sql=sql & " 	AND APE_disciplina_optativa.codigo_ape_serie=" & intCodSerie 
	sql=sql & " 	AND APE_disciplina_optativa.semestre=" & intCodSemetre
	sql=sql & " 	AND APE_disciplina_optativa.codigo_ave_aluno_ano_letivo=" & strCodAluno
	sql=sql & " 	AND APE_disciplina_optativa.data_aproveitamento is not null"
	
	sql=sql & " )"
	rsAuxCH.open sql, cnn
	
	if rsAuxCH.eof = false then
		if isnull(rsAuxCH("total")) = false then
			cargaHorariaAluno = rsAuxCH("total")
		else
			cargaHorariaAluno=0
		end if	
	else
		cargaHorariaAluno=0
	end if
	
	rsAuxCH.close
	
end function

%>
