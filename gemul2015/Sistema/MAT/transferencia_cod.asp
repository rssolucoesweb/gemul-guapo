<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/01/2020
	::	Desenvolvedores...: Sergio Borges - Sergiob76@gmail.com
	::	Objetivo Pagina...: Cadastro de transferencia
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 			= Trim(Request.QueryString("acao"))

	strCod_empresa 		= Session("CodEmpresa")
	cod_transferencia	= Trim(Request.Form("cod_transferencia"))
	strCodAluno			= Trim(Request.Form("txtCodAluno"))
	strMatricula 		= Trim(Request.Form("txtMatricula"))
	strNomealuno 		= Trim(Request.Form("txtNomealuno"))
	strBairroAluno 		= Trim(Request.Form("txtBairro"))
	
	acompanhamentoSocial 			= Trim(Request.Form("acompanhamentoSocial"))
	descricao_acompanhamento_social	= Trim(Request.Form("descricaoAcompanhamentoSocial"))
	irmaoNaEscola 					= request.Form("irmaoNaEscola")

	quantidadeIrmao 		= request.Form("quantidadeIrmao")
	if quantidadeIrmao 		= "" then quantidadeIrmao = "0"

	strCursoAluno 	= request.form("cmbCurso")
	strPeriodoAluno = request.form("cmbPeriodo")	
	strTurnoAluno 	= request.form("cmbTurno")	
	
	Cod_empresa_1opcao 	= request.form("cmbEmpresa1opcao")	
	Cod_empresa_2opcao 	= request.form("cmbEmpresa2opcao")	
	Cod_empresa_3opcao 	= request.form("cmbEmpresa3opcao")	

	if acao="I" then
		strMensagem = "Registro incluido com sucesso..."

		sql = "SET NoCount ON Insert Into MAT_TRANSFERENCIA ("
		sql = sql & " cod_empresa,"
		sql = sql & " matricula,"
		sql = sql & " cod_aluno,"
		sql = sql & " nome,"
		sql = sql & " bairro,"
		sql = sql & " curso,"
		sql = sql & " periodo,"
		sql = sql & " turno,"
		sql = sql & " acompanhamento_social,"
		sql = sql & " descricao_acompanhamento_social,"
		sql = sql & " irmao_escola,"
		sql = sql & " qtde_irmao_escola,"
		sql = sql & " Cod_empresa_1opcao,"
		sql = sql & " Cod_empresa_2opcao,"
		sql = sql & " Cod_empresa_3opcao,"
		sql = sql & " Situacao,"
		sql = sql & " usuario_incl,"
		sql = sql & " data_hora_incl,"
		sql = sql & " usuario_altr,"
		sql = sql & " data_hora_altr,"
		sql = sql & " excluido,"
		sql = sql & " usuario_exc,"
		sql = sql & " data_exc)"
		sql = sql & " Values ("
		sql = sql & "" & strCod_empresa & ","
		sql = sql & "'" & strMatricula & "',"
		sql = sql & ""  & strCodAluno  & ","
		sql = sql & "'" & strNomealuno & "',"
		sql = sql & "'" & strBairroAluno & "',"
		sql = sql & "'" & strCursoAluno & "',"
		sql = sql & "'" & strPeriodoAluno & "',"
		sql = sql & "'" & strTurnoAluno & "',"
		sql = sql & "'" & acompanhamentoSocial & "',"
		if descricao_acompanhamento_social = "" then
			sql = sql & "null,"
		else
			sql = sql & "'" & descricao_acompanhamento_social & "',"
		end if
		sql = sql & "'" & irmaoNaEscola & "',"
		sql = sql & "" & quantidadeIrmao & ","
		sql = sql & "'" & Cod_empresa_1opcao & "',"
		if Cod_empresa_2opcao = "0" then
			sql = sql & "null,"
		else
			sql = sql & "'" & Cod_empresa_2opcao & "',"
		end if
		if Cod_empresa_3opcao = "0" then
			sql = sql & "null,"
		else
			sql = sql & "'" & Cod_empresa_3opcao & "',"
		end if
		sql = sql & "'A',"
		sql = sql & "'" & session("usuarioWeb") & "',"
		sql = sql & "getdate(),"
		sql = sql & "null,"
		sql = sql & "null,"
		sql = sql & "null,"
		sql = sql & "null,"
		sql = sql & "null) ;SELECT @@IDENTITY "
		Set rs = cnn.Execute(sql)
		cod_transferencia = rs(0)
		rs.close
		
		GravarLog replace(replace(sql," ;SELECT @@IDENTITY",""),"SET NoCount ON ","")
		
		if quantidadeIrmao>0 then
			for i=1 to quantidadeIrmao
				intCodAlunoIrmao 		= request.form("txtCodAlunoIrmao"&i)
				strMatriculaAlunoIrmao 	= request.form("txtMatriculaAlunoIrmao"&i)
				strNomeAlunoIrmao 		= request.form("txtNomeAlunoIrmao"&i)
				strCursoAlunoIrmao 		= request.form("cmbCursoIrmao"&i)				
				strPeriodoAlunoIrmao 	= request.form("cmbPeriodoIrmao"&i)				
				strTurnoAlunoIrmao 		= request.form("cmbTurnoIrmao"&i)				
				
				sql = "Insert Into mat_transferencia_irmao_escola ("
				sql = sql & " cod_transferencia,"
				sql = sql & " cod_empresa,"
				sql = sql & " cod_aluno,"
				sql = sql & " matricula,"
				sql = sql & " nome,"
				sql = sql & " curso,"
				sql = sql & " periodo,"
				sql = sql & " turno,"
				sql = sql & " Situacao,"
				sql = sql & " usuario_incl,"
				sql = sql & " data_hora_incl)"
				sql = sql & " Values ("
				sql = sql & "'" & cod_transferencia & "',"
				sql = sql & "" & strCod_empresa & ","
				sql = sql & ""  & intCodAlunoIrmao  & ","
				sql = sql & ""  & strMatriculaAlunoIrmao  & ","
				sql = sql & "'"  & strNomeAlunoIrmao  & "',"
				sql = sql & "'" & strCursoAlunoIrmao & "',"
				sql = sql & "'" & strPeriodoAlunoIrmao & "',"
				sql = sql & "'" & strTurnoAlunoIrmao & "',"
				sql = sql & "'A',"
				sql = sql & "'" & session("usuarioWeb") & "',"
				sql = sql & "getdate())"
				
				cnn.execute sql
				GravarLog sql
				
			next
		end if
		
	elseif acao="A" then
		strMensagem = "Registro alterado com sucesso..."

		sql = "update MAT_TRANSFERENCIA set"
		sql = sql & " bairro = '" & strBairroAluno & "',"
		sql = sql & " curso = '" & strCursoAluno & "',"
		sql = sql & " periodo = '" & strPeriodoAluno & "',"
		sql = sql & " turno = '" & strTurnoAluno & "',"
		sql = sql & " acompanhamento_social = '" & acompanhamentoSocial & "',"
		if descricao_acompanhamento_social = "" then
			sql = sql & "descricao_acompanhamento_social = null,"
		else
			sql = sql & "descricao_acompanhamento_social = '" & descricao_acompanhamento_social & "',"
		end if
		sql = sql & " irmao_escola = '" & irmaoNaEscola & "',"
		sql = sql & " qtde_irmao_escola = " & quantidadeIrmao & ","
		sql = sql & " Cod_empresa_1opcao = '" & Cod_empresa_1opcao & "',"
		if Cod_empresa_2opcao = "0" then
			sql = sql & "Cod_empresa_2opcao = null,"
		else
			sql = sql & "Cod_empresa_2opcao = '" & Cod_empresa_2opcao & "',"
		end if
		if Cod_empresa_3opcao = "0" then
			sql = sql & "Cod_empresa_3opcao = null,"
		else
			sql = sql & "Cod_empresa_3opcao = '" & Cod_empresa_3opcao & "',"
		end if

		sql = sql & " usuario_altr = '" & session("usuarioWeb") & "',"
		sql = sql & " data_hora_altr = getdate() "
	
		sql = sql & " where cod_empresa = " & strCod_empresa
		sql = sql & " and codigo = " & cod_transferencia
		cnn.execute sql
		GravarLog sql
		
		sql = "delete mat_transferencia_irmao_escola "
		sql = sql & "where cod_transferencia = " & cod_transferencia
		cnn.execute sql
		GravarLog sql
		
		if quantidadeIrmao>0 then
			for i=1 to quantidadeIrmao
				intCodAlunoIrmao 		= request.form("txtCodAlunoIrmao"&i)
				strMatriculaAlunoIrmao 	= request.form("txtMatriculaAlunoIrmao"&i)
				strNomeAlunoIrmao 		= request.form("txtNomeAlunoIrmao"&i)
				strCursoAlunoIrmao 		= request.form("cmbCursoIrmao"&i)				
				strPeriodoAlunoIrmao 	= request.form("cmbPeriodoIrmao"&i)				
				strTurnoAlunoIrmao 		= request.form("cmbTurnoIrmao"&i)				
				
				sql = "Insert Into mat_transferencia_irmao_escola ("
				sql = sql & " cod_transferencia,"
				sql = sql & " cod_empresa,"
				sql = sql & " cod_aluno,"
				sql = sql & " matricula,"
				sql = sql & " nome,"
				sql = sql & " curso,"
				sql = sql & " periodo,"
				sql = sql & " turno,"
				sql = sql & " Situacao,"
				sql = sql & " usuario_incl,"
				sql = sql & " data_hora_incl)"
				sql = sql & " Values ("
				sql = sql & "'" & cod_transferencia & "',"
				sql = sql & "" & strCod_empresa & ","
				sql = sql & ""  & intCodAlunoIrmao  & ","
				sql = sql & ""  & strMatriculaAlunoIrmao  & ","
				sql = sql & "'"  & strNomeAlunoIrmao  & "',"
				sql = sql & "'" & strCursoAlunoIrmao & "',"
				sql = sql & "'" & strPeriodoAlunoIrmao & "',"
				sql = sql & "'" & strTurnoAlunoIrmao & "',"
				sql = sql & "'A',"
				sql = sql & "'" & session("usuarioWeb") & "',"
				sql = sql & "getdate())"
				
				cnn.execute sql
				GravarLog sql
				
			next
		end if
	elseif acao="E" then
		strMensagem = "Registro excluido com sucesso..."
		sql = "delete mat_transferencia_irmao_escola "
		sql = sql & "where cod_transferencia = " & cod_transferencia
		cnn.execute sql
		GravarLog sql
		
		sql = "delete MAT_TRANSFERENCIA "
		sql = sql & "where codigo = " & cod_transferencia
		cnn.execute sql
		GravarLog sql
		
	end if

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='transferencia_acompanhamento_con.asp';
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