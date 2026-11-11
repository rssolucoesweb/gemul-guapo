
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
	strBotaoPedidoDeRemocaoAutorizacao = "S"
	
	strTipo 	= Trim(Request("cmbTipo"))
	if strTipo = "" then strTipo = "R"
	strAnoletivo = Trim(Request("txtAnoLetivo"))
	if strAnoletivo = "" then strAnoletivo = year(date)
	strFuncaoEscolhida = Trim(Request.form("txtFuncaoEscolhida"))
	intCodTurno = Trim(Request.form("cmbTurnoRH"))
	
	strDesabilitaIncluir = "" ' Desabilita o botão Incluir
		
	intCodFuncionarioAtual = request.form("txtCodFuncionario")
	intCodFuncionalAtual = request.form("txtCodigoFuncionalAtual")
	intCodigo = request("txtCodigo")
	if intCodigo <>"" then
		strNomeColaboradorAtual = "Não encontrado!"
		sql = "SELECT e.codigo as codEmpresa, pr.ano_letivo, e.razaosocial as empresa, pr.cod_regiao1, pr.cod_regiao2, pr.cod_regiao3, pr.cod_empresa_1opcao, pr.cod_empresa_2opcao, pr.cod_empresa_3opcao, pr.observacao, m.descricao as motivo, pr.cod_turno_escolhido, c.nome, c.codigo, f.situacao_disciplinar, f.cod_funcao, f.desc_funcao, c.codFuncional, t.cod_turno, t.Desc_Turno as turno, ca.cod_cargo, ca.Desc_Cargo as cargo, pr.cod_empresa_escolhida "
		sql = sql & " FROM SRH_COLABORADOR c "
		sql = sql & " inner join SRH_PEDIDO_REMOCAO pr on pr.cod_colaborador = c.codigo"
		sql = sql & " left join seg_empresa e on e.codigo = c.codLotacao and e.cod_grupo=" & session("CodGrupo")
		sql = sql & " left join srh_funcaocolaborador f on f.Cod_Funcao = c.codfuncao "
		sql = sql & " left join srh_cargocolaborador ca on ca.Cod_Cargo = c.CodCargo "
		sql = sql & " left join srh_turno t on t.Cod_Turno = c.codturno"
		sql = sql & " left join srh_motivo_remocao m on m.codigo = pr.cod_motivo_remocao"
		sql = sql & " Where pr.codigo = " & intCodigo
		sql = sql & " and pr.situacao = 'A'"
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
			
			if not isnull(intCodRegiao1) then strTipo = "R"
			if not isnull(intCodEmpresa1) then strTipo = "U"
			
			strCodEmpresaAtual						= rs("codEmpresa")
			strEmpresaAtual							= rs("empresa")
			strCodFuncaoAtual						= rs("cod_funcao")
			strFuncaoAtual							= rs("desc_funcao")
			strCodCargoAtual						= rs("cod_cargo")
			strCargoAtual							= rs("cargo")
			strCodTurnoAtual						= rs("cod_turno")
			strTurnoAtual							= rs("turno")
			intCodturno								= rs("cod_turno_escolhido")
			intCodEmpresaEscolhida					= rs("cod_empresa_escolhida")
			
			observacao								= rs("observacao")
			strMotivo								= rs("motivo")
			
			strDesabilitaIncluir = "OK" ' Desabilita o botão Incluir
			
			
		end if 
		rs.close
	end if
    %>
  <form id="frm" name="frm" action="pedidoRemocaoAutorizacao_cad.asp" class="sky-form panel-body0" method="post">
	<!--=== Content Part ===-->
    <div class="container content">
        <div class="row">
            <!-- Begin Content -->
            <div class="col-md-12" >     
       		<!-- Inicia o Painel do Formulario --> </font>    
                	<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
                    <div style="background:#95a5a6;height:40px;padding-top: 8px;" class="panel-title">&nbsp;&nbsp;<font color="#FFFFFF"><i class="fa fa-tasks"></i>&nbsp;Pedido de Remoção - ENVIAR PARA AUTORIZAÇÃO</font></div>
					<input name="txtCodigoFuncionalAtual" type="hidden" class="text" id="txtCodigoFuncionalAtual" size="12" maxlength="8" value="<%=intCodFuncionalAtual%>">
                    <fieldset>
                        
                        <div class="row">
                             <section class="col col-12">
                                <label class="form-label">Colaborador</label>
                              
                                <label class="input">
                                     <input disabled style="background:#CCC" name="txtNome" type="text" class="text" id="txtNome" size="100" maxlength="8" value="<%=intCodFuncionalAtual%> - <%=strNomeColaboradorAtual%>" >
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
                                    <label class="form-label">Motivo</label>
                                    <label class="input">
                                    	<input disabled style="background:#CCC" name="txtFuncaoEscolhida" type="text" class="text" id="txtFuncaoEscolhida" size="100" maxlength="200" value="<%=strMotivo%>" >
                                    </label>
                                </section>
                        	</div>
							<div class="row">
                                <section class="col col-12">
                                    <label class="form-label">Observação</label>
                                    <label class="input">
                                    	<input disabled style="background:#CCC" name="txtFuncaoEscolhida" type="text" class="text" id="txtFuncaoEscolhida" size="100" maxlength="200" value="<%=observacao%>" >
                                    </label>
                                </section>
                        	</div>
                  			<div class="row">
                                <section class="col col-12">
                                    <label class="form-label">Turno escolhido</label>
                                    <!--#include file="../includes/inc_cmbTurno.asp" -->
                                </section>
                        	</div>
				
				<%if strDesabilitaIncluir = "OK" then%>
                       	<div class="row">
                             <section class="col col-12">
                                <label class="form-label">Unidade Escolhida</label>
								<%
										sql = "select '(' + r.descricao + ')' as regiao, e.CODIGO as cod_empresa, e.RAZAOSOCIAL as empresa"
										sql = sql & " from SRH_PEDIDO_REMOCAO re"
										sql = sql & " inner join MAT_regiao r on r.codigo = re.cod_regiao1"
										sql = sql & " inner join MAT_regiao_empresa ree on ree.cod_regiao = r.codigo"
										sql = sql & " inner join SEG_EMPRESA e on e.CODIGO = ree.cod_empresa"
										sql = sql & " where re.codigo = " & intCodigo
										sql = sql & " union" 
										sql = sql & " select '(' + r.descricao + ')' as regiao, e.CODIGO as cod_empresa, e.RAZAOSOCIAL as empresa"
										sql = sql & " from SRH_PEDIDO_REMOCAO re"
										sql = sql & " inner join MAT_regiao r on r.codigo = re.cod_regiao2"
										sql = sql & " inner join MAT_regiao_empresa ree on ree.cod_regiao = r.codigo"
										sql = sql & " inner join SEG_EMPRESA e on e.CODIGO = ree.cod_empresa"
										sql = sql & " where re.codigo = " & intCodigo
										sql = sql & " union"
										sql = sql & " select '(' + r.descricao + ')' as regiao, e.CODIGO as cod_empresa, e.RAZAOSOCIAL as empresa"
										sql = sql & " from SRH_PEDIDO_REMOCAO re"
										sql = sql & " inner join MAT_regiao r on r.codigo = re.cod_regiao3"
										sql = sql & " inner join MAT_regiao_empresa ree on ree.cod_regiao = r.codigo"
										sql = sql & " inner join SEG_EMPRESA e on e.CODIGO = ree.cod_empresa"
										sql = sql & " where re.codigo = " & intCodigo
										sql = sql & " union"
										sql = sql & " select '' as regiao, e.CODIGO as cod_empresa, e.RAZAOSOCIAL as empresa"
										sql = sql & " from SRH_PEDIDO_REMOCAO re"
										sql = sql & " inner join seg_empresa e on e.codigo = re.cod_empresa_1opcao"
										sql = sql & " where re.codigo = " & intCodigo
										sql = sql & " union"
										sql = sql & " select '' as regiao, e.CODIGO as cod_empresa, e.RAZAOSOCIAL as empresa"
										sql = sql & " from SRH_PEDIDO_REMOCAO re"
										sql = sql & " inner join seg_empresa e on e.codigo = re.cod_empresa_2opcao"
										sql = sql & " where re.codigo = " & intCodigo
										sql = sql & " union"
										sql = sql & " select '' as regiao, e.CODIGO as cod_empresa, e.RAZAOSOCIAL as empresa"
										sql = sql & " from SRH_PEDIDO_REMOCAO re"
										sql = sql & " inner join seg_empresa e on e.codigo = re.cod_empresa_3opcao"
										sql = sql & " where re.codigo = " & intCodigo
										sql = sql & " order by 1,3"
								%>
                                <label class="input">
                                     <select name="cmbUnidadeEscolhida" id="cmbUnidadeEscolhida" class="form-control">
										<option value="0">Selecione...</option>
										<%
										
										RS.OPEN SQL, CNN
										IF NOT RS.EOF THEN
											WHILE NOT RS.EOF
												%>
												<option <%if intCodEmpresaEscolhida = rs("cod_empresa") then response.write "selected"%> value="<%=rs("cod_empresa")%>"><%=rs("empresa")%> <%=rs("regiao")%></option>
												<%
												RS.MOVENEXT
											WEND
										END IF
										RS.CLOSE
										%>
                                    </select>
                                </label>
                             </section>
                        </div>
                     </fieldset>
                 
								 
					<input type="button" name="cmdAlterar" style="cursor:hand"  value="Enviar para Autorização"  class="btn-u btn-u-blue float-shadow" onclick="salvar()">
				<%end if%>				 
                <input type="button" name="cmdAlterar" style="cursor:hand"  value="Voltar para lista de pedidos"  class="btn-u float-shadow" onclick="window.location='PedidoRemocao_con.asp'">
				<br>
				<br>
			</div>
         	<!-- Fecha o Form -->  
      </div>

        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
    </form>    
     
    <script>
	 
	function salvar(){
			
			var intContMarcado=0;
			var frm = document.getElementById("frm");
	
			if (frm.cmbTurnoRH.value == "0") {
				alert("O turno deve ser selecionado!");
				frm.cmbTurnoRH.focus();
				return false;
			} 
			if (frm.cmbUnidadeEscolhida.value == "0") {
				alert("A unidade deve ser selecionada!");
				frm.cmbUnidadeEscolhida.focus();
				return false;
			} 
			frm.action="PedidoRemocaoAutorizacao_cod.asp?acao=G";
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