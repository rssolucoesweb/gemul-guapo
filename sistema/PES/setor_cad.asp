<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<style>
.margin-bottom-30 {
    margin-left: 30px;
}
.pointer {cursor: pointer;}
.tamanho7 { font-size: 9px; }
</style>
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">PES - Sistema de Pesquisas</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
    acao = "I"
	strExecutarSubmitEstado						= "S"
	strPaginaTitulo                  			= "setor_cad.asp"
	strPagina						 			= "setor_cad.asp"

	intCodigo           	  					= Trim(Request.Form("txtCodigo"))
	nome										= Trim(Request.form("nome"))
	cod_estado									= Trim(Request.form("cmbEstado"))
	cod_cidade									= Trim(Request.form("cmbCidade"))
	situacao									= Trim(Request.form("cmbSituacao"))
	limite										= Trim(Request.form("limite"))
	
	
	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	
	if trim(intCodigo) <> "" then
		sql = "SELECT s.*, c.cod_estado"
		sql = sql & " FROM PES_setor s inner join PES_cidade c on c.codigo = s.cod_cidade"
		sql = sql & " where s.codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			nome			= rs("nome")
			situacao		= rs("situacao")
			cod_estado		= rs("cod_estado")
			cod_cidade		= rs("cod_cidade")
			limite		= rs("limite_entrevistas")
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir

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
        <div class="row">
            <!-- Begin Content -->
            <div class="col-md-12" >     

       		<!-- Inicia o Painel do Formulario -->   

					<form id="frm" method="post" action="setor_cad.asp"  class="sky-form panel-body0">
					<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
                    <div style="background:#95a5a6;height:40px;padding-top: 8px;" class="panel-title">&nbsp;&nbsp;<font color="#FFFFFF"><i class="fa fa-tasks"></i>&nbsp;Cadastro de Setor</font></div>

                    <fieldset>
                        
                       	<div class="row">
							<section class="col col-6">
                                <label class="form-label">Nome</label>
                              
                                <label class="input">
                                    <input name="nome" type="text" class="form-control" id="nome" size="50" maxlength="50" value="<%=nome%>">
                                </label>
                             </section>
							 
						</div>
						
						<div class="row">
							<section class="col col-4">
                                <label class="form-label">Estado</label>
                              
                                <label class="input">
                                    <!--#include file="../includes/inc_cmbEstado.asp" -->
                                </label>
                             </section>
							 
						
							<section class="col col-4">
                                <label class="form-label">Cidade</label>
                              
                                <label class="input">
                                    <!--#include file="../includes/inc_cmbCidade.asp" -->
                                </label>
                             </section>
							 
						</div>
						<div class="row">
							<section class="col col-4">
                                <label class="form-label">Limite de entrevistas por setor</label>
                              
                                <label class="input">
                                    <input name="limite" style="width: 50px;" type="text" class="form-control" id="limite" onkeypress="return formataCampo(this, 2, 5)" size="5" maxlength="5" value="<%=limite%>">
                                </label>
                            </section>
						</div>
						<div class="row">
							<section class="col col-4">
								<label class="form-label">Situação</label>
							  
								<label class="input">
									<!--#include file="../includes/inc_cmbSituacaoAtivoInativo.asp" -->
								</label>
								
							</section>
							 
						</div>
                       
						</fieldset><fieldset>
					 
					</fieldset>
					 
					<div class="margin-left-60">
	                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
					</div>
                    
				<%
					sql = "select s.codigo, s.nome, c.nome as cidade, e.nome as estado, s.situacao, s.usuario_altr, s.data_hora_altr"
					sql = sql & " from PES_setor s "
					sql = sql & " inner join PES_cidade c on c.codigo = s.cod_cidade"
					sql = sql & " inner join PES_estado e on e.codigo = c.cod_estado"
					sql = sql & " order by s.situacao, e.nome, c.nome, s.nome"
                    RS.OPEN SQL, CNN
                    IF NOT RS.EOF THEN
                    %> 
                  <div class="panel panel-grey">
                        <div class="panel-heading">
                            <h3 class="panel-title"><i class="fa fa-tasks"></i> Setores cadastrados</strong>
                            </h3>
                        </div>
                        <div class="panel-body">
                        <table class="table table-bordered" >
                            <thead>
								<tr  bgcolor="#E2E2E2">
									<th width="2%" align="center">Código</th>
                                    <th width="30%"  align="center">Nome</th>
									<th width="30%"  align="center">Cidade | Estado</th>
                                    <th width="15%" align="center"><strong>Usuário</strong></td>
                                    <th width="20%" align="center"><strong>Data</strong></td>
									<th width="10%" align="center"><strong>Situação</strong></td>
                                </tr>
                            </thead>
                            <%
                            cont = 0
                            while not rs.eof
								cont = cont + 1	
								strCorlinha = "FFFFFF"
								if trim(rs("situacao")) = "A" then
									strSituacao = "Ativo"
								elseif trim(rs("situacao")) = "I" then
									strSituacao = "Inativo"
									strCorlinha = "F5A9A9"
								else
									strSituacao = "Não informada"
									strCorlinha = "F3E2A9"
								end if
                                %>
                                <tr  onclick="return resultadoConsulta('<%=rs("CODIGO")%>')" class="pointer" bgcolor="#<%=strCorlinha%>" onmouseover="return linhaMouseOver(this)" onmouseout="return linhaMouseOut(this)">
                                  	<td><%=rs("codigo")%></td>
									<td><%=RS("nome")%></td>
									<td><%=RS("cidade")%> | <%=RS("estado")%></td>
                                    <td><%=RS("usuario_altr")%></td>
									<td><%=RS("data_hora_altr")%></td>
									<td><%=strSituacao%></td>
                                </tr>
                                <%				
                                    rs.movenext
                                wend
                            %>
                        </table>
                      </div>
				</div>
                    <%
                    RS.CLOSE
                END IF
            %> 
			</div>
			</form>
         	<!-- Fecha o Form -->  
      </div>

        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
      
   	   
	<script>
   
	function resultadoConsulta(intCodigo){
	
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.action = "setor_cad.asp";
		frm.submit();
	}
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (acao=="E"){
			frm.action="setor_cod.asp?acao=" + acao;
			frm.submit();
			return true;
		}
		else
		{
			if (frm.nome.value == "") {
				alert("O nome deve ser informado!");
				frm.nome.focus();
				return false;
			}
			if (frm.cmbEstado.value == "0") {
				alert("O estado deve ser selecionado!");
				frm.cmbEstado.focus();
				return false;
			}
			if (frm.cmbCidade.value == "0") {
				alert("A cidade deve ser selecionada!");
				frm.cmbCidade.focus();
				return false;
			}
			
			if (frm.cmbSituacao.value == "0") {
				alert("A situação deve ser informada!");
				frm.cmbSituacao.focus();
				return false;
			}
	
			frm.action="setor_cod.asp?acao=" + acao;
			frm.submit();
			return true;
		}
 	}
	
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 