<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - Sergiob76@gmail.com
	::	Objetivo Pagina...: Cadastro de tipo avaliação
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 			= Trim(Request.QueryString("acao"))
	intCodEmp		= Session("CodEmpresa")
	intCodigo = Request.Form("codigo")
	nome = Request.Form("nome")
	sexo = Request.Form("sexo")
	data_nascimento = formatadataBD(Request.Form("data_nascimento"))
	mae = Request.Form("mae")
	cep = Request.Form("cep")
	Logradouro = Request.Form("Logradouro")
	NumeroEndereco = Request.Form("NumeroEndereco")
	ComplementoEndereco = Request.Form("ComplementoEndereco")
	bairro = Request.Form("bairro")
	cidade = Request.Form("cidade")
	uf = Request.Form("uf")
	email = Request.Form("email")
	Contato = Request.Form("Contato")
	Celular = Request.Form("Celular")
	FonePai = Request.Form("FonePai")
	FoneMae = Request.Form("FoneMae")
	bolsa_Familia = Request.Form("bolsa_Familia")

			
	if acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update mat_reserva Set"
		sql = sql & " nome = '" & nome & "',"
		sql = sql & " sexo = '" & sexo & "',"
		sql = sql & " data_nascimento = '" & data_nascimento & "',"

		sql = sql & " mae = '" & mae & "',"
		sql = sql & " cep = '" & cep & "',"
		sql = sql & " Logradouro = '" & Logradouro & "',"
		sql = sql & " NumeroEndereco = '" & NumeroEndereco & "',"
		sql = sql & " ComplementoEndereco = '" & ComplementoEndereco & "',"
		sql = sql & " bairro = '" & bairro & "',"
		sql = sql & " cidade = '" & cidade & "',"
		sql = sql & " uf = '" & uf & "',"
		sql = sql & " email = '" & email & "',"
		sql = sql & " Contato = '" & Contato & "',"
		sql = sql & " Celular = '" & Celular & "',"
		sql = sql & " FonePai = '" & FonePai & "',"
		sql = sql & " FoneMae = '" & FoneMae & "',"
		sql = sql & " bolsa_Familia = '" & bolsa_Familia & "',"
		sql = sql & " usuario_altr = '" & trim(session("usuarioWeb")) & "',"
		sql = sql & " data_hora_altr = getdate()"
		sql = sql & " where codigo = " & intCodigo
		'response.write sql
		cnn.execute sql
		GravarLog sql
		
	elseif acao="E" then
	
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "insert into MAT_reserva_ocorrencia ("
		sql = sql & " codigo_reserva"
		sql = sql & ",chave"
		sql = sql & ",Inscricao"
		sql = sql & ",CodEmpresa"
		sql = sql & ",Ano"
		sql = sql & ",nome"
		sql = sql & ",sexo"
		sql = sql & ",data_nascimento"
		sql = sql & ",mae"
		sql = sql & ",cep"
		sql = sql & ",Logradouro"
		sql = sql & ",NumeroEndereco"
		sql = sql & ",ComplementoEndereco"
		sql = sql & ",bairro"
		sql = sql & ",cidade"
		sql = sql & ",uf"
		sql = sql & ",email"
		sql = sql & ",Contato"
		sql = sql & ",Celular"
		sql = sql & ",FonePai"
		sql = sql & ",FoneMae"
		sql = sql & ",curso"
		sql = sql & ",periodo"
		sql = sql & ",turno"
		sql = sql & ",Situacao"
		sql = sql & ",Atualizado"
		sql = sql & ",usuario_incl"
		sql = sql & ",data_hora_incl"
		sql = sql & ",bolsa_Familia"
		sql = sql & ",cod_aluno"
		sql = sql & ",usuario_efetivacao"
		sql = sql & ",data_efetivacao"
		sql = sql & ",usuario_altr"
		sql = sql & ",data_hora_altr"
		sql = sql & ",usuario_excl"
		sql = sql & ",data_hora_excl) "

		sql = sql & " select "
		sql = sql & " codigo as codigo_reserva"
		sql = sql & " ,chave"
		sql = sql & " ,Inscricao"
		sql = sql & " ,CodEmpresa"
		sql = sql & " ,Ano"
		sql = sql & " ,nome"
		sql = sql & " ,sexo"
		sql = sql & " ,data_nascimento"
		sql = sql & " ,mae"
		sql = sql & " ,cep"
		sql = sql & " ,Logradouro"
		sql = sql & " ,NumeroEndereco"
		sql = sql & " ,ComplementoEndereco"
		sql = sql & " ,bairro"
		sql = sql & " ,cidade"
		sql = sql & " ,uf"
		sql = sql & " ,email"
		sql = sql & " ,Contato"
		sql = sql & " ,Celular"
		sql = sql & " ,FonePai"
		sql = sql & " ,FoneMae"
		sql = sql & " ,curso"
		sql = sql & " ,periodo"
		sql = sql & " ,turno"
		sql = sql & " ,Situacao"
		sql = sql & " ,Atualizado"
		sql = sql & " ,usuario_incl"
		sql = sql & " ,data_hora_incl"
		sql = sql & " ,bolsa_Familia"
		sql = sql & " ,cod_aluno"
		sql = sql & " ,usuario_efetivacao"
		sql = sql & " ,data_efetivacao"
		sql = sql & " ,usuario_altr"
		sql = sql & " ,data_hora_altr"
		sql = sql & " ,'" & Session("UsuarioWeb") & "' as usuario_excl"
		sql = sql & " ,getdate()"
		sql = sql & " from MAT_reserva	"
		sql = sql & " Where Codigo in(" & intCodigo & ")"
		cnn.execute sql	
		
		sql = "Delete From MAT_reserva_deficiencia "
		sql = sql & " Where cod_reserva in(" & intCodigo & ")"
		cnn.execute sql	
		GravarLog sql
		
		sql = "Delete From MAT_Reserva "
		sql = sql & " Where Codigo in(" & intCodigo & ")"
		cnn.execute sql	
		GravarLog sql
		
		
	end if
	

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='RemoveReserva_con.asp';
		</script>
		<%
		response.end
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