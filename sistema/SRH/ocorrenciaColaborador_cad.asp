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
            <h1 class="pull-left">SRH - Recurso Humano</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
    acao = "I"

	strPaginaTitulo                  			= "ocorrenciaColaborador_cad.asp"
	strPagina						 			= "ocorrenciaColaborador_cad.asp"
	strExecutarSubmitModulacaoReferencia        = "S"


	intCodigo           	  					= Trim(Request.Form("txtCodigo"))
	intCodModulacaoReferencia 					= Trim(Request("cmbModulacaoReferencia"))
	strOcorrencia								= Trim(Request.form("txtOcorrencia"))
	intCodColaborador         	 				= Trim(Request("cmbColaborador")) 

	if intCodModulacaoReferencia <> "" and intCodModulacaoReferencia <> "0" then

		sql = "select AnoReferencia, SemestreReferencia from SRH_MODULACAO_REFERENCIA WHERE CODIGO = " & intCodModulacaoReferencia
		rs.open sql, cnn
		if rs.eof = false then
			strAnoLetivoReferencia  = rs("AnoReferencia")
			intSemestreReferencia 	= rs("SemestreReferencia")
		end if
		rs.close
		
	end if
	
	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	
	if trim(intCodigo) <> "" then
		sql = "SELECT *"
		sql = sql & " FROM SRH_COLABORADOR_OCORRENCIA_FOLHA"
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
		sql = sql & " and codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodColaborador			= rs("cod_colaborador")
			strOcorrencia				= rs("ocorrencia")
			intCodModulacaoReferencia	= rs("cod_referencia")
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
	
	intSemestre = intSemestreReferencia
    %>
<!--=== Content Part ===-->
    <div class="container content">
        <div class="row">
            <!-- Begin Content -->
            <div class="col-md-12" >     

       		<!-- Inicia o Painel do Formulario -->   

					<form id="frm" method="post" action="ocorrenciaColaborador_cad.asp"  class="sky-form panel-body0">
					<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
                    <div style="background:#95a5a6;height:40px;padding-top: 8px;" class="panel-title">&nbsp;&nbsp;<font color="#FFFFFF"><i class="fa fa-tasks"></i>&nbsp;Lançamento de Ocorrência do Colaborador</font></div>

                    <fieldset>
                        
						<div class="row">
                             <section class="col col-6">
                                <label class="form-label">Refer&ecirc;ncia:</label>
                              
                                <label class="input">
                                     <!--#include file="../includes/inc_PeriodoModulacao.asp" -->
									- De: <%=formataDataAP(strDataInicialModulacao)%> a <%=formataDataAP(strDataFinalModulacao)%>
                                </label>
                             </section>
                        </div>
                       
							 
						 <div class="row">
							
							 
							 <section class="col col-6">
								<label class="form-label">Colaborador</label>
							  
								<label class="input">
									 <!--#include file="../includes/inc_cmdColaboradorOcorrencia.asp" -->
								</label>
							 </section>
						</div>
						
                        <div class="row">
							
							 
							 <section class="col col-6">
								<label class="form-label">Ocorrrência</label>
							  
								<label class="input">
										<textarea  onkeyup="blocTexto(this.value,'<%=cont%>')"  name="txtOcorrencia" cols="70" rows="4" class="text" id="txtOcorrencia"><%=strOcorrencia%></textarea>
										 <br /><font color="#FF0000">(caracteres restantes: <span id="cont">500</span>)</font></span>
								</label>
							 </section>
						</div>
						
						</fieldset><fieldset>
					 
					 </fieldset>
					 
					<div class="margin-left-60">
	                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
					</div>
                    
				<%
				if intCodModulacaoReferencia <> "" then
					sql = "select f.codigo, c.nome, c.codFuncional, left(f.ocorrencia,200) as ocorrencia, f.usuario_altr as usuario_alteracao, f.data_altr as data_alteracao"
					sql=sql & " from SRH_COLABORADOR_OCORRENCIA_FOLHA f"
					sql=sql & " inner join SRH_COLABORADOR c on c.codigo = f.cod_colaborador"
					sql=sql & " where f.cod_empresa = " & session("codEmpresa")
					sql=sql & " and f.cod_referencia = " & intCodModulacaoReferencia
					sql=sql & " order by c.nome"
                    RS.OPEN SQL, CNN
                    IF NOT RS.EOF THEN
                    %> 
                  <div class="panel panel-grey">
                        <div class="panel-heading">
                            <h3 class="panel-title"><i class="fa fa-tasks"></i> Ocorrências</strong>
                            </h3>
                        </div>
                        <div class="panel-body">
                        <table class="table table-bordered" >
                            <thead>
								<tr  bgcolor="#E2E2E2">
									<th width="1%" align="center">Cod.</th>
									<th width="25%" align="center">Colaborador</th>
                                    <th width="2%"  align="center">Matrícula</th>
									<th width="45%"  align="center"><strong>Ocorrência</strong></td>
                                    <th width="12%" align="center"><strong>Usuário</strong></td>
                                    <th width="16%" align="center"><strong>Data/Hora</strong></td>
                                </tr>
                            </thead>
                            <%
                            
                            Total_Aulas = 0
                            while not rs.eof
								cont = cont + 1	
								
                                %>
                                <tr class="pointer" onmouseover="return linhaMouseOver(this)" onmouseout="return linhaMouseOut(this)" onclick="return resultadoConsulta('<%=rs("CODIGO")%>')">
                                  	<td><%=rs("codigo")%></td>
									<td><%=RS("nome")%></td>
                                    <td><%=RS("codfuncional")%></td>
                                    <td><i class="tamanho7"><%=rs("ocorrencia")%></i></td>
                                    <td><%=RS("usuario_alteracao")%></td>
                                    <td><%=RS("data_alteracao")%></td>
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
   
	function resultadoConsulta(intCodigo){
	
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.action = "ocorrenciaColaborador_cad.asp";
		frm.submit();
	}
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (acao=="E"){
			frm.action="ocorrenciaColaborador_cod.asp?acao=" + acao;
			frm.submit();
			return true;
		}
		else
		{
			if (frm.cmbModulacaoReferencia.value == "0") {
				alert("A Referência deve ser informada!");
				frm.cmbModulacaoReferencia.focus();
				return false;
			}
	
			
			if (frm.cmbColaborador.value == "0" && acao!="E" ) {
				alert("O colaborador deverá ser informado.");
				frm.cmbColaborador.focus();
				return false;
			}
	
			frm.action="ocorrenciaColaborador_cod.asp?acao=" + acao;
			frm.submit();
			return true;
		}
 	}
	
	
		function blocTexto(valor, id)
        {
            quant = 500;
            total = valor.length;
            if(total <= quant)
            {
                resto = quant - total;
                document.getElementById('cont').innerHTML = resto;
            }
            else
            {
                document.getElementById('txtResposta_'+id).value = valor.substr(0,quant);
            }
        }  
    
	
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 