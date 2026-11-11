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

.btnResposta {
    background: #5fb611;
	color: aliceblue;
	}
</style>
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">EAD - Sistema de Educação a Distância</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
    acao = "I"
	strExecutarSubmitQuestionario					= "S"
	strPaginaTitulo                  			= "pergunta_cad.asp"
	strPagina						 			= "pergunta_cad.asp"

	intCodigo           	  					= Trim(Request("txtCodigo"))
	nome										= Trim(Request.form("nome"))
	cod_questionario								= Trim(Request.form("cmbQuestionario"))
	if cod_questionario = "" then cod_questionario = "0"

	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	
	if trim(intCodigo) <> "" then
		sql = "SELECT nome, ordem, cod_questionario"
		sql = sql & " FROM EAD_pergunta"
		sql = sql & " where codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			ordem			= rs("ordem")
			nome			= rs("nome")
			cod_questionario	= rs("cod_questionario")

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

				<form id="frm" method="post" action="pergunta_cad.asp"  class="sky-form panel-body0">
					<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
                    <div style="background:#95a5a6;height:40px;padding-top: 8px;" class="panel-title">&nbsp;&nbsp;<font color="#FFFFFF"><i class="fa fa-tasks"></i>&nbsp;Cadastro de pergunta</font></div>

                    <fieldset>
                       	<div class="row">
							<section class="col col-4">
                                <label class="form-label">Questionário</label>
                              
                                <label class="input">
                                    <!--#include file="../includes/inc_cmbQuestionario.asp" -->
                                </label>
                             </section>
						</div>
						<div class="row">
							<section class="col col-10">
                                <label class="form-label">Nome da pergunta</label>
                              
                                <label class="input">
                                    <input name="nome" type="text" class="form-control" id="nome" size="150" maxlength="150" value="<%=nome%>">
                                </label>
                             </section>
							 <section class="col col-2">
                                <label class="form-label">Ordem</label>
                              
                                <label class="input">
                                    <input name="ordem" type="text" class="form-control" id="ordem" size="2" maxlength="2" value="<%=ordem%>">
                                </label>
                             </section>
						</div>
						
						</fieldset><fieldset>
					 
					</fieldset>
					 
					<div class="margin-left-60">
	                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
					</div>
                    
				<%
				if cod_questionario<>"0" then
					sql = "select s.ordem, s.codigo, s.nome, p.nome as questionario, s.usuario_altr, s.data_hora_altr, s.cod_questionario"
					sql = sql & " from EAD_pergunta s "
					sql = sql & " inner join EAD_questionario p on p.codigo = s.cod_questionario"
					sql = sql & " where s.cod_questionario = " & cod_questionario
					sql = sql & " order by s.ordem, s.codigo"
                    RS.OPEN SQL, CNN
                    IF NOT RS.EOF THEN
						descricao_questionario = rs("questionario")
                    %> 
						<div class="panel panel-grey">
							<div class="panel-heading">
								<h3 class="panel-title"><i class="fa fa-tasks"></i> Perguntas cadastradas</strong>
								</h3>
							</div>
							<div class="panel-body">
								<table class="table table-bordered" >
									<thead>
										<tr  bgcolor="#E2E2E2">
											<th width="2%" align="center">Ordem</th>
											<th width="30%"  align="center">Pergunta</th>
											<th width="15%" align="center"><strong>Usuário</strong></td>
											<th width="15%" align="center"><strong>Data</strong></td>
											<th width="5%" align="center"><strong>Ação</strong></td>
										</tr>
									</thead>
									<%
									cont = 0
									while not rs.eof
										cont = cont + 1	
										%>
										<tr class="pointer" onmouseover="return linhaMouseOver(this)" onmouseout="return linhaMouseOut(this)">
											<td onclick="return resultadoConsulta('<%=rs("CODIGO")%>')" ><%=rs("ordem")%></td>
											<td onclick="return resultadoConsulta('<%=rs("CODIGO")%>')" ><%=RS("nome")%></td>
											<td><%=RS("usuario_altr")%></td>
											<td><%=RS("data_hora_altr")%></td>
											<td onclick="return cadastrarRespostas('<%=rs("cod_questionario")%>','<%=rs("codigo")%>')"><button class="btn u-btn-primary btnResposta" type="button" role="button"><i class="fa fa-tasks"></i> Respostas</button></td>
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
				end if
				%> 
				</div>
				<input name="cod_pergunta" type="hidden" id="cod_pergunta">
				<input name="cod_questionario" type="hidden" id="cod_questionario">
			</form>
         	<!-- Fecha o Form -->  
      </div>

        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
      
   	   
	<script>
   
	function cadastrarRespostas(cod_questionario, cod_pergunta){
	
		var frm = document.getElementById("frm");
		frm.cod_pergunta.value=cod_pergunta;
		frm.cod_questionario.value=cod_questionario;
		frm.action = "resposta_cad.asp";
		frm.submit();
	}
	function resultadoConsulta(intCodigo){
	
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.action = "pergunta_cad.asp";
		frm.submit();
	}
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (acao=="E"){
			frm.action="pergunta_cod.asp?acao=" + acao;
			frm.submit();
			return true;
		}
		else
		{
			if (frm.cmbQuestionario.value == "0") {
				alert("O Questionário deve ser selecionado!");
				frm.cmbQuestionario.focus();
				return false;
			}
			if (frm.nome.value == "") {
				alert("O nome deve ser informado!");
				frm.nome.focus();
				return false;
			}
			
			frm.action="pergunta_cod.asp?acao=" + acao;
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