<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 02/08/2015
	::	Desenvolvedores...: Sergio Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Notas 
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	gravaMedia			= Trim(Request("media"))
	strPaginaRetorno	= Trim(Request.Form("txtPaginaRetorno"))
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	intCodCurso	 		= Trim(Request("txtCurso"))
	intCodPeriodo 		= Trim(Request("txtPeriodo"))
	strAtivos           = trim(request("cmbativos"))
	intSemestre 		= Trim(Request.Form("cmbSemestre"))
	strAnoLetivo 		= Trim(Request.Form("txtAnoLetivo"))
	strTipoNota 		= Trim(Request.Form("chkTipoNota"))
	intCodDisciplina	= Trim(Request.Form("cmbDisciplinaTurma"))

		'verifica se o usuario é professor ou admnistrativo
	sql = "select codigo "
	sql = sql & " from SRH_COLABORADOR"
	sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
	sql = sql & " and codLotacao= " & Session("CodEmpresa")
	sql = sql & " and (CodCategoria = 1)"'professor
	sql = sql & " and Situacao = 'A'"'ativo
	rs.open sql, cnn
	if rs.eof then
		strTipoAcessoCadastroNotas = "ADM"
	else
		strTipoAcessoCadastroNotas = "PROF"
	end if
	rs.close
	
	if strTipoAcessoCadastroNotas = "ADM" then
		intCodDisciplina	= Trim(Request.Form("cmbDisciplinaTurma"))
		intCodTurma 		= Trim(Request.Form("cmbTurma"))
	elseif strTipoAcessoCadastroNotas = "PROF" then
		intCodDisciplina	= Trim(Request.Form("cmbDisciplinaDoProfessor"))
		intCodTurma 			= Trim(Request("cmbTurmaProfessor"))
	end if
	
	
	'carrega campos
	sql = "SELECT  posicao, descricao, formula, digitar, bimestre as tipo, tipo_bimestre "
	sql = sql & " FROM SCA_TIPO_AVALIACAO_Planilha "
	sql = sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
	sql = sql & " AND 	COD_CURSO = " & intCodCurso
	sql = sql & " AND tipo_bimestre = " & strTipoNota
	sql = sql & " order by posicao"
	vetCampo = null
	rs.open sql, cnn
	if not rs.eof then
		vetCampo = rs.getRows
	end if
	rs.close
	
	dim C(30)
	
	intQtdeLancamento = request.form("qtdeAluno")
	
	cnn.begintrans
	
	for i=1 to intQtdeLancamento
		for j=0 to ubound(vetCampo,2)
			C(j)  = replace(request.form("txtNota_"&i&"_0"&j),".",",")
			if trim(C(j)) = "" then C(j) = -1
		next
		
		strCodAluno				= request.form("txtCodAluno_"&i)
		strCodNota 				= request.form("txtCodAlunoNota_"&i)
		strCodAlunoDisciplina 	= request.form("txtCodAlunoDisciplina_"&i)
		
		C1   = 0 
		C2   = 0
		C3   = 0
		C4   = 0
		C5   = 0
		C6   = 0
		C7   = 0
		C8   = 0
		C9   = 0
		C10  = 0
		C11  = 0
		C12  = 0
		C13  = 0
		C14  = 0
		C15  = 0
		C16  = 0 
		C17  = 0 
		C18  = 0 
		C19  = 0 
		C20  = 0 
		C21  = 0 
		C22  = 0 
		C23  = 0 
		C24  = 0 
		C25  = 0 
		C26  = 0 
		C27  = 0 
		C28  = 0 
		C29  = 0 
		C30  = 0 

		bolCalcularMediaExame 		= false
		bolCalcularMediaConselho 	= false
		strFormulaCalculoAnterior 	= ""
		strMediaFinal = ""

		SQL = "update SCA_NOTAS_PLANILHA set "
		for r=0 to ubound(vetCampo,2)
			strNota = C(r)
			strNotaTela = C(r)
			
			if trim(vetCampo(0,r)) = "1"   then  if strNota = -1 then C1   = 0 else C1  = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "2"   then  if strNota = -1 then C2   = 0 else C2  = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "3"   then  if strNota = -1 then C3   = 0 else C3  = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "4"   then  if strNota = -1 then C4   = 0 else C4  = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "5"   then  if strNota = -1 then C5   = 0 else C5  = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "6"   then  if strNota = -1 then C6   = 0 else C6  = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "7"   then  if strNota = -1 then C7   = 0 else C7  = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "8"   then  if strNota = -1 then C8   = 0 else C8  = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "9"   then  if strNota = -1 then C9   = 0 else C9  = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "10"  then  if strNota = -1 then C10  = 0 else C10 = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "11"  then  if strNota = -1 then C11  = 0 else C11 = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "12"  then  if strNota = -1 then C12  = 0 else C12 = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "13"  then  if strNota = -1 then C13  = 0 else C13 = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "14"  then  if strNota = -1 then C14  = 0 else C14 = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "15"  then  if strNota = -1 then C15  = 0 else C15 = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "16"  then  if strNota = -1 then C16  = 0 else C16 = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "17"  then  if strNota = -1 then C17  = 0 else C17 = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "18"  then  if strNota = -1 then C18  = 0 else C18 = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "19"  then  if strNota = -1 then C19  = 0 else C19 = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "20"  then  if strNota = -1 then C20  = 0 else C20 = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "21"  then  if strNota = -1 then C21  = 0 else C21 = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "22"  then  if strNota = -1 then C22  = 0 else C22 = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "23"  then  if strNota = -1 then C23  = 0 else C23 = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "24"  then  if strNota = -1 then C24  = 0 else C24 = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "25"  then  if strNota = -1 then C25  = 0 else C25 = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "26"  then  if strNota = -1 then C26  = 0 else C26 = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "27"  then  if strNota = -1 then C27  = 0 else C27 = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "28"  then  if strNota = -1 then C28  = 0 else C28 = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "29"  then  if strNota = -1 then C29  = 0 else C29 = cCur(strNota) end if end if
			if trim(vetCampo(0,r)) = "30"  then  if strNota = -1 then C30  = 0 else C30 = cCur(strNota) end if end if

			strComplemento = "0"	
			if cInt(vetCampo(0,r))>9 then strComplemento = ""


			'Busca Formula
			if trim(vetCampo(3,r)) = "N" then 
				strNota 		= replace(round(Eval(vetCampo(2,r)),1),",",".")
				if trim(strFormulaCalculoAnterior) = "" then strFormulaCalculoAnterior = vetCampo(2,r)
				
				if gravaMedia = "S" then
					strPosicaoNaMedia = "0"
					strComplementoMedia = "0"	
					'busca posição na media
					SQLMedia = "select posicao "
					SQLMedia = SQLMedia & " FROM	SCA_TIPO_AVALIACAO"
					SQLMedia = SQLMedia & " WHERE	COD_EMPRESA = " & Session("CodEmpresa")  
					SQLMedia = SQLMedia & " AND		COD_CURSO = " & intCodCurso 
					SQLMedia = SQLMedia & " AND		digitar = 'S'"
					SQLMedia = SQLMedia & " AND		bimestre = " & vetCampo(5,r)
					rsAux.open SQLMedia, cnn
					if not rsAux.eof then
						strPosicaoNaMedia = rsAux("posicao")
						if len(strPosicaoNaMedia)>1 then strComplementoMedia = ""
					end if
					rsAux.close
					
					if trim(strPosicaoNaMedia) <> "0" then
						strCodigoNaMedia = "0"
						SQLMedia = "select codigo from SCA_NOTAS_FALTAS "
						SQLMedia = SQLMedia & " where cod_empresa = "& Session("CodEmpresa")
						SQLMedia = SQLMedia & " and cod_aluno = "& strCodAluno
						SQLMedia = SQLMedia & " and cod_aluno_disciplina = " & strCodAlunoDisciplina
						SQLMedia = SQLMedia & " and cod_periodo = " & intCodPeriodo
						SQLMedia = SQLMedia & " and ano_letivo = " & strAnoLetivo
						SQLMedia = SQLMedia & " and semestre = " & intSemestre
						SQLMedia = SQLMedia & " and cod_disciplina = " & intCodDisciplina
						rsAux.open SQLMedia, cnn
						if not rsAux.eof then
							strCodigoNaMedia = rsAux("codigo")
						end if
						rsAux.close
					
						if strCodigoNaMedia = "0" then
							SQLMedia = "INSERT INTO SCA_NOTAS_FALTAS (cod_empresa, cod_aluno, cod_aluno_disciplina, cod_periodo, "
							SQLMedia = SQLMedia & "ano_letivo, semestre, cod_disciplina, nota01, falta01, nota02, falta02, nota03, falta03, nota04, falta04, nota05, falta05, nota06, falta06, nota07, falta07, nota08, falta08, nota09, falta09, nota10, falta10, nota11, falta11, nota12, falta12, nota13, falta13, nota14, falta14, nota15, falta15, situacao, media )  VALUES ("
							SQLMedia = SQLMedia & "" & Session("CodEmpresa")   & ","
							SQLMedia = SQLMedia & "" & strCodAluno & ","
							SQLMedia = SQLMedia & "" & strCodAlunoDisciplina & ","
							SQLMedia = SQLMedia & "" & intCodPeriodo & ","
							SQLMedia = SQLMedia & "" & strAnoLetivo & ","
							SQLMedia = SQLMedia & "" & intSemestre & ","
							SQLMedia = SQLMedia & "" & intCodDisciplina & ","
							SQLMedia = SQLMedia & "null,"
							SQLMedia = SQLMedia & "null,"
							SQLMedia = SQLMedia & "null,"
							SQLMedia = SQLMedia & "null,"
							SQLMedia = SQLMedia & "null,"
							SQLMedia = SQLMedia & "null,"
							SQLMedia = SQLMedia & "null,"
							SQLMedia = SQLMedia & "null,"
							SQLMedia = SQLMedia & "null,"
							SQLMedia = SQLMedia & "null,"
							SQLMedia = SQLMedia & "null,"
							SQLMedia = SQLMedia & "null,"
							SQLMedia = SQLMedia & "null,"
							SQLMedia = SQLMedia & "null,"
							SQLMedia = SQLMedia & "null,"
							SQLMedia = SQLMedia & "null,"
							SQLMedia = SQLMedia & "null,"
							SQLMedia = SQLMedia & "null,"
							SQLMedia = SQLMedia & "null,"
							SQLMedia = SQLMedia & "null,"
							SQLMedia = SQLMedia & "null,"
							SQLMedia = SQLMedia & "null,"
							SQLMedia = SQLMedia & "null,"
							SQLMedia = SQLMedia & "null,"
							SQLMedia = SQLMedia & "null,"
							SQLMedia = SQLMedia & "null,"
							SQLMedia = SQLMedia & "null,"
							SQLMedia = SQLMedia & "null,"
							SQLMedia = SQLMedia & "null,"
							SQLMedia = SQLMedia & "null,"
							SQLMedia = SQLMedia & "null,"
							SQLMedia = SQLMedia & "null)"
							cnn.execute SQLMedia
							GravarLog SQLMedia	
						end if
						
						'grava na media
						SQLMedia = "update SCA_NOTAS_FALTAS set "
						SQLMedia = SQLMedia & " nota" & strComplementoMedia & strPosicaoNaMedia & " = " & replace(strNota,",",".") & ""
						SQLMedia = SQLMedia & " where cod_empresa = "& Session("CodEmpresa")
						SQLMedia = SQLMedia & " and cod_aluno = "& strCodAluno
						SQLMedia = SQLMedia & " and cod_aluno_disciplina = " & strCodAlunoDisciplina
						SQLMedia = SQLMedia & " and cod_periodo = " & intCodPeriodo
						SQLMedia = SQLMedia & " and ano_letivo = " & strAnoLetivo
						SQLMedia = SQLMedia & " and semestre = " & intSemestre
						SQLMedia = SQLMedia & " and cod_disciplina = " & intCodDisciplina
						cnn.execute SQLMedia
						GravarLog SQLMedia	
					end if
				
				end if
			end if
			
			if strNota = -1 then
				SQL = SQL & "nota" & strComplemento & vetCampo(0,r) & " = null,"
			else
				SQL = SQL & "nota" & strComplemento & vetCampo(0,r) & " = " & replace(strNota,",",".") & ","
			end if
		next	
		SQL = SQL & " media=media"
		SQL = SQL & " where codigo = " & strCodNota
		cnn.execute SQL
		GravarLog sql		
		
	next	

	strParametro = "NotasPlanilhas_cad.asp?cmbPeriodo="&intCodPeriodo
	strParametro = strParametro & "&txtAnoLetivo="&strAnoLetivo
	strParametro = strParametro & "&cmbSemestre="&intSemestre
	strParametro = strParametro & "&cmbDisciplinaTurma="&intCodDisciplina
	strParametro = strParametro & "&cmbDisciplinaProfessorHorario="&intCodDisciplina
	strParametro = strParametro & "&cmbDisciplinaDoProfessor="&intCodDisciplina
	strParametro = strParametro & "&chkTipoNota="&strTipoNota
	strParametro = strParametro & "&cmbTurma="&intCodTurma
	strParametro = strParametro & "&cmbTurmaProfessor="&intCodTurma
	strParametro = strParametro & "&cmbCurso="&intCodCurso
	strParametro = strParametro & "&cmbativos="&strAtivos			
	strMsnAlert = "Nota"
	
	if err.number = 0 then
		'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			aguarde.style.display="none";
		</script>
		<script>
			alert("<%=strMsnAlert%> registrada com sucesso.	");
			window.location ='<%=strParametro%>';
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			aguarde.style.display="none";
		</script>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if

%>