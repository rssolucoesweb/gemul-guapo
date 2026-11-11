	<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
    <!--#include file="../../includes/inc_formataData.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <script src="../ckeditor/ckeditor.js"></script>
	<script src="../ckeditor/config.js"></script>
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Controle de Chamados</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
	
	strPaginaTitulo					= "Chamado_cad.asp"
	intCodigo	 					= Trim(Request.Form("txtCodigo"))
	intCodEmpresa					= session("codEmpresa")
	strDataAbertura 				= Trim(Request.Form("txtDataAbertura"))
	intCodEmpresaChamado			= session("codEmpresa")
	strResponsavelAbertura			= Trim(session("UsuarioWeb"))
	intCodUsuarioChamado			= Trim(session("cmbUsuarioChamado"))
	srtSituacao						= Trim(session("cmbSituacao"))
	strPrioridade					= Trim(session("cmbPrioridade"))
	strOcorrencia					= Trim(Request.Form("txtOcorrencia"))
	intTipoServico					= Trim(Request.Form("chkTipoServico"))
	strGrupo						= Trim(Request.Form("cmbGrupo"))
	intSeq							= Trim(Request.Form("cmbSequencia"))

	' Consulta o Tipo de Usuario	
	if trim(strResponsavelAbertura) <> "" then
	
		sql = "SELECT ISNULL(USUARIO_MASTER,'N') AS USUARIO_MASTER, ISNULL(GESTOR_MANUTENCAO,'N') AS GESTOR_MANUTENCAO, ISNULL(GESTOR_SUPORTE,'N') AS GESTOR_SUPORTE "
		sql = sql & " FROM SEG_USUARIOS_SISTEMA"
		sql = sql & " Where USUA_CODG = '" & strResponsavelAbertura & "'"
		rs.open sql, cnn
		if rs.eof = false then
			UsuarioMaster				= Trim(rs("USUARIO_MASTER"))
			GestorManutencao			= Trim(rs("GESTOR_MANUTENCAO"))
			GestorSuporte				= Trim(rs("GESTOR_SUPORTE"))
		end if 
		rs.close
	end if 
	
	if  trim(UsuarioMaster) = "" then UsuarioMaster = "N"
	if  trim(GestorManutencao) = "" then GestorManutencao = "N"
	if  trim(GestorSuporte) = "" then GestorSuporte = "N"
		
	if trim(intCodigo) <> "" then
	
		sql = "SELECT Codigo, Cod_empresa, DataAbertura, Ocorrencias, pedido_por, sequencia_desenvolvimento, "
		sql = sql & " Cod_Usuario_Abertura, Cod_Usuario_Destino, Observacao ," 
		sql = sql & " Situacao, DataFechamento, Prioridade"
		sql = sql & " FROM SCH_CHAMADO"
		sql = sql & " Where Codigo = " & intCodigo

		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 				= rs("Codigo")
			intCodEmpresa 				= rs("Cod_empresa")
			strDataAbertura 			= formatadataAP(rs("DataAbertura"))
			intCodEmpresaGrupoUsuario	= rs("Cod_Usuario_Abertura")
			intCodUsuarioChamado		= rs("Cod_Usuario_Destino")
			srtSituacao					= rs("Situacao")
			strPrioridade				= rs("Prioridade")
			strOcorrencias				= rs("Ocorrencias")
			strGrupo					= rs("pedido_por")
			intSeq						= rs("sequencia_desenvolvimento")

			'if ucase(trim(intCodEmpresaGrupoUsuario)) = ucase(Trim(session("UsuarioWeb"))) then
			
				strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
				strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
				strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			
			'else
			
				'strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
				'strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
				'strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir

			'end if
		end if 
		rs.close
		
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 
	
	if strDataAbertura = "" then strDataAbertura = formatadataap(date)
	
	%>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Abertura de Chamados - ( Suporte )</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="txtCodigo" type="hidden" class="text" id="txtCodigo" value="<%=intCodigo%>" size="10">
                    <div class="form-group">
                        <label class="form-label">Data de Abertura</label>
                         <input readonly name="txtDataAbertura" type="text" class="form-control" id="txtDataAbertura" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataAbertura%>">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Respon&aacute;vel Abertura</label>
                         <input readonly name="txtResponsavelAbertura" type="text" class="form-control" id="txtResponsavelAbertura" size="40" maxlength="40" value="<%=strResponsavelAbertura%>">
                    </div>
                   
                    <div class="form-group">
                        <label class="form-label"> Encaminhamento Para</label>
                         <!--#include file="../includes/inc_cmbUsuariosChamado.asp" -->
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Situa&ccedil;&atilde;o</label>
                            <select name="cmbSituacao" class="form-control" id="cmbSituacao" style="width:150pt">
                            <!--<option value="0">Selecione...</option>-->
                            <option value="A" <%if srtSituacao = "A" then response.Write("selected") %>>Ativo</option>
                            <!--<option value="F" <%if srtSituacao = "F" then response.Write("selected") %>>Fechado</option>
                            <option value="P" <%if srtSituacao = "P" then response.Write("selected") %>>Pendente</option>
                            <option value="S" <%if srtSituacao = "S" then response.Write("selected") %>>Suspen&ccedil;o</option>
                            <option value="E" <%if srtSituacao = "E" then response.Write("selected") %>>Executada</option>-->
                            </select>    
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label"> Prioridade</label>
                         <select name="cmbPrioridade" class="form-control" id="cmbPrioridade" style="width:150pt">
                          <option value="0">Selecione...</option>
                          <option value="1" <%if strPrioridade = "1" then response.Write("selected") %>>1 - Alta</option>
                          <option value="2" <%if strPrioridade = "2" then response.Write("selected") %>>2 - Media</option>
                          <option value="3" <%if strPrioridade = "3" then response.Write("selected") %>>3 - Baixa</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label"> Seq. de Desenvolvimento (menor seqquencia, maior prioridade)</label>
                         <select name="cmbSequencia" class="form-control" id="cmbSequencia" style="width:350pt">
                          <option value="0">Selecione...</option>
                          <option value="1" <%if intSeq = "1" then response.Write("selected") %>>1 (EMERGENCIAL-ERRO SISTEMA)</option>
                          <option value="2" <%if intSeq = "2" then response.Write("selected") %>>2 (PRIORIDADE MAIOR PARA DESENVOLVIMENTO)</option>
                          <option value="3" <%if intSeq = "3" then response.Write("selected") %>>3 (PARA ANALISE E POSTERIOR DESENVOLVIMENTO)</option>
                          <option value="4" <%if intSeq = "4" then response.Write("selected") %>>4</option>
                          <option value="5" <%if intSeq = "5" then response.Write("selected") %>>5</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label"> Pedido pelo Município</label>
                         <select name="cmbGrupo" class="form-control" id="cmbGrupo" style="width:350pt">
                          <option value="0">Selecione...</option>
                          <option value="ABADIA" 			<%if strGrupo = "ABADIA" then response.Write("selected") %>>ABADIA</option>
                          <option value="APARECIDA" 		<%if strGrupo = "APARECIDA" then response.Write("selected") %>>APARECIDA</option>
                          <option value="CANEDO" 			<%if strGrupo = "CANEDO" then response.Write("selected") %>>CANEDO</option>
                          <option value="APARECIDA|CANEDO" 	<%if strGrupo = "APARECIDA|CANEDO" then response.Write("selected") %>>APARECIDA|CANEDO</option>
                          <option value="APARECIDA|ABADIA" 	<%if strGrupo = "APARECIDA|ABADIA" then response.Write("selected") %>>APARECIDA|ABADIA</option>
                          <option value="CANEDO|ABADIA" 	<%if strGrupo = "CANEDO|ABADIA" then response.Write("selected") %>>CANEDO|ABADIA</option>
                          <option value="TODOS" 			<%if strGrupo = "TODOS" then response.Write("selected") %>>TODOS</option>
                        </select>
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label"> Selecione o Tipo de Servi&ccedil;o:</label><br>
                         <%
							SQL = "SELECT Codigo, cod_grupo,  Nome"
							SQL = SQL & " FROM SCH_TIPOSERVICO"
							sql = sql & " Where cod_grupo = " & session("CodGrupo")
							SQL = SQL & " Order by Codigo"
							rs.open sql, cnn
							if not rs.eof then  
								cont = 0
								while not rs.eof
								selecionaCaracteristica = ""
								%>
                                <input <%=selecionaCaracteristica%> name="chkTipoServico" type="checkbox" value="<%=rs("Codigo")%>"><%=rs("Nome")%>
                    			<%
								rs.movenext
							wend
						end if
						rs.close				  
						%>       
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">OCORR&Ecirc;NCIA - ( At&eacute; 2000 Caracteres )</label>
                         <Textarea class="ckeditor" rows="6" cols="120" id="txtOcorrencia" name="txtOcorrencia"><%=strOcorrencias%></textarea>
                    </div>
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
      
             <!--Table Bordered-->
                <div class="panel panel-grey margin-bottom-40">
                    <div class="panel-heading">
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Chamados Ativos</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="3%" rowspan="2" bgcolor="#95A5A6">#</th>
                                    <th colspan="2" align="center" bgcolor="#95A5A6">Abertura</th>
                                    <th width="66%" rowspan="2" bgcolor="#95A5A6">Ocorrência</th>
                                    <th width="5%" rowspan="2" align="center" bgcolor="#95A5A6">Pedido</th>
                                    <th width="5%" rowspan="2" align="center" bgcolor="#95A5A6">Sequencia</th>
                                    <th width="5%" rowspan="2" align="center" bgcolor="#95A5A6"><div align="center">Ação</div></th>
                                </tr>
                                <tr>
                                  <th width="10%" bgcolor="#95A5A6">Data</th>
                                  <th width="16%" bgcolor="#95A5A6">Usuário</th>
                                </tr>
                            </thead>
                            <%
							sql = "SELECT Codigo, dataAbertura, Cod_Usuario_Abertura, Ocorrencias, pedido_por, sequencia_desenvolvimento"
							sql = sql & " FROM SCH_CHAMADO"
							sql = sql & " where situacao in ('A','P') and cod_empresa in (select codigo from seg_empresa where COD_GRUPO = " & Session("CodGrupo") & ")"
							sql = sql & " Order by sequencia_desenvolvimento, prioridade, codigo"
							rs.open sql, cnn
							cont=0
							if rs.eof = false then
							
								while not rs.eof
								cont = cont + 1	
								%>
								<tbody>
									<tr>
										<td><%=trim(rs("Codigo"))%></td>
										<td><%=trim(rs("dataAbertura"))%></td>
										<td><%=trim(rs("Cod_Usuario_Abertura"))%></td>
										<td><%=trim(rs("Ocorrencias"))%></td>
										<td align="center" ><%=trim(rs("pedido_por"))%></td>
										<td align="center" ><%=trim(rs("sequencia_desenvolvimento"))%></td>
										<td align="center" >
										<button class="btn-u btn-u-sea" onClick="resultadoConsulta(<%=trim(rs("Codigo"))%>)" type="button"><i class="fa fa-file-text-o"></i></button> 
										</td> 
									</tr>
								</tbody>
								<%				
								rs.movenext
								wend
							end if
							rs.close
						%>
                        </table>
                    </div>                      
                </div>
                <!--End Table Bordered-->
     <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
    <script>
	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtDataAbertura.value == "") {
			alert("A Data de Abertura deve ser informada !");
			frm.txtDataAbertura.focus();
			return false;
		}
	
		if (frm.txtResponsavelAbertura.value == "") {
			alert("O Responsavel pela Abertura deve ser informado !");
			frm.txtResponsavelAbertura.focus();
			return false;
		}
		
		if (frm.cmbUsuarioChamado.value == "0") {
			alert("O Encaminhamento Para deve ser informado !");
			frm.cmbUsuarioChamado.focus();
			return false;
		}
		
		if (frm.cmbSituacao.value == "0") {
			alert("A Situacao deve ser informada !");
			frm.cmbSituacao.focus();
			return false;
		}
		
		if (frm.cmbPrioridade.value == "0") {
			alert("A Prioridade deve ser informada !");
			frm.cmbPrioridade.focus();
			return false;
		}
		
		frm.action="Chamado_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 