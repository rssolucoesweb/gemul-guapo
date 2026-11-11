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
    <!--#include file="includes/inc_cnn_almoxarifado.asp"-->
    <!--=== End Breadcrumbs ===-->
	<%  
        strTombamentoSim = ""
        strTombamentoNao = " checked "
        principal			= "principal.asp"
        strOnChangeGrupo	= "S" 
        strEmpresaSecaoProduto_submit = "S"
        intCodigo 			= Trim(Request("txtCodigo"))
        strDescricaoProduto			= Trim(Request.Form("txtDescricaoProduto"))
        intUnidadeProduto			= Trim(Request.Form("cmbUnidadeProduto"))
        intCodGrupoProduto			= Trim(Request.Form("cmbGrupoProduto")) 
        intCodSubGrupoProduto		= Trim(Request.Form("cmbSubGrupoProduto")) 
        intEstMinimo		 		= Trim(Request.Form("txtEstMinimo"))
        intEstMaximo		 		= Trim(Request.Form("txtEstMaximo"))
        strQtdAtualEst		 		= Trim(Request.Form("txtQtdAtualEst"))
        strPrecoCusto		 		= Trim(Request.Form("txtPrecoCusto"))
        strMargemLucro		 		= Trim(Request.Form("txtMargemLucro"))
        strPrecoVenda		 		= Trim(Request.Form("txtPrecoVenda"))
        intSecaoProduto				= Trim(Request("cmbSecaoProduto"))
        strReferProduto		 		= Trim(Request.Form("txtReferProduto"))
        intEAN				 		= Trim(Request.Form("txtEAN"))
        intCodMArca		 			= Trim(Request.Form("cmbMarcaProduto"))
        strObsProduto		 		= Trim(Request.Form("txtObsProduto"))
        strSituacao	 				= Trim(Request.Form("cmbSituacao"))
        
		'if intSecaoProduto = "" then intSecaoProduto = Session("CodSecao")
		if intSecaoProduto = "" then intSecaoProduto = "0"
	
	    strAcessoProdutoAdm			= "S" 
        if trim(intCodigo) <> "" then
        
            sql = " SELECT  _p.CODIGO, _p.DESCRICAO, _ga.acesso, _p.tipoAcesso, COD_MARCA, COD_UNIDADE,isnull(_p.COD_SUBGRUPO,0) as COD_SUBGRUPO, isnull(_g.COD_GRUPO_produto,0) as COD_GRUPO_produto, ESTOQUE_MINIMO, ESTOQUE_MAXIMO, QTD_ATUAL_ESTOQUE, PRECO_CUSTO, MARGEM_LUCRO, PRECO_VENDA, COD_SECAO, REFERENCIA, CODG_BARRAS, OBSERVACAO, _p.tombamento "
            sql = sql & "  FROM EST_PRODUTO _p "
            sql = sql & " left join EST_SUBGRUPO_PRODUTO _g on _g.codigo = _p.COD_SUBGRUPO"
            sql = sql & " left join EST_PRODUTO_ACESSO _ga on _ga.cod_produto =  _p.CODIGO"
            sql = sql & " WHERE _p.CODIGO = " & intCodigo
            sql = sql & " and _p.cod_secao = " & intSecaoProduto
            rs.open sql, cnn
            
            if rs.eof = false then
                strDescricaoProduto		    = rs("DESCRICAO")	
                strAcessoProduto		    = rs("tipoAcesso")	
                strTombamento			    = rs("tombamento")			
                if strTombamento = "S" then 
                    strTombamentoSim = " checked "
                    strTombamentoNao = ""
                else
                    strTombamentoSim = ""
                    strTombamentoNao = " checked "
                end if
                
                intUnidadeProduto		= rs("COD_UNIDADE")
                if request("gp") = "" then
                    intCodGrupoProduto			= rs("COD_GRUPO_produto")
                    intCodSubGrupoProduto			= rs("COD_SUBGRUPO")
                end if
                
                intEstMinimo				= rs("ESTOQUE_MINIMO")
                intEstMaximo				= rs("ESTOQUE_MAXIMO")
                strQtdAtualEst				= rs("QTD_ATUAL_ESTOQUE")
                strPrecoCusto				= formatNumber(rs("PRECO_CUSTO"),2)
                    
                strMargemLucro				= formatNumber(rs("MARGEM_LUCRO"),2)
                strPrecoVenda				= formatNumber(rs("PRECO_VENDA"),2)
                
                if Trim(Request.Form("cmbSecaoProduto")) = "0" or Trim(Request.Form("cmbSecaoProduto")) = "" then
                    intSecaoProduto			= rs("COD_SECAO")
                end if
                
                strReferProduto				= rs("REFERENCIA")
                intEAN						= rs("CODG_BARRAS")
                
                if Trim(Request.Form("cmbMarcaProduto")) = "0" or Trim(Request.Form("cmbMarcaProduto")) = "" then
                    intCodMarca			= rs("COD_MARCA")
                end if
                strObsProduto				= rs("OBSERVACAO")
                
                strDesabilitaIncluir		= "disabled" 'Desabilita o botão Incluir
                strDesabilitaAlterar 		= "" 'Desabilita o botão Excluir
                strDesabilitaExcluir		= "" 'Desabilita o botão Excluir
    
                strAcessoProdutoAdm			= "S" 
                strAcessoProdutoUE			= "" 
                strAcessoProdutoCMEIS		= ""
                strAcessoProdutoEMEI		= ""
                
                 
                strAcessoProdutoSec			= ""
                while not rs.eof
                    if rs("acesso") = "SECRETARIA" 		then strAcessoProdutoSec	= "S" 
                    if rs("acesso") = "ADMINISTRACAO" 	then strAcessoProdutoAdm	= "S" 
                    if rs("acesso") = "UNIDADE_ESCOLA" 	then strAcessoProdutoUE		= "S" 
                    if rs("acesso") = "CMEIS" 			then strAcessoProdutoCMEIS	= "S" 
                    if rs("acesso") = "EMEI" 			then strAcessoProdutoEMEI	= "S" 
                    rs.movenext
                wend
                
            end if 
            rs.close
        else
            strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
            strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
            strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
        end if 
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Produto</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	
                  	<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
                    
                    <div class="form-group">
                    	<label class="form-label">Se&ccedil;&atilde;o</label>
                    	<!--#include file="../includes/inc_cmbSecaoProduto.asp" -->
                    </div>
                    
                    <div class="form-group">
                    	<label class="form-label">Descri&ccedil;&atilde;o do Produto</label>
                    	<input name="txtDescricaoProduto" type="text" class="form-control" id="txtDescricaoProduto" size="60" maxlength="100" value="<%=strDescricaoProduto%>">
                    </div>
                    
                    <div class="form-group">
                    	<label class="form-label">Marca</label>
                    	<!--#include file="../includes/inc_cmbMarcaProduto.asp"-->
                    </div>
                    
                    <div class="form-group">
                    	<label class="form-label">Unidade</label>
                    	<!--#include file="../includes/inc_cmbUnidadeProduto.asp"-->
                    </div>
                    
                    <div class="form-group">
                    	<label class="form-label">Grupo</label>
                    	<!--#include file="../includes/inc_cmbGrupoProduto.asp"-->
                    </div>
                    
                    <div class="form-group">
                    	<label class="form-label">SubGrupo</label>
                    	<!--#include file="../includes/inc_cmbSubGrupoProduto.asp"-->
                    </div>
                    
                    <div class="form-group">
                    	<label class="form-label">Acesso ao Produto</label>
                        <input name="chkAcessoProduto" type="hidden" value="ADMINISTRACAO"	>
                        <input disabled <%if strAcessoProdutoAdm 	= "S" then%> checked <%end if%> name="chkAcessoProduto" type="checkbox" value="ADMINISTRACAO"	>Administra&ccedil;&atilde;o&nbsp;&nbsp;
                        <input <%if strAcessoProdutoSec 	= "S" then%> checked <%end if%> name="chkAcessoProduto" type="checkbox" value="SECRETARIA"		>Secretaria Municipal&nbsp;&nbsp;
                        <input <%if strAcessoProdutoUE 		= "S" then%> checked <%end if%> name="chkAcessoProduto" type="checkbox" value="UNIDADE_ESCOLA"	>Unidade Escolares&nbsp;&nbsp;
                        <input <%if strAcessoProdutoCMEIS 	= "S" then%> checked <%end if%> name="chkAcessoProduto" type="checkbox" value="CMEIS"			>CMEIS          
                        <input <%if strAcessoProdutoEMEI 	= "S" then%> checked <%end if%> name="chkAcessoProduto" type="checkbox" value="EMEI"			>EMEI          
                    </div>
                    
                    <div class="form-group">
                    	<label class="form-label">Estoque M&iacute;nimo</label>
                    	<input name="txtEstMinimo" type="text" class="form-control" id="txtEstMinimo" size="40" maxlength="40" value="<%=intEstMinimo%>"  onKeyPress="return formataCampo(this, 2, 8)">
                    </div>
                    
                    <div class="form-group">
                    	<label class="form-label">Estoque M&aacute;ximo</label>
                    	<input name="txtEstMaximo" type="text" class="form-control" id="txtEstMaximo" size="40" maxlength="40" value="<%=intEstMaximo%>"  onKeyPress="return formataCampo(this, 2, 8)">
                    </div>
                    
                    <div class="form-group">
                    	<label class="form-label">Qtd. Atual em Estoque</label>
                    	<input name="txtQtdAtualEst" type="textDesabilitado" class="form-control" id="txtQtdAtualEst" size="40" maxlength="40" value="<%=strQtdAtualEst%>" disabled >
                    </div>
                    
                    <div class="form-group">
                    	<label class="form-label">Pre&ccedil;o de Custo</label>
                    	R$&nbsp;<input name="txtPrecoCusto" type="text" class="form-control" id="txtPrecoCusto" size="20" maxlength="10" value="<%=strPrecoCusto%>"  onKeyPress="return currencyFormat(this,event)">
                    </div>
                    
                    <div class="form-group">
                    	<label class="form-label">Margem de Lucro</label>
                    	%&nbsp;&nbsp;<input name="txtMargemLucro" type="text" class="form-control" id="txtMargemLucro" size="20" maxlength="10" value="<%=strMargemLucro%>" onblur="submit()"  onKeyPress="return currencyFormat(this,event)">
                    </div>
                    
                    <%		
						if strMargemLucro<>"" and strPrecoCusto<>"" then
						strPrecoVenda = formatNumber(round((((strMargemLucro * strPrecoCusto)/100) + strPrecoCusto),2),2)
						end if
						'end if
					%>
                    
                    <div class="form-group">
                    	<label class="form-label">Pre&ccedil;o de Venda</label>
                    	R$&nbsp;<input name="txtPrecoVenda" type="text" class="form-control" id="txtPrecoVenda" size="20" maxlength="10" value="<%=strPrecoVenda%>"  onKeyPress="return currencyFormat(this,event)">
                    </div>
                    
                    <div class="form-group">
                    	<label class="form-label">Refer&ecirc;ncia</label>
                    	<input name="txtReferProduto" type="text" class="form-control" id="txtReferProduto" size="40" maxlength="40" value="<%=strReferProduto%>">
                    </div>
                    
                    <div class="form-group">
                    	<label class="form-label">C&oacute;digo de Barras</label>
                    	<input name="txtEAN" type="text" class="form-control" id="txtEAN" size="40" maxlength="40" value="<%=intEAN%>">
                    </div>
                    
                    <div class="form-group">
                    	<label class="form-label">Observa&ccedil;&otilde;es</label>
                    	<input name="txtObsProduto" type="text" class="form-control" id="txtObsProduto" size="40" maxlength="40" value="<%=strObsProduto%>">
                    </div>
                    
                    <div class="form-group">
                    	<label class="form-label">Tombamento</label>
                    	<input type="radio" <%=strTombamentoSim%>  name="tombamento" id="tombamento" value="S">Sim&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" <%=strTombamentoNao%> name="tombamento" id="tombamento" value="N">N&atilde;o
                    </div>

                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                </form>
       	  </div>
   	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
       <%if intSecaoProduto <> "0" then %>
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Produto </h3>
          </div>
            <div class="panel-body">
            	<div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="9%" bgcolor="#95A5A6">C&oacute;digo</th>
                          <th width="83%" bgcolor="#95A5A6">Descri&ccedil;&atilde;o</th>
                          <th width="83%" bgcolor="#95A5A6">Unidade</th>
                          <th width="83%" bgcolor="#95A5A6">Grupo</th>
                          <th width="83%" bgcolor="#95A5A6">Subgrupo</th>
                          <th width="83%" bgcolor="#95A5A6">Qtd. Estoque Atual</th>
                          <th width="8%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                      </tr>
                    </thead>
                  <%
                    cont =0
					
					cont =0
					sql = " select _P.CODIGO, _P.DESCRICAO, _P.QTD_ATUAL_ESTOQUE, _g.descricao as grupo, _sg.descricao as subgrupo, _P.PRECO_CUSTO, _P.PRECO_VENDA, _Up.DESCRICAO AS UNIDADE, _S.DESCRICAO AS SECAO "
					sql = sql & " from EST_PRODUTO _P "
					sql = sql & " left join EST_UNIDADE_PRODUTO _up on _up.codigo = _p.COD_UNIDADE"
					sql = sql & " left join EST_SUBGRUPO_PRODUTO _sg on _sg.codigo = _p.COD_SUBGRUPO"
					sql = sql & " left join EST_GRUPO_PRODUTO _g on _g.codigo = _sg.COD_GRUPO_PRODUTO"
					sql = sql & " LEFT JOIN EST_SECAO_PRODUTO _S ON _S.CODIGO = _P.COD_SECAO and _S.COD_EMPRESA = _P.COD_EMPRESA"
					sql = sql & " where _P.COD_EMPRESA = '"& Session("CodEmpresa") &"'"	
					sql = sql & " and _P.COD_SECAO = "& intSecaoProduto
					sql = sql & " Order by _P.DESCRICAO "
				    rs.open sql, cnn
                    if rs.eof = false then
                    
                    while not rs.eof
						cont = cont + 1	
						if (rs("CODIGO")) <> "" then intCod = intCodProduto
			        %>
                    <tbody>
                        <tr>
                          <td><%=trim(rs("Codigo"))%></td>
                          <td><%=trim(rs("DESCRICAO"))%></td>
                          <td><%=trim(rs("UNIDADE"))%></td>
                          <td><%=trim(rs("grupo"))%></td>
                          <td><%=trim(rs("subgrupo"))%></td>
                          <td><%=trim(rs("QTD_ATUAL_ESTOQUE"))%></td>
                          <td align="center" >
                            <button class="btn-u btn-u-sea" onclick="resultadoConsulta(<%=trim(rs("Codigo"))%>)" type="button"><i class="fa fa-file-text-o"></i></button> 
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
        <!--End Table Bordered-->	
        <%end if%>
        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
	<script>
    
        function resultadoConsulta(intCodigo){
            frm.txtCodigo.value=intCodigo
            frm.submit();
        }
        function carregaGrupo(){
            frm.action = "Produto_cad.asp?gp=s";
            frm.submit();
        }
        function salvar(acao){
            
            var frm = document.getElementById("frm");
            if (frm.cmbSecaoProduto.value == "0") {
                alert("Seção deve ser informada!");
                frm.cmbSecaoProduto.focus();
                return false;
            }
    
            if (frm.txtDescricaoProduto.value == "") {
                alert("A Descrição deve ser informada !");
                frm.txtDescricaoProduto.focus();
                return false;
            }
            if (frm.cmbUnidadeProduto.value == "0") {
                alert("A Unidade deve ser informada !");
                frm.cmbUnidadeProduto.focus();
                return false;
            }
    /*		if (frm.cmbGrupoProduto.value == "0") {
                alert("A grupo deve ser informado!");
                frm.cmbGrupoProduto.focus();
                return false;
            }
            if (frm.cmbSubGrupoProduto.value == "0") {
                alert("A subgrupo deve ser informado!");
                frm.cmbSubGrupoProduto.focus();
                return false;
            }*/
            if (frm.txtEstMinimo.value == "") {
                alert("Estoque mínimo deve ser informado!");
                frm.txtEstMinimo.focus();
                return false;
            }
            if (frm.txtEstMaximo.value == "") {
                alert("Estoque máximo deve ser informad!");
                frm.txtEstMaximo.focus();
                return false;
            }
            
            
            frm.action="Produto_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 