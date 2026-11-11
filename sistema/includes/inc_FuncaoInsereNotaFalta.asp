<%
	dim rsFuncao
	set rsFuncao = server.createObject("adodb.recordset")	
	

	function insereNota (codigoTipoNota,strCodAluno,intCodPeriodo,intCodDisciplina,intCodSemestre,intValor,strTipo)
			'strTipo = 'N'ota ou 'F'alta
			
			if intValor<>"" then
				SQL = "INSERT INTO SCA_NOTAS (cod_aluno, cod_empresa, cod_periodo, cod_disciplina, cod_semestre,"
				if strTipo = "N" then 'nota
					SQL = SQL & " nota, "
				else
					SQL = SQL & " falta, "	
				end if
				SQL = SQL & "cod_tipo_avaliacao, anoLetivo ) VALUES ("
				SQL = SQL & "" & strCodAluno & ","	
				SQL = SQL & "" &  Session("CodEmpresa") & ","
				SQL = SQL & "" & intCodPeriodo & ","
				SQL = SQL & "" & intCodDisciplina & ","
				SQL = SQL & "" & intCodSemestre & ","
				if strTipo = "N" then 'nota
					if intValor <>"" then
						SQL = SQL & "" & intValor & ","
					else
						SQL = SQL & "NULL,"
					end if
				else 'falta
					if intValor <>"" then
						SQL = SQL & "" & intValor & ","
					else
						SQL = SQL & "NULL,"
					end if			
				end if
				SQL = SQL & codigoTipoNota & ","
				SQL = SQL & session("strAnoLetivo") & ")"
				'response.Write(SQL) & "<BR><BR>"
				cnn.execute sql
				GravarLog sql
				'*****
			end if
			
	end function
	
	function alteraNota(codigoTipoNota,strCodAluno,intCodPeriodo,intCodDisciplina,intCodSemestre, intValor,strTipo)
		'Altera a nota do boletim
		SQL = "UPDATE SCA_NOTAS SET "
		if strTipo = "N" then
			IF intValor <>"" THEN
				SQL = SQL & " nota = " & intValor & ""
			ELSE
				SQL = SQL & " nota =NULL"
			END IF
		else
			IF intValor <>"" THEN
				SQL = SQL & " falta = " & intValor & ""
			ELSE
				SQL = SQL & " falta =NULL"
			END IF			
		end if
		SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
		SQL = SQL & " AND anoLetivo=" & session("strAnoLetivo")
		SQL = SQL & " AND cod_aluno=" & strCodAluno
		SQL = SQL & " AND cod_periodo=" & intCodPeriodo
		SQL = SQL & " AND cod_disciplina=" & intCodDisciplina 
		SQL = SQL & " AND cod_semestre=" & intCodSemestre
		SQL = SQL & " AND cod_tipo_avaliacao=" & codigoTipoNota
		'response.Write(SQL) & "<BR><BR>"
		cnn.execute sql
		GravarLog sql
end function
	
	function excluiNota(codigoTipoNota,strCodAluno,intCodPeriodo,intCodDisciplina,intCodSemestre)
		'Altera a nota do boletim
		SQL = "DELETE FROM SCA_NOTAS"
		SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
		SQL = SQL & " AND anoLetivo=" & session("strAnoLetivo")
		SQL = SQL & " AND cod_aluno=" & strCodAluno
		SQL = SQL & " AND cod_periodo=" & intCodPeriodo
		SQL = SQL & " AND cod_disciplina=" & intCodDisciplina 
		SQL = SQL & " AND cod_semestre=" & intCodSemestre
		SQL = SQL & " AND cod_tipo_avaliacao=" & codigoTipoNota
		cnn.execute sql
		GravarLog sql
end function
	
	function insereCargaHoraria(intTurma, intCodDisciplina, intTipoNota, intCh,intTipoLancamento)
		'intTipoLancamento= 2 --> 1 a 4
		sql = "insert into SCA_CARGA_HORARIA" 
		sql=sql & "(cod_empresa,cod_turma,cod_tipo_avaliacao,"
		if intTipoLancamento<>2 then ' a disciplina somente é gravada na tabela AVE_carga_horaria_ministrada
			sql=sql & "cod_disciplina,"
		end if
		sql=sql & "carga_horaria)"
		sql=sql & " values("
		sql=sql & Session("CodEmpresa") & ","
		sql=sql & intTurma & ","
		sql=sql & intTipoNota & ","
		if intTipoLancamento<>2 then
			sql=sql & intCodDisciplina & ","
		end if
		sql=sql & intCh & ")"
		cnn.execute sql
		GravarLog sql
end function
	
	function alteraCargaHoraria(intTurma, intCodDisciplina, intTipoNota, intCh,intTipoLancamento)
		if intCh<>"" then
			sql="update SCA_CARGA_HORARIA set"
			sql=sql & " carga_horaria=" & intCh & ""
			sql=sql & " WHERE cod_empresa=" & Session("CodEmpresa")
'			sql=sql & " AND ano_letivo=" & session("strAnoLetivo")  
			sql=sql & " AND cod_turma=" & intTurma 
			sql=sql & " AND cod_tipo_avaliacao=" & intTipoNota
			if intTipoLancamento <>2 then
				sql=sql & " AND cod_disciplina=" & intCodDisciplina
			end if
			'response.Write(SQL) & "<BR><BR>"	
			cnn.execute sql
			GravarLog sql
		else
			sql="delete from SCA_CARGA_HORARIA"
			sql=sql & " WHERE cod_empresa=" & Session("CodEmpresa")
'			sql=sql & " AND ano_letivo=" & session("strAnoLetivo")
			sql=sql & " AND cod_turma=" & intTurma 
			sql=sql & " AND cod_tipo_avaliacao=" & intTipoNota
			if intTipoLancamento <>2 then
				sql=sql & " AND cod_disciplina=" & intCodDisciplina
			end if	
			cnn.execute sql
			GravarLog sql
		end if	
		'response.Write(SQL) & "<BR><BR>"
		'response.end			
	end function
	
	function insereSituacaoPromocao(strCodAluno,intCodPeriodo,intCodSemestre,intCodDisciplina,intCodSitDisciplina)
	
'		sql="insert into AVE_aluno_situacao_promocao (cod_aluno,ano_letivo,cod_empresa,semestre,cod_disciplina,codigo_ave_situacao_promocao,usuario_incl,data_hora_incl)"
'		sql=sql & " values(" & strCodAluno & ","
'		sql=sql & "" & session("strAnoLetivo") & "," 
'		sql=sql & Session("CodEmpresa") & ","
'		sql=sql & "" & intCodSemestre & ","
'		sql=sql & intCodDisciplina & ","
'		sql=sql & intCodSitDisciplina & ","
'		sql=sql & "'" & session("strUsuario") & "','" & formataDataBD(Date) & " " & time & "')"
'		'response.Write(SQL) & "<BR><BR>"
'		'response.end
'		cnn.execute sql
GravarLog sql
end function	
	
	function alteraSituacaoPromocao(strCodAluno,intCodPeriodo,intCodSemestre,intCodDisciplina,intCodSitDisciplina)
	
'		'Altera a situação do aluno na disciplina
'		sql="Update AVE_aluno_situacao_promocao set codigo_ave_situacao_promocao=" & intCodSitDisciplina & ","
'		SQL=SQL & " usuario_altr='" & Session("strUsuario") & "',"
'		SQL=SQL & " data_hora_altr='" & formataDataBD(Date) & " " & time & "'"		
'		sql=sql & " WHERE cod_aluno=" & strCodAluno
'		sql=sql & " AND ano_letivo=" & session("strAnoLetivo")
'		sql=sql & " AND cod_empresa=" & Session("CodEmpresa")
'		sql=sql & " AND semestre=" & intCodSemestre
'		sql=sql & " AND cod_disciplina=" & intCodDisciplina			
'		'response.Write(SQL) & "<BR><BR>"	
'		'response.Write(SQL) & "<BR><BR>"
'		'response.end		
'		cnn.execute sql
GravarLog sql
end function
	
	function excluiSituacaoPromocao(strCodAluno,intCodPeriodo,intCodSemestre,intCodDisciplina)
	
'		sql="DELETE FROM AVE_aluno_situacao_promocao"
'		sql=sql & " WHERE AVE_aluno_situacao_promocao.cod_aluno=" & strCodAluno
'		sql=sql & " AND AVE_aluno_situacao_promocao.ano_letivo=" & session("strAnoLetivo")
'		sql=sql & " AND AVE_aluno_situacao_promocao.cod_empresa=" & Session("CodEmpresa")
'		sql=sql & " AND AVE_aluno_situacao_promocao.semestre=" & intCodSemestre
'		sql=sql & " AND AVE_aluno_situacao_promocao.cod_disciplina=" & intCodDisciplina		
'		'response.Write(SQL) & "<BR><BR>"
'		'response.end
'		cnn.execute sql
GravarLog sql
end function

	function insereFalta(codigoTipoNota,strCodAluno,intCodSerie,intCodSemestre,intFalta)
		
		if intFalta <>"" then
					
			SQL = "INSERT INTO SCA_FALTAS (cod_aluno, cod_empresa, cod_periodo, cod_semestre, falta, cod_tipo_avaliacao) VALUES ("
			SQL = SQL & "" & strCodAluno & ","	
			SQL = SQL & "" & Session("CodEmpresa") & ","
'			SQL = SQL & "" & session("strAnoLetivo") & ","
			SQL = SQL & "" & intCodSerie & ","
			SQL = SQL & "" & intCodSemestre & ","
			if intFalta <>"" then
				SQL = SQL & "" & intFalta & ","
			else
				SQL = SQL & "NULL,"
			end if
			SQL = SQL & "" & codigoTipoNota & ")"
			'response.Write(SQL) & "<BR><BR>"
			cnn.execute sql
			GravarLog sql
		end if
					
	end function

	function excluiFalta(codigoTipoNota,strCodAluno,intCodSerie,intCodSemestre)
		SQL = "delete from SCA_FALTAS"
		SQL = SQL & " WHERE cod_empresa = " & Session("CodEmpresa") & " "
'		SQL = SQL & " AND ano_letivo=" & session("strAnoLetivo") & " "
		SQL = SQL & " AND cod_aluno = " & strCodAluno & " "
		SQL = SQL & " AND cod_periodo = " & intCodSerie & " "
		SQL = SQL & " AND cod_semestre = " & intCodSemestre & " "
		SQL = SQL & " AND cod_tipo_avaliacao = " & intTipoNota & ""
		response.Write "<BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR>" & (SQL) & "<BR><BR>"
		cnn.execute sql
		GravarLog sql
end function	

%>