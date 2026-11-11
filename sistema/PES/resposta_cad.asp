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
	strExecutarSubmitResposta					= "S"
	strBotaoPerguntas = "S"
	strPaginaTitulo                  			= "resposta_cad.asp"
	strPagina						 			= "resposta_cad.asp"
	strDesabilitaLimpar							= "disabled" 
				
	intCodigo           	  					= Trim(Request("txtCodigo"))
	
	cod_pergunta           	  					= Trim(Request("cod_pergunta"))
	cod_cidade           	  					= Trim(Request("cod_cidade"))
	cod_pesquisa           	  					= Trim(Request("cod_pesquisa"))
	
	nome										= Trim(Request.form("nome"))
	cod_tipo_resposta							= Trim(Request.form("cmbCandidato"))
	tipo										= Trim(Request.form("cmbTipo"))
	desc_tipo = ""
	if tipo = "" then tipo = "CANDIDATO"
	if tipo = "CANDIDATO" then desc_tipo = "Candidato"
	if tipo = "OUTRAS" then desc_tipo = "Outras Respostas"

	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	if trim(cod_pesquisa) <> "" then
		sql = "SELECT p.CODIGO, p.NOME, c.nome as cidade, e.nome as estado, p.cod_cidade"
		sql = sql & " FROM PES_PESQUISA p "
		sql = sql & " left join PES_cidade c on c.Codigo = p.cod_cidade"
		sql = sql & " left join PES_estado e on e.Codigo = c.cod_estado"
		sql = sql & " where p.codigo = " & cod_pesquisa
		rs.open sql, cnn
		
		if rs.eof = false then
			
			pesquisa	= rs("nome") & " | " & rs("cidade") & "-" & rs("estado")
			cod_cidade	= rs("cod_cidade")

			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir

		end if 
		rs.close
	end if
	if trim(cod_pergunta) <> "" then
		sql = "SELECT nome"
		sql = sql & " FROM PES_pergunta"
		sql = sql & " where codigo = " & cod_pergunta
		rs.open sql, cnn
		
		if rs.eof = false then
			
			pergunta	= rs("nome")

			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir

		end if 
		rs.close
	end if
	
	if trim(intCodigo) <> "" then
		sql = "SELECT r.nome, r.cod_tipo_resposta, tr.tipo"
		sql = sql & " FROM PES_resposta r inner join PES_tipo_resposta tr on tr.codigo = r.cod_tipo_resposta"
		sql = sql & " where r.cod_tipo_resposta<>1 and r.codigo = " & intCodigo
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
					<input name="cod_cidade" type="hidden" id="cod_cidade" value="<%=cod_cidade%>">
					<input name="cod_pesquisa" type="hidden" id="cod_pesquisa" value="<%=cod_pesquisa%>">
					<input name="cmbPesquisa" type="hidden" id="cmbPesquisa" value="<%=cod_pesquisa%>">
                    <div style="background:#95a5a6;height:40px;padding-top: 8px;" class="panel-title">&nbsp;&nbsp;<font color="#FFFFFF"><i class="fa fa-tasks"></i>&nbsp;Cadastro de resposta</font></div>

                    <fieldset>
						<div class="row">
							<section class="col col-12">
                                <label class="form-label">Pesquisa</label>
                              
                                <label class="input">
                                    <h3><%=pesquisa%></h3>
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
							<section class="col col-12">
                                <label class="form-label">Tipo de resposta</label>
                              
                                <label class="input">
                                  
									<select name="cmbTipo" id="cmbTipo" class="form-control" onchange="submit()">
										<option value="CANDIDATO" <%IF tipo="CANDIDATO" then response.write "selected"%>>CANDIDATO</option>
										<option value="OUTRAS" <%IF tipo="OUTRAS" then response.write "selected"%>>RESPOSTAS</option>
										<option value="TEXTO" <%IF tipo="TEXTO" then response.write "selected"%>>EXPONTÂNEA</option>
									</select>
									
                                </label>
                             </section>
						</div>
						<%IF tipo<>"TEXTO" then%>
						<div class="row">
							<section class="col col-5">
                                <label class="form-label"><%=desc_tipo%></label>
                              
                                <label class="input">
                                    <!--#include file="../includes/inc_cmbTipoResposta.asp" -->
                                </label>
                             </section>
						</div>
						<%END IF%>
						</fieldset><fieldset>
					 
					</fieldset>
					 
					<div class="margin-left-60">
	                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
					</div>
                    
				<%
				if cod_pergunta<>"0" then
					sql = "select s.codigo, s.nome, p.nome as pergunta, s.usuario_altr, s.data_hora_altr"
					sql = sql & " from PES_resposta s "
					sql = sql & " inner join PES_pergunta p on p.codigo = s.cod_pergunta"
					sql = sql & " where s.cod_pergunta = " & cod_pergunta
					sql = sql & " order by s.codigo"
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
											<th width="2%" align="center">Cód.</th>
											<th width="30%"  align="center">Resposta</th>
											<th width="15%" align="center"><strong>Usuário</strong></td>
											<th width="15%" align="center"><strong>Data</strong></td>
										</tr>
									</thead>
									<%
									cont = 0
									while not rs.eof
										cont = cont + 1	
										%>
										<tr  onclick="return resultadoConsulta('<%=rs("CODIGO")%>')" class="pointer" onmouseover="return linhaMouseOver(this)" onmouseout="return linhaMouseOut(this)">
											<td><%=rs("codigo")%></td>
											<td><%=RS("nome")%></td>
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
			</form>
         	<!-- Fecha o Form -->  
      </div>

        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
      
   	   
	<script>
   
	function perguntas(cod_pesquisa){
	
		var frm = document.getElementById("frm");
		frm.cmbPesquisa.value=cod_pesquisa;
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
			if (frm.cmbTipo.value != "TEXTO"){
				if (frm.cmbTipoResposta.value == "0") {
					alert("A resposta deve ser selecionada!");
					frm.cmbTipoResposta.focus();
					return false;
				}
			}
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