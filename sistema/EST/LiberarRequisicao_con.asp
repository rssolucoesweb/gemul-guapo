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
        principal			= "principal.asp"
        intCodEmpresa		= session("CodEmpresa")	
        intSecaoProduto			= Trim(Request.Form("cmbSecaoProduto"))
        if intSecaoProduto = "" then intSecaoProduto = Session("CodSecao")
        if intSecaoProduto = "" then intSecaoProduto = 0
        intQtdeMostrar			= Trim(Request.Form("txtQtdeMostrar"))
        if intQtdeMostrar = "" then intQtdeMostrar = "5"
        strNomeDaUnidade			= Trim(Request.Form("txtUnidade"))
        botaopesquisar			= Trim(Request("botaopesquisar"))
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Analise/Autorização da Solicitação</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	
                  <input value="<%=session("strNomeUsuario")%>" id="usuarioAutorizacao" name="usuarioAutorizacao" type="hidden">
                    
                  <div class="form-group">
                    <label class="form-label">Se&ccedil;&atilde;o</label>
                    <!--#include file="../includes/inc_cmbSecaoProduto.asp" -->
                  </div>
                  
                  <div class="form-group" style="display:none">
                    <label class="form-label"> Mostrar somente</label>
                    <input value="<%=intQtdeMostrar%>" size="3" type="text" class="form-control" name="txtQtdeMostrar" id="txtQtdeMostrar">
                  </div>
                  
                  <div class="form-group">
                    <label class="form-label">Filtrar pelo nome da unidade</label>
                    <input value="<%=strNomeDaUnidade%>" size="15" type="text" class="form-control" name="txtUnidade" id="txtUnidade">&nbsp;
                    <input type="button" class="btn btn-u float-shadow" value="Consultar" name="Consultar" onClick="consultarAutorizacoes()">
                  </div>
                </form>
       	  </div>
   	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
       <%
			if intSecaoProduto <> "0" or botaopesquisar="S" then
					cont =0
					if intQtdeMostrar = "" then intQtdeMostrar = "5" %>
					
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Balanço</h3>
          </div>
            <div class="panel-body">
            	<div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="9%" bgcolor="#95A5A6">#</th>
                          <th width="9%" bgcolor="#95A5A6">C&oacute;digo</th>
                          <th width="83%" bgcolor="#95A5A6">Data</th>
                          <th width="83%" bgcolor="#95A5A6">Departamento/Unidade</th>
                          <th width="8%" bgcolor="#95A5A6">Solicitante</th>
                      </tr>
                    </thead>
                  <%
                    cont =0
					'sql = "select top " & intQtdeMostrar & " _r.codigo, _r.dataentrada, _u.nome, _d.descricao as depto, _r.obs, _r.tipo"
					sql = "select	"
					sql = sql & " 		_r.codigo, "
					sql = sql & " 		_r.dataentrada, "
					sql = sql & " 		_u.nome, "
					sql = sql & " 		_di.codRequisicao,"
					sql = sql & " case "
					sql = sql & " 	when _di.codigo is null then _d.descricao "
					sql = sql & " 	else _dd.descricao "
					sql = sql & " 	end as depto, "
					sql = sql & " 	_r.obs, _r.tipo"
					sql = sql & " from est_requisicao _r "
					sql = sql & " inner join SEG_usuarios _u					on _u.cpf = _r.solicitante "
					sql = sql & " left  join EST_departamento _d				on _d.codigo = _u.codDepartamento "
					sql = sql & " left  join EST_departamento _dd				on _dd.codigo = _r.codDepartamento "
					sql = sql & " left  join est_requisicaoDistribuicao _di	on _di.codRequisicao = _r.codigo "
					sql = sql & " where _r.codSituacao = 2 "
					sql = sql & " and _r.cod_secao = " & intSecaoProduto
					sql = sql & " and _r.codEmpresa = " & intCodEmpresa
					if strNomeDaUnidade<>"" then
						sql = sql & " and ( _d.descricao like '%" & strNomeDaUnidade & "%' or  _dd.descricao like '%" & strNomeDaUnidade & "%' )"
					end if
					sql = sql & " order by 1"
					rs.open sql, cnn
					if rs.eof = false then
				    
                    while not rs.eof
						cont = cont + 1	
						emergencial = ""
						if rs("tipo") = "E" then emergencial = "<img src='../../../images/emergencial.png' alt='Solicitação Emergencial' width='16' height='16' align='absmiddle'>"
			        %>
                    <tbody>
                        <tr>
                        	<td><div align="center"><a href="javascript:showTr(1)">[+]</a></div></td>
                            <td><strong><%=rs("Codigo")%><%=emergencial%></strong></td>
                            <td><%=trim(rs("dataentrada"))%></td>
                            <td><%=trim(rs("depto"))%></td>
                          	<td><%=trim(rs("nome"))%></td> 
                        </tr>
                        <tr id="tr1" style="display:none;">
                        
                          <td colspan="5">
                        
                          	<%if not isnull(rs("obs")) then%>
                                <table class="table table-bordered">
                                  <tr bgcolor="#FFB7B7">
                                    <td width="26%" height="35" rowspan="2" align="center"><STRONG>Observa&ccedil;&atilde;o/Justificativa</STRONG></td>
                                    <td rowspan="2" align="left"><STRONG><font color="#0033CC"><%=rs("obs")%></font></STRONG>&nbsp;</td>
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
        <%
		 end if
    	%>
        <!--End Table Bordered-->	
        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
	<script>
	
	 function mostraConsultaItens(idReq){
        $.ajax({
            type: "GET",
            url: "LiberarRequisicao_Itens.asp",
            data: { id: idReq },
            contentType: "application/html; charset=utf-8",
            success: function (data) {
                $("#requisicaoIens_"+idReq).empty();
                $("#requisicaoIens_"+idReq).html(data);
            },
            dataType: "html"
        });   
    }
	
	function resultadoConsulta(intCodigo){
			frm.txtCodigo.value=intCodigo
			frm.submit();
		}
	function consultarAutorizacoes(){
				var frm = document.getElementById("frm");
				if (frm.cmbSecaoProduto.value=="0") {
					alert("Seção deve ser selecionada!");
					frm.cmbSecaoProduto.focus();
				}else{
					frm.action="LiberarRequisicao_con.asp?botaopesquisar=S";
					frm.submit();
				}
			}
	function autorizar(req){

		var men = 'ATENÇÃO: Deseja autorizar a requisição número ' + req + '?\n';
		if (confirm(men)) {
			var frm = document.getElementById("frm");
			frm.action="LiberarRequisicao_cod.asp?req="+req;
			frm.submit();
			return true;
		}else{
			return false;
		}
	}
	
	function showTr(id){
		var elemento = document.getElementById("tr" + id);
		if(elemento.style.display == ''){
			elemento.style.display = 'none';
		}else{
			elemento.style.display = '';
		}
	}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 