<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - Sergiob76@gmail.com
	::	Objetivo Pagina...: Cadastro de tipo avaliação
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--include file="../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_formataCPF.asp"-->
<script>

function validaCPFAluno(campo) {
   var pcpf=campo.value;
   
   pcpf = pcpf.replace(".","");
   pcpf = pcpf.replace(".","");
   pcpf = pcpf.replace("-","");
   
   if (pcpf != "") {
   
	   if (pcpf.length != 11){
		   sim=false;
	   }
	   else{
		   sim=true;
	   }
	   
	   if ( (pcpf==11111111111) || (pcpf==22222222222) ||
		   (pcpf==33333333333) || (pcpf==44444444444) || (pcpf==55555555555) ||
		   (pcpf==66666666666) || (pcpf==77777777777) || (pcpf==88888888888) ||
		   (pcpf==99999999999) || (pcpf==00000000000) ){
			   sim=false;
	   }
	   
	   if(sim){
		   for (i=0; i<=(pcpf.length-1) && sim; i++){
			   val = pcpf.charAt(i);
			   if((val!="9")&&(val!="0")&&(val!="1")&&(val!="2")&&(val!="3")&&(val!="4")&&( val!="5")&&(val!="6")&&(val!="7")&&(val!="8")){
				   sim=false;
			   }
		   }
	   
		   if(sim){
			   soma=0;
			   for (i=0;i<=8;i++){
				   val = eval(pcpf.charAt(i));
				   soma = soma + (val*(i+1));
			   }
		   
			   resto = soma % 11;
			   
			   if (resto>9)
				   dig = resto -10;
			   else
				   dig = resto;
			   
		   
			   if (dig != eval(pcpf.charAt(9))){
				   sim=false
			   }else{
				   soma = 0
				   for (i=0;i<=7;i++){
					   val = eval(pcpf.charAt(i+1))
					   soma = soma +	(val*(i+1))
				   }
				   soma = soma + (dig * 9)
				   resto = soma % 11
				   if (resto>9){
					   dig = resto -10
				   }else{
					   dig = resto
				   }
		   
				   if (dig != eval(pcpf.charAt(10))){
					   sim = false
				   }else{
					   sim = true
				   }
			   }
		   }
	   }
	   
	   if (!sim){
		   alert("CPF inválido!");
		   campo.value="";
		   campo.focus();
		   return false;
	   }
			   
   }
}

	function gravarContato(){

		var codigo = document.getElementById("codigo").value;

		if(codigo==""){
			alert("Registro não localizado.");
			return;
		}

		var tipo = document.getElementById("tipo_contato").value;
		var obs  = document.getElementById("observacao_contato").value;

		if(obs==""){
			alert("Informe a observação.");
			return;
		}

		location.href =
			"reserva_historico_gravar.asp" +
			"?codigo_reserva=" + codigo +
			"&tipo=" + escape(tipo) +
			"&obs=" + escape(obs);
	}

	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		frm.action="reserva_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<%
	strPaginaTitulo = "RemoveReserva_con.asp"
	strPagina 		= "reserva_cad.asp"
	strExecutarSubmitCurso 	= "S"
	strRetiraBotaoExcluirTela = "S"
	chave 		= Trim(Request("chave"))
	
	sql = "SELECT *"
	sql = sql & " FROM mat_reserva"
	sql = sql & " Where chave = '" & chave & "'"
	rs.open sql, cnn
	
	if rs.eof = false then	
		codigo = rs("codigo")
		cpf = formataCPFap(rs("cpf"))
		nome = rs("nome")
		sexo = rs("sexo")
		data_nascimento = formatadataAP(rs("data_nascimento"))
		mae = rs("mae")
		cep = rs("cep")
		Logradouro = rs("Logradouro")
		NumeroEndereco = rs("NumeroEndereco")
		ComplementoEndereco = rs("ComplementoEndereco")
		bairro = rs("bairro")
		cidade = rs("cidade")
		uf = rs("uf")
		email = rs("email")
		Contato = rs("Contato")
		Celular = rs("Celular")
		FonePai = rs("FonePai")
		FoneMae = rs("FoneMae")
		bolsa_Familia = rs("bolsa_Familia")

		strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "" 'Desabilita o botão Excluir

	end if 
	rs.close

%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="98%"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post">
        <input name="codigo" type="hidden" class="text" id="codigo" value="<%=codigo%>">
		  <table width="100%" border="0" cellpadding="0" cellspacing="0">

            <tr valign="top">
              <td width="100%" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
          </table>
		  <br>
		  <table width="98%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="texto1">Nome</td>
            <td><input name="nome" type="text" class="text" id="nome" size="40" maxlength="30" value="<%=nome%>"></td>
          </tr>
          <tr>
            <td width="142" class="texto1">Sexo</td>
            <td width="1314"><span class="TextoForm">
              <select name="sexo" class="Combo" id="sexo">
                <option value="M" <%if trim(sexo) = "M" then response.Write("selected") %>>Masculino</option>
                <option value="F" <%if trim(sexo) = "F" then response.Write("selected") %>>Feminino</option>
              </select>
            </span></td>
          </tr>
          <tr>
            <td class="texto1">Data Nascimento</td>
            <td><input name="data_nascimento" type="text" class="text" id="data_nascimento"  onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=data_nascimento%>"></td>
          </tr> 
		  <tr>
            <td class="texto1">CPF Aluno</td>
            <td><input name="txtcpf" type="text" class="text" id="txtcpf"  onKeyPress="return formataCampo(this,5,14)" onBlur="return validaCPFAluno(this)" size="12" maxlength="15" value="<%=cpf%>"></td>
          </tr>
		  
          <tr>
            <td class="texto1">M&atilde;e</td>
            <td><input name="mae" type="text" class="text" id="mae" size="40" maxlength="30" value="<%=mae%>"></td>
          </tr>
		  <tr>
            <td class="texto1">Logradouro</td>
            <td><input name="logradouro" type="text" class="text" id="logradouro" size="40" maxlength="30" value="<%=logradouro%>"></td>
          </tr>
          <tr>
            <td class="texto1">N&uacute;mero</td>
            <td><input name="NumeroEndereco" type="text" class="text" id="NumeroEndereco" size="20" maxlength="30" value="<%=NumeroEndereco%>"></td>
          </tr>
          <tr>
            <td class="texto1">Complemento</td>
            <td><input name="ComplementoEndereco" type="text" class="text" id="ComplementoEndereco" size="40" maxlength="30" value="<%=ComplementoEndereco%>"></td>
          </tr>
          <tr>
            <td class="texto1">Bairro</td>
            <td><input name="bairro" type="text" class="text" id="bairro" size="40" maxlength="30" value="<%=bairro%>"></td>
          </tr>
          <tr>
            <td class="texto1">Cidade</td>
            <td><input name="cidade" type="text" class="text" id="cidade" size="40" maxlength="30" value="<%=cidade%>"></td>
          </tr>
          <tr>
            <td class="texto1">UF</td>
            <td><input name="uf" type="text" class="text" id="uf" size="5" maxlength="30" value="<%=uf%>"></td>
          </tr>
          <tr>
            <td class="texto1">Email</td>
            <td><input name="email" type="text" class="text" id="email" size="40" maxlength="30" value="<%=email%>"></td>
          </tr>
          <tr>
            <td class="texto1">Fone Contato</td>
            <td><input name="contato" type="text" class="text" id="contato" size="20" maxlength="30" value="<%=contato%>"></td>
          </tr>
          <tr>
            <td class="texto1">Celular</td>
            <td><input name="Celular" type="text" class="text" id="Celular" size="20" maxlength="30" value="<%=Celular%>"></td>
          </tr>
          <tr>
            <td class="texto1">Fone Pai</td>
            <td><input name="FonePai" type="text" class="text" id="FonePai" size="20" maxlength="30" value="<%=FonePai%>"></td>
          </tr>
          <tr>
            <td class="texto1">Fone M&atilde;e</td>
            <td><input name="Fonemae" type="text" class="text" id="Fonemae" size="20" maxlength="30" value="<%=Fonemae%>"></td>
          </tr>
          <tr>
            <td class="texto1">N&uacute;mero Bolsa fam&iacute;lia</td>
            <td><input name="bolsa_Familia" type="text" class="text" id="bolsa_Familia" size="20" maxlength="30" value="<%=bolsa_Familia%>"></td>
          </tr>
		  
		  <tr>
			<td colspan="2">
				<hr>
				<br>

				<table width="100%" border="0" cellpadding="3">

					<tr>
						<td colspan="2" class="tituloSistema">
							Histórico de Tentativas de Contato
						</td>
					</tr>

					<tr>
						<td width="120" class="texto1">Tipo</td>
						<td>
							<select name="tipo_contato" id="tipo_contato" class="Combo">
								<option value="Ligação">Ligação</option>
								<option value="WhatsApp">WhatsApp</option>
								<option value="SMS">SMS</option>
								<option value="Presencial">Presencial</option>
								<option value="Outro">Outro</option>
							</select>
						</td>
					</tr>

					<tr>
						<td valign="top" class="texto1">
							Observação
						</td>
						<td>
							<textarea
								name="observacao_contato"
								id="observacao_contato"
								cols="90"
								rows="4"></textarea>
						</td>
					</tr>

					<tr>
						<td>&nbsp;</td>
						<td>
							<input
								type="button"
								value="Adicionar Registro"
								class="botao"
								onclick="gravarContato();">
						</td>
					</tr>

				</table>

				<br>

				<table width="100%" border="1" cellpadding="3" cellspacing="0" class="tabela">

					<tr bgcolor="#EAEAEA">
						<td class="celula" width="200"><b>Data</b></td>
						<td class="celula" width="120"><b>Tipo</b></td>
						<td class="celula"><b>Observação</b></td>
						<td class="celula" width="120"><b>Usuário</b></td>
					</tr>

					<%

					sqlHist = "SELECT * "
					sqlHist = sqlHist & "FROM mat_reserva_historico "
					sqlHist = sqlHist & "WHERE codigo_reserva = " & codigo
					sqlHist = sqlHist & " ORDER BY data_contato DESC"

					rs.Open sqlHist, cnn

					Do While Not rs.EOF

					%>

					<tr>
						<td class="celula" >
							<%=rs("data_contato")%>
						</td>

						<td class="celula">
							<%=rs("tipo_contato")%>
						</td>

						<td class="celula">
							<%=rs("observacao")%>
						</td>

						<td class="celula">
							<%=rs("usuario")%>
						</td>
					</tr>

					<%

						rs.MoveNext
					Loop

					rs.Close

					%>

				</table>

			</td>
		</tr>

          <tr>
            <td colspan="2"><br><br><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
          </tr>
          </table>
		  <br>
		  <br>
		</form>
		</td>
      </tr>
    </table>
	</td>
  </tr>
</table>
<!--#include file="../rodape.asp"-->
</body>
</html>