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
        strLiberaAlteracao		= "S"
        usuarioInclusao			= session("strUsuario")
        strObs					= request("txtObs")
        if isnull(usuarioInclusao) then usuarioInclusao = ""
        
        strEmpresaSecaoProduto_submit = "S"
        principal			= "principal.asp"
        intCodEmpresa		= session("CodEmpresa")	
        intCodigo 			= Trim(Request("txtCodigo"))
        intCodRequisicao	= Trim(Request("txtCodRequisicao"))
        intCodDepartamento	= Trim(Request("cmbDepartamento"))
        
        strMostraBotaoEnviarParaAutorizacao = "S"
        strDesabilitaBotaoEnviarParaAutorizacao = "Disabled"
        intCodSituacao = "1"
        intSecaoProduto			= Trim(Request.Form("cmbSecaoProduto"))
        if intSecaoProduto = "" then intSecaoProduto = "0"
        
        if trim(intCodRequisicao) <> "" then
            sql = "select _r.*, _s.descricao as situacao"
            sql = sql & " from est_requisicao _r"
            sql = sql & " inner join est_situacao _s on _s.codigo = _r.codsituacao"
            sql = sql & " where _r.codigo = " & intCodRequisicao
            sql = sql & " And _r.CodEmpresa = " & intCodEmpresa
            if session("strNomeUsuario")<>"76143139172" then 'responsavel pela liberaçao do material
                sql = sql & " and 	_r.solicitante = '" & session("strNomeUsuario") & "'"
            end if
            rs.open sql, cnn
            
            if rs.eof = false then
                strObs				= rs("obs")
                strSolicitante		= rs("solicitante")
                intCodDepartamento	= rs("codDepartamento")
                strSituacao			= rs("situacao")
                strDataSolicitacao	= formatadataAP(rs("dataentrada"))
                intCodSituacao		= rs("codsituacao")
                            
                strDesabilitaIncluir = "" 'Desabilita o botão Incluir
                strDesabilitaAlterar = "disabled" 'Desabilita o botão Excluir
                strDesabilitaExcluir = "" 'Desabilita o botão Excluir
                strDesabilitaBotaoEnviarParaAutorizacao = ""
                rs.close
            else
                rs.close
                %>
                <script>
                    alert("ATENÇÃO: Solicitação de material não foi encontrada.");
                    window.location='Distribuicao_cad.asp';
                </script>
                <%
                response.End()
            end if 
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
        
        
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Distribuição de Material</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" method="post">
                	
                <input name="txtCodigo" type="hidden" class="text" id="txtCodigo" size="10" maxlength="20" value="<%=intCodigo%>">	
                <div class="form-group">
                    <label class="form-label">Código</label>
                    <input class="form-control" name="txtCodRequisicao" size="10" maxlength="20" type="text" id="txtCodRequisicao" value="<%=intCodRequisicao%>" onBlur="consultar(this.value)">
                    <button class="btn-u btn-u-sea" onClick="return abreConsulta('Distribuicao_con.asp')" type="button"><i class="fa fa-search"></i></button> 
                </div>
                
                <div class="form-group">
                    <label class="form-label">Situa&ccedil;&atilde;o</label>
                    <%=strSituacao%>
                 </div>
                 
                 <div class="form-group">
                    <label class="form-label">Solicitante</label>
                    <%=session("strUsuarioRodape")%>
                 </div>
                 
                 <div class="form-group">
                    <label class="form-label">Data</label>
                    <%=strDataSolicitacao%>
                 </div>
                 
                 <div class="form-group">
                    <label class="form-label">Data</label>
                    <%=strDataSolicitacao%>
                 </div>
                
                <div class="form-group">
                    <label class="form-label">Departamento/Unidade</label>
                    <!--#include file="../includes/inc_cmbDepartamentoEstoqueDistribuicao.asp" -->
                </div>
                
                <div class="form-group">
                    <label class="form-label">Observa&ccedil;&atilde;</label>
                    <textarea name="txtObs" id="txtObs" cols="75" rows="3" class="form-control"><%=strObs%></textarea>
                 </div>
                 
                 <div class="form-group">
                    <label class="form-label">Se&ccedil;&atilde;o</label>
                    <!--#include file="../includes/inc_cmbSecaoProdutoDistribuicao.asp" -->
                 </div>
                 
                 <div class="form-group">
                    <label class="form-label">Material</label>
                    <!--#include file="../includes/inc_cmbProdutoSolicitacao.asp"-->
                    <input name="txtDescricaoMaterial" type="text" class="form-control" id="txtDescricaoMaterial" size="30" maxlength="100" value="<%=strDescricaoMaterial%>" >
					<input type="button" name="cmdFiltrar"  value="Filtrar Material"  class="btn btn-u float-shadow"  onClick="carregaMaterial()">
                 </div>
                 
                  <div class="form-group">
                    <label class="form-label">Quantidade</label>
                    <input name="txtQuantidade" type="text" class="form-control" id="txtQuantidade" size="10" maxlength="20" value="<%=intQuantidade%>"  onKeyPress="return formataCampo(this,2,10)">
                 </div>

                <legend></legend>
                <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                </form>
       	  </div>
   	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
       <%
		cont =0
		if intCodRequisicao <>"" then%>
        
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Distribuição de Material</h3>
          </div>
            <div class="panel-body">
            	<div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="40%" bgcolor="#95A5A6">Material</th>
                          <th width="44%" bgcolor="#95A5A6">Unidade</th>
                          <th width="11%" bgcolor="#95A5A6">Quantidade</th>
                          <th width="5%" bgcolor="#95A5A6" align="center"><div align="center">Excluir</div></th>
                      </tr>
                    </thead>
                  <%
                    cont =0
					
					sql = "SELECT _R.Codigo, _R.CODPRODUTO, _P.DESCRICAO,  _U.DESCRICAO AS UNIDADE, _R.quantidade"
					sql = sql & " FROM EST_RequisicaoProduto _R"
					sql = sql & " INNER JOIN EST_PRODUTO _P ON _P.CODIGO = _R.CODPRODUTO"
					sql = sql & " INNER JOIN EST_UNIDADE_PRODUTO _U ON _U.CODIGO = _P.COD_UNIDADE"
					sql = sql & " where _r.codRequisicao = " & intCodRequisicao
					sql = sql & " Order by _P.DESCRICAO"
				    rs.open sql, cnn
                    if rs.eof = false then
                    
                    while not rs.eof
						cont = cont + 1	
			        %>
                    <tbody>
                        <tr>
                            <td><%=trim(rs("DESCRICAO"))%></td>
                            <td><%=trim(rs("unidade"))%></td>
                            <td><%=trim(rs("quantidade"))%></td>
                          	<td align="center" >
                          	<%if strDesabilitaBotaoEnviarParaAutorizacao="" then%>
                            	<button class="btn-u btn-u-sea" onClick="excluirMaterial(<%=trim(rs("Codigo"))%>)" type="button"><i class="fa fa-file-text-o"></i></button> 
                            <%end if%>
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
        <%end if%>
        <!--End Table Bordered-->	
        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
	<script>
	
        function carregaMaterial(){	
            var parametros = 'descricao=' + document.getElementById('txtDescricaoMaterial').value + '&tipoAcao=carregaMaterial';
            parametros = parametros + '&CodSecaoProduto=' + document.getElementById('cmbSecaoProduto').value;
            parametros = parametros + '&tipo_usuario=' + document.getElementById('tipo_usuario').value;
            
            //limpa a combo
            document.getElementById('cmbProduto').innerHTML = '';
            var option = document.createElement('option')
            option.value = ""
            option.text = "Selecione"
            document.getElementById('cmbProduto').options[0] = option;			
            
            //Consulta
            var func = function(xmlHttp2)
            {
                var xml = xmlHttp2.responseXML;
                var elementos = xml.getElementsByTagName('elemento_superior')[0];	
                if (getText(elementos.getElementsByTagName('codigo')[0].childNodes[0]) !=""){
                    preencheCombo(xmlHttp2.responseXML, document.getElementById('cmbProduto'));
                }
            }
            //window.open('js/ajax.asp?' + parametros)
            ExecAjax(func,'js/ajax.asp?' + parametros,'','');
        }  
        
        function resultadoConsulta(intCodigo){
                frm.txtCodigo.value=intCodigo
                frm.submit();
            }
        function consultar(intCodigo){
                frm.txtCodRequisicao.value=intCodigo
                frm.submit();
            }
        function salvar(acao){
            
            var frm = document.getElementById("frm");
            
            if (acao=="E") {
                var men = 'ATENÇÃO: Deseja realmente excluir TODOS os materiais dessa solicitação, inclusive a solicitação?\n';
                if (confirm(men)) {
                    var frm = document.getElementById("frm");
                    frm.action="Distribuicao_cod.asp?acao=EXCLUIR&txtCodRequisicao="+frm.txtCodRequisicao.value;
                    frm.submit();
                    return true;
                }else{
                    return false;
                }		
    
            }else{
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
            }
            frm.action="Distribuicao_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
        function excluirMaterial(codigo){
            var men = 'ATENÇÃO: Deseja realmente excluir esse material da solicitação?\n';
            if (confirm(men)) {
                var frm = document.getElementById("frm");
                frm.action="Distribuicao_cod.asp?acao=EM&codigo=" + codigo + "&txtCodRequisicao="+frm.txtCodRequisicao.value;
                frm.submit();
                return true;
            }else{
                return false;
            }		
            
        }
    
        function enviar(){
            var men = 'ATENÇÃO: Deseja realmente enviar essa solicitação para autorização, após enviado não poderá mais efetuar alteração nesta requisição?\n';
            if (confirm(men)) {
                var frm = document.getElementById("frm");
                frm.action="Distribuicao_cod.asp?acao=F";
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