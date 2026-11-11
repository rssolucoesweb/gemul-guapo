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
	intCodSetor		    	= Trim(Request("cod_setor")) 
	rede = request("rede")
	
	if acao="LISTA_UNIDADES" then
		cont =0
		sql = "SELECT Descricao as nome"
		sql = sql & " FROM MAT_setores"
		sql = sql & " where codigo = " & intCodSetor
		rs.open sql, cnn
		if rs.eof = false then
			nomeSetor = rs("nome")
		end if
		rs.close
		
		if rede = "M" then
			sql = "select s.codigo, s.razaosocial as descricao, v.Cod_rota_vincula_unidade_setores"
			sql = sql & " from seg_empresa s"
			sql = sql & " left join STE_ROTA_VINCULA_UNIDADE_SETORES v on v.cod_empresa = s.codigo and v.cod_setores = " & intCodSetor
			sql = sql & " where s.codTipoEmpresa<>5 and s.bloqueio='N'"
			sql = sql & " order by s.razaosocial "
		elseif rede = "E" then
			sql = "select s.codigo_escola_estadual as codigo, s.nome as descricao, v.Cod_rota_vincula_unidade_setores"
			sql = sql & " from ste_escola_estadual s"
			sql = sql & " left join STE_ROTA_VINCULA_UNIDADE_SETORES v on v.codigo_escola_estadual = s.codigo_escola_estadual and v.cod_setores = " & intCodSetor
			sql = sql & " order by s.nome "
		end if
		rs.open sql, cnn
		if rs.eof = false then
		%>
		<div class="row">
			<div class="col-xl-12">
				<div id="panel-1" class="panel">
					<div class="panel-hdr">
						<h2>
							Setor: <%=nomeSetor%>
						</h2>
					</div>	
					<input name="txtCodSetor" type="hidden" id="txtCodSetor" value="<%=intCodSetor%>">
					<div class="panel-container show">
						<div class="panel-content">					
							<div class="table-responsive-lg">
								<table class="table table-bordered table-hover m-0">
									<thead class="thead-themed">
									  <tr>
										<th><strong>Unidades <%if rede="M" then%>Municipais<%else%>Estaduais<%end if%></strong></th>
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
										<td height="20" class="celula"><input name="chkUnidade" <%if not isnull(rs("Cod_rota_vincula_unidade_setores")) then response.write "checked"%> type="checkbox" value="<%=rs("codigo")%>"></td>
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
	elseif acao="GRAVA_UNIDADES" then
		cont =0
		codSetor = request("txtCodSetor")
		
		cod_unidades = request("chkUnidade")
		
		if rede = "M" then
			sql = "delete STE_ROTA_VINCULA_UNIDADE_SETORES where cod_setores = " & codSetor
			sql = sql & " and cod_empresa in (select codigo from SEG_EMPRESA )"
			cnn.execute sql
			
			if trim(cod_unidades)<>"" then
				sql="insert STE_ROTA_VINCULA_UNIDADE_SETORES (Cod_setores, Cod_empresa, usuario_incl, data_hora_incl)"
				sql = sql & " select " & codSetor & ", codigo,'" & session("usuarioWeb")& "',getdate() from SEG_EMPRESA where codigo in (" & cod_unidades & ")"
				cnn.execute sql
			end if
		elseif rede = "E" then
			sql = "delete STE_ROTA_VINCULA_UNIDADE_SETORES where cod_setores = " & codSetor
			sql = sql & " and codigo_escola_estadual in (select codigo_escola_estadual from ste_escola_estadual )"
			cnn.execute sql
			
			if trim(cod_unidades)<>"" then
				sql="insert STE_ROTA_VINCULA_UNIDADE_SETORES (Cod_setores, codigo_escola_estadual, usuario_incl, data_hora_incl)"
				sql = sql & " select " & codSetor & ", codigo_escola_estadual,'" & session("usuarioWeb")& "',getdate() from ste_escola_estadual where codigo_escola_estadual in (" & cod_unidades & ")"
				cnn.execute sql
			end if
		
		end if
		strMensagem = "Unidades vinculadas com sucesso!"
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		
		if acao="GRAVA_UNIDADES" then
			%>
			<script>
				alert("<%=strMensagem%>");
				window.location='ste_transporte_escola_vincula.asp?rede=<%=rede%>';
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