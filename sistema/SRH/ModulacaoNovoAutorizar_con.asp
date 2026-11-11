<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_formataCPF.asp"-->
<!--#include file="../../includes/inc_replaceRequest.asp"-->
<!--#include file="../../js/Calendario/Calendario.asp"-->
<!--#include file="../menuModulos.asp"-->

<style>

#txtCodigoFuncional{
  color: blue;
}
#txtNomeFuncionario{
  color: blue;
}
#txtcpf{
  color: blue;
}

.letra10{
  font-size: 10px;
}
</style>

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
	Session("CodPerfilAcessoRH") = ""
	sql = "select ACES_USUA_CODG "
	sql = sql & " from SEG_ACESSOS_USUARIO "
	sql = sql & " where ACES_PERF_CODG=72"
	sql = sql & " and ACES_USUA_CODG = '" & session("usuarioWeb") & "'"
	rs.open sql, cnn
	if not rs.eof then
		Session("CodPerfilAcessoRH") = "72"
	end if
	rs.close
	
	strEmpresaGrupo_submit = "S"
	
	if Session("CodPerfilAcessoRH") <> "72" then
		%>
		<script>
			alert("Acesso não autorizado. Verifique seu perfil!")
			window.location='ModulacaoNovo_cad.asp';
		</script>
		<%
		response.end
	end if
	
	
	' Inativa todas as Modulacoes Vencidas vencidas
	sql = " Update SRH_MODULACAO_DISCIPLINAR_DOCENTE "
	sql = sql & " set status = 'I', data_inativacao = getdate(), usuario_inativacao = 'Sistema' "
	sql = sql & " where convert(varchar, DataFinal,111) < convert(varchar, getdate(),111) "
	sql = sql & " AND Status = 'A' "
	cnn.execute sql

	sql = " UPDATE SRH_MODULACAO_DISCIPLINAR_DOCENTE  SET Status = 'I', data_inativacao = getdate(), usuario_inativacao = 'Sistema' where Ano_Letivo < YEAR(GETDATE()) AND Status = 'A' "
	cnn.execute sql

	'Inativa todas as substituicoes vencidas
	sql = " Update SRH_COLABORADOR_SUBSTITUTO "
	sql = sql & " set SITUACAO = 'I' "
	sql = sql & " where Cod_Grupo = " & Session("CodGrupo")
	sql = sql & " and convert(varchar, DataFinal,111) < convert(varchar, getdate(),111) "
	sql = sql & " and SITUACAO = 'A' "
	cnn.execute sql

	'atualiza saldo substituicao
	sql = " update s set s.Saldo_Substituicao = null"
	sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE m"
	sql = sql & " inner join SRH_MODULACAO_DISCIPLINAR_DOCENTE s on s.codigo = m.Cod_Modulacao_Substituicao"
	sql = sql & " where m.Status = 'I'"
	sql = sql & " and m.Cod_Modulacao_Substituicao is not null"
	cnn.execute sql

	strBotaoVoltaTelaAnterior = "ModulacaoNovo_cad.asp"
	strPaginaTitulo = "ModulacaoNovoAutorizacao_con.asp"
	
	strPagina						= "ModulacaoNovoAutorizacao_con.asp"
	strAnoLetivo			= session("strAnoLetivo")
	if request.form("txtAnoLetivo")<>"" then
		strAnoLetivo = request.form("txtAnoLetivo")
	end if
	
	strSituacao = request("cmbSituacao")
	if strSituacao = "" then strSituacao = "E"
	
	intCodEmpresaGrupo = request("cmbEmpresaGrupo")
	if intCodEmpresaGrupo = "" then intCodEmpresaGrupo = "0"

%>
	<form method="post" name="frm" id="frm" action="ModulacaoNovoAutorizar_con.asp">	

	 <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Relação de Pedidos de Modulação</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                
                <input name="txtCodigo" type="hidden" id="txtCodigo">
                    <div class="form-group">
                        <label class="form-label">Situação</label>
                          <select name="cmbSituacao" id="cmbSituacao" style="width:230pt" class="form-control" onchange="submit()">
							<option <%if strSituacao = "E" then response.write "selected"%> value="E">Aguardando Autorização</option>
							<option <%if strSituacao = "A" then response.write "selected"%> value="A">Autorizado</option>
							<option <%if strSituacao = "N" then response.write "selected"%> value="N">Nao Autorizado</option>
							<option <%if strSituacao = "X" then response.write "selected"%> value="X">Excluído</option>
							<option <%if strSituacao = "I" then response.write "selected"%> value="I">Inativo</option>
							<option <%if strSituacao = "0" then response.write "selected"%> value="0">Todas</option>
						</select>
                    </div>
					<div class="form-group">
                        <label class="form-label">Unidade</label>
							<!--#include file="../includes/inc_cmbEmpresaGrupo.asp"-->
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
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de pedidos de modulação para <%=strAnoLetivo%></h3>
            </div>
			
				<div class="panel-body">
					<table class="table table-bordered">
						<thead>
								<tr bgcolor="#E5E5E5" class="letra10">
									<th height="26" class="letra10">Editar</th>
									<th height="26" class="letra10">Unidade</th>
									<th height="26" class="letra10">Colaborador</th>
									<th class="letra10">Fun&ccedil;&atilde;o</th>
									<th align="center" class="letra10">Data Inicial / Final</th>
									<th class="letra10">Per&iacute;odo</th>
									<th class="letra10">Turno</th>
									<th class="letra10">Sit. Disciplinar</th>
									<th class="letra10">Disciplina</th>
									<th width="50" class="letra10">Aulas/Entrada</th>
									<th class="letra10">Origem</th>
									<th class="letra10">Ação</th>
								</tr>
								</thead>
								 <tbody>
							  <%
							  if trim(strAnoLetivo) <> "" then
							  
								sql = "select co.nome as colaborador, dd.tipoModulacao, dd.justificativa, dd.usuario_excl, dd.data_hora_excl, dd.Codigo, dd.Situacao_disciplinar, p.Descricao as periodo, t.desc_turno as turno, dd.usuario_inativacao, dd.Data_Inativacao,  "
								sql = sql & " dd.Total_Aulas, dd.tipo_contratacao, dd.periodo_inicial, dd.usuario_incl, dd.data_hora_incl, dd.usuario_altr, dd.data_hora_altr, dd.usuario_situacao, dd.data_hora_situacao,"
								sql = sql & " case when dd.periodo_final is not null then dd.periodo_final "
								sql = sql & " else dd.DataFinal end as periodo_final, "
								sql = sql & " dd.status, dd.Ano_letivo, dd.Semestre, e.codigo as codemp, e.RAZAOSOCIAL, dd.DataInicial, "
								sql = sql & " case when dd.DataFinal is not null then dd.DataFinal "
								sql = sql & " else dd.periodo_final end as DataFinal, "
								sql = sql & " f.Desc_Funcao as funcao, isnull(dd.Cod_ColaboradorSubstituido,'0') as Cod_Substituicao, dd.Cod_ColaboradorSubstituido, "
								sql = sql & " d.Desc_Disciplina as disciplina, dd.status, e.CodTipoEmpresa, dd.DataInicial_Substituicao, dd.DataFinal_Substituicao "
								sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE dd "
								sql = sql & " inner join SEG_EMPRESA e on e.CODIGO = dd.Cod_empresa "
								sql = sql & " inner join SRH_COLABORADOR CO on CO.CODIGO = dd.Cod_colaborador "
								sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = dd.cod_funcao"
								sql = sql & " left join SCA_disciplina d on d.cod_disciplina = dd.cod_disciplina"
								sql = sql & " left join SRH_TURNO t on t.cod_turno = dd.cod_turno"
								sql = sql & " left join SCA_periodo p on p.cod_periodo = dd.cod_periodo"
								sql = sql & " left join SRH_COLABORADOR_SUBSTITUTO ss on ss.codColaboradorSubstituto = dd.Cod_Colaborador and ss.codigo = dd.Cod_ColaboradorSubstituido"
								sql = sql & " where dd.ano_letivo = " & strAnoLetivo
								if strSituacao <>"0" then
									sql = sql & " and dd.status = '" & strSituacao & "'"
								end if
								if intCodEmpresaGrupo <>"0" then
									sql = sql & " and dd.cod_empresa = " & intCodEmpresaGrupo
								end if
								sql = sql & " order by dd.ano_letivo desc , dd.tipoModulacao desc, Cod_ColaboradorSubstituido, dd.tipo_contratacao desc, dd.codigo"
								'response.write sql
								rs.open sql, cnn
								if rs.eof = false then
									
									Total_Aulas = 0
									cont = 0
									while not rs.eof
									   cont = cont + 1	
									   strSituacaoDisciplinar = rs("Situacao_disciplinar")
									   if strSituacaoDisciplinar = "D" then strSituacaoDisciplinar = "Disciplinar"
									   if strSituacaoDisciplinar = "I" then strSituacaoDisciplinar = "Interdisciplinar"
									   codigo = rs("codigo")
									   if isnull(rs("Cod_ColaboradorSubstituido")) then  
										   strorigem = "MODULAÇÃO"	
										   TipoModSub = "C"
									   else				
										   strorigem = "SUBSTITUICAO"	
										   TipoModSub = "S"
									   end if
									   
										link = "onClick='return resultadoConsulta(" & rs("codigo") & ")'"
										inativado=""
										strStatus = "Ativo"
										if trim(rs("status")) = "A" then 
											cor = "#deffe1"
											strStatus = "Autorizado"
										elseif trim(rs("status")) = "E" then 
											cor = "#def6ff"
											strStatus = "Aguardando Autorização"
										elseif trim(rs("status")) = "X" then 
											cor = "#fd9797"
											strStatus = "Excluído"
										elseif trim(rs("status")) = "N" then 
											cor = "#fdc68e"
											strStatus = "Não Autorizado"
										elseif trim(rs("status")) = "I" then 
											cor = "#C0C0C0"
											link = ""
											strStatus = "Inativo"
											inativado = "&nbsp;&nbsp;&nbsp;&nbsp; Inativado por: " & rs("usuario_inativacao") & " em " & rs("Data_Inativacao")
										end if
									   
									   periodo = ""
									   tipo = "Contratual"
									   
									   if rs("tipo_contratacao") = "A" then 
											periodo = "&nbsp;(" & formatadataAP(rs("periodo_inicial")) & " a " & formatadataAP(rs("periodo_final")) & ")"
											tipo = "Adicional"
											cor = "#faf4c1"
											strorigem = "PERÍODO"	
											link = ""
											TipoModSub = "P"
										end if
										link = "onClick='return resultadoConsulta(" & rs("codigo") & ")'"
										if rs("Cod_Substituicao") <> "0" then 
											cor = "#C0C0C0"
											link = ""
										end if
										if rs("Situacao_disciplinar") = "I" then  
											if trim(ucase(rs("turno"))) = "INTEGRAL" then
												intTAulas = rs("Total_Aulas")*28
											else
												intTAulas = rs("Total_Aulas")*21
											end if                        
										else
											intTAulas = rs("Total_Aulas")
										end if
										
										turno = rs("turno")
										
										if rs("Cod_Substituicao") <> "0" then
											cor = "#6699FF"
										end if
										if strStatus = "Inativo" then
											cor = "#C0C0C0"
										end if
										if not isnull(rs("periodo_final")) then
											strPeriodoFinalComparar = replace(formataDataCalc(rs("periodo_final")),"/","")
											strDataAtualComparar 	= replace(formataDataCalc(date),"/","")
											'response.write rs("periodo_final") & "<br>|"
											'response.write strPeriodoFinalComparar & "<br>|"
											'response.write strDataAtualComparar
											
											if cCur(strPeriodoFinalComparar)<cCur(strDataAtualComparar) then 
												sql = "update SRH_MODULACAO_DISCIPLINAR_DOCENTE set status = 'I', data_inativacao = getdate(), usuario_inativacao = 'Sistema' where codigo = " & rs("codigo") 
												'response.write sql
												cnn.execute sql
												strStatus = "Inativo" 
												cor = "#C0C0C0"
											end if
										end if
										if not isnull(rs("DataInicial")) then
											periodoMod = formatadataAP(rs("DataInicial"))
										end if
										if not isnull(rs("DataFinal")) then
											periodoMod = periodoMod & " - " & formatadataAP(rs("DataFinal"))
										end if
										if rs("Cod_Substituicao") <> "0" then 
											periodoMod = formatadataAP(rs("DataInicial_Substituicao")) & " - " & formatadataAP(rs("DataFinal_Substituicao"))
										end if
										
										acesso = "style='cursor:hand' onMouseOver='return linhaMouseOver(this)' onMouseOut='return linhaMouseOut(this)' "
										inclusoes = ""
										IF NOT ISNULL(rs("data_hora_incl")) THEN inclusoes = "Incluído por: " & rs("usuario_incl") & " | " & rs("data_hora_incl")
										IF NOT ISNULL(rs("data_hora_altr")) THEN inclusoes = inclusoes & " | Alterado por: " & rs("usuario_altr") & " | " & rs("data_hora_altr")
										IF NOT ISNULL(rs("data_hora_situacao")) THEN inclusoes = inclusoes & " | Autorização/Justifiado por: " & rs("usuario_situacao") & " | " & rs("data_hora_situacao")
										IF NOT ISNULL(rs("data_hora_excl")) THEN inclusoes = inclusoes & " | Excluído por: " & rs("usuario_excl") & " | " & rs("data_hora_excl")
										
										   %>
										   <tr   bgcolor="<%=cor%>" class="celula"  >
												<td rowspan="2"<%if rs("status") <> "N" AND rs("status") <> "X" then%> <%=acesso%>  <%=link%><%end if%> width="26" class="celula8" valign="middle">
													<%if Session("CodPerfilAcessoRH") = "72" then%>
														<%if rs("status") <> "N" AND rs("status") <> "X" then%>
															<button class="btn btn-primary" type="button"><i class="fa fa-edit"></i></button>
														<%end if%>
													<%end if%>
												</td>
											   <td width="196" class="letra10">&nbsp;<%=trim(rs("RAZAOSOCIAL"))%></td>
											   <td width="180" class="letra10">&nbsp;<%=trim(rs("colaborador"))%></td>
											   <td width="180" class="letra10">&nbsp;<%=trim(rs("funcao"))%><%=periodo%></td>
											   <td width="170" align="center" class="letra10"><%=periodoMod%>&nbsp;</td>
											   <td width="63" class="letra10">&nbsp;<%=trim(rs("periodo"))%></td>
											   <td width="62" class="letra10">&nbsp;<%=trim(turno)%>                           </td>
											   <td width="93" class="letra10">&nbsp;<%=strSituacaoDisciplinar%></td>
											   <td width="73" height="26" class="letra10">&nbsp;<%=trim(rs("disciplina"))%></td>
											   <td height="26" align="center" class="letra10">&nbsp;<%=trim(intTAulas)%></td>
											 <td width="79" class="letra10" style="cursor:hand" 
											 <%if rs("status") = "A" then%>
											 <%if TipoModSub <> "S" then %>
												onclick="return gerarImpressao('<%=rs("codemp")%>','<%=TipoModSub%>','<%=left(strStatus,1)%>','<%=rs("Ano_letivo")%>','<%=intCodColaborador%>','<%=trim(rs("tipo_contratacao"))%>')"
											 <%end if%>
											 
											 <%if TipoModSub = "S" then %>
												onclick="return gerarImpressaoSub('<%=rs("codigo")%>')"
											 <%end if%>
											 <%end if%>
											 >&nbsp;<%=trim(strorigem)%><%if rs("status") = "A" then%><span class="letra10" style="cursor:hand"><img src="../../images/impressora_on.gif" width="26" height="26"></span><%end if%></td>
											<td align="left"  class="letra10"  width="60">
												<%if rs("status") = "E" and Session("CodPerfilAcessoRH") = "72" then %>
													<button class="btn-u btn-u-blue" onclick="autorizar('<%=trim(rs("codigo"))%>','A')" type="button"><i class="fa fa-check-circle-o"></i></button>Autorizar
													<br>
													<br>
													<button class="btn-u btn-u-red" onclick="autorizar('<%=trim(rs("codigo"))%>','E')" type="button"><i class="fa fa-close"></i></button>Não Autorizar
													<br>Justificativa: <br>
													<input name="txtJustificativa<%=trim(rs("codigo"))%>" type="text" class="form-control" id="txtJustificativa<%=trim(rs("codigo"))%>" size="20" maxlength="100" >
												<%else%>
													<%if rs("status") = "E" and isnull(rs("justificativa")) then %>
													Aguardando Autorização
													<%else%>
													<%=rs("justificativa")%>
													<%end if%>
												<%end if%>
											</td> 
									</tr>
									<TR   bgcolor="<%=cor%>" >
											<td colspan="11" align="center" class="letra10"><%=inclusoes%>&nbsp;<%=inativado%></td>
											</TR>
									   <% 
										if rs("status") = "A" then
											Total_Aulas = Total_Aulas + intTAulas
										end if
									   rs.movenext
									wend
									%>
									<tr> 

									<td height="21" class="letra10" colspan="2"><span class="texto"><strong>Total Registros :</strong></span> <strong><%=cont%></strong></td>
									<td height="21" colspan="6" align="right" class="celula"><span class="texto"><strong>Total:</strong></span></td>
									<td height="21" align="center" class="letra10"><strong><%=Total_Aulas%></strong></td>
									<td height="21" colspan="2" class="letra10">&nbsp;</td>
									<%
								end if
								rs.close
								 %>
								 </tbody>
								  </table> 
								  <br>
								  <table align="center" width="40%" border="0" cellspacing="0" cellpadding="0" class="tabela">
									  <tr>
										<td class="celula" bgcolor="#deffe1">&nbsp;</td>
										<td class="celula">&nbsp;Modula&ccedil;&atilde;o Autorizada</td>
									  </tr>
									  <tr>
										<td class="celula" bgcolor="#def6ff">&nbsp;</td>
										<td class="celula">&nbsp;Modula&ccedil;&atilde;o Aguardando Autorização</td>
									  </tr>
									  <tr>
										<td class="celula" width="17%" bgcolor="#fdc68e">&nbsp;</td>
										<td class="celula" width="83%">&nbsp;Modula&ccedil;&atilde;o Não Autorizada</td>
									  </tr>
									  <tr>
										<td class="celula" width="17%" bgcolor="#faf4c1">&nbsp;</td>
										<td class="celula" width="83%">&nbsp;Por Período</td>
									  </tr>
									  <tr>
										<td class="celula" width="17%" bgcolor="#6699FF">&nbsp;</td>
										<td class="celula" width="83%">&nbsp;Substituição</td>
									  </tr>
									  <tr>
										<td class="celula" width="17%" bgcolor="#fd9797">&nbsp;</td>
										<td class="celula" width="83%">&nbsp;Modula&ccedil;&atilde;o Excluída</td>
									  </tr>
									  <tr>
										<td class="celula" width="17%" bgcolor="#COCOCO">&nbsp;</td>
										<td class="celula" width="83%">&nbsp;Modula&ccedil;&atilde;o Inativa</td>
									  </tr>
									</table>
								  <%	
							 end if	
							 %>
							  </td>
							</tr>
						</table>
        
                    </div>
               
            	</div>
   	 	</div>
         	<!-- Fecha o Form -->  
      </div>
     <!-- Fecha o Painel do Formulario -->        
    </div>
    <%if intTotalAulasAlteracao = "" then intTotalAulasAlteracao = 0%>
    <br>
	<input value="<%=Total_Aulas%>" id="Total_Aulas_Grid" name="Total_Aulas_Grid" type="hidden">
     </form>
    <!--/container-->		
	
	<script>

	function limpar(Pagina){
		
		var frm = document.getElementById("frm");
		
		frm.action= Pagina;
		document.getElementById('frm').submit();
		return true;
		
	}

	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.action="ModulacaoNovo_cad.asp?p=s";
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	
	function gerarImpressao(codEmp, TipoModSub, Status, AnoLetivo, codColaborador, origem){
		var frm = document.getElementById("frm");
//		window.open("ColaboradorSubstitutoDeficit_rel.asp?TipoModSub="+TipoModSub+"&Status="+Status+"&AnoLetivo="+AnoLetivo+"&CodColaborador="+codColaborador +"&origem="+ origem,"abreConsulta","top=5,left=5,height=600,width=800,menubar=no,toolbar=no,scrollbars=yes,status=yes");
 		
		window.open("ColaboradorSubstitutoTexto_rel.asp?codEmp="+codEmp+"&TipoModSub="+TipoModSub+"&Status="+Status+"&AnoLetivo="+AnoLetivo+"&CodColaborador="+codColaborador +"&origem="+ origem,"abreConsulta","top=5,left=5,height=600,width=800,menubar=no,toolbar=no,scrollbars=yes,status=yes");
		return false	
	}
	function gerarImpressaoSub(CodSubstituicao){
		window.open("ColaboradorSubstitutoModulacao_rel.asp?CodSubstituicao="+CodSubstituicao,"abreConsulta","top=5,left=5,height=600,width=800,menubar=no,toolbar=no,scrollbars=yes,status=yes");
		return false	
	}
	
	function autorizar(intCodigo, acao){
		var frm = document.getElementById("frm");
		var justificativa = document.getElementById("txtJustificativa" + intCodigo).value;
		var situacao = document.getElementById("cmbSituacao").value;
		if (acao=="A"){
			if(confirm("Deseja Autorizar essa modulação?")) {
				frm.action="ModulacaoNovo_cod.asp?situacao_retorno="+situacao+"&retorno=ModulacaoNovoAutorizar_con.asp&acao=AUTORIZAR&txtCodigo=" + intCodigo + "&txtJustificativa=" + justificativa;
				frm.submit();
				return true;
			}			
		}
		if (acao=="E"){
			
			if (justificativa==""){
				alert("A justificativa deve ser informada!")
				return false;
			}
		
			frm.action="ModulacaoNovo_cod.asp?situacao_retorno="+situacao+"&retorno=ModulacaoNovoAutorizar_con.asp&acao=NAO_AUTORIZAR&txtCodigo=" + intCodigo + "&txtJustificativa=" + justificativa;
			frm.submit();
			return true;
		}
	}
	function voltarModulacao(){
		window.location="ModulacaoNovo_cad.asp";
	}
</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 