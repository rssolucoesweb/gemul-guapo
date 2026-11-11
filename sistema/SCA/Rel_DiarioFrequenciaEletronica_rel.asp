<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
SESSION.Timeout = 1200
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 08/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Diário de frequencia Eletronica
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file=../../includes/inc_aguarde.asp-->
<script src="../../js/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<%
	
	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
	end if
	strQtdeFaltas = request("cmbQtdeFaltas")
	strMes		 		= Trim(Request("cmbMes"))	
    
	
	if strMes = "12" then
	   qtdeDiasMes  = "31"
	else   
		aux=Cdate("01/" & cInt(ZEROLEFT(strMes,2))+1 & "/" & cInt(strAnoLetivo)) - 1
	    qtdeDiasMes = day(aux)
	end if	
	
	'GRAVANDO NO ARQUIVO DE NOTAS
	strGravarOnde = "NOTA"
	msnHistorico  = ""
		
	if  Trim(Request("cmbTurma")) <> "" then
		intCodTurma 			= Trim(Request("cmbTurma"))
		intCodTurmaProfessor	= Trim(Request("cmbTurma"))
	else
		intCodTurma				= Trim(Request("cmbTurmaProfessor"))
		intCodTurmaProfessor	= Trim(Request("cmbTurmaProfessor"))
	end if
	
	if  Trim(Request("cmbDisciplinaTurma")) <> "" then
		intCodDisciplina			= Trim(Request("cmbDisciplinaTurma"))
		intCodDisciplinaTurma		= Trim(Request("cmbDisciplinaTurma"))
	else
		intCodDisciplina			 = Trim(Request("cmbDisciplinaDoProfessor"))
		intCodDisciplinaTurma		 = Trim(Request("cmbDisciplinaDoProfessor"))
	end if
	if intCodTurma = "" then intCodTurma = "0"
	if intCodTurmaProfessor = "" then intCodTurmaProfessor = "0"
	if intCodDisciplina = "" then intCodDisciplina = "0"
	if intCodDisciplinaTurma = "" then intCodDisciplinaTurma = "0"
	
	intCodCurso	 				= Trim(Request("cmbCurso"))
	intCodPeriodo 				= Trim(Request("cmbPeriodo"))
	intSemestre 				= Trim(Request("cmbSemestre"))
	intCodEstagio     			= Trim(Request.Form("cmbEstagio"))
	strMostraConteudo 		    = Trim(Request.Form("mostraConteudo"))
	
	intCodTurno		 			= Trim(Request("cmbTurno"))
	strAlunos      				= Trim(Request("chkAluno"))
	intCodTipoNota				= Trim(Request("chkTipoNota"))
	intCodTipoLancamento		= Trim(Request("cmbTipoLancamento")) '"0" '-->Nota e Falta | "1" '-->Somente Nota	| "2" '-->Somente Falta		
	strNomeNota 		= ""
	strNomeTipoBimestre = ""
	strPosicao 			= ""
    
	if intSemestre = "3" then 
	   msgSemestre = ""
	else   
	   msgSemestre = "/"& intSemestre
	end if   
	strTituloRelatorio ="Di&aacute;rio de Frequência <br> Referência: " &ucase(monthName(strMes)) & " - " & strAnoLetivo & msgSemestre

	
	strNomedisciplina = ""
	sql = "SELECT DESC_DISCIPLINA FROM SCA_DISCIPLINA"
	sql = sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
	sql = sql & " AND	COD_DISCIPLINA = " & intCodDisciplina
	rs.open sql, cnn
	if not rs.eof then
		strNomedisciplina = rs("DESC_DISCIPLINA")
	end if
	rs.close
	
	sql = "SELECT DISTINCT SRH_COLABORADOR.NOME AS COLABORADOR"
	sql = sql & " FROM SCA_HORARIO_AULA"
	sql = sql & " INNER JOIN SRH_COLABORADOR ON SRH_COLABORADOR.CODIGO = SCA_HORARIO_AULA.COD_COLABORADOR"
	sql = sql & " WHERE	SCA_HORARIO_AULA.ANOLETIVO=" & strAnoLetivo
	sql = sql & " AND		SCA_HORARIO_AULA.SEMESTRE=" & intSemestre
	sql = sql & " AND		SCA_HORARIO_AULA.COD_TURMA=" & intCodTurma
	sql = sql & " AND		SCA_HORARIO_AULA.COD_DISCIPLINA=" & intCodDisciplinaTurma
	rs.open sql, cnn
	if not rs.eof then 
		strProfessor = RS("COLABORADOR")
	else
		strProfessor = "PROFESSOR(A) NÃO INFORMADO NO HORÁRIO DE AULA"
	end if
	rs.close

    if intCodEstagio <> "0" then
		sql = "SELECT E.Ano, E.Semestre, E.Descricao as Grupo, C.nome as Orientador"
		sql = sql & " FROM SCA_ESTAGIO E"
		sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.CODIGO = E.COD_COLABORADOR " 
		sql = sql & " And E.codigo = " & intCodEstagio
		rs.open sql, cnn
		if rs.eof = false then
			strGrupo = rs("grupo")   
			strSupervisor = rs("Orientador")
		end if
		rs.close	
    end if
	
	sql="SELECT CODIGO, DESCRICAO, POSICAO, BIMESTRE"
	sql=sql & " FROM  SCA_TIPO_AVALIACAO"
	sql=sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
	sql=sql & " AND		CODIGO = " & intCodTipoNota
	rs.open sql, cnn
	if rs.eof = false then
		strNomeTipoBimestre 	= trim(rs("bimestre")) & "º Bimestre"
		strCodBimestre			= trim(rs("bimestre"))
		if trim(rs("bimestre")) = "5" then
			strNomeTipoBimestre = "Exame Final"		
			strNotaDoTipoEF		= "S"
		end if
		if trim(rs("bimestre")) = "6" then
			strNomeTipoBimestre = "Cons. Classe"		
		end if

		strNomeNota			 	= rs("DESCRICAO")
		strPosicao 				= ZeroLeft(rs("POSICAO"),2)
	end if
	rs.close
	
	strPosicaoNotas1Bim = "0"
	sql="Select TA.POSICAO "
	sql=sql & " from SCA_AVALIACAO A"
	sql=sql & " inner join SCA_CRITERIO_AVALIACAO CA ON CA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and CA.CODIGO = A.CODCRITERIOAVALIACAO"
	sql=sql & " inner join SCA_TIPO_AVALIACAO TA ON TA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and TA.CODIGO = A.CODTIPOAVALIACAO"
	sql=sql & " where A.cod_empresa = " & Session("CodEmpresa") 
	sql=sql & " and CA.cod_curso = " & intCodCurso
	sql=sql & " and TA.BIMESTRE = 1"
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			strPosicaoNotas1Bim = strPosicaoNotas1Bim & "," & rs("posicao")
			rs.movenext
		wend
	end if
	rs.close	
	strPosicaoNotas2Bim = "0"
	sql="Select TA.POSICAO "
	sql=sql & " from SCA_AVALIACAO A"
	sql=sql & " inner join SCA_CRITERIO_AVALIACAO CA ON CA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and CA.CODIGO = A.CODCRITERIOAVALIACAO"
	sql=sql & " inner join SCA_TIPO_AVALIACAO TA ON TA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and TA.CODIGO = A.CODTIPOAVALIACAO"
	sql=sql & " where A.cod_empresa = " & Session("CodEmpresa") 
	sql=sql & " and CA.cod_curso = " & intCodCurso
	sql=sql & " and TA.BIMESTRE = 2"
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			strPosicaoNotas2Bim = strPosicaoNotas2Bim & "," & rs("posicao")
			rs.movenext
		wend
	end if
	rs.close	
	strPosicaoNotas3Bim = "0"
	sql="Select TA.POSICAO "
	sql=sql & " from SCA_AVALIACAO A"
	sql=sql & " inner join SCA_CRITERIO_AVALIACAO CA ON CA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and CA.CODIGO = A.CODCRITERIOAVALIACAO"
	sql=sql & " inner join SCA_TIPO_AVALIACAO TA ON TA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and TA.CODIGO = A.CODTIPOAVALIACAO"
	sql=sql & " where A.cod_empresa = " & Session("CodEmpresa") 
	sql=sql & " and CA.cod_curso = " & intCodCurso
	sql=sql & " and TA.BIMESTRE = 3"
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			strPosicaoNotas3Bim = strPosicaoNotas3Bim & "," & rs("posicao")
			rs.movenext
		wend
	end if
	rs.close	
	strPosicaoNotas4Bim = "0"
	sql="Select TA.POSICAO "
	sql=sql & " from SCA_AVALIACAO A"
	sql=sql & " inner join SCA_CRITERIO_AVALIACAO CA ON CA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and CA.CODIGO = A.CODCRITERIOAVALIACAO"
	sql=sql & " inner join SCA_TIPO_AVALIACAO TA ON TA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and TA.CODIGO = A.CODTIPOAVALIACAO"
	sql=sql & " where A.cod_empresa = " & Session("CodEmpresa") 
	sql=sql & " and CA.cod_curso = " & intCodCurso
	sql=sql & " and TA.BIMESTRE = 4"
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			strPosicaoNotas4Bim = strPosicaoNotas4Bim & "," & rs("posicao")
			rs.movenext
		wend
	end if
	rs.close	
	strPosicaoNotasExameFinal = "0"
	sql="Select TA.POSICAO "
	sql=sql & " from SCA_AVALIACAO A"
	sql=sql & " inner join SCA_CRITERIO_AVALIACAO CA ON CA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and CA.CODIGO = A.CODCRITERIOAVALIACAO"
	sql=sql & " inner join SCA_TIPO_AVALIACAO TA ON TA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and TA.CODIGO = A.CODTIPOAVALIACAO"
	sql=sql & " where A.cod_empresa = " & Session("CodEmpresa") 
	sql=sql & " and CA.cod_curso = " & intCodCurso
	sql=sql & " and TA.BIMESTRE = 5"
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			strPosicaoNotasExameFinal = strPosicaoNotasExameFinal & "," & rs("posicao")
			rs.movenext
		wend
	end if
	rs.close	
	strPosicaoNotasCC = "0"
	sql="Select TA.POSICAO "
	sql=sql & " from SCA_AVALIACAO A"
	sql=sql & " inner join SCA_CRITERIO_AVALIACAO CA ON CA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and CA.CODIGO = A.CODCRITERIOAVALIACAO"
	sql=sql & " inner join SCA_TIPO_AVALIACAO TA ON TA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and TA.CODIGO = A.CODTIPOAVALIACAO"
	sql=sql & " where A.cod_empresa = " & Session("CodEmpresa") 
	sql=sql & " and CA.cod_curso = " & intCodCurso
	sql=sql & " and TA.BIMESTRE = 6"
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			strPosicaoNotasCC = strPosicaoNotasCC & "," & rs("posicao")
			rs.movenext
		wend
	end if
	rs.close	


	vetPosicaoNota1Bim 		= split(strPosicaoNotas1Bim,",")
	vetPosicaoNota2Bim 		= split(strPosicaoNotas2Bim,",")
	vetPosicaoNota3Bim 		= split(strPosicaoNotas3Bim,",")
	vetPosicaoNota4Bim 		= split(strPosicaoNotas4Bim,",")
	vetPosicaoNotaExameFinal= split(strPosicaoNotasExameFinal,",")
	vetPosicaoNotaCC		= split(strPosicaoNotasCC,",")
	
	if intCodDisciplina = "" then intCodDisciplina = "0"
	
	sql="select * from SCA_CRITERIO_AVALIACAO"
	sql=sql & " where	cod_empresa = "&Session("CodEmpresa") 
	sql=sql & " and		cod_curso	= "&intCodCurso
	rs.open sql, cnn
	if not rs.eof then
		strTipoFormulaFinal = rs("tipoFormulaFinal")
		strCondicaoEF_notaInicial = rs("condicaoEF_notaInicial")
		if isnull(strCondicaoEF_notaInicial) then strCondicaoEF_notaInicial = 0
		strCondicaoEF_notaFinal = rs("condicaoEF_notaFinal")
		if isnull(strCondicaoEF_notaFinal) then strCondicaoEF_notaFinal = 0
		
		if isnull(rs("peso_1bim")) = false then
			intPeso1Bim = rs("peso_1bim")
		else
			intPeso1Bim = 0
		end if
		
		if isnull(rs("peso_2bim")) = false then
			intPeso2Bim = rs("peso_2bim")
		else
			intPeso2Bim = 0			
		end if			
		
		if isnull(rs("peso_3bim")) = false then
			intPeso3Bim = rs("peso_3bim")
		else
			intPeso3Bim = 0			
		end if			
		
		if isnull(rs("peso_4bim")) = false then
			intPeso4Bim = rs("peso_4bim")
		else
			intPeso4Bim = 0			
		end if
		
		if isnull(rs("peso_EF")) = false then
			intPesoEF = rs("peso_EF")
		else
			intPesoEF = 0			
		end if
		
		'Armazena os pesos em uma string separada por ";" para ser utilizada na função calculaMedia
		strPesos = intPeso1Bim & ";" & intPeso2Bim & ";" & intPeso3Bim & ";"  & intPeso4Bim & ";" & intPesoEF
		
		if isnull(rs("formula")) = false then
			strFormula = rs("formula") 
		else
			strFormula = ""
		end if
		intMediaAprovacao     = rs("media_aprovacao")
		intMediaAprovacaoFinal = rs("media_aprovacao_final")
		intFreqMinima         = rs("frequencia_minima_percentual")
		
		if isnull(rs("num_disciplina_recuperacao")) = false then
			intNumDisciplinaRec   = rs("num_disciplina_recuperacao") 'Quantidade de disciplinas que o aluno pode ficar de recuperação
		else
			intNumDisciplinaRec = 0
		end if
		
		if isnull(rs("num_disciplina_prog_parcial")) = false then
			intNumDisciplinaProgParcial   = rs("num_disciplina_prog_parcial") 'Quantidade de disciplinas que o aluno pode ficar de prog. parcial
		else
			intNumDisciplinaProgParcial = 0
		end if	
		rs.close
	else
		rs.close
		%>
		<script>
			alert("O critério de avaliação não foi criado para esse curso.");
			window.location="Avaliacao_cad.asp?intCodCurso=<%=intCodCurso%>";
		</script>

		<%
		response.end
	end if
	
	sql = " select DAY(datainicial), datainicial from dbo.SCA_CONTEUDO " 
	sql = sql & " where Cod_turma = " & intCodTurma	
	sql = sql & " and Cod_Disciplina = " & intCodDisciplina
	sql = sql & " and MONTH(datainicial) = " & cInt(ZEROLEFT(strMes,2))
	sql = sql & " and YEAR(datainicial) = " & cInt(strAnoLetivo)
	sql = sql & " and Fechamento = 'S' "
	sql = sql & " and Cod_Empresa = " & Session("CodEmpresa")
	sql = sql & " order by DAY(datainicial) "
	rsAux1.open sql, cnn, 3, 3
	if not rsAux1.eof then
		vetAux1 = rsAux1.getRows
	end if
	rsAux1.close
	
%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="98%"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post">
		<input type="hidden" name="txtPosicao" value="<%=strPosicao%>">
        <input type="hidden" name="cmbQtdeFaltas" value="<%=strQtdeFaltas%>">
		<input type="HIDDEN" name="txtBimestreAtual" value="<%=strCodBimestre%>">
		<input type="HIDDEN" name="txtData" value="<%=strData%>">
		           <!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
		  <%
			sql = "SELECT TU.NOMETURMA, TU.ANO, TU.ANOLETIVO, T.DESC_TURNO "
			sql = sql & " FROM SCA_TURMA TU"
			sql = sql & " INNER JOIN SCA_TURNO T ON T.COD_TURNO = TU.COD_TURNO AND T.COD_EMPRESA = TU.COD_EMPRESA"
			sql = sql & " WHERE	TU.COD_EMPRESA = " & Session("CodEmpresa") 
			sql = sql & " AND	TU.COD_TURMA = " & intCodTurma
			rs.open sql, cnn
			if not rs.eof then
		  %>
		  <table width="99%" border="0" cellspacing="0" cellpadding="0" class="tabela">
            <tr bgcolor="#E5E5E5">
              <td width="6%" height="24" class="celula">&nbsp;<strong>Turma:</strong></td>
              <% if intCodEstagio <> "0" then %>
              		<td width="12%" class="celula">&nbsp;Grupo de Estágio&nbsp;</td>
              <% else %>      
              		<td width="12%" class="celula">&nbsp;<%=RS("NOMETURMA")%></td>
              <% end if %>      
              <td width="7%" class="celula">&nbsp;<strong>Disciplina:</strong></td>
              <td width="23%" class="celula"><%if strNomedisciplina="" then%>Todas do Hor&aacute;rio<%else%><%=strNomedisciplina%><%end if%>&nbsp;</td>
              <td width="12%" class="celula">&nbsp;<strong>Turno:</strong></td>
              <td width="12%" class="celula">&nbsp;<%=RS("DESC_TURNO")%></td>
              <% if intCodEstagio = "0" then %>
              	  <td width="7%" class="celula">&nbsp;<strong>Professor(a):</strong></td>
                  <td width="21%" class="celula">&nbsp;<%=strProfessor%></td>
              <% else %>
              	  <td width="7%" class="celula">&nbsp;<strong>Preceptor:</strong></td>
              	  <td width="21%" class="celula">&nbsp;<%=strSupervisor%> - <%=strGrupo%> </td>
              <% end if%>    
            </tr>
          </table>
		  <%
		  end if
		  rs.close
			'**** SELECIONA OS ALUNOS REGULARES E NOTAS E FALTAS
			buscaHistorico = "N"
			if trim(intSemestre) = "3" then
			   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  then
				  buscaHistorico = "S"
			   end if
			else
			   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  or trim(intSemestre) <> trim(session("strSemestre")) then
				  buscaHistorico = "S"
			   end if	   
			end if

			if buscaHistorico = "N" then
				sql = " SELECT distinct "
				sql = sql & " AD.COD_ALUNO AS CODIGO, " 
				sql = sql & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
				sql = sql & " A.NOMEALUNO, "
				sql = sql & " A.MATRICULA, "
				sql = sql & " SA.DESC_SITUACAOALUNO "
				sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD INNER JOIN " 
				sql = sql & " SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO  INNER JOIN "
				sql = sql & " SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO AND SA.Cod_Empresa = A.COD_EMPRESA "
				if intCodEstagio <> "0" then
					sql = sql & " INNER JOIN SCA_ESTAGIO_VINCULO EV ON EV.Cod_Aluno = A.CODIGO and CodEstagio = " & intCodEstagio
				end if
				sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa")
				' Filtra o estagio
				if intCodEstagio <> "0" then
					sql = sql & " and EV.CodEstagio = " & intCodEstagio
				else	
					sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO = " & intCodTurma	
				end if
				sql = sql & " AND AD.COD_ALUNO in (" & strAlunos & ") "
				sql = sql & " AND (SA.Desc_SituacaoAluno = 'ATIVO' OR SA.Desc_SituacaoAluno = 'PRÉ-MATRÍCULA') " 
				sql = sql & " ORDER BY A.NOMEALUNO "

			else   
			   'seleciona os alunos pelo ano e semestres do histórico 			
			   sql = " select DISTINCT A.CODIGO, AT.COD_TURMA, HED.COD_DISCIPLINA, A.NOMEALUNO, A.MATRICULA,  '' AS SEQUENCIA, SA.DESC_SITUACAOALUNO "
			   sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA HED "
			   sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR HE ON HE.CODIGO = HED.COD_HISTORICO_ESCOLAR "
			   sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = HE.COD_ALUNO AND A.COD_EMPRESA = HE.COD_EMPRESA "
			   sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND SA.COD_EMPRESA = A.COD_EMPRESA " 
			   sql = sql & " INNER JOIN SCA_ALUNO_TURMA AT ON  AT.COD_ALUNO=A.CODIGO AND AT.COD_EMPRESA = A.COD_EMPRESA "
			   sql = sql & " WHERE A.COD_EMPRESA = " & Session("CodEmpresa")
			   sql = sql & " AND AT.COD_TURMA = " & intCodTurma	
			   sql = sql & " AND HE.ANO_LETIVO = " & strAnoLetivo
			   sql = sql & " AND HE.SEMESTRE = " & intSemestre 
			   sql = sql & " AND HED.COD_DISCIPLINA= " & intCodDisciplina
			   sql = sql & " AND A.CODIGO in (" & strAlunos & ") "
			   sql = sql & " ORDER BY NOMEALUNO "
			end if
			rs.open sql, cnn
			%>		  
		  <table width="99%" border="0" cellspacing="0" cellpadding="0" class="tabela">
          <tr bgcolor="#E5E5E5">
            <td colspan="2" rowspan="2" align="center" class="celula"><strong><%=ucase(monthName(strMes))%></strong></td>
            <td height="24"  colspan="31" align="center" class="celula"><strong><%=ucase(strNomeTipoBimestre)%></strong></td>
            </tr>
          <tr bgcolor="#E5E5E5">
            <td height="24" colspan="31" align="center" class="celula"><strong>FALTA&nbsp;<%=strNomeNota%></strong></td>
          </tr>
          <tr bgcolor="#E5E5E5">
            <td height="19" class="celula"><div align="center"><strong>Matr&iacute;cula</strong></div></td>
            <td class="celula"><div align="center"><strong>Nome do Aluno</strong></div></td>
            
			<%
			if isArray(vetAux1) then
				for j=0 to ubound(vetAux1,2)
				   diaConteudo = vetAux1(0,j) 
				   %>
                   <td class="celula" align="center"><strong><%=ZeroLeft(diaConteudo,2)%></strong></td>
                   <%
				next	

				%>
            	<td class="celula" align="center"><strong>Tot.Fal</strong></td>
            	</tr>
		  		<%

			end if	
		  contLanc = 0
		  while not rs.eof
		  		contLanc = contLanc + 1
				strCodAluno = RS("CODIGO")
				
				  %>
				  <tr>
					<td class="celula" width="6%"><div align="center"><%=rs("MATRICULA")%>
					    <input type="hidden" name="txtCodAluno_<%=contLanc%>" value="<%=rs("CODIGO")%>">
			        </div></td>
					<td class="celula" width="67%">&nbsp;<%=rs("NOMEALUNO")%></td>
                    <%
					AcumuladaFalta = 0
					if isArray(vetAux1) then
		
						for j=0 to ubound(vetAux1,2)
							diaConteudo = vetAux1(0,j) 
							strData = strAnoLetivo & "/" & ZeroLeft(strMes,2) & "/" & ZeroLeft(diaConteudo,0)
                            diaSemana = weekday(strData)
							strCorPodeFazerAvaliacao = ""
							bolFalta = false
							selecionado = "0"
							
							' Consulta a quantidade de Faltas
							sql = " select cod_aluno, cod_disciplina, falta "
							sql = sql & " from SCA_FALTAS_DIARIA "
							sql = sql & " where cod_aluno = " & strCodAluno 
							sql = sql & " And cod_empresa = " & Session("CodEmpresa")
							sql = sql & " And data = '" & strData & "'"
							sql = sql & " and cod_disciplina = " & intCodDisciplina
							rsAux.open sql, cnn	
							if not rsAux.eof then
								while not rsAux.eof
									selecionado = selecionado + int(rsAux("falta"))
									AcumuladaFalta = AcumuladaFalta + int(rsAux("falta"))
									bolFalta = true
									rsAux.movenext
								wend
							else
								sql = " SELECT count(cod_turma) as total from SCA_HORARIO_AULA "
								sql = sql & " where cod_empresa = " & Session("CodEmpresa")
								sql = sql & " and cod_turma = " & intCodTurma
								sql = sql & " and anoLetivo = " & strAnoLetivo
								sql = sql & " and semestre = " & intSemestre
								sql = sql & " and Cod_Disciplina = " & intCodDisciplina
								sql = sql & " and diasemana = " & trim(diaSemana)
								rs1.OPEN SQL, CNN
								IF NOT rs1.EOF THEN
									TotalMatriz = rs1("total")
									if isnull(rs1("total")) or trim(rs1("total"))="0"  then
									   TotalMatriz = "0"
									end if   
								END IF
								rs1.close
								if TotalMatriz <> "0" and TotalMatriz <> "" then
								   	i=1
									selecionado = ""
									do while i <= clng(TotalMatriz)
										selecionado = selecionado & "."
										i = i + 1
									loop
								else
									selecionado = "F.H."	
								end if	
							end if
							rsAux.close
							%>
							<td class="celula" width="1%" align="center"><%=selecionado%></td>
							<%
						next
					end if	
					if AcumuladaFalta = 0 then AcumuladaFalta = ""
					%>
 					<td class="celula" width="1%" align="center"><%=AcumuladaFalta%>&nbsp;</td>
                </tr>
			  <%
		  		rs.movenext
		  wend
		  rs.close
		  
		  %>
        </table>
		<input type="hidden" name="strQuantNotasBimAtual" value="<%=strQuantNotas%>">
		<input type="hidden" name="qtdeAluno" value="<%=contLanc%>">
		<input type="hidden" name="cmbPeriodo" value="<%=intCodPeriodo%>">
		<input type="hidden" name="cmbSemestre" value="<%=intSemestre%>">
		<input type="hidden" name="cmbDisciplinaTurma" value="<%=intCodDisciplina%>">
		<input type="hidden" name="chkTipoNota" value="<%=intCodTipoNota%>">
		<input type="hidden" name="cmbTurma" value="<%=intCodTurma%>">
		<input type="hidden" name="cmbTurno" value="<%=intCodTurno%>">
		<input type="hidden" name="chkAluno" value="<%=strAlunos%>">
		<input type="hidden" name="cmbTipoLancamento" value="<%=intCodTipoLancamento%>">
		<input type="hidden" name="cmbCurso" value="<%=intCodCurso%>">

		 <!--Armazena a média que o aluno deve alcançar para ser aprovado na disciplina-->
        <input type="Hidden" name="txtHiddenMediaAprovacao" value="<%=intMediaAprovacao%>"> 
		 <!--Armazena a média que o aluno deve alcançar para ser aprovado na disciplina-->
        <input type="Hidden" name="txtHiddenMediaAprovacaoFinal" value="<%=intMediaAprovacaoFinal%>"> 
        <!--Armazena a média que o aluno deve alcançar para ser aprovado na disciplina-->
        <input type="Hidden" name="txtHiddenTipoFormulaFinal" value="<%=strTipoFormulaFinal%>"> 
        <!--Armazena a média que o aluno deve alcançar para ser aprovado na disciplina-->
        <input type="Hidden" name="txtHiddenFreqMinima" value="<%=intFreqMinima%>"> 
        <!--Verifica se possui recuperação-->
        <input type="Hidden" name="txtHiddenRecuperacao" value="<%=strRecuperacao%>">	
        <!--Verifica se possui recuperação-->
        <input type="Hidden" name="txtHiddenConselho" value="<%=strConselho%>"> 
        <!--Verifica quantas disciplinas o aluno pode ficar de recuperação-->
        <input type="hidden" name="txtHiddenNumDisciplinaRec" value="<%=intNumDisciplinaRec%>"> 
        <!--Verifica quantas disciplinas o aluno pode ficar de prog. parcial-->
        <input type="hidden" name="txtHiddenNumDisciplinaProgParcial" value="<%=intNumDisciplinaProgParcial%>"> 
        <!--Verifica se haverá reprovação por falta para a prog. parcial-->
        <input type="hidden" name="txtHiddenReprovacaoFaltaProgParcial" value="<%=strReprovacaoFaltaProgParcial%>"> 
		<!--Verifica se haverá reprovação por falta para a prog. parcial-->
        <input type="hidden" name="txtHiddenNotaDoTipoEF" value="<%=strNotaDoTipoEF%>">
        <input type="hidden" name="txtQtdeDias" value="<%=qtdeDiasMes%>">
        <input type="hidden" name="cmbMes" value="<%=strMes%>">	
		<%
		
			strParametro = "Rel_DiarioFrequenciaEletronica_con.asp?cmbPeriodo="&intCodPeriodo
			strParametro = strParametro & "&cmbSemestre="&intSemestre
			strParametro = strParametro & "&chkTipoNota="&intCodTipoNota
			strParametro = strParametro & "&cmbTurma="&intCodTurma
			strParametro = strParametro & "&cmbTurmaProfessor="&intCodTurma
			strParametro = strParametro & "&chkAluno="&strAlunos
			strParametro = strParametro & "&cmbTurno="&intCodTurno
			strParametro = strParametro & "&cmbTipoLancamento="&intCodTipoLancamento	
			strParametro = strParametro & "&cmbCurso="&intCodCurso	
			strParametro = strParametro & "&cmbMes="&strMes
			strParametro = strParametro & "&cmbDisciplinaTurma="&intCodDisciplinaTurma
			strParametro = strParametro & "&cmbDisciplinaDoProfessor="&intCodDisciplinaTurma
			
		
		%>
		<div align="center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
		  <input type="hidden" name="txtAnoLetivo" value="<%=strAnoLetivo%>">
		  <input type="hidden" name="txtSemestre" value="<%=intSemestre%>">
          <input type="hidden" name="txtPaginaRetorno" value="FALTASPROF">
		</form>

			<table width="98%" align="center" class="tabela" border="1" cellspacing="0" cellpadding="0">
			  <tr>
				<td width="30%" height="135" align="center" class="celula"><table width="93%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td height="24">LEGENDA: </td>
				  </tr>
				  <tr>
					<td width="23%" height="19">&quot;.&quot; (ponto) =Acad&ecirc;mico PRESENTE &agrave; aula do dia.</td>
				  </tr>
				  <tr>
					<td height="17">&quot;N&ordm;&quot; (N&uacute;mero) = Total de Falta.</td>
				  </tr>
				  <tr>
					<td height="19">&quot;F.H.&quot; = Aula Fora do Hor&aacute;rio.</td>
				  </tr>
				  <tr>
					<td height="31">&nbsp;</td>
				  </tr>
				</table></td>
				<td width="33%" align="center" class="celula" valign="top">
				
				<table width="91%" border="0" cellspacing="0" cellpadding="0">
				  <tr valign="top">
					<td height="23" align="center">PARA USO DA SECRETARIA </td>
				  </tr>
				  <tr>
					<td width="33%" height="17">&nbsp;</td>
				  </tr>
				  <tr>
					<td height="17" align="center">____________________________</td>
				  </tr>
				  <tr>
					<td height="17" align="center">&nbsp;</td>
				  </tr>
				  <tr>
					<td height="17" align="center">&nbsp;</td>
				  </tr>
				  <tr>
					<td height="17" align="center">_________/_________/_________</td>
				  </tr>
				</table></td>
				<td width="37%" align="center" class="celula" valign="top"><table width="91%" border="0" cellspacing="0" cellpadding="0">
				  <tr valign="top">
					<td height="23">AULAS PREVISTAS: _____________________ </td>
				  </tr>
				  <tr>
					<td width="33%" height="17">AULAS DADAS :  ________________________</td>
				  </tr>
				  <tr>
					<td height="17">DATA:_________/_________/_________ </td>
				  </tr>
				  <tr>
					<td height="17">&nbsp;</td>
				  </tr>
				  <tr>
					<td height="17"><div align="center">____________________________________</div></td>
				  </tr>
				  <tr>
                    <% if intCodEstagio = "0" then %>
						<td height="17"><div align="center">VISTO DO PROFESSOR</div></td>
                    <% else %>
						<td height="17"><div align="center">VISTO DO PRECEPTOR</div></td>
                    <% end if %>    
				  </tr>
				</table></td>
			  </tr>
			</table>

		</td>
      </tr>
    </table>
    
	</td>
  </tr>
</table>

<%if strMostraConteudo = "S" then %>
	<pre></pre>				
	<%
	strTituloRelatorio ="Conte&uacute;do Program&aacute;tico <br> Refer&ecirc;ncia: " &ucase(monthName(strMes)) & " - " & strAnoLetivo & msgSemestre
	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<table width="98%" border="0" cellspacing="0"  cellpadding="0" class="tabela" align="center">
	  <% if intCodDisciplina <> "0" then %>
	     <tr bgcolor="#CCCCCC">
	     	<td height="15" colspan="3" class="celula"><strong>Disciplina: <%=rs("Desc_Disciplina")%> - Turma: <%=rs("nometurma")%></strong></td>
      </tr>
	  <% end if %>	 
	  <tr bgcolor="#CCCCCC">
	    <% if intCodDisciplina = "0" then %>
	       <td width="22%" class="celula"><div align="center"><strong>Disciplina</strong></div></td>
		<% end if %>   
	    <td width="22%" class="celula"><div align="center"><strong>Data<span class="TextoForm">/Per&iacute;odo</span></strong></div></td>
	    <td width="68%" height="15" class="celula"><div align="center"><strong>Conte&uacute;do</strong></div></td>
      </tr>
	  
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	cont = 0

	sql = "SELECT c.*, t.nometurma, d.Desc_Disciplina,p.nome as COLABORADOR"
	sql = sql & " FROM SCA_Conteudo c"
	sql = sql & " inner join sca_turma t on t.cod_turma = c.cod_turma and t.cod_empresa = c.cod_empresa"
	sql = sql & " inner join sca_disciplina d on d.Cod_Disciplina = c.Cod_Disciplina and d.cod_empresa = c.cod_empresa"
	sql = sql & " left join 	SRH_COLABORADOR p on p.codigo = c.cod_colaborador and  p.cod_empresa = c.cod_empresa"
	sql = sql & " where c.cod_empresa = " & Session("CodEmpresa")			
	sql = sql & " and c.semestre in (" & intSemestre & ")"
	sql = sql & " and c.cod_turma = " & intCodTurma
    sql = sql & " and c.Cod_Disciplina = " & intCodDisciplina
	sql = sql & " and MONTH(c.datainicial) = " & cInt(ZEROLEFT(strMes,2))
	sql = sql & " and YEAR(c.datainicial) = " & cInt(strAnoLetivo)
	sql = sql & " and c.Fechamento = 'S' "
	sql = sql & " Order by c.anoletivo, c.semestre, c.datainicial "
	rs.open sql, cnn
	if not rs.eof then 
	    mostraCabecalho
		While not rs.eof 
			%>
			  <tr height="28">
			    <% if intCodDisciplina = "0" then %>
			    	<td align="left" class="celula"><%=rs("Desc_Disciplina")%></td>
				<% end if %>	
			    <td align="left" class="celula"><div align="center"><%=trim(formatadataAP(rs("datainicial")))%>&nbsp;a&nbsp;<%=trim(formatadataAP(rs("datafinal")))%></div></td>
			    <td align="left" class="celula"><%=rs("conteudo")%></td>
		      </tr>
			<%
			
			'quantidade de registros da página
			if int(intQtdeRegistroPorPagina) = int(strlpp) - 1 then
				 intPagina = intPagina + 1
				 intQtdeRegistroPorPagina = 1
				 fimTabela
				%>
				<pre></pre>				
				<%			
				mostraCabecalho
			end if	
			cont = cont + 1
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			rs.movenext
		wend
		contPeriodo = contPeriodo + 1
	else
		%>
		  <tr>
			<td height="24" colspan="3" align="center" class="celula"><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close
	%>
	</table>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  
	  <tr>
		<td colspan="2" align="left"><strong>&nbsp;&nbsp;&nbsp;<%=session("CidadeEmpresaWeb")%>-<%=session("ufEmpresaWeb")%>, <%=day(date)%> de <%=monthname(month(date))%> de <%=year(date)%>. </strong></td>
	  </tr>
	  <tr>
		<td height="21" colspan="2" align="center">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="51%" align="center">______________________________________</td>
		<td width="49%" align="center">______________________________________</td>
	  </tr>
	  <tr>
		<td align="center" valign="top"><strong><%=strProfessor%></strong></td>
		<td align="center" valign="top">Coordenador(a)</td>
	  </tr>
	  <tr>
		<% if intCodEstagio = "0" then %>
			<td align="center" valign="top">Professor(a)</td>
		<% else %>
			<td align="center" valign="top">Preceptor</td>
		<% end if %>    
		<td align="center" valign="top">&nbsp;</td>
	  </tr>
	</table>
<% end if %>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>