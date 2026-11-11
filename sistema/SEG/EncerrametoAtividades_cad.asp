<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
    <!--#include file="../../includes/inc_formatadata.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--=== Breadcrumbs ===-->
    <script>
    	alert("ATENÇÃO: \nEssa aplicação tem a função de ALTERAR o  ANO e o SEMESTRE letivo,\n o seu uso indevido poderá causar INCONSISTÊNCIA em suas informações.");
    </script>
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Seguran&ccedil;a</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
    <%
		strPaginaTitulo 					= "EncerrametoAtividades_cad.asp"
		intCodigo	 						= Trim(Request.Form("txtCodigo"))
		intAno								= Trim(Request.Form("txtAno"))
		intSemestre							= Trim(Request.Form("cmbSemestre"))
		strDataEncerramento					= Trim(Request.Form("txtDataEncerramento"))
		strSimouNaoDocente					= Trim(Request.Form("cmbSimouNaoDocente"))
		intCodAvaliacaoAgrupamento			= Trim(Request.Form("cmbTipoAvaliacaoAgrupamento"))
		strSimouNaoSecretaria    			= Trim(Request.Form("cmbSimouNaoSecretaria"))
		strSimouNaoCampoAcumuladaFalta 		= Trim(Request.Form("cmbSimouNaoCampoAcumuladaFalta"))
		strSimouNaoDocumentacaoColaboradores= Trim(Request.Form("cmbSimouNaoDocumentacaoColaboradores"))
		strSimouNaoHabilitaPlanoEnsino      = Trim(Request.Form("cmbSimouNaoHabilitaPlanoEnsino"))
		strSimouNaoPreMatricula      		= Trim(Request.Form("cmbSimouNaoPreMatricula"))
		strCriarGradeChecandoHistorico 		= Trim(Request.Form("cmbCriarGradeChecandoHistorico"))
	
	
		strNotificacao1						= Trim(Request.Form("txtNotificacao1"))
		strNotificacao2						= Trim(Request.Form("txtNotificacao2"))
		strMes								= Trim(Request("cmbMes"))
		if strMes = "0" then strMes = month(date) 
			
		if trim(intCodigo) <> "" then
		
			sql = "SELECT Codigo, cod_empresa, ano_letivo, semestre, data_encerramento, Bloqueia_NotasDocente, Permitir_AlteracaoNotaDocente, Bloqueia_NotasSecretaria, Bloqueia_CampoAcumuladaFalta, Bloqueia_ConteudoProgramatico, Habilitar_PlanoEnsino, Habilitar_PreMatricula, DocumentacaoColaboradores, notificacao1, notificacao2"
			sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES"
			sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
			sql = sql & " and codigo = " & intCodigo
			rs.open sql, cnn
			
			if rs.eof = false then
				
				intCodigo							= rs("Codigo")
				intAno								= rs("ano_letivo")
				intSemestre							= rs("semestre")
				strDataEncerramento					= formataDataAP(rs("data_encerramento"))
				strSimouNaoDocente					= rs("Bloqueia_NotasDocente")
				intCodAvaliacaoAgrupamento			= rs("Permitir_AlteracaoNotaDocente")
				
				strSimouNaoSecretaria				= rs("Bloqueia_NotasSecretaria")
				strSimouNaoCampoAcumuladaFalta		= rs("Bloqueia_CampoAcumuladaFalta")
				strSimouNaoHabilitaPlanoEnsino      = rs("Habilitar_PlanoEnsino")
				strSimouNaoPreMatricula     		= rs("Habilitar_PreMatricula")
				strSimouNaoDocumentacaoColaboradores= rs("DocumentacaoColaboradores")
				strNotificacao1						= rs("Notificacao1")
				strNotificacao2						= rs("Notificacao2")
				strMes								= rs("Bloqueia_ConteudoProgramatico")
				if isnull(strMes) then strMes = "0"
				
				
				strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
				strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
				strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	
			end if 
			rs.close
		else
			if session("nivelpermissao")= "A" then
			   strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			else   
			   strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			end if   
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		end if 
	%>
     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Encerramento das Atividades</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
                    
                    <div class="headline"><h2>Fechamento do semestre ou ano letivo</h2></div>
                    
                    <div class="form-group">
                        <label class="form-label">Ano</label>
                         <input name="txtAno" type="text" class="form-control" id="txtAno" style="width:50pt" value="<%=intAno%>" size="80" maxlength="100">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Semestre</label>
                         <!--#include file="../includes/inc_cmdSemestreTodos.asp" -->
                    </div>
                   
                    <div class="form-group">
                        <label class="form-label">Data de Encerramento</label>
                          <input name="txtDataEncerramento" type="text" class="form-control" id="txtDataEncerramento" style="width:100pt" value="<%=strDataEncerramento%>" size="80" maxlength="15">
                    </div>
                    
                    <div class="headline"><h2>Controlando Atividades</h2></div>
                    
                     <div class="form-group">
                        <label class="form-label">Bloquear Lancto Notas Docentes?</label>
                          <select name="cmbSimouNaoDocente" class="form-control" id="cmbSimouNaoDocente"  style="width:100pt" onchange='' >
                          <option value="0">Selecione...</option>
                          <option value="S" <%if strSimouNaoDocente = "S" then response.Write("selected") %>>SIM</option>
                          <option value="N" <%if strSimouNaoDocente = "N" then response.Write("selected") %>>NAO</option>
                        </select>
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Permitir altera&ccedil;&atilde;o Notas ao Docentes?</label>
                          <!--#include file="../includes/inc_cmdTipoAvaliacaoAgrupamentoDigitacao.asp" -->
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Bloquear Lancto Notas Secretaria?</label>
                          <select name="cmbSimouNaoSecretaria" class="form-control" id="cmbSimouNaoSecretaria"  style="width:100pt" onchange='' >
                          <option value="0">Selecione...</option>
                          <option value="S" <%if strSimouNaoSecretaria = "S" then response.Write("selected") %>>SIM</option>
                          <option value="N" <%if strSimouNaoSecretaria = "N" then response.Write("selected") %>>NAO</option>
                        </select>
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label"> Bloquear Campo Acumulada de Faltas?</label>
                          <select name="cmbSimouNaoCampoAcumuladaFalta" class="form-control" id="cmbSimouNaoCampoAcumuladaFalta"  style="width:100pt" onChange='' >
                          <option value="0">Selecione...</option>
                          <option value="S" <%if strSimouNaoCampoAcumuladaFalta = "S" then response.Write("selected") %>>SIM</option>
                          <option value="N" <%if strSimouNaoCampoAcumuladaFalta = "N" then response.Write("selected") %>>NAO</option>
                          </select>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Bloquear Conte&uacute;do Program&aacute;tico at&eacute; o m&ecirc;s:</label>
                          <!--#include file="../includes/inc_cmbMesConteudo.asp"-->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Habilitar Plano de Ensino?</label>
                          <select name="cmbSimouNaoHabilitaPlanoEnsino" class="form-control" id="cmbSimouNaoHabilitaPlanoEnsino"  style="width:100pt" onChange='' >
                          <option value="0">Selecione...</option>
                          <option value="S" <%if strSimouNaoHabilitaPlanoEnsino = "S" then response.Write("selected") %>>SIM</option>
                          <option value="N" <%if strSimouNaoHabilitaPlanoEnsino = "N" then response.Write("selected") %>>NAO</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Habilitar Pr&eacute;-Matr&iacute;cula no Portal do Aluno?</label>
                          <select name="cmbSimouNaoPreMatricula" class="form-control" id="cmbSimouNaoPreMatricula"  style="width:100pt" onChange='' >
                          <option value="0">Selecione...</option>
                          <option value="S" <%if strSimouNaoPreMatricula = "S" then response.Write("selected") %>>SIM</option>
                          <option value="N" <%if strSimouNaoPreMatricula = "N" then response.Write("selected") %>>NAO</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Criar ou Atualizar Matriz Curricular checando o Hist&oacute;rico?</label>
                         <select name="cmbCriarGradeChecandoHistorico" class="form-control" id="cmbCriarGradeChecandoHistorico"  style="width:100pt" onChange='' >
                          <option value="0">Selecione...</option>
                          <option value="S" <%if strCriarGradeChecandoHistorico = "S" then response.Write("selected") %>>SIM</option>
                          <option value="N" <%if cmbCriarGradeChecandoHistorico = "N" then response.Write("selected") %>>NAO</option>
                        </select>
                    </div>
                   
                   <div class="form-group">
                        <label class="form-label">Controlar Documenta&ccedil;&atilde;o de Colaboradores pelo Grau de Instru&ccedil;&atilde;o?</label>
                         <select name="cmbSimouNaoDocumentacaoColaboradores" class="form-control" id="cmbSimouNaoDocumentacaoColaboradores"  style="width:100pt" onChange='' >
                          <option value="0">Selecione...</option>
                          <option value="S" <%if strSimouNaoDocumentacaoColaboradores = "S" then response.Write("selected") %>>SIM</option>
                          <option value="N" <%if strSimouNaoDocumentacaoColaboradores = "N" then response.Write("selected") %>>NAO</option>
                        </select>
                    </div>
                    
                    <div class="headline"><h2> Quadro de Avisos  ( at&eacute; 300 caracteres por linha ) </h2></div>
                    	
                    <div class="form-group">
                        <label class="form-label">Aviso 01</label>
                        <input name="txtNotificacao1" type="text" class="form-control" id="txtNotificacao1" size="120" maxlength="300" value="<%=strNotificacao1%>">
                    </div>
                    
                      <div class="form-group">
                        <label class="form-label">Aviso 02</label>
                        <input name="txtNotificacao2" type="text" class="form-control" id="txtNotificacao2" size="120" maxlength="300" value="<%=strNotificacao2%>">
                    </div>
                 
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
                <div class="panel panel-grey margin-bottom-40">
                    <div class="panel-heading">
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Encerramento das Atividades</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="4%" bgcolor="#95A5A6">Ano</th>
                                    <th width="38%" bgcolor="#95A5A6">Semestre</th>
                                    <th width="47%" bgcolor="#95A5A6">Data de Encerramento</th>
                                  <th width="11%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                              </tr>
                            </thead>
                            <%

							sql = "SELECT Codigo, cod_empresa, ano_letivo, semestre, data_encerramento"
							sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES"
							sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
							sql = sql & " Order by codigo"
							rs.open sql, cnn
							cont=0
							if rs.eof = false then
							
							while not rs.eof
							cont = cont + 1	
							%>
                            <tbody>
                                <tr>
                                    <td><%=trim(rs("ano_letivo"))%></td>
                                    <td><%=trim(rs("semestre"))%></td>
                                    <td><%=formataDataAP(trim(rs("data_encerramento")))%></td>
                                    <td><div align="center"><button class="btn-u btn-u-sea" onClick="resultadoConsulta(<%=trim(rs("Codigo"))%>)" type="button"><i class="fa fa-file-text-o"></i></button>   </div>
                                     
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
                <!--End Table Bordered-->	
       <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
    <script>
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtAno.value == "") {
			alert("O Ano letivo deve ser informado!");
			frm.txtAno.focus();
			return false;
		}
		
		if (frm.cmbSemestre.value == "0") {
			alert("O Semestre deve ser informado!");
			frm.cmbSemestre.focus();
			return false;
		}
		
		if (frm.txtDataEncerramento.value == "") {
			alert("A Data de Encerramento deve ser informada!");
			frm.txtDataEncerramento.focus();
			return false;
		}
		
		frm.action="EncerrametoAtividades_cod.asp?acao=" + acao;
		frm.submit();
		return true;
		
		}
	
		function resultadoConsulta(intCodigo){
			var frm = document.getElementById("frm");
			frm.txtCodigo.value=intCodigo;
			frm.submit();
		}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 