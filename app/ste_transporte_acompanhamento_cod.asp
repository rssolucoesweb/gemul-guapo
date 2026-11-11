<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_formataCPF.asp"-->
<!--#include file="includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 					= Trim(Request("acao"))
	intCodSolicitacao		    	= Trim(Request("cod_solicitacao")) 

	strSituacao = request("cmbSituacao")
	if strSituacao = "" then strSituacao = "S"
	
	intCodSetor = request("cmbSetor")
	if intCodSetor = "" then intCodSetor = "0"
	
	intCodTurno = request("cmbTurno")
	if intCodTurno = "" then intCodTurno = "0"
	
	strRede = request("cmbRede")
	if strRede = "" then strRede = "0"


	intCodEmpresa = request("cmbEmpresa")
	intCodEscolaEstadual = request("cmbEscolaEstadual")
	
	if strRede = "" then 
		strRede = "0"
	end if


	if acao="MOSTRA_SOLICITACAO" then
		cont =0
		sql = "select a.codigo, m.codigo_escola_estadual, m.situacao, m.situacao_dda, m.obs, r.Cod_rota, m.codigo as codInscricao, m.nome as NOMEALUNO, a.MATRICULA, m.cpf, m.DATA_NASCIMENTO as DATANASCIMENTO , m.MAE , a.EMAIL, a.FONERESIDENCIAL, e.RAZAOSOCIAL, M.sexo,"
		sql = sql & " EE.ENDERECO AS ENDERECO_ESTADUAL, EE.BAIRRO AS BAIRRO_ESTADUAL, EE.MUNICIPIO AS MUNICIPIO_ESTADUAL, EE.CEP AS CEP_ESTADUAL, e.ENDERECO, e.BAIRRO, e.MUNICIPIO, e.UF, e.CEP, e.TELEFONE, M.usuario_incl, M.data_hora_incl, CONVERT(VARCHAR(5),CAST(M.data_hora_incl AS datetime), 108) as hora, a.cod_empresa, "
		sql = sql & " c.descricao as curso, m.contato, m.Celular, m.FoneMae, m.FonePai, p.descricao as serie, tu.Desc_Turno as turno, t.nometurma, t.TurmaAluno,"
		sql = sql & " a.ATENDIMENTOESPECIAL, nn.Desc_NecEspecial, M.Logradouro as LogradouroAluno, ee.nome as escola_estadual, M.NUMEROENDERECO as NumeroEnderecoAluno, M.COMPLEMENTOENDERECO as ComplementoEnderecoAluno, M.BAIRRO AS BAIRROALUNO, M.CIDADE as cidadeAluno, M.UF as ufaluno, M.CEP as cepAluno, m.turno_estadual"
		sql = sql & " from ste_solicitacao_transporte m"
		sql = sql & " left join sca_aluno a on m.cod_aluno = a.codigo"
		sql = sql & " left join seg_empresa e on e.codigo = m.cod_empresa"
		sql = sql & " left join ste_escola_estadual ee on ee.codigo_escola_estadual = m.codigo_escola_estadual "
		sql = sql & " left join sca_turma t on t.cod_turma = m.cod_turma"
		sql = sql & " left join sca_periodo p on p.cod_periodo = t.cod_periodo"
		sql = sql & " left join sca_curso c on c.cod_curso = p.cod_curso"
		sql = sql & " left join sca_turno tu on tu.cod_turno = t.cod_turno"
		sql = sql & " left join STE_ROTA_VINCULA_UNIDADE_SETORES se on se.Cod_empresa = m.Cod_empresa"
		sql = sql & " left join STE_ROTA_VINCULA_SETORES s on s.Cod_setores = se.Cod_setores"
		sql = sql & " left join STE_ROTA r on r.Cod_rota = s.Cod_rota and r.Situacao = 'A'"
		sql = sql & " left join SCA_NECESSIDADEESPECIAL nn on nn.Cod_NecEspecial = a.COD_NECESPECIAL"
		sql = sql & " WHERE m.codigo = " & intCodSolicitacao
		'RESPONSE.WRITE SQL
		RS.OPEN SQL, CNN
		IF NOT RS.EOF THEN
			intCodInscricao		= Trim(RS("codInscricao"))
			intCodigo			= Trim(RS("Codigo"))
			strNomealuno		= Trim(RS("NOMEALUNO"))
			strCPF				= formataCpfAP(Trim(RS("cpf")))
			strSexo				= Trim(RS("Sexo"))
			if strSexo = "M" then strSexo = "MASCULINO"
			if strSexo = "F" then strSexo = "FEMININO"
			strMATRICULA		= Trim(RS("MATRICULA"))
			strDATANASCIMENTO	= Trim(RS("DATANASCIMENTO"))
			strMAE				= Trim(RS("MAE"))
			strEMAIL			= Trim(RS("EMAIL"))
			
			strFONERESIDENCIAL  = ""
			if not isnull(RS("contato")) then
				strFONERESIDENCIAL = Trim(RS("contato"))
			end if
			if not isnull(RS("Celular")) then
				strFONERESIDENCIAL = strFONERESIDENCIAL & " " & Trim(RS("Celular"))
			end if
			if not isnull(RS("FoneMae")) then
				strFONERESIDENCIAL = strFONERESIDENCIAL & " " & Trim(RS("FoneMae"))
			end if
			if not isnull(RS("FonePai")) then
				strFONERESIDENCIAL = strFONERESIDENCIAL & " " & Trim(RS("FonePai"))
			end if
			
			strFONERESIDENCIAL = trim(strFONERESIDENCIAL)
			
			strEnderecoAluno = rs("LogradouroAluno") & " " & rs("numeroEnderecoAluno")  & " " & rs("ComplementoEnderecoAluno")
			strBairroAluno = rs("bairroAluno") 
			strCidadeAluno = rs("cidadeAluno") 
			strCepAluno = rs("cepAluno")
			
			strUsuario_incl		= Trim(RS("usuario_incl"))
			strData_hora_incl	= formatadataAP(Trim(RS("data_hora_incl"))) & " " & RS("hora")
			strDataAtual		= formatadataAP(RS("data_hora_incl"))
			if not isnull(rs("codigo_escola_estadual")) then
				strEscola		= Trim(RS("escola_estadual"))
				strEndereco		= Trim(RS("ENDERECO_ESTADUAL"))
				strBairro		= Trim(RS("BAIRRO_ESTADUAL"))
				strMunicipio	= Trim(RS("MUNICIPIO_ESTADUAL"))
				strCep			= Trim(RS("CEP_ESTADUAL"))
			else
				strEscola		= Trim(RS("RAZAOSOCIAL"))
				strEndereco		= Trim(RS("ENDERECO"))
				strBairro		= Trim(RS("BAIRRO"))
				strMunicipio	= Trim(RS("MUNICIPIO"))
				strUF			= Trim(RS("UF"))
				strCep			= Trim(RS("CEP"))
				strTelefone		= Trim(RS("TELEFONE"))
			end if
			
			strTurma		= Trim(RS("NomeTurma")) 
			if not isnull(RS("TurmaAluno")) or RS("TurmaAluno")<>"" then
				strTurma = strTurma & " - " & Trim(RS("TurmaAluno"))
			end if
			strNecessidade	= Trim(RS("Desc_NecEspecial"))
			strCurso		= Trim(RS("curso"))
			strSerie		= Trim(RS("serie"))
			strTurno		= Trim(RS("turno"))
			intCodEmpresa = rs("cod_empresa")
			codigo_escola_estadual = rs("codigo_escola_estadual")
			intCodRota = rs("Cod_rota")
			strSituacao = rs("situacao")
			situacao_dda = rs("situacao_dda")
			if not isnull(situacao_dda) then
				mostraE = "N"
				mostraS = "N"
			end if
			ATENDIMENTOESPECIAL = rs("ATENDIMENTOESPECIAL")
			strObservacao = rs("obs")
			retiraTodas="S"
			turno_estadual		= Trim(RS("turno_estadual"))
			rs.close
		%>
		<div class="row">
			<div class="col-xl-12">
				<div id="panel-1" class="panel">
					<div class="panel-hdr">
						<h2>
							Rota:&nbsp;<!--#include file=includes/inc_cmdRota.asp-->&nbsp;&nbsp;&nbsp;&nbsp;Encaminhamento:&nbsp;<!--#include file=includes/inc_cmdSituacaoTransporteEncaminhamento.asp-->
						</h2>
					</div>
					<br>
					<div class="panel-hdr">
						<h2>
							Observação:&nbsp;<textarea name="txtObservacao" cols="55" rows="2" class="form-control" id="txtObservacao"><%=strObservacao%></textarea>
						</h2>
						<br>
					</div>
					<br>
					<div style="text-align: center">
						<button onClick="salvarEncaminhamento()"  type="button" class="btn btn-success waves-effect waves-themed">Salvar</button>
						<button type="button" class="btn btn-secondary waves-effect waves-themed" data-dismiss="modal">Fechar</button>
					</div>					
					<input name="txtCodSolicitacao" type="hidden" id="txtCodSolicitacao" value="<%=intCodSolicitacao%>">
					<div class="panel-container show">
						<div class="panel-content">					
							<div class="table-responsive-lg">

								<div style="background: #fff; padding: 5px; border: #000 0px solid; width: 100%; margin: 0 auto; color: #000;">
									<div style="text-align: center;  font: bold 16px Arial, Helvetica, sans-serif;">
										Comprovante de Solicitação <%=strCurso%><br />
									</div>
									<table width="100%" bgcolor="#F3F3F3" style="border: #ccc 1px solid; margin-top: 5px; font: 12px Arial, Helvetica, sans-serif;">
									  <tr>
										<td width="45%"  style="border-right: #ccc 1px solid; padding: 5px;"  >N&uacute;mero: <strong><span class="texto1"><%=intCodInscricao%></span></strong></td>
										<td width="55%"  style="padding: 5px;" >Data:&nbsp;<strong><%=strData_hora_incl%> </strong></td>
									  </tr>
									</table>
									<br>
									<p class="titulo2"><strong>1. Dados do Aluno</strong></p>
									<table width="100%" bgcolor="#F3F3F3" style="border: #ccc 1px solid; margin-top: 5px; font: 12px Arial, Helvetica, sans-serif;">
										<tr>
											<td width="17%"  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Nome do Aluno</span></td>
											<td width="33%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strNomealuno%></strong></td>
											<td width="8%"   style="border-left: #ccc 1px solid;border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  >CPF</td>
											<td width="12%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strCPF%></strong></td>
										</tr>
										<tr>
											<td width="17%"  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Data de Nasc.</span></td>
											<td width="33%"  style="padding: 5px; border-top: #ccc 1px solid" ><strong><%=formatadataAP(strDATANASCIMENTO)%></strong></td>
											<td width="8%"   style="border-left: #ccc 1px solid;border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  >Sexo</td>
											<td width="12%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strSexo%></strong></td>
										</tr>
										<tr>
										  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Nome da m&atilde;e</span></td>
										  <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid" ><strong><%=strMAE%></strong></td>
										</tr>
										<tr>
										  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Telefones</span></td>
										  <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid" ><strong><%=strFONERESIDENCIAL%></strong></td>
										</tr>
										<tr>
										  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Endereço</span></td>
										  <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid" ><strong><%=strEnderecoAluno%></strong></td>
										</tr>
										<tr>
										  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Bairro</span></td>
										  <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid" ><strong><%=strBairroAluno%></strong></td>
										</tr>
										<tr>
										  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Cidade</span></td>
										  <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid" ><strong><%=strCidadeAluno%></strong></td>
										</tr>
										<tr>
										  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">CEP</span></td>
										  <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid" ><strong><%=strCepAluno%></strong></td>
										</tr>
										<%if strEMAIL <> "" then%>
										<tr>
										  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Email</span></td>
										  <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid" ><strong><%=strEMAIL%></strong></td>
										</tr>
										<%end if%>
										<%if isnull(codigo_escola_estadual) then%>
										<%
										if ATENDIMENTOESPECIAL = "S" then 
											ATENDIMENTOESPECIAL = "Sim"
										else
											ATENDIMENTOESPECIAL = "Não"
										end if
										%>
										<tr>
										  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Atendimento especial</span></td>
										  <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid" ><strong><%=ATENDIMENTOESPECIAL%></strong></td>
										</tr>
										<tr>
										  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Necessidade especial</span></td>
										  <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid" ><strong><%=strNecessidade%></strong></td>
										</tr>
										<%end if%>
									</table>
									
									<br />
									<%if isnull(codigo_escola_estadual) then%>
									<p class="titulo2"><strong>2. Dados Escolares</strong></p>
									<table width="100%" bgcolor="#F3F3F3" style="border: #ccc 1px solid; margin-top: 5px; font: 12px Arial, Helvetica, sans-serif;">
										<tr>
											<td width="5%"   style="border-left: #ccc 1px solid;border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  >Curso</td>
											<td width="40%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strCurso%></strong></td>
											<td width="5%"   style="border-left: #ccc 1px solid;border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  >S&eacute;rie</td>
											<td width="25%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strSerie%></strong></td>
											<td width="5%"   style="border-left: #ccc 1px solid;border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  >Turno</td>
											<td width="20%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strTurno%></strong></td>
										</tr>
										<tr>
											<td width="5%"   style="border-left: #ccc 1px solid;border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  >Turma</td>
											<td width="40%" colspan="5"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strTurma%></strong></td>
										</tr>
									</table>
									
									<br />
									<p class="titulo2"><strong>3. Transporte para Escola</strong></p>
									<table width="100%" bgcolor="#F3F3F3" style="border: #ccc 1px solid; margin-top: 5px; font: 12px Arial, Helvetica, sans-serif;">
										<tr>
										  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Escola</span></td>
										  <td  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strEscola%></strong></td>
										  <td  style="border-left: #ccc 1px solid;border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  >Cep</td>
										  <td  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strCep%></strong></td>
										</tr>
										<tr>
										  <td width="17%"  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Endere&ccedil;o</span></td>
										  <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strEndereco%></strong></td>
										</tr>
										<tr>
										  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Bairro</span></td>
										  <td width="38%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strBairro%></strong></td>
										  <td width="11%"  style="border-left: #ccc 1px solid;border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  >Munic&iacute;pio</td>
										  <td width="34%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strMunicipio%>-<%=strUF%></strong></td>
										</tr>
										<tr>
										  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Telefone</span></td>
										  <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strTelefone%></strong></td>
										</tr>
									</table>
									<%else%>
									<br />
									<p class="titulo2"><strong>2. Transporte para Escola</strong></p>
									<table width="100%" bgcolor="#F3F3F3" style="border: #ccc 1px solid; margin-top: 5px; font: 12px Arial, Helvetica, sans-serif;">
										<tr>
										  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Escola</span></td>
										  <td  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strEscola%></strong></td>
										  <td  style="border-left: #ccc 1px solid;border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  >Cep</td>
										  <td  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strCep%></strong></td>
										</tr>
										<tr>
										  <td width="17%"  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Endere&ccedil;o</span></td>
										  <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strEndereco%></strong></td>
										</tr>
										<tr>
										  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Bairro</span></td>
										  <td width="38%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strBairro%></strong></td>
										  <td width="11%"  style="border-left: #ccc 1px solid;border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  >Munic&iacute;pio</td>
										  <td width="34%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strMunicipio%>-<%=strUF%></strong></td>
										</tr>
										<tr>
										  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Turno</span></td>
										  <td width="38%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=turno_estadual%></strong></td>
										  <td width="11%"  style="border-left: #ccc 1px solid;border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ></td>
										  <td width="34%"  style="padding: 5px; border-top: #ccc 1px solid;" ></td>
										</tr>
									</table>
									<%end if%>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div> 
		<%
		else	
			rs.close
		end if
	elseif acao="MOSTRA_ALTERACAO" then
		cont =0
		sql = "select a.codigo, m.codigo_escola_estadual, m.situacao, m.situacao_dda, m.obs, r.Cod_rota, m.codigo as codInscricao, m.nome as NOMEALUNO, a.MATRICULA, m.cpf, m.DATA_NASCIMENTO as DATANASCIMENTO , m.MAE , a.EMAIL, a.FONERESIDENCIAL, e.RAZAOSOCIAL, M.sexo,"
		sql = sql & " EE.ENDERECO AS ENDERECO_ESTADUAL, EE.BAIRRO AS BAIRRO_ESTADUAL, EE.MUNICIPIO AS MUNICIPIO_ESTADUAL, EE.CEP AS CEP_ESTADUAL, e.ENDERECO, e.BAIRRO, e.MUNICIPIO, e.UF, e.CEP, e.TELEFONE, M.usuario_incl, M.data_hora_incl, CONVERT(VARCHAR(5),CAST(M.data_hora_incl AS datetime), 108) as hora, a.cod_empresa, "
		sql = sql & " c.descricao as curso, m.contato, m.Celular, m.FoneMae, m.FonePai, p.descricao as serie, tu.Desc_Turno as turno, t.nometurma, t.TurmaAluno,"
		sql = sql & " a.ATENDIMENTOESPECIAL, nn.Desc_NecEspecial, M.Logradouro as LogradouroAluno, ee.nome as escola_estadual, M.NUMEROENDERECO as NumeroEnderecoAluno, M.COMPLEMENTOENDERECO as ComplementoEnderecoAluno, M.BAIRRO AS BAIRROALUNO, M.CIDADE as cidadeAluno, M.UF as ufaluno, M.CEP as cepAluno, m.turno_estadual"
		sql = sql & " from ste_solicitacao_transporte m"
		sql = sql & " left join sca_aluno a on m.cod_aluno = a.codigo"
		sql = sql & " left join seg_empresa e on e.codigo = m.cod_empresa"
		sql = sql & " left join ste_escola_estadual ee on ee.codigo_escola_estadual = m.codigo_escola_estadual "
		sql = sql & " left join sca_turma t on t.cod_turma = m.cod_turma"
		sql = sql & " left join sca_periodo p on p.cod_periodo = t.cod_periodo"
		sql = sql & " left join sca_curso c on c.cod_curso = p.cod_curso"
		sql = sql & " left join sca_turno tu on tu.cod_turno = t.cod_turno"
		sql = sql & " left join STE_ROTA_VINCULA_UNIDADE_SETORES se on se.Cod_empresa = m.Cod_empresa"
		sql = sql & " left join STE_ROTA_VINCULA_SETORES s on s.Cod_setores = se.Cod_setores"
		sql = sql & " left join STE_ROTA r on r.Cod_rota = s.Cod_rota and r.Situacao = 'A'"
		sql = sql & " left join SCA_NECESSIDADEESPECIAL nn on nn.Cod_NecEspecial = a.COD_NECESPECIAL"
		sql = sql & " WHERE m.codigo = " & intCodSolicitacao
		'RESPONSE.WRITE SQL
		RS.OPEN SQL, CNN
		IF NOT RS.EOF THEN
			intCodInscricao		= Trim(RS("codInscricao"))
			intCodigo			= Trim(RS("Codigo"))
			strNomealuno		= Trim(RS("NOMEALUNO"))
			strCPF				= formataCpfAP(Trim(RS("cpf")))
			strSexo				= Trim(RS("Sexo"))
			if strSexo = "M" then strSexo = "MASCULINO"
			if strSexo = "F" then strSexo = "FEMININO"
			strMATRICULA		= Trim(RS("MATRICULA"))
			strDATANASCIMENTO	= Trim(RS("DATANASCIMENTO"))
			strMAE				= Trim(RS("MAE"))
			strEMAIL			= Trim(RS("EMAIL"))
			
			strFONERESIDENCIAL  = ""
			if not isnull(RS("contato")) then
				strFONERESIDENCIAL = Trim(RS("contato"))
			end if
			if not isnull(RS("Celular")) then
				strFONERESIDENCIAL = strFONERESIDENCIAL & " " & Trim(RS("Celular"))
			end if
			if not isnull(RS("FoneMae")) then
				strFONERESIDENCIAL = strFONERESIDENCIAL & " " & Trim(RS("FoneMae"))
			end if
			if not isnull(RS("FonePai")) then
				strFONERESIDENCIAL = strFONERESIDENCIAL & " " & Trim(RS("FonePai"))
			end if
			
			strFONERESIDENCIAL = trim(strFONERESIDENCIAL)
			
			strEnderecoAluno = rs("LogradouroAluno") & " " & rs("numeroEnderecoAluno")  & " " & rs("ComplementoEnderecoAluno")
			strBairroAluno = rs("bairroAluno") 
			strCidadeAluno = rs("cidadeAluno") 
			strCepAluno = rs("cepAluno")
			
			strUsuario_incl		= Trim(RS("usuario_incl"))
			strData_hora_incl	= formatadataAP(Trim(RS("data_hora_incl"))) & " " & RS("hora")
			strDataAtual		= formatadataAP(RS("data_hora_incl"))
			if not isnull(rs("codigo_escola_estadual")) then
				strEscola		= Trim(RS("escola_estadual"))
				strEndereco		= Trim(RS("ENDERECO_ESTADUAL"))
				strBairro		= Trim(RS("BAIRRO_ESTADUAL"))
				strMunicipio	= Trim(RS("MUNICIPIO_ESTADUAL"))
				strCep			= Trim(RS("CEP_ESTADUAL"))
			else
				strEscola		= Trim(RS("RAZAOSOCIAL"))
				strEndereco		= Trim(RS("ENDERECO"))
				strBairro		= Trim(RS("BAIRRO"))
				strMunicipio	= Trim(RS("MUNICIPIO"))
				strUF			= Trim(RS("UF"))
				strCep			= Trim(RS("CEP"))
				strTelefone		= Trim(RS("TELEFONE"))
			end if
			
			strTurma		= Trim(RS("NomeTurma")) 
			if not isnull(RS("TurmaAluno")) or RS("TurmaAluno")<>"" then
				strTurma = strTurma & " - " & Trim(RS("TurmaAluno"))
			end if
			strNecessidade	= Trim(RS("Desc_NecEspecial"))
			strCurso		= Trim(RS("curso"))
			strSerie		= Trim(RS("serie"))
			strTurno		= Trim(RS("turno"))
			intCodEmpresa = rs("cod_empresa")
			codigo_escola_estadual = rs("codigo_escola_estadual")
			intCodRota = rs("Cod_rota")
			strSituacao = rs("situacao")
			situacao_dda = rs("situacao_dda")
			if not isnull(situacao_dda) then
				mostraE = "N"
				mostraS = "N"
			end if
			ATENDIMENTOESPECIAL = rs("ATENDIMENTOESPECIAL")
			strObservacao = rs("obs")
			retiraTodas="S"
			turno_estadual		= Trim(RS("turno_estadual"))
			rs.close
		%>
		<div class="row">
			<div class="col-xl-12">
				<div id="panel-1" class="panel">
					<div class="panel-hdr">
						<h2>
							Turno:&nbsp;
							
							<select class="form-control" id="turno_estadual" name="turno_estadual">
								<option value="0">Selecione...</option>
								<option <%if turno_estadual = "MATUTINO" then response.write "selected"%> value="MATUTINO">Matutino</option>	
								<option <%if turno_estadual = "VESPERTINO" then response.write "selected"%> value="VESPERTINO">Vespertino</option>
								<option <%if turno_estadual = "NOTURNO" then response.write "selected"%> value="NOTURNO">Noturno</option>
								<option <%if turno_estadual = "INTEGRAL" then response.write "selected"%> value="INTEGRAL">Integral</option>
							</select>
						</h2>
					</div>
					<br>
					<div style="text-align: center">
						<button onClick="salvarAlteracao()"  type="button" class="btn btn-success waves-effect waves-themed">Salvar</button>
						<button type="button" class="btn btn-secondary waves-effect waves-themed" data-dismiss="modal">Fechar</button>
					</div>					
					<input name="txtCodSolicitacao" type="hidden" id="txtCodSolicitacao" value="<%=intCodSolicitacao%>">
					<div class="panel-container show">
						<div class="panel-content">					
							<div class="table-responsive-lg">

								<div style="background: #fff; padding: 5px; border: #000 0px solid; width: 100%; margin: 0 auto; color: #000;">
									<div style="text-align: center;  font: bold 16px Arial, Helvetica, sans-serif;">
										Comprovante de Solicitação <%=strCurso%><br />
									</div>
									<table width="100%" bgcolor="#F3F3F3" style="border: #ccc 1px solid; margin-top: 5px; font: 12px Arial, Helvetica, sans-serif;">
									  <tr>
										<td width="45%"  style="border-right: #ccc 1px solid; padding: 5px;"  >N&uacute;mero: <strong><span class="texto1"><%=intCodInscricao%></span></strong></td>
										<td width="55%"  style="padding: 5px;" >Data:&nbsp;<strong><%=strData_hora_incl%> </strong></td>
									  </tr>
									</table>
									<br>
									<p class="titulo2"><strong>1. Dados do Aluno</strong></p>
									<table width="100%" bgcolor="#F3F3F3" style="border: #ccc 1px solid; margin-top: 5px; font: 12px Arial, Helvetica, sans-serif;">
										<tr>
											<td width="17%"  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Nome do Aluno</span></td>
											<td width="33%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strNomealuno%></strong></td>
											<td width="8%"   style="border-left: #ccc 1px solid;border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  >CPF</td>
											<td width="12%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strCPF%></strong></td>
										</tr>
										<tr>
											<td width="17%"  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Data de Nasc.</span></td>
											<td width="33%"  style="padding: 5px; border-top: #ccc 1px solid" ><strong><%=formatadataAP(strDATANASCIMENTO)%></strong></td>
											<td width="8%"   style="border-left: #ccc 1px solid;border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  >Sexo</td>
											<td width="12%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strSexo%></strong></td>
										</tr>
										<tr>
										  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Nome da m&atilde;e</span></td>
										  <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid" ><strong><%=strMAE%></strong></td>
										</tr>
										<tr>
										  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Telefones</span></td>
										  <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid" ><strong><%=strFONERESIDENCIAL%></strong></td>
										</tr>
										<tr>
										  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Endereço</span></td>
										  <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid" ><strong><%=strEnderecoAluno%></strong></td>
										</tr>
										<tr>
										  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Bairro</span></td>
										  <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid" ><strong><%=strBairroAluno%></strong></td>
										</tr>
										<tr>
										  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Cidade</span></td>
										  <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid" ><strong><%=strCidadeAluno%></strong></td>
										</tr>
										<tr>
										  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">CEP</span></td>
										  <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid" ><strong><%=strCepAluno%></strong></td>
										</tr>
										<%if strEMAIL <> "" then%>
										<tr>
										  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Email</span></td>
										  <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid" ><strong><%=strEMAIL%></strong></td>
										</tr>
										<%end if%>
										<%if isnull(codigo_escola_estadual) then%>
										<%
										if ATENDIMENTOESPECIAL = "S" then 
											ATENDIMENTOESPECIAL = "Sim"
										else
											ATENDIMENTOESPECIAL = "Não"
										end if
										%>
										<tr>
										  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Atendimento especial</span></td>
										  <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid" ><strong><%=ATENDIMENTOESPECIAL%></strong></td>
										</tr>
										<tr>
										  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Necessidade especial</span></td>
										  <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid" ><strong><%=strNecessidade%></strong></td>
										</tr>
										<%end if%>
									</table>
									
									<br />
									<%if isnull(codigo_escola_estadual) then%>
									<p class="titulo2"><strong>2. Dados Escolares</strong></p>
									<table width="100%" bgcolor="#F3F3F3" style="border: #ccc 1px solid; margin-top: 5px; font: 12px Arial, Helvetica, sans-serif;">
										<tr>
											<td width="5%"   style="border-left: #ccc 1px solid;border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  >Curso</td>
											<td width="40%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strCurso%></strong></td>
											<td width="5%"   style="border-left: #ccc 1px solid;border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  >S&eacute;rie</td>
											<td width="25%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strSerie%></strong></td>
											<td width="5%"   style="border-left: #ccc 1px solid;border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  >Turno</td>
											<td width="20%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strTurno%></strong></td>
										</tr>
										<tr>
											<td width="5%"   style="border-left: #ccc 1px solid;border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  >Turma</td>
											<td width="40%" colspan="5"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strTurma%></strong></td>
										</tr>
									</table>
									
									<br />
									<p class="titulo2"><strong>3. Transporte para Escola</strong></p>
									<table width="100%" bgcolor="#F3F3F3" style="border: #ccc 1px solid; margin-top: 5px; font: 12px Arial, Helvetica, sans-serif;">
										<tr>
										  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Escola</span></td>
										  <td  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strEscola%></strong></td>
										  <td  style="border-left: #ccc 1px solid;border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  >Cep</td>
										  <td  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strCep%></strong></td>
										</tr>
										<tr>
										  <td width="17%"  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Endere&ccedil;o</span></td>
										  <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strEndereco%></strong></td>
										</tr>
										<tr>
										  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Bairro</span></td>
										  <td width="38%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strBairro%></strong></td>
										  <td width="11%"  style="border-left: #ccc 1px solid;border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  >Munic&iacute;pio</td>
										  <td width="34%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strMunicipio%>-<%=strUF%></strong></td>
										</tr>
										<tr>
										  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Telefone</span></td>
										  <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strTelefone%></strong></td>
										</tr>
									</table>
									<%else%>
									<br />
									<p class="titulo2"><strong>2. Transporte para Escola</strong></p>
									<table width="100%" bgcolor="#F3F3F3" style="border: #ccc 1px solid; margin-top: 5px; font: 12px Arial, Helvetica, sans-serif;">
										<tr>
										  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Escola</span></td>
										  <td  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strEscola%></strong></td>
										  <td  style="border-left: #ccc 1px solid;border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  >Cep</td>
										  <td  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strCep%></strong></td>
										</tr>
										<tr>
										  <td width="17%"  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Endere&ccedil;o</span></td>
										  <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strEndereco%></strong></td>
										</tr>
										<tr>
										  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Bairro</span></td>
										  <td width="38%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strBairro%></strong></td>
										  <td width="11%"  style="border-left: #ccc 1px solid;border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  >Munic&iacute;pio</td>
										  <td width="34%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strMunicipio%>-<%=strUF%></strong></td>
										</tr>
										<tr>
										  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Turno</span></td>
										  <td width="38%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=turno_estadual%></strong></td>
										  <td width="11%"  style="border-left: #ccc 1px solid;border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ></td>
										  <td width="34%"  style="padding: 5px; border-top: #ccc 1px solid;" ></td>
										</tr>
									</table>
									<%end if%>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div> 
		<%
		else	
			rs.close
		end if
		
	elseif acao="EXCLUIR_CADASTRO" then
		codSolicitacao = request("txtCodSolicitacao")
		
		sql="DELETE STE_presenca "
		sql = sql & " where cod_solicitacao_transporte = " & codSolicitacao
		cnn.execute sql
		GravarLog sql
		
		sql="DELETE SCA_ROTA_VICULA_ALUNO "
		sql = sql & " where cod_solicitacao_transporte = " & codSolicitacao
		cnn.execute sql
		GravarLog sql
		
		sql="DELETE ste_solicitacao_transporte "
		sql = sql & " where codigo = " & codSolicitacao
		cnn.execute sql
		GravarLog sql
		
		strMensagem = "Registro exluído com sucesso!"
	elseif acao="CANCELA_SITUACAO" then
		codSolicitacao = request("txtCodSolicitacao")
		
		sql="update ste_solicitacao_transporte set cod_rota = null"
		sql = sql & ", usuario_efetivacao = null"
		sql = sql & ", situacao = 'R'"
		sql = sql & ", data_efetivacao = null"
		sql = sql & ", efetivacao = null"
		sql = sql & " where codigo = " & codSolicitacao
		cnn.execute sql
		GravarLog sql
		strMensagem = "Cancelamento com troca de situação executado com sucesso!"
	elseif acao="GRAVA_ALTERACAO" then
		codSolicitacao = request("txtCodSolicitacao")
		turno_estadual = request("turno_estadual")
		
		IF turno_estadual = "" OR turno_estadual = "0" THEN
			sql="update ste_solicitacao_transporte set turno_estadual = NULL"
		ELSE
			sql="update ste_solicitacao_transporte set turno_estadual = '" & turno_estadual & "'"
		END IF
		sql = sql & " where codigo = " & codSolicitacao
		RESPONSE.WRITE SQL
		cnn.execute sql
		GravarLog sql
		strMensagem = "Alteração efetuada com sucesso!"	
	elseif acao="GRAVA_ENCAMINHAMENTO" then
		cont =0
		
		codSolicitacao = request("txtCodSolicitacao")
		codRota = request("txtCodRota")
		codSituacao = request("txtCodSituacao")	
		obs = replace(request("txtObservacao"),"'","")
		
		sql = "select codigo_escola_estadual"
		sql = sql & " from ste_solicitacao_transporte "
		sql = sql & " WHERE codigo = " & codSolicitacao
		RS.OPEN SQL, CNN
		IF NOT RS.EOF THEN
			if not isnull(rs("codigo_escola_estadual")) then
				rede		= "E"
			else
				rede		= "M"
			end if
		end if
		rs.close
		
		sql="update ste_solicitacao_transporte set cod_rota = " & codRota
		sql = sql & ", usuario_efetivacao = '" & session("usuarioWeb") & "'"
		sql = sql & ", situacao = '" & codSituacao & "'"
		sql = sql & ", data_efetivacao = getdate()"
		sql = sql & ", efetivacao = 'S'"
		sql = sql & ", obs = '" & obs & "'"
		sql = sql & " where codigo = " & codSolicitacao
		cnn.execute sql
		GravarLog sql
		strMensagem = "Encaminhamento executado com sucesso!"

		if rede = "M" then
			if codSituacao = "D" then
				
				sql = "SELECT ano_letivo "
				sql = sql & " FROM STE_configura_alunos"
				RS.OPEN SQL, CNN
				IF NOT RS.EOF THEN
					intAnoLetivo		= Trim(RS("ano_letivo"))
				END IF
				RS.CLOSE
				
				sql = "SELECT cod_aluno, cod_turma, cod_empresa "
				sql = sql & " FROM ste_solicitacao_transporte"
				sql = sql & " WHERE codigo = " & codSolicitacao
				RS.OPEN SQL, CNN
				IF NOT RS.EOF THEN
					strCodAluno		= Trim(RS("cod_aluno"))
					intCodTurma			= Trim(RS("cod_turma"))
					strCod_empresa		= Trim(RS("cod_empresa"))
				END IF
				RS.CLOSE
				
				sql = " Insert into SCA_ROTA_VICULA_ALUNO (cod_empresa, cod_aluno, cod_solicitacao_transporte, codTurma, ano_letivo, Cod_Rota, usuario_incl, data_hora_incl)"
				sql = sql & " VALUES ("
				sql = sql & " " & strCod_empresa & ","
				sql = sql & " " & strCodAluno & ","
				sql = sql & " " & codSolicitacao & ","
				sql = sql & " " & intCodTurma & ","
				sql = sql & " " & intAnoLetivo & ","
				sql = sql & " " & codRota & ","
				sql = sql & " '" & session("usuarioweb") & "',"
				sql = sql & " getdate())"
				cnn.execute sql
				GravarLog sql
			
			end if
		end if
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		'cnn.rollbackTrans
		cnn.commitTrans
		
		if acao="CANCELA_SITUACAO" or acao="EXCLUIR_CADASTRO" or acao="GRAVA_ENCAMINHAMENTO" or acao="GRAVA_ALTERACAO" then
			%>
			<script>
				alert("<%=strMensagem%>");
				window.location='ste_transporte_acompanhamento.asp?cmbSetor=<%=intCodSetor%>&cmbSituacao=<%=strSituacao%>&cmbTurno=<%=intCodTurno%>&cmbEmpresa=<%=intCodEmpresa%>&cmbEscolaEstadual=<%=intCodEscolaEstadual%>&cmbRede=<%=strRede%>';
			</script>
			<%
			response.end
		end if
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>