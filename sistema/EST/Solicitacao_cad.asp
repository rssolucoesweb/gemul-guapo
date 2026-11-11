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
        
        if usuarioInclusao="" then
            %>
            <script>
                alert("Usuário esta sem lotação, acesso o modulo de segurança e vinculo o usuário a sua lotação.");
                window.history.back();
            </script>
            <%
            response.End()
        else
            sql = "SELECT _d.Descricao as depto, _d.codigo, _d.tipo  "
            sql = sql & " FROM SEG_usuarios _u"
            sql = sql & " inner join EST_DEPARTAMENTO _d on _d.codigo = _u.codDepartamento"
            sql = sql & " Where _u.cpf = '" & usuarioInclusao & "'"
            rsAux.open sql, cnn
            if rsAux.eof then	
                rsAux.close
                %>
                <script>
                    alert("Usuário esta sem lotação, acesso o modulo de segurança e vinculo o usuário a sua lotação.");
                    window.history.back();
                </script>
                <%
                response.End()
            else
                tipo_usuario = rsAux("tipo")
                strDepartamento = rsAux("depto")
                intCodDepartamento = rsAux("codigo")
            end if
            rsAux.close		
        end if	
        strEmpresaSecaoProduto_submit = "S"
        principal			= "principal.asp"
        intCodEmpresa		= session("CodEmpresa")	
        intCodigo 			= Trim(Request("txtCodigo"))
        intCodRequisicao	= Trim(Request("txtCodRequisicao"))
        strMostraBotaoEnviarParaAutorizacao = "S"
        strDesabilitaBotaoEnviarParaAutorizacao = "Disabled"
        intCodSituacao = "1"
        intSecaoProduto			= Trim(Request.Form("cmbSecaoProduto"))
        if intSecaoProduto = "" then intSecaoProduto = Session("CodSecao")
        
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
                    window.location='Solicitacao_cad.asp';
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
        
        'busca liberação para solicitação
        if intCodDepartamento<>"" then
            sql = "select DIA_INICIAL, DIA_FINAL"
            sql = sql & " from EST_LIBERA_REQUISICAO "
            sql = sql & " where COD_DEPARTAMENTO = " & intCodDepartamento
            sql = sql & " And Cod_Empresa = " & intCodEmpresa
            rs.open sql, cnn
            if rs.eof = false then
                diaInicial	 = rs("DIA_INICIAL")
                diaFinal	 = rs("DIA_FINAL")
                
                if cInt(DAY(DATE))>=cInt(diaInicial) and cInt(DAY(DATE))<=cInt(diaFinal) then
                    if diaFinal = 31 then
                        if MONTH(DATE) = 2 then
                            diaFinal = 28
                        else
                            if MONTH(DATE) = 4 or MONTH(DATE) = 6 or MONTH(DATE) = 9 or MONTH(DATE) = 11 then
                                diaFinal = 30
                            end if
                        end if
                    end if 
    
                    strPeriodoLiberacao = formatadataAP(diaInicial & "/" & MONTH(DATE) & "/" & YEAR(DATE)) & " a " &  formatadataAP(diaFinal & "/" & MONTH(DATE) & "/" & YEAR(DATE)) 
                else
                    strMesPosterior = MONTH(DATE)+1
                    strAnoPosterior = YEAR(DATE)
                    if MONTH(DATE)=12 then 
                        strMesPosterior = 1
                        strAnoPosterior = YEAR(DATE)+1
                    end if
                    if diaFinal = 31 then
                        if strMesPosterior = 2 then
                            diaFinal = 29
                        else
                            if strMesPosterior = 4 or strMesPosterior = 6 or strMesPosterior = 9 or strMesPosterior = 11 then
                                diaFinal = 30
                            end if
                        end if
                    end if 
                    strPeriodoLiberacao = formatadataAP(diaInicial & "/" & strMesPosterior & "/" & strAnoPosterior) & " a " &  formatadataAP(diaFinal & "/" & strMesPosterior & "/" & strAnoPosterior) 
                end if
                
                intDiaInicial	= diaInicial
                intDiaFinal		= diaFinal
                intDiaAtual 	= day(date)
                
                
                sql = "select _d.TIPO"
                sql = sql & " from est_requisicao _r"
                sql = sql & " inner join SEG_usuarios _u on _u.cpf = _r.solicitante"
                sql = sql & " inner join EST_DEPARTAMENTO _d on _d.codigo = _u.codDepartamento"
                sql = sql & " where solicitante = '"&session("strNomeUsuario")&"'"
                rsAux.open sql, cnn
                if not rsAux.eof then
                    tipousuario = rsAux("tipo")
                    mostraMensagemPeriodoComp=""
                    if tipousuario = "UNIDADE_ESCOLA" then mostraMensagemPeriodoComp = ", você poderá enviar uma solicitação por mês."
                end if
                rsAux.close
                
                if cInt(intDiaAtual) >= cInt(intDiaInicial) and cInt(intDiaAtual) <= cInt(intDiaFinal) then 
                    'liberado
                    mostraMensagemPeriodo = "<font color='#009900'><i>(O per&iacute;odo de envio para autorização esta liberado" &mostraMensagemPeriodoComp&")</i></font>"
                else
                    mostraMensagemPeriodo = "<font color='#FF0000'><i>(O per&iacute;odo de envio de solicita&ccedil;&atilde;o para autoriza&ccedil;&atilde;o está bloqueado, mais voc&ecirc; poder&aacute; cadastrar sua solicita&ccedil;&atilde;o e esperar o período acima para envio)</i></font>"
                    strDesabilitaBotaoEnviarParaAutorizacao = "disabled"			
                end if
            end if
            rs.close
        end if
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Solitação de Material</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" name="frm" action="Solicitacao_cad.asp" method="post">
                <input name="tipo_usuario" type="hidden" id="tipo_usuario"  value="<%=tipo_usuario%>">
                <input name="txtCodigo" type="hidden" class="text" id="txtCodigo" size="10" maxlength="20" value="<%=intCodigo%>">
					
                  <div class="form-group">
                        <label class="form-label">Código</label>
                        <input class="form-control" name="txtCodRequisicao" size="10" maxlength="20" type="text" id="txtCodRequisicao" value="<%=intCodRequisicao%>" onBlur="consultar(this.value)">
                        <button class="btn-u btn-u-sea" onClick="return abreConsulta()" type="button"><i class="fa fa-search"></i></button>  
                   </div>  

                  <div class="form-group">
                     <label class="form-label">Situa&ccedil;&atilde;o</label>
                    <strong><%=strSituacao%></strong>
                  </div>

  				   <div class="form-group">
                        <label class="form-label">Solicitante</label>
                    	<%=session("strUsuarioRodape")%>
                  </div>
                 
                  <div class="form-group">
                        <label class="form-label">Data</label>
                    	<strong><%=strDataSolicitacao%></strong>
                  </div>
                  
                  <div class="form-group">
                        <label class="form-label">Lotação</label>
                    	<strong><%=strDepartamento%></strong>
                  </div>
                  
                  <div class="form-group">
                        <label class="form-label">Envio para Autoriza&ccedil;&atilde;o</label>
                    	<strong><font color="#333399"><%=strPeriodoLiberacao%></font></strong>&nbsp;
                  </div>
                  
                  <div class="form-group">
                    	<%=mostraMensagemPeriodo%>
                  </div>
	
                  <div class="form-group">
                    <label class="form-label">Observa&ccedil;&atilde;o</label>
                    <textarea name="txtObs" id="txtObs" cols="75" rows="3" class="form-control"><%=strObs%></textarea>
                  </div>
                  
                  <div class="form-group">
                    <label class="form-label">Se&ccedil;&atilde;o</label>
                    <!--#include file="../includes/inc_cmbSecaoProduto.asp" -->
                  </div>
                  
                  <div class="form-group">
                    <label class="form-label">Material</label>
                    <!--#include file="../includes/inc_cmbProdutoSolicitacao.asp"-->
                    <input name="txtDescricaoMaterial" type="text" class="form-control" id="txtDescricaoMaterial" size="30" maxlength="100" value="<%=strDescricaoMaterial%>" >
					<input type="button" name="cmdFiltrar"  style="cursor:hand"  value="Filtrar Material"  class="btn btn-u float-shadow"  onClick="carregaMaterial()">
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
		if intCodRequisicao <>"" then %>
                    
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Solitação de Material</h3>
          </div>
            <div class="panel-body">
            	<div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="9%" bgcolor="#95A5A6">Material</th>
                          <th width="83%" bgcolor="#95A5A6">Unidade</th>
                          <th width="83%" bgcolor="#95A5A6">Quantidade</th>
                          <th width="8%" bgcolor="#95A5A6" align="center"><div align="center">Excluir</div></th>
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
                            	<button class="btn-u btn-u-sea" onClick="excluirMaterial('<%=rs("Codigo")%>')" type="button"><i class="fa fa-file-text-o"></i></button> 
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
        function abreConsulta(){
            window.open("Solicitacao_con.asp", "consulta", "top=0,left=0,height=510,width=750,menubar=no,toolbar=no,scrollbars=yes,status=yes");
            return true;
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
                    frm.action="Solicitacao_cod.asp?acao=EXCLUIR&txtCodRequisicao="+frm.txtCodRequisicao.value;
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
            frm.action="Solicitacao_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
        function excluirMaterial(codigo){
            var men = 'ATENÇÃO: Deseja realmente excluir esse material da solicitação?\n';
            if (confirm(men)) {
                var frm = document.getElementById("frm");
                frm.action="Solicitacao_cod.asp?acao=EM&codigo=" + codigo + "&txtCodRequisicao="+frm.txtCodRequisicao.value;
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
                frm.action="Solicitacao_cod.asp?acao=F";
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