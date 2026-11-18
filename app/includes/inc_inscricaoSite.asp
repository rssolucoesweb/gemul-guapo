<%
	'---------------------------------------------------------------------
	' Inscrição no SITE DA MATRÍCULA para o mesmo aluno (MAT_RESERVA)
	' Usado pela TIP e pela Renovação: se o aluno já tem solicitação de matrícula pelo site
	' para o ano de destino, a TIP/renovação é bloqueada.
	'
	' O aluno da rede é o mesmo da inscrição quando:
	'   - a inscrição já está ligada a ele (MAT_RESERVA.cod_aluno), ou
	'   - o CPF é o mesmo (SCA_ALUNO.CPFALUNO ou SCA_ALUNO.CPF), ou
	'   - nome (sem diferença de acento/maiúscula) e data de nascimento são os mesmos.
	' Inscrição excluída (data_exc_cadastro preenchida) não conta.
	'
	' Desempenho: primeiro lê CPF, nome e nascimento do aluno; depois procura em MAT_RESERVA com
	' valores fixos (cada condição usa índice: cod_aluno, cpf, data_nascimento).
	'
	' inscricaoSiteDoAluno(código do aluno, ano de destino) = texto para a mensagem | "" = não tem
	'---------------------------------------------------------------------
	function inscricaoSiteDoAluno(ByVal codAluno, ByVal anoDestino)
		dim rsIs, s, cpf, nome, nasc, nascIso
		inscricaoSiteDoAluno = ""
		if not isnumeric(codAluno & "") or not isnumeric(anoDestino & "") then exit function
		if clng(codAluno) = 0 or clng(anoDestino) = 0 then exit function

		set rsIs = cnn.Execute("SELECT REPLACE(REPLACE(ISNULL(NULLIF(LTRIM(CPFALUNO), ''), CPF), '.', ''), '-', '') AS CPF, NOMEALUNO, DATANASCIMENTO FROM SCA_ALUNO WHERE CODIGO = " & clng(codAluno))
		cpf = "" : nome = "" : nascIso = ""
		if not rsIs.eof then
			cpf = trim(rsIs("CPF") & "")
			nome = replace(trim(rsIs("NOMEALUNO") & ""), "'", "''")
			if isdate(rsIs("DATANASCIMENTO")) then nasc = cdate(rsIs("DATANASCIMENTO")) : nascIso = year(nasc) & right("0" & month(nasc), 2) & right("0" & day(nasc), 2)
		end if
		rsIs.close
		if len(cpf) <> 11 or not isnumeric(cpf) then cpf = ""

		s = "SELECT TOP 1 R.inscricao, R.data_hora_incl, E.RAZAOSOCIAL FROM ("
		s = s & " SELECT codigo FROM MAT_RESERVA WHERE cod_aluno = " & clng(codAluno) & " AND ano = " & clng(anoDestino) & " AND data_exc_cadastro IS NULL"
		if cpf <> "" then s = s & " UNION SELECT codigo FROM MAT_RESERVA WHERE cpf = '" & cpf & "' AND ano = " & clng(anoDestino) & " AND data_exc_cadastro IS NULL"
		if nascIso <> "" and nome <> "" then
			s = s & " UNION SELECT codigo FROM MAT_RESERVA WHERE data_nascimento = '" & nascIso & "' AND ano = " & clng(anoDestino) & " AND data_exc_cadastro IS NULL"
			s = s & " AND LTRIM(RTRIM(nome)) COLLATE Latin1_General_CI_AI = '" & nome & "' COLLATE Latin1_General_CI_AI"
		end if
		s = s & " ) X INNER JOIN MAT_RESERVA R ON R.codigo = X.codigo"
		s = s & " LEFT JOIN SEG_EMPRESA E ON E.CODIGO = R.CODEMPRESA"	'Guapó: a inscrição guarda a unidade em CODEMPRESA
		s = s & " ORDER BY R.codigo DESC"
		set rsIs = cnn.Execute(s)
		if not rsIs.eof then
			inscricaoSiteDoAluno = "inscrição nº " & trim(rsIs("inscricao") & "")
			if isdate(rsIs("data_hora_incl")) then inscricaoSiteDoAluno = inscricaoSiteDoAluno & " de " & right("0" & day(rsIs("data_hora_incl")), 2) & "/" & right("0" & month(rsIs("data_hora_incl")), 2) & "/" & year(rsIs("data_hora_incl"))
			if trim(rsIs("RAZAOSOCIAL") & "") <> "" then inscricaoSiteDoAluno = inscricaoSiteDoAluno & ", 1ª opção " & trim(rsIs("RAZAOSOCIAL") & "")
		end if
		rsIs.close
		set rsIs = nothing
	end function
%>
