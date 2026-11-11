<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--
	::	IMOB
	::	Data de Criação...: 22/08/2011
	::	Desenvolvedores...: Sergio Dias Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Incluir sub grupo
	::	Data Atualizacao..: 
-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 						= Trim(Request.QueryString("acao"))
	intCodEmpresa				= session("codEmpresa")	
	intCodigo 					= Trim(Request.Form("txtCodigo"))
	intCodRequisicao			= Trim(Request.Form("txtCodRequisicao"))
	strSolicitante				= session("strNomeUsuario")
	intCodProduto				= Trim(Request.Form("cmbProduto"))
	intQuantidade				= Trim(Request.Form("txtQuantidade"))
	strObs						= replace(Trim(Request.Form("txtObs")),"'","")
	intSecaoProduto				= Trim(Request.Form("cmbSecaoProduto"))
	CodDepartamento				= Trim(Request.Form("CodDepartamento"))
	strSituacao					= 1

	' Dados do Usuario
	strUsuario_incl   	=	session("strNomeUsuario")
	strData_hora_incl 	= 	formatadataBD(date) & " " & time 
	strUsuario_altr   	=	session("strNomeUsuario")
	strData_hora_altr 	= 	formatadataBD(date) & " " & time 

	if acao="I" then
		strMensagem = "Registro salvo com sucesso..."
		
		if intCodRequisicao="" then
			
			if (trim(session("codPerfil")) = "37" or trim(session("codPerfil")) = "17" or session("bolUsuarioAcessaTodasRequisicoes")="S") or intSecaoProduto="10" then 'responsavel pela liberaçao do material
			'perfil liberado
			else
				'regra 1 pedido por mes
				sql = "select _d.TIPO, COUNT(*) as qtde"
				sql = sql & " from est_requisicao _r"
				sql = sql & " inner join SEG_usuarios _u on _u.cpf = _r.solicitante"
				sql = sql & " inner join EST_DEPARTAMENTO _d on _d.codigo = _u.codDepartamento"
				sql = sql & " where solicitante = '"&strUsuario_incl&"'"
				sql = sql & " and month(dataEntrada) = " & month(date)
				sql = sql & " and YEAR(dataentrada) = " & year(date)
				sql = sql & " group by _d.TIPO"
				rs.open sql, cnn
				if not rs.eof then
					tipo = rs("tipo")
					qtde = rs("qtde")
					if isnull(qtde) then qtde = 0
					rs.close
					if tipo = "UNIDADE_ESCOLA" then
						'uma requisição por mes
						%>
						<script>
							alert("ATENÇÃO: Já foi realizada a solicitação de material para esse mês, será liberada nova solicitação somente no proximo mês.");
							window.history.back();
						</script>
						<%
						response.End()
					else
						'quatro requisição por mes
						'if qtde > 4 then
							%>
							<!--script>
								//alert("ATENÇÃO: Já foram realizadas 04 (quatro) solicitações de material para esse mês, será liberada nova solicitação somente no proximo mês.");
								//window.history.back();
							</script -->
							<%
							'response.End()
						'end if
					end if
				else
					rs.close
				end if
			end if			
			sql = "SET NoCount ON Insert Into est_requisicao(codEmpresa,cod_secao,solicitante,codDepartamento,dataEntrada,codSituacao,obs,usuario_incl,data_hora_incl,usuario_altr,data_hora_altr)"          
			sql = sql & " Values ("
			sql = sql & "" & intCodEmpresa & ","
			sql = sql & "" & intSecaoProduto & ","
			sql = sql & "'" & strSolicitante & "',"
			sql = sql & "'" & CodDepartamento & "',"
			sql = sql & "'" & strData_hora_incl & "',"
			sql = sql & "1,"
			sql = sql & "'" & strObs & "',"
			' Usuario do Sistema
			sql = sql & "'" & strUsuario_incl & "',"
			sql = sql & "'" & strData_hora_incl & "',"
			' Campos nulos para campo Usuario Alteracao e data Alteracao'
			sql = sql & "" & "null, null" & ")"
			sql = sql & " ;SELECT @@IDENTITY "	
			
			Set rs = cnn.Execute(sql)
			intCodRequisicao = rs(0)
			rs.close
			GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	

			'incluir movimentação
			strSituacaoAndamento = "Iniciada a digitação da solicitação"
			'strUsuario_incl
			'strData_hora_incl
			'intCodRequisicao
			%><!--#include file="../../../includes/inc_andamento_requisicao.asp"--><%

		else
			sql = "UPDATE est_requisicao SET "          
			sql = sql & " OBS='" & strObs & "'"
			sql = sql & " where CODIGO = " & intCodRequisicao
			cnn.Execute(sql)
		end if
		
		'verifica se o material já existe nessa solicitação
		sql = "select codigo"
		sql = sql & " from est_requisicaoproduto"
		sql = sql & " where codRequisicao = " & intCodRequisicao
		sql = sql & " and codProduto = " & intCodProduto
		rs.open sql, cnn
		if not rs.eof then
			rs.close
			%>
			<script>
				alert("ATENÇÃO: Já foi incluído esse mesmo material nesta solicitação, caso deseje incluí-lo novamente, você deverá excluí-lo e incluí-lo com a quantidade correta.");
				window.history.back();
			</script>
			<%
			response.End()
		end if
		rs.close
		
		sql = "Insert Into est_requisicaoproduto(codRequisicao,codProduto,unidade,quantidade,quantidade_autorizada,quantidade_liberada,usuario_incl,data_hora_incl,usuario_altr,data_hora_altr)"          
		sql = sql & " Values ("
		sql = sql & "" & intCodRequisicao & ","
		sql = sql & "" & intCodProduto & ","
		sql = sql & "null,"
		sql = sql & "" & intQuantidade & ","
		sql = sql & "" & intQuantidade & ","
		sql = sql & "" & intQuantidade & ","
		' Usuario do Sistema
		sql = sql & "'" & strUsuario_incl & "',"
		sql = sql & "'" & strData_hora_incl & "',"
		' Campos nulos para campo Usuario Alteracao e data Alteracao'
		sql = sql & "" & "null, null" & ")"
		cnn.Execute(sql)
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
		
	elseif acao="EXCLUIR" then
		
		strMensagem = "Registro excluida com sucesso..."
		
		sql = "Delete from est_requisicaoproduto "
		sql = sql & " where codRequisicao = " & intCodRequisicao
		cnn.Execute(sql)
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	

		sql = "Delete from EST_RequisicaoAndamento "
		sql = sql & " where codRequisicao = " & intCodRequisicao
		cnn.Execute(sql)
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
		
		sql = "Delete from est_requisicao "
		sql = sql & " Where Codigo = " & intCodRequisicao
		cnn.Execute(sql)
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
		acao="E" 
	elseif acao="EM" then
		intCodRequisicao			= Trim(Request("txtCodRequisicao"))
		intCodigo					= Trim(Request("codigo"))
		strMensagem = "Material excluido com sucesso..."
		
		sql = "Delete from est_requisicaoproduto "
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And codRequisicao = " & intCodRequisicao
		cnn.Execute(sql)
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	

		acao="I"
		bolExiste = "S"
		sql = "select codigo from est_requisicaoproduto "
		sql = sql & " where codRequisicao = " & intCodRequisicao
		rs.open sql, cnn
		if rs.eof then
			bolExiste = "N"
		end if
		rs.close

		if bolExiste = "N" then
			sql = "Delete from EST_RequisicaoAndamento "
			sql = sql & " where codRequisicao = " & intCodRequisicao
			cnn.Execute(sql)
			GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
		
			
			sql = "Delete from est_requisicao "
			sql = sql & " Where Codigo = " & intCodRequisicao
			cnn.Execute(sql)
			GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
			acao="E"
			strMensagem = "Material e solicitação foram excluidos com sucesso..."
			 
		end if 

	elseif acao="F" then
		
		strMensagem = "Solicitação foi enviada para autorizacao."
		sql = "update est_requisicao set codSituacao = 2 "
		sql = sql & " Where Codigo = " & intCodRequisicao
		cnn.Execute(sql)
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	

		sql = "update est_requisicaoproduto set quantidade_autorizada = quantidade, quantidade_liberada = quantidade "
		sql = sql & " Where CodRequisicao = " & intCodRequisicao
		cnn.Execute(sql)
		GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))	
		
		'incluir movimentação
		strSituacaoAndamento = "Enviado para Autorização"
		'strUsuario_incl
		'strData_hora_incl
		'intCodRequisicao
		%><!--#include file="../../../includes/inc_andamento_requisicao.asp"--><%
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		if acao="E" or acao="F" then
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Solicitacao_cad.asp';
		</script>
		<%
		else
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Solicitacao_cad.asp?txtCodRequisicao=<%=intCodRequisicao%>';
		</script>
		<%
		end if
		response.end
	else
		cnn.rollbacktrans
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
	end if
%>