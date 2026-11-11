<!--#include file="../ConfigModulo.asp"-->
	<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 23/03/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Cadastro de Situação
	-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnnDocumento.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<%
	
	strAcao 			= Request.QueryString("acao")
	
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	intCodDocumento		= Trim(Request.Form("txtCodigo"))
	strTitulo	 		= Trim(Request.Form("txtTitulo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strCampos	 		= Trim(Request.Form("campos"))
	strPosicaoFinanceira= Trim(Request.Form("posicaofinanceira"))
	if strPosicaoFinanceira = "" THEN strPosicaoFinanceira = "N"
	strSituacaoAluno	= Trim(Request.Form("situacaoaluno"))
	intCodDepartamento	= Trim(Request.Form("cmbDepartamento"))

	strDescricaoAntiga	= Trim(Request.Form("txtDescricaoAntiga"))
 
	'on error resume next


	if trim(intCodDocumento) <> "" then
		sql = "SELECT codigo, titulo, Documento, campos, cod_departamento, posicaofinanceira, situacaoaluno"
		sql = sql & " FROM SCA_DOCUMENTO"
		sql = sql & " Where codigo = " & intCodDocumento
		rs.open sql, cnn
		if rs.eof = false then
			strTitulo 				= rs("Titulo")
			strDescricao			= rs("Documento")
			strDescricao 			= REPLACE(REPLACE(rs("documento"),"&lt;","["),"&gt;","]")
			strCampos				= rs("campos")
			intCodDepartamento		= rs("cod_departamento")
			strSituacaoAluno		= rs("situacaoaluno")
		end if 
		rs.close
	end if 

	
	cnn.begintrans

	if strAcao = "A" then  
		
		'*****************************************************************
		'todas unidades
		vetCodTodasEmpresa	= split(Session("CodTodasEmpresaGrupo"),",")
		
		'percorre todas unidades
		for i=0 to ubound(vetCodTodasEmpresa)
		
			intCodEmp = vetCodTodasEmpresa(i)
			bolExiste = false

			sql = "SELECT titulo "
			sql = sql & " FROM SCA_DOCUMENTO"
			sql = sql & " Where 1=1"
			if trim(strDescricaoAntiga) <> "" then
				sql = sql & " and titulo = '" & trim(strDescricaoAntiga) & "'"
			else
				sql = sql & " and titulo = '" & trim(strDescricao) & "'"
			end if
			rs.open sql, cnn
			if not RS.EOF then
				bolExiste = true
			end if
			rs.close
			
			if bolExiste=false then
			
				strMensagem = "Registro Salvo com sucesso..."
				
				sql = "SELECT Max(codigo) as MaiorCodigo" 
				sql = sql & " FROM SCA_DOCUMENTO"
				rs.open sql, cnn
				
				if not RS.EOF then
				
					if rs("MaiorCodigo") <> "" then
						intCodNovo = cstr(rs("MaiorCodigo")) + 1
						intCodigo = intCodNovo
					else
						intCodigo = 1	
					end if
				
				end if
				rs.close
		
				sql = "Insert Into SCA_DOCUMENTO( Titulo, Documento, cod_Departamento, situacaoAluno, posicaoFinanceira, Campos)"
				sql = sql & " Values ("
				sql = sql & "'" & strTitulo & "',"
				sql = sql & "'" & strDescricao & "',"
				sql = sql & "" & intCodDepartamento & ","
				sql = sql & "'" & strSituacaoAluno & "',"
				sql = sql & "'" & strPosicaoFinanceira & "',"
				sql = sql & "'" & strCampos & "')"
				response.write sql
				response.end
				''cnn.execute sql
			
			else
			
				strMensagem = "Registro Alterado com sucesso..."
		
				sql = "Update SCA_DOCUMENTO Set"
				sql = sql & " Titulo = '" & strTitulo & "',"
				sql = sql & " Documento = '" & strDescricao & "',"
				sql = sql & " posicaoFinanceira = '" & strPosicaoFinanceira & "',"
				sql = sql & " situacaoAluno = '" & strSituacaoAluno & "',"
				sql = sql & " cod_Departamento = " & intCodDepartamento & ","
				sql = sql & " Campos = '" & strCampos & "'"
				sql = sql & " where codigo = " & intCodDocumento
				response.write sql
				response.end
				''cnn.execute sql
						
			end if
			
		next

	
	end if

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Documento_cad.asp';
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