<%
	response.Expires=0
	Server.ScriptTimeOut = 5000
%>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------

	intCodigo 		= Trim(Request.Form("chkCodigo"))
	intOrdenacao 	= request("cmbOrdenacao")
	
	if intCodigo <> "" then
	
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
		
		if err.number = 0 then
			%>
			<script>
				alert("Reserva excluida com sucesso.");
				window.location='RemoveReserva_con.asp?cmbOrdenacao=<%=intOrdenacao%>';
			</script>
			<%
		end if	
	else
		%>
		<script>
            alert("ATENÇÃO: Codigo não informado.");
            window.history.back();
        </script>
        <%
	end if
%>