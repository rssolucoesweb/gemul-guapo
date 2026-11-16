<%
	'---------------------------------------------------------------------
	' Recarrega na sessão o ano letivo, semestre e regime da unidade,
	' com a mesma regra do login (login/selecionar_escola.asp):
	'	ano escolhido pelo usuário (Session("strAnoLetivoEscolhido")), se houver;
	'	semestre e notificações da SEG_ENCERRAMENTOATIVIDADES desse ano
	'	(sem cadastro do ano na unidade: configuração do ano mais recente).
	' Usada pela troca de ano dentro dos módulos (login/trocar-ano-letivo.asp?volta=).
	'---------------------------------------------------------------------
	sub carregaAnoLetivoSessao(ByVal codEmpresa)
		dim rsAL, s, anoEscolhido, semestre, tipoSeriacao
		if trim(codEmpresa & "") = "" or not isnumeric(codEmpresa & "") then exit sub
		codEmpresa = clng(codEmpresa)
		anoEscolhido = 0
		if isnumeric(Session("strAnoLetivoEscolhido") & "") and trim(Session("strAnoLetivoEscolhido") & "") <> "" then anoEscolhido = clng(Session("strAnoLetivoEscolhido"))

		set rsAL = Server.CreateObject("adodb.recordset")
		s = "SELECT TOP 1 ano_letivo, semestre FROM SEG_ENCERRAMENTOATIVIDADES WHERE cod_empresa = " & codEmpresa
		s = s & " ORDER BY CASE WHEN ano_letivo = " & anoEscolhido & " THEN 0 ELSE 1 END, ano_letivo DESC"
		rsAL.open s, cnn
		if not rsAL.eof then
			Session("strAnoLetivo") = rsAL("ano_letivo")
			semestre = trim(rsAL("semestre") & "")
		end if
		rsAL.close
		if anoEscolhido > 0 then Session("strAnoLetivo") = anoEscolhido
		if semestre = "" then semestre = "3"
		Session("strSemestre") = semestre
		Session("strTodosSemestre") = semestre
		Session("strDescSemestre") = "Não Informado"

		s = "SELECT TOP 1 tipo_seriacao FROM sca_regime WHERE cod_empresa = " & codEmpresa & " ORDER BY Cod_Regime DESC"
		rsAL.open s, cnn
		if not rsAL.eof then
			tipoSeriacao = trim(rsAL("tipo_seriacao") & "")
			if tipoSeriacao = "A" then
				Session("strSemestre") = "3"
				Session("strDescSemestre") = "Anual"
				Session("strTodosSemestre") = "3"
			elseif tipoSeriacao = "S" then
				if semestre = "1" then Session("strSemestre") = "1"
				if semestre = "2" then Session("strSemestre") = "2"
				Session("strTodosSemestre") = "1,2"
				Session("strDescSemestre") = semestre & "º Semestre"
			elseif tipoSeriacao = "AS" then
				if semestre = "1" then Session("strSemestre") = "1,3"
				if semestre = "2" then Session("strSemestre") = "2,3"
				Session("strTodosSemestre") = "1,2,3"
				Session("strDescSemestre") = "Anual/" & semestre & "º Semestre"
			end if
		end if
		rsAL.close
		set rsAL = nothing
	end sub
%>
