	<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 26/01/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Confirmação Aluno
	-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_cnnDocumento.asp"-->
    <!--#include file="../../includes/inc_formatadata.asp"-->
<%
	strAlunoEncontrado					= ""
	pagina								= "EfetivacaoAluno_con.asp"
	Session("MatriculaInformatizada") 	=  "SIM"
	strCod_empresa 						= Session("CodEmpresa")
	Session("MatriculaInformatizadaAnoEfetivacao") = year(date)
	intCodAluno			= Trim(Request.Form("txtCodAluno"))
	strNomealuno 		= Trim(Request.Form("txtNomealuno"))
	strDatanascimento 	= formataDataBD(Trim(Request.Form("txtDatanascimento")))
	strMae 				= Trim(Request.Form("txtMae"))
	msn 				= ""
	
	IF intCodAluno = "" THEN intCodAluno = "0"
	
		SQL = "select A.MATRICULA, e.RAZAOSOCIAL, A.COD_EMPRESA"
		SQL = SQL & " from SCA_ALUNO A"
		SQL = SQL & " inner join SCA_SITUACAOALUNO SA ON SA.Cod_Empresa = A.COD_EMPRESA AND SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO"
		SQL = SQL & " inner join SEG_EMPRESA e on e.CODIGO = A.COD_EMPRESA"
		SQL = SQL & " where A.NOMEALUNO = '"&strNomealuno&"'  COLLATE SQL_Latin1_General_CP1_CI_AI "
		SQL = SQL & " and A.MAE = '"&strMae&"' COLLATE SQL_Latin1_General_CP1_CI_AI "
		SQL = SQL & " and A.DATANASCIMENTO = '"&strDatanascimento&"'"
		SQL = SQL & " and SA.Desc_SituacaoAluno = 'ATIVO'"
		SQL = SQL & " and A.Cod_Empresa in (select codigo from SEG_EMPRESA where COD_GRUPO=7)"
		rs.open sql, cnn, 3, 3
		if rs.eof = false then
			if trim(rs("cod_empresa")) <> trim(strCod_empresa) then
				msn = "EFETIVAÇÃO NEGADA!\n\nAluno(a) já esta matriculado(a) no " & rs("RAZAOSOCIAL") & " com a matrícula " & rs("matricula") & "."
			end if
		end if
		rs.close	

		if trim(msn) = "" then
			sql = "update SCA_ALUNO set"
			sql = sql & " nomeAluno = '" & strNomealuno & "',"
			sql = sql & " dataNascimento = '" & strDatanascimento & "',"
			sql = sql & " mae = '" & strMae & "'"
			sql = sql & " where codigo = "& intCodAluno
			sql = sql & " and cod_empresa =" & Session("CodEmpresa")
			'response.write sql
			cnn.execute sql
			%>
			<script>
				window.location="../../gemul2015/Sistema/SCA/Aluno_cad.asp?txtCodAluno=<%=intCodAluno%>";
			</script>
			<%
			response.End()
		else
			%>
			<script>
				alert("<%=msn%>");
				window.location="EfetivacaoAluno_con.asp";
			</script>
			<%
			response.End()
		end if
%>