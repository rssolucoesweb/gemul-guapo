<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))

	intCodTurma	       	= Trim(Request.Form("cmbTurma"))
	strAnoLetivo 		= Trim(Request.Form("txtAnoLetivo"))
			
	if acao="I" or acao="A"  then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "delete ESP_HORARIO_AULA where ano_letivo = " & strAnoLetivo & " and cod_turma = " & intCodTurma
		cnn.execute sql
		
		sql = "select h.codigo, h.horario, tu.desc_turno as turno "
		sql = sql & " from esp_faixa_horario h"
		sql = sql & " inner join sca_turno tu on tu.cod_turno = h.cod_turno"
		sql = sql & " where h.ano_letivo = " & strAnoLetivo
		sql = sql & " order by h.sequencia"
		rs.open sql, cnn,3,1
		if rs.eof = false then
			while not rs.eof
				
				cod_faixa_horario_segunda 	= request.form("horario_2_" & rs("codigo"))
				cod_faixa_horario_terca 	= request.form("horario_3_" & rs("codigo"))
				cod_faixa_horario_quarta 	= request.form("horario_4_" & rs("codigo"))
				cod_faixa_horario_quinta 	= request.form("horario_5_" & rs("codigo"))
				cod_faixa_horario_sexta 	= request.form("horario_6_" & rs("codigo"))
				cod_faixa_horario_sabado 	= request.form("horario_7_" & rs("codigo"))
				cod_faixa_horario_domingo 	= request.form("horario_1_" & rs("codigo"))
				
				if cod_faixa_horario_segunda<>"" then
					
					sql = "Insert Into ESP_HORARIO_AULA (ano_letivo, cod_turma, dia_semana, cod_faixa_horario)" 
					sql = sql & " Values ("
					sql = sql & "" & strAnoLetivo & ","
					sql = sql & "" & intCodTurma & ","
					sql = sql & "2,"
					sql = sql & "" & cod_faixa_horario_segunda & ")"
					cnn.execute sql
					GravarLog sql
			
				end if
				if cod_faixa_horario_terca<>"" then
					
					sql = "Insert Into ESP_HORARIO_AULA (ano_letivo, cod_turma, dia_semana, cod_faixa_horario)" 
					sql = sql & " Values ("
					sql = sql & "" & strAnoLetivo & ","
					sql = sql & "" & intCodTurma & ","
					sql = sql & "3,"
					sql = sql & "" & cod_faixa_horario_terca & ")"
					cnn.execute sql
					GravarLog sql
			
				end if
				if cod_faixa_horario_quarta<>"" then
					
					sql = "Insert Into ESP_HORARIO_AULA (ano_letivo, cod_turma, dia_semana, cod_faixa_horario)" 
					sql = sql & " Values ("
					sql = sql & "" & strAnoLetivo & ","
					sql = sql & "" & intCodTurma & ","
					sql = sql & "4,"
					sql = sql & "" & cod_faixa_horario_quarta & ")"
					cnn.execute sql
					GravarLog sql
			
				end if
				if cod_faixa_horario_quinta<>"" then
					
					sql = "Insert Into ESP_HORARIO_AULA (ano_letivo, cod_turma, dia_semana, cod_faixa_horario)" 
					sql = sql & " Values ("
					sql = sql & "" & strAnoLetivo & ","
					sql = sql & "" & intCodTurma & ","
					sql = sql & "5,"
					sql = sql & "" & cod_faixa_horario_quinta & ")"
					cnn.execute sql
					GravarLog sql
			
				end if
				if cod_faixa_horario_sexta<>"" then
					
					sql = "Insert Into ESP_HORARIO_AULA (ano_letivo, cod_turma, dia_semana, cod_faixa_horario)" 
					sql = sql & " Values ("
					sql = sql & "" & strAnoLetivo & ","
					sql = sql & "" & intCodTurma & ","
					sql = sql & "6,"
					sql = sql & "" & cod_faixa_horario_sexta & ")"
					cnn.execute sql
					GravarLog sql
			
				end if
				if cod_faixa_horario_sabado<>"" then
					
					sql = "Insert Into ESP_HORARIO_AULA (ano_letivo, cod_turma, dia_semana, cod_faixa_horario)" 
					sql = sql & " Values ("
					sql = sql & "" & strAnoLetivo & ","
					sql = sql & "" & intCodTurma & ","
					sql = sql & "7,"
					sql = sql & "" & cod_faixa_horario_sabado & ")"
					cnn.execute sql
					GravarLog sql
			
				end if
				if cod_faixa_horario_domingo<>"" then
					
					sql = "Insert Into ESP_HORARIO_AULA (ano_letivo, cod_turma, dia_semana, cod_faixa_horario)" 
					sql = sql & " Values ("
					sql = sql & "" & strAnoLetivo & ","
					sql = sql & "" & intCodTurma & ","
					sql = sql & "1,"
					sql = sql & "" & cod_faixa_horario_domingo & ")"
					cnn.execute sql
					GravarLog sql
			
				end if
				
				rs.movenext
			wend
		end if
	

	
		
	elseif acao="E" then
	
		strMensagem = "Registro excluído com sucesso..."
		
		sql = "delete ESP_HORARIO_AULA where ano_letivo = " & strAnoLetivo & " and cod_turma = " & intCodTurma
		cnn.execute sql
		
	end if
	
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='esp_horario_aula.asp?txtAnoLetivo=<%=strAnoLetivo%>&cmbTurma=<%=intCodTurma%>';
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