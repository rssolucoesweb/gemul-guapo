<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 04/02/2021
	::	Desenvolvedores...: Sergio Borges - sergio@rssolucoesweb.com.br
-->
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnndocumento.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans

	acao 				= Trim(Request.QueryString("acao"))
	CarregaCad 			= "S"
	strAnoLetivo = request.Form("txtAnoLetivo")
	strSemestre = request.Form("cmbSemestre")

	intCodEmp				= Session("CodEmpresa")
	intCodigo 				= Trim(Request.Form("txtCodigo"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodGrade				= Trim(Request.Form("cmbGrade"))
    intCodDisciplinaGrade   = Trim(Request.Form("cmbDisciplinaGrade"))
	strTexto 				= replace(Trim(Request.Form("txttexto")),"ö","o")
    strPlanoEnsino          = Trim(Request.Form("cmbPlanoEnsino"))

	if trim(strTexto)="" then
		cnn.rollbackTrans
		%>
		<script>
			alert("Conteúdo deve ser informado!");
			window.location.href  = 'sca_plano_ensino.asp?txtCodigo=<%=intCodigo%>&cmbCurso=<%=intCodCurso%>&cmbPeriodo=<%=intCodPeriodo%>&cmbGrade=<%=intCodGrade%>&cmbDisciplinaGrade=<%=intCodDisciplinaGrade%>&cmbPlanoEnsino=<%=strPlanoEnsino%>'
		</script>
		<%	
		response.End()
	end if	

	
	if len(strTexto)>8000 then
		utrapassou = len(strTexto)
		%>
		<script>
            alert("Conteúdo digitado é de <%=utrapassou%> caracteres, o tamanho máximo de 8000. Verifique!");
            window.history.back();
        </script>
        <%	
        response.End()
	end if
	

	if acao="I" then

		ExisteLancamento = False
		sql = "SELECT CODIGO"
		sql = sql & " FROM SCA_PLANOENSINO"
		sql = sql & " WHERE COD_EMPRESA = " & Session("CodEmpresa")
		sql = sql & " AND COD_CURSO = " & intCodCurso
		sql = sql & " AND COD_PERIODO = " & intCodPeriodo
		sql = sql & " AND AnoLetivo = " & strAnoLetivo
		sql = sql & " AND Semestre = " & strSemestre
		sql = sql & " AND COD_GRADECURRICULARDISCIPLINA = " & intCodDisciplinaGrade
		rs.open sql, cnn
		if rs.EOF = false then								
			ExisteLancamento = true		
		end if
		rs.close
			
		if ExisteLancamento then
			cnn.rollbackTrans
			%>
			<script>
				alert("Conteúdo já lançado para essa Curso e Período. Verifique!");
				window.location.href  = 'sca_plano_ensino.asp?cmbCurso=<%=intCodCurso%>&cmbPeriodo=<%=intCodPeriodo%>&cmbGrade=<%=intCodGrade%>&cmbDisciplinaGrade=<%=intCodDisciplinaGrade%>'
			</script>
			<%	
			response.End()
		end if	
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "Insert Into SCA_PLANOENSINO(Cod_Empresa, AnoLetivo, Semestre, Cod_Curso, Cod_Periodo, Cod_GradeCurricular, Cod_GradeCurricularDisciplina)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & strAnoLetivo & ","
		sql = sql & "" & strSemestre & ","
		sql = sql & "" & intCodCurso & ","
		sql = sql & "" & intCodPeriodo & ","
		sql = sql & "" & intCodGrade & ","
		sql = sql & "" & intCodDisciplinaGrade & ")"
		cnn.execute sql
		
        ' Incluindo separadamente as ementas
		
		codPlanoEnsino = ""
		sql = "SELECT CODIGO"
		sql = sql & " FROM SCA_PLANOENSINO"
		sql = sql & " WHERE COD_EMPRESA = " & Session("CodEmpresa")
		sql = sql & " AND COD_CURSO = " & intCodCurso
		sql = sql & " AND COD_PERIODO = " & intCodPeriodo
		sql = sql & " AND AnoLetivo = " & strAnoLetivo
		sql = sql & " AND Semestre = " & strSemestre
		sql = sql & " AND COD_GRADECURRICULARDISCIPLINA = " & intCodDisciplinaGrade
		rs.open sql, cnn
		if rs.EOF = false then								
		   	codPlanoEnsino  = rs("CODIGO")
		end if
		rs.close
		
		if codPlanoEnsino <> "" then 
		 	if strPlanoEnsino = "OBJ" then
				sql = "Update SCA_PLANOENSINO Set"
				sql = sql & " Objetivos = '" & strTexto & "'"
				sql = sql & " where codigo = " & codPlanoEnsino
			    cnn.execute sql
		 	elseif strPlanoEnsino = "EME" then	
				sql = "Update SCA_PLANOENSINO Set"
				sql = sql & " Ementa = '" & strTexto & "'"
				sql = sql & " where codigo = " & codPlanoEnsino
			    cnn.execute sql
		 	elseif strPlanoEnsino = "CON" then	
				sql = "Update SCA_PLANOENSINO Set"
				sql = sql & " Conteudo_Programatico = '" & strTexto & "'"
				sql = sql & " where codigo = " & codPlanoEnsino
			    cnn.execute sql
			elseif strPlanoEnsino = "MET" then	
				sql = "Update SCA_PLANOENSINO Set"
				sql = sql & " Metodologia = '" & strTexto & "'"
				sql = sql & " where codigo = " & codPlanoEnsino
			    cnn.execute sql
		 	elseif strPlanoEnsino = "BIB" then	
				sql = "Update SCA_PLANOENSINO Set"
				sql = sql & " Bibliografia_Basica = '" & strTexto & "'"
				sql = sql & " where codigo = " & codPlanoEnsino
			    cnn.execute sql
		 	elseif strPlanoEnsino = "BIC" then	
				sql = "Update SCA_PLANOENSINO Set"
				sql = sql & " Bibliografia_Complementar = '" & strTexto & "'"
				sql = sql & " where codigo = " & codPlanoEnsino
			    cnn.execute sql
		 	elseif strPlanoEnsino = "CRI" then	
				sql = "Update SCA_PLANOENSINO Set"
				sql = sql & " Criterio_Avaliacao = '" & strTexto & "'"
				sql = sql & " where codigo = " & codPlanoEnsino
			    cnn.execute sql
		 	end if	
		end if	
	elseif acao="A" then

		strMensagem = "Registro Salvo com sucesso..."

		sql = "Update SCA_PLANOENSINO Set"
		sql = sql & " Cod_Periodo = " & intCodPeriodo & ","
		sql = sql & " Cod_GradeCurricular = " & intCodGrade & ","
		sql = sql & " Cod_GradeCurricularDisciplina = " & intCodDisciplinaGrade & ""
		sql = sql & " where codigo = " & intCodigo
		cnn.execute sql
		
		if strPlanoEnsino = "OBJ" then
			sql = "Update SCA_PLANOENSINO Set"
			sql = sql & " Objetivos = '" & strTexto & "'"
			sql = sql & " where codigo = " & intCodigo
			cnn.execute sql
		elseif strPlanoEnsino = "EME" then	
			sql = "Update SCA_PLANOENSINO Set"
			sql = sql & " Ementa = '" & strTexto & "'"
			sql = sql & " where codigo = " & intCodigo
			cnn.execute sql
		elseif strPlanoEnsino = "CON" then	
			sql = "Update SCA_PLANOENSINO Set"
			sql = sql & " Conteudo_Programatico = '" & strTexto & "'"
			sql = sql & " where codigo = " & intCodigo
			cnn.execute sql
		elseif strPlanoEnsino = "MET" then	
			sql = "Update SCA_PLANOENSINO Set"
			sql = sql & " Metodologia = '" & strTexto & "'"
			sql = sql & " where codigo = " & intCodigo
			cnn.execute sql
		elseif strPlanoEnsino = "BIB" then	
			sql = "Update SCA_PLANOENSINO Set"
			sql = sql & " Bibliografia_Basica = '" & strTexto & "'"
			sql = sql & " where codigo = " & intCodigo
			cnn.execute sql
		elseif strPlanoEnsino = "BIC" then	
			sql = "Update SCA_PLANOENSINO Set"
			sql = sql & " Bibliografia_Complementar = '" & strTexto & "'"
			sql = sql & " where codigo = " & intCodigo
			cnn.execute sql
		elseif strPlanoEnsino = "CRI" then	
			sql = "Update SCA_PLANOENSINO Set"
			sql = sql & " Criterio_Avaliacao = '" & strTexto & "'"
			sql = sql & " where codigo = " & intCodigo
			cnn.execute sql
		end if	
	else
	
		strMensagem = "Registro Excluido com sucesso..."

		sql = "Delete from SCA_PLANOENSINO "
		sql = sql & " where codigo = " & intCodigo
		cnn.execute sql
		
	end if
	
	ExisteLancamento = False
	sql = "select cod_empresa, cod_curso, cod_periodo, Cod_GradeCurricular, Cod_GradeCurricularDisciplina"
	sql = sql & " from SCA_PLANOENSINO"
	sql = sql & " WHERE COD_EMPRESA = " & Session("CodEmpresa")
	sql = sql & " AND COD_CURSO = " & intCodCurso
	sql = sql & " AND COD_PERIODO = " & intCodPeriodo
	sql = sql & " AND AnoLetivo = " & strAnoLetivo
	sql = sql & " AND Semestre = " & strSemestre
	sql = sql & " AND COD_GRADECURRICULARDISCIPLINA = " & intCodDisciplinaGrade
	sql = sql & " group by cod_empresa, cod_curso, cod_periodo, Cod_GradeCurricular, Cod_GradeCurricularDisciplina"
	sql = sql & " having count(*)>1	"
	rs.open sql, cnn
	if rs.EOF = false then								
		ExisteLancamento = true		
	end if
	rs.close
		
	if ExisteLancamento then
		cnn.rollbackTrans
		%>
		<script>
			alert("Conteúdo já lançado para essa Curso, Período, Grade e Disciplina. Verifique você poderá somente fazer alteração!");
			window.location.href  = 'sca_plano_ensino.asp?cmbCurso=<%=intCodCurso%>&cmbPeriodo=<%=intCodPeriodo%>&cmbGrade=<%=intCodGrade%>&cmbDisciplinaGrade=<%=intCodDisciplinaGrade%>'
		</script>
		<%	
		response.End()
	end if		

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='sca_plano_ensino.asp?cmbCurso=<%=intCodCurso%>&cmbPeriodo=<%=intCodPeriodo%>&cmbGrade=<%=intCodGrade%>&cmbDisciplinaGrade=<%=intCodDisciplinaGrade%>';
        </script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.location='sca_plano_ensino.asp';
		</script>
		<%
	end if
%>