<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/05/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Cadastramento automatico de turmas - GRAVA
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%

'	on error resume next
	bolInsert 			= false		
	acao 				= Trim(Request.QueryString("acao"))
	strCod_empresa		= Session("CodEmpresa")
	strAnoLetivo 		= session("strAnoLetivo")
	strSemestre 		= session("strSemestre")
	strSiglaTurmaPeriodo= Trim(Request.Form("cmbSiglaTurmaPeriodo"))

	strTurmas      		= Trim(Request.Form("chkTurma"))
	vetTurmas			= split(strTurmas,",")
	strAnoLetivoDestino = Trim(Request.Form("txtAnoLetivo"))
	strSemestreDestino	= Trim(Request.Form("cmbSemestrePromocao"))
	
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	for i=0 to ubound(vetTurmas)
        
		'BUSCANDO DADOS DA TURMA ATUAL
		strCodCursoAtual 	= "0"
		strCodPeriodoAtual 	= "0"
		strSequenciaAtual 	= "0"
		strSequenciaDestino	= "0"
		strCodTurnoDestino 	= "0"
		strSalaDestino		= "0"
		strAnoDestino 		= "0"
		strNomeTurmaAtual	= "0"
					
		sql = "SELECT P.COD_CURSO, P.COD_PERIODO, P.SEQUENCIA, T.Cod_SemestreCriacao, T.COD_TURNO, T.SALA, T.ANO, T.NOMETURMA, "
		sql = sql & " T.capacidade, T.Cod_ContaCorrente,  T.Cod_FichaDescritiva"
		sql = sql & " FROM	SCA_GRADECURRICULAR G"
		sql = sql & " INNER	JOIN SCA_TURMA T 	ON T.COD_GRADECURRICULAR = G.COD_GRADECURRICULAR AND T.COD_EMPRESA = G.COD_EMPRESA"
		sql = sql & " INNER	JOIN SCA_PERIODO P 	ON P.COD_PERIODO = G.COD_PERIODO AND P.COD_EMPRESA = G.COD_EMPRESA"
		sql = sql & " WHERE	T.COD_TURMA		= " & vetTurmas(i)
		sql = sql & " AND	T.COD_EMPRESA	= " & strCod_empresa
		rs.open sql, cnn, 3, 3
		if not RS.EOF then	
			
			strCodCursoAtual 				= rs("COD_CURSO")
			strCodPeriodoAtual 				= rs("COD_PERIODO")
			strSequenciaAtual 				= rs("SEQUENCIA")
			strSequenciaDestino				= rs("SEQUENCIA")+1
			strSequenciaDestinoInicial		= rs("SEQUENCIA")
			strCodTurnoDestino 				= rs("COD_TURNO")
			strSalaDestino 					= rs("SALA")
			strAnoDestino 					= rs("ANO")
			strSemestreCriacaoDestino 		= rs("Cod_SemestreCriacao")
			strNomeTurmaAtual				= rs("NOMETURMA")
			strCapacidadeDestino			= rs("capacidade")
			strCodContaCorrenteDestino 		= rs("Cod_ContaCorrente")
			strCodFichaDescritivaDestino 	= rs("Cod_FichaDescritiva")
			if isnull(strCodContaCorrenteDestino) or strCodContaCorrenteDestino = "" then strCodContaCorrenteDestino = "0"
			if isnull(strCodFichaDescritivaDestino) or strCodFichaDescritivaDestino = "" then strCodFichaDescritivaDestino = "0"
			
		end if
		rs.close	
		
		strCodPeriodoDestino = "0"
		'BUSCA DADOS PARA O PROXIMO PERIODO	
		sql = "select COD_PERIODO"
		sql = sql & " from SCA_PERIODO"
		sql = sql & " WHERE	COD_EMPRESA	= " & strCod_empresa
		sql = sql & " AND		COD_CURSO = " & strCodCursoAtual
		sql = sql & " AND		SEQUENCIA = " & strSequenciaDestino
		rs.open sql, cnn, 3, 3
		if not RS.EOF then	
			strCodPeriodoDestino = rs("COD_PERIODO")
		end if
		rs.close	
        
		strNomeTurmaDestino = left(strNomeTurmaAtual,2) & strSequenciaDestino & right(strNomeTurmaAtual,6)		
		
		if trim(strCodPeriodoDestino) = "0" then
			%>
			<script>
				alert("ATENÇÃO: Não existe período cadastrado para turma: <%=strNomeTurmaDestino%>.");
			</script>
			<%
		end if
		bolExiteTurma = false
		'VERIFICA SE A TURMA JÁ FOI CADASTRADA
		sql = "select NomeTurma, Cod_Semestre, AnoLetivo"
		sql = sql & " FROM	SCA_TURMA "
		sql = sql & " WHERE	NOMETURMA	= '" & strNomeTurmaDestino & "'"
		sql = sql & " AND COD_EMPRESA	= " & strCod_empresa
		sql = sql & " AND Cod_Semestre = " & strSemestreDestino
		sql = sql & " AND AnoLetivo = " & strAnoLetivoDestino
		rs.open sql, cnn, 3, 3
		if not RS.EOF then	
			bolExiteTurma = true
		end if
		rs.close	

		if bolExiteTurma then
			%>
			<script>
				alert("ATENÇÃO: Turma <%=strNomeTurmaDestino%> já para o ano letivo / semestre.");
			</script>
			<%
		end if		
		
		strCodGradeDestino = "0"
		'BUSCANDO DADOS DE DESTINO - GRADE
		sql = "SELECT G.Cod_GradeCurricular"
		sql = sql & " FROM	SCA_GRADECURRICULAR G"
		sql = sql & " INNER	JOIN SCA_PERIODO P 	ON P.COD_PERIODO = G.COD_PERIODO AND P.COD_EMPRESA = G.COD_EMPRESA"
		sql = sql & " WHERE	P.COD_PERIODO 	= " & strCodPeriodoDestino
		sql = sql & " AND	P.COD_EMPRESA	= " & strCod_empresa
		sql = sql & " AND	G.Situacao = 'A'"
		sql = sql & " order by G.Cod_GradeCurricular desc "   ' Pego a ultima grade ativa
		rs.open sql, cnn, 3, 3
		if not RS.EOF then	
			strCodGradeDestino 	= rs("Cod_GradeCurricular")
		end if
		rs.close	
		if strCodGradeDestino <> "0" then

			sql = "SELECT  Cod_Turma "
			sql = sql & " FROM	SCA_TURMA "
			sql = sql & " WHERE	NOMETURMA	= '" & strNomeTurmaDestino & "'"
			sql = sql & " AND COD_EMPRESA	= " & strCod_empresa
		    sql = sql & " AND Cod_Semestre = " & strSemestreDestino
		    sql = sql & " AND AnoLetivo = " & strAnoLetivoDestino
			rs.open sql, cnn, 3, 3
			if RS.EOF then	

				sql = "Insert Into SCA_TURMA(Cod_Empresa, Cod_GradeCurricular, Cod_Semestre, Cod_Turno, Cod_periodo, " 
				sql = sql & " NomeTurma, Sala, Ano, Capacidade, AnoLetivo, Cod_SemestreCriacao, Cod_ContaCorrente, Situacao)"
				sql = sql & " Values ("
				sql = sql & "" & strCod_empresa & ","
				sql = sql & "" & strCodGradeDestino & ","
				sql = sql & "" & strSemestreDestino & ","
				sql = sql & "" & strCodTurnoDestino & ","
				sql = sql & "" & strCodPeriodoDestino & ","
				sql = sql & "'" & strNomeTurmaDestino & "',"
				sql = sql & "" & strSalaDestino & ","
				sql = sql & "" & strAnoDestino & ","
				sql = sql & "" & strCapacidadeDestino & ","
				sql = sql & "" & strAnoLetivoDestino & ","
				sql = sql & "" & strSemestreCriacaoDestino & ","
				sql = sql & "" & strCodContaCorrenteDestino & ","
				sql = sql & "'A')"
						
				cnn.execute SQL
				GravarLog sql	

				bolInsert = true	
	
			end if
			rs.close
        else
		
			%>
			<script>
				alert("ATENÇÃO: Grade inexistente para a turma <%=strNomeTurmaDestino%>. Verifique!");
			</script>
			<%
		end if
		
		if  TRIM(left(strNomeTurmaAtual,3)) = trim(strSiglaTurmaPeriodo) then 
		
				
			strCodPeriodoDestinoInicial = "0"
			'BUSCA DADOS PARA O PROXIMO PERIODO	
			sql = "select COD_PERIODO"
			sql = sql & " from SCA_PERIODO"
			sql = sql & " WHERE	COD_EMPRESA	= " & strCod_empresa
			sql = sql & " AND		COD_CURSO = " & strCodCursoAtual
			sql = sql & " AND		SEQUENCIA = " & strSequenciaDestinoInicial
			rs.open sql, cnn, 3, 3
			if not RS.EOF then	
				strCodPeriodoDestinoInicial = rs("COD_PERIODO")
			end if
			rs.close	
			
			strNomeTurmaDestino = left(strNomeTurmaAtual,2) & strSequenciaDestinoInicial & right(strNomeTurmaAtual,6)		
			
			if trim(strCodPeriodoDestinoInicial) = "0" then
				cnn.rollbackTrans
				%>
				<script>
					alert("ATENÇÃO: Não existe período cadastrado para turma: <%=strNomeTurmaDestino%>.");
				</script>
				<%
				response.end
			end if
	 
			strCodGradeDestinoInicial = "0"
			'BUSCANDO DADOS DE DESTINO - GRADE
			sql = "SELECT G.Cod_GradeCurricular"
			sql = sql & " FROM	SCA_GRADECURRICULAR G"
			sql = sql & " INNER	JOIN SCA_PERIODO P 	ON P.COD_PERIODO = G.COD_PERIODO AND P.COD_EMPRESA = G.COD_EMPRESA"
			sql = sql & " WHERE	P.COD_PERIODO 	= " & strCodPeriodoDestinoInicial
			sql = sql & " AND	P.COD_EMPRESA	= " & strCod_empresa
			sql = sql & " AND	G.Situacao = 'A'"
			sql = sql & " order by G.Cod_GradeCurricular desc "   ' Pego a ultima grade ativa
			rs.open sql, cnn, 3, 3
			if not RS.EOF then	
				strCodGradeDestinoInicial 	= rs("Cod_GradeCurricular")
			end if
			rs.close	

			if strCodGradeDestinoInicial = "0" then
				cnn.rollbackTrans
				%>
				<script>
					alert("ATENÇÃO: Não existe período cadastrado para turma: <%=strNomeTurmaDestino%>.");
				</script>
				<%
				response.end
			end if
	
			strNomeTurmaDestino = left(strNomeTurmaAtual,7) & right(strAnoLetivoDestino,2)

			'VERIFICA SE A TURMA JÁ FOI CADASTRADA
			sql = "select NomeTurma, Cod_Semestre, AnoLetivo"
			sql = sql & " FROM	SCA_TURMA "
			sql = sql & " WHERE	NOMETURMA	= '" & strNomeTurmaDestino & "'"
			sql = sql & " AND COD_EMPRESA	= " & strCod_empresa
			sql = sql & " AND Cod_Semestre = " & strSemestreDestino
			sql = sql & " AND AnoLetivo = " & strAnoLetivoDestino
			rs.open sql, cnn, 3, 3
			if RS.EOF then	
			
				sql = "Insert Into SCA_TURMA(Cod_Empresa, Cod_GradeCurricular, Cod_Semestre, Cod_Turno, Cod_periodo, " 
				sql = sql & " NomeTurma, Sala, Ano, Capacidade, AnoLetivo, Cod_SemestreCriacao, Cod_ContaCorrente, Situacao)"
				sql = sql & " Values ("
				sql = sql & "" & strCod_empresa & ","
				sql = sql & "" & strCodGradeDestinoInicial & ","
				sql = sql & "" & strSemestreDestino & ","
				sql = sql & "" & strCodTurnoDestino & ","
				sql = sql & "" & strCodPeriodoDestinoInicial & ","
				sql = sql & "'" & strNomeTurmaDestino & "',"
				sql = sql & "" & strSalaDestino & ","
				sql = sql & "" & strAnoDestino & ","
				sql = sql & "" & strCapacidadeDestino & ","
				sql = sql & "" & strAnoLetivoDestino & ","
				sql = sql & "" & strSemestreCriacaoDestino & ","
				sql = sql & "" & strCodContaCorrenteDestino & ","
				sql = sql & "'A')"
	
				cnn.execute SQL
				GravarLog sql

				bolInsert = true
						
			else
				%>
				<script>
					alert("ATENÇÃO: Turma Inicial <%=strNomeTurmaDestino%> já para o ano letivo / semestre.");
				</script>
				<%     
			end if		
			rs.close
		end if		

		
	next
	
	if bolInsert then
		strMensagem = "Turma(s) incluida(s) automaticamento com sucesso..."
	else
		strMensagem = "ATENÇÃO: Não foram incluidas turmas nesse processamento."
	end if
			
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='TurmaAutomatica_cad.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			alert('<%=replace(err.description,"'","")%>');
			window.history.back();
		</script>
		<%
	end if
%>