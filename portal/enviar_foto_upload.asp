<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 

'Não armazena a página em buffer antes de mostra-la na tela'
'response.Buffer = false
response.Expires=0
Server.ScriptTimeOut = 8000

%>
<!--#include file="includes/inc_verificaSession.asp"-->
<!--#include file="includes/inc_cnn_gemulEAD.asp"-->
<!--#include file="includes/inc_log_ead.asp"-->
<%

	acao                                       = request("acao")
    cod_atividade_pai                          = request.Form("cod_atividade_pai")
	nome_imagem                          	   = request.Form("nome_imagem")
    arquivoBase64                              = request.Form("arquivoBase64")
	
	if acao = "I" then
		cod_colaborador = ""
		sql = "select a.cod_colaborador, c.codLotacao, a.titulo"
		sql = sql & " from EAD_Atividade_pai a"
		sql = sql & " inner join SRH_COLABORADOR c on c.codigo = a.cod_colaborador"
		sql = sql & " where a.cod_atividade_pai = " & cod_atividade_pai
		rs.open sql, cnn
		if not rs.eof then
			cod_colaborador = rs("cod_colaborador")
			ID_EMPRESA = rs("codLotacao")
			titulo = rs("titulo")
		end if
		rs.close
		
		sql = "SET NoCount ON insert into EAD_Atividade_aluno (cod_atividade_pai,cod_aluno,nome_imagem,imagem,usuario_incl,data_hora_incl) values ("
		sql = sql & "" & cod_atividade_pai & ","
		sql = sql & "" & Session("CodAluno_GemulEad") & ","
		sql = sql & " '" & nome_imagem & "',"
		sql = sql & " '" & arquivoBase64 & "',"
		sql = sql & " '" & Session("CodAluno_GemulEad") & "',getdate());SELECT @@IDENTITY "
		Set rs = cnn.Execute(sql)
		cod_atividade_aluno = rs(0)
		rs.close

		GravarLogEaD "Enviada a imagem da atividade",cod_atividade_pai,0,0,0
		
		if trim(cod_colaborador) <>"" then
			sql = "SET NoCount ON INSERT INTO EAD_NOTIFICACAO (cod_empresa, cod_colaborador, cod_aluno, cod_atividade_aluno, descricao, usuario_incl_aluno, data_hora_incl) VALUES ("
			sql = sql & "" & ID_EMPRESA & ","
			sql = sql & "" & cod_colaborador & ","
			sql = sql & "" & Session("CodAluno_GemulEad") & ","
			sql = sql & "" & cod_atividade_aluno & ","
			sql = sql & "'Atividade " & titulo & " foi respondida com envio da imagem da atividade',"
			sql = sql & "" & Session("CodAluno_GemulEad") & ",GetDate()); SELECT @@IDENTITY"
			Set rs = cnn.Execute(sql)
			id_mensagem = rs(0)
			rs.close
			
			GravarLogEaD "Professor foi notificado do envio da imagem da atividade",cod_atividade_pai,id_mensagem,0,cod_colaborador
		end if
		
	end if
	
    if err.number=0 then
		response.redirect "enviar_foto.asp?id_atv=" & cod_atividade_pai
	else
		%>
		<script language="JavaScript" type="text/JavaScript">
		    document.all.aguarde.style.display = "none";
		    alert("ATENÇÃO: não conseguimos fazer o upload da sua foto, tente novamente e verifique o tamanho para não exceder o tamanho máximo do servidor!");
		    window.history.go(-1);
		</script>
		<%
	end if	
%>
