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
<script>
	
	function verifica4Opcao(){
		var frm = document.getElementById("frm");
		frm.cmbEmpresa4opcao.value = "0"
		if (document.getElementById("4_opcao").checked){
			$(".linha4Opcao").show();	
		}else{
			$(".linha4Opcao").hide();	
		}
	}
	function salvar(acao){
		
		var frm = document.getElementById("frm");

		/*if (frm.txtMatricula.value == "") {
			alert("A Matricula do Aluno deve ser informada !");
			frm.txtMatricula.focus();
			return false;
		}
		if (frm.txtNomealuno.value == "") {
			alert("Aluno deve ser informado!");
			frm.txtMatricula.focus();
			return false;
		}
		if (frm.cmbCurso.value == "0") {
			alert("Selecione o curso para onde o aluno será transferido!");
			frm.cmbCurso.focus();
			return false;
		}		
		if (frm.cmbPeriodo.value == "0") {
			alert("Selecione o período para onde o aluno será transferido!");
			frm.cmbPeriodo.focus();
			return false;
		}		
		if (frm.cmbTurno.value == "0") {
			alert("Selecione o turno para onde o aluno será transferido!");
			frm.cmbTurno.focus();
			return false;
		}		
		if (frm.cmbEmpresa1opcao.value == "0") {
			alert("Selecione a unidade de 1ª opção para onde o aluno será transferido!");
			frm.cmbEmpresa1opcao.focus();
			return false;
		}		
		if (frm.cmbEmpresa2opcao.value!="0"){
			if (frm.cmbEmpresa1opcao.value == frm.cmbEmpresa2opcao.value) {
				alert("A unidade de 2ª opção para onde o aluno será transferido não poder igual a de 1ª opção!");
				frm.cmbEmpresa2opcao.focus();
				return false;
			}	
		}
		
		if (frm.cmbEmpresa3opcao.value!="0"){
			if (frm.cmbEmpresa1opcao.value == frm.cmbEmpresa3opcao.value) {
				alert("A unidade de 3ª opção para onde o aluno será transferido não poder igual a de 1ª opção!");
				frm.cmbEmpresa3opcao.focus();
				return false;
			}		
		}
		
		if (frm.cmbEmpresa2opcao.value!="0" && frm.cmbEmpresa3opcao.value!="0"){
			if (frm.cmbEmpresa2opcao.value == frm.cmbEmpresa3opcao.value) {
				alert("A unidade de 3ª opção para onde o aluno será transferido não poder igual a de 2ª opção!");
				frm.cmbEmpresa3opcao.focus();
				return false;
			}	
		}		
		
		if (frm.cmbEmpresa1opcao.value == <%=Session("CodEmpresa")%>) {
			alert("A unidade de 1ª opção para onde o aluno será transferido não poder igual a sua unidade de origem!");
			frm.cmbEmpresa1opcao.focus();
			return false;
		}
		if (frm.cmbEmpresa2opcao.value == <%=Session("CodEmpresa")%>) {
			alert("A unidade de 2ª opção para onde o aluno será transferido não poder igual a sua unidade de origem!");
			frm.cmbEmpresa1opcao.focus();
			return false;
		}
		if (frm.cmbEmpresa3opcao.value == <%=Session("CodEmpresa")%>) {
			alert("A unidade de 3ª opção para onde o aluno será transferido não poder igual a sua unidade de origem!");
			frm.cmbEmpresa1opcao.focus();
			return false;
		}
		*/
		frm.action="transferencia_gerenciamento_cod.asp?acao=T";
		frm.submit();
		return true;
	}

	function cancelar(codTransferencia){
		
		var frm = document.getElementById("frm");
		
		frm.action = "transferencia_cancelamento_cad.asp?cod_transferencia="+codTransferencia;
		frm.submit();
		return true;	
	}
	
	
</script>
<%


	strUsuarioLiberadoParaMatricularDireto = ""
	sql = "SELECT CODIGO_SEG_USUARIOS_SISTEMA"
	sql = sql & " FROM SEG_USUARIOS_INCLUI_CADASTRO"
	sql = sql & " Where cod_grupo = " & Session("CodGrupo")
	sql = sql & " and upper(CODIGO_SEG_USUARIOS_SISTEMA) = '" & ucase(trim(session("usuarioWeb"))) & "'"
	rs.open sql, cnn
	if rs.eof = false then
		strUsuarioLiberadoParaMatricularDireto = ucase(trim(session("usuarioWeb")))
	end if 
	rs.close

	if ucase(trim(session("usuarioWeb"))) = "SERGIO" OR ucase(trim(session("usuarioWeb"))) = "FERNANDO.DOMINGOS" THEN
		'liberado manualmente
	else
		if ucase(trim(session("usuarioWeb"))) <> strUsuarioLiberadoParaMatricularDireto then
			%>
			<script>
				alert("ATENÇÃO: Você não tem acesso para confirmação da transferência!");
				window.location='default.asp';
			</script>
			<%
			response.end
		end if	
	end if	

	strBotaoCancelarTransferencia = "S"
	strSituacao 		 = "A"
	strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir'
	strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar
	strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
	strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'

	strExecutarSubmitCurso = "S"
	strExecutarSubmitPeriodo = "S"
	strExecutarSubmitTurno = "S"

	pagina				= "transferencia_cad.asp"
	strPaginaTitulo		= "transferencia_cad.asp"
	
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

	if ano_letivo = "" then
			%>
			<script>
				alert("ATENÇÃO: O ano letivo de destino não foi configurado para a transferência, você será redirecionado para tela de criação!");
				window.location='configurarTransferencia_cad.asp';
			</script>
			<%
			response.end
	end if

	
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
           <td width="100%" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%> - <%=ano_letivo%></td>
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
			      <td height="12" colspan="3" class="texto1"><div align="center"><strong>VAGAS DISPON&Iacute;VEIS - <%=ano_letivo%></strong></div></td>
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
								
								existe_matutino 	= vetUnd1(2,i)
								if existe_matutino = "S" then
									existe_matutino = "<input name='opcao_marcada_" & strCodAluno & "' type='radio' value='" & id_chave_matutino & "'>"
								else
									existe_matutino = ""
								end if
								existe_vespertino 	= vetUnd1(4,i)
								if existe_vespertino = "S" then
									existe_vespertino = "<input name='opcao_marcada_" & strCodAluno & "' type='radio' value='" & id_chave_vespertino & "'>"
								else
									existe_vespertino = ""
								end if
								existe_integral 	= vetUnd1(6,i)
								if existe_integral = "S" then
									existe_integral = "<input name='opcao_marcada_" & strCodAluno & "' type='radio' value='" & id_chave_integral & "'>"
								else
									existe_integral = ""
								end if							
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
								
								existe_matutino 	= vetUnd2(2,i)
								if existe_matutino = "S" then
									existe_matutino = "<input name='opcao_marcada_" & strCodAluno & "' type='radio' value='" & id_chave_matutino & "'>"
								else
									existe_matutino = ""
								end if
								existe_vespertino 	= vetUnd2(4,i)
								if existe_vespertino = "S" then
									existe_vespertino = "<input name='opcao_marcada_" & strCodAluno & "' type='radio' value='" & id_chave_vespertino & "'>"
								else
									existe_vespertino = ""
								end if
								existe_integral 	= vetUnd2(6,i)
								if existe_integral = "S" then
									existe_integral = "<input name='opcao_marcada_" & strCodAluno & "' type='radio' value='" & id_chave_integral & "'>"
								else
									existe_integral = ""
								end if							
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
								
								existe_matutino 	= vetUnd3(2,i)
								if existe_matutino = "S" then
									existe_matutino = "<input name='opcao_marcada_" & strCodAluno & "' type='radio' value='" & id_chave_matutino & "'>"
								else
									existe_matutino = ""
								end if
								existe_vespertino 	= vetUnd3(4,i)
								if existe_vespertino = "S" then
									existe_vespertino = "<input name='opcao_marcada_" & strCodAluno & "' type='radio' value='" & id_chave_vespertino & "'>"
								else
									existe_vespertino = ""
								end if
								existe_integral 	= vetUnd3(6,i)
								if existe_integral = "S" then
									existe_integral = "<input name='opcao_marcada_" & strCodAluno & "' type='radio' value='" & id_chave_integral & "'>"
								else
									existe_integral = ""
								end if							
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
											
											existe_matutino 	= vetUnd1(2,i)
											if existe_matutino = "S" then
												existe_matutino = "<input name='opcao_marcada_" & intCodAlunoIrmao& "' type='radio' value='" & id_chave_matutino & "'>"
											else
												existe_matutino = ""
											end if
											existe_vespertino 	= vetUnd1(4,i)
											if existe_vespertino = "S" then
												existe_vespertino = "<input name='opcao_marcada_" & intCodAlunoIrmao& "' type='radio' value='" & id_chave_vespertino & "'>"
											else
												existe_vespertino = ""
											end if
											existe_integral 	= vetUnd1(6,i)
											if existe_integral = "S" then
												existe_integral = "<input name='opcao_marcada_" & intCodAlunoIrmao& "' type='radio' value='" & id_chave_integral & "'>"
											else
												existe_integral = ""
											end if	
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
											
											existe_matutino 	= vetUnd2(2,i)
											if existe_matutino = "S" then
												existe_matutino = "<input name='opcao_marcada_" & intCodAlunoIrmao& "' type='radio' value='" & id_chave_matutino & "'>"
											else
												existe_matutino = ""
											end if
											existe_vespertino 	= vetUnd2(4,i)
											if existe_vespertino = "S" then
												existe_vespertino = "<input name='opcao_marcada_" & intCodAlunoIrmao& "' type='radio' value='" & id_chave_vespertino & "'>"
											else
												existe_vespertino = ""
											end if
											existe_integral 	= vetUnd2(6,i)
											if existe_integral = "S" then
												existe_integral = "<input name='opcao_marcada_" & intCodAlunoIrmao& "' type='radio' value='" & id_chave_integral & "'>"
											else
												existe_integral = ""
											end if	
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
											
											existe_matutino 	= vetUnd3(2,i)
											if existe_matutino = "S" then
												existe_matutino = "<input name='opcao_marcada_" & intCodAlunoIrmao& "' type='radio' value='" & id_chave_matutino & "'>"
											else
												existe_matutino = ""
											end if
											existe_vespertino 	= vetUnd3(4,i)
											if existe_vespertino = "S" then
												existe_vespertino = "<input name='opcao_marcada_" & intCodAlunoIrmao& "' type='radio' value='" & id_chave_vespertino & "'>"
											else
												existe_vespertino = ""
											end if
											existe_integral 	= vetUnd3(6,i)
											if existe_integral = "S" then
												existe_integral = "<input name='opcao_marcada_" & intCodAlunoIrmao& "' type='radio' value='" & id_chave_integral & "'>"
											else
												existe_integral = ""
											end if	
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
				  <td height="26" colspan="6" class="texto1">Caso não tenha vagas você poderá utilizar a 4ª opção, deseja utiliza-la? <input type="checkbox" name="4_opcao" id="4_opcao" <%=marcou4opcao_marcacao%>  value="S" onClick="verifica4Opcao();"></td>
				</tr>
				<tr bgcolor="#CCCCCC" class="linha4Opcao" <%=marcou4opcao%>>
				  <td height="26" colspan="2" rowspan="2" class="texto1"><strong>&nbsp;Caso as unidades escolhidas pela aluno não tenha vaga, você poderá transferi-lo para uma 4ª Opção:</strong></td>
			      <td height="26" rowspan="2" class="texto1"><strong>PER&Iacute;ODO</strong></td>
			      <td height="12" colspan="3" align="center" class="texto1"><strong>VAGAS DISPON&Iacute;VEIS </strong></td>
		        </tr>
				<tr bgcolor="#CCCCCC" class="linha4Opcao" <%=marcou4opcao%>>
				  <td height="12" class="texto1"><div align="center"><strong>MATUTINO</strong></div></td>
				  <td class="texto1"><div align="center"><strong>VESPERTINO</strong></div></td>
				  <td class="texto1"><div align="center"><strong>INTEGRAL</strong></div></td>
			    </tr>
				
				<!-- aluno principal -->
				<tr bgcolor="#7DBEFF" class="linha4Opcao" <%=marcou4opcao%>>
				  <td width="14%" height="26" class="texto1">Unidade 4ª opção:</td>
				  <td colspan="5" class="texto1"><%strEmpresa4Opcao_submit="S"%><!--#include file="../includes/inc_cmbEmpresa4opcao.asp"--></td>
				</tr>
				<tr bgcolor="#cceeff" class="linha4Opcao" <%=marcou4opcao%>>
				  <td height="26" class="texto1">Matr&iacute;cula: </td>
				  <td class="texto1"><strong><%=strMatricula%> - <%=strNomeAluno%></strong></td>
			      <td colspan="4">
				  <%IF intCodEmpresa4opcao <>"" AND intCodEmpresa4opcao<>"0" THEN%>
					  <table width="100%" border="0" cellspacing="0" cellpadding="0">
						<% 
						'response.write sql
						sql = "EXEC [SP_consulta_vagas_para_transferencia] " & intCodEmpresa4opcao & "," & ano_letivo
						vetUnd4 = null
						rs.open sql, cnn
						if not rs.eof then
							vetUnd4 = rs.getRows
						end if
						rs.close
						if isArray(vetUnd4) then
							for i=0 to ubound(vetUnd4,2)
								periodo = replace(vetUnd4 (0,i)," ","_")
								if inStr(strPeriodoAluno, periodo) <> "0" then
									id_chave_matutino 	= right("0000" & cInt(intCodEmpresa4opcao),5) & "_MATUTINO__" & Left(replace(vetUnd4(0,i)," ","_") & "                              ",30)
									id_chave_vespertino = right("0000" & cInt(intCodEmpresa4opcao),5) & "_VESPERTINO" & Left(replace(vetUnd4(0,i)," ","_") & "                              ",30)
									id_chave_integral 	= right("0000" & cInt(intCodEmpresa4opcao),5) & "_INTEGRAL__" & Left(replace(vetUnd4(0,i)," ","_") & "                              ",30)
									
									existe_matutino 	= vetUnd4(2,i)
									if existe_matutino = "S" then
										existe_matutino = "<input name='opcao_marcada_" & strCodAluno & "' type='radio' value='" & id_chave_matutino & "'>"
									else
										existe_matutino = ""
									end if
									existe_vespertino 	= vetUnd4(4,i)
									if existe_vespertino = "S" then
										existe_vespertino = "<input name='opcao_marcada_" & strCodAluno & "' type='radio' value='" & id_chave_vespertino & "'>"
									else
										existe_vespertino = ""
									end if
									existe_integral 	= vetUnd4(6,i)
									if existe_integral = "S" then
										existe_integral = "<input name='opcao_marcada_" & strCodAluno & "' type='radio' value='" & id_chave_integral & "'>"
									else
										existe_integral = ""
									end if	
									%>
									<tr>
									  <td class="texto1" width="21%"><%=vetUnd4(0,i)%></td>
									  <td align="center" class="texto1" width="27%"><%=vetUnd4(1,i)%>&nbsp;<%=existe_matutino%></td>
									  <td align="center" class="texto1" width="26%"><%=vetUnd4(3,i)%>&nbsp;<%=existe_vespertino%></td>
									  <td align="center" class="texto1" width="26%"><%=vetUnd4(5,i)%>&nbsp;<%=existe_integral%></td>
									</tr>
									<%
								end if
							next
						end if
						%>
					  </table>
				  <%END IF%>				  </td>
		        </tr>
				<!-- aluno principal fim -->
				<%
				if quantidadeIrmao > 0 then
				
					cont=1
					sql = "select cod_aluno, matricula, nome, curso, periodo, turno"
					sql = sql & " from mat_transferencia_irmao_escola"
					sql = sql & " where cod_transferencia = " & cod_transferencia
					rsAux.open sql, cnn
					if not rsAux.eof then
						while not rsAux.eof
							intCodAlunoIrmao 			= rsAux("cod_aluno")
							strMatriculaAlunoIrmao		= rsAux("matricula")
							strNomeAlunoIrmao 			= rsAux("nome")
							strCursoAlunoIrmao			= rsAux("curso")
							strPeriodoAlunoIrmao		= rsAux("periodo")
							strTurnoAlunoIrmao			= rsAux("turno")
							periodos					= strPeriodoAlunoIrmao
							%>
						<tr bgcolor="#cceeff" class="linha4Opcao" <%=marcou4opcao%>>
						  <td height="26" class="texto1">Matr&iacute;cula <%=cont%>º irmão: </td>
						  <td class="texto1"><strong><%=strMatriculaAlunoIrmao%> - <%=strNomeAlunoIrmao%></strong></td>
						  <td colspan="4">
						  <%IF intCodEmpresa4opcao <>"" AND intCodEmpresa4opcao<>"0" THEN%>
							  <table width="100%" border="0" cellspacing="0" cellpadding="0">
								<% 
								sql = "EXEC [SP_consulta_vagas_para_transferencia] " & intCodEmpresa4opcao & "," & ano_letivo
								'response.write sql
								vetUnd4 = null
								rs.open sql, cnn
								if not rs.eof then
									vetUnd4 = rs.getRows
								end if
								rs.close
								if isArray(vetUnd4) then
									for i=0 to ubound(vetUnd4,2)
										periodo = replace(vetUnd4 (0,i)," ","_")
										if inStr(strPeriodoAlunoIrmao, periodo) <> "0" then
											id_chave_matutino 	= right("0000" & cInt(intCodEmpresa4opcao),5) & "_MATUTINO__" & Left(replace(vetUnd4(0,i)," ","_") & "                              ",30)
											id_chave_vespertino = right("0000" & cInt(intCodEmpresa4opcao),5) & "_VESPERTINO" & Left(replace(vetUnd4(0,i)," ","_") & "                              ",30)
											id_chave_integral 	= right("0000" & cInt(intCodEmpresa4opcao),5) & "_INTEGRAL__" & Left(replace(vetUnd4(0,i)," ","_") & "                              ",30)
											
											existe_matutino 	= vetUnd4(2,i)
											if existe_matutino = "S" then
												existe_matutino = "<input name='opcao_marcada_" & intCodAlunoIrmao & "' type='radio' value='" & id_chave_matutino & "'>"
											else
												existe_matutino = ""
											end if
											existe_vespertino 	= vetUnd4(4,i)
											if existe_vespertino = "S" then
												existe_vespertino = "<input name='opcao_marcada_" & intCodAlunoIrmao & "' type='radio' value='" & id_chave_vespertino & "'>"
											else
												existe_vespertino = ""
											end if
											existe_integral 	= vetUnd4(6,i)
											if existe_integral = "S" then
												existe_integral = "<input name='opcao_marcada_" & intCodAlunoIrmao & "' type='radio' value='" & id_chave_integral & "'>"
											else
												existe_integral = ""
											end if	
											%>
											<tr>
											  <td class="texto1" width="21%"><%=vetUnd4(0,i)%></td>
											  <td align="center" class="texto1" width="27%"><%=vetUnd4(1,i)%>&nbsp;<%=existe_matutino%></td>
											  <td align="center" class="texto1" width="26%"><%=vetUnd4(3,i)%>&nbsp;<%=existe_vespertino%></td>
											  <td align="center" class="texto1" width="26%"><%=vetUnd4(5,i)%>&nbsp;<%=existe_integral%></td>
											</tr>
											<%
										end if
									next
								end if
								%>
							  </table>
						  <%END IF%>					  </td>
					</tr>
							<%
							cont=cont+1
							rsAux.movenext
						wend
					end if
					rsAux.close
				
				end if%>
				
				
				<tr>
				  <td height="26" class="texto1" colspan="6"><input name="cod_irmaos" type="hidden" id="cod_irmaos" value="<%=cod_irmaos%>"></td>
			    </tr>
				<%
				if strSituacao = "A" then
				%>
				<tr>
				  <td height="26" colspan="6" class="texto1"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
			    </tr>   
				<%
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