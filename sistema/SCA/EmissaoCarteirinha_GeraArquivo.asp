<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">SCA - Controle Acadêmico</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        'on error resume next
        '------------------
        'PASTA DO ARQUIVO
        '------------------
    
        strDia = day(date)
        strMes = month(date)
        if len(day(date)) < 2 then strDia = "0" & day(date)
        if len(month(date)) < 2 then strMes = "0" & month(date)
    
        strNomeArquivo		= "CARTEIRA-ESTUDANTIL.CSV"
        strPastaArquivos	= server.MapPath("../../CarteiraEstudantil")
        strPastaArquivos 	= strPastaArquivos & "\" & Session("CodEmpresa")
        strDominiolink       = trim(Request.ServerVariables("SERVER_NAME"))
        
        Set file = Server.CreateObject("Scripting.FileSystemObject")
    
        'Cria a pasta de acordo com codigo da Empresa
        Pasta = Server.MapPath("../../CarteiraEstudantil") & "\" & Session("CodEmpresa")
        IF Not file.FolderExists(Pasta) THEN
            file.CreateFolder(Pasta)
        END IF
    
        strCaminho = strPastaArquivos & "\" & strNomeArquivo
        if not file.FileExists(strCaminho) then
            Set outfile = file.CreateTextFile(strCaminho, True) 'Parâmetros: Caminho, OverWrite'
        else
            Set outfile = file.OpenTextFile(strCaminho, 2) 'Parâmetros: Caminho, Tipo de Abertura'
        end if
        
        strPaginaTitulo = "EmissaoCarteirinha_con.asp"
        strCodAluno		=	Trim(Request.form("chkAluno"))
        strDataAP		= request.Form("txtData")
    
        cont = 0
        sql = "SELECT DISTINCT "
        sql = sql & " A.MATRICULA, "
        sql = sql & " A.NOMEALUNO AS NOME, "
        sql = sql & " SUBSTRING(C.DESCRICAO,1,40) AS CURSO, "
        sql = sql & " ISNULL(A.IDENTIDADE, '') AS RG, "
        sql = sql & " ISNULL(A.IDENTIDADEORGAO, '') AS ORGAO, " 
        sql = sql & " '"&strDataAP&"' AS DATAVALIDADE, "
        sql = sql & " CASE WHEN LEN(A.MATRICULA) = 5 THEN   '0000'+CONVERT(VARCHAR(10),A.MATRICULA)+CONVERT(VARCHAR(10),ISNULL(A.CTRVIACE,'0')+1) " 
        sql = sql & "      WHEN LEN(A.MATRICULA) = 6 THEN  '000'+CONVERT(VARCHAR(10),A.MATRICULA)+CONVERT(VARCHAR(10),ISNULL(A.CTRVIACE,'0')+1) "
        sql = sql & "      ELSE CONVERT(VARCHAR(10),A.MATRICULA) + CONVERT(VARCHAR(10),ISNULL(A.CTRVIACE,'0')+1) "
        sql = sql & "      END  AS CODBARRA_10DG, "
        sql = sql & " ISNULL(A.CTRVIACE,'0')+1 AS NUMERODAVIA "
        sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD " 
        sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO " 
        sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO AND SA.Cod_Empresa = A.COD_EMPRESA "
        sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA=AD.COD_TURMA_REMANEJAMENTO AND T.Cod_Empresa = AD.COD_EMPRESA "
        sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.COD_GRADECURRICULAR = T.COD_GRADECURRICULAR AND T.Cod_Empresa = AD.COD_EMPRESA "
        sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO = GC.COD_PERIODO AND P.Cod_Empresa = AD.COD_EMPRESA "
        sql = sql & " INNER JOIN SCA_CURSO C ON C.COD_CURSO = P.COD_CURSO AND C.Cod_Empresa = AD.COD_EMPRESA "
        sql = sql & " WHERE AD.COD_EMPRESA = " & session("CodEmpresa")
        sql = sql & " And 	A.codigo in (" & strCodAluno & ")"
        sql = sql & " ORDER BY CURSO, A.NOMEALUNO "	
        rs.open sql, cnn
        if not rs.eof then 
            strLinha1 = ""
            strLinha2 = ""
            While not rs.eof
                'cabeçalho
                if strLinha1 = "" then
                    strLinha1 = "MATRICULA;NOME;CURSO;RG;ORGAO;DATA_VALIDADE;CODBARRA_10DG;NUMERODAVIA"
                    outfile.WriteLine(strLinha1)
                end if
    
                'corpo
                strLinha2 = UCASE(TRIM(rs("MATRICULA"))) & ";" 
                strLinha2 = strLinha2 & UCASE(TRIM(rs("NOME"))) & ";" 
                strLinha2 = strLinha2 & UCASE(TRIM(rs("CURSO"))) & ";" 
                strLinha2 = strLinha2 & UCASE(TRIM(rs("RG"))) & ";" 
                strLinha2 = strLinha2 & UCASE(TRIM(rs("ORGAO"))) & ";" 
                strLinha2 = strLinha2 & UCASE(TRIM(rs("DATAVALIDADE"))) & ";" 
                strLinha2 = strLinha2 & UCASE(TRIM(rs("CODBARRA_10DG"))) & ";" 
                strLinha2 = strLinha2 & UCASE(TRIM(rs("NUMERODAVIA")))
                outfile.WriteLine(strLinha2)
                cont = cont + 1
                rs.movenext
            wend
        end if
        rs.close
        
    %>
     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Emissão de Carteirinhas - Gerar Arquivo CSV</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	
                    <div class="form-group" align="center">
                          <label for="exampleInputEmail1" >Clique com o botão direito do mouse no ícone abaixo e escolha a opção "salvar destino como..." </label><br />
                          <a href="http://<%=strDominiolink%>/CarteiraEstudantil/<%=Session("CodEmpresa")%>/<%=strNomeArquivo%>" target="_blank">
                          	<input type="button" name="cmdGerar" value="Arquivo CSV Gerado " class="btn-u float-shadow">	
                          </a>
                          
                          <input type="button" name="cmdPrincipal"  value="Principal"  class="btn-u btn-u-default float-shadow" <%=strDesabilitaPrincipal%> onClick="window.location='default.asp'">
                    </div>
                  </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
     <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 