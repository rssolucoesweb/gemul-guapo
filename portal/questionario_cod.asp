<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<!--#include file="includes/inc_verificaSession.asp"-->
<!--#include file="includes/inc_cnn_gemulEAD.asp"-->
<!--#include file="includes/inc_log_ead.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans

	intCodEmp									= Session("CodEmpresaAluno_GemulEad")
	intCodTurma           	  					= Session("CodTurma_GemulEad")
	intCodAluno           	  					= Session("CodAluno_GemulEad")
	cod_questionario							= Trim(Request("id"))
	cod_disciplina 								= request.form("cd")
	
	' Dados do Usuario
	strUsuario_incl   	= Session("LoginAluno_GemulEad")
	
	if intCodAluno <> "" then

		sql = "SET NoCount ON INSERT INTO EAD_resultado (cod_aluno, cod_questionario, cod_turma, usuario_incl, data_hora_incl) VALUES ("
		sql = sql & "" & intCodAluno  & ","
		sql = sql & "" & cod_questionario & ","
		sql = sql & "" & intCodTurma & ","
		sql = sql & "'" & strUsuario_incl & "',getdate());SELECT @@IDENTITY "
		Set rs = cnn.Execute(sql)
		cod_resultado = rs(0)
		rs.close
		
		GravarLogEaD "Questionário foi enviado",0,0,cod_questionario,0
		
		sql = " select distinct p.codigo as cod_pergunta"
		sql = sql & " from ead_questionario q"
		sql = sql & " inner join ead_questionario_turma qt on qt.cod_questionario = q.codigo"
		sql = sql & " inner join EAD_pergunta p on p.cod_questionario = q.codigo"
		sql = sql & " where q.cod_empresa = " & intCodEmp
		sql = sql & " and qt.cod_turma = " & intCodTurma
		sql = sql & " and q.codigo = " & cod_questionario
		sql = sql & " and q.situacao = 'P'"
		sql = sql & " order by 1 "
		vetPergunta = null
		rs.open sql, cnn
		if not rs.eof then
			vetPergunta = rs.getRows
		end if
		rs.close
		
		if isArray(vetPergunta) then
			for i=0 to ubound(vetPergunta,2)
				
				id_pergunta			= vetPergunta(0,i)
				id_resposta  		= request.form("pergunta_" & vetPergunta(0,i))
				
				'response.write "<br>cod_tipo_resposta:" & cod_tipo_resposta
				'response.write "<br>id_pergunta:" & id_pergunta
				'response.write "<br>id_resposta:" & id_resposta
				
				if id_resposta <> "" then
					sql = "SET NoCount ON INSERT INTO EAD_resultado_respostas (cod_resultado, cod_pergunta, cod_resposta, usuario_incl, data_hora_incl) VALUES ("
					sql = sql & "" & cod_resultado  & ","
					sql = sql & "" & id_pergunta & ","
					sql = sql & "" & id_resposta & ","
					sql = sql & "'" & strUsuario_incl & "',getdate());SELECT @@IDENTITY "
					Set rs = cnn.Execute(sql)
					cod_resultado_respostas = rs(0)
					rs.close
					
					
					cod_tipo_resposta = "0"
					
					sql = " select distinct r.cod_tipo_resposta"
					sql = sql & " from EAD_pergunta p "
					sql = sql & " inner join EAD_resposta r on r.cod_pergunta = p.codigo"
					sql = sql & " where r.cod_pergunta = " & id_pergunta
					rs.open sql, cnn
					if not rs.eof then
						cod_tipo_resposta 	= rs("cod_tipo_resposta")
					end if
					rs.close
					
					if cod_tipo_resposta = "1" then
						texto = request.form("resposta_pergunta_" & vetPergunta(0,i))
						
						sql = "INSERT INTO EAD_resultado_respostas_texto (cod_resultado_respostas, resposta, usuario_incl, data_hora_incl) VALUES ("
						sql = sql & "" & cod_resultado_respostas  & ","
						sql = sql & "'" & texto & "',"
						sql = sql & "'" & strUsuario_incl & "',getdate())"
						cnn.Execute(sql)
						texto = ""

					end if
				
				end if
			next
		end if
		
	end if
	
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------

		cnn.commitTrans
		
		%>
		<script>
			alert("Respostas foram salvas, enviadas e corrigidas!");
			window.location = "questionario.asp?cod_questionario=<%=cod_questionario%>";
		</script>			
		<%
		
		response.end
		
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>