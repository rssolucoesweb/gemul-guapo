<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%response.Buffer=false%>
<%SESSION.Timeout = 1200%>
<%Server.ScriptTimeout = 900 %>
<%

strModelo	 			= Trim(Request("modelo"))
if strModelo = "TRANSCOLAR" then
	nome_arquivo = "transcolar.csv"
elseif strModelo = "SETE_FNDE" then
	nome_arquivo = "modelo_importacao.csv"
end if
Response.ContentType = "text/csv"
Response.AddHeader "Content-Disposition", "attachment;filename=" & nome_arquivo
response.Charset = "utf-8" 
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_formataCPF.asp"-->
<!--#include file="includes/inc_log.asp"-->
<%  
intCodGrupo				= Session("CodGrupo") 		

strRede		 			= Trim(Request("rede"))
intCodEmpresa 			= Trim(Request("cmbEmpresa"))
intCodEscolaEstadual	= Trim(Request("cmbEscolaEstadual"))

Dim header
Dim linha

if strModelo = "TRANSCOLAR" then

	codigo_municipio_ige = "5220454" 'senador canedo
	nome_municipio = "SENADOR CANEDO"
	uf_municipio = "GO"
	
	header = "anobase;sre;tipo_dependencia;inep_escola;nome_escola;endereco_escola;numero_escola;complemento_escola;bairro_escola;codibge7_escola;municipio_escola;estado_escola;cep_escola;ddd_telefone_escola;tipo_ensino;sigla_tipo_ensino;modalidade;submodalidade;serie;classe;periodo_letivo;sigla_concessionaria_escola;codigo_energia_escola;latdec_posicao_original_escola;londec_posicao_original_escola;codibge7_aluno;municipio_aluno;turno_aluno;registro_aluno;matricula_aluno;inep_aluno;nome_aluno;data_nascimento;endereco_aluno;numero_aluno;complemento_aluno;bairro_aluno;estado_aluno;cep_aluno;ddd_telefone_aluno;nome_mae_aluno;cpf_mae;sigla_concessionaria_aluno;codigo_energia_aluno;latdec_posicao_original_aluno;londec_posicao_original_aluno;mobilidade_reduzida;veiculo_especial;utiliza_transporte_rural;forca_otimizacao;possui_deficiencia;frota_propria;tipo_transporte;codibge7_extensao;codigo_extensao;nome_extensao;latdec_posicao_original_extensao;londec_posicao_original_extensao;codigo_energia_extensao"
	Response.Write header & vbCrLf

	bolExisteDados = false

	cont = 0
	sql = "select t.codigo, a.CODIGOINEP,t.logradouro, t.numeroEndereco, t.complementoEndereco, t.bairro, t.uf, t.cep, t.celular, t.codigo_escola_estadual, t.nome, t.sexo, t.cpf, t.data_nascimento, a.responsavel, t.Logradouro as endereco, t.cep, " 
	sql = sql & " 	case"	
	sql = sql & " 		when t.codigo_escola_estadual is null then TUR.Desc_Turno"
	sql = sql & " 		else T.TURNO_ESTADUAL"
	sql = sql & " 		end as TURNO, "
	sql = sql & " 	case"	
	sql = sql & " 		when t.codigo_escola_estadual is null then em.codigo_censo"
	sql = sql & " 		else ee.codigo_escola_estadual"
	sql = sql & " 		end as codigo_censo, "
	sql = sql & " 	case"	
	sql = sql & " 		when t.codigo_escola_estadual is null then em.RAZAOSOCIAL"
	sql = sql & " 		else ee.nome"
	sql = sql & " 		end as escola, "
	sql = sql & " 	case"	
	sql = sql & " 		when C.DESCRICAO = 'EDUCAÇÃO INFANTIL' then 'PE'"
	sql = sql & " 		when C.DESCRICAO IS NULL then 'EF'"
	sql = sql & " 		else 'EF'"
	sql = sql & " 		end as sigla_tipo_ensino "
	sql = sql & " from ste_solicitacao_transporte t "
	sql = sql & " left join sca_aluno a on a.codigo = t.cod_aluno"
	sql = sql & " left join SCA_ROTA_VICULA_ALUNO v on v.cod_solicitacao_transporte = t.codigo "
	sql = sql & " left join SCA_TURMA tu on tu.cod_turma = v.codturma "
	sql = sql & " left join SCA_PERIODO P on P.COD_PERIODO = TU.COD_PERIODO"
	sql = sql & " left join SCA_CURSO C on C.COD_CURSO = P.COD_CURSO"
	sql = sql & " left join SCA_turno TUR on TUR.COD_TURNO = TU.COD_TURNO"
	sql = sql & " left join SEG_EMPRESA em on em.codigo = t.Cod_empresa "
	sql = sql & " left join ste_escola_estadual ee on ee.codigo_escola_estadual = t.codigo_escola_estadual"
	sql = sql & " where t.Situacao = 'D' "
	if strRede = "M" then
		if intCodEmpresa<>"0" then
			sql = sql & " and em.CODIGO = " & intCodEmpresa
			sql = sql & " and ee.codigo_escola_estadual is null "
		else
			sql = sql & " and ee.codigo_escola_estadual is null "
		end if
	elseif strRede = "E" then
		if intCodEscolaEstadual<>"0" then
			sql = sql & " and ee.codigo_escola_estadual = " & intCodEscolaEstadual
			sql = sql & " and ee.codigo_escola_estadual is not null "
		else
			sql = sql & " and ee.codigo_escola_estadual is not null "
		end if
	end if
	sql = sql & " order by t.nome"
	rs.open sql,cnn
	if NOT rs.eof then

		while not rs.eof
			tipo_dependencia = "Estadual"
			if isnull(rs("codigo_escola_estadual")) then tipo_dependencia = "Municipal"
			
			'sigla_tipo_ensino
			'PE - Educação Infantil
			'EF - Ensino Fundamental 1
			'EF2- Ensino Fundamental 2
			'EM - Ensino Médio
			
			
			linha = year(date) & ";" 
			linha = linha &	";" 'sre
			linha = linha &	tipo_dependencia & ";"
			linha = linha &	rs("codigo_censo") & ";" 
			linha = linha &	left(rs("escola"),200) & ";" 
			linha = linha &	";" 'endereço escola
			linha = linha &	";" 'numero escola
			linha = linha &	";" 'compl escola
			linha = linha &	";" 'bairro escola
			linha = linha &	codigo_municipio_ige & ";" 
			linha = linha &	nome_municipio & ";" 
			linha = linha &	uf_municipio & ";" 
			linha = linha &	";" 'cep escola
			linha = linha &	";" 'telefone escola
			linha = linha &	";" 'tipo escola
			linha = linha &	rs("sigla_tipo_ensino") & ";" 
			linha = linha &	";" 'modalidade
			linha = linha &	";" 'submodalidade
			linha = linha &	";" 'serie
			linha = linha &	";" 'classe
			linha = linha &	";" 'periodo letivo
			linha = linha &	";" 'sigla_concessionaria_escola
			linha = linha &	";" 'codigo_energia_escola
			linha = linha &	";" 'Latitude
			linha = linha &	";" 'Longitude
			linha = linha &	codigo_municipio_ige & ";" 
			linha = linha &	nome_municipio & ";" 
			linha = linha &	rs("turno") & ";" 
			linha = linha &	rs("codigo") & ";"
			linha = linha &	rs("codigo") & ";"
			linha = linha &	rs("CODIGOINEP") & ";"
			linha = linha &	left(rs("nome"),200) & ";"
			linha = linha &	formatadataAP(rs("data_nascimento")) & ";" 
			linha = linha &	rs("logradouro") & ";" 
			linha = linha &	rs("numeroEndereco") & ";" 
			linha = linha &	rs("complementoEndereco") & ";" 
			linha = linha &	rs("bairro") & ";" 
			linha = linha &	rs("uf") & ";" 
			linha = linha &	rs("cep") & ";" 
			linha = linha &	rs("celular") & ";" 
			linha = linha &	";" 'mae
			linha = linha &	";" 'cpf mae
			linha = linha &	";" 'sigla concessionaria aluno
			linha = linha &	";" 'codigo_energia_aluno
			linha = linha &	";"	'Latitude
			linha = linha &	";"	'Longitude
			linha = linha &	"N;"
			linha = linha &	"N;"
			linha = linha &	"S;"
			linha = linha &	"N;"
			linha = linha &	"N;"
			linha = linha &	"N;"
			linha = linha &	"TERRESTRE;"
			linha = linha &	";"
			linha = linha &	";"
			linha = linha &	";"
			linha = linha &	";"'Latitude 
			linha = linha &	";"'Longitude
			linha = linha &	";"'codigo_energia_extensao
			
			Response.Write linha & vbCrLf
			
			intQuantRegistoLote = intQuantRegistoLote + 1
			rs.movenext
			
			bolExisteDados = true
		wend
	ELSE
		%>
		<script>
			alert("Verifique! Não foi encontrado registros.");
			window.location ='ste_geracaoArquivosCon.asp';
		</script>
		<%
		response.End()	
	end if
	rs.close


elseif strModelo = "SETE_FNDE" then


	' Cabeçalho com os nomes corretos
	header = "OBRIGATORIO_NOME;OBRIGATORIO_DATA_NASCIMENTO;OBRIGATORIO_SEXO;OBRIGATORIO_COR;OBRIGATORIO_LOCALIZACAO;" & _
			 "OBRIGATORIO_NIVEL_ENSINO;OBRIGATORIO_TURNO_ENSINO;OPTATIVO_CPF;OPTATIVO_NOME_RESPONSAVEL;" & _
			 "OPTATIVO_GRAU_PARENTESCO;OPTATIVO_ENDERECO;OPTATIVO_LATITUDE;OPTATIVO_LONGITUDE"

	Response.Write header & vbCrLf

	bolExisteDados = false

	cont = 0
	sql = "select t.codigo, t.nome, t.sexo, t.cpf, t.data_nascimento, a.responsavel, t.Logradouro as endereco, t.cep, " 
	sql = sql & " 	case"	
	sql = sql & " 		when t.codigo_escola_estadual is null then TUR.Desc_Turno"
	sql = sql & " 		else T.TURNO_ESTADUAL"
	if strRede = "M" then
		sql = sql & " 		end as TURNO, isnull(C.DESCRICAO,'ENSINO FUNDAMENTAL') AS CURSO"
	else
		sql = sql & " 		end as TURNO, isnull(C.DESCRICAO,'ENSINO MÉDIO') AS CURSO"
	end if
	sql = sql & " from ste_solicitacao_transporte t "
	sql = sql & " left join sca_aluno a on a.codigo = t.cod_aluno"
	sql = sql & " left join SCA_ROTA_VICULA_ALUNO v on v.cod_solicitacao_transporte = t.codigo "
	sql = sql & " left join SCA_TURMA tu on tu.cod_turma = v.codturma "
	sql = sql & " left join SCA_PERIODO P on P.COD_PERIODO = TU.COD_PERIODO"
	sql = sql & " left join SCA_CURSO C on C.COD_CURSO = P.COD_CURSO"
	sql = sql & " left join SCA_turno TUR on TUR.COD_TURNO = TU.COD_TURNO"
	sql = sql & " left join SEG_EMPRESA em on em.codigo = t.Cod_empresa "
	sql = sql & " left join ste_escola_estadual ee on ee.codigo_escola_estadual = t.codigo_escola_estadual"
	sql = sql & " where t.Situacao = 'D' "
	if strRede = "M" then
		if intCodEmpresa<>"0" then
			sql = sql & " and em.CODIGO = " & intCodEmpresa
			sql = sql & " and ee.codigo_escola_estadual is null "
		else
			sql = sql & " and ee.codigo_escola_estadual is null "
		end if
	elseif strRede = "E" then
		if intCodEscolaEstadual<>"0" then
			sql = sql & " and ee.codigo_escola_estadual = " & intCodEscolaEstadual
			sql = sql & " and ee.codigo_escola_estadual is not null "
		else
			sql = sql & " and ee.codigo_escola_estadual is not null "
		end if
	end if
	sql = sql & " order by t.nome"
	rs.open sql,cnn
	if NOT rs.eof then

		while not rs.eof
			linha = rs("nome") & ";" 
			linha = linha &	rs("data_nascimento") & ";" 
			linha = linha &	rs("sexo") & ";"
			linha = linha &	"Não declarada" & ";" 
			linha = linha &	"Área Urbana" & ";"
			linha = linha &	rs("curso") & ";"
			linha = linha &	rs("turno") & ";"
			linha = linha &	rs("cpf") & ";"
			linha = linha &	rs("responsavel") & ";"
			linha = linha &	";"
			linha = linha &	rs("endereco") & ";"
			linha = linha &	";"
			
			Response.Write linha & vbCrLf
			
			intQuantRegistoLote = intQuantRegistoLote + 1
			rs.movenext
			
			bolExisteDados = true
		wend
	ELSE
		%>
		<script>
			alert("Verifique! Não foi encontrado registros.");
			window.location ='ste_geracaoArquivosCon.asp';
		</script>
		<%
		response.End()	
	end if
	rs.close
end if


if not bolExisteDados then
	%>
	<script>
		alert("Arquivo não foi gerado!");
		window.location='ste_geracaoArquivosCon.asp'
	</script>
	<%
end if
%>