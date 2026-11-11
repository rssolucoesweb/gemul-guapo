<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">EST - Controle Almoxarifado</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%  
        intCodEmpresa		= session("CodEmpresa")	
        
        sql = "SELECT CODIGO"
        sql = sql & " FROM EST_BALANCO"
        sql = sql & " Where situacao = 'A'"
        sql = sql & " And Cod_Empresa = " & intCodEmpresa
        rs.open sql, cnn
        if rs.eof then
            %>
            <script>
                alert("O balanço não foi aberto!\n\nO balanço do estoque não pode ser iniciado.");
                window.location='AbrirBalanco_cad.asp';
            </script>
            <%
        else
            codBalanco = rs("CODIGO")
        end if 
        rs.close
    
        strEmpresaSecaoProduto_submit = "S"
        StrReloadProduto = "S"
        principal			= "principal.asp"
        intCodigo 			= Trim(Request("txtCodigo"))
        intCodRequisicao	= Trim(Request("txtCodRequisicao"))
        strMotivo			= Trim(Request("txtMotivo"))
        strMostraBotaoAtualizaEstoque = "S"
        strDesabilitaBotaoAtualizaEstoque = "Disabled"
        intCodSituacao = "1"
        desabilitaProduto		= ""
        intSecaoProduto			= Trim(Request.Form("cmbSecaoProduto"))
        intCodProduto			= Trim(Request.Form("cmbProduto"))
        intNumeroProduto			= Trim(Request.Form("txtCodProduto"))
        intCodConferencista			= Trim(Request.Form("cmbConferencista"))
        if intCodConferencista = "" then intCodConferencista = 0
        if intCodProduto = "" then intCodProduto = 0
        
        if intSecaoProduto = "" then intSecaoProduto = "0"
        if trim(intCodigo) <> "" then
        
            sql = "select _p.codigo, _r.motivo, _r.codigo as codAtualizacaoEstoque, _p.codconferencista, _pr.cod_Secao, _r.dataentrada, _r.usuario, _p.saldoExistente as quantidade, _p.codproduto,  _r.codSituacao"
            sql = sql & " from EST_ATUALIZACAO_ESTOQUE _r"
            sql = sql & " inner join EST_ATUALIZACAO_ESTOQUE_produto _p on _p.codAtualizacaoEstoque = _r.codigo"
            sql = sql & " inner join EST_produto _pr on _p.codProduto = _pr.codigo"
            sql = sql & " where _p.codigo = " & intCodigo
            sql = sql & " And _r.CodEmpresa = " & intCodEmpresa
            rs.open sql, cnn
            if rs.eof = false then
                
                intCodigo	 		= rs("codigo")
                intCodRequisicao	= rs("codAtualizacaoEstoque")
                strSolicitante		= rs("usuario")
                intCodProduto		= rs("codproduto")
                intCodConferencista = rs("codconferencista")
                desabilitaProduto   = "disabled"
                intQuantidade		= rs("quantidade")
                strSituacao 		= "Em Aberto"
                intCodSituacao		= rs("codsituacao")
                strMotivo			= rs("motivo")
                intSecaoProduto		= rs("cod_Secao")
                strDataSolicitacao	= formatadataAP(rs("dataentrada"))
                            
                strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir
                strDesabilitaAlterar = "" 'Desabilita o botão Excluir
                strDesabilitaExcluir = "" 'Desabilita o botão Excluir
                strDesabilitaBotaoAtualizaEstoque = ""
                if intCodSituacao = "2" then
                    strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir
                    strDesabilitaAlterar = "disabled" 'Desabilita o botão Excluir
                    strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
                    strDesabilitaBotaoAtualizaEstoque = "disabled"
                    strSituacao = "Atualizado"
                end if
            end if 
            rs.close
        elseif trim(intCodRequisicao) <> "" then
            sql = "select *"
            sql = sql & " from EST_ATUALIZACAO_ESTOQUE _r"
            sql = sql & " where _r.codigo = " & intCodRequisicao
            sql = sql & " And _r.CodEmpresa = " & intCodEmpresa
            rs.open sql, cnn
            
            if rs.eof = false then
                
                strSolicitante		= rs("usuario")
                strSituacao			= "Em Aberto"
                strDataSolicitacao	= formatadataAP(rs("dataentrada"))
                intCodSituacao		= rs("codsituacao")
                strMotivo			= rs("Motivo")			
                strDesabilitaIncluir = "" 'Desabilita o botão Incluir
                strDesabilitaAlterar = "disabled" 'Desabilita o botão Excluir
                strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
                strDesabilitaBotaoAtualizaEstoque = ""
                if intCodSituacao = "2" then
                    strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir
                    strDesabilitaAlterar = "disabled" 'Desabilita o botão Excluir
                    strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
                    strDesabilitaBotaoAtualizaEstoque = "disabled"
                    strSituacao = "Atualizado"
                end if
    
            end if 
            rs.close
        else
            strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
            strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
            strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
        end if 
        
        if intCodSituacao <> "1" then
            strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
            strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
            strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
            strDesabilitaBotaoEnviarParaAutorizacao = "disabled"
        end if
        
        if intCodProduto = "" then intCodProduto = "0"
        bloqDigitacao = ""
        if intCodProduto <> "0" then
            if intCodRequisicao <> "" then
                sql = "select codigo, SaldoExistente, codConferencista"
                sql = sql & " from EST_ATUALIZACAO_ESTOQUE_PRODUTO _r"
                sql = sql & " where codAtualizacaoEstoque = " & intCodRequisicao
                sql = sql & " And codProduto = " & intCodProduto
                rs.open sql, cnn
                if rs.eof = false then
                    strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
                    strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
                    strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
                    intCodigo				= rs("codigo")
                    intQuantidade			= rs("SaldoExistente")
                    intCodConferencista		= rs("codConferencista")
                end if
                rs.close
            end if
            
            sql = "select codigo, QTD_ATUAL_ESTOQUE, isnull(QTD_ATUAL_ESTOQUE_ANTERIOR_BALANCO,0) as QTD_ATUAL_ESTOQUE_ANTERIOR_BALANCO, isnull(BALANCO,'N') as BALANCO "
            sql = sql & " from EST_PRODUTO"
            sql = sql & " where codigo = " & intCodProduto
            sql = sql & " And Cod_Empresa = " & intCodEmpresa
            rs.open sql, cnn
            if rs.eof = false then
                intNumeroProduto		= rs("codigo")
                strEstoqueAtual		= rs("QTD_ATUAL_ESTOQUE")
                strEstoqueAnterior		= rs("QTD_ATUAL_ESTOQUE_ANTERIOR_BALANCO")
                if trim(rs("BALANCO")) = "S" then
                    bloqDigitacao = "disabled"
                end if
            end if
            rs.close
        elseif intNumeroProduto <> "" then
            if intCodRequisicao <> "" then
                sql = "select codigo, SaldoExistente, codConferencista"
                sql = sql & " from EST_ATUALIZACAO_ESTOQUE_PRODUTO _r"
                sql = sql & " where codAtualizacaoEstoque = " & intCodRequisicao
                sql = sql & " And codProduto = " & intNumeroProduto
                rs.open sql, cnn
                if rs.eof = false then
                    strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
                    strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
                    strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
                    intCodigo				= rs("codigo")
                    intQuantidade			= rs("SaldoExistente")
                    intCodConferencista		= rs("codConferencista")
                end if
                rs.close
            end if
    
            sql = "select codigo, cod_Secao, QTD_ATUAL_ESTOQUE, isnull(QTD_ATUAL_ESTOQUE_ANTERIOR_BALANCO,0) as QTD_ATUAL_ESTOQUE_ANTERIOR_BALANCO, isnull(BALANCO,'N') as BALANCO "
            sql = sql & " from EST_PRODUTO"
            sql = sql & " where codigo = " & intNumeroProduto
            sql = sql & " And Cod_Empresa = " & intCodEmpresa
            rs.open sql, cnn
            if rs.eof = false then
                intCodProduto		= rs("codigo")
                intSecaoProduto		= rs("cod_Secao")
                strEstoqueAtual		= rs("QTD_ATUAL_ESTOQUE")
                strEstoqueAnterior		= rs("QTD_ATUAL_ESTOQUE_ANTERIOR_BALANCO")
                if trim(rs("BALANCO")) = "S" then
                    bloqDigitacao = "disabled"
                end if
            end if
            rs.close
        end if	
        strMensagemBalanco = ""
        if bloqDigitacao = "disabled" then
            strMensagemBalanco = "Produto já foi atualizado em balanço anterior, não poderá ser alterado!"
            strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
            strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
            strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
        end if
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Balanço Estoque</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" method="post">
                	
                  <input name="txtCodigo" type="hidden" class="text" id="txtCodigo" size="10" maxlength="20" value="<%=intCodigo%>">
                  <input name="codBalanco" type="hidden" class="text" id="codBalanco" size="10" maxlength="20" value="<%=codBalanco%>">
                    
                   <div class="form-group">
                        <label class="form-label">Código</label>
                        <input class="form-control" name="txtCodRequisicao" size="10" maxlength="20" type="text" id="txtCodRequisicao" value="<%=intCodRequisicao%>" onBlur="consultar(this.value)">
                        <button class="btn-u btn-u-sea" onClick="return abreConsulta()" type="button"><i class="fa fa-search"></i></button>  
                   </div>
                    
                  <div class="form-group">
                        <label class="form-label">Situa&ccedil;&atilde;o</label>
                        <%=strSituacao%>
                  </div>
                  
                  <div class="form-group">
                        <label class="form-label">Usu&aacute;rio</label>
                        <%=session("strUsuarioRodape")%>
                  </div>
                  
                   <div class="form-group">
                        <label class="form-label">Data</label>
                        <strong><%=strDataSolicitacao%></strong>
                  </div>
                  
                   <div class="form-group">
                        <label class="form-label">Motivo</label>
                        <textarea name="txtMotivo" id="txtMotivo" cols="60" rows="6"><%=strMotivo%></textarea>
                  </div>
                  
                  <div class="form-group">
                        <label class="form-label">Se&ccedil;&atilde;o</label>
                        <!--#include file="../includes/inc_cmbSecaoProduto.asp" -->
                  </div>
                  
                  <div class="form-group">
                        <label class="form-label">Produto</label>
                        <input name="txtCodProduto" type="text" class="form-control" id="txtCodProduto" size="10" maxlength="10" value="<%=intNumeroProduto%>" onBlur="consultarPorNumero()"  onKeyPress="return formataCampo(this,2,10)">
						<!--#include file="../includes/inc_cmbProduto.asp"-->
                  </div>
                  
                   <div class="form-group">
                        <label class="form-label">Conferido Por</label>
                        <!--#include file="../includes/inc_cmbConferencista.asp" -->
                  </div>
                  
                   <div class="form-group">
                        <label class="form-label">Estoque Atual</label>
                        <input readonly name="txtEstoqueAtual" type="text" class="form-control" id="txtEstoqueAtual" size="10" maxlength="20" value="<%=strEstoqueAtual%>"  onKeyPress="return formataCampo(this,2,10)">
                  </div>
                  
                  <div class="form-group">
                        <label class="form-label">Estoque Conferido</label>
                        <input name="txtQuantidade" type="text" class="form-control" id="txtQuantidade" size="10" maxlength="20" value="<%=intQuantidade%>"  onKeyPress="return formataCampo(this,2,10)"><strong><font color="#FF0000"><%=strMensagemBalanco%></font></strong>
                  </div>

	              <legend></legend>
                  <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                </form>
       	  </div>
   	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
       <% cont =0
	 	if intCodRequisicao <>"" then %>
        
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Balanço Estoque</h3>
          </div>
            <div class="panel-body">
            	<div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="36%" bgcolor="#95A5A6">Produto</th>
                          <th width="23%" bgcolor="#95A5A6">Unidade</th>
                          <th width="23%" bgcolor="#95A5A6">Estoque Conferido</th>
                          <th width="14%" bgcolor="#95A5A6">Conferido Por</th>
                          <th width="4%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                      </tr>
                    </thead>
                  <%
                    cont =0
					
					sql = "SELECT _R.Codigo, _R.CODPRODUTO, _P.DESCRICAO, _U.DESCRICAO AS UNIDADE, _R.saldoExistente as quantidade, _C.nome"
					sql = sql & " FROM EST_ATUALIZACAO_ESTOQUE_produto _R"
					sql = sql & " INNER JOIN EST_PRODUTO _P ON _P.CODIGO = _R.CODPRODUTO"
					sql = sql & " INNER JOIN EST_UNIDADE_PRODUTO _U ON _U.CODIGO = _P.COD_UNIDADE"
					sql = sql & " left JOIN EST_conferencista _C ON _C.CODIGO = _R.codconferencista"
					sql = sql & " where _r.codAtualizacaoEstoque = " & intCodRequisicao
					sql = sql & " Order by _P.DESCRICAO"
					
				    rs.open sql, cnn
                    if rs.eof = false then
                    
                    while not rs.eof
						cont = cont + 1	
			        %>
                    <tbody>
                        <tr>
                          <td><%=trim(rs("CODPRODUTO"))%> - <%=trim(rs("DESCRICAO"))%></td>
                          <td><%=trim(rs("unidade"))%></td>
                          <td><%=trim(rs("quantidade"))%></td>
                          <td><%=trim(rs("nome"))%></td>
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
        </div>
        <% end if%>
        
        <!--End Table Bordered-->	
        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
	<script>
        function abreConsulta(){
            window.open("AtualizaEstoque_con.asp", "consulta", "top=0,left=0,height=510,width=750,menubar=no,toolbar=no,scrollbars=yes,status=yes");
            return true;
        }
        function resultadoConsulta(intCodigo){
            var frm = document.getElementById("frm");
                frm.txtCodigo.value=intCodigo
                frm.submit();
            }
        function consultar(intCodigo){
            var frm = document.getElementById("frm");
                frm.txtCodRequisicao.value=intCodigo
                frm.submit();
            }
            
        function consultarPorNumero(){
            var frm = document.getElementById("frm");
                frm.cmbProduto.value=0;
                frm.submit();
            }
    
        function salvar(acao){
            
            var frm = document.getElementById("frm");
            if (frm.txtMotivo.value == "") {
                alert("O motivo deve ser informado !");
                frm.txtMotivo.focus();
                return false;
            }
            if (frm.cmbConferencista.value == "0") {
                alert("Quem fez a conferência deve ser informado !");
                frm.cmbConferencista.focus();
                return false;
            }
            if (frm.cmbProduto.value == "0") {
                alert("O produto deve ser informado !");
                frm.cmbProduto.focus();
                return false;
            }
    
            if (frm.txtQuantidade.value == "") {
                alert("A quantidade deve ser informada !");
                frm.txtQuantidade.focus();
                return false;
            }
            
            frm.cmbProduto.disabled = false;
            frm.action="AtualizaEstoque_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
    
        function enviar(){
            var frm = document.getElementById("frm");
            var men = 'ATENÇÃO: Deseja fechar balanço e atualizar o estoque, esse processo não poderá ser revertido, deseja continuar?\n';
            if (confirm(men)) {
                frm.action="AtualizaEstoque_cod.asp?acao=F";
                frm.submit();
                return true;
            }else{
                return false;
            }
        }
    </script>

    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 