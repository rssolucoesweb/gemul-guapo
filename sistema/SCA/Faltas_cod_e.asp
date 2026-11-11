<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 10/05/2010
    ::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br.com
	::	Objetivo Pagina...: Excluir Faltas
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	strPaginaRetorno		= Trim(Request.Form("txtPaginaRetorno"))
	acao 					= Trim(Request.QueryString("acao"))
	intCodAlunoDisciplina 	= Trim(Request.QueryString("CodAlunoDisciplina"))
	strFalta				= Trim(Request.QueryString("Falta"))
	intCodFalta				= Trim(Request.QueryString("CodFalta"))
	intAnoLetivo 			= Trim(Request.QueryString("AnoLetivo"))
	intSemestre 			= Trim(Request.QueryString("Semestre"))
	intCodBimestre			= Trim(Request.QueryString("CodBimestre"))
	
	if acao="E" then
		
		strMensagem = "Falta Excluida com sucesso..."

		sql = "Delete From SCA_FALTAS_DIARIA "
		SQL = SQL & " WHERE Cod_empresa = " & Session("CodEmpresa") 
		SQL = SQL & " AND Cod_aluno_disciplina = " & intCodAlunoDisciplina
		SQL = SQL & " AND Ano_letivo = " & intAnoLetivo
		SQL = SQL & " AND Semestre = " & intSemestre
		response.Write(sql)
		
		'cnn.execute SQL
		'GravarLog sql		
		
		SQL = "SELECT Bimestre FROM SCA_TIPO_AVALIACAO "
		SQL = SQL & " WHERE Cod_empresa = " & Session("CodEmpresa") 
		SQL = SQL & " AND Codigo = " & intCodBimestre
		response.Write(sql)
		
		rs.open sql, cnn
		if rs.eof = false then
			strPosicao = rs("Bimestre")			
		end if
		rs.close
		
		if  strPosicao <> "" then
			'alterar falta
			SQL = "SELECT falta"& ZeroLeft(strPosicao,2)& " as Faltas FROM SCA_NOTAS_FALTAS "
			SQL = SQL & " Where cod_aluno_disciplina = " & intCodAlunoDisciplina
			response.Write(sql)
			rs.open sql, cnn
			if rs.eof = false then
				strFaltasRegistradas = rs("faltas")	
				strTotal = cint(strFaltasRegistradas) - cint(strFalta)
			end if
			rs.close
			
			if strTotal < 0 then
				cnn.rollbackTrans
				%>
				<script>
                    alert("A quantidade de faltas a excluir e maior do que a quantidade registrada, verifique.");
                    window.close();
                </script>
                <%
                response.end
			else
			
				SQL = "UPDATE SCA_NOTAS_FALTAS SET "
				SQL = SQL & "falta"&ZeroLeft(strPosicao,2) & "=" & strTotal 
				SQL = SQL & " where cod_aluno_disciplina = " & intCodAlunoDisciplina
				response.Write(sql)
				'cnn.execute SQL
				'GravarLog sql	
				
			end if
				
		end if
	
	end if
	
	response.End()
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			 window.close();
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