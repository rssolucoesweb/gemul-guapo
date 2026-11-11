
<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
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
	intCodRegiao 	= Trim(Request("cmbRegiao"))
	if intCodRegiao = "" then intCodRegiao = "0"
	strBotaoPedidoDeRemocaoSolicitados = "S"
	strTipo 	= Trim(Request("cmbTipo"))
	if strTipo = "" then strTipo = "R"
	strAnoletivo = Trim(Request("txtAnoLetivo"))
	if strAnoletivo = "" then strAnoletivo = year(date)
	intCodTurno = Trim(Request.form("cmbTurnoRH"))
	observacao		= Trim(Trim(Request.Form("observacao")))
	strMotivo		= Trim(Trim(Request.Form("cmbMotivo")))
	
	strDesabilitaIncluir = "" ' Desabilita o botão Incluir
	strDesabilitaAlterar = "disabled" ' Desabilita o botão Alterar
	strDesabilitaExcluir = "disabled" ' Desabilita o botão Excluir
	strDesabilitaLimpar  = "" ' Habilita o Botão Limpar
    	
	intCodFuncionarioAtual = request.form("txtCodFuncionario")
	intCodFuncionalAtual = request.form("txtCodigoFuncionalAtual")
	intCodigo = request.form("txtCodigo")
	if intCodigo <>"" then
		strNomeColaboradorAtual = "Não encontrado!"
		sql = "SELECT e.codigo as codEmpresa, pr.ano_letivo, e.razaosocial as empresa, pr.cod_regiao1, pr.cod_regiao2, pr.cod_regiao3, pr.cod_empresa_1opcao, pr.cod_empresa_2opcao, pr.cod_empresa_3opcao, pr.cod_turno_escolhido, c.nome, c.codigo, f.situacao_disciplinar, f.cod_funcao, f.desc_funcao, c.codFuncional, t.cod_turno, t.Desc_Turno as turno, ca.cod_cargo, ca.Desc_Cargo as cargo, pr.observacao, pr.cod_motivo_remocao "
		sql = sql & " FROM SRH_COLABORADOR c "
		sql = sql & " inner join SRH_PEDIDO_REMOCAO pr on pr.cod_colaborador = c.codigo"
		sql = sql & " left join seg_empresa e on e.codigo = c.codLotacao and e.cod_grupo=" & session("CodGrupo")
		sql = sql & " left join srh_funcaocolaborador f on f.Cod_Funcao = c.codfuncao "
		sql = sql & " left join srh_cargocolaborador ca on ca.Cod_Cargo = c.CodCargo "
		sql = sql & " left join srh_turno t on t.Cod_Turno = c.codturno"
		sql = sql & " Where pr.codigo = " & intCodigo
		rs.open sql, cnn
		if rs.eof = false then
			strNomeColaboradorAtual					= Trim(Rs("nome"))
			intCodColaboradorAtual					= Trim(Rs("codigo"))
			intCodFuncionalAtual					= Trim(Rs("codFuncional"))
			situacao_disciplinar_colaborador_atual  = rs("situacao_disciplinar")
			strAnoletivo							= rs("ano_letivo")
			intCodRegiao1							= rs("cod_regiao1")
			intCodRegiao2							= rs("cod_regiao2")
			intCodRegiao3							= rs("cod_regiao3")

			intCodEmpresa1							= rs("cod_empresa_1opcao")
			intCodEmpresa2							= rs("cod_empresa_2opcao")
			intCodEmpresa3							= rs("cod_empresa_3opcao")
			
			observacao								= rs("observacao")
			strMotivo								= rs("cod_motivo_remocao")
			
			if not isnull(intCodRegiao1) 	then strTipo = "R"
			if not isnull(intCodEmpresa1) 	then strTipo = "U"
			
			strCodEmpresaAtual						= rs("codEmpresa")
			strEmpresaAtual							= rs("empresa")
			strCodFuncaoAtual						= rs("cod_funcao")
			strFuncaoAtual							= rs("desc_funcao")
			strCodCargoAtual						= rs("cod_cargo")
			strCargoAtual							= rs("cargo")
			strCodTurnoAtual						= rs("cod_turno")
			strTurnoAtual							= rs("turno")
			intCodturno								= rs("cod_turno_escolhido")
			
			strDesabilitaIncluir = "disabled" ' Desabilita o botão Incluir
			strDesabilitaAlterar = "" ' Desabilita o botão Alterar
			strDesabilitaExcluir = "" ' Desabilita o botão Excluir
			strDesabilitaLimpar  = "" ' Habilita o Botão Limpar
			
		end if 
		rs.close
	end if
	if trim(intCodFuncionarioAtual) <> "" and intCodigo = "" then
		strNomeColaboradorAtual = "Não encontrado!"
		sql = "SELECT e.codigo as codEmpresa, e.razaosocial as empresa,  c.nome, c.codigo, f.situacao_disciplinar, f.cod_funcao, f.desc_funcao, c.codFuncional, t.cod_turno, t.Desc_Turno as turno, ca.cod_cargo, ca.Desc_Cargo as cargo "
		sql = sql & " FROM SRH_COLABORADOR c "
		sql = sql & " left join seg_empresa e on e.codigo = c.codLotacao and e.cod_grupo=" & session("CodGrupo")
		sql = sql & " left join srh_funcaocolaborador f on f.Cod_Funcao = c.codfuncao "
		sql = sql & " left join srh_cargocolaborador ca on ca.Cod_Cargo = c.CodCargo "
		sql = sql & " left join srh_turno t on t.Cod_Turno = c.codturno"
		sql = sql & " Where c.codigo = " & intCodFuncionarioAtual
		rs.open sql, cnn
		if rs.eof = false then
			strNomeColaboradorAtual					= Trim(Rs("nome"))
			intCodColaboradorAtual					= Trim(Rs("codigo"))
			intCodFuncionalAtual					= Trim(Rs("codFuncional"))
			situacao_disciplinar_colaborador_atual  = rs("situacao_disciplinar")
			
			strCodEmpresaAtual						= rs("codEmpresa")
			strEmpresaAtual							= rs("empresa")
			strCodFuncaoAtual						= rs("cod_funcao")
			strFuncaoAtual							= rs("desc_funcao")
			strCodCargoAtual						= rs("cod_cargo")
			strCargoAtual							= rs("cargo")
			strCodTurnoAtual						= rs("cod_turno")
			strTurnoAtual							= rs("turno")
		end if 
		rs.close
	end if
	if trim(intCodFuncionalAtual) <> "" and intCodFuncionarioAtual="" and intCodigo = "" then
		strNomeColaboradorAtual = "Não encontrado!"
		sql = "SELECT e.codigo as codEmpresa, e.razaosocial as empresa, c.nome, c.codigo, f.situacao_disciplinar, f.cod_funcao, f.desc_funcao, c.codFuncional, t.cod_turno, t.Desc_Turno as turno, ca.cod_cargo, ca.Desc_Cargo as cargo "
		sql = sql & " FROM SRH_COLABORADOR c "
		sql = sql & " left join seg_empresa e on e.codigo = c.codLotacao and e.cod_grupo=" & session("CodGrupo")
		sql = sql & " left join srh_funcaocolaborador f on f.Cod_Funcao = c.codfuncao "
		sql = sql & " left join srh_cargocolaborador ca on ca.Cod_Cargo = c.CodCargo "
		sql = sql & " left join srh_turno t on t.Cod_Turno = c.codturno"
		sql = sql & " Where c.codFuncional = " & intCodFuncionalAtual
		rs.open sql, cnn
		if rs.eof = false then
			strNomeColaboradorAtual					= Trim(Rs("nome"))
			intCodColaboradorAtual					= Trim(Rs("codigo"))
			intCodFuncionalAtual					= Trim(Rs("codFuncional"))
			situacao_disciplinar_colaborador_atual  = rs("situacao_disciplinar")
			
			strCodEmpresaAtual						= rs("codEmpresa")
			strEmpresaAtual							= rs("empresa")
			strCodFuncaoAtual						= rs("cod_funcao")
			strFuncaoAtual							= rs("desc_funcao")
			strCodCargoAtual						= rs("cod_cargo")
			strCargoAtual							= rs("cargo")
			strCodTurnoAtual						= rs("cod_turno")
			strTurnoAtual							= rs("turno")
		end if 
		rs.close
	end if
	

    %>
  <form id="frm" name="frm" action="pedidoRemocao_cad.asp" class="sky-form panel-body0" method="post">
<!--=== Content Part ===-->
    <div class="container content">
        <div class="row">
            <!-- Begin Content -->
            <div class="col-md-12" >     

       		<!-- Inicia o Painel do Formulario --> </font>    

              
                	<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
                    <input name="txtCodFuncionario" type="hidden" id="txtCodFuncionario" class="text" size="10" value="<%=intCodColaboradorAtual%>" maxlength="10">
                    <input name="txtNomeFuncionario" type="hidden" id="txtNomeFuncionario" class="text" size="10" value="<%=strNomeColaboradorAtual%>" maxlength="10">
                    <div style="background:#95a5a6;height:40px;padding-top: 8px;" class="panel-title">&nbsp;&nbsp;<font color="#FFFFFF"><i class="fa fa-tasks"></i>&nbsp;Pedido de Remoção</font></div>

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
                                     <button class="btn btn-success" onclick="return abreConsultaColaborador('Colaborador_con.asp?PaginaOrigem=pedidoRemocao_cad')" type="button"><i class="fa fa-search"></i></button>
                                </label>
                             </section>
                             <section class="col col-9">
                                <label class="form-label">Localizar?</label>
                              
                                <label>
                                     <input type="checkbox" name="LocalizarMatricula" value="S" onClick='submit()'>   
                                </label>
                             </section>
                        </div>
                        <div class="row">
                             <section class="col col-12">
                                <label class="form-label">Ano Letivo</label>
                              
                                <label class="input">
                                     <input name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" size="5" maxlength="4" value="<%=strAnoLetivo%>" >
                                </label>
                             </section>
                            
                        </div>
                        <div class="row">
                             <section class="col col-12">
                                <label class="form-label">Colaborador</label>
                              
                                <label class="input">
                                     <input disabled style="background:#CCC" name="txtNome" type="text" class="text" id="txtNome" size="100" maxlength="8" value="<%=strNomeColaboradorAtual%>" >
                                </label>
                             </section>
                        </div>
                        	<div class="row">
                                <section class="col col-12">
                                    <label class="form-label">Unidade Atual</label>
                                    <label class="input">
                                        <input name="txtCodEmpresaAtual" type="hidden" id="txtCodEmpresaAtual" size="100" maxlength="8" value="<%=strCodEmpresaAtual%>" >
                                        <input disabled style="background:#CCC" name="txtEmpresaAtual" type="text" class="text" id="txtEmpresaAtual" size="100" maxlength="8" value="<%=strEmpresaAtual%>" >
                                    </label>
                                </section>
                        	</div>
                        	<div class="row">
                                <section class="col col-12">
                                    <label class="form-label">Cargo Atual</label>
                                    <label class="input">
                                        <input name="txtCodFuncaoAtual" type="hidden" id="txtCodFuncaoAtual" size="100" maxlength="8" value="<%=strCodFuncaoAtual%>" >
                                        <input disabled style="background:#CCC" name="txtFuncaoAtual" type="text" class="text" id="txtFuncaoAtual" size="100" maxlength="8" value="<%=strFuncaoAtual%>" >
                                    </label>
                                </section>
                        	</div>
                        	<div class="row">
                                <section class="col col-12">
                                    <label class="form-label">Função Atual</label>
                                    <label class="input">
                                        <input name="txtCodCargoAtual" type="hidden" id="txtCodCargoAtual" size="100" maxlength="8" value="<%=strCodCargoAtual%>" >
                                        <input disabled style="background:#CCC" name="txtCargoAtual" type="text" class="text" id="txtCargoAtual" size="100" maxlength="8" value="<%=strCargoAtual%>" >
                                    </label>
                                </section>
                        	</div>
							<div class="row">
                                <section class="col col-12">
                                    <label class="form-label">Turno Atual</label>
                                    <label class="input">
                                        <input name="txtCodTurnoAtual" type="hidden" id="txtCodTurnoAtual" size="100" maxlength="8" value="<%=strCodTurnoAtual%>" >
                                        <input disabled style="background:#CCC" name="txtTurnoAtual" type="text" class="text" id="txtTurnoAtual" size="100" maxlength="8" value="<%=strTurnoAtual%>" >
                                    </label>
                                </section>
                        	</div>
                  			<div class="row">
                                <section class="col col-12">
                                    <label class="form-label">Informe o motivo?</label>
                                    <label class="form-label">
									<select name="cmbMotivo" id="cmbMotivo" style="width:230pt" class="form-control">
										<option <%if strMotivo = "0" then response.write "selected"%> value="0">Selecione...</option>
										<option <%if strMotivo = "1" then response.write "selected"%> value="1">Pedido do servidor</option>
										<option <%if strMotivo = "2" then response.write "selected"%> value="2">Permuta</option>
										<option <%if strMotivo = "3" then response.write "selected"%> value="3">Necessidade da secretaria</option>
										<option <%if strMotivo = "4" then response.write "selected"%> value="4">Outros</option>
									</select>
                                </section>
                        	</div>
							<div class="row">
                                <section class="col col-12">
                                    <label class="form-label">Observação</label>
                                    <label class="input">
										<textarea name="observacao" cols="100" rows="2"><%=observacao%></textarea>
                                    </label>
                                </section>
                        	</div>
							
                        	
                  			<div class="row">
                                <section class="col col-12">
                                    <label class="form-label">Turno escolhido</label>
                                    <!--#include file="../includes/inc_cmbTurno.asp" -->
                                </section>
                        	</div>
                     </fieldset>
                        
                      <fieldset>  
						<%if intCodColaboradorAtual <> "" then%>
                       	<div class="row">
                             <section class="col col-12">
                                <label class="form-label">Tipo</label>
                              
                                <label class="input">
                                     <select name="cmbTipo" id="cmbTipo" style="width:250pt" class="form-control" onchange="submit()">
                                        <option <%if strTipo = "R" then response.write "selected"%> value="R">Por Região (máximo 3)</option>
                                        <option <%if strTipo = "U" then response.write "selected"%> value="U">Por Unidade (máximo 3)</option>
                                    </select>
                                </label>
                             </section>
                        </div>
                        <%end if%>
                     </fieldset>
                     
					<div class="margin-left-40">
	                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
					</div>
                    
                    <br>
                    
				<%
            	if strTipo = "U" then
					sql = "SELECT E.RAZAOSOCIAL, E.COD_REGIAO, E.CODIGO AS COD_EMPRESA "
					sql = sql & " FROM SEG_EMPRESA E"
					sql = sql & " WHERE E.BLOQUEIO='N' AND E.COD_GRUPO = " & Session("CodGrupo")
					sql = sql & " Order by E.RAZAOSOCIAL"
                    RS.OPEN SQL, CNN
                    IF NOT RS.EOF THEN
                    %> 
                  	<div class="panel panel-grey">
                        <div class="panel-heading">
                            <h3 class="panel-title"><i class="fa fa-tasks"></i> Unidades <strong></strong>
                            </h3>
                        </div>
                        <div class="panel-body">
							<table class="table table-bordered">
                                <thead>
                                    <tr>
                                      <th width="3%" bgcolor="#95A5A6"> <input name="chkTodos" type="checkbox" value="" onclick="return marcaTodos()"> </th>
                                      <th width="5%" bgcolor="#95A5A6">Código</th>
                                      <th width="53%" bgcolor="#95A5A6">Unidade</th>
                                  </tr>
                                </thead>
                                 <tbody>
                                <%
                           		cont =0
                                while not rs.eof
                                    cont = cont + 1	
                                    'strMarca 	= ""
									
									strMarca = ""
									if trim(intCodEmpresa1) = trim(rs("cod_empresa")) then
										strMarca = " checked "
									elseif trim(intCodEmpresa2) = trim(rs("cod_empresa")) then
										strMarca = " checked "
									elseif trim(intCodEmpresa3) = trim(rs("cod_empresa")) then
										strMarca = " checked "
									end if
									
                                    %>
                                    <tr>
                                        <td><input name="chkEmp"  type="checkbox"  value="<%=rs("cod_empresa")%>" <%=strMarca%>></td>
                                        <td><%=trim(rs("cod_empresa"))%></td>
                                        <td><%=trim(rs("RAZAOSOCIAL"))%></td>
                                      <%				
                                    rs.movenext
                                    wend
                                end if
                                rs.close
                                %>
                                <tr>
                                    <td colspan="3">Total Registros : <%=cont%></td>
                                </tr>
                            </tbody>
                        </table>
                  </div>
            </div>
                    <%
                END IF
            %> 
            
            <%
            	if strTipo = "R" then
					sql = "select codigo as cod_regiao, descricao "
					sql = sql & " from MAT_REGIAO"
					sql = sql & " where cod_grupo = " & Session("CodGrupo")
					sql = sql & " order by descricao	"			
                    RS.OPEN SQL, CNN
                    IF NOT RS.EOF THEN
                    %> 
                  	<div class="panel panel-grey">
                        <div class="panel-heading">
                            <h3 class="panel-title"><i class="fa fa-tasks"></i> Regiões <strong></strong>
                            </h3>
                        </div>
                        <div class="panel-body">
							<table class="table table-bordered">
                                <thead>
                                    <tr>
                                      <th width="3%" bgcolor="#95A5A6"> <input name="chkTodosRegiao" type="checkbox" value="" onclick="return marcaTodosRegiao()"> </th>
                                      <th width="5%" bgcolor="#95A5A6">Código</th>
                                      <th width="92%" bgcolor="#95A5A6">Região</th>
                                  </tr>
                                </thead>
                                 <tbody>
                                <%
                           		cont =0
                                while not rs.eof
                                    cont = cont + 1	
									marcaRegiao = ""
									if trim(intCodRegiao1) = trim(rs("cod_regiao")) then
										marcaRegiao = " checked "
									elseif trim(intCodRegiao2) = trim(rs("cod_regiao")) then
										marcaRegiao = " checked "
									elseif trim(intCodRegiao3) = trim(rs("cod_regiao")) then
										marcaRegiao = " checked "
									end if
                                    %>
                                    <tr>
                                        <td><input <%=strDesabilitar%> name="chkReg"  type="checkbox" value="<%=rs("cod_regiao")%>" <%=marcaRegiao%> ></td>
                                        <td><%=trim(rs("cod_regiao"))%></td>
                                        <td><%=trim(rs("descricao"))%></td>
                                      <%				
                                    rs.movenext
                                    wend
                                end if
                                rs.close
                                %>
                                <tr>
                                    <td colspan="3">Total Registros : <%=cont%></td>
                                </tr>
                            </tbody>
                        </table>
                  </div>
            </div>
                    <%
                END IF
            %> 
			</div>
         	<!-- Fecha o Form -->  
      </div>

        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
    </form>    
     
    <script>
	 
	function salvar(acao){
			
			var intContMarcado=0;
			var frm = document.getElementById("frm");
			if (frm.cmbMotivo.value == "U") {
				alert("Informe o motivo da remoção!");
				frm.cmbMotivo.focus();
				return false;
			} 
			if (frm.cmbTipo.value == "R") {
				for (var i = 0; i < frm.elements.length; i++) {
					
					if (frm.elements[i].type == "checkbox" && frm.elements[i].name=="chkReg" && frm.elements[i].checked == true){				
						intContMarcado = intContMarcado + 1;		
					}
			    }
				
				if (intContMarcado == 0) {
					alert("Deve ser selecionada no mínimo uma região!");
					return false;
				} 
				
				if (intContMarcado > 3) {
					alert("Deve ser selecionada no máximo três!");
					return false;
				} 
			} 
			if (frm.cmbTipo.value == "U") {
				for (var i = 0; i < frm.elements.length; i++) {
					
					if (frm.elements[i].type == "checkbox" && frm.elements[i].name=="chkEmp" && frm.elements[i].checked == true){				
						intContMarcado = intContMarcado + 1;		
					}
			    }
				
				if (intContMarcado == 0) {
					alert("Deve ser selecionada no mínimo uma unidade!");
					return false;
				} 
				
				if (intContMarcado > 3) {
					alert("Deve ser selecionada no máximo três!");
					return false;
				} 
			} 
			
			frm.action="PedidoRemocao_cod.asp?acao=" + acao;
			frm.submit();
			return true;	 
	}
	function pedidoRemocaoSolicitados(){
		window.location="PedidoRemocao_con.asp"; 
	}
	function marcaTodos(){
		
		var frm = document.getElementById("frm");
		
		if(frm.chkTodos.checked == true){ 
		  for (var i = 0; i < frm.elements.length; i++) {
					//verifica todos os checkbox
					if (frm.elements[i].type == "checkbox" && frm.elements[i].name == "chkEmp"){				
						frm.elements[i].checked = true;				
					}
		  }
		}else{
		  for (var i = 0; i < frm.elements.length; i++) {
					//verifica todos os checkbox
					if (frm.elements[i].type == "checkbox"){				
						frm.elements[i].checked = false;				
					}
		  }
		}
		return true;
	}
	
	function marcaTodosRegiao(){	
		var frm = document.getElementById("frm");
		
		if(frm.chkTodosRegiao.checked == true){ 
		  for (var i = 0; i < frm.elements.length; i++) {
				//verifica todos os checkbox
				if (frm.elements[i].type == "checkbox" && frm.elements[i].name == "chkReg"){				
					frm.elements[i].checked = true;				
				}
		  }
		}else{
		  for (var i = 0; i < frm.elements.length; i++) {
				//verifica todos os checkbox
				if (frm.elements[i].type == "checkbox"){				
					frm.elements[i].checked = false;				
				}
		  }
		}
		return true;
	}
	
	function abreConsultaColaborador(caminho){
            window.open(caminho,"abreColoboradortroca","top=5,left=5,height=510,width=1000,menubar=no,toolbar=no,scrollbars=yes,status=yes");
        }
    </script>
    <!--/container-->		
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->

</body>
</html> 