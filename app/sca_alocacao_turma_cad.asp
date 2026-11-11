<%
	
	strExecutarSubmitSemestre 		= "S"
	strExecutarSubmitSemestreAlocacao = "S"
	strExecutarSubmitTurma	 		= "S"	
	strExecutarSubmitTurmaAlocacao  = "S"

	intSemestre 			= Trim(Request("cmbSemestre"))
	strSemestre 			= Trim(Request("cmbSemestre"))
	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
	end if
	if Trim(Request("cmbSemestreAlocacao")) <> "0" and Trim(Request("cmbSemestreAlocacao")) <> "" then
		intSemestreAlocacao 	= Trim(Request("cmbSemestreAlocacao"))
	else
		intSemestreAlocacao 	= session("strSemestre")
	end if
	if Trim(Request("txtAnoLetivoLocacao")) <> "" then
		strAnoLetivoLocacao 	= Trim(Request.Form("txtAnoLetivoLocacao"))
	else
		strAnoLetivoLocacao 	= session("strAnoLetivo")
	end if

'response.write "strAnoLetivo:" & strAnoLetivo & " | strAnoLetivoLocacao:" & strAnoLetivoLocacao


	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodTurmaAlocacao 	= Trim(Request.Form("cmbTurmaAlocacao"))
	strTipoAlocacao 		= Trim(Request.Form("cmbTipoAlocacao"))
 	strLetraInicial        	= Trim(Request.Form("txtLetraInicial"))
	strLetraFinal          	= Trim(Request.Form("txtLetraFinal"))
	
	if intCodTurma 		= "" then intCodTurma 		= "0"

	acao = "I"
	
	strbotaoAtualizar		= "S"
	
	if intCodTurma = "0" or intCodTurma = "" then
		msgFiltroAZ = " Obrigatório"
	else
		msgFiltroAZ = " Opcional"
	end if


%>

<!--#include file="includes/inc_verifica_fechamento_anual.asp" -->
<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
<form id="frm" name="frm" method="post" action="sca_alocacao_turma.asp">
	<ol class="breadcrumb page-breadcrumb">
		<li class="breadcrumb-item"><a href="javascript:void(0);"><%=sistema%></a></li>
		<li class="breadcrumb-item"><%=modulo%></li>
		<li class="breadcrumb-item active"><%=pagina%></li>
		<li class="position-absolute pos-top pos-right d-none d-sm-block"><%=session("data_hoje")%></li>
	</ol>
	<div class="subheader">
		<h1 class="subheader-title">
			<i class='subheader-icon fal fa-edit'></i> <%=pagina%>
			<small>
				<%=descricao_pagina%>
			</small>
		</h1>
	</div>
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-8" class="panel">
                <div class="panel-hdr">
					<h2>
						<%=pagina%> <span class="fw-300"><i></i></span>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<%if mensagem_alerta_pagina<>"" then%>
						<div class="panel-tag">
							<%=mensagem_alerta_pagina%>
						</div>
						<%end if%>
						<%if Session("strBloqueiaFechamento") <> "S" then%>
						<div class="alert alert-warning  alert-dismissible fade show">
							<button type="button" class="close" data-dismiss="alert" aria-label="Close">
								<span aria-hidden="true"><i class="fal fa-times"></i></span>
							</button>
							<div class="d-flex align-items-center">
								<div class="alert-icon width-8">
									<span class="icon-stack icon-stack-xl">
										<i class="base-2 icon-stack-3x color-warning -400"></i>
										<i class="base-10 text-white icon-stack-1x"></i>
										<i class="ni md-profile color-warning -800 icon-stack-2x"></i>
									</span>
								</div>
								<div class="flex-1 pl-1">
									<span class="h2">
										Aviso!
									</span>
									<br>
									O bloqueio de alocação de alunos em turmas está desativado. Dessa forma, os alunos poderão ser alocados sem a necessidade de fechamento anual das turmas.
								</div>
							</div>
						</div>
						<%end if%>
						<div class="row">
							<div class="col-sm-12">
								<span><strong>Origem</strong></span>
							</div>	
						</div>					
						<div class="row">
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Ano Letivo</label>
									<input name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Semestre</label>
									 <!--#include file="includes/inc_cmdSemestre.asp" -->
								</div>
							</div>
						
							<div class="col-sm-6">
								<div class="form-group">
								
									<label class="form-label">Turma Origem</label>
									<!--#include file="includes/inc_cmdTurmaModulacaoTotal.asp"-->
								</div>
							</div>
						</div>
						<br>
						<div class="row">
							<div class="col-sm-12">
								<span><strong>Nova Alocação</strong></span>
							</div>	
						</div>					
						<div class="row">
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Ano Letivo</label>
									<input name="txtAnoLetivoLocacao" type="text" class="form-control" id="txtAnoLetivoLocacao" onBlur="submit()"  value="<%=strAnoLetivoLocacao%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group">
									<label class="form-label">Semestre</label>
									 <!--#include file="includes/inc_cmdSemestreAlocacao.asp" -->
								</div>
							</div>
						
							<div class="col-sm-6">
								<div class="form-group">
								
									<label class="form-label">Turma Destino</label>
									<!--#include file="includes/inc_cmdTurmaModulacaoTotalAlocacao.asp"-->
								</div>
							</div>
						</div>
						<input name="serieOrigem" 	id="serieOrigem"  type="hidden" value="<%=intCodSerie%>" >
						<input name="serieDestino"	id="serieDestino" type="hidden" value="<%=intCodSerieDestino%>" >
						
						<input name="cmbTipoAlocacao" id="cmbTipoAlocacao" type="hidden" value="TG" >
						<br>
						<div class="frame-wrap">
							<!--#include file="includes/inc_botoes_cadastro.asp"-->
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
 <%
  if intCodTurma <> "0"  and intCodTurma <> "" then
  %>
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						<%=pagina%> cadastradas
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>	
				<div class="panel-container show">
					<div class="panel-content">		
						
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><input type="checkbox" name="chkTodos" onClick="return marcaTodos(this.checked)"></th>
									<th><strong>Matr&iacute;cula</strong></th>
									<th><strong>Nome</strong></th>
									<th><strong>Turma</strong></th>
									<th><strong>Situa&ccedil;&atilde;o</strong></th>
								  </tr>
								</thead>
								<tbody>
								<%	
							sql = "SELECT SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, "
							sql = sql & " SCA_ALUNO.NOMEALUNO, SCA_ALUNO_TURMA.COD_TURMA, SCA_TURMA.TURMAALUNO, "
							sql = sql & " SCA_TURMA.NomeTurma, SCA_SITUACAOALUNO.Desc_SituacaoAluno, I.EFETIVACAO, I.codigo as codInscricao,  "
							sql = sql & " ("
							sql = sql & " select "
							sql = sql & " 	codigo"
							sql = sql & " from SCA_ALUNO"
							sql = sql & " where CODIGO=SCA_ALUNO_TURMA.COD_ALUNO"
							sql = sql & " and ( NOMEALUNO is null or DATANASCIMENTO is null"
							sql = sql & " or DATAMATRICULA is null"
							sql = sql & " or SEXOALUNO is null"
							sql = sql & " or NACIONALIDADE is null"
							sql = sql & " or COD_TIPONACIONALIDADE is null"
							sql = sql & " or COD_PROFISSAO is null"
							sql = sql & " or COD_ETNIA is null"
							sql = sql & " or MAE is null"
							sql = sql & " or ( COD_TIPONACIONALIDADE <> 3 and ( CIDADENASCIMENTO is null or UFNASCIMENTO is null ) )"
							sql = sql & ")) as pendencias"							
							sql = sql & " FROM SCA_ALUNO_TURMA "
							sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
							sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma "
							sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular"
							sql = sql & " LEFT JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = SCA_ALUNO.COD_SITUACAOALUNO"
							sql = sql & " LEFT JOIN MAT_INSCRICAO I ON I.COD_ALUNO = SCA_ALUNO.CODIGO"
							sql = sql & " where SCA_TURMA.cod_empresa = " & Session("CodEmpresa")			
							sql = sql & " and SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma & ""	
							sql = sql & " and SCA_ALUNO_TURMA.situacao = 'A'"
							if strLetraInicial <> "" and strLetraFinal <> "" then
							   sql = sql & " and SUBSTRING(NomeAluno,1,1) >= '" & strLetraInicial & "'"
							   sql = sql & " and SUBSTRING(NomeAluno,1,1) <= '" & strLetraFinal & "'"
							end If 
							sql = sql & " order by SCA_ALUNO.NOMEALUNO"
							rs.open sql, cnn
							if rs.eof = false then
								selecionado = "checked"
								cont = 0
								while not rs.eof
									cont = cont+1
									strCodigoAluno        = rs("codigo")
									strMatricula		  = rs("MATRICULA")
									strEfetivacao		  = rs("EFETIVACAO")
									
									strPendencias		  = rs("pendencias")
									if isnull(strPendencias) then 
										strPendencias = ""
									else
										strPendencias = "<a href=""sca_aluno.asp?txtCodAluno=" & strCodigoAluno & """ class=""pendencia""><button type=""button"" class=""btn btn-danger waves-effect waves-themed"" data-template=""<div class=&quot;tooltip&quot; role=&quot;tooltip&quot;><div class=&quot;tooltip-inner bg-danger-500&quot;></div></div>"" data-toggle=""tooltip"" title="""" data-original-title=""Aluno com ficha cadastral incompleta, clique para fazer o preenchimento."">Atenção!</button></a>"
									end if
									
									strBloqAltrExcl 	  = ""
									corLinha 			  = " "
									if not isnull(rs("codInscricao")) then
										if strEfetivacao = "S" then
											strBloqAltrExcl = ""
											corLinha = " "
										else
											strBloqAltrExcl = "disabled"
											strMensagemEfetivacao = "<br><table class='tabela' width='50%' border='0' cellspacing='0' cellpadding='0'><tr  bgcolor='#9BCDFF'><td class='celula'><strong>* Aluno não está efetivado!</strong></td></tr></table><br><br>"
											corLinha = " bgcolor='#9BCDFF' "
										end if
									end if
									 %>
									 <tr style="cursor: pointer"  <%=corLinha%>>
										<td>
											<%if strPendencias = "" then %>
											<input type="checkbox"  <%=strBloqAltrExcl%>  id="chkAluno" name="chkAluno" value="<%=rs("codigo")%>"></td>
											<%end if%>
																					
										<td><%=strMatricula%></td>
										<td><%=rs("NOMEALUNO")%>&nbsp;<%=strPendencias%></td>
										<td><%=rs("TURMAALUNO")%>&nbsp;&nbsp;<%=rs("NOMETURMA")%></td>
										<td><%=rs("Desc_SituacaoAluno")%></td>
									</tr>
									
									 <%
									 rs.movenext
								  wend
									  
							  else
								 %>
								<tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)">
									<td colspan="5" align="center" class="celula">Total de Alunos:&nbsp;<%=cont%> </td>
								</tr>
								 <%
							  end if
							  rs.close
							%>
								<tr>
									<td colspan="6">Total de Alunos:&nbsp;<%=cont%> </td>
								</tr>
								</tbody>
							</table>
							<br><strong><%=strMensagemEfetivacao%></strong>
						</div>	
					</div>
				</div>
			</div>
		</div>
	</div>
<%
end if
%>	
	</form>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>