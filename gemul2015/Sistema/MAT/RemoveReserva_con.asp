<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body>
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<script>
	
	function gerar(){
		frm.submit();
		return true;	
	}
	
	function mostraEscolaAtivo(id){
		window.open("reserva_ativo_escola_con.asp?id=" + id,"abreConsulta","top=5,left=5,height=510,width=519,menubar=no,toolbar=no,scrollbars=yes,status=yes");		
	}
	
	function remover(){
		
		var frm = document.getElementById("frm");
		
		if (!confirm('Deseja excluir essa Reserva?'))
			return false;
		else{
			frm.action="RemoveReserva_cod.asp";
			frm.submit();
			return true;
		}
 	}
</script>
<%
	strCod_empresa 			= Session("CodEmpresa")
	intCurso	 			= request.Form("cmbAgrupamento")
	intOrdenacao 			= request.Form("cmbOrdenacao")
	intFiltro	 			= request.Form("cmbFiltro")
	strFiltroAtivo	 		= request.Form("cmbFiltroAtivo")
	intQtde		 			= request.Form("txtQtde")
	strNome 				= request.Form("txtNome")
	strMae 					= request.Form("txtMae")
	strPeriodo				= request.Form("cmbAgrupamento")
	
	strDataInicio = ""
	strDataFim = ""
		
%>
<table width="100%" border="0"  class="CorFundo" cellpadding="0" cellspacing="0" align="center">
  <tr>
    <td>
    <form method="post" id="frm" action="#">
    	<input type="hidden" name="strConsultar" id="strConsultar" value="S">
		<table width="100%" height="414" align="left" class="CorFundo" >
    <tr>
      <td height="14" align="center" valign="top"><span class="tituloPrincipal">Remover/Alterar Reserva</span></td>
    </tr>
    <tr>
      <td width="100%" height="85" align="center" valign="top"><table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
        <tr>
          <td width="10%" height="20" class="texto">Filtro:</td>
          <td width="90%"><!--#include file="../includes/inc_cmbAgrupamento.asp"--></td>
        </tr>

        <tr>
          <td height="20" class="texto">Aluno:</td>
          <td><span class="texto1">
            <input name="txtNome" type="text" class="text" id="txtNome" size="50" value="<%=strNome%>" >
          </span></td>
        </tr>
        <tr>
          <td height="20" class="texto">M&atilde;e:</td>
          <td><span class="texto1">
            <input name="txtMae" type="text" class="text" id="txtMae" size="50" value="<%=strMae%>" >
          </span></td>
        </tr>
        <tr>
          <td height="20" class="texto">Ordena&ccedil;&atilde;o:</td>
          <td><select name="cmbOrdenacao" class="Combo" id="cmbOrdenacao"  style="width:100pt" >
            <option value="0">Selecione...</option>
            <option value="1" <%if intOrdenacao = "1" then response.Write("selected") %>>Nome Aluno</option>
            <option value="2" <%if intOrdenacao = "2" then response.Write("selected") %>>Nome M&atilde;e</option>
            <option value="3" <%if intOrdenacao = "3" then response.Write("selected") %>>Inscrição</option>
            <option value="4" <%if intOrdenacao = "4" then response.Write("selected") %>>Bairro</option>
            <option value="5" <%if intOrdenacao = "5" then response.Write("selected") %>>Data Nascimento</option>
            </select></td>
        </tr>
        <tr>
          <td height="20" class="texto">Filtro 1:</td>
          <td><select name="cmbFiltro" class="Combo" id="cmbFiltro"  style="width:100pt" >
            <option value="0">Selecione...</option>
            <option value="1" <%if intFiltro = "1" then response.Write("selected") %>>Nome Aluno Iguais</option>
            <option value="2" <%if intFiltro = "2" then response.Write("selected") %>>Nome M&atilde;e Iguais</option>
          </select>
            <span class="texto1">
            <input name="txtQtde" type="text" class="text" id="txtQtde" value="<%=intQtde%>" size="5" maxlength="5" >
            caracteres iniciais ser&atilde;o comparados
            </span></td>
        </tr>
        <tr>
          <td height="20" class="texto">Filtro 2:</td>
          <td><select name="cmbFiltroAtivo" class="Combo" id="cmbFiltroAtivo"  style="width:100pt" >
            <option value="0">Todos...</option>
            <option value="A" <%if strFiltroAtivo = "A" then response.Write("selected") %>>Aluno Ativo</option>
          </select> <span class="texto1">
            <i>opcional</i>
            </span>
		</td>
        </tr>
        <tr>
          <td height="20" class="texto">&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td height="2" colspan="2"><hr size="1" color="#CCCCCC"></td>
        </tr>
        <tr>
          <td colspan="2">&nbsp;
            <input class="botao" type="button" value="Consultar" <%=strDesabilitaConsultar%>  name="cmdConsultar" onClick="return gerar()">
            <input class="botao" type="button" value="Excluir" <%=strDesabilitaConsultar%>  name="cmdExcluit" onClick="remover()">
            <input type="button" name="cmdLimpar"  value="Limpar"  class="botao" <%=strDesabilitaLimpar%> onClick="return limpar('<%=strPagina%>')">
            &nbsp; </td>
        </tr>
      </table>
        <br>
        <table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
	    <td width="2%" align="center" class="celula">#</td>
	    <td width="4%" align="center" class="celula"><strong>Alterar</strong></td>
	    <td width="2%" align="center" class="celula"><strong>Ativo</strong></td>
		<td width="4%" align="center" class="celula"><strong>Inscrição</strong></td>
		<td width="12%" class="celula"><strong>Nome Aluno</strong></td>
		<td width="5%" class="celula"><strong>Data Nasc</strong></td>
		<td width="7%" class="celula"><strong>Contato</strong></td>
		<td width="15%" class="celula"><strong>M&atilde;e</strong></td>
		<td width="4%" class="celula"><strong>Ser&iacute;e</strong></td>
		<td width="5%" class="celula"><strong>Turno</strong></td>
		<td width="10%" class="celula"><strong>Endere&ccedil;o</strong></td>
		<td width="14%" class="celula"><strong>Bairro</strong></td>
        <td width="18%" class="celula"><strong>Execução</strong></td>
		</tr>
	<%
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
%>
<%
	intPagina = 1
	intQtdeRegistroPorPagina = 1
	cont = 0
	
	intTotal_AgrupamentoI = 0
	intTotal_AgrupamentoII = 0
	intTotal_AgrupamentoIII = 0
	intTotal_AgrupamentoIV = 0
	intTotal_AgrupamentoV = 0
	
	sql = "SELECT "
	sql = sql & " 	("
	sql = sql & " 	select distinct re.codigo"
	sql = sql & " 	from mat_reserva re"
	sql = sql & " 	inner join sca_aluno a on a.nomealuno = re.nome and a.DATANASCIMENTO = re.data_nascimento and a.MAE = r.mae"
	sql = sql & " 	inner join SCA_SITUACAOALUNO s on s.cod_situacaoaluno = a.cod_situacaoaluno"
	sql = sql & " 	inner join SCA_ALUNO_TURMA at on at.cod_aluno = a.codigo and at.situacao = 'A'"
	sql = sql & " 	where re.cod_aluno is null "
	sql = sql & " 	and s.Desc_SituacaoAluno = 'ATIVO'"
	sql = sql & " 	and re.codigo = r.codigo"
	sql = sql & " 	) as ativoEscola, "
	sql = sql & " 	("
	sql = sql & " 			select top 1 COD_SITUACAOALUNO"
	sql = sql & " 			from sca_controle_situacao_aluno"
	sql = sql & " 			where cod_aluno = r.cod_aluno"
	sql = sql & " 			order by codigo desc"
	sql = sql & " 	) as cod_situacao_aluno, "
	sql = sql & " 	( select top 1 eee.RAZAOSOCIAL from sca_controle_situacao_aluno sss inner join seg_empresa eee on eee.codigo = sss.COD_EMPRESA where sss.cod_aluno = r.cod_aluno order by sss.codigo desc ) as unidade_atual, "
	sql = sql & " 	r.Codigo, r.inscricao,r.chave, r.nome, r.data_nascimento, r.mae, r.cep, r.Logradouro, "
	sql = sql & " r.bairro, r.cidade, r.email, r.Periodo, r.Turno, r.EMAIL, r.Contato, r.Celular, r.FonePai, r.FoneMae, ISNULL(r.ATUALIZADO,'N') as utilizado, u.USUA_NOME_COMPLETO as usuario_remove_cadastro, r.data_exc_cadastro , e.USUA_NOME_COMPLETO as usuario_efetivacao, r.data_efetivacao		"
	sql = sql & " FROM MAT_Reserva r"
	sql = sql & " left join seg_usuarios_sistema u on u.usua_codg = r.usuario_exc_cadastro"
	sql = sql & " left join seg_usuarios_sistema e on e.usua_codg = r.usuario_efetivacao"
	
	sql = sql & " where 1 = 1" 
	sql = sql & " and Situacao = 'R'"
	
	if strFiltroAtivo = "A" then
		sql = sql & " and ("
		sql = sql & " 	select distinct re.codigo"
		sql = sql & " 	from mat_reserva re"
		sql = sql & " 	inner join sca_aluno a on a.nomealuno = re.nome and a.DATANASCIMENTO = re.data_nascimento and a.MAE = r.mae"
		sql = sql & " 	inner join SCA_SITUACAOALUNO s on s.cod_situacaoaluno = a.cod_situacaoaluno"
		sql = sql & " 	inner join SCA_ALUNO_TURMA at on at.cod_aluno = a.codigo and at.situacao = 'A'"
		sql = sql & " 	where re.cod_aluno is null "
		sql = sql & " 	and s.Desc_SituacaoAluno = 'ATIVO'"
		sql = sql & " 	and re.codigo = r.codigo"
		sql = sql & " 	) is not null "
	end if
	'sql = sql & " AND ISNULL(ATUALIZADO,'N') = 'N'"
	if strNome <> "" then
		sql = sql & " and Nome like '" & strNome & "%'"
	end if
	if strMae <> "" then
		sql = sql & " and Mae like '" & strMae & "%'"
	end if
	if strPeriodo <> "0" then
		'sql = sql & " and data_nascimento between '" & strDataInicio & "' and '" & strDataFim & "'"
		sql = sql & " and periodo = '" & replace(strPeriodo,"_"," ") & "'"
	end if
	if intFiltro = "1" then
		if intQtde = "" then
			sql = sql & " and Nome in (	select nome from mat_reserva where Situacao = 'R' group by nome having count(*)>1 )"
		else
			sql = sql & " and left(nome,"&intQtde&") in (	select left(nome,"&intQtde&") from mat_reserva where Situacao = 'R' group by left(nome,"&intQtde&") having count(*)>1 )"
		end if
	end if
	if intFiltro = "2" then
		if intQtde = "" then
			sql = sql & " and mae in (	select mae from mat_reserva where Situacao = 'R' group by mae having count(*)>1 )"
		else
			sql = sql & " and left(mae,"&intQtde&") in (	select left(mae,"&intQtde&") from mat_reserva where Situacao = 'R' group by left(mae,"&intQtde&") having count(*)>1 )"
		end if
	end if
	cor = "bgcolor='#FFFFFF'"
	if intOrdenacao = 1 or intOrdenacao = "" then 
		sql = sql & " order by nome"
	elseif intOrdenacao = 2 then 
		sql = sql & " order by mae, nome"
	elseif intOrdenacao = 3 then 
		sql = sql & " order by inscricao"
	elseif intOrdenacao = 4 then 
		sql = sql & " order by bairro, nome"
	elseif intOrdenacao = 5 then 
		sql = sql & " order by data_nascimento, nome"
	end if
	'response.write sql
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
		
				cont = cont + 1
				
				'if (cont MOD 2) = 0 then
				'if nome = rs("nome") then
				'	strCor = "#CCCCCC"
				'else
				'	strCor = "#FFFFFF"
				'end if
			 
				if trim(rs("TURNO")) <> "0" then
					strTurno = trim(rs("TURNO"))
				else
					strTurno =  ""
				end if
				
				if trim(rs("Periodo")) = "AGRUPAMENTO I" then
					intTotal_AgrupamentoI = intTotal_AgrupamentoI + 1
				end if
				
				if trim(rs("Periodo")) = "AGRUPAMENTO II" then
					intTotal_AgrupamentoII = intTotal_AgrupamentoII + 1
				end if
				
				if trim(rs("Periodo")) = "AGRUPAMENTO III" then
					intTotal_AgrupamentoIII = intTotal_AgrupamentoIII + 1
				end if
				
				if trim(rs("Periodo")) = "AGRUPAMENTO IV" then
					intTotal_AgrupamentoIV = intTotal_AgrupamentoIV + 1
				end if
				
				if trim(rs("Periodo")) = "AGRUPAMENTO V" then
					intTotal_AgrupamentoV = intTotal_AgrupamentoV + 1
				end if
				utilizado = "N"
				if rs("utilizado") = "S" then
					cor = "bgcolor='#BBFFDD'"
					utilizado = "S"
				end if
				
				usuario_excluiu = ""
				if rs("utilizado") = "S" and not isnull(rs("usuario_remove_cadastro")) then
					cor = "bgcolor='#FFDFBF'"
					utilizado = "S"
					usuario_excluiu = rs("usuario_remove_cadastro") & "<br>" & rs("data_exc_cadastro") 
				end if
				usuario_efetivou = ""
				if rs("utilizado") = "S" and not isnull(rs("usuario_efetivacao")) and usuario_excluiu = "" then
					cor = "bgcolor='#BBFFDD'"
					utilizado = "S"
					usuario_efetivou = rs("usuario_efetivacao") & "<br>" & rs("data_efetivacao") 
				end if
				if rs("cod_situacao_aluno") <> "1" then
					cor = "bgcolor='#f5a4a4'"
				end if
				unidade_atual = ""
				if rs("cod_situacao_aluno") = "1" then
					unidade_atual = rs("unidade_atual")
				end if
				
				
				
				ativoEscola = ""
				if not isnull(rs("ativoEscola")) then
					ativoEscola = "S"
				end if
				
			%>
			  <tr <%=cor%> height="20">
			    <td class="celula" align="center"><%if utilizado = "N" then%><input name="chkCodigo" type="checkbox" value="<%=rs("Codigo")%>"<%=strMarca%>><%else%>-<%end if%></td>
			    <td class="celula" align="center"><%if utilizado = "N" then%><a href="reserva_cad.asp?chave=<%=rs("chave")%>"><img src="../../../../images/botao_azul_normal.gif" width="26" height="26"></a><%else%>---<%end if%></td>
				<td class="celula" align="center"><%if ativoEscola = "S" then%><a href="#" onClick="mostraEscolaAtivo('<%=rs("ativoEscola")%>')" ><img src="../../../../images/botao_verde_normal.gif" width="26" height="26" alt="Aluno já ativo em outra unidade"></a><%else%>---<%end if%></td>
				<td class="celula" align="center"><%=rs("inscricao")%></td>
				<td align="left" class="celula"><%=rs("nome")%>&nbsp;</td>
				<td align="left" class="celula"><%=formataDataAP(rs("data_nascimento"))%></td>
				<td align="left" class="celula"><%=rs("Contato")%>&nbsp;</td>
				<td align="left" class="celula"><%=rs("mae")%></td>
				<td align="left" class="celula"><%=rs("Periodo")%></td>
				<td align="left" class="celula"><%=strTurno%>&nbsp;</td>
				<td align="left" class="celula"><%=rs("Logradouro")%></td>
				<td align="left" class="celula"><%=rs("bairro")%></td>
                <td align="left" class="celula"><%=usuario_excluiu & usuario_efetivou%>&nbsp;</td>
			  </tr>
			<%
			if unidade_atual<>"" then
			%>
			  <tr <%=cor%> height="20">
                <td align="center" colspan="13" class="celula">Unidade Atual: <%=unidade_atual%>&nbsp;</td>
			  </tr>
			<%
			end if
			nome = rs("nome")
			mae = rs("mae")
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			rs.movenext
			if not rs.eof then
				if utilizado = "N" and usuario_excluiu = "" then
					if intOrdenacao = "1" then
						if trim(nome)<>trim(rs("nome")) then
							if cor = "bgcolor='#FFFFFF'" then
								cor = "bgcolor='#C4E1FF'"
							else
								cor = "bgcolor='#FFFFFF'"
							end if
						end if
					elseif intOrdenacao = "2" or intOrdenacao = "5" then
						if trim(mae)<>trim(rs("mae")) then
							if cor = "bgcolor='#FFFFFF'" then
								cor = "bgcolor='#C4E1FF'"
							else
								cor = "bgcolor='#FFFFFF'"
							end if
						end if
					end if
				else
					cor = ""
				end if
			end if
			utilizado = "N"
		wend
		%>
		<tr>
			<td colspan="13" class="celula">Total Agrupamento I:<%=intTotal_AgrupamentoI%></td>
		</tr>
		<tr>
			<td colspan="13" class="celula">Total Agrupamento II:<%=intTotal_AgrupamentoII%></td>
		</tr>
		<tr>
			<td colspan="13" class="celula">Total Agrupamento III:<%=intTotal_AgrupamentoIII%></td>
		</tr>
		<tr>
			<td colspan="13" class="celula">Total Agrupamento IV:<%=intTotal_AgrupamentoIV%></td>
		</tr>
		<tr>
			<td colspan="13" class="celula">Total Agrupamento V:<%=intTotal_AgrupamentoV%></td>
		</tr>
		<tr>
			<td colspan="13" class="celula">Quantidade de Candidatos: <%=cont%></td>
		</tr>
		 <%
	else
		%>
		<%
	end if
	rs.close
%>
</table>	
<br>
<table width="50%" border="0" cellspacing="0" cellpadding="0" class="tabela">
  <tr bgcolor='#BBFFDD'>
    <td  class="celula">Cadastro de reserva já utilizado/matrículado&nbsp;</td>
  </tr>
  <tr bgcolor="#FFDFBF">
    <td  class="celula">Cadastro de reserva já utilizado e removido pelo cadastro</td>
  </tr>
  <tr bgcolor="#f5a4a4">
    <td  class="celula">Aluno com situação diferente de Ativo </td>
  </tr>
</table>


</td> 
    </tr>
  </table>
   </form>
    </td>
  </tr>
</table>

<!--#include file="../rodape.asp"-->
</body>
</html>