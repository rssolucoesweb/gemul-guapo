<%
if intCodTurmaProfessor = "" 		then intCodTurmaProfessor 		= "0"
if intCodDisciplina = "" 			then intCodDisciplina 			= "0"

if strAnoLetivo <>"" and intCodTurmaProfessor<>"0" and intCodDisciplina<>"0" and intCodColaboradorProfessor<>"" then

	sql = "select cast(cd.ano as varchar) + '/' +"
	sql = sql & " 		 case"
	sql = sql & " 			when len(cd.mes)=1 then '0' + cast(cd.mes as varchar) + '/'"
	sql = sql & " 			else cast(cd.mes as varchar) + '/'"
	sql = sql & " 		 end + "
	sql = sql & " 		 case"
	sql = sql & " 			when len(cd.dia_mes)=1 then '0' + cast(cd.dia_mes as varchar)"
	sql = sql & " 			else cast(cd.dia_mes as varchar)"
	sql = sql & " 		 end"
	sql = sql & " 		 as dataLancamento, "
	sql = sql & " 		 case"
	sql = sql & " 			when len(cd.dia_mes)=1 then '0' + cast(cd.dia_mes as varchar) + '/'"
	sql = sql & " 			else cast(cd.dia_mes as varchar) + '/'"
	sql = sql & " 		 end + "
	sql = sql & " 		 case"
	sql = sql & " 			when len(cd.mes)=1 then '0' + cast(cd.mes as varchar) + '/'"
	sql = sql & " 			else cast(cd.mes as varchar) + '/'"
	sql = sql & " 		 end + "
	sql = sql & " 		 cast(cd.ano as varchar) as dataLancamentoMostrar, "
	sql = sql & " 		 cd.dia_semana, dbo.FDIA_SEMANA_EXT(cd.dia_semana) as diaDaSemana"
	sql = sql & " from SCA_CALENDARIO_UE c"
	sql = sql & " inner join SCA_CALENDARIO cg on cg.cod_calendario = c.cod_calendario_geral"
	sql = sql & " inner join SCA_CALENDARIO_DIA_UE cd on cd.cod_calendario_ue = c.cod_calendario_ue"
	sql = sql & " inner join sca_calendario_evento e on e.cod_calendario_evento = cd.cod_calendario_evento"
	sql = sql & " where c.ano_letivo = " & strAnoLetivo
	sql = sql & " and c.cod_empresa = " & Session("CodEmpresa")
	sql = sql & " and cg.situacao = 'A'"
	sql = sql & " and c.situacao = 'A'"
	sql = sql & " and e.letivo = 'S' "
	sql = sql & " and cd.dia_semana in	("
	sql = sql & " 						select DiaSemana"
	sql = sql & " 						FROM SCA_HORARIO_AULA"
	sql = sql & " 						WHERE anoletivo = " & strAnoLetivo
	sql = sql & " 						and COD_EMPRESA = " & Session("CodEmpresa")
	sql = sql & " 						and cod_turma = " & intCodTurmaProfessor
	sql = sql & " 						and Cod_Disciplina = " & intCodDisciplina
	sql = sql & " 						and Cod_Colaborador = " & intCodColaboradorProfessor
	sql = sql & " 						)"
	sql = sql & " and CONVERT(char(10), cast(cd.ano as varchar) + '-' + case when len(cd.mes)=1 then '0' + cast(cd.mes as varchar) + '-' else cast(cd.mes as varchar) + '-' end + case when len(cd.dia_mes)=1 then '0' + cast(cd.dia_mes as varchar) else cast(cd.dia_mes as varchar) end,126) between DATEADD(day, -30, getdate()) and getdate()"
	sql = sql & " order by dataLancamento"
	'response.write sql
	RS.OPEN SQL, CNN
	%>
	<select name="txtDataInicial" id="txtDataInicial" class="combo" onchange="submit()">
		<option value="0">Selecione...</option>
	<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(strDataInicial) = trim(rs("dataLancamentoMostrar")) then
				strSelecionado = "selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("dataLancamento") & " " & strSelecionado & ">" & rs("dataLancamentoMostrar") & " - " & rs("diaDaSemana")& "</option>" & vbcrlf
			rs.movenext
		wend
	END IF
	
	rs.close
	%>
	</select>

<%else%>
		<select name="txtDataInicial" id="txtDataInicial" class="combo" onchange="submit()">
			<option value="0">Selecione...</option>
		</select>.
<%end if%>

