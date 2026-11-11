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
    <iframe name="iframeAlteracao" height="0" width="0"></iframe>
	<%  
        strEmpresaSecaoProduto_submit = "S"
        principal			= "principal.asp"
        intCodEmpresa		= session("CodEmpresa")	
        intSecaoProduto			= Trim(Request.Form("cmbSecaoProduto"))
        if intSecaoProduto = "" then intSecaoProduto = Session("CodSecao")
        strUnidade = request("unidade")
        strTop = request("top")
        if strTop = "" then strTop = "5"
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Liberação das Solicitações Autorizadas   </h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                  <form id="frm" name="frm" action="#" method="post">
    			  <input value="<%=session("strNomeUsuario")%>" id="usuarioAutorizacao" name="usuarioAutorizacao" type="hidden">

                  <div class="form-group">
                        <label class="form-label">Se&ccedil;&atilde;o</label>
                        <!--#include file="../includes/inc_cmbSecaoProdutoLiberarMaterial.asp" -->
                  </div>
                  
                   <div class="form-group">
                        <label class="form-label">Departamento/Unidade</label>
                        <input type="text" name="unidade" id="unidade" value="<%=strUnidade%>" class="form-control" size="30">
                  </div>

                    <legend></legend>
                    <input type="button" class="btn btn-u float-shadow" value="Consultar" name="Consultar" onClick="consultarAutorizacoes()">
                </form>
       	  </div>
   	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
       <%
	    cont=0		
		if intSecaoProduto <> "0" or botaopesquisar="S" then %>
            
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i>Lista de Solicitações Autorizadas</h3>
          </div>
            <div class="panel-body">
            	<div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="7%" bgcolor="#95A5A6">#o</th>
                          <th width="7%" bgcolor="#95A5A6">C&oacute;digo</th>
                          <th width="47%" bgcolor="#95A5A6">Departamento/Unidade</th>
                          <th width="19%" bgcolor="#95A5A6">Solicitante</th>
                          <th width="20%" bgcolor="#95A5A6">Autorizado Por</th>
                      </tr>
                    </thead>
                  <%
                    cont =0
					
					sql = "select _r.codigo, _r.obs,_u.nome as solicitante, _ua.nome as usuario_autorizacao, _r.data_autorizacao, "
					sql = sql & " case "
					sql = sql & " 	when _di.codigo is null then _d.descricao "
					sql = sql & " 	else _dd.descricao "
					sql = sql & " 	end as depto "	
					sql = sql & " from est_requisicao _r"
					sql = sql & " inner join SEG_usuarios _u on _u.cpf = _r.solicitante"
					sql = sql & " left join SEG_usuarios _ua on _ua.cpf = _r.usuario_autorizacao"
					sql = sql & " left join EST_departamento _d on _d.codigo = _u.codDepartamento"
					sql = sql & " left  join EST_departamento _dd				on _dd.codigo = _r.codDepartamento "
					sql = sql & " left  join est_requisicaoDistribuicao _di	on _di.codRequisicao = _r.codigo "
					sql = sql & " where _r.codSituacao = 3 "
					sql = sql & " and _r.cod_secao = " & intSecaoProduto
					if strUnidade<>"" then
						sql = sql & " and _d.descricao like '%" & strUnidade & "%'"
					end if
					sql = sql & " order by 1"
					
				    rs.open sql, cnn
                    if rs.eof = false then
                    
                    while not rs.eof
						cont = cont + 1	
			        %>
                    <tbody>
                        <tr>
                        	<td><a href="javascript:showTr(1)">[+]</a></td>
                            <td><%=trim(rs("Codigo"))%></td>
                            <td><%=trim(rs("depto"))%></td>
                          	<td><%=trim(rs("solicitante"))%> </td> 
                            <td><%=trim(Rs("usuario_autorizacao"))%><br><%=trim(Rs("data_autorizacao"))%></td> 
                        </tr>
                        <tr id="tr1" style="display:none;">
                          <td colspan="5">
                          
                          	<!-- execucao -->
                                     <%if not isnull(rs("obs")) then%>
                                   	<table class="table table-bordered">
                                      <tr bgcolor="#FFB7B7">
                                        <td width="26%" rowspan="2" align="center"><STRONG>Observa&ccedil;&atilde;o/Justificativa</STRONG></td>
                                        <td rowspan="2" align="left"><%=rs("obs")%>&nbsp;</td>
                                      </tr>
                                  </table>
                                     <%end if%>
                                  
								  <div id="requisicaoIens_<%=rs("codigo")%>"></div>
                          
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

	function showTr(id){
		var elemento = document.getElementById("tr" + id);
		if(elemento.style.display == ''){
			elemento.style.display = 'none';
		}else{
			elemento.style.display = '';
		}
	}
	
	function mostraConsultaItens(idReq){
        $.ajax({
            type: "GET",
            url: "LiberarMaterial_Itens.asp",
            data: { id: idReq },
            contentType: "application/html; charset=utf-8",
            success: function (data) {
                $("#requisicaoIens_"+idReq).empty();
                $("#requisicaoIens_"+idReq).html(data);
            },
            dataType: "html"
        });   
    }
	
	function consultarAutorizacoes(){
			var frm = document.getElementById("frm");
			if (frm.cmbSecaoProduto.value=="0") {
				alert("Seção deve ser selecionada!");
				frm.cmbSecaoProduto.focus();
			}else{
				frm.action="LiberarMaterial_con.asp?botaopesquisar=S";
				frm.submit();
			}
		}
	function resultadoConsulta(intCodigo){
		frm.txtCodigo.value=intCodigo
		frm.submit();
	}
	function salvarQuantidadeAutorizadaAlteracao(qtde){
		frm.txtCodigo.value=intCodigo
		frm.submit();
	}
	
	function salvarQuantidadeAutorizadaAlteracao(codigo, qtde, acao) {
		iframeAlteracao.location.href='LiberarMaterialAlteracao_cod.asp?acao='+acao+'&codigo='+codigo+'&qtde='+qtde;
		return true;
	}
	function autorizar(req,tombamento,qtdeItens){
		var frm = document.getElementById("frm");
		document.getElementById("cmbAutorizarRequisicao_"+req).disabled = true;
		var men = 'ATENÇÃO: Deseja liberar a requisição número ' + req + '?\n';
		if (confirm(men)) {
			if(tombamento=="S"){
				for (i=0;i<qtdeItens;i++){
					if(document.getElementsByName("txtTombamento_"+req)[i].value==""){
						alert("O tombamento deve ser informado!");
						document.getElementById("cmbAutorizarRequisicao_"+req).disabled = false;
						document.getElementsByName("txtTombamento_"+req)[i].focus();
						return false;	
					}
				}
			}
			frm.action="LiberarMaterial_cod.asp?req="+req;
			frm.submit();
			return true;
		}else{
			document.getElementById("cmbAutorizarRequisicao_"+req).disabled = false;
			return false;
		}
 	}
</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 