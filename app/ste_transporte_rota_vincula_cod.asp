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
	acao 					= Trim(Request("acao"))
	intCodRota		    	= Trim(Request("cod_rota")) 

	if acao="LISTA_SETORES" then
		cont =0
		sql = "SELECT Descricao as nome"
		sql = sql & " FROM STE_ROTA"
		sql = sql & " where cod_rota = " & intCodRota
		rs.open sql, cnn
		if rs.eof = false then
			nomeRota = rs("nome")
		end if
		rs.close
		
		
		sql = "select s.codigo, s.descricao, v.Cod_rota_vincula_setores"
		sql = sql & " from MAT_setores s"
		sql = sql & " left join STE_ROTA_VINCULA_SETORES v on v.Cod_Setores = s.codigo and v.cod_Rota = " & intCodRota
		sql = sql & " order by s.descricao "
		rs.open sql, cnn
		if rs.eof = false then
		%>
		<div class="row">
			<div class="col-xl-12">
				<div id="panel-1" class="panel">
					<div class="panel-hdr">
						<h2>
							Rota: <%=nomeRota%>
						</h2>
					</div>	
					<input name="txtCodRota" type="hidden" id="txtCodRota" value="<%=intCodRota%>">
					<div class="panel-container show">
						<div class="panel-content">					
							<div class="table-responsive-lg">
								<table class="table table-bordered table-hover m-0">
									<thead class="thead-themed">
									  <tr>
										<th><strong>Setor</strong></th>
										<th><strong>Vinculado</strong></th>
									  </tr>
									</thead>
									<tbody>
								  <%
								while not rs.eof
									cont = cont + 1	
									%>
									  <tr>
										<td class="celula"><%=rs("descricao")%></td>
										<td height="20" class="celula"><input name="chkSetor" <%if not isnull(rs("Cod_rota_vincula_setores")) then response.write "checked"%> type="checkbox" value="<%=rs("codigo")%>"></td>
									  </tr>
									  <%				
									rs.movenext
								wend
								%>
										<tr>
											<td height="21" colspan="2" class="celula">Total Registros : <%=cont%></td>
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
	elseif acao="GRAVA_SETORES" then
		cont =0
		codRota = request("txtCodRota")
		
		cod_setores = request("chkSetor")
		
		sql = "delete STE_ROTA_VINCULA_SETORES where cod_Rota = " & codRota
		cnn.execute sql

		if trim(cod_setores)<>"" then
			sql="insert STE_ROTA_VINCULA_SETORES"
			sql = sql & " select " & codRota & ", codigo,'" & session("usuarioWeb")& "',getdate() from mat_setores where codigo in (" & cod_setores & ")"
			cnn.execute sql
		end if
		strMensagem = "Setores vinculado com sucesso!"
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		
		if acao="GRAVA_SETORES" then
			%>
			<script>
				alert("<%=strMensagem%>");
				window.location='ste_transporte_rota_vincula.asp';
			</script>
			<%
			response.end
		end if
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