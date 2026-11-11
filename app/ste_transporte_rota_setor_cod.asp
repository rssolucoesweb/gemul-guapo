<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	intCodGrupo				= Session("CodGrupo") 
	intCodigo		    	= Trim(Request.Form("txtCodigo")) 
	strNomeRota	 			= Trim(Request.Form("txtNome"))
	intDistanciaPercorrida 	= Trim(Request.Form("txtDistanciaPercorrida"))
	strCapacidade		 	= Trim(Request.Form("txtCapacidade"))
	strReservado		 	= Trim(Request.Form("txtReservado"))
	intCodColaborador	 	= Trim(Request.Form("cmbColaborador"))
	strVeiculo	 			= Trim(Request.Form("txtVeiculo"))
	strPlaca	 			= Trim(Request.Form("txtPlaca"))
	strCor	 				= Trim(Request.Form("txtCor"))
	strData	 				= formatadataBD(Trim(Request.Form("txtData"))) 
	strObservacao			= Trim(Request.Form("txtObservacao"))
	strSituacao				= Trim(Request.Form("cmbSituacao"))
	intCodEmpMarcada  	= Trim(Request.Form("chkEmpresa"))

	
	if strCapacidade = "" then strCapacidade = 0
	if strReservado = "" then strReservado = 0
	if acao="LISTA_SETORES" then
		cont =0
		sql = "SELECT Cod_Rota as codigo, capacidade, Descricao as nome"
		sql = sql & " FROM SCA_ROTA"
		sql = sql & " where situacao = 'A' "
		sql = sql & " Order by Descricao"
		
	rs.open sql, cnn
			
	if rs.eof = false then
	%>
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						<%=pagina%> cadastradas
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>	
				<div class="panel-container show">
					<div class="panel-content">					
						<div class="panel-tag">
							<span class="fw-300">Para editar clique em editar setor ou editar unidade abaixo.</span>
						</div>
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><strong>Nome da Rota</strong></th>
									<th><strong>Capacidade</strong></th>
									<th><strong>Setor Vinculado</strong></th>
									<th><strong>Unidade Vinculada</strong></th>
									<th><strong>Setor</strong></th>
									<th><strong>Unidade</strong></th>
								  </tr>
								</thead>
								<tbody>
							  <%
							while not rs.eof
								cont = cont + 1	
								%>
								  <tr>
									<td class="celula"><%=rs("nome")%></td>
									<td height="20" class="celula"><%=trim(rs("capacidade"))%></td>
									<td height="20" class="celula"></td>
									<td height="20" class="celula"></td>
									<td height="20" class="celula">
										<button onClick="return abreSetores('<%=rs("CODIGO")%>')" type="button" class="btn btn-outline-success btn-sm">Editar Setor</button>
									</td>
									<td height="20" class="celula">
										<button onClick="return abreModalUnidades('<%=rs("CODIGO")%>')" type="button" class="btn btn-outline-info btn-sm">Editar Unidade</button>
									</td>
								  </tr>
								  <%				
								rs.movenext
							wend
							%>
									<tr>
										<td height="21" colspan="6" class="celula">Total Registros : <%=cont%></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div> 
	<%
	end if
	rs.close
	
	<%
	
	
	elseif acao="I" then
	
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "Insert Into SCA_ROTA(Cod_Grupo, Descricao, Capacidade, reservado, Distancia_percorrida, "
		sql = sql & " CodColaborador, Veiculo, Placa, Cor, Data, Observacao, Situacao, usuario_incl, data_hora_incl )"
		sql = sql & " Values ("
		sql = sql & "" & intCodGrupo & ","
		sql = sql & "" & intCodigo & ","
		sql = sql & "'" & strNomeRota & "',"
		sql = sql & "" & strCapacidade & ","
		sql = sql & "" & strReservado & ","
		sql = sql & "" & intDistanciaPercorrida & ","
		if intCodColaborador = "" or intCodColaborador = "0" then
			sql = sql & "null,"
		else
			sql = sql & "" & intCodColaborador & ","
		end if
		sql = sql & "'" & strVeiculo & "',"
		sql = sql & "'" & strPlaca & "',"
		sql = sql & "'" & strCor & "',"
		sql = sql & "getdate(),"
	
		if strObservacao <> "" then
			sql = sql & "'" & strObservacao & "',"
		else
			sql = sql & "null,"
		end if
		
		sql = sql & "'" & strSituacao & "',"
		sql = sql & "'" & session("usuarioWeb") & "',"
		sql = sql & "getdate())"
		
		cnn.execute sql
		GravarLog sql
			
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SCA_ROTA Set"
		sql = sql & " Descricao = '" & strNomeRota & "',"
		sql = sql & " Capacidade = " & strCapacidade & ","
		sql = sql & " Reservado = " & strReservado & ","
		sql = sql & " Distancia_percorrida = " & intDistanciaPercorrida & ","
		if intCodColaborador = "" or intCodColaborador = "0" then
			sql = sql & " CodColaborador = null,"
		else
			sql = sql & " CodColaborador = " & intCodColaborador & ","
		end if
		
		sql = sql & " Veiculo = '" & strVeiculo & "',"
		sql = sql & " Placa = '" & strPlaca & "',"
		sql = sql & " Cor = '" & strCor & "',"
		
		if strObservacao <> "" then
			sql = sql & " Observacao = '" & strObservacao & "',"
		else
			sql = sql & " Observacao = null " & strObservacao & ","
		end if
		
		sql = sql & " Situacao = '" & strSituacao & "',"
		sql = sql & " usuario_altr = '" & session("usuarioWeb") & "',"
		sql = sql & " data_hora_altr = getdate()"
		
		sql = sql & " where Cod_Grupo = " & intCodGrupo
		sql = sql & " And Cod_Rota = " & intCodigo

		cnn.execute sql
		GravarLog sql
			
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete from SCA_ROTA "
		sql = sql & " where Cod_Rota = " & intCodigo
		cnn.execute sql
		GravarLog sql

	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='sca_transporte_rota.asp';
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