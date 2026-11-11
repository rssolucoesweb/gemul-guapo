<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
response.Expires=0
Server.ScriptTimeOut = 5000
response.Buffer = false
strAnoCab = Trim(Request.QueryString("AnoLetivo"))
%>
<html>
<head>
<title><%=session("Titulo")%></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
</head>
<body>
<script src="js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="js/js_dragdrop.js"></script>

<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_formataCPF.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->
<!--#include file=includes/inc_aguarde.asp-->
<br>
<%
	dim intPagina

	
	strCod_empresa 			= Session("CodEmpresa")
	if request("txtCodEmpresa") <> "" then
		strCod_empresa			=	request("txtCodEmpresa")
	end if
	intAnoLetivoAtual	 		= Trim(Request("txtAnoLetivo"))
	intSemestreAtual	 		= Trim(Request("cmbSemestre"))
	
	intSemestreSession			= session("strSemestre")
	intAnoLetivoSession			= session("strAnoLetivo")	

	strPromoverAnoLetivo = request.form("cmbPromoverAnoLetivo")
	if strPromoverAnoLetivo = "S" then
		strAnoLetivoPromovido = intAnoLetivoAtual + 1
		intAnoLetivoAtual = strAnoLetivoPromovido
	else
		strAnoLetivoPromovido = intAnoLetivoAtual
		intAnoLetivoAtual = strAnoLetivoPromovido
	end if
	
	intCodTurma 			= Trim(Request("cmbTurma"))
	strCodAluno				= Trim(Request("txtCodAluno"))
	
	mostraNotas 			= Trim(Request.Form("mostraNotas"))
	if strCodAluno = "" then
		strCodAluno			=	Trim(Request.form("chkAluno"))
	end if
	
	
	strTituloRelatorio  	= "AMAI - Apoio e Monitoramento do Aluno Infrequente"
	
	sub mostraCabecalho()
	%>
	<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<%
	end Sub
	
	
	if intCodTurma <> "" then 
	
		sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma"
		sql = sql & " FROM SCA_TURMA "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
		sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
		SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & strCod_empresa
		sql = sql & " AND SCA_TURMA.Cod_Turma= " & intCodTurma
		RS.OPEN SQL, CNN
		IF not RS.EOF THEN
			intCodCurso 	= rs("cod_curso")
			intCodPeriodo 	= rs("cod_periodo")
			intCodTurno 	= rs("cod_turno")
			intSemestre 	= rs("cod_Semestre")
		END IF
		rs.close
	
	end if

	
	if trim(strCodAluno) <> "" then

		'VERIFICAÇÃO DE BLOQUEIO
		intCodAluno = strCodAluno
				
	
		sql = "SELECT A.Codigo,a.Nomealuno,a.Datanascimento, a.Logradouro, a.Numero_endereco, a.Comp_endereco, a.Bairroaluno, a.Cidaderesidencia, ufr.sigla as descUfresidencia,a.Cepresidencia, a.pai, a.mae, a.responsavel "
		sql = sql & " FROM SCA_ALUNO A "
		sql = sql & " LEFT JOIN SCF_UF UFR				ON UFR.CODIGO = A.UFRESIDENCIA "
		sql = sql & " Where A.codigo in (" & strCodAluno & ")"
		rs.open sql, cnn
		if rs.eof = false then
			while not rs.eof
				'dados pessoais
				strCodigo			= TRIM(rs("Codigo"))
				strNomealuno 		= TRIM(rs("Nomealuno"))
				strDatanascimento 	= formataDataAP(TRIM(rs("Datanascimento")))

				'endereço
				strEndereco 		= TRIM(rs("Logradouro"))
				strNumero_endereco 	= TRIM(rs("Numero_endereco"))
				strComp_endereco 	= TRIM(rs("Comp_endereco"))
				strBairro 			= TRIM(rs("Bairroaluno"))
				strMunicipio		= TRIM(rs("Cidaderesidencia")) 
				strUfresidencia 	= TRIM(rs("descUfresidencia"))
				if not isnull(strUfresidencia) and strUfresidencia<>"" then strMunicipio = strMunicipio & "/" & strUfresidencia
				strCepresidencia 	= TRIM(rs("Cepresidencia"))
				
				if not isnull(strNumero_endereco) and strNumero_endereco<>"" THEN
					strEndereco = strEndereco & ", " & strNumero_endereco & ", " & strComp_endereco
				end if
				if not isnull(strComp_endereco) and strComp_endereco<>"" THEN
					strEndereco = strEndereco & ", " & strComp_endereco
				end if
				
				'dados familiares
				strNomePai 				= TRIM(rs("Pai"))
				strNomeMae 				= TRIM(rs("Mae"))
				strNomeResponsavel 		= TRIM(rs("Responsavel"))
				
				strTurma = ""
				'aluno na turma
				sql = "select E.RAZAOSOCIAL AS empresa, e.MUNICIPIO, e.ENDERECO, e.BAIRRO, e.UF, e.CEP, at.codigo, AT.COD_TURMA, T.NomeTurma, T.Turmaaluno, C.DESCRICAO AS CURSO, p.Descricao as periodo, p.cod_periodo, tu.desc_turno as turno "
				sql = sql & " from SCA_ALUNO_TURMA AT"
				sql = sql & " INNER JOIN SCA_TURMA T ON AT.COD_TURMA = T.Cod_Turma  AND AT.ANO_LETIVO = T.AnoLetivo AND AT.SEMESTRE = T.Cod_Semestre AND AT.cod_empresa = T.cod_empresa "
				sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO = T.COD_PERIODO"
				sql = sql & " INNER JOIN SCA_CURSO C ON C.COD_CURSO = P.COD_CURSO"
				sql = sql & " INNER JOIN SCA_TURNO TU ON TU.COD_TURNO = T.COD_TURNO"
				sql = sql & " INNER JOIN SEG_EMPRESA E ON E.CODIGO = T.COD_EMPRESA"
				sql = sql & " where AT.COD_EMPRESA = " &  strCod_empresa
				sql = sql & " and 	AT.COD_ALUNO = " &  strCodigo
				sql = sql & " and 	AT.situacao = 'A'"
				sql = sql & " and 	AT.ANO_LETIVO = " & intAnoLetivoAtual
				sql = sql & " and 	AT.Semestre = " & intSemestreAtual
				sql = sql & " order by at.codigo desc"
				rsAux.open sql, cnn
				if not rsAux.eof then
					strTurma = rsAux("Turmaaluno") & " " & rsAux("NomeTurma")
					strCurso = rsAux("curso")
					strPeriodo = rsAux("periodo")
					strTurno = rsAux("turno")
					intCodPeriodo = rsAux("cod_periodo")
					empresa = rsAux("empresa")
					enderecoEmpresa = rsAux("ENDERECO") & ", " & rsAux("bairro") & ", Cep: " & rsAux("cep")
					municipioEmpresa = rsAux("municipio") & "/" & rsAux("uf")
				end if
				rsAux.close
				
				mostraCabecalho
				
				%>
				
				
				<table width="100%" align="center" cellpadding="0" cellspacing="0" border = "0">
				  <tr> 
					<td colspan="3" valign="top"> <table width="98%" align="center" cellpadding="0" cellspacing="0" class="tabela">
						<tr> 
						  <td height="14" colspan="2" class="celula"><strong>1 - DADOS DA ESCOLA</strong></td>
						</tr>
						<tr> 
						  <td width="23%" height="15" class="celula"><strong>Nome:</strong></td>
						  <td width="77%" class="celula"><%=empresa%></td>
						</tr>
						<tr> 
						  <td height="15" class="celula"><strong>Endere&ccedil;o:</strong></td>
						  <td class="celula"><%=enderecoEmpresa%>&nbsp</td>
						</tr>
						<tr> 
						  <td height="13" class="celula"><strong>Munic&iacute;pio:</strong></td>
						  <td class="celula"><%=municipioEmpresa%></td>
						</tr>
					  </table>
					  <br> <table width="98%" align="center" cellpadding="0" cellspacing="0" class="tabela">
						<tr> 
						  <td height="15" colspan="2" class="celula"><strong>2 - DADOS DE IDENTIFICA&Ccedil;&Atilde;O 
							DO ALUNO</strong></td>
						</tr>
						<tr> 
						  <td width="27%" height="15" class="celula"><strong>Data de nascimento:</strong></td>
						  <td class="celula"><%=strDatanascimento%>&nbsp;</td>
						</tr>
						<tr> 
						  <td height="15" class="celula"><strong>Filia&ccedil;&atilde;o - M&atilde;e</strong></td>
						  <td class="celula"><%=strNomeMae%>&nbsp;</td>
						</tr>
						<tr class="celula"> 
						  <td height="15" class="celula"><strong>Filia&ccedil;&atilde;o - Pai</strong></td>
						  <td class="celula"><%=strNomePai%>&nbsp;</td>
						</tr>
						<tr class="celula"> 
						  <td height="15" class="celula"><strong>Respons&aacute;vel:</strong></td>
						  <td class="celula"><%=strNomeResponsavel%>&nbsp;</td>
						</tr>
						<tr class="celula"> 
						  <td height="15" class="celula"><strong>Endere&ccedil;o residencial:</strong></td>
						  <td class="celula"><%=strEndereco%>&nbsp;</td>
						</tr>
						<tr class="celula"> 
						  <td height="15" class="celula"><strong>Bairro / Munic&iacute;pio:</strong></td>
						  <td class="celula"><%=strBairro%> - <%=strMunicipio%></td>
						</tr>
					  </table>
					  <br> <table width="98%" align="center" cellpadding="0" cellspacing="0" class="tabela" >
						<tr> 
						  <td height="16" colspan="6" class="celula"><strong>3 - HIST&Oacute;RICO 
							DA SITUA&Ccedil;&Atilde;O DO ALUNO</strong></td>
						</tr>
						<tr class="celula"> 
						  <td width="24%" height="15" class="celula"><strong>Nome:</strong></td>
						  <td colspan="5" class="celula"><%=strNomeAluno%>&nbsp;</td>
						</tr>
						<tr> 
						  <td class="celula"><strong>Curso/S&eacute;rie:</strong></td>
						  <td class="celula"><%=strCurso%>&nbsp;</td>
						  <td class="celula"><strong>Turma:</strong></td>
						  <td class="celula"><%=strTurma%>&nbsp;</td>
						  <td class="celula"><strong>Turno:</strong></td>
						  <td class="celula"><%=strTurno%>&nbsp;</td>
						</tr>
						<tr> 
						  <td height="30" colspan="6" class="celula"><strong>Datas das Faltas:<br>
							____/____/______ - ____/____/______ - ____/____/______</strong></td>
						</tr>
						<tr class="celula"> 
						  <td height="15" colspan="6" class="celula"><strong>Professor regente 
							da turma ou disciplina:</strong></td>
						</tr>
						<tr class="celula"> 
						  <td height="19" colspan="6" class="celula"><strong>Data de comunica&ccedil;&atilde;o 
							da equipe &agrave; escola: ____/____/______</strong></td>
						</tr>
						<tr class="celula"> 
						  <td height="14" colspan="6" class="celula"><strong>Assinatura do Professor:</strong></td>
						</tr>
					  </table>
					  <br> <table width="98%" height="252" class="tabela"align="center" cellpadding="0" cellspacing="0">
						<tr> 
						  <td height="15" class="celula"><strong>4 - MEDIDAS TOMADAS PELA ESCOLA</strong><span class="celula"></span></td>
						</tr>
						<tr> 
						  <td height="15" class="celula"><strong>4.1 - Forma de convoca&ccedil;&atilde;o 
							dos pais ou respons&aacute;veis: </strong></td>
						</tr>
						<tr> 
						  <td height="23" class="celula">&nbsp;</td>
						</tr>
						<tr> 
						  <td height="20" class="celula"><strong>4.2 - Data de comparecimento 
							dos pais ou respons&aacute;veis: ____/____/______</strong></td>
						</tr>
						<tr class="celula"> 
						  <td height="15" class="celula"><strong>4.3 - Motivos alegados para as 
							faltas:</strong></td>
						</tr>
						<tr> 
						  <td height="45" class="celula">&nbsp;</td>
						</tr>
						<tr> 
						  <td height="15" class="celula"><strong>4.4 - Encaminhamentos feitos 
							pela escola : </strong></td>
						</tr>
						<tr> 
						  <td height="53" class="celula">&nbsp;</td>
						</tr>
						<tr> 
						  <td height="21" class="celula"><strong>Retorno do aluno &agrave; escola 
							em: ____/____/______</strong></td>
						</tr>
						<tr> 
						  <td height="19" class="celula"><strong>Assinatura do(a) <%=session("strNomenclaturaDiretor")%>: 
							</strong></td>
						</tr>
					  </table>
					  <table width="98%" align="center" cellpadding="0" cellspacing="0" class="tabela">
						<tr> 
						  <td height="15" class="celula"><strong>5 - CASO O ALUNO N&Atilde;O RETORNE 
							&Agrave; ESCOLA</strong></td>
						</tr>
						<tr> 
						  <td height="32" class="celula"><strong>Encaminhamento do AMAI ao Conselho 
							Tutelar em: <br>
							____/____/______</strong></td>
						</tr>
						<tr> 
						  <td height="15" class="celula"><strong>Atendimento e medidas aplicadas 
							pelo Conselho Tutelar: </strong></td>
						</tr>
						<tr> 
						  <td height="68" class="celula">&nbsp;</td>
						</tr>
						<tr> 
						  <td height="20" class="celula"><strong>Devolu&ccedil;&atilde;o do AMAI 
							em: ____/____/______</strong></td>
						</tr>
						<tr> 
						  <td height="15" class="celula"><strong>Assinatura do Conselho Tutelar:</strong></td>
						</tr>
						<tr> 
						  <td height="23" class="celula"><strong>Encaminhamento ao Minist&eacute;rio 
							P&uacute;blico em: ____/____/______</strong></td>
						</tr>
					  </table></td>
					<td width="53%" valign="top"><table width="98%" height="349" class="tabela"align="center" cellpadding="0" cellspacing="0">
						<tr> 
						  <td height="15" class="celula"><strong>6 - MINIST&Eacute;RIO P&Uacute;BLICO</strong></td>
						</tr>
						<tr> 
						  <td height="20" class="celula"><strong>S&iacute;ntese do atendimento 
							do Minist&eacute;rio P&uacute;blico: </strong></td>
						</tr>
						<tr> 
						  <td height="105" class="celula">&nbsp;</td>
						</tr>
						<tr> 
						  <td height="32" class="celula"><strong>Devolu&ccedil;&atilde;o do AMAI 
							&agrave; Escola e comunica&ccedil;&atilde;o ao Conselho Tutelar em: 
							<br>
							____/____/______</strong></td>
						</tr>
						<tr> 
						  <td height="21" class="celula"><strong>Ajuizado em: ____/____/______</strong></td>
						</tr>
						<tr> 
						  <td height="21" class="celula"><strong>Motivo do arquivamento:</strong></td>
						</tr>
						<tr> 
						  <td height="99" class="celula">&nbsp;</td>
						</tr>
						<tr> 
						  <td height="18" class="celula"><strong>Assinatura do Promotor de Justi&ccedil;a:</strong></td>
						</tr>
						<tr> 
						  <td height="16" class="celula">&nbsp;</td>
						</tr>
					  </table>
					  <table width="98%" height="110"  class="tabela" align="center" cellpadding="0" cellspacing="0">
						<tr> 
						  <td height="30" class="celula"><strong>7 - REGISTRO DE CONHECIMENTO 
							DA ESCOLA E ENCAMINHAMENTO &Agrave; SECRETARIA DA EDUCA&Ccedil;&Atilde;O</strong></td>
						</tr>
						<tr> 
						  <td height="19" class="celula"><strong>Retorno do AMAI em: ____/____/______</strong></td>
						</tr>
						<tr> 
						  <td height="19" class="celula"><strong>Encaminhamento &agrave; Subsecretaria 
							em: ____/____/______</strong></td>
						</tr>
						<tr> 
						  <td height="14" class="celula">&nbsp;</td>
						</tr>
						<tr> 
						  <td height="18" class="celula"><strong>Assinatura do(a) <%=session("strNomenclaturaDiretor")%>:</strong></td>
						</tr>
					  </table>

					  <br>
					  <br>
					  <br>
					  <table width="98%" height="303" class="tabela" align="center" cellpadding="0" cellspacing="0">
						<tr> 
						  <td height="15" class="celula"><div align="center"><strong>INSTRU&Ccedil;&Otilde;ES 
							  DE PREENCHIMENTO</strong></div></td>
						</tr>
						<tr> 
						  <td class="celula"><div align="justify"><strong>Este instrumento destina 
							  - se ao acompanhamento do Aluno Infrequente, devendo </strong><strong>ser 
							  preenchido em</strong> <strong>3 vias.</strong></div></td>
						</tr>
						<tr> 
						  <td height="17" class="celula"><strong><u>Campo 1, 2 ,3</u></strong> 
							- A ser preenchido pelo professor ou equipe pedag&oacute;gica da unidade 
							escolar.</td>
						</tr>
						<tr> 
						  <td class="celula"><strong><u>Campo 4</u></strong> - Procedimentos a 
							serem tomados pela Equipe de Apoio ao Aluno Infrequente(<%=session("strNomenclaturaDiretor")%>, coordenadores, 
							professores e Conselho Escolar).<br>
							4.1 - Informar qual a forma utilizada pela escola no contato com a 
							fam&iacute;lia (visita, carta, telefone, etc).<br>
							4.2 - Registrar a data de comparecimento dos pais ou respons&aacute;veis<br>
							4.3 - Registrar com clareza as informa&ccedil;&otilde;es coletadas 
							sobre o motivo da infrequ&ecirc;ncia do aluno.<br>
							4.4 - Informar as medidas tomadas pela escola juntamente com a fam&iacute;lia 
							para retorno do aluno.</td>
						</tr>
						<tr> 
						  <td height="108" class="celula"><div align="justify"><strong><u>Campo 
							  5</u></strong> - N&atilde;o obtendo sucesso, o <%=session("strNomenclaturaDiretor")%> ou Presidente 
							  do Conselho Escolar dever&aacute; encaminhar a 2&ordf; e 3&ordf; 
							  <em>vias</em> do AMAI ao Conselho Tutelar. Quando da n&atilde;o 
							  exist&ecirc;ncia deste encaminhar &agrave; Promotoria P&uacute;blica 
							  da respectiva comarca. Obtendo &ecirc;xito, o Conselho Tutelar ou 
							  Promotoria P&uacute;blica retornar&aacute; a 2&ordf;<em>via</em> 
							  &agrave; escola com as anota&ccedil;&otilde;es das provid&ecirc;ncias 
							  adotadas, permanecendo a 3&ordf; <em>via</em> arquivada no Conselho 
							  Tutelar. N&atilde;o obtendo &ecirc;xito encaminhar&aacute; a 3&ordf; 
							  <em>via</em> ao Minist&eacute;rio P&uacute;blico, informando &agrave; 
							  escola. Obs.: O Per&iacute;odo m&aacute;ximo para as dilig&ecirc;ncias 
							  do Conselho Tutelar &eacute; de 02 (duas) semanas.</div></td>
						</tr>
						<tr> 
						  <td height="29" class="celula"><strong><u>Campo 6</u></strong> - O Minist&eacute;rio 
							P&uacute;blico, tomadas as provid&ecirc;ncias cab&iacute;veis, dever&aacute; 
							remeter <strong><em>c&oacute;pias da 3&ordf; via</em></strong> &agrave; 
							escola e ao Conselho Tutelar para que tomem conhecimento do que foi 
							providenciado.</td>
						</tr>
					  </table></td>
				  </tr>
				</table>
				<%
				rs.movenext
				if not rs.eof then
					%>
					<pre>&nbsp;</pre>				
					<%			
				end if
			wend
		end if 
		rs.close
	else
		%>
		<script>
			alert("Aluno não foi encontrato, verifique.");
			window.history.back();
		</script>
		<%
		response.end
	end if 
	%>
	<script>
		aguarde.style.display="none";
	</script>
</body>
</html>