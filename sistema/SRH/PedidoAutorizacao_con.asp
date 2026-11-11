<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">SRH - Recurso Humano</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        tiraSolicitado = "S"
		strSituacaoPedidoRemocao 			= Trim(Request("cmbSituacaoPedidoRemocao"))
		if strSituacaoPedidoRemocao = "" then strSituacaoPedidoRemocao = "A"
		strBotaoVoltaTelaAnterior = "pedidoRemocao_cad.asp"
		strAnoletivo = Trim(Request("txtAnoLetivo"))
		if strAnoletivo = "" then strAnoletivo = year(date)
		strTipo 			= Trim(Request("cmbTipo"))
		tipoAcao = ""
		sql = "select ACES_USUA_CODG "
		sql = sql & " from SEG_ACESSOS_USUARIO "
		sql = sql & " where ACES_PERF_CODG=72"
		sql = sql & " and ACES_USUA_CODG = '" & session("usuarioWeb") & "'"
		rs.open sql, cnn
		if not rs.eof then
			tipoAcao = "LIBERADO"
		end if
		rs.close
		
		if tipoAcao = "" THEN 
			%>
				<script>
					alert("Acesso não permitido!");
				</script>
			<%
			response.end
		END IF
    %>
     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Autorizações</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post" action="PedidoAutorizacao_con.asp">
                <input name="txtCodigo" type="hidden" id="txtCodigo">
                    <div class="form-group">
                        <label class="form-label">Tipo</label>
                          <select name="cmbTipo" id="cmbTipo" style="width:230pt" class="form-control" onchange="submit()">
							<option <%if strTipo = "" or strTipo = "R" then response.write "selected"%> value="R">REMOÇÃO</option>
							<option <%if strTipo = "A" then response.write "selected"%> value="A">ATIVAÇÃO DE CADASTRO</option>
						</select>
                    </div>
					<div class="form-group">
                        <label class="form-label">Situação</label>
                          <!--#include file="../includes/inc_cmbSituacaoPedidoRemocao.asp" -->
                    </div>
                    <div class="form-group">
                        <label class="form-label">Ano do Pedido</label>
                          <input class="form-control" name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" size="5" maxlength="4" value="<%=strAnoLetivo%>" >
                    </div>
              
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_consulta.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de pedidos para <%=strAnoLetivo%></h3>
            </div>
			
			<%if strTipo = "R" then%>
			
				<div class="panel-body">
					<table class="table table-bordered">
						<thead>
							<tr>
							  <th width="1%"  bgcolor="#95A5A6">Mat.</th>
							  <th width="20%" bgcolor="#95A5A6">Nome</th>
							  <th width="15%" bgcolor="#95A5A6">Unidade Atual</th>
							  <th width="15%" bgcolor="#95A5A6">Unidade Escolhida</th>
							  <th width="5%" bgcolor="#95A5A6">Turno Escolhido</th>
							  <th width="5%" bgcolor="#95A5A6">Dt. Pedido</th>
							  <th width="10%" bgcolor="#95A5A6">Motivo</th>
							  <th width="10%" bgcolor="#95A5A6">Situação</th>
							  <th width="1%"  bgcolor="#95A5A6" align="center"><div align="center">Autorizar</div></th>
						  </tr>
						</thead>
						 <tbody>
						<%
						cont =0
						sql = "select p.codigo, c.codFuncional,c.nome, ea.razaosocial as unidade_atual, e1.razaosocial as unidade_escolhida, M.DESCRICAO AS motivo, p.observacao,"
						sql = sql & " p.situacao, p.usuario_incl, p.data_hora_incl, p.usuario_altr, p.data_hora_altr, T.DESC_TURNO AS TURNO_ESCOLHIDO, f.Desc_Funcao as funcao, ca.Desc_Cargo as cargo"
						sql = sql & " from SRH_PEDIDO_REMOCAO P"
						sql = sql & " inner join SRH_COLABORADOR C ON C.CODIGO = P.COD_COLABORADOR"
						sql = sql & " left join SRH_FUNCAOCOLABORADOR f ON f.Cod_Funcao = c.codFuncao"
						sql = sql & " left join SRH_CARGOCOLABORADOR ca ON ca.Cod_Cargo = c.codCargo"
						sql = sql & " left join SEG_EMPRESA E1 ON E1.CODIGO = P.COD_EMPRESA_ESCOLHIDA"
						sql = sql & " left join SEG_EMPRESA Ea ON Ea.CODIGO = p.cod_empresa"
						sql = sql & " left join SRH_TURNO T ON T.COD_TURNO = P.COD_TURNO_ESCOLHIDO"
						sql = sql & " left join SRH_MOTIVO_REMOCAO M ON M.CODIGO = P.COD_MOTIVO_REMOCAO"
						sql = sql & " WHERE P.COD_GRUPO = " & Session("CodGrupo")
						if strSituacaoPedidoRemocao <> "0" then
							sql = sql & " AND P.situacao = '" & strSituacaoPedidoRemocao & "'"
						end if
						if strAnoLetivo <> "" then
							sql = sql & " AND p.ANO_LETIVO = " & strAnoLetivo
						end if
						sql = sql & " order BY P.DATA_hora_INCL "
						rs.open sql, cnn
						if rs.eof = false then
							while not rs.eof
								cont = cont + 1	
								situacao = "<font size='-2'><strong>Solicitado</strong> por " & rs("usuario_incl") & "<br>Em " & rs("data_hora_incl") & "</font>"
								if rs("situacao") = "G" then 
									situacao = "<font size='-2'><strong>Aguardando Autorização</strong> <br>Enviado por " & rs("usuario_altr") & "<br>Em " & rs("data_hora_altr") & "</font>"
								elseif rs("situacao") = "F" then 
									situacao = "<font size='-2'><strong>Atendida</strong> por " & rs("usuario_altr") & "<br><font size='-2'>Em " & rs("data_hora_altr") & "</font>"
								elseif rs("situacao") = "N" then 
									situacao = "<font size='-2'><strong>Não Atendida</strong> por " & rs("usuario_altr") & "<br>Em " & rs("data_hora_altr") & "</font>"
								end if

								%>
								<tr>
									<td><%=trim(rs("codFuncional"))%></td>
									<td>
										<%=trim(rs("nome"))%>
										<br>
										<br><i>Função: <%=trim(rs("funcao"))%></i>
										<br><i>Cargo: <%=trim(rs("cargo"))%></i>
									
									</td>
									
									<td><%=trim(rs("unidade_atual"))%></td>
									<td><strong><%=trim(rs("unidade_escolhida"))%></strong></td>
									<td><strong><%=trim(rs("turno_escolhido"))%></strong></td>
									
									<td><%=trim(rs("data_hora_incl"))%></td>
									
									<td><%=rs("motivo")%><br><%=rs("observacao")%></td>
									<td><%=trim(situacao)%></td>
									
									<td align="center" >
									<%if rs("situacao") = "G" then %>
									<button class="btn-u btn-u-blue" onclick="editar('<%=trim(rs("codigo"))%>','F')" type="button"><i class="fa fa-check-circle-o"></i></button>
									<br>
									<br>
									<button class="btn-u btn-u-red" onclick="editar('<%=trim(rs("codigo"))%>','N')" type="button"><i class="fa fa-close"></i></button>
									<%end if%>
									</td> 
								</tr>
								<%				
								rs.movenext
							wend
						end if
						rs.close
						%>
							<tr>
								<td colspan="9">Total Registros : <%=cont%></td>
							</tr>
						</tbody>
					</table>
				</div> 

			<%elseif strTipo = "A" then%>
				
				<div class="panel-body">
					<table class="table table-bordered">
						<thead>
							<tr>
							  <th width="1%"  bgcolor="#95A5A6">Mat.</th>
							  <th width="20%" bgcolor="#95A5A6">Nome</th>
							  <th width="20%" bgcolor="#95A5A6">Unidade</th>
							  <th width="5%" bgcolor="#95A5A6">Dt. Pedido</th>
							  <th width="10%" bgcolor="#95A5A6">Motivo</th>
							  <th width="10%" bgcolor="#95A5A6">Situação</th>
							  <th width="1%"  bgcolor="#95A5A6" align="center"><div align="center">Autorizar</div></th>
						  </tr>
						</thead>
						 <tbody>
						<%
						cont =0
						sql = "select p.codigo, c.codFuncional, c.nome, E.razaosocial as unidade_atual, p.observacao,"
						sql = sql & " p.situacao, p.usuario_incl, p.data_hora_incl, p.usuario_autorizacao, p.data_hora_autorizacao, f.Desc_Funcao as funcao, ca.Desc_Cargo as cargo"
						sql = sql & " from SRH_ATIVACAO_CADASTRO P"
						sql = sql & " inner join SRH_COLABORADOR C ON C.CODIGO = P.COD_COLABORADOR"
						sql = sql & " left join SRH_FUNCAOCOLABORADOR f ON f.Cod_Funcao = c.codFuncao"
						sql = sql & " left join SRH_CARGOCOLABORADOR ca ON ca.Cod_Cargo = c.codCargo"
						sql = sql & " left join SEG_EMPRESA E ON E.CODIGO = P.COD_EMPRESA"
						sql = sql & " WHERE P.COD_GRUPO = " & Session("CodGrupo")
						if strSituacaoPedidoRemocao <> "0" then
							sql = sql & " AND P.situacao = '" & strSituacaoPedidoRemocao & "'"
						end if
						if strAnoLetivo <> "" then
							sql = sql & " AND p.ANO_LETIVO = " & strAnoLetivo
						end if
						sql = sql & " order BY P.DATA_hora_INCL "
						rs.open sql, cnn
						if rs.eof = false then
							while not rs.eof
								cont = cont + 1	
								situacao = "<font size='-2'><strong>Solicitado</strong> por " & rs("usuario_incl") & "<br>Em " & rs("data_hora_incl") & "</font>"
								if rs("situacao") = "G" then 
									situacao = "<font size='-2'><strong>Aguardando Autorização</strong> <br>Enviado por " & rs("usuario_incl") & "<br>Em " & rs("data_hora_incl") & "</font>"
								elseif rs("situacao") = "F" then 
									situacao = "<font size='-2'><strong>Atendida</strong> por " & rs("usuario_autorizacao") & "<br><font size='-2'>Em " & rs("data_hora_autorizacao") & "</font>"
								elseif rs("situacao") = "N" then 
									situacao = "<font size='-2'><strong>Não Atendida</strong> por " & rs("usuario_autorizacao") & "<br>Em " & rs("data_hora_autorizacao") & "</font>"
								end if

								%>
								<tr>
									<td><%=trim(rs("codFuncional"))%></td>
									<td>
										<%=trim(rs("nome"))%>
										<br>
										<br><i>Função: <%=trim(rs("funcao"))%></i>
										<br><i>Cargo: <%=trim(rs("cargo"))%></i>
									
									</td>
									
									<td><%=trim(rs("unidade_atual"))%></td>
									
									<td><%=trim(rs("data_hora_incl"))%></td>
									
									<td>Ativar Cadastro<br><%=rs("observacao")%></td>
									<td><%=trim(situacao)%></td>
									
									<td align="center" >
									<%if rs("situacao") = "G" then %>
									<button class="btn-u btn-u-blue" onclick="ativar('<%=trim(rs("codigo"))%>','F')" type="button"><i class="fa fa-check-circle-o"></i></button>
									<br>
									<br>
									<button class="btn-u btn-u-red" onclick="ativar('<%=trim(rs("codigo"))%>','N')" type="button"><i class="fa fa-close"></i></button>
									<%end if%>
									</td> 
								</tr>
								<%				
								rs.movenext
							wend
						end if
						rs.close
						%>
							<tr>
								<td colspan="9">Total Registros : <%=cont%></td>
							</tr>
						</tbody>
					</table>
				</div> 

			<%end if%>
			
        </div>
        <!--End Table Bordered-->	
        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
	<script>
	    
		 function editar(intCodigo, acao){
            
			if (acao=="F"){
				if(confirm("Deseja ATENDER esse pedido?")) {
					frm.action="pedidoRemocaoAutorizacao_cod.asp?acao=" + acao + "&txtCodigo=" + intCodigo;
					frm.submit();
					return true;
				}			
			}
   			if (acao=="N"){
				if(confirm("Deseja CANCELAR/NÃO ATENDER esse pedido?")) {
					frm.action="pedidoRemocaoAutorizacao_cod.asp?acao=" + acao + "&txtCodigo=" + intCodigo;
					frm.submit();
					return true;
				}			
			}
        }
		function ativar(intCodigo, acao){
            
			if (acao=="F"){
				if(confirm("Deseja ATENDER esse pedido?")) {
					frm.action="ativacaoCadastroAutorizacao_cod.asp?acao=" + acao + "&txtCodigo=" + intCodigo;
					frm.submit();
					return true;
				}			
			}
   			if (acao=="N"){
				if(confirm("Deseja CANCELAR/NÃO ATENDER esse pedido?")) {
					frm.action="ativacaoCadastroAutorizacao_cod.asp?acao=" + acao + "&txtCodigo=" + intCodigo;
					frm.submit();
					return true;
				}			
			}
        }
    
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 