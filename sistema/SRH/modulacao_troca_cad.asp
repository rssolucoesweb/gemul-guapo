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
    strPaginaTitulo = "modulacao_troca_cad.asp"

	strDesabilitaIncluir = " "
	strDesabilitaAlterar = " Disabled "
	strDesabilitaExcluir = " Disabled "
	
	intCodFuncionarioAtual = request.form("txtCodFuncionario")
	intCodFuncionalAtual = request.form("txtCodigoFuncionalAtual")
	
	intCodFuncionarioDestino = request.form("txtCodFuncionarioDestino")
	intCodFuncionalDestino = request.form("txtCodigoFuncionalDestino")
	
	strDataMovimentacao = request.form("txtDataMovimentacao")
	if strDataMovimentacao = "" then strDataMovimentacao = formatadataAP(date)
	'response.write "intCodFuncionalAtual:" & intCodFuncionalAtual
	'response.write "<br>intCodFuncionalDestino:" & intCodFuncionalDestino
'	response.End()
	if trim(intCodFuncionarioAtual) <> "" then
		strNomeColaboradorAtual = "<font color='#FF0000'>Não encontrado!</font>"
		sql = "SELECT  c.nome, c.codigo, f.situacao_disciplinar, f.desc_funcao, c.codFuncional "
		sql = sql & " FROM SRH_COLABORADOR c left join srh_funcaocolaborador f on f.Cod_Funcao = c.codfuncao "
		sql = sql & " inner join SEG_EMPRESA e ON e.CODIGO = c.CodLotacao and e.cod_grupo=" & session("CodGrupo")
		sql = sql & " Where c.codigo = " & intCodFuncionarioAtual
		rs.open sql, cnn
		if rs.eof = false then
			strNomeColaboradorAtual					= Trim(Rs("nome"))
			intCodColaboradorAtual					= Trim(Rs("codigo"))
			intCodFuncionalAtual					= Trim(Rs("codFuncional"))
			situacao_disciplinar_colaborador_atual  = rs("situacao_disciplinar")
		end if 
		rs.close
	end if
	if trim(intCodFuncionalAtual) <> "" and intCodFuncionarioAtual="" then
		strNomeColaboradorAtual = "<font color='#FF0000'>Não encontrado!</font>"
		sql = "SELECT  c.nome, c.codigo, f.situacao_disciplinar, f.desc_funcao "
		sql = sql & " FROM SRH_COLABORADOR c left join srh_funcaocolaborador f on f.Cod_Funcao = c.codfuncao "
		sql = sql & " inner join SEG_EMPRESA e ON e.CODIGO = c.CodLotacao and e.cod_grupo=" & session("CodGrupo")
		sql = sql & " Where c.CodFuncional = " & intCodFuncionalAtual
		
		rs.open sql, cnn
		if rs.eof = false then
			strNomeColaboradorAtual					= Trim(Rs("nome"))
			intCodColaboradorAtual					= Trim(Rs("codigo"))
			
			situacao_disciplinar_colaborador_atual  = rs("situacao_disciplinar")
		end if 
		rs.close
	end if
	
	'--destino
	if trim(intCodFuncionarioDestino) <> "" then
		strNomeColaboradorDestino = "<font color='#FF0000'>Não encontrado!</font>"
		strNomeColaboradorDestinoHidden = ""
		sql = "SELECT  c.nome, c.codigo, f.situacao_disciplinar, f.desc_funcao, c.codFuncional "
		sql = sql & " FROM SRH_COLABORADOR c left join srh_funcaocolaborador f on f.Cod_Funcao = c.codfuncao "
		sql = sql & " inner join SEG_EMPRESA e ON e.CODIGO = c.CodLotacao and e.cod_grupo=" & session("CodGrupo")
		sql = sql & " Where c.codigo = " & intCodFuncionarioDestino
		rs.open sql, cnn
		if rs.eof = false then
			strNomeColaboradorDestino				= Trim(Rs("nome"))
			strNomeColaboradorDestinoHidden				= Trim(Rs("nome"))
			intCodColaboradorDestino				= Trim(Rs("codigo"))
			intCodFuncionalDestino					= Trim(Rs("codFuncional"))
			situacao_disciplinar_colaborador_destino = rs("situacao_disciplinar")
		end if 
		rs.close
	end if
	if trim(intCodFuncionalDestino) <> "" and intCodFuncionarioDestino = "" then
		strNomeColaboradorDestino = "<font color='#FF0000'>Não encontrado!</font>"
		strNomeColaboradorDestinoHidden = ""
		sql = "SELECT  c.nome, c.codigo, f.situacao_disciplinar, f.desc_funcao "
		sql = sql & " FROM SRH_COLABORADOR c left join srh_funcaocolaborador f on f.Cod_Funcao = c.codfuncao "
		sql = sql & " inner join SEG_EMPRESA e ON e.CODIGO = c.CodLotacao and e.cod_grupo=" & session("CodGrupo")
		sql = sql & " Where c.CodFuncional = " & intCodFuncionalDestino
		rs.open sql, cnn
		if rs.eof = false then
			strNomeColaboradorDestino				= Trim(Rs("nome"))
			strNomeColaboradorDestinoHidden				= Trim(Rs("nome"))
			intCodColaboradorDestino				= Trim(Rs("codigo"))
			situacao_disciplinar_colaborador_destino = rs("situacao_disciplinar")
		end if 
		rs.close
	end if
    %>
<!--=== Content Part ===-->
    <div class="container content">
        <div class="row">
            <!-- Begin Content -->
            <div class="col-md-12" >     

       		<!-- Inicia o Painel do Formulario --> </font>    

                <form id="frm" name="frm" action="modulacao_troca_cad.asp" class="sky-form panel-body0" method="post">
                	<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
                    <input name="txtCodFuncionario" type="hidden" id="txtCodFuncionario" class="text" size="10" value="<%=intCodColaboradorAtual%>" maxlength="10">
                    <input name="txtNomeFuncionario" type="hidden" id="txtNomeFuncionario" class="text" size="10" value="<%=strNomeColaboradorAtual%>" maxlength="10">
                    <input name="txtCodFuncionarioDestino" type="hidden" id="txtCodFuncionarioDestino" class="text" size="10" value="<%=intCodColaboradorDestino%>" maxlength="10">
                    <input name="txtNomeFuncionarioDestino" type="hidden" id="txtNomeFuncionarioDestino" class="text" size="10" value="<%=strNomeColaboradorDestinoHidden%>" maxlength="10">
                    <div style="background:#95a5a6;height:40px;padding-top: 8px;" class="panel-title">&nbsp;&nbsp;<font color="#FFFFFF"><i class="fa fa-tasks"></i>&nbsp;Troca da Modulação</font></div>

                    <fieldset>
                        <div class="row">
                             <section class="col col-2">
                                <label class="form-label">Matrícula Funcional</label>
                              
                                <label class="input">
                                     <input name="txtCodigoFuncionalAtual" type="text" class="text" id="txtCodigoFuncionalAtual" size="12" maxlength="8" value="<%=intCodFuncionalAtual%>"  onKeyPress="return formataCampo(this, 2, 8)">
                                </label>
                             </section>
                             <section class="col col-1">
                                <label class="form-label">&nbsp;</label>
                              
                                <label class="input">
                                     <button class="btn btn-success" onclick="return abreConsultaColaborador('Colaborador_con.asp?PaginaOrigem=modulacao_troca_cad')" type="button"><i class="fa fa-search"></i></button>
                                </label>
                             </section>
                             <section class="col col-9">
                                <label class="form-label">Localizar?</label>
                              
                                <label>
                                     <input type="checkbox" name="LocalizarMatricula" value="S" onClick='submit()'>   
                                </label>
                             </section>
                        </div>
						<%if intCodColaboradorAtual <> "" then%>
                       	<div class="row">
                             <section class="col col-8">
                                <label class="form-label">Colaborador</label>
                              
                                <label class="input">
                                     <input type="text" class="form-control" disabled  size="100" value="<%=strNomeColaboradorAtual%>">
                                </label>
                             </section>
                             <section class="col col-2">
                                <label class="form-label">Por Período</label>
                              
                                <label>
                                     <input type="checkbox" name="chkPorPeriodoOrigem" value="S"> 
                                </label>
                             </section>
                             <section class="col col-2">
                                <label class="form-label">Data da Movimentação</label>
                              
                                <label class="input">
                                    <input name="txtDataMovimentacao" type="text" class="form-control" id="txtDataMovimentacao" onblur="return validaData(this)" onkeypress="return formataCampo(this, 3, 10)" size="11" value="<%=strDataMovimentacao%>">
                                </label>
                                
                             </section>
                        </div>
                        <!--Table Bordered-->
                        <div class="panel panel-grey margin-bottom-40">
                            <div class="panel-body">
                                <div class="table-responsive">
                                    <%
                                    codColaborador = intCodColaboradorAtual
                                    %>
                                    <!--#include file="../includes/inc_ListaModulacaoColaboradorTroca.asp" -->
                                </div>
                            </div>                      
                        </div>
                        <!--End Table Bordered-->
                        <%end if%>
                     </fieldset>
                     
                     
                     <fieldset>
                        <div class="row">
                             <section class="col col-2">
                                <label class="form-label">Matrícula para Troca</label>
                              
                                <label class="input">
                                     <input name="txtCodigoFuncionalDestino" type="text" class="text" id="txtCodigoFuncionalDestino" size="12" maxlength="8" value="<%=intCodFuncionalDestino%>"  onKeyPress="return formataCampo(this, 2, 8)">
                                </label>
                             </section>
                             <section class="col col-1">
                                <label class="form-label">&nbsp;</label>
                              
                                <label class="input">
                                     <button class="btn btn-success" onclick="return abreConsultaColaboradorDestino('ColaboradorDestino_con.asp?PaginaOrigem=modulacao_troca_cad')" type="button"><i class="fa fa-search"></i></button>
                                </label>
                             </section>
                             <section class="col col-9">
                                <label class="form-label">Localizar?</label>
                              
                                <label>
                                     <input type="checkbox" name="LocalizarMatricula" value="S" onClick='submit()'>   
                                </label>
                             </section>
                        </div>
					   <%if intCodColaboradorDestino <> "" then%>
                       <div class="row">
                             <section class="col col-8">
                                <label class="form-label">Colaborador Destino</label>
                              
                                <label class="input">
                                     <input type="text" class="form-control" disabled  size="100" value="<%=strNomeColaboradorDestino%>">
                                </label>
                             </section>
                             <section class="col col-3">
                                <label class="form-label">Por Período</label>
                              
                                <label>
                                     <input type="checkbox" name="chkPorPeriodoDestino" value="S"> 
                                </label>
                             </section>
                        </div>
                        <!--Table Bordered-->
                        <div class="panel panel-grey margin-bottom-40">
                            <div class="panel-body">
                                <div class="table-responsive">
                                    <%
                                    codColaborador = intCodColaboradorDestino
                                    %>
                                    <!--#include file="../includes/inc_ListaModulacaoColaboradorTrocaDestino.asp" -->
                                </div>
                            </div>                      
                        </div>
                        <!--End Table Bordered-->
                        <%end if%>
                     </fieldset>
                     				

					<div class="margin-left-40">
	                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
					</div>
                    
                    <br>
                    
                 </form>                
                
                
				<%
            
                    sql = "select t.codigo, c.nome as nome_origem, cd.nome as nome_destino, t.data_movimentacao, t.usuario_incl, t.data_hora_incl "
					sql = sql & " from SRH_TROCA_MODULACAO_HISTORICO t "
					sql = sql & " inner join srh_COLABORADOR c on c.codigo = t.cod_Colaborador_origem "
					sql = sql & " left join srh_COLABORADOR cd on cd.codigo = t.cod_Colaborador_destino "
					sql = sql & " where year(t.data_movimentacao)=" & year(date)
					sql = sql & " order by 1 desc"
                    RS.OPEN SQL, CNN
                    IF NOT RS.EOF THEN
                    %> 
                  <div class="panel panel-grey">
                        <div class="panel-heading">
                            <h3 class="panel-title"><i class="fa fa-tasks"></i> Troca de Modulações efetuadas em <strong><%=year(date)%></strong>
                            </h3>
                        </div>
                        <div class="panel-body">
                        <table class="table table-bordered" >
                            <thead>
                          <tr  bgcolor="#E2E2E2">
                                    <th width="1%">Cód</th>
                                    <th width="25%" >Colaborador Origem</th>
                                    <th width="25%" >Colaborador Destino</th>
                                    <th width="13%" align="center"><strong>Data Movimentação</strong></td>
                                    <th width="13%"><strong>Inclusão</strong></td>
                                    <th width="15%"><strong>Data</strong></td>
                                </tr>
                            </thead>
                            <%
                            
                            Total_Aulas = 0
                            while not rs.eof

                                %>
                                <tr>
                                  	<td><%=RS("codigo")%></td>
                                    <td><%=RS("nome_origem")%></td>
                                    <td><%=RS("nome_destino")%>&nbsp;</td>
                                    <td><%=RS("data_movimentacao")%></td>
                                    <td><%=RS("usuario_incl")%></td>
                                    <td><%=RS("data_hora_incl")%></td>
                                </tr>
                                <%				
                                    rs.movenext
                                wend
                            %>
                        </table>
                      </div>
            </div>
                    <%
                    RS.CLOSE
                END IF
            %> 




			</div>
         	<!-- Fecha o Form -->  
      </div>

        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
    
   	   
	<script>
        function resultadoConsulta(intCodigo){
            var frm = document.getElementById("frm");
            frm.txtCodigo.value=intCodigo;
            frm.submit();
        }
		
		function abreConsultaColaborador(caminho){
            window.open(caminho,"abreColoboradortroca","top=5,left=5,height=510,width=1000,menubar=no,toolbar=no,scrollbars=yes,status=yes");
        }
		function abreConsultaColaboradorDestino(caminho){
            window.open(caminho,"abreColoboradortroca","top=5,left=5,height=510,width=1000,menubar=no,toolbar=no,scrollbars=yes,status=yes");
        }
        
        function salvar(acao){
            
            var frm = document.getElementById("frm");
            var selecionado = 'N';
			
            if (frm.txtCodigoFuncionalAtual.value == "") {
                alert("O colaborador de origem deve ser informado!");
                frm.txtCodigoFuncionalAtual.focus();
                return false;
            }
            if (frm.txtCodigoFuncionalDestino.value == "") {
                alert("O colaborador de destino deve ser informado!");
                frm.txtCodigoFuncionalDestino.focus();
                return false;
            }
			
			for (var i = 0; i < frm.elements.length; i++) {
				//verifica todos os checkbox
				if (frm.elements[i].type == "checkbox"){	
					if (frm.elements[i].name == "chkOrigem"){
						if (frm.elements[i].checked){	
							selecionado = 'S';
						}
					}
				}
			}	
			
			if (selecionado == 'N') {
                alert("Não foi selecionada nenhuma modulação para a troca!");
                return false;
            }		
            
            frm.action="modulacao_troca_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
		
		function verificaDestino(){
			var frm = document.getElementById("frm");
			if (frm.txtNomeFuncionarioDestino.value==""){
                alert("O colaborador de destino deve ser informado antes de ser selecionado as modulações de origem!");
                frm.txtCodigoFuncionalDestino.focus();
                return false;
			}
		}
    
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 