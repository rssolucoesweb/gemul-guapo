 <%
 response.Expires = 60
 response.Expiresabsolute = Now() - 1
 response.AddHeader "pragma","no-cache"
 response.AddHeader "cache-control","private"
 response.CacheControl = "no-cache"

response.Clear()
'response.Charset = "iso-8859-1"
response.Charset = "utf-8"
%>
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../../includes/inc_formataCPF.asp"-->
<%
	strTipoAcao = request("strTipoAcao")
	'ajusta curso
	curso 			= TRIM(request("curso"))
	if curso="EDUCACAO_INFANTIL" 	then curso = "EDUCAÇÃO INFANTIL"
	if curso="ENSINO_FUNDAMENTAL" 	then curso = "ENSINO FUNDAMENTAL"

'	data_nascimento	= FORMATADATABD(TRIM(request("data_nascimento"))) 
	data_nascimento	= right(request("data_nascimento"),4) & mid(request("data_nascimento"),3,4) & left(request("data_nascimento"),2)

	select case strTipoAcao
		case "carregaIdadeAluno"
			datanasc = request("data_nascimento")
			data = strDataInicialCorteIdadeDaMatricula '"05/01/2015"
			
			dd2 = day(data)
			mm2 = cint(mid(data,4,2))+1 ' month(data) + 1
			yy2 = year(data)
			
			dd = day(datanasc)
			mm = cint(mid(datanasc,4,2)) 'month(datanasc)
			yy = year(datanasc)
			
			
			if yy2 < 100 then	
				yy2 = yy2 + 1900
			end if
			suaIdade = yy2 - yy
			
			if mm2 < mm then
				suaIdade = suaIdade - 1
			end if
			
			if mm2 = mm then 
				if dd2 < dd then 
					suaIdade = suaIdade - 1
				end if
			end if
			
			strMsnIdade = cstr(suaIdade) + " anos até " & data '& " " & month(datanasc) & " " & cint(mid(datanasc,4,2))
			retorno = "{""idade"": """ & cstr(suaIdade) & """,""mensagem"": """ & strMsnIdade & """}"
			response.Write retorno
			
		case "validaRegraEspecialDoisAgrupamentos"
			
			mostra_regra_especial = "N"
			SQL = "SELECT curso"
			SQL = SQL & " FROM MAT_periodo_curso "
			SQL = SQL & " WHERE '" & data_nascimento & "' between DT_INICIAL AND DT_FINAL"
			SQL = SQL & " AND curso = 'REGRA ESPECIAL'"
			rsAux.open sql, cnn, 3, 3
			if not rsAux.eof then	
				mostra_regra_especial = "S"
			end if
			rsAux.close

			retorno = "{""mostra_regra_especial"": """ & mostra_regra_especial & """}"
			response.Write retorno			
			
		case "carregaAlunoSeJaExisteMatricula"
						
			cpf_aluno 		= TRIM(request("strCPFAluno"))
			aluno 			= replace(TRIM(request("strAluno")),"'","")
			mae				= replace(TRIM(request("strMae")),"'","")
			data_nascimento	= FORMATADATABD(TRIM(request("strDataNascimento")))
			
			SQL = "select E.RAZAOSOCIAL, I.codigo, I.cod_aluno, I.chave"
			SQL = SQL & " from MAT_INSCRICAO I"
			SQL = SQL & " inner join SEG_EMPRESA E ON E.CODIGO = I.Cod_empresa"
			SQL = SQL & " where 1=1 "
			if cpf_aluno<>"" then
				SQL = SQL & " and I.cpf = '"&formataCPFBD(cpf_aluno)&"'"
			else
				SQL = SQL & " and I.nome = '"&aluno&"' COLLATE SQL_Latin1_General_CP1_CI_AI "
				SQL = SQL & " and I.mae = '"&mae&"' COLLATE SQL_Latin1_General_CP1_CI_AI "
				SQL = SQL & " and I.data_nascimento = '"&data_nascimento&"'"
			end if
			SQL = SQL & " and I.efetivacao is null and isnull(I.excluido,'N') = 'N'"
			rs.open sql, cnn, 3, 3
			if rs.eof = false then
				destino = "https://gemul-guapo.com.br/matricula/matricula-gemul-fundamental/Comprovante.asp?m=n&cv=" & rs("chave")
				if cpf_aluno="" then
					retorno = "{""codigo"": ""001"",""mensagem"": ""Aluno(a) já possui uma solicitação cadastrada sob o número " & rs("cod_aluno") & ". Você deverá comparecer a Escola " & trim(rs("RAZAOSOCIAL")) & " para a Efetivar sua Matrícula.\nVocê será direcionado para o comprovante da solicitação"",""destino"": """ & destino & """}"
				else	
					retorno = "{""codigo"": ""001"",""mensagem"": ""Aluno(a) já possui uma solicitação cadastrada sob o número " & rs("cod_aluno") & " com o CPF " & formataCPFAP(cpf_aluno) & ". Você deverá comparecer a Escola " & trim(rs("RAZAOSOCIAL")) & " para a Efetivar sua Matrícula.\nVocê será direcionado para o comprovante da solicitação"",""destino"": """ & destino & """}"
				end if
				strEncontrado = "S"
			else		
				strEncontrado = "N"
			end if
			rs.close			

			if strEncontrado = "N" then
				'verifica se o aluno esta ativo em outra unidade
				sql = "SELECT "
				sql = sql & "     A.MATRICULA,"
				sql = sql & "     CC.COD_EMPRESA,"
				sql = sql & "     CC.UNIDADE"
				sql = sql & " FROM SCA_ALUNO A"
				sql = sql & " OUTER APPLY ("
				sql = sql & "     SELECT TOP 1"
				sql = sql & "         C.COD_EMPRESA,"
				sql = sql & "         C.COD_SITUACAOALUNO,"
				sql = sql & "         E.RAZAOSOCIAL AS UNIDADE"
				sql = sql & "     FROM SCA_CONTROLE_SITUACAO_ALUNO C"
				sql = sql & "     INNER JOIN SEG_EMPRESA E ON E.CODIGO = C.COD_EMPRESA"
				sql = sql & "     WHERE "
				sql = sql & "         C.COD_ALUNO = A.CODIGO"
				sql = sql & "         AND C.ANO_LETIVO = " & trim(session("strAnoLetivo"))
				sql = sql & "     ORDER BY C.CODIGO DESC"
				sql = sql & " ) CC"
				sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA "
				sql = sql & "     ON SA.Cod_SituacaoAluno = CC.COD_SITUACAOALUNO"
				if cpf_aluno<>"" then
					SQL = SQL & " where A.cpf = '"&formataCPFBD(cpf_aluno)&"'"
					SQL = SQL & " and SA.Desc_SituacaoAluno in ('ATIVO','PRÉ-MATRÍCULA')"
				else
					SQL = SQL & " where A.NOMEALUNO = '"&aluno&"'  COLLATE SQL_Latin1_General_CP1_CI_AI "
					SQL = SQL & " and A.MAE = '"&mae&"' COLLATE SQL_Latin1_General_CP1_CI_AI "
					SQL = SQL & " and A.DATANASCIMENTO = '"&data_nascimento&"'"
					SQL = SQL & " and SA.Desc_SituacaoAluno in ('ATIVO','PRÉ-MATRÍCULA')"
				end if
				'response.write sql
				rs.open sql, cnn,3,3
				
				if rs.eof = false then
					destino = "inscricao.html"
					if cpf_aluno="" then
						retorno = "{""codigo"": ""001"",""mensagem"": ""Aluno(a) já está matriculado na rede municipal no(a) " & trim(rs("UNIDADE")) & " com a matrícula: " & rs("matricula") & ". Você deverá comparecer a escola para regularizar sua situação!"",""destino"": """ & destino & """}"
					else	
						retorno = "{""codigo"": ""001"",""mensagem"": ""Aluno(a) já está matriculado na rede municipal no(a) " & trim(rs("UNIDADE")) & " com a matrícula: " & rs("matricula") & " com o CPF " & formataCPFAP(cpf_aluno) & ". Você deverá comparecer a escola para regularizar sua situação!"",""destino"": """ & destino & """}"
					end if					
					strEncontrado = "S"
				else
					strEncontrado = "N"
				end if
				rs.close	
			end if
			
			if strEncontrado = "N" and aluno<>"" and mae<>"" and data_nascimento<>"" then
				'verifica se o aluno esta ativo em outra unidade
				sql = "SELECT "
				sql = sql & "     A.MATRICULA,"
				sql = sql & "     CC.COD_EMPRESA,"
				sql = sql & "     CC.UNIDADE"
				sql = sql & " FROM SCA_ALUNO A"
				sql = sql & " OUTER APPLY ("
				sql = sql & "     SELECT TOP 1"
				sql = sql & "         C.COD_EMPRESA,"
				sql = sql & "         C.COD_SITUACAOALUNO,"
				sql = sql & "         E.RAZAOSOCIAL AS UNIDADE"
				sql = sql & "     FROM SCA_CONTROLE_SITUACAO_ALUNO C"
				sql = sql & "     INNER JOIN SEG_EMPRESA E ON E.CODIGO = C.COD_EMPRESA"
				sql = sql & "     WHERE "
				sql = sql & "         C.COD_ALUNO = A.CODIGO"
				sql = sql & "         AND C.ANO_LETIVO = " & trim(session("strAnoLetivo"))
				sql = sql & "     ORDER BY C.CODIGO DESC"
				sql = sql & " ) CC"
				sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA "
				sql = sql & "     ON SA.Cod_SituacaoAluno = CC.COD_SITUACAOALUNO"
				SQL = SQL & " where A.NOMEALUNO = '"&aluno&"'  COLLATE SQL_Latin1_General_CP1_CI_AI "
				SQL = SQL & " and A.MAE = '"&mae&"' COLLATE SQL_Latin1_General_CP1_CI_AI "
				SQL = SQL & " and A.DATANASCIMENTO = '"&data_nascimento&"'"
				SQL = SQL & " and SA.Desc_SituacaoAluno in ('ATIVO','PRÉ-MATRÍCULA')"
				'response.write sql
				rs.open sql, cnn,3,3
				
				if rs.eof = false then
					destino = "inscricao.html"
					retorno = "{""codigo"": ""001"",""mensagem"": ""Aluno(a) já está matriculado na rede municipal no(a) " & trim(rs("UNIDADE")) & " com a matrícula: " & rs("matricula") & ". Você deverá comparecer a escola para regularizar sua situação!"",""destino"": """ & destino & """}"
					strEncontrado = "S"
				else
					strEncontrado = "N"
				end if
				rs.close	
			end if
			
			if strEncontrado = "N" then
				retorno = "{""codigo"": ""001"",""mensagem"": ""ok"",""destino"": """"}"
			end if
			
			response.write retorno
		case "carregaAlunoSeJaExisteReserva"
			strEncontrado = "N"			
			cpf_aluno 		= TRIM(request("strCPFAluno"))
			aluno 			= replace(TRIM(request("strAluno")),"'","")
			mae				= replace(TRIM(request("strMae")),"'","")
			data_nascimento	= FORMATADATABD(TRIM(request("strDataNascimento")))
			if cpf_aluno<>"" then
				SQL = "select E.RAZAOSOCIAL, I.codigo, I.cod_aluno, I.chave"
				SQL = SQL & " from MAT_INSCRICAO I"
				SQL = SQL & " inner join SEG_EMPRESA E ON E.CODIGO = I.Cod_empresa"
				SQL = SQL & " where I.cpf = '"&formataCPFBD(cpf_aluno)&"'"
				SQL = SQL & " and isnull(I.excluido,'N') = 'N'"
				rs.open sql, cnn, 3, 3
				if rs.eof = false then
					destino = "https://gemul-guapo.com.br/matricula/matricula-gemul-fundamental/Comprovante.asp?m=n&cv=" & rs("chave")
					if cpf_aluno="" then
						retorno = "{""codigo"": ""001"",""mensagem"": ""Aluno(a) já possui uma solicitação cadastrada sob o número " & rs("cod_aluno") & ". Você deverá comparecer a Escola " & rs("RAZAOSOCIAL") & " para a Efetivar sua Matrícula."",""destino"": """ & destino & """}"
					else	
						retorno = "{""codigo"": ""001"",""mensagem"": ""Aluno(a) já possui uma solicitação cadastrada sob o número " & rs("cod_aluno") & " com o CPF " & formataCPFAP(cpf_aluno) & ". Você deverá comparecer a Escola " & rs("RAZAOSOCIAL") & " para a Efetivar sua Matrícula."",""destino"": """ & destino & """}"
					end if
					strEncontrado = "S"
				else		
					strEncontrado = "N"
				end if
				rs.close
			end if
			
			if strEncontrado = "N" then
				SQL = "select E.RAZAOSOCIAL, I.codigo, I.cod_aluno, I.chave"
				SQL = SQL & " from MAT_INSCRICAO I"
				SQL = SQL & " inner join SEG_EMPRESA E ON E.CODIGO = I.Cod_empresa"
				SQL = SQL & " where I.nome = '"&aluno&"' COLLATE SQL_Latin1_General_CP1_CI_AI "
				SQL = SQL & " and I.mae = '"&mae&"' COLLATE SQL_Latin1_General_CP1_CI_AI "
				SQL = SQL & " and I.data_nascimento = '"&data_nascimento&"'"
				SQL = SQL & " and isnull(I.excluido,'N') = 'N'"
				rs.open sql, cnn, 3, 3
				if rs.eof = false then
					destino = "https://gemul-guapo.com.br/matricula/matricula-gemul-fundamental/Comprovante.asp?m=n&cv=" & rs("chave")
					if cpf_aluno="" then
						retorno = "{""codigo"": ""001"",""mensagem"": ""Aluno(a) já possui uma solicitação cadastrada sob o número " & rs("cod_aluno") & ". Você deverá comparecer a Escola " & rs("RAZAOSOCIAL") & " para a Efetivar sua Matrícula."",""destino"": """ & destino & """}"
					else	
						retorno = "{""codigo"": ""001"",""mensagem"": ""Aluno(a) já possui uma solicitação cadastrada sob o número " & rs("cod_aluno") & " com o CPF " & formataCPFAP(cpf_aluno) & ". Você deverá comparecer a Escola " & rs("RAZAOSOCIAL") & " para a Efetivar sua Matrícula."",""destino"": """ & destino & """}"
					end if
					strEncontrado = "S"
				else		
					strEncontrado = "N"
				end if
				rs.close			
			end if
			
			if strEncontrado = "N" and cpf_aluno<>"" then
				cod_aluno_reserva = ""
				SQL = "select inscricao, cod_aluno, chave"
				SQL = SQL & " from MAT_RESERVA "
				SQL = SQL & " where cpf = '"&formataCPFBD(cpf_aluno)&"'"
				SQL = SQL & " and data_exc_cadastro is null "
				rs.open sql, cnn, 3, 3
				if rs.eof = false then
					cod_aluno_reserva = rs("cod_aluno")
					strChave = rs("chave")
					strCadastro = rs("inscricao")
					if isnull(cod_aluno_reserva) then
						cod_aluno_reserva = ""
						destino = "https://gemul-guapo.com.br/matricula/matricula-gemul-fundamental/Comprovante_reserva.asp?m=n&cv=" & rs("chave")
						if cpf_aluno="" then
							retorno = "{""codigo"": ""001"",""mensagem"": ""Aluno(a) já possui uma solicitação reserva sob o número " & rs("inscricao") & "."",""destino"": """ & destino & """}"
						else
							retorno = "{""codigo"": ""001"",""mensagem"": ""Aluno(a) já possui uma solicitação reserva sob o número " & rs("inscricao") & " com o CPF " & formataCPFAP(cpf_aluno) & "."",""destino"": """ & destino & """}"
						end if
						strEncontrado = "S"
					else
						strEncontrado = "N"
						
						'verificar se o aluno está ativo
						SQL = "select a.CODIGO"
						SQL = SQL & " from SCA_ALUNO a"
						SQL = SQL & " inner join SCA_SITUACAOALUNO s on s.Cod_SituacaoAluno = a.COD_SITUACAOALUNO"
						SQL = SQL & " WHERE a.CODIGO = " & cod_aluno_reserva
						SQL = SQL & " and s.Desc_SituacaoAluno in ('ATIVO','PRÉ-MATRÍCULA')"
						RSaux.OPEN SQL, CNN
						IF not RSaux.EOF THEN
							destino = "https://gemul-guapo.com.br/matricula/matricula-gemul-fundamental/Comprovante_reserva.asp?m=n&cv=" & strChave
							if cpf_aluno="" then
								retorno = "{""codigo"": ""001"",""mensagem"": ""Aluno(a) já possui uma solicitação reserva sob o número " & strCadastro & "."",""destino"": """ & destino & """}"
							else
								retorno = "{""codigo"": ""001"",""mensagem"": ""Aluno(a) já possui uma solicitação reserva sob o número " & strCadastro & " com o CPF " & formataCPFAP(cpf_aluno) & "."",""destino"": """ & destino & """}"
							end if
							strEncontrado = "S"
							
						END IF
						RSaux.CLOSE
						
					end if
				else		
					strEncontrado = "N"
				end if
				rs.close		
			end if
			
			if strEncontrado = "N" then
				cod_aluno_reserva = ""
				SQL = "select inscricao, cod_aluno, chave, nome"
				SQL = SQL & " from MAT_RESERVA "
				SQL = SQL & " where nome = '"&aluno&"' COLLATE SQL_Latin1_General_CP1_CI_AI "
				SQL = SQL & " and mae = '"&mae&"' COLLATE SQL_Latin1_General_CP1_CI_AI "
				SQL = SQL & " and data_nascimento = '"&data_nascimento&"'"
				SQL = SQL & " and data_exc_cadastro is null "
				rs.open sql, cnn, 3, 3
				if rs.eof = false then
					cod_aluno_reserva = rs("cod_aluno")
					strChave = rs("chave")
					strCadastro = rs("inscricao")
					if isnull(cod_aluno_reserva) then
						cod_aluno_reserva = ""
						destino = "https://gemul-guapo.com.br/matricula/matricula-gemul-fundamental/Comprovante_reserva.asp?m=n&cv=" & rs("chave")
						retorno = "{""codigo"": ""001"",""mensagem"": ""Aluno(a) já possui uma solicitação reserva sob o número " & rs("inscricao") & "."",""destino"": """ & destino & """}"
						strEncontrado = "S"
					else
						strEncontrado = "N"
						
						'verificar se o aluno está ativo
						SQL = "select a.CODIGO"
						SQL = SQL & " from SCA_ALUNO a"
						SQL = SQL & " inner join SCA_SITUACAOALUNO s on s.Cod_SituacaoAluno = a.COD_SITUACAOALUNO"
						SQL = SQL & " WHERE a.CODIGO = " & cod_aluno_reserva
						SQL = SQL & " and s.Desc_SituacaoAluno in ('ATIVO','PRÉ-MATRÍCULA')"
						RSaux.OPEN SQL, CNN
						IF not RSaux.EOF THEN
							
							destino = "https://gemul-guapo.com.br/matricula/matricula-gemul-fundamental/Comprovante_reserva.asp?m=n&cv=" & strChave
							retorno = "{""codigo"": ""001"",""mensagem"": ""Aluno(a) já possui uma solicitação reserva sob o número " & strCadastro & "."",""destino"": """ & destino & """}"
							strEncontrado = "S"
							
						END IF
						RSaux.CLOSE
						
					end if
				else		
					strEncontrado = "N"
				end if
				rs.close		
			end if
			
			if strEncontrado = "N" then
				if cod_aluno_reserva <> "" then
					sql = "SELECT "
					sql = sql & "     A.MATRICULA,"
					sql = sql & "     CC.COD_EMPRESA,"
					sql = sql & "     CC.UNIDADE"
					sql = sql & " FROM SCA_ALUNO A"
					sql = sql & " OUTER APPLY ("
					sql = sql & "     SELECT TOP 1"
					sql = sql & "         C.COD_EMPRESA,"
					sql = sql & "         C.COD_SITUACAOALUNO,"
					sql = sql & "         E.RAZAOSOCIAL AS UNIDADE"
					sql = sql & "     FROM SCA_CONTROLE_SITUACAO_ALUNO C"
					sql = sql & "     INNER JOIN SEG_EMPRESA E ON E.CODIGO = C.COD_EMPRESA"
					sql = sql & "     WHERE "
					sql = sql & "         C.COD_ALUNO = A.CODIGO"
					sql = sql & "         AND C.ANO_LETIVO = " & trim(session("strAnoLetivo"))
					sql = sql & "     ORDER BY C.CODIGO DESC"
					sql = sql & " ) CC"
					sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA "
					sql = sql & "     ON SA.Cod_SituacaoAluno = CC.COD_SITUACAOALUNO"
					SQL = SQL & " where A.NOMEALUNO = '"&aluno&"'  COLLATE SQL_Latin1_General_CP1_CI_AI "
					SQL = SQL & " and A.MAE = '"&mae&"' COLLATE SQL_Latin1_General_CP1_CI_AI "
					SQL = SQL & " and A.DATANASCIMENTO = '"&data_nascimento&"'"
					SQL = SQL & " and SA.Desc_SituacaoAluno in ('ATIVO','PRÉ-MATRÍCULA')"
					rs.open sql, cnn,3,3
					if rs.eof = false then
						destino = "inscricao.html"
						retorno = "{""codigo"": ""001"",""mensagem"": ""Aluno(a) já está matriculado na rede municipal no(a) " & trim(rs("UNIDADE")) & " com a matrícula: " & rs("matricula") & ". Você deverá comparecer a escola para regularizar sua situação!"",""destino"": """ & destino & """}"
						strEncontrado = "S"
					else
						strEncontrado = "N"
					end if
					rs.close
				end if
			end if
			
			
			
			if strEncontrado = "N" then
				retorno = "{""codigo"": ""001"",""mensagem"": ""ok"",""destino"": """"}"
			end if
			
			response.write retorno		
		case "carregaPeriodoIdadeMinima"
			'data_nascimento	= FORMATADATABD(TRIM(request("data_nascimento")))
			mensagem = ""
			if data_nascimento <> "" then
				SQL = "SELECT curso"
				SQL = SQL & " FROM MAT_periodo_curso"
				SQL = SQL & " WHERE '" & data_nascimento & "' between DT_INICIAL AND DT_FINAL"
				'response.write sql
				rs.open sql, cnn, 3, 3
				if rs.eof = false then	
					IF rs("curso") = "NAO_ATENDE" THEN
						response.Write( "NAO_ATENDE" )
					ELSE
						response.Write( "OK" )
					END IF
				else
					response.Write( "OK" )
				end if
				rs.close
			end if
		case "validaIdadeParaMatricula"
			'response.write TRIM(request("data_nascimento"))
			'data_nascimento	= right(request("data_nascimento"),4) & "/" & mid(request("data_nascimento"),3,4) & "/" & left(request("data_nascimento"),2)
			'response.write curso
			data_nascimento	= right(request("data_nascimento"),4) & mid(request("data_nascimento"),3,4) & left(request("data_nascimento"),2)
			'response.write data_nascimento
			'data_nascimento	= FORMATADATABD(TRIM(request("data_nascimento")))
			'response.end
			if data_nascimento <> "" and curso <> "" then
				retorno = ""
				
				
				SQL = "SELECT curso"
				SQL = SQL & " FROM MAT_periodo_valido_matricula"
				SQL = SQL & " WHERE '" & data_nascimento & "' between DT_INICIAL AND DT_FINAL"
				SQL = SQL & " AND curso = '" & curso & "'"
				
				rs.open sql, cnn, 3, 3
				if rs.eof then	
					if trim(curso) = "ENSINO FUNDAMENTAL" then
						'achou = "N"				
						retira_mensagem = "N"
						''nova regra para dois agrupamento (especial)
						SQL = "SELECT curso"
						SQL = SQL & " FROM MAT_periodo_curso "
						SQL = SQL & " WHERE '" & data_nascimento & "' between DT_INICIAL AND DT_FINAL"
						SQL = SQL & " AND curso = 'REGRA ESPECIAL'"
						'response.write sql
						rsAux.open sql, cnn, 3, 3
						if not rsAux.eof then	
							retira_mensagem = "S"				
						end if
						rsAux.close
						
						if retira_mensagem = "N" then
							retorno = "{""codigo"": ""001"",""mensagem"": ""A idade não é permitida para este curso, para ENSINO FUNDAMENTAL a idade mínima é de 6 anos e a máxima é de 15 anos!""}"
						end if
						
					elseif trim(curso) = "EDUCAÇÃO INFANTIL" then
						retorno = "{""codigo"": ""001"",""mensagem"": ""A idade não é permitida para este curso, a matrícula deverá ser solicitada no ENSINO FUNDAMENTAL!""}"
					elseif trim(curso) = "EJA 1º SEGMENTO" then
						retorno = "{""codigo"": ""001"",""mensagem"": ""A idade não é permitida para este curso, para EJA 1º SEGMENTO a idade mínina é de 15 anos!""}"
					end if	
				else
					retorno = "{""codigo"": ""001"",""mensagem"": ""ok""}"
				end if
				
			end if
			response.write retorno
		case "carregaEscola"

			bairro 			= TRIM(request("bairro"))
			serie 			= TRIM(request("serie"))
			turno 			= TRIM(request("turno"))
			bolsaFamilia 	= TRIM(request("bolsaFamilia"))
			if bolsaFamilia = "" then bolsaFamilia = "N"
			if isnull(bolsaFamilia) then bolsaFamilia = "N"

			'regra para ajustar o turno quando for ed. infantil e integral (CMEIS)
			if curso = "EDUCAÇÃO INFANTIL" and turno = "INTEGRAL"  then
			
				SQL = "select distinct SEG_EMPRESA.CODIGO AS COD_EMPRESA, SEG_EMPRESA.RAZAOSOCIAL,SEG_EMPRESA.BAIRRO, SEG_GRUPO.codigo AS CodGrupo,"
				SQL = SQL & " SEG_GRUPO.DESCRICAO AS GRUPO "
				SQL = SQL & " FROM SEG_EMPRESA "
				SQL = SQL & " INNER JOIN SEG_TIPOEMPRESA ON SEG_TIPOEMPRESA.CODIGO = SEG_EMPRESA.CODTIPOEMPRESA AND SEG_EMPRESA.COD_GRUPO = SEG_TIPOEMPRESA.COD_GRUPO"
				SQL = SQL & " LEFT JOIN SEG_GRUPO  ON SEG_EMPRESA.COD_GRUPO = SEG_GRUPO.CODIGO"
				SQL = SQL & " WHERE SEG_GRUPO.codigo = " & intCodGrupo
				SQL = SQL & " AND SEG_TIPOEMPRESA.CODIGO <> 5"
				'SQL = SQL & " AND 	SEG_TIPOEMPRESA.DESCRICAO = 'CMEIS'"
				SQL = SQL & " AND 	SEG_EMPRESA.codigo in ("
				SQL = SQL & " 						select distinct tu.Cod_Empresa"
				SQL = SQL & " 						from SCA_TURMA TU"
				SQL = SQL & " 						inner join SCA_GRADECURRICULAR GD on GD.Cod_GradeCurricular = TU.Cod_GradeCurricular "
				SQL = SQL & " 						inner join SCA_PERIODO PE ON PE.Cod_Periodo = GD.Cod_Periodo "
				SQL = SQL & " 						inner join SCA_TURNO TUR ON TUR.Cod_Turno = TU.Cod_Turno "
				SQL = SQL & " 						where TU.Cod_Empresa in (select codigo from SEG_EMPRESA where COD_GRUPO="&intCodGrupo&" and BLOQUEIO='N')"
				SQL = SQL & " 						and TU.Situacao = 'A'"
				SQL = SQL & " 						and tu.AnoLetivo = " & strAnoLetivo
				SQL = SQL & " 						and tu.COD_SEMESTRE = " & strSemestre
				SQL = SQL & " 						and PE.Descricao = '" & serie & "'"
				SQL = SQL & " 						and PE.Matricula = 'S'"
				SQL = SQL & " 						and TUR.Desc_Turno = '"&turno&"'"
				SQL = SQL & " 						and isnull(TU.Capacidade,0) - isnull(TU.VagasReservadas,0) -  isnull(TU.VagasMatriculasUtilizadas,0) > 0"	
				'if trim(bolsaFamilia) = "N" and turno = "INTEGRAL" and left(serie,11) = "AGRUPAMENTO" then
				'	SQL = SQL & " 					AND (SELECT (SUM(CASE WHEN VagasMatriculaInicial<= 0 THEN 0 ELSE VagasMatriculaInicial END)* 30)/100 "
				'	SQL = SQL & " 						FROM SCA_TURMA T1 "
				'	SQL = SQL & " 						INNER JOIN SCA_GRADECURRICULAR G1 ON G1.Cod_GradeCurricular = T1.Cod_GradeCurricular "
				'	SQL = SQL & " 						INNER JOIN SCA_PERIODO P1 ON P1.Cod_Periodo = G1.Cod_Periodo "
				'	SQL = SQL & " 						INNER JOIN SCA_CURSO C1 ON C1.Cod_curso = P1.Cod_Curso "
				'	SQL = SQL & " 						INNER JOIN SCA_TURNO TU1 ON TU1.Cod_Turno = T1.Cod_Turno "
				'	SQL = SQL & " 						WHERE T1.Cod_empresa = TU.Cod_Empresa "
				'	SQL = SQL & " 						and T1.AnoLetivo = " & strAnoLetivo
				'	SQL = SQL & " 						and T1.COD_SEMESTRE = " & strSemestre
				'	SQL = SQL & " 						AND SUBSTRING(P1.Descricao,1,11) = 'AGRUPAMENTO' "
				'	SQL = SQL & " 						AND TU1.Desc_Turno = '"&turno&"'	) "		
				'	SQL = SQL & " 						> "		
				'	SQL = SQL & " 						(SELECT COUNT(CODIGO) FROM MAT_inscricao MI "	
				'	SQL = SQL & " 						INNER JOIN SCA_PERIODO P1 ON P1.Cod_Periodo = MI.Cod_Periodo "	
				'	SQL = SQL & " 						INNER JOIN SCA_CURSO C1 ON C1.Cod_curso = P1.Cod_Curso "	
				'	SQL = SQL & " 						INNER JOIN SCA_TURNO TU1 ON TU1.Cod_Turno = MI.Cod_Turno "	
				'	SQL = SQL & " 						WHERE MI.Cod_empresa = TU.Cod_Empresa "
				'	SQL = SQL & " 						and isnull(Bolsa_Familia,'0') = '0' AND MI.excluido='N' " 
				'	SQL = SQL & " 						AND SUBSTRING(P1.Descricao,1,11) = 'AGRUPAMENTO' " 
				'	SQL = SQL & " 						AND TU1.Desc_Turno = '"&turno&"'	) "		
				'end if
				SQL = SQL & " 	)"
				'inicio regra nova para buscar pelo setor(bairro)
				'SQL = SQL & " AND 	SEG_EMPRESA.codigo in ("
				'SQL = SQL & " 								select distinct cod_empresa "
				'SQL = SQL & " 								from mat_setores s "
				'SQL = SQL & " 								inner join MAT_regiao_setores rs on rs.cod_setores = s.codigo "
				'SQL = SQL & " 								INNER JOIN MAT_regiao_empresa re on re.cod_regiao = rs.cod_regiao "
				'SQL = SQL & " 								where s.descricao = '" & bairro & "')"
				'fim regra nova para buscar pelo setor(bairro)				
				SQL = SQL & " Order by SEG_GRUPO.DESCRICAO, SEG_EMPRESA.RAZAOSOCIAL"
			else
				SQL = "select distinct SEG_EMPRESA.CODIGO AS COD_EMPRESA, SEG_EMPRESA.RAZAOSOCIAL,SEG_EMPRESA.BAIRRO, SEG_GRUPO.codigo AS CodGrupo,"
				SQL = SQL & " SEG_GRUPO.DESCRICAO AS GRUPO "
				SQL = SQL & " FROM SEG_EMPRESA "
				SQL = SQL & " INNER JOIN SEG_TIPOEMPRESA ON SEG_TIPOEMPRESA.CODIGO = SEG_EMPRESA.CODTIPOEMPRESA AND SEG_EMPRESA.COD_GRUPO = SEG_TIPOEMPRESA.COD_GRUPO"
				SQL = SQL & " LEFT JOIN SEG_GRUPO  ON SEG_EMPRESA.COD_GRUPO = SEG_GRUPO.CODIGO"
				SQL = SQL & " WHERE SEG_GRUPO.codigo = " & intCodGrupo
				SQL = SQL & " AND SEG_TIPOEMPRESA.CODIGO <> 5"
				'SQL = SQL & " AND 	SEG_TIPOEMPRESA.DESCRICAO <> 'CMEIS'"
				SQL = SQL & " AND 	SEG_EMPRESA.codigo in ("
				SQL = SQL & " 						select distinct tu.Cod_Empresa"
				SQL = SQL & " 						from SCA_TURMA TU"
				SQL = SQL & " 						inner join SCA_GRADECURRICULAR GD on GD.Cod_GradeCurricular = TU.Cod_GradeCurricular"
				SQL = SQL & " 						inner join SCA_PERIODO PE ON PE.Cod_Periodo = GD.Cod_Periodo "
				SQL = SQL & " 						inner join SCA_TURNO TUR ON TUR.Cod_Turno = TU.Cod_Turno"
				SQL = SQL & " 						where TU.Cod_Empresa in (select codigo from SEG_EMPRESA where COD_GRUPO="&intCodGrupo&" and BLOQUEIO='N')"
				SQL = SQL & " 						and TU.Situacao = 'A'"
				SQL = SQL & " 						and tu.AnoLetivo = " & strAnoLetivo
				SQL = SQL & " 						and tu.Cod_semestre = " & strSemestre
				SQL = SQL & " 						and PE.Descricao = '" & serie & "'"
				SQL = SQL & " 						and PE.Matricula = 'S'"
				SQL = SQL & " 						and TUR.Desc_Turno = '" & turno & "'"
				SQL = SQL & " 						and isnull(TU.Capacidade,0) - isnull(TU.VagasReservadas,0) -  isnull(TU.VagasMatriculasUtilizadas,0) > 0"	
				SQL = SQL & " 	)"
				'inicio regra nova para buscar pelo setor(bairro)
				'SQL = SQL & " AND 	SEG_EMPRESA.codigo in ("
				'SQL = SQL & " 								select distinct cod_empresa "
				'SQL = SQL & " 								from mat_setores s "
				'SQL = SQL & " 								inner join MAT_regiao_setores rs on rs.cod_setores = s.codigo "
				'SQL = SQL & " 								INNER JOIN MAT_regiao_empresa re on re.cod_regiao = rs.cod_regiao "
				'SQL = SQL & " 								where s.descricao = '" & bairro & "')"
				'fim regra nova para buscar pelo setor(bairro)			
				SQL = SQL & " Order by SEG_GRUPO.DESCRICAO, SEG_EMPRESA.RAZAOSOCIAL"
			end if	
			'response.Write(sql)
			'RESPONSE.END
			rs.open sql, cnn, 3, 3
			if rs.eof = false then
				retorno = "["
				while not rs.eof		
					retorno = retorno & "{""codigo"": """ & trim(rs("COD_EMPRESA")) & """, ""descricao"": """ & UCASE(TRIM(rs("RAZAOSOCIAL"))) & " (" & UCASE(TRIM(RS("BAIRRO"))) & ")""}"				
					rs.movenext
					if not rs.eof then
						retorno = retorno & ","
					end if					
				wend
				retorno = retorno & "]"
			else
				retorno = "[{""codigo"": ""0"", ""descricao"": ""Não existe escola disponível""}]"
			end if
			rs.close
			response.write retorno
				
		
		case "carregaTurno"
			serie 			= TRIM(request("serie"))
			idade 			= 10'TRIM(request("idade"))
			
			'regra criada para atender o turno integra para o cadastro de reserva
			'if left(serie,11) = "AGRUPAMENTO" THEN
			'	sql = "select 'INTEGRAL'  as turno"
			'	sql = sql & " union "
			'ELSE
			'	sql = ""
			'END IF
			'-------------------
			'if TRIM(serie) = "AGRUPAMENTO I" OR TRIM(serie) = "AGRUPAMENTO II" OR TRIM(serie) = "AGRUPAMENTO III" OR TRIM(serie) = "AGRUPAMENTO IV" THEN
			''	SQL = SQL & " 						select distinct 'INTEGRAL' as turno"
			'ELSE
				'SQL = " 						select distinct tur.Desc_Turno as turno"
			'END IF 
			
			
			SQL = " 						select distinct 'MATUTINO' as turno union "
			SQL = SQL & "					select distinct 'VESPERTINO' as turno union "
			SQL = SQL & "					select distinct 'INTEGRAL' as turno  "
			'SQL = SQL & " 						select distinct tur.Desc_Turno as turno"
			'SQL = SQL & " 						from SCA_TURMA TU"
			'SQL = SQL & " 						inner join SCA_GRADECURRICULAR GD on GD.Cod_GradeCurricular = TU.Cod_GradeCurricular"
			'SQL = SQL & " 						inner join SCA_PERIODO PE ON PE.Cod_Periodo = GD.Cod_Periodo "
			'SQL = SQL & " 						inner join SCA_TURNO TUR ON TUR.Cod_Turno = TU.Cod_Turno "
			'SQL = SQL & " 						where TU.Cod_Empresa in (select codigo from SEG_EMPRESA where COD_GRUPO="&intCodGrupo&" and BLOQUEIO='N')"
			'SQL = SQL & " 						and TU.Situacao = 'A'"
			'SQL = SQL & " 						and tu.AnoLetivo = " & strAnoLetivo
			'SQL = SQL & " 						and PE.Descricao = '" & serie & "'"
			'SQL = SQL & " 						and PE.Matricula = 'S'"
			'SQL = SQL & " 						and isnull(TU.Capacidade,0) - isnull(TU.VagasReservadas,0) -  isnull(TU.VagasMatriculasUtilizadas,0) > 0"			
			'if idade<15 then
			'	SQL = SQL & " AND 	tur.Desc_Turno <> 'NOTURNO'"
			'end if
			'TEMPORARIO
			'SQL = SQL & " AND 	tur.Desc_Turno <> 'INTEGRAL'"
			'sql = sql & " order by 1"
			rs.open sql, cnn, 3, 3
			if rs.eof = false then
				retorno = "["
				while not rs.eof
					retorno = retorno & "{""codigo"": """ & trim(rs("turno")) & """, ""descricao"": """ & ucase(TRIM(rs("turno"))) & """}"				
					rs.movenext
					if not rs.eof then
						retorno = retorno & ","
					end if
				wend
				retorno = retorno & "]"
			else
				retorno = "[{""codigo"": ""0"", ""descricao"": ""Não foi encontrado""}]"
			end if
			rs.close
			response.write retorno
			
		case "carregaPeriodo"
			'data_nascimento	= FORMATADATABD(TRIM(request("data_nascimento")))
			mensagem = ""
			agrupamento = ""
			achou1a5 = "N"
			achou6a9 = "N"
			achouRegraEspecial = "N"	
			
			if data_nascimento <> "" then
				
				'nova regra para ensino fundamental de 1 a 5 ano
				SQL = "SELECT curso"
				SQL = SQL & " FROM MAT_periodo_valido_matricula"
				SQL = SQL & " WHERE '" & data_nascimento & "' between DT_INICIAL AND DT_FINAL"
				SQL = SQL & " AND curso = 'ENSINO FUNDAMENTAL'"
				rs.open sql, cnn, 3, 3
				if not rs.eof then	
					achou1a5 = "S"				
				end if
				rs.close
				
				'nova regra para ensino fundamental de 6 a 9 ano
				SQL = "SELECT curso"
				SQL = SQL & " FROM MAT_periodo_valido_matricula"
				SQL = SQL & " WHERE '" & data_nascimento & "' between DT_INICIAL AND DT_FINAL"
				SQL = SQL & " AND curso = 'ENSINO FUNDAMENTAL - 6ao9'"
				rs.open sql, cnn, 3, 3
				if not rs.eof then	
					achou6a9 = "S"				
				end if
				rs.close
				
				if curso = "ENSINO FUNDAMENTAL" and (achou1a5 = "S" or achou6a9 = "S") then
					'vai pemanecer o mesmo curso
				else
					SQL = "SELECT curso"
					SQL = SQL & " FROM MAT_periodo_curso"
					SQL = SQL & " WHERE '" & data_nascimento & "' between DT_INICIAL AND DT_FINAL"
					rs.open sql, cnn, 3, 3
					if rs.eof = false then
						
						IF rs("curso") = "NÃO ATENDE" THEN
							retorno = "[{""codigo"": ""0"", ""descricao"": ""Não foi encontrada""}]"
						ELSE
							curso = rs("curso")
						END IF
					end if
					rs.close
				end if
			end if
			
			if TRIM(LEFT(curso,11)) <> "AGRUPAMENTO" then
				sql = "select distinct Descricao as serie"
				sql = sql & " from SCA_PERIODO"
				sql = sql & " where cod_curso in (2,3)"
				sql = sql & " and Matricula = 'S'"
				if achou1a5 = "S" then
					sql = sql & " and Cod_periodo in "
					sql = sql & " ("
					sql = sql & " select cod_periodo"
					sql = sql & " from SCA_PERIODO"
					sql = sql & " where Matricula = 'S'"
					sql = sql & " )"					
				end if
				if achou6a9 = "S" then
					sql = sql & " and Cod_periodo in "
					sql = sql & " ("
					sql = sql & " select cod_periodo"
					sql = sql & " from SCA_PERIODO"
					sql = sql & " where Matricula = 'S'"
					sql = sql & " )"					
				end if
				sql = sql & " order by 1"
				'response.write sql
				rs.open sql, cnn, 3, 3
				if rs.eof = false then
					retorno = "["
					while not rs.eof
						retorno = retorno & "{""codigo"": """ & trim(rs("serie")) & """, ""descricao"": """ & ucase(TRIM(rs("serie"))) & """}"			
						rs.movenext
						if not rs.eof then
							retorno = retorno & ","
						end if
					wend
					retorno = retorno & "]"
				else
					retorno = "[{""codigo"": ""0"", ""descricao"": ""Não foi encontrada""}]"
				end if
				rs.close	
				response.write retorno
						
			else
				sql = "select distinct Descricao as serie"
				sql = sql & " from SCA_PERIODO"
				sql = sql & " where Descricao = '" & curso & "'"
				sql = sql & " and Matricula = 'S'"
				sql = sql & " order by 1"
				rs.open sql, cnn, 3, 3
				if rs.eof = false then
					retorno = "["
					while not rs.eof
						retorno = retorno & "{""codigo"": """ & trim(rs("serie")) & """, ""descricao"": """ & ucase(TRIM(rs("serie"))) & """}"				
						rs.movenext
						if not rs.eof then
							retorno = retorno & ","
						end if
					wend
					retorno = retorno & "]"
				else
					retorno = "[{""codigo"": ""0"", ""descricao"": ""Não foi encontrada""}]"
				end if
				rs.close
				response.write retorno
			end if		
		
		end select
%>