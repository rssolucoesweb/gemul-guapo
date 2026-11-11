<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 05/01/2021
	::	Desenvolvedores...: Sergio Borges - Sergiob76@gmail.com
	::	Objetivo Pagina...: Cadastro da ficha descritiva
-->
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnndocumento.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<%
	strAcao							= Trim(Request.QueryString("acao"))
	intCodAluno		 				= Trim(Request.form("txtCodAluno"))
	intCodFichaDescritiva		 	= Trim(Request.form("txtFichaDescritiva"))
	intCodBimestre					= Trim(Request.Form("txtBimestre"))
	intCodTurma		 				= Trim(Request.form("txtTurma"))
	intCodTurnoRH		 			= Trim(Request.form("txtCodTurnoRH"))
    intCodColaboradorProfessor 	    = Trim(Request.form("txtProfessor"))
	intCodDisciplina                = trim(request("txtDisciplinaDoProfessor"))
	strCodItemAvaliacao				= Trim(Request.form("chkAvaliacao"))
	intAnoLetivo					= Trim(Request.form("txtAnoLetivo"))
	intSemestre						= Trim(Request.form("txtSemestre"))
	
	if strCodItemAvaliacao <> "" then   
		vetCodItemAvaliacao = split(strCodItemAvaliacao,",")			 
	end if

	'on error resume next
	cnn.begintrans

	if strAcao = "I" or strAcao = "A" then  
		
		strMensagem = "Ficha Descritiva Salva com sucesso."
		
		sql = " delete n"
		sql = sql & " from SCA_FICHA_DESCRITIVA_PERGUNTA_NOTA n "
		sql = sql & " inner join SCA_FICHA_DESCRITIVA_PERGUNTA p on p.codigo = n.Cod_Ficha_Descritiva_Pergunta "
		sql = sql & " where p.cod_ficha_descritiva = " & intCodFichaDescritiva
		sql = sql & " AND Cod_Turma = " & intCodTurma
		sql = sql & " AND Cod_aluno = " & intCodAluno
		sql = sql & " AND cod_bimestre = " & intCodBimestre
		sql = sql & " AND Cod_Disciplina = " & intCodDisciplina
		sql = sql & " AND Cod_Turno_Rh = " & intCodTurnoRH
		
		cnn.execute sql
		GravarLog sql
		
		for intContador = 0 to ubound(vetCodItemAvaliacao)
				
				intCodFichaDescritivaPergunta		= Trim(Request.form("txtCod_Ficha_Descritiva_Pergunta" & intContador))
				strResposta							= Trim(Request.form("txtResposta_" & intContador))
				strConceito		 					= Trim(Request.Form("txtConceito_" & intContador))
				
				SQL = "INSERT INTO SCA_FICHA_DESCRITIVA_PERGUNTA_NOTA (Cod_Turma, cod_professor, cod_disciplina, cod_bimestre, Cod_Ficha_Descritiva_Pergunta, Cod_aluno, "
				SQL = SQL & " Conceito, Resposta, Cod_Turno_Rh)"
				SQL = SQL & " VALUES ("
				SQL = SQL & "" & intCodTurma & ","
				SQL = SQL & "" & intCodColaboradorProfessor & ","
				SQL = SQL & "" & intCodDisciplina & ","
				SQL = SQL & "" & intCodBimestre & ","
				SQL = SQL & "" & intCodFichaDescritivaPergunta & ","
				SQL = SQL & "" & intCodAluno & ","
				SQL = SQL & "'" & strConceito & "',"
				SQL = SQL & "'" & strResposta & "',"
				SQL = SQL & "" & intCodTurnoRH & ")"
				cnn.execute SQL
				GravarLog sql
				'response.write sql & "<br>"
		 	
		next
	
	elseif strAcao = "E" then	
		
		strMensagem = "Ficha Descritiva Excluida com sucesso."
		
		sql = " delete n"
		sql = sql & " from SCA_FICHA_DESCRITIVA_PERGUNTA_NOTA n "
		sql = sql & " inner join SCA_FICHA_DESCRITIVA_PERGUNTA p on p.codigo = n.Cod_Ficha_Descritiva_Pergunta "
		sql = sql & " where p.cod_ficha_descritiva = " & intCodFichaDescritiva
		sql = sql & " AND Cod_Turma = " & intCodTurma
		sql = sql & " AND Cod_aluno = " & intCodAluno
		sql = sql & " AND cod_bimestre = " & intCodBimestre
		sql = sql & " AND Cod_Disciplina = " & intCodDisciplina
		sql = sql & " AND Cod_Turno_Rh = " & intCodTurnoRH
		cnn.execute sql
		GravarLog sql

	end if 
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.close();
			//window.location="sca_ficha_descritiva_aluno.asp?CodAluno=<%=intCodAluno%>&cmbFichaDescritiva=<%=intCodFichaDescritiva%>&AnoLetivo=<%=intAnoLetivo%>&Semestre=<%=intSemestre%>&cmbTurmaProfessor=<%=intCodTurma%>&cmbDisciplinaDoProfessor=<%=intCodDisciplina%>&cmbBimestre=<%=intCodBimestre%>&cmbProfessor=<%=intCodColaboradorProfessor%>&cmbTurnoRH=<%=intCodTurnoRH%>";

		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>