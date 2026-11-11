	<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 23/03/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Cadastro de Situação
	-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
    <!--#include file="../../includes/inc_formataData.asp"-->
	<%
	
	paginaRetorno		= "Situacao_cad.asp"
	strAcao 			= Request.QueryString("acao")
	
	intCodEmp						= Session("CodEmpresa")
	intCodigo	 					= Trim(Request.Form("txtCodigo"))
	intAno							= Trim(Request.Form("txtAno"))
	intSemestre						= Trim(Request.Form("cmbSemestre"))
	strDataEncerramento				= formataDataBD(Trim(Request.Form("txtDataEncerramento")))
	strSimouNaoDocente				= Trim(Request.Form("cmbSimouNaoDocente"))
    strSimouNaoSecretaria    		= Trim(Request.Form("cmbSimouNaoSecretaria"))
    strSimouNaoCampoAcumuladaFalta 	= Trim(Request.Form("cmbSimouNaoCampoAcumuladaFalta"))
	strMes							= Trim(Request("cmbMes"))

	'on error resume next
	
	cnn.begintrans

	if strAcao = "I" then  
		
		strMensagem = "Registro Salvo com sucesso..."
		
		'*****************************************************************
		'todas unidades
		vetCodTodasEmpresa	= split(Session("CodTodasEmpresaGrupo"),",")
		
		'percorre todas unidades
		for i=0 to ubound(vetCodTodasEmpresa)
		
			intCodEmp = vetCodTodasEmpresa(i)
			bolExiste = false

			strMensagem = "Registro Salvo com sucesso..."

			sql = "SELECT * " 
			sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES"
			sql = sql & " where cod_empresa = " & intCodEmp
			rs.open sql, cnn
			if not RS.EOF then
				bolExiste = true
			end if
			rs.close
			
			if bolExiste=false then
			
				sql = "SELECT Max(Codigo) as MaiorCodigo" 
				sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES"
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
				
				sql = "Insert Into SEG_ENCERRAMENTOATIVIDADES(COD_EMPRESA, Ano_letivo, Semestre, data_encerramento, Bloqueia_NotasDocente, Bloqueia_NotasSecretaria, Bloqueia_CampoAcumuladaFalta, Bloqueia_ConteudoProgramatico)"
				sql = sql & " Values ("
				sql = sql & "" & intCodEmp & ","
				sql = sql & "" & intAno & ","
				sql = sql & "" & intSemestre & ","
				sql = sql & "'" & strDataEncerramento & "',"
				sql = sql & "'" & strSimouNaoDocente & "',"
				sql = sql & "'" & strSimouNaoSecretaria & "',"
				sql = sql & "'" & strSimouNaoCampoAcumuladaFalta & "',"
				sql = sql & "" &  strMes & ")"
				cnn.execute sql
			else	

				strMensagem = "Registro Alterado com sucesso..."
		
				sql = "Update SEG_ENCERRAMENTOATIVIDADES Set"
				sql = sql & " ano_letivo = " & intAno & ","
				sql = sql & " semestre = " & intSemestre & ","
				sql = sql & " data_encerramento = '" & strDataEncerramento & "',"
				sql = sql & " Bloqueia_NotasDocente = '" & strSimouNaoDocente & "',"
				sql = sql & " Bloqueia_NotasSecretaria = '" & strSimouNaoSecretaria & "',"
				sql = sql & " Bloqueia_CampoAcumuladaFalta = '" & strSimouNaoCampoAcumuladaFalta & "',"
				sql = sql & " Bloqueia_ConteudoProgramatico = " & strMes 
				sql = sql & " where cod_empresa = " & intCodEmp
				cnn.execute sql
			
			end if
			
		next

	end if

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='EncerrametoAtividades_cad.asp';
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