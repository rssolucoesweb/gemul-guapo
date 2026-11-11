<%
	response.Expires=0
	Server.ScriptTimeOut = 5000
%>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	intSemestre  = session("strSemestre")	
	strAnoLetivo = session("strAnoLetivo")
	if session("strAnoLetivo")<=2016 then 	strAnoLetivo = session("strAnoLetivo") + 1

	strUsuarioWeb				= Session("UsuarioWeb")	
	strCodEmpresa				= trim(request("txtCodigoEmpresa"))
	strCodInscricao				= Trim(Request("txtCodigoInscricao"))
	
	if strCodInscricao <> "" then
		sql = "execute SP_CancelaInscricaoMatricula " & strCodInscricao & "," & strCodEmpresa & ",'" & strUsuarioWeb & "','" & strAnoLetivo & "','" & intSemestre & "'"

		cnn.execute sql	
		
		if err.number = 0 then

			sql = "select codigo, cod_aluno, cod_periodo, cod_turno, cod_empresa from MAT_inscricao where codigo = " & strCodInscricao
			'response.write sql
			rs.open sql, cnn
			if not rs.eof then
				intCodAluno = rs("cod_aluno")
			end if
			rs.close
			
			intCodEmp			= strCodEmpresa
			intCodDepartamento	= Session("CodDeptoUsuario")
			intCodTaxa			= ""
			intCodBebitoAluno	= ""
			strDataOcorrencia	= formatadataBD(date)
			strUsuarioIncl		= strUsuarioWeb
			strDataValidade		= ""
			strOcorrencia		= "Cancelado pela matrícula/remover inscrição"
			%>
			<!--#include file="../includes/inc_lancamentoDeOcorrencia.asp"-->	
			<script>
				alert("Aluno cancelado com sucesso.");
				window.location='RemoveInscricaoMatricula_con.asp';
			</script>
			<%
		else
			%>
			<script>
				alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
				window.history.back();
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