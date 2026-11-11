<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnndocumento.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%

	'on error resume next
	'----------Inicia uma transação--------------
	'cnn.begintrans
	acao 										= Trim(Request.QueryString("acao"))
	pg 										= Trim(Request.QueryString("pg"))
	enviarFalta									= Trim(Request.QueryString("enviarFalta"))
	
	intCodEmp									= Session("CodEmpresa")
	intCodigo           	  					= Trim(Request.Form("txtCodigo"))
	intCodRequisicao							= intCodigo
	intCodArea				 					= Trim(Request.Form("cmbArea"))
	intCodTipoServicoOS							= Trim(Request.Form("cmbTipoServicoOS"))
	
	SQL = "select cod_prioridade "
	SQL = SQL & " from sos_tipo_servico "
	SQL = SQL & " where codigo = " & intCodTipoServicoOS
	RS.OPEN SQL, CNN
	IF NOT RS.EOF THEN
		intCodPrioridade = RS("cod_prioridade")
	END IF
	RS.CLOSE
	
	intCodUsuarioExterno = "0"
	SQL = "select usua_codg "
	SQL = SQL & " from sos_area "
	SQL = SQL & " where codigo = " & intCodArea
	RS.OPEN SQL, CNN
	IF NOT RS.EOF THEN
		intCodUsuarioExterno = RS("usua_codg")
	END IF
	RS.CLOSE
	if intCodUsuarioExterno="0" then
		%>
		<script>
			alert("Área selecionada está sem responsável!");
			window.history.back();
		</script>
		<%
		response.end 
	end if	
	
	strResumo          							= Trim(Request.Form("txtResumo"))
	
	strFechamento             					= Trim(Request("cmbFechamento"))

	if acao <> "E" then
		strImagem								= Trim(Request("txtTexto"))
	end if
	strAnoLetivo             					= Trim(Request("txtAnoLetivo"))
	intSemestre             					= Trim(Request("cmbSemestre"))

	' Dados do Usuario
	strUsuario_incl   	=	session("usuarioWeb")
	strData_hora_incl 	= 	formatadataBD(date) & " " & time 
	strUsuario_altr   	=	session("usuarioWeb")
	strData_hora_altr 	= 	formatadataBD(date) & " " & time 
	
	if strSimouNao = "" then
	   strSimouNao = "N"
	end if 

	if acao="I" then
		if strImagem <> "" then
		if LEFT(strImagem,9)<>"<img src=" then
			%>
			<script>
				alert("Imagem invalida, devera ser enviado somente arquivo do tipo IMAGEM!");
				window.history.back();
			</script>
			<%
			response.end 
		end if	
		if LEN(strImagem)>9999999 then
			%>
			<script>
				alert("Imagem não permitida, Favor redur o tamanho da imagem!");
				window.history.back();
			</script>
			<%
			response.end 
		end if	
		end if
	end if
	  	  
	if acao="I" then
	
		strMensagem = "Registro incluido e encaminhado para o Gestor Respons�vel!"

		sql = "SET NoCount ON Insert Into SOS_REQUISICAO ( cod_empresa,cod_tipo_servico,cod_prioridade, cod_usuario_abertura, Cod_funcionario_externo,resumo,data,situacao,usuario_incl,data_hora_incl,usuario_altr,data_hora_altr )"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodTipoServicoOS & ","
		sql = sql & "" & intCodPrioridade & ","
		sql = sql & "'" & strUsuario_incl & "',"
		sql = sql & "null,"
		sql = sql & "'" & strResumo & "',"
		sql = sql & "'" & strData_hora_incl & "',"
		sql = sql & "'INCLUIDO'," 
		
		' Usuario do Sistema
		sql = sql & "'" & strUsuario_incl & "',"
		sql = sql & "'" & strData_hora_incl & "',"
		
		' Campos nulos para campo Usuario Alteracao e data Alteracao'
		sql = sql & "" & "null, null); SELECT @@IDENTITY"
		Set rs = cnn.Execute(sql)
		intCodRequisicao = rs(0)
		rs.close
		
		SQL = REPLACE(sql,"SET NoCount ON ","")
		SQL = REPLACE(sql," ; SELECT @@IDENTITY","")
		GravarLog SQL
		
		sql = "insert into SOS_REQUISICAO_ANDAMENTO (cod_requisicao, cod_tipo_andamento, parecer, usuario_incl, data_hora_incl) values ("
		sql = sql & "'" & intCodRequisicao & "',"
		sql = sql & "1,"
		sql = sql & "'" & strResumo & "',"
		sql = sql & "'" & strUsuario_incl & "',"
		sql = sql & "'" & strData_hora_altr & "')"
		cnn.execute sql
		GravarLog sql
		
		if strImagem<>"" then
		sql = "Insert Into SOS_REQUISICAO_IMAGEM(cod_requisicao, imagem )"
		sql = sql & " Values ("
		sql = sql & "" & intCodRequisicao & ","
		sql = sql & "'" & strImagem & "')"
		cnn.execute sql
		end if
	
	elseif acao="A" then
		
		strMensagem = "Registro alterado com sucesso..."
		
		sql = "UPDATE SOS_REQUISICAO SET "
		sql = sql & "cod_tipo_servico=" & intCodTipoServicoOS & ","
		sql = sql & "cod_prioridade=" & intCodPrioridade  & ","
		if strResumo <> "" then
			sql = sql & "resumo='" & strResumo & "',"
		else 
			sql = sql & "resumo=null, "
		end if		
		
		sql = sql & " usuario_altr = '" & strUsuario_altr & "',"
		sql = sql & " data_hora_altr = '" & strData_hora_altr & "'"
		sql = sql & " WHERE codigo = " & intCodRequisicao
		cnn.execute sql
		GravarLog SQL
		if strImagem<>"" then
		sql = "UPDATE SOS_REQUISICAO_IMAGEM SET "
		sql = sql & " imagem = '" & strImagem & "' "
		sql = sql & " WHERE cod_requisicao = " & intCodRequisicao
		cnn.execute sql
		end if
		
	elseif acao = "E" then
		
		strMensagem = "Registro Excluido com sucesso..."

		sql = "Delete from SOS_REQUISICAO_ANDAMENTO "
		sql = sql & " where cod_requisicao =" & intCodRequisicao
'response.write sql & "<hr>"		
		cnn.execute sql
		GravarLog sql		

		sql = "Delete from SOS_REQUISICAO_IMAGEM "
		sql = sql & " where cod_requisicao =" & intCodRequisicao
'response.write sql & "<hr>"		
		cnn.execute sql
		GravarLog sql		
		
		sql = "Delete from SOS_REQUISICAO "
		sql = sql & " where codigo = " & intCodRequisicao
'response.write sql & "<hr>"		
		cnn.execute sql
		GravarLog sql

	end if


	if err.number = 0 then
		'----------Finaliza tranzação iniciada--------------
		'cnn.commitTrans
		if pg="comp" then
			%>
			<script>
				alert("<%=strMensagem%>");
				window.location='requisicao_comp_cad.asp';
			</script>
			<%
		else
			%>
			<script>
				alert("<%=strMensagem%>");
				window.location='requisicao_cad.asp';
			</script>
			<%
		end if
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		'cnn.rollbacktrans
	end if
%>