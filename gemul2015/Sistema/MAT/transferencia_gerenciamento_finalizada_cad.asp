<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 21/01/2020
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: transferencia
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<!--#include file="../../js/Calendario/Calendario.asp"-->

<%
	strSituacao 		 = "A"
	strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir'
	strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar
	strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
	strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'

	strExecutarSubmitCurso = "S"
	strExecutarSubmitPeriodo = "S"
	strExecutarSubmitTurno = "S"

	pagina	= "transferencia_cad.asp"
	strPaginaTitulo	= "transferencia_cad.asp"
	
	strCod_empresa 		= Session("CodEmpresa")
	intInscricao		= Trim(Request("txtInscricao"))
	cod_transferencia	= Trim(Request("cod_transferencia"))
	strCodAluno			= Trim(Request("txtCodAluno"))
	strMatricula 		= Trim(Request("txtMatricula"))
	strNomealuno 		= Trim(Request("txtNomealuno"))
	marcou4opcao 		= Trim(Request.form("4_opcao"))
	if marcou4opcao="S" then
		marcou4opcao = "style='display:table-row'"
		marcou4opcao_marcacao = "checked"
	else
		marcou4opcao = "style='display:none'"
		marcou4opcao_marcacao = ""
	end if
	acompanhamentoSocial = Trim(Request.Form("acompanhamentoSocial"))
	descricaoAcompanhamentoSocial = Trim(Request.Form("descricaoAcompanhamentoSocial"))

	quantidadeIrmao = request.Form("quantidadeIrmao")
	if quantidadeIrmao = "" then quantidadeIrmao = "0"
	
	irmaoNaEscola = request.Form("irmaoNaEscola")
	
	intCodEmpresa1opcao = request.Form("cmbEmpresa1opcao")
	if intCodEmpresa1opcao = "" then intCodEmpresa1opcao = "0"
	intCodEmpresa2opcao = request.Form("cmbEmpresa2opcao")
	if intCodEmpresa2opcao = "" then intCodEmpresa2opcao = "0"
	intCodEmpresa3opcao = request.Form("cmbEmpresa3opcao")
	if intCodEmpresa3opcao = "" then intCodEmpresa3opcao = "0"
	intCodEmpresa4opcao = request.Form("cmbEmpresa4opcao")
	if intCodEmpresa4opcao = "" then intCodEmpresa4opcao = "0"
	
	strVerificaRegiao = "S"
	strMostraIntegral = "S"

	sql = "select parecer_integral, travar_regiao, ano_letivo from MAT_configura_transferencia"
	rsAux.open sql, cnn
	if not rsAux.eof then
		strVerificaRegiao = rsAux("travar_regiao")
		strMostraIntegral = rsAux("parecer_integral")
		ano_letivo = rsAux("ano_letivo")
	end if
	rsAux.close	
	strLinhaIrmao = ""
	if cod_transferencia <> "" then
	
		sql = "Select t.codigo" 
		sql = sql & " ,t.situacao"
		sql = sql & " ,t.matricula"
		sql = sql & " ,t.cod_aluno"
		sql = sql & " ,t.nome"
		sql = sql & " ,t.bairro"
		sql = sql & " ,t.curso"
		sql = sql & " ,t.periodo"
		sql = sql & " ,t.turno"
		sql = sql & " ,t.acompanhamento_social"
		sql = sql & " ,t.descricao_acompanhamento_social"
		sql = sql & " ,t.irmao_escola"
		sql = sql & " ,t.qtde_irmao_escola"
		sql = sql & " ,t.Cod_empresa_1opcao"
		sql = sql & " ,t.Cod_empresa_2opcao"
		sql = sql & " ,t.Cod_empresa_3opcao"
		sql = sql & " ,t.Cod_empresa_3opcao"
		sql = sql & " ,t.Cod_empresa"
		sql = sql & " ,e1.razaosocial as empresa1"
		sql = sql & " ,e2.razaosocial as empresa2"
		sql = sql & " ,e3.razaosocial as empresa3"
		sql = sql & " ,ea.razaosocial as empresa_atual"
		sql = sql & " from mat_transferencia t "
		sql = sql & " left  join seg_empresa e1 on e1.codigo = t.cod_empresa_1opcao"
		sql = sql & " left  join seg_empresa e2 on e2.codigo = t.cod_empresa_2opcao"
		sql = sql & " left  join seg_empresa e3 on e3.codigo = t.cod_empresa_3opcao"
		sql = sql & " left  join seg_empresa ea on ea.codigo = t.cod_empresa"
		sql = sql & " where t.codigo = " & cod_transferencia
		rs.open sql, cnn
		if rs.eof = false then
			strSituacao 		= rs("situacao")
			strCodAluno			= Trim(rs("cod_aluno"))
			strMatricula 		= Trim(rs("Matricula"))
			strNomealuno 		= Trim(rs("nome"))

			strBairroAluno		  	= rs("bairro")
			strCursoAluno			= rs("curso")
			strPeriodoAluno			= rs("periodo")
			periodos				= rs("periodo")
			strTurnoAluno			= rs("turno")
			
			acompanhamentoSocial	= rs("acompanhamento_social")
			descricaoAcompanhamentoSocial= rs("descricao_acompanhamento_social")
			irmaoNaEscola			= rs("irmao_escola")
			quantidadeIrmao			= rs("qtde_irmao_escola")
			intCodEmpresa			= rs("Cod_empresa")
			intCodEmpresa1opcao		= rs("Cod_empresa_1opcao")
			intCodEmpresa2opcao		= rs("Cod_empresa_2opcao")
			intCodEmpresa3opcao		= rs("Cod_empresa_3opcao")
			
			empresa_atual	= rs("empresa_atual")
			empresa1		= rs("empresa1")
			empresa2		= rs("empresa2")
			empresa3		= rs("empresa3")
			
			strDesabilitaIncluir = "" 'Desabilita o botão Incluir'
			strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar
			strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
			strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
			
			strLinhaIrmao =  "style='display:none'"
			
			rs.close
		else
			rs.close
			%>
			<script>
				alert("transferencia não foi encontrada.");
				window.location='Transferencia_Acompanhamento_con.asp'
			</script>
			<%
			response.end
		end if
	end if
	
	marcaIrmaoEscola = ""
	mostraLinhaQtdeIrmao = "display:none"
	if trim(irmaoNaEscola) = "S" then 
		marcaIrmaoEscola = "checked"
		mostraLinhaQtdeIrmao = "display:table-row"
	end if
	
	mostraLinhaAcompanhamentoSocial = "display:none"
	if trim(acompanhamentoSocial) = "S" then 
		mostraLinhaAcompanhamentoSocial = "display:table-row"
	end if
	
	
%>
<form method="post" id="frm" action="transferencia_gerenciamento_cad.asp">
<input name="cod_transferencia" type="hidden" id="cod_transferencia" value="<%=cod_transferencia%>">
<input name="cod_empresa_atual" type="hidden" id="cod_empresa_atual" value="<%=intCodEmpresa%>">
<input name="txtCodAluno" type="hidden" id="txtCodAluno" value="<%=strCodAluno%>">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
        <tr valign="top">
           <td width="100%" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
        </tr>
		<tr valign="top">
		  <td align="center" valign="top">
		  
			  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
				<tr>
				  <td height="26" class="texto1">&nbsp;</td>
				  <td colspan="5">&nbsp;</td>
			    </tr>
				<tr bgcolor="#7DBEFF">
				  <td width="14%" height="26" class="texto1"><strong>Matr&iacute;cula:</strong></td>
				  <td colspan="5" class="texto1"><strong><%=strMatricula%> - <%=strNomealuno%></strong></td>
				</tr>
				<tr>
				  <td height="26" class="texto1">Unidade Atual</td>
				  <td colspan="5" class="texto1"><strong><%=empresa_atual%></strong>&nbsp;</td>
			    </tr>
				<tr>
				  <td height="26" class="texto1">Bairro do Aluno</td>
				  <td colspan="5" class="texto1"><strong><%=strBairroAluno%></strong>&nbsp;<input name="txtBairro" type="hidden" id="txtBairro" value="<%=strBairroAluno%>"></td>
			    </tr>
				<tr bgcolor="#CCCCCC">
				  <td height="26" colspan="6" class="texto1"><strong>&nbsp;Dados da Transfer&ecirc;ncia Solicitada </strong></td>
			    </tr>
				<tr>
				  <td height="26" class="texto1">Curso/Período:</td>
				  <td colspan="5" class="texto1"><strong><%=replace(strCursoAluno,"_"," ")%> - <%=replace(strPeriodoAluno,"_"," ")%> | <strong><%=replace(strTurnoAluno,"_"," ")%></strong></strong></td>
			    </tr>
				<tr>
				  <td height="26" class="texto1">Acompanhamento social:</td>
				  <td colspan="5" class="texto1"><strong><%if trim(acompanhamentoSocial) = "S" then%>Sim<%else%>Não<%end if%></strong></td>
			    </tr>
				<tr id="linhaAcompanhamentoSocial" style="<%=mostraLinhaAcompanhamentoSocial%>">
				  <td height="26" class="texto1">Descrição: </td>
				  <td colspan="5" class="texto1"><%=descricaoAcompanhamentoSocial%></td>
			    </tr>
				
				<!-- INICIO CONSULTA VAGAS -->
				<tr bgcolor="#CCCCCC">
				  <td height="26" colspan="2" rowspan="2" class="texto1"><strong>&nbsp;Opções escolhida por <%=strNomealuno%></strong></td>
			      <td width="7%" rowspan="2" class="texto1"><strong>PER&Iacute;ODO</strong></td>
			      <td height="12" colspan="3" class="texto1"><div align="center"><strong>VAGAS DISPON&Iacute;VEIS </strong></div></td>
			    </tr>
				<tr bgcolor="#CCCCCC">
				  <td width="10%" height="12" class="texto1"><div align="center"><strong>MATUTINO</strong></div></td>
			      <td width="9%" class="texto1"><div align="center"><strong>VESPERTINO</strong></div></td>
				  <td width="9%" class="texto1"><div align="center"><strong>INTEGRAL</strong></div></td>
				</tr>
				<tr bgcolor="#8AFFC5">
				  <td height="26" class="texto1">Unidade 1&ordf; op&ccedil;&atilde;o: </td>
				  <td width="51%" class="texto1"><strong><%=empresa1%></strong></td>
			      <td colspan="4" class="texto1">
				  <table width="100%" border="0" cellspacing="0" cellpadding="0">
					<% 
					sql = "EXEC [SP_consulta_vagas_para_transferencia] " & intCodEmpresa1opcao & "," & ano_letivo
					vetUnd1 = null
					rs.open sql, cnn
					if not rs.eof then
						vetUnd1 = rs.getRows
					end if
					rs.close

					if isArray(vetUnd1) then
						
						for i=0 to ubound(vetUnd1,2)
							periodo = replace(vetUnd1(0,i)," ","_")
							if inStr(periodos, periodo) <> "0" then
								id_chave_matutino 	= right("0000" & cInt(intCodEmpresa1opcao),5) & "_MATUTINO__" & Left(replace(vetUnd1(0,i)," ","_") & "                              ",30)
								id_chave_vespertino = right("0000" & cInt(intCodEmpresa1opcao),5) & "_VESPERTINO" & Left(replace(vetUnd1(0,i)," ","_") & "                              ",30)
								id_chave_integral 	= right("0000" & cInt(intCodEmpresa1opcao),5) & "_INTEGRAL__" & Left(replace(vetUnd1(0,i)," ","_") & "                              ",30)
								
								%>
								<tr>
								  <td class="texto1" width="21%"><%=vetUnd1(0,i)%></td>
								  <td align="center" class="texto1" width="27%"><%=vetUnd1(1,i)%>&nbsp;<%=existe_matutino%></td>
								  <td align="center" class="texto1" width="26%"><%=vetUnd1(3,i)%>&nbsp;<%=existe_vespertino%></td>
								  <td align="center" class="texto1" width="26%"><%=vetUnd1(5,i)%>&nbsp;<%=existe_integral%></td>
								</tr>
								<%
							end if
						next
					end if
					%>
                  </table>				  </td>
		        </tr>
				<tr bgcolor="#B7FFDB">
				  <td height="26" class="texto1">Unidade 2&ordf; op&ccedil;&atilde;o:</td>
				  <td class="texto1"><strong><%=empresa2%></strong></td>
			      <td colspan="4" class="texto1">
				  <%IF intCodEmpresa2opcao <>"" AND intCodEmpresa2opcao<>"0" THEN%>
				  <table width="100%" border="0" cellspacing="0" cellpadding="0">
					<% 
					sql = "EXEC [SP_consulta_vagas_para_transferencia] " & intCodEmpresa2opcao & "," & ano_letivo
					vetUnd2 = null
					rs.open sql, cnn
					if not rs.eof then
						vetUnd2 = rs.getRows
					end if
					rs.close
					
					if isArray(vetUnd2) then
						for i=0 to ubound(vetUnd2,2)
							periodo = replace(vetUnd2(0,i)," ","_")
							if inStr(periodos, periodo) <> "0" then
								id_chave_matutino 	= right("0000" & cInt(intCodEmpresa2opcao),5) & "_MATUTINO__" & Left(replace(vetUnd2(0,i)," ","_") & "                              ",30)
								id_chave_vespertino = right("0000" & cInt(intCodEmpresa2opcao),5) & "_VESPERTINO" & Left(replace(vetUnd2(0,i)," ","_") & "                              ",30)
								id_chave_integral 	= right("0000" & cInt(intCodEmpresa2opcao),5) & "_INTEGRAL__" & Left(replace(vetUnd2(0,i)," ","_") & "                              ",30)
								
								%>
								<tr>
								  <td class="texto1" width="21%"><%=vetUnd2(0,i)%></td>
								  <td align="center" class="texto1" width="27%"><%=vetUnd2(1,i)%>&nbsp;<%=existe_matutino%></td>
								  <td align="center" class="texto1" width="26%"><%=vetUnd2(3,i)%>&nbsp;<%=existe_vespertino%></td>
								  <td align="center" class="texto1" width="26%"><%=vetUnd2(5,i)%>&nbsp;<%=existe_integral%></td>
								</tr>
								<%
							end if
						next
					end if
					%>
                  </table>
				  <%END IF%>				  </td>
		        </tr>
				<tr bgcolor="#CCFFE6">
				  <td height="26" class="texto1">Unidade 3&ordf; op&ccedil;&atilde;o:</td>
				  <td class="texto1"><strong><%=empresa3%></strong></td>
			      <td colspan="4" class="texto1">
				  <%IF intCodEmpresa3opcao <>"" AND intCodEmpresa3opcao<>"0" THEN%>
				  <table width="100%" border="0" cellspacing="0" cellpadding="0">
					<% 
					sql = "EXEC [SP_consulta_vagas_para_transferencia] " & intCodEmpresa3opcao & "," & ano_letivo
					vetUnd3 = null
					rs.open sql, cnn
					if not rs.eof then
						vetUnd3 = rs.getRows
					end if
					rs.close
					
					if isArray(vetUnd3) then
						for i=0 to ubound(vetUnd3,2)
							periodo = replace(vetUnd3(0,i)," ","_")
							if inStr(periodos, periodo) <> "0" then
								id_chave_matutino 	= right("0000" & cInt(intCodEmpresa3opcao),5) & "_MATUTINO__" & Left(replace(vetUnd3(0,i)," ","_") & "                              ",30)
								id_chave_vespertino = right("0000" & cInt(intCodEmpresa3opcao),5) & "_VESPERTINO" & Left(replace(vetUnd3(0,i)," ","_") & "                              ",30)
								id_chave_integral 	= right("0000" & cInt(intCodEmpresa3opcao),5) & "_INTEGRAL__" & Left(replace(vetUnd3(0,i)," ","_") & "                              ",30)
								
								%>
								<tr>
								  <td class="texto1" width="21%"><%=vetUnd3(0,i)%></td>
								  <td align="center" class="texto1" width="27%"><%=vetUnd3(1,i)%>&nbsp;<%=existe_matutino%></td>
								  <td align="center" class="texto1" width="26%"><%=vetUnd3(3,i)%>&nbsp;<%=existe_vespertino%></td>
								  <td align="center" class="texto1" width="26%"><%=vetUnd3(5,i)%>&nbsp;<%=existe_integral%></td>
								</tr>
								<%
							end if
						next
					end if
					%>
                  </table>
  				  <%END IF%>				  </td>
		        </tr>
				<tr>
				  <td height="15" class="texto1" colspan="6"></td>
			    </tr>				
				
				<tr id="linhaQtdeIrmaoEscola" style="<%=mostraLinhaQtdeIrmao%>" <%=strLinhaIrmao%>>
				  <td colspan="6" height="26" class="texto1">Quantidade de irmão na mesma unidade: <strong><%=quantidadeIrmao%></strong></td>
			    </tr>

				<!-- IRMAOS -->
				<%if quantidadeIrmao > 0 then%>
				<tr id="linhaQtdeIrmaoEscola1" bgcolor="#CCCCCC">
				  <td height="26" colspan="6" class="texto1"><strong>&nbsp;Dados informados dos irmãos </strong></td>
			    </tr>
				<%end if%>
				<%
				
				if quantidadeIrmao = "" then quantidadeIrmao = "0"
				if isnull(quantidadeIrmao) then quantidadeIrmao = "0"
				
				if quantidadeIrmao>0 then
					cont=1
					cod_irmaos = ""
					sql = "select cod_aluno, matricula, nome, curso, periodo, turno"
					sql = sql & " from mat_transferencia_irmao_escola"
					sql = sql & " where cod_transferencia = " & cod_transferencia
					rsAux.open sql, cnn
					if not rsAux.eof then
						while not rsAux.eof
							if cod_irmaos = "" then
								cod_irmaos					= rsAux("cod_aluno")
							else
								cod_irmaos					= cod_irmaos & "," & rsAux("cod_aluno")
							end if
							intCodAlunoIrmao 			= rsAux("cod_aluno")
							strMatriculaAlunoIrmao		= rsAux("matricula")
							strNomeAlunoIrmao 			= rsAux("nome")
							strCursoAlunoIrmao			= rsAux("curso")
							strPeriodoAlunoIrmao		= rsAux("periodo")
							strTurnoAlunoIrmao			= rsAux("turno")
							periodos					= strPeriodoAlunoIrmao
							%>
							<tr class="linhaDadosIrmaoEscola" bgcolor="#7DBEFF">
							  <td width="14%" height="26" class="texto1">Matr&iacute;cula do <%=cont%>º irmão:</td>
							  <td colspan="5" class="texto1"><strong><%=strMatriculaAlunoIrmao%> - <%=strNomeAlunoIrmao%></strong></td>
							</tr>
							<tr class="linhaDadosIrmaoEscola">
							  <td height="26" class="texto1">Curso do <%=cont%>º irmão:</td>
							  <td colspan="5" class="texto1"><strong><%=replace(strCursoAlunoIrmao,"_"," ")%> - <%=replace(strPeriodoAlunoIrmao,"_"," ")%> | <%=strTurnoAlunoIrmao%></strong></td>
							</tr>
							
							<!-- INICIO CONSULTA VAGAS -->
							<tr bgcolor="#CCCCCC">
							  <td height="26" colspan="2" rowspan="2" class="texto1"><strong>&nbsp;Opções escolhida por <%=strNomeAlunoIrmao%></strong></td>
							  <td width="7%" rowspan="2" class="texto1"><strong>PER&Iacute;ODO</strong></td>
							  <td height="12" colspan="3" class="texto1"><div align="center"><strong>VAGAS DISPON&Iacute;VEIS </strong></div></td>
							</tr>
							<tr bgcolor="#CCCCCC">
							  <td width="10%" height="12" class="texto1"><div align="center"><strong>MATUTINO</strong></div></td>
							  <td width="9%" class="texto1"><div align="center"><strong>VESPERTINO</strong></div></td>
							  <td width="9%" class="texto1"><div align="center"><strong>INTEGRAL</strong></div></td>
							</tr>
							<tr bgcolor="#8AFFC5">
							  <td height="26" class="texto1">Unidade 1&ordf; op&ccedil;&atilde;o: </td>
							  <td width="51%" class="texto1"><strong><%=empresa1%></strong></td>
							  <td colspan="4" class="texto1">
							  <table width="100%" border="0" cellspacing="0" cellpadding="0">
								<% 
								if isArray(vetUnd1) then
									for i=0 to ubound(vetUnd1,2)
										periodo = replace(vetUnd1(0,i)," ","_")
										if inStr(periodos, periodo) <> "0" then
											id_chave_matutino 	= right("0000" & cInt(intCodEmpresa1opcao),5) & "_MATUTINO__" & Left(replace(vetUnd1(0,i)," ","_") & "                              ",30)
											id_chave_vespertino = right("0000" & cInt(intCodEmpresa1opcao),5) & "_VESPERTINO" & Left(replace(vetUnd1(0,i)," ","_") & "                              ",30)
											id_chave_integral 	= right("0000" & cInt(intCodEmpresa1opcao),5) & "_INTEGRAL__" & Left(replace(vetUnd1(0,i)," ","_") & "                              ",30)
											
										%>
										<tr>
										  <td class="texto1" width="21%"><%=vetUnd1(0,i)%></td>
										  <td align="center" class="texto1" width="27%"><%=vetUnd1(1,i)%>&nbsp;<%=existe_matutino%></td>
										  <td align="center" class="texto1" width="26%"><%=vetUnd1(3,i)%>&nbsp;<%=existe_vespertino%></td>
										  <td align="center" class="texto1" width="26%"><%=vetUnd1(5,i)%>&nbsp;<%=existe_integral%></td>
										</tr>
										<%
										end if
									next
								end if
								vetUnd1 = null
								%>
							  </table>							  </td>
							</tr>
							<tr bgcolor="#B7FFDB">
							  <td height="26" class="texto1">Unidade 2&ordf; op&ccedil;&atilde;o:</td>
							  <td class="texto1"><strong><%=empresa2%></strong></td>
							  <td colspan="4" class="texto1">
							  <%IF intCodEmpresa3opcao <>"" AND intCodEmpresa3opcao<>"0" THEN%>
							  <table width="100%" border="0" cellspacing="0" cellpadding="0">
								<% 
								if isArray(vetUnd2) then
									for i=0 to ubound(vetUnd2,2)
										periodo = replace(vetUnd2(0,i)," ","_")
										if inStr(periodos, periodo) <> "0" then
											id_chave_matutino 	= right("0000" & cInt(intCodEmpresa2opcao),5) & "_MATUTINO__" & Left(replace(vetUnd2(0,i)," ","_") & "                              ",30)
											id_chave_vespertino = right("0000" & cInt(intCodEmpresa2opcao),5) & "_VESPERTINO" & Left(replace(vetUnd2(0,i)," ","_") & "                              ",30)
											id_chave_integral 	= right("0000" & cInt(intCodEmpresa2opcao),5) & "_INTEGRAL__" & Left(replace(vetUnd2(0,i)," ","_") & "                              ",30)
											
										%>
										<tr>
										  <td class="texto1" width="21%"><%=vetUnd2(0,i)%></td>
										  <td align="center" class="texto1" width="27%"><%=vetUnd2(1,i)%>&nbsp;<%=existe_matutino%></td>
										  <td align="center" class="texto1" width="26%"><%=vetUnd2(3,i)%>&nbsp;<%=existe_vespertino%></td>
										  <td align="center" class="texto1" width="26%"><%=vetUnd2(5,i)%>&nbsp;<%=existe_integral%></td>
										</tr>
										<%
										end if
									next
								end if
								%>
							  </table>
							  <%END IF%>							  </td>
							</tr>
							<tr bgcolor="#CCFFE6">
							  <td height="26" class="texto1">Unidade 3&ordf; op&ccedil;&atilde;o:</td>
							  <td class="texto1"><strong><%=empresa3%></strong></td>
							  <td colspan="4" class="texto1">
							  <%IF intCodEmpresa3opcao <>"" AND intCodEmpresa3opcao<>"0" THEN%>
							  <table width="100%" border="0" cellspacing="0" cellpadding="0">
								<% 
								if isArray(vetUnd3) then
									for i=0 to ubound(vetUnd3,2)
										periodo = replace(vetUnd3(0,i)," ","_")
										if inStr(periodos, periodo) <> "0" then
											id_chave_matutino 	= right("0000" & cInt(intCodEmpresa3opcao),5) & "_MATUTINO__" & Left(replace(vetUnd3(0,i)," ","_") & "                              ",30)
											id_chave_vespertino = right("0000" & cInt(intCodEmpresa3opcao),5) & "_VESPERTINO" & Left(replace(vetUnd3(0,i)," ","_") & "                              ",30)
											id_chave_integral 	= right("0000" & cInt(intCodEmpresa3opcao),5) & "_INTEGRAL__" & Left(replace(vetUnd3(0,i)," ","_") & "                              ",30)
											
											%>
											<tr>
											  <td class="texto1" width="21%"><%=vetUnd3(0,i)%></td>
											  <td align="center" class="texto1" width="27%"><%=vetUnd3(1,i)%>&nbsp;<%=existe_matutino%></td>
											  <td align="center" class="texto1" width="26%"><%=vetUnd3(3,i)%>&nbsp;<%=existe_vespertino%></td>
											  <td align="center" class="texto1" width="26%"><%=vetUnd3(5,i)%>&nbsp;<%=existe_integral%></td>
											</tr>
											<%
										end if
									next
								end if
								%>
							  </table>
							  <%END IF%>							  </td>
							</tr>
							<tr>
							  <td height="25" class="texto1" colspan="6"></td>
							</tr>
							<%
							cont=cont+1
							rsAux.movenext
						wend
					end if
					rsAux.close
				end if	
				%>
				<tr>
				  <td height="26" class="texto1" colspan="6"><input name="cod_irmaos" type="hidden" id="cod_irmaos" value="<%=cod_irmaos%>"></td>
			    </tr>
				<%
				if strSituacao = "F" then
				
					sql = "select t.matricula, t.nome, t.matricula_transferencia, e.razaosocial as unidade, t.turno_transferencia, t.periodo_transferencia, t.data_situacao, '' as irmao"
					sql = sql & " from mat_transferencia t"
					sql = sql & " inner join seg_empresa e on e.codigo = t.cod_empresa_transferencia"
					sql = sql & " where t.codigo = " & cod_transferencia
					sql = sql & " union"
					sql = sql & " select i.matricula, i.nome, i.matricula_transferencia, e.razaosocial as unidade, i.turno_transferencia, i.periodo_transferencia, t.data_situacao, 'S' as irmao "
					sql = sql & " from mat_transferencia_irmao_escola i"
					sql = sql & " inner join mat_transferencia t on t.codigo = i.cod_transferencia"
					sql = sql & " inner join seg_empresa e on e.codigo = i.cod_empresa_transferencia"
					sql = sql & " where i.cod_transferencia = " & cod_transferencia
					sql = sql & " order by irmao"
					rs.open sql, cnn
					if not rs.eof then
						%>
						<tr  bgcolor="#A9F5D0">
						  <td height="26" colspan="2" class="texto1"><strong>Dados da TRANSFERÊNCIA CONCLUÍDA</strong></td>
						</tr>
						<%
						while not rs.eof
							irmao = ""
							if rs("irmao") = "S" then
								irmao = " <u><b>(Irmão)</b></u>"
							end if
							
							%>
							<tr>
							  <td height="26" class="texto1">Aluno:</td>
							  <td class="texto1"><font color="#088A29"><strong><%=rs("matricula_transferencia")%> - <%=rs("nome")%><%=irmao%></strong></font></td>
							</tr>
							<tr>
							  <td height="26" class="texto1">Unidade transferido:</td>
							  <td class="texto1"><font color="#088A29"><strong><%=rs("unidade")%></strong></font></td>
							</tr>
							<tr>
							  <td height="26" class="texto1">Período transferido:</td>
							  <td class="texto1"><font color="#088A29"><strong><%=rs("periodo_transferencia")%></strong></font></td>
							</tr>
							<tr>
							  <td height="26" class="texto1">Turno transferido:</td>
							  <td class="texto1"><font color="#088A29"><strong><%=rs("turno_transferencia")%></strong></font></td>
							</tr>
							<tr>
							  <td height="26" class="texto1" colspan="2"><hr></td>
							</tr>
							<%
							rs.movenext
						wend
					end if
					rs.close
				end if
				%>
				
				
			  </table>
			<br>
			<br>
  		  </td>
		</tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>