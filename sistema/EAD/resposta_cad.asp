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
	strExecutarSubmitResposta					= "S"
	strBotaoPerguntas = "S"
	strPaginaTitulo                  			= "resposta_cad.asp"
	strPagina						 			= "resposta_cad.asp"
	strDesabilitaLimpar							= "disabled" 
				
	intCodigo           	  					= Trim(Request("txtCodigo"))
	
	cod_pergunta           	  					= Trim(Request("cod_pergunta"))
	cod_questionario       	  					= Trim(Request("cod_questionario"))
	
	nome										= Trim(Request.form("nome"))
	tipo										= Trim(Request.form("cmbTipo"))
	desc_tipo = ""
	if tipo = "" then tipo = "TEXTO"
	if tipo = "MUTIPLA" then desc_tipo = "Múltipla Escolha"
	if tipo = "TEXTO" then desc_tipo = "Resposta Curta"

	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	
	
	if trim(cod_Questionario) <> "" then
		sql = "SELECT p.CODIGO, p.NOME, P.limite_resposta"
		sql = sql & " FROM ead_Questionario p "
		sql = sql & " where p.codigo = " & cod_questionario
		rs.open sql, cnn
		
		if rs.eof = false then
			
			Questionario	= rs("nome")
			limite_resposta= rs("limite_resposta")

		end if 
		rs.close
	end if
	
	if trim(cod_pergunta) <> "" then
		sql = "SELECT nome"
		sql = sql & " FROM EAD_pergunta"
		sql = sql & " where codigo = " & cod_pergunta
		rs.open sql, cnn
		
		if rs.eof = false then
			
			pergunta	= rs("nome")

		end if 
		rs.close
	end if
	
	if trim(intCodigo) <> "" then
		sql = "SELECT r.nome, r.cod_tipo_resposta, tr.tipo"
		sql = sql & " FROM EAD_resposta r inner join EAD_tipo_resposta tr on tr.codigo = r.cod_tipo_resposta"
		sql = sql & " where r.codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			nome			= rs("nome")
			tipo			= rs("tipo")
			cod_tipo_resposta	= rs("cod_tipo_resposta")

			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
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

				<form id="frm" method="post" action="resposta_cad.asp"  class="sky-form panel-body0">
					<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
					<input name="cod_pergunta" type="hidden" id="cod_pergunta" value="<%=cod_pergunta%>">
					<input name="cod_questionario" type="hidden" id="cod_questionario" value="<%=cod_questionario%>">
					<input name="cmbQuestionario" type="hidden" id="cmbQuestionario" value="<%=cod_Questionario%>">
                    <div style="background:#95a5a6;height:40px;padding-top: 8px;" class="panel-title">&nbsp;&nbsp;<font color="#FFFFFF"><i class="fa fa-tasks"></i>&nbsp;Cadastro de resposta</font></div>

                    <fieldset>
						<div class="row">
							<section class="col col-12">
                                <label class="form-label">Questionario</label>
                              
                                <label class="input">
                                    <h3><%=Questionario%></h3>
                                </label>
                             </section>
						</div>
                       	<div class="row">
							<section class="col col-12">
                                <label class="form-label">Pergunta</label>
                              
                                <label class="input">
                                    <h3><%=pergunta%></h3>
                                </label>
                             </section>
						</div>
						<div class="row">
							<section class="col col-6">
                                <label class="form-label">Tipo de resposta</label>
                              
                                <label class="input">
                                  
									<select name="cmbTipo" id="cmbTipo" class="form-control" onchange="submit()">
										<option value="TEXTO" <%IF tipo="TEXTO" then response.write "selected"%>>Discursivas</option>
										<option value="MUTIPLA" <%IF tipo="MUTIPLA" then response.write "selected"%>>Objetivas </option>
									</select>
									
                                </label>
                             </section>
							 <%IF tipo="TEXTO" and strDesabilitaIncluir = "" then%>
							 <section class="col col-2">
                                <label class="form-label">Ordem</label>
                              
                                <label class="input">
                                    <input name="ordem" type="text" class="form-control" id="ordem" size="2" maxlength="2" value="<%=ordem%>">
                                </label>
                             </section>
							 <%end if%>
						</div>
						<%IF tipo<>"TEXTO" and strDesabilitaIncluir = "" then%>
							<%
							if limite_resposta = "" then limite_resposta = 10
							%>
							<% FOR I=1 TO limite_resposta%>
							<div class="row">
								<section class="col col-5">
									<label class="form-label">Opção <%=I%></label>
								  
									<label class="input">
										<input name="opcao_<%=I%>" type="text" class="form-control" id="opcao_<%=I%>" size="150" maxlength="150" value="">
									</label>
								 </section>
								 <section class="col col-2">
									<label class="form-label">Correta</label>
								  
									<label class="input">
										<select name="cmbCorreta_<%=I%>" id="cmbCorreta_<%=I%>" class="form-control">
											<option value="N">Não</option>
											<option value="S">Sim</option>
										</select>
									</label>
								 </section>
							</div>
							<%NEXT%>
						<%END IF%>
						</fieldset><fieldset>
					 
					</fieldset>
					 
					<div class="margin-left-60">
	                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
					</div>
                    
				<%
				if cod_pergunta<>"0" then
					sql = "select s.ordem, s.codigo, s.cod_tipo_resposta, s.nome, p.nome as pergunta, s.usuario_altr, s.data_hora_altr, s.correta"
					sql = sql & " from EAD_resposta s "
					sql = sql & " inner join EAD_pergunta p on p.codigo = s.cod_pergunta"
					sql = sql & " where s.cod_pergunta = " & cod_pergunta
					sql = sql & " order by s.ordem, s.codigo"
                    RS.OPEN SQL, CNN
                    IF NOT RS.EOF THEN
						descricao_pergunta = rs("pergunta")
                    %> 
						<div class="panel panel-grey">
							<div class="panel-heading">
								<h3 class="panel-title"><i class="fa fa-tasks"></i> Resposta cadastradas para pergunta: <strong><%=descricao_pergunta%></strong>
								</h3>
							</div>
							<div class="panel-body">
								<table class="table table-bordered" >
									<thead>
										<tr  bgcolor="#E2E2E2">
											<th width="2%" align="center">Ordem</th>
											<th width="30%"  align="center">Resposta</th>
											<th width="5%"  align="center">Correta</th>
											<th width="15%" align="center"><strong>Usuário</strong></td>
											<th width="15%" align="center"><strong>Data</strong></td>
										</tr>
									</thead>
									<%
									cont = 0
									while not rs.eof
										cont = cont + 1	
										correta = ""
										if rs("correta") ="N" then correta = "Não"
										if rs("correta") ="S" then correta = "<strong>Sim</strong>"
										
										if rs("cod_tipo_resposta") ="1" then correta = "  "
										
										%>
										<tr  onclick="return resultadoConsulta('<%=rs("CODIGO")%>')" class="pointer" onmouseover="return linhaMouseOver(this)" onmouseout="return linhaMouseOut(this)">
											<td><%=rs("ordem")%></td>
											<td><%=RS("nome")%></td>
											<td><%=correta%></td>
											<td><%=RS("usuario_altr")%></td>
											<td><%=RS("data_hora_altr")%></td>
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
				<input name="limite_resposta" type="hidden" id="limite_resposta" value="<%=limite_resposta%>">
			</form>
         	<!-- Fecha o Form -->  
      </div>

        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
      
   	   
	<script>
   
	function perguntas(cod_questionario){
	
		var frm = document.getElementById("frm");
		frm.cmbQuestionario.value=cod_questionario;
		frm.action = "pergunta_cad.asp";
		frm.submit();
	}
	function resultadoConsulta(intCodigo){
	
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.action = "resposta_cad.asp";
		frm.submit();
	}
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (acao=="E"){
			frm.action="resposta_cod.asp?acao=" + acao;
			frm.submit();
			return true;
		}
		else
		{
			frm.action="resposta_cod.asp?acao=" + acao;
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