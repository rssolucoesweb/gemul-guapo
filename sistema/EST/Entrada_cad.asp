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
        strEmpresaSecaoProduto_submit = "S"
        principal					= "principal.asp"
        strBotaoLimpa				= "S"
        strPagina					= "Entrada_cad.asp"
        
        intCodigo 					= Trim(Request("txtCodigo"))
        intCodEmpresa				= session("CodEmpresa")	
        intFornecedor				= Trim(Request.Form("cmbFornecedor"))
        strNumeroNota				= Trim(Request.Form("txtNumeroNota"))
        strDataEntrada				= Trim(Request.Form("txtDataEntrada"))
        strValorNota				= Trim(Request.Form("txtValorNota"))
        
        strItens 				= Trim(Request("txtItens"))
        strItensBanco			= 0
    
        strDesabilitaIncluir		= "disabled" 'Desabilita o botão Incluir
        strDesabilitaAlterar 		= "disabled" 'Desabilita o botão Excluir
        strDesabilitaExcluir		= "disabled" 'Desabilita o botão Excluir
        strDesabilitaImprimir		= "disabled"
        intSecaoProduto			= Trim(Request.Form("cmbSecaoProduto"))
        if intSecaoProduto = "" then intSecaoProduto = Session("CodSecao")
    
        if trim(intCodigo) <> "" then
        
            sql = " SELECT Codigo, CodEmpresa, CodFornecedor, Numero, Data_Entrada, Valor_Total"
            sql = sql & " FROM EST_Entrada "
            sql = sql & " WHERE CodEmpresa = " & intCodEmpresa
            sql = sql & " And Codigo = " & intCodigo
            rs.open sql, cnn
    
            if rs.eof = false then
                
                intCodigo 					= rs("Codigo")
                intFornecedor				= rs("CodFornecedor")
                strNumeroNota				= rs("Numero")
                strDataEntrada				= formataDataAP(rs("Data_Entrada"))
                strValorNota				= formatnumber(rs("Valor_Total"),2)
                strTipoExecucao 			= "A"
                    
                strDesabilitaIncluir		= "disabled" 'Desabilita o botão Incluir
                strDesabilitaAlterar 		= "disabled" 'Desabilita o botão Excluir
                strDesabilitaExcluir		= "disabled" 'Desabilita o botão Excluir
                strDesabilitaImprimir		= ""
    
                
            end if 
            rs.close
            sql = " Select count(*) as qtde "
            sql = sql & " from EST_EntradaItens"
            sql = sql & " where CodEntrada = " & intCodigo
            rs.open sql, cnn
            if not rs.eof then
                strItens = rs("qtde")
                strItensBanco = rs("qtde")
            end if
            rs.close
        else
        
            strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
            strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
            strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
            strTipoExecucao 		= "I"
            
        end if 
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Entrada de Material</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" name="frm" action="Entrada_cad.asp" method="post">
                	<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
                  
                   <div class="form-group">
                        <label class="form-label">Se&ccedil;&atilde;o</label>
                        <!--#include file="../includes/inc_cmbSecaoProduto.asp" -->
                  </div>
                  
                  	
                  <div class="form-group">
                        <label class="form-label">Fornecedor</label>
                        <!--#include file="../includes/inc_cmbFornecedor.asp"-->
                        <button class="btn-u btn-u-sea" onClick="return abreConsulta('Entrada_con.asp')" type="button"><i class="fa fa-search"></i></button>  
                    </div>
                    
                 
                  <div class="form-group">
                        <label class="form-label">N/Nota</label>
                        <input name="txtNumeroNota" type="text" class="form-control" id="txtNumeroNota" size="40" maxlength="40" value="<%=strNumeroNota%>">
                  </div>
                  
                   <div class="form-group">
                        <label class="form-label">Data de Entrada</label>
                        <input name="txtDataEntrada" type="text" class="form-control" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strDataEntrada%>" size="10" maxlength="10">
                  </div>
                  
                   <div class="form-group">
                        <label class="form-label">Valor Nota</label>
                        <input name="txtValorNota" type="text" class="form-control" id="txtValorNota" size="10" maxlength="10" value="<%=strValorNota%>"  onKeyPress="return currencyFormat(this,event)">
                  </div>
                  
                  <%
			
				 if strTipoExecucao = "A" then
				  
					sql = " Select Codigo, CodEntrada, CodProduto, Quantidade, Valor_unitario "
					sql = sql & " From EST_EntradaItens "
					sql = sql & " Where CodEntrada = " & intCodigo
					rsAux.open sql, cnn
					
					vetItens = null
					qtdeItens = 0
					
					rs.open sql, cnn
					if not rs.eof then
						vetItens = rs.getRows
					end if
					rs.close
					
					if isArray(vetItens) then
						for i=0 to ubound(vetItens,2)
							qtdeItens 			= qtdeItens + 1
						next
					end if
					
				end if
				%>
                <%if strTipoExecucao = "I" then%>  
                  <div class="form-group">
                        <label class="form-label">Qtde. de Itens</label>
                        <input name="txtItens" type="text" class="<%if strTipoExecucao = "I" then response.write "text" else response.write "textDesabilita"%>" id="txtItens" <%if strTipoExecucao = "A" then%> readonly <%end if%> value="<%=strItens%>" size="5" maxlength="50"  onKeyPress="return formataCampo(this,2,15)">
    	        		<input type="button" name="button" class="botao" id="button" value="Gerar Itens" onClick="gerarLotes()">
                  </div>
                  <%else
            		response.Write(strItens)
			  	end if%>
                
	              <legend></legend>
                  <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                </form>
       	  </div>
   	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
       <%
		  strTotalItens		= 0
		if strItens <> "" then
		
			if strTipoExecucao = "A" then
				sql = " Select i.Codigo, i.CodEntrada, i.CodProduto, i.Quantidade, i.Valor_unitario, p.COD_SECAO"
				sql = sql & " from EST_EntradaItens i "
				sql = sql & " inner join EST_produto p on p.codigo = i.codProduto"
				sql = sql & " where i.CodEntrada = " & intCodigo
				vetItens = null
				rs.open sql, cnn,3,1
				if not rs.eof then
					vetItens = rs.getRows
				end if
				rs.close
			end if
			qtdeItens = strItens
		
		%>

        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Itens Entrada de Material</h3>
          </div>
            <div class="panel-body">
            	<div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="4%" bgcolor="#95A5A6">Item.</th>
                          <th width="57%" bgcolor="#95A5A6">Produto</th>
                          <th width="24%" bgcolor="#95A5A6">Qtde</th>
                          <th width="15%" bgcolor="#95A5A6">Valor Total</th>
                      </tr>
                    </thead>
                  <%
                    for i=1 to qtdeItens 

						id = i
						intCodProduto				= "0"
						strQtde 					= ""
						strValor					= ""
					
						if cInt(i)<=cInt(strItensBanco) and strTipoExecucao = "A" then
							intCodProduto  		= vetItens(2,i-1)
							strQtde 			= vetItens(3,i-1)
							strValor  			= formatnumber(vetItens(4,i-1),2) 
							strTotalItens		= strTotalItens + vetItens(4,i-1)
							intSecaoProduto		= vetItens(5,i-1)
						end if
			        %>
                    <tbody>
                        <tr>
                          <td><%=i%></td>
                          <td><!--#include file="../includes/inc_cmbProdutoEntrada.asp"--></td>
                          <td><input name="txtQtde<%=i%>" type="text" class="form-control" id="txtQtde<%=i%>" size="10" maxlength="20" value="<%=strQtde%>" onKeyPress="return formataCampo(this, 2, 10)"></td>
                          <td><input name="txtValor<%=i%>" type="text" class="form-control" id="txtValor<%=i%>" size="10" maxlength="20" value="<%=strValor%>" onBlur="calculaValor('<%=qtdeItens%>')" onKeyPress="return currencyFormat(this,event)"></td>
                        </tr>
                    </tbody>
                    <%next %>
           		
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
    function calculaValor(totalItem){
        var frm = window.document.forms[0];
        var valor=0;
        var intValorTotal=0;
        
        //*****verifica se um aluno foi selecionado
        for (var i = 1; i <= totalItem; i++) {
            //verifica todos os checkbox
            if (document.getElementById("txtValor"+i).value!=''){
                valor = document.getElementById("txtValor"+i).value;
                valor = valor.replace('.','');
                valor = valor.replace('.','');
                valor = valor.replace('.','');
                valor = valor.replace(',','.');
                intValorTotal = parseFloat(intValorTotal) + parseFloat(valor);
            }
        }
        var totals;
        totals = "";
        totals = intValorTotal.toFixed(2);
        totals = totals.replace('.',',');
    
        document.getElementById("txtTotalItens").value = FormataValor(totals);
    }
        
    function FormataValor(valor){
        var posVirgula;
        var tamnhoValor;
        var i, cont;
        var valorFinal;
        var valorInicial; 
        
        valor = valor.replace(".","");
        valorInicial = valor;
        if (valor == "")
            return false;			
        
        posVirgula = valor.indexOf(",");
        tamanhoValor = valor.length;
        
        if (posVirgula == -1){
            valor = valor + ",00";
        }
        else {
            
            if (parseInt(tamanhoValor) - parseInt(posVirgula) ==2){
                valor = valor + "0"
            }
        }
        cont=0;
        valorFinal = "";
        posVirgula = valor.indexOf(",");
        
        for (i=posVirgula-1;i>=0;i--){
            valorFinal = valor.substr(i,1) + valorFinal
            cont ++;
            if (valor.substr(i,1) != "-"){
                if (i>0) {
                    if (cont == 3){
                        valorFinal = "." + valorFinal;
                        cont = 0;
                    }
                }
            }
        }
        if (valorFinal=="")
            valorFinal = valorInicial;
        
        valorFinal = valorFinal + valor.substr(posVirgula,3);
        return valorFinal;
    }
        function gerarLotes(){
            frm.action='Entrada_cad.asp';
            frm.submit();
        }
    
        function resultadoConsulta(intCodigo){
                frm.txtCodigo.value=intCodigo
                frm.submit();
            }
    
        function salvar(acao){
            
            var frm = document.getElementById("frm");
            
            if (frm.cmbFornecedor.value == "0") {
                alert("O Fornecedor deve ser informado !");
                frm.cmbFornecedor.focus();
                return false;
            }
            if (frm.txtNumeroNota.value == "0") {
                alert("O Número da Nota deve ser informado !");
                frm.txtNumeroNota.focus();
                return false;
            }
            
            if (frm.txtDataEntrada.value == "") {
                alert("A Data de Entrada deve ser informada!");
                frm.txtDataEntrada.focus();
                return false;
            }
            
            if (frm.txtValorNota.value == "") {
                alert("O Valor da Nota deve ser informao!");
                frm.txtValorNota.focus();
                return false;
            }
            
            if (document.getElementById("txtTotalItens").value!=document.getElementById("txtValorNota").value){
                alert("O Valor da Nota esta diferente dos somantoria dos valores dos itens!");
                frm.txtValorNota.focus();
                return false;
            }
            
            frm.action="Entrada_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 