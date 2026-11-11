<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 27/11/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Notas
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file=../../includes/inc_aguarde.asp-->
<script>
	function controlaFoco(proximoEnter) {
		var codigoTecla = event.keyCode;
		if (codigoTecla==13) { //enter
			document.all(proximoEnter).focus();
			document.all(proximoEnter).select();
		}
			
	}

	function calculaNota(valor){ //->função que ignora deixa somente 1 número após a vírgula. Ex.: 6.86 para 6.8
	
		var qtde;
		var i;
		var VNota = "";
		var ponto = false;
		
		valor = "" + valor.toFixed(1); //->converte para string
		qtde = valor.length;
	
		for(i=0;i<qtde;i++){
			VNota = VNota + valor.substring(i,i+1);
			if (valor.substring(i,i+1) =="."){
				ponto = true;
				break;
			}
		}
		
		if (ponto){
			VNota = VNota + valor.substring(i+1,i+2)
		}	
		
		return VNota;
	}
	function calculaMedia(notaAtual, posicao,intMediaAprovacao,intMediaAprovacaoFinal,strPesos){
		var intMedia, intMediaEF,Y,Z,W,R,C,K,Y_,Z_,W_,R_,C_,K_;
		var intPeso1Bim, intPeso2Bim, intPeso3Bim, intPeso4Bim, intPesoEF;
		var vetPesos = strPesos.split(";");
		var objMediaFinal, objMediaAnual;
		var strQuantNotasBimAtual = document.all["strQuantNotasBimAtual"].value;
		var strAvaliacaoFinal = document.all["txtHiddenNotaDoTipoEF"].value;

		Y = document.all["txtNota1_" + posicao].value;
		Z = document.all["txtNota2_" + posicao].value;
		W = document.all["txtNota3_" + posicao].value;
		R = document.all["txtNota4_" + posicao].value;
		C = document.all["txtNota5_" + posicao].value; //Exame Final
		K = document.all["txtNota6_" + posicao].value; //Con. Classe

		Y_= "null";
		Z_= "null";
		W_= "null";
		R_= "null";
		C_= "null";
		K_= "null";

		if (frm.txtBimestreAtual.value=="1") Y_ = notaAtual;
		if (frm.txtBimestreAtual.value=="2") Z_ = notaAtual;
		if (frm.txtBimestreAtual.value=="3") W_ = notaAtual;
		if (frm.txtBimestreAtual.value=="4") R_ = notaAtual;
		if (frm.txtBimestreAtual.value=="5") C_ = notaAtual;
		if (frm.txtBimestreAtual.value=="6") K_ = notaAtual;
		
		objMediaFinal 	  = document.all["txtMediaFinal_" + posicao]; //média Final
		objSituacaoFinal  = document.all["txtSituacaoFinal_" + posicao]; //média Final
		var Y_existeNota  = "N";
		var Z_existeNota  = "N";
		var W_existeNota  = "N";
		var R_existeNota  = "N";
		var C_existeNota  = "N";
		var K_existeNota  = "N";

		if (Y!="")  Y_existeNota  = "S";
		if (Z!="")  Z_existeNota  = "S";
		if (W!="")  W_existeNota  = "S";
		if (R!="")  R_existeNota  = "S";
		if (C!="")  C_existeNota  = "S";
		if (K!="")  K_existeNota  = "S";
		
		if (Y_!="null") Y_existeNota  = "S";
		if (Z_!="null") Z_existeNota  = "S";
		if (W_!="null") W_existeNota  = "S";
		if (R_!="null") R_existeNota  = "S";
		if (C_!="null") C_existeNota  = "S";			
		if (K_!="null") K_existeNota  = "S";			

		if (Y=="")  Y  = "0,00";
		if (Z=="")  Z  = "0,00";
		if (W=="")  W  = "0,00";
		if (R=="")  R  = "0,00";
		if (C=="")  C  = "0,00";
		if (K=="")  K  = "0,00";
		
		if (Y_=="") Y_ = "0,00";
		if (Z_=="") Z_ = "0,00";
		if (W_=="") W_ = "0,00";
		if (R_=="") R_ = "0,00";
		if (C_=="") C_ = "0,00";			
		if (K_=="") K_ = "0,00";			


		//verifica se foi digitado a nota
		strQtdeNotas = 0
		if (Y_existeNota=="S") strQtdeNotas = strQtdeNotas + 1;
		if (Z_existeNota=="S") strQtdeNotas = strQtdeNotas + 1;
		if (W_existeNota=="S") strQtdeNotas = strQtdeNotas + 1;
		if (R_existeNota=="S") strQtdeNotas = strQtdeNotas + 1;
		var strQtdeNotasEF = 1;
		if (C_existeNota=="S") strQtdeNotasEF = strQtdeNotasEF + 1;		
		var strQtdeNotasCC = 1;
		if (K_existeNota=="S") strQtdeNotasCC = strQtdeNotasCC + 1;		

		//*****ARMAZENA O VALOR DOS PESOS NAS REPECTIVAS VARIÁVEIS
		intPeso1Bim = parseFloat(vetPesos[0]);
		intPeso2Bim = parseFloat(vetPesos[1]);
		intPeso3Bim = parseFloat(vetPesos[2]);
		intPeso4Bim = parseFloat(vetPesos[3]);
		intPesoEF   = parseFloat(vetPesos[4]);
		
		if (intPeso1Bim == "" || intPeso1Bim == "0") intPeso1Bim = 1;
		if (intPeso2Bim == "" || intPeso2Bim == "0") intPeso2Bim = 1;
		if (intPeso3Bim == "" || intPeso3Bim == "0") intPeso3Bim = 1;
		if (intPeso4Bim == "" || intPeso1Bim == "0") intPeso4Bim = 1;
		if (intPesoEF   == "" || intPesoEF   == "0") intPesoEF = 1;
		
		Y  = Y.replace(",",".");
		Z  = Z.replace(",",".");
		W  = W.replace(",",".");
		R  = R.replace(",",".");
		C  = C.replace(",",".");
		K  = K.replace(",",".");

		Y_ = Y_.replace(",",".");
		Z_ = Z_.replace(",",".");
		W_ = W_.replace(",",".");
		R_ = R_.replace(",",".");
		C_ = C_.replace(",",".");
		K_ = K_.replace(",",".");

		if (Y_ != "null")
			if (Y != "0.00")
				Y = ( parseFloat(Y) + parseFloat(Y_) ) / 2;
			else	
				Y = parseFloat(Y) + parseFloat(Y_);
			
		if (Z_ != "null")  
			if (Z != "0.00")
				Z = ( parseFloat(Z) + parseFloat(Z_) ) / 2;
			else	
				Z = parseFloat(Z) + parseFloat(Z_);

		if (W_ != "null")  
			if (W != "0.00")
				W = ( parseFloat(W) + parseFloat(W_) ) / 2;
			else	
				W = parseFloat(W) + parseFloat(W_);

		if (R_ != "null")  
			if (R != "0.00")
				R = ( parseFloat(R) + parseFloat(R_) ) / 2;
			else	
				R = parseFloat(R) + parseFloat(R_);

		if (C_ != "null")  
			if (C != "0.00")
				C = ( parseFloat(C) + parseFloat(C_) ) / 2;
			else	
				C = parseFloat(C) + parseFloat(C_);

		if (K_ != "null")  
			if (K != "0.00")
				K = ( parseFloat(K) + parseFloat(K_) ) / 2;
			else	
				K = parseFloat(K) + parseFloat(K_);

		Y = parseFloat(Y);
		Z = parseFloat(Z);
		W = parseFloat(W);
		R = parseFloat(R);			
		C = parseFloat(C);	
		K = parseFloat(K);	

		
//			intMedia = Math.round((X * intPeso1Bim) + (Y * intPeso2Bim) + (Z * intPeso3Bim) + (W * intPeso4Bim))/strQtdeNotas;
//		alert("1Bim:" + Y + " P1:" + intPeso1Bim + "\n2Bim:" + Z + " P2:" + intPeso2Bim+ "\n2Bim:" + W + " P2:" + intPeso3Bim+ "\n3Bim:" + R + " P4:" + intPeso4Bim);

		if ((Y=="0.00") && (Z=="0.00") && (W=="0.00") && (R=="0.00") && (C=="0.00") && (K=="0.00")){
			intMedia = '0.0';
			objMediaFinal.value = "0.0";
			objSituacaoFinal.value = "RN";
			objMediaFinal.style.color = "#FF0000";
			return intMedia
		}
		if (strQtdeNotas == 0) strQtdeNotas = 1;
		
		intMedia   = ((parseFloat(Y) * parseFloat(intPeso1Bim)) + (parseFloat(Z) * parseFloat(intPeso2Bim)) + (parseFloat(W) * parseFloat(intPeso3Bim)) + (parseFloat(R) * parseFloat(intPeso4Bim)))/parseFloat(strQtdeNotas);
//		alert("intMedia:" + intMedia + "\n\n strQtdeNotas:" + strQtdeNotas);
		intMediaEF = (parseFloat(C) * parseFloat(intPesoEF));

		if (parseFloat(intMediaEF)!=0){
			intMedia   = ((parseFloat(intMedia) + parseFloat(intMediaEF))/parseFloat(strQtdeNotasEF)) + parseFloat(K) ;
		}else{
			intMedia   = parseFloat(intMedia) + parseFloat(K) ;
		}



		A = intMedia;
		objMediaFinal.value = calculaNota(A);
		
		intMedia = calculaNota(intMedia); //função que ignora deixa somente 1 número após a víergula. Ex.: 6.86 para 6.8
		if (strAvaliacaoFinal=='S'){
			if (parseFloat(intMedia)<parseFloat(intMediaAprovacaoFinal)){
				objMediaFinal.style.color = "#FF0000";
				objSituacaoFinal.value = "RN"
			}
			else{
				objMediaFinal.style.color = "#0000FF";				
				objSituacaoFinal.value = "AP"
			}
		}else{
			if (parseFloat(intMedia)<parseFloat(intMediaAprovacao)){
				objMediaFinal.style.color = "#FF0000";
				objSituacaoFinal.value = "RN"
			}
			else{
				objMediaFinal.style.color = "#0000FF";				
				objSituacaoFinal.value = "AP"
			}
		}
		
		objMediaFinal.value=intMedia;				
		return intMedia;
	}


	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	function validaNota(valor, posicao, intMediaAprovacao, intMediaAprovacaoFinal, strCalcular, strPesos){
		if (valor<0 || valor>10){
			alert("Atenção: nota inválida, deve estar entre 0 a 10!");
			document.all["txtNota_" + posicao].select();
			document.all["txtNota_" + posicao].style.backgroundColor = "#DAFA7A";
			document.all["txtNota_" + posicao].focus();
			return false;
		}else{
			if (valor.substring(0,2) == "10" && valor.substring(2,3) == "," && valor.substring(3,4) != "0") {
				alert("Atenção: nota inválida, deve estar entre 0 a 10!");
				document.all["txtNota_" + posicao].select();
				document.all["txtNota_" + posicao].style.backgroundColor = "#DAFA7A";
				document.all["txtNota_" + posicao].focus();
				return false;
			
			}
			document.all["txtNota_" + posicao].style.backgroundColor = "#FFB7B7";
			//calculaMedia(valor, posicao, intMediaAprovacao, intMediaAprovacaoFinal, strPesos);
			return true;
		}
	}	
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		frm.action="Notas_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<%
	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
	end if
	
	'REGRA QUANDO O ANO DIGITADO FOR MENOR QUE O DA SESSION
	'SERÁ GRAVADO DO ARQUIVO DE HISTORICO
	if Cint(strAnoLetivo) < Cint(session("strAnoLetivo")) then
		'GRAVANDO NO ARQUIVO DE HISTORICO
		strGravarOnde = "HISTORICO"
		msnHistorico  = "<font color='#0000FF'>(<strong>HISTÓRICO</strong>)</font>"
	else
		'GRAVANDO NO ARQUIVO DE NOTAS
		strGravarOnde = "NOTA"
		msnHistorico  = ""
	end if
	
	intCodTurma 			= Trim(Request("cmbTurmaProfessor"))
	intCodCurso	 			= Trim(Request("cmbCurso"))
	intCodPeriodo 			= Trim(Request("cmbPeriodo"))
	intSemestre 			= Trim(Request("cmbSemestre"))
	
	intCodTurno		 		= Trim(Request("cmbTurno"))
	intCodDisciplina  		= trim(request("cmbDisciplinaDoProfessor"))
	intCodTipoLancamento    = trim(request("cmbTipoLancamento"))

	strAlunos      			= Trim(Request("chkAluno"))
	intCodTipoNota			= Trim(Request("chkTipoNota"))
	intCodTipoLancamento	= Trim(Request("cmbTipoLancamento")) '"0" '-->Nota e Falta | "1" '-->Somente Nota	| "2" '-->Somente Falta		
	bloqueiaAcumuladaFalta	= Trim(Request("cmbBloqueiaFaltas"))	
	
	strNomedisciplina = ""
	sql = "SELECT DESC_DISCIPLINA FROM SCA_DISCIPLINA"
	sql = sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
	sql = sql & " AND	COD_DISCIPLINA = " & intCodDisciplina
	rs.open sql, cnn
	if not rs.eof then
		strNomedisciplina = rs("DESC_DISCIPLINA")
	end if
	rs.close
	
	strNomeNota 		= ""
	strNomeTipoBimestre = ""
	strPosicao 			= ""
	strBimestreAtual 	= ""
	strBimestre1		= "1Bim"
	strBimestre2		= "2Bim"
	strBimestre3		= "3Bim"
	strBimestre4		= "4Bim"
	strExameFinal		= "5EF"
	strExameFinal		= "6CC"
	strCodBimestre		= ""
	strNotaDoTipoEF		= ""
	sql="SELECT CODIGO, DESCRICAO, POSICAO, BIMESTRE"
	sql=sql & " FROM  SCA_TIPO_AVALIACAO"
	sql=sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
	sql=sql & " AND		CODIGO = " & intCodTipoNota
	rs.open sql, cnn
	if rs.eof = false then
		strNomeTipoBimestre 	= trim(rs("bimestre")) & "º Bimestre"
		strCodBimestre			= trim(rs("bimestre"))
		if trim(rs("bimestre")) = "5" then
			strNomeTipoBimestre = "Exame Final"		
			strNotaDoTipoEF		= "S"
		end if
		if trim(rs("bimestre")) = "6" then
			strNomeTipoBimestre = "Cons. Classe"		
		end if

		strNomeNota			 	= rs("DESCRICAO")
		strPosicao 				= ZeroLeft(rs("POSICAO"),2)
	end if
	rs.close
	
	strPosicaoNotas1Bim = "0"
	sql="Select TA.POSICAO "
	sql=sql & " from SCA_AVALIACAO A"
	sql=sql & " inner join SCA_CRITERIO_AVALIACAO CA ON CA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and CA.CODIGO = A.CODCRITERIOAVALIACAO"
	sql=sql & " inner join SCA_TIPO_AVALIACAO TA ON TA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and TA.CODIGO = A.CODTIPOAVALIACAO"
	sql=sql & " where A.cod_empresa = " & Session("CodEmpresa") 
	sql=sql & " and CA.cod_curso = " & intCodCurso
	sql=sql & " and TA.BIMESTRE = 1"
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			strPosicaoNotas1Bim = strPosicaoNotas1Bim & "," & rs("posicao")
			rs.movenext
		wend
	end if
	rs.close	
	strPosicaoNotas2Bim = "0"
	sql="Select TA.POSICAO "
	sql=sql & " from SCA_AVALIACAO A"
	sql=sql & " inner join SCA_CRITERIO_AVALIACAO CA ON CA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and CA.CODIGO = A.CODCRITERIOAVALIACAO"
	sql=sql & " inner join SCA_TIPO_AVALIACAO TA ON TA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and TA.CODIGO = A.CODTIPOAVALIACAO"
	sql=sql & " where A.cod_empresa = " & Session("CodEmpresa") 
	sql=sql & " and CA.cod_curso = " & intCodCurso
	sql=sql & " and TA.BIMESTRE = 2"
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			strPosicaoNotas2Bim = strPosicaoNotas2Bim & "," & rs("posicao")
			rs.movenext
		wend
	end if
	rs.close	
	strPosicaoNotas3Bim = "0"
	sql="Select TA.POSICAO "
	sql=sql & " from SCA_AVALIACAO A"
	sql=sql & " inner join SCA_CRITERIO_AVALIACAO CA ON CA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and CA.CODIGO = A.CODCRITERIOAVALIACAO"
	sql=sql & " inner join SCA_TIPO_AVALIACAO TA ON TA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and TA.CODIGO = A.CODTIPOAVALIACAO"
	sql=sql & " where A.cod_empresa = " & Session("CodEmpresa") 
	sql=sql & " and CA.cod_curso = " & intCodCurso
	sql=sql & " and TA.BIMESTRE = 3"
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			strPosicaoNotas3Bim = strPosicaoNotas3Bim & "," & rs("posicao")
			rs.movenext
		wend
	end if
	rs.close	
	strPosicaoNotas4Bim = "0"
	sql="Select TA.POSICAO "
	sql=sql & " from SCA_AVALIACAO A"
	sql=sql & " inner join SCA_CRITERIO_AVALIACAO CA ON CA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and CA.CODIGO = A.CODCRITERIOAVALIACAO"
	sql=sql & " inner join SCA_TIPO_AVALIACAO TA ON TA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and TA.CODIGO = A.CODTIPOAVALIACAO"
	sql=sql & " where A.cod_empresa = " & Session("CodEmpresa") 
	sql=sql & " and CA.cod_curso = " & intCodCurso
	sql=sql & " and TA.BIMESTRE = 4"
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			strPosicaoNotas4Bim = strPosicaoNotas4Bim & "," & rs("posicao")
			rs.movenext
		wend
	end if
	rs.close	
	strPosicaoNotasExameFinal = "0"
	sql="Select TA.POSICAO "
	sql=sql & " from SCA_AVALIACAO A"
	sql=sql & " inner join SCA_CRITERIO_AVALIACAO CA ON CA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and CA.CODIGO = A.CODCRITERIOAVALIACAO"
	sql=sql & " inner join SCA_TIPO_AVALIACAO TA ON TA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and TA.CODIGO = A.CODTIPOAVALIACAO"
	sql=sql & " where A.cod_empresa = " & Session("CodEmpresa") 
	sql=sql & " and CA.cod_curso = " & intCodCurso
	sql=sql & " and TA.BIMESTRE = 5"
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			strPosicaoNotasExameFinal = strPosicaoNotasExameFinal & "," & rs("posicao")
			rs.movenext
		wend
	end if
	rs.close	
	strPosicaoNotasCC = "0"
	sql="Select TA.POSICAO "
	sql=sql & " from SCA_AVALIACAO A"
	sql=sql & " inner join SCA_CRITERIO_AVALIACAO CA ON CA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and CA.CODIGO = A.CODCRITERIOAVALIACAO"
	sql=sql & " inner join SCA_TIPO_AVALIACAO TA ON TA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and TA.CODIGO = A.CODTIPOAVALIACAO"
	sql=sql & " where A.cod_empresa = " & Session("CodEmpresa") 
	sql=sql & " and CA.cod_curso = " & intCodCurso
	sql=sql & " and TA.BIMESTRE = 6"
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			strPosicaoNotasCC = strPosicaoNotasCC & "," & rs("posicao")
			rs.movenext
		wend
	end if
	rs.close	


	vetPosicaoNota1Bim 		= split(strPosicaoNotas1Bim,",")
	vetPosicaoNota2Bim 		= split(strPosicaoNotas2Bim,",")
	vetPosicaoNota3Bim 		= split(strPosicaoNotas3Bim,",")
	vetPosicaoNota4Bim 		= split(strPosicaoNotas4Bim,",")
	vetPosicaoNotaExameFinal= split(strPosicaoNotasExameFinal,",")
	vetPosicaoNotaCC		= split(strPosicaoNotasCC,",")
	
	strMostraNota = "style='display:block'"
	strMostraFalta = "style='display:block'"

	if intCodTipoLancamento = "0" then 
		strTipoLancamento = "NOTAS E FALTAS"
		strTipoLancamentoBotao = "Notas e Faltas"
	elseif intCodTipoLancamento = "1" then 
		strTipoLancamento = "NOTAS"
		strMostraNota = "style='display:block'"
		strMostraFalta = "style='display:none'"
		strTipoLancamentoBotao = "Notas"
	elseif intCodTipoLancamento = "2" then 
		strTipoLancamento = "FALTAS"
		strMostraNota = "style='display:none'"
		strMostraFalta = "style='display:block'"
		strTipoLancamentoBotao = "Faltas"
	end if
	
	if intCodDisciplina = "" then intCodDisciplina = "0"
	
	sql="select * from SCA_CRITERIO_AVALIACAO"
	sql=sql & " where	cod_empresa = "&Session("CodEmpresa") 
	sql=sql & " and		cod_curso	= "&intCodCurso
	rs.open sql, cnn
	if not rs.eof then
		strTipoFormulaFinal = rs("tipoFormulaFinal")
		strCondicaoEF_notaInicial = rs("condicaoEF_notaInicial")
		if isnull(strCondicaoEF_notaInicial) then strCondicaoEF_notaInicial = 0
		strCondicaoEF_notaFinal = rs("condicaoEF_notaFinal")
		if isnull(strCondicaoEF_notaFinal) then strCondicaoEF_notaFinal = 0
		
		if isnull(rs("peso_1bim")) = false then
			intPeso1Bim = rs("peso_1bim")
		else
			intPeso1Bim = 0
		end if
		
		if isnull(rs("peso_2bim")) = false then
			intPeso2Bim = rs("peso_2bim")
		else
			intPeso2Bim = 0			
		end if			
		
		if isnull(rs("peso_3bim")) = false then
			intPeso3Bim = rs("peso_3bim")
		else
			intPeso3Bim = 0			
		end if			
		
		if isnull(rs("peso_4bim")) = false then
			intPeso4Bim = rs("peso_4bim")
		else
			intPeso4Bim = 0			
		end if
		
		if isnull(rs("peso_EF")) = false then
			intPesoEF = rs("peso_EF")
		else
			intPesoEF = 0			
		end if
		
		'Armazena os pesos em uma string separada por ";" para ser utilizada na função calculaMedia
		strPesos = intPeso1Bim & ";" & intPeso2Bim & ";" & intPeso3Bim & ";"  & intPeso4Bim & ";" & intPesoEF
		
		if isnull(rs("formula")) = false then
			strFormula = rs("formula") 
		else
			strFormula = ""
		end if
		intMediaAprovacao     = rs("media_aprovacao")
		intMediaAprovacaoFinal = rs("media_aprovacao_final")
		intFreqMinima         = rs("frequencia_minima_percentual")
		
		if isnull(rs("num_disciplina_recuperacao")) = false then
			intNumDisciplinaRec   = rs("num_disciplina_recuperacao") 'Quantidade de disciplinas que o aluno pode ficar de recuperação
		else
			intNumDisciplinaRec = 0
		end if
		
		if isnull(rs("num_disciplina_prog_parcial")) = false then
			intNumDisciplinaProgParcial   = rs("num_disciplina_prog_parcial") 'Quantidade de disciplinas que o aluno pode ficar de prog. parcial
		else
			intNumDisciplinaProgParcial = 0
		end if	
		rs.close
	else
		rs.close
		%>
		<script>
			alert("O critério de avaliação não foi criado para esse curso.");
			window.location="Avaliacao_cad.asp?intCodCurso=<%=intCodCurso%>";
		</script>
		<%
		response.end
	end if
	
%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="751"  height="469" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td height="469" colspan="2" align="center">
		<form id="frm" method="post">
		<input type="hidden" name="txtPosicao" value="<%=strPosicao%>">
		<input type="HIDDEN" name="txtBimestreAtual" value="<%=strCodBimestre%>">
		  <table width="100%" border="0" cellpadding="0" cellspacing="0">

            <tr valign="top">
              <td width="100%" align="center" class="tituloSistema">Cadastro de Notas - Professor <%=msnHistorico%></td>
            </tr>
          </table>
		  <br>
		  <%
			sql = "SELECT TU.NOMETURMA, TU.ANO, TU.ANOLETIVO, T.DESC_TURNO "
			sql = sql & " FROM SCA_TURMA TU"
			sql = sql & " INNER JOIN SCA_TURNO T ON T.COD_TURNO = TU.COD_TURNO AND T.COD_EMPRESA = TU.COD_EMPRESA"
			sql = sql & " WHERE	TU.COD_EMPRESA = " & Session("CodEmpresa") 
			sql = sql & " AND	TU.COD_TURMA = " & intCodTurma
			rs.open sql, cnn
			if not rs.eof then
		  %>
		  <table width="703" border="0" cellspacing="0" cellpadding="0" class="tabela">
            <tr bgcolor="#E5E5E5">
              <td width="85" height="24" class="celula">&nbsp;<strong>Turma:</strong></td>
              <td width="262" class="celula">&nbsp;<%=RS("NOMETURMA")%></td>
              <td width="136" class="celula">&nbsp;<strong>Turno:</strong></td>
              <td width="219" class="celula">&nbsp;<%=RS("DESC_TURNO")%></td>
            </tr>
            <tr bgcolor="#E5E5E5">
              <td height="24" class="celula">&nbsp;<strong>Disciplina:</strong></td>
              <td colspan="3" class="celula">&nbsp;<%=strNomedisciplina%></td>
              </tr>
          </table>
		  <%
		  end if
		  rs.close
		  %>
		  <br>
			<%		 
			IF TRIM(strGravarOnde) = "NOTA" THEN
	           'SELECIONA OS ALUNOS REGULARES CONFORME DISCIPLINA CADASTRADA
	           sql = " SELECT "
			   sql = sql & " AD.CODIGO AS COD_ALUNO_DISCIPLINA, "
			   sql = sql & " AD.COD_ALUNO AS CODIGO,"
			   sql = sql & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
			   sql = sql & " AD.COD_DISCIPLINA, "
			   sql = sql & " A.NOMEALUNO, "
			   sql = sql & " A.MATRICULA, "
			   sql = sql & " '' AS SEQUENCIA, " 
			   sql = sql & " SA.DESC_SITUACAOALUNO, "
			   sql = sql & " GC.COD_PERIODO, "
			   sql = sql & " NF.media, "    
			   sql = sql & " NF.nota" & strPosicao & " as NOTA, "
			   sql = sql & " NF.falta" & strPosicao & " as FALTA, "     
               sql = sql & " NF.codigo AS COD_NOTA, "
		       for i=0 to ubound(vetPosicaoNota1Bim)
			       if trim(vetPosicaoNota1Bim(i)) <> "0" then
					  strPos = ZeroLeft(vetPosicaoNota1Bim(i),2)
				  	  sql = sql & " 	NF.NOTA"&strPos&", "
			      	  sql = sql & " 	NF.FALTA"&strPos&", "
				   end if
				next
			    for i=0 to ubound(vetPosicaoNota2Bim)
			    	if trim(vetPosicaoNota2Bim(i)) <> "0" then
					   strPos = ZeroLeft(vetPosicaoNota2Bim(i),2)
					   sql = sql & " 	NF.NOTA"&strPos&", "
	     			   sql = sql & " 	NF.FALTA"&strPos&", "
					end if
				next
				for i=0 to ubound(vetPosicaoNota3Bim)
					if trim(vetPosicaoNota3Bim(i)) <> "0" then
						strPos = ZeroLeft(vetPosicaoNota3Bim(i),2)
						sql = sql & " 	NF.NOTA"&strPos&", "
						sql = sql & " 	NF.FALTA"&strPos&", "
					end if
				next
				for i=0 to ubound(vetPosicaoNota4Bim)
			      		if trim(vetPosicaoNota4Bim(i)) <> "0" then
						strPos = ZeroLeft(vetPosicaoNota4Bim(i),2)
						sql = sql & " 	NF.NOTA"&strPos&", "
						sql = sql & " 	NF.FALTA"&strPos&", "
				end if
				next
				for i=0 to ubound(vetPosicaoNotaExameFinal)
					if trim(vetPosicaoNotaExameFinal(i)) <> "0" then
			    	   strPos = ZeroLeft(vetPosicaoNotaExameFinal(i),2)
			           sql = sql & " 	NF.NOTA"&strPos&", "
					   sql = sql & " 	NF.FALTA"&strPos&", "
					end if
 
        		next
				for i=0 to ubound(vetPosicaoNotaCC)
			    	if trim(vetPosicaoNotaCC(i)) <> "0" then
			    	   strPos = ZeroLeft(vetPosicaoNotaCC(i),2)
						sql = sql & " 	NF.NOTA"&strPos&", "
						sql = sql & " 	NF.FALTA"&strPos&", "
					end if
				next
		        sql = sql & " NF.situacao "
				sql = sql & "FROM SCA_ALUNO_DISCIPLINA AD INNER JOIN "
 				sql = sql & "SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO  INNER JOIN "
 				sql = sql & "SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO JOIN "
 				sql = sql & "SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurriculardisciplina = AD.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO INNER JOIN "
 				sql = sql & "SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = GCD.Cod_GradeCurricular INNER JOIN "
 				sql = sql & "SCA_NOTAS_FALTAS NF ON NF.cod_aluno_disciplina = AD.CODIGO "
 				sql = sql & "WHERE 1=1 "
				'AD.COD_EMPRESA = " & Session("CodEmpresa")
				sql = sql & "AND AD.COD_DISCIPLINA = " & intCodDisciplina
				sql = sql & "AND AD.COD_TURMA_REMANEJAMENTO =  " & intCodTurma
				  sql = sql & "AND (SA.Desc_SituacaoAluno = 'ATIVO' OR SA.Desc_SituacaoAluno = 'PRÉ-MATRÍCULA') " 
				sql = sql & "AND A.CODIGO in (" & strAlunos & ") "
 				sql = sql & "ORDER BY A.NOMEALUNO "
		ELSEIF TRIM(strGravarOnde) = "HISTORICO" THEN
			
				sql = " SELECT SCA_ALUNO.CODIGO, "
				sql = sql & " 	SCA_ALUNO.MATRICULA, "
				sql = sql & " 	SCA_ALUNO.NOMEALUNO, "
				sql = sql & " 	SCA_ALUNO_TURMA.SEQUENCIA, "
				sql = sql & " 	SCA_ALUNO_TURMA.COD_TURMA, "
				sql = sql & " 	SCA_GRADECURRICULAR.Cod_Periodo, "
				sql = sql & " 	SCA_HISTORICO_ESCOLAR_DISCIPLINA.MEDIA, "
				sql = sql & " 	SCA_HISTORICO_ESCOLAR_DISCIPLINA.NOTA" & strPosicao & " as NOTA, "
				sql = sql & " 	SCA_HISTORICO_ESCOLAR_DISCIPLINA.FALTA" & strPosicao & " as FALTA, "
	
				for i=0 to ubound(vetPosicaoNota1Bim)
					if trim(vetPosicaoNota1Bim(i)) <> "0" then
						strPos = ZeroLeft(vetPosicaoNota1Bim(i),2)
						sql = sql & " 	SCA_HISTORICO_ESCOLAR_DISCIPLINA.NOTA"&strPos&", "
						sql = sql & " 	SCA_HISTORICO_ESCOLAR_DISCIPLINA.FALTA"&strPos&", "
					end if
				next
				for i=0 to ubound(vetPosicaoNota2Bim)
					if trim(vetPosicaoNota2Bim(i)) <> "0" then
						strPos = ZeroLeft(vetPosicaoNota2Bim(i),2)
						sql = sql & " 	SCA_HISTORICO_ESCOLAR_DISCIPLINA.NOTA"&strPos&", "
						sql = sql & " 	SCA_HISTORICO_ESCOLAR_DISCIPLINA.FALTA"&strPos&", "
					end if
				next
				for i=0 to ubound(vetPosicaoNota3Bim)
					if trim(vetPosicaoNota3Bim(i)) <> "0" then
						strPos = ZeroLeft(vetPosicaoNota3Bim(i),2)
						sql = sql & " 	SCA_HISTORICO_ESCOLAR_DISCIPLINA.NOTA"&strPos&", "
						sql = sql & " 	SCA_HISTORICO_ESCOLAR_DISCIPLINA.FALTA"&strPos&", "
					end if
				next
				for i=0 to ubound(vetPosicaoNota4Bim)
					if trim(vetPosicaoNota4Bim(i)) <> "0" then
						strPos = ZeroLeft(vetPosicaoNota4Bim(i),2)
						sql = sql & " 	SCA_HISTORICO_ESCOLAR_DISCIPLINA.NOTA"&strPos&", "
						sql = sql & " 	SCA_HISTORICO_ESCOLAR_DISCIPLINA.FALTA"&strPos&", "
					end if
				next
				for i=0 to ubound(vetPosicaoNotaExameFinal)
					if trim(vetPosicaoNotaExameFinal(i)) <> "0" then
						strPos = ZeroLeft(vetPosicaoNotaExameFinal(i),2)
						sql = sql & " 	SCA_HISTORICO_ESCOLAR_DISCIPLINA.NOTA"&strPos&", "
						sql = sql & " 	SCA_HISTORICO_ESCOLAR_DISCIPLINA.FALTA"&strPos&", "
					end if
				next
				for i=0 to ubound(vetPosicaoNotaCC)
					if trim(vetPosicaoNotaCC(i)) <> "0" then
						strPos = ZeroLeft(vetPosicaoNotaCC(i),2)
						sql = sql & " 	SCA_HISTORICO_ESCOLAR_DISCIPLINA.NOTA"&strPos&", "
						sql = sql & " 	SCA_HISTORICO_ESCOLAR_DISCIPLINA.FALTA"&strPos&", "
					end if
				next
	
				sql = sql & " 	SCA_ALUNO_DISCIPLINA.CODIGO AS COD_ALUNO_DISCIPLINA, "
				sql = sql & " 	SCA_HISTORICO_ESCOLAR_DISCIPLINA.CODIGO AS COD_NOTA, SCA_HISTORICO_ESCOLAR_DISCIPLINA.CODIGO AS CODHISTORICODISCIPLINA, "
				sql = sql & " 	SCA_HISTORICO_ESCOLAR_DISCIPLINA.SITUACAO"
				sql = sql & " FROM SCA_ALUNO_TURMA "
				sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_ALUNO_TURMA.COD_EMPRESA = SCA_ALUNO.COD_EMPRESA "
				sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
				sql = sql & " INNER JOIN SCA_TURNO ON SCA_TURNO.COD_TURNO = SCA_TURMA.Cod_TURNO AND SCA_TURNO.COD_EMPRESA = SCA_TURMA.COD_EMPRESA "
				sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular AND SCA_TURMA.COD_EMPRESA = SCA_GRADECURRICULAR.COD_EMPRESA "
				sql = sql & " INNER JOIN SCA_ALUNO_DISCIPLINA ON SCA_ALUNO_DISCIPLINA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_TURMA.Cod_Turma = SCA_ALUNO_DISCIPLINA.COD_TURMA AND SCA_TURMA.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA "
				sql = sql & " INNER JOIN SCA_DISCIPLINA ON SCA_DISCIPLINA.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA AND SCA_DISCIPLINA.COD_DISCIPLINA = SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA "
				sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina = SCA_ALUNO_DISCIPLINA.Cod_GradeCurricularDisciplina AND SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_ALUNO_DISCIPLINA.Cod_Disciplina "
				sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR  ON SCA_HISTORICO_ESCOLAR.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_HISTORICO_ESCOLAR.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA "
				sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR_DISCIPLINA ON SCA_HISTORICO_ESCOLAR_DISCIPLINA.COD_HISTORICO_ESCOLAR = SCA_HISTORICO_ESCOLAR.CODIGO AND SCA_HISTORICO_ESCOLAR_DISCIPLINA.COD_DISCIPLINA = SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA AND SCA_HISTORICO_ESCOLAR_DISCIPLINA.COD_ALUNO_DISCIPLINA = SCA_ALUNO_DISCIPLINA.CODIGO "
				sql = sql & " where SCA_TURMA.cod_empresa = " & Session("CodEmpresa")
				sql = sql & " AND SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma
				sql = sql & " AND SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA = " & intCodDisciplina
				sql = sql & " AND SCA_ALUNO.CODIGO in (" & strAlunos & ") "
				sql = sql & " and 	SCA_ALUNO_TURMA.situacao = 'A'"
				sql = sql & " and 	SCA_ALUNO_TURMA.Ano_Letivo = " & strAnoLetivo
				sql = sql & " and 	SCA_ALUNO_TURMA.Semestre = " & intSemestre
				sql = sql & " ORDER BY SCA_ALUNO.NOMEALUNO"	
			END IF
			rs.open sql, cnn,3,1
			%>		  
		  <table width="703" border="0" cellspacing="0" cellpadding="0" class="tabela">
          <tr bgcolor="#E5E5E5">
            <td height="24" class="celula">&nbsp;</td>
            <td class="celula">&nbsp;</td>
            <td class="celula">&nbsp;</td>
            <td colspan="3" align="center" class="celula" ><strong><%=ucase(strNomeTipoBimestre)%></strong></td>
            </tr>
          <tr bgcolor="#E5E5E5">
            <td height="24" class="celula">&nbsp;<strong>Seq.</strong></td>
            <td class="celula">&nbsp;<strong>Matrícula</strong></td>
            <td class="celula">&nbsp;<strong>Aluno</strong></td>
            <td class="celula" align="center" <%=strMostraNota%>><strong><%=strNomeNota%></strong></td>
            <td class="celula" align="center" <%=strMostraFalta%>><strong>FALTA</strong></td>
            <td align="center" class="celula" <%=strMostraFalta%>><strong>M&Eacute;DIA</strong></td>
            </tr>
		  <%
		  contLanc = 0
		  intCont1Bim = 0
		  intCont2Bim = 0
		  intCont3Bim = 0
		  intCont4Bim = 0
		  intContExameFinal	= 0
		  intContCC	= 0
		  strNotaAcumulada1Bim = 0
		  strNotaAcumulada2Bim = 0
		  strNotaAcumulada3Bim = 0
		  strNotaAcumulada4Bim = 0
		  strNotaAcumuladaExameFinal = 0
		  strNotaAcumuladaCC = 0
		  intQtdeRegistros = 0
		  if not rs.eof then
			  intQtdeRegistros = rs.recordCount
		  end if
		  
		  while not rs.eof
		  		contLanc = contLanc + 1
				strNota = RS("NOTA")
				if isnull(strNota) or strNota="" then
					strPodeFazerAlteracao = ""
					strStyleDesablilitado = "class='text'"
				else
					strPodeFazerAlteracao = "readonly"
					strStyleDesablilitado = "class='textDesabilita'"
				end if
				
				strFalta = RS("FALTA")
				strCodAluno = RS("CODIGO")
				strCodHistoricoDisciplina = ""
				IF TRIM(strGravarOnde) = "HISTORICO" THEN
					strCodHistoricoDisciplina = RS("CODHISTORICODISCIPLINA")
				END IF
				
				for i=0 to ubound(vetPosicaoNota1Bim)
					if trim(vetPosicaoNota1Bim(i)) <> "0" then
						strPos = ZeroLeft(vetPosicaoNota1Bim(i),2)
						if not isnull(RS("NOTA"& strPos)) then
							if trim(strPosicao) <> trim(strPos) then
								strNotaAcumulada1Bim = strNotaAcumulada1Bim + ccur(RS("NOTA"& strPos))
							end if
							intCont1Bim = intCont1Bim + 1
						end if
					end if
				next
				
				for i=0 to ubound(vetPosicaoNota2Bim)
					if vetPosicaoNota2Bim(i) <> "0" then
						strPos = ZeroLeft(vetPosicaoNota2Bim(i),2)
						if not isnull(RS("NOTA"& strPos)) then
							if trim(strPosicao) <> trim(strPos) then
								strNotaAcumulada2Bim = strNotaAcumulada2Bim + RS("NOTA"& strPos)
							end if
							intCont2Bim = intCont2Bim + 1
						end if
					end if
				next
				for i=0 to ubound(vetPosicaoNota3Bim)
					if vetPosicaoNota3Bim(i) <> "0" then
						strPos = ZeroLeft(vetPosicaoNota3Bim(i),2)
						if not isnull(RS("NOTA"& strPos)) then
							if trim(strPosicao) <> trim(strPos) then
								strNotaAcumulada3Bim = strNotaAcumulada3Bim + RS("NOTA"& strPos)
							end if
							intCont3Bim = intCont3Bim + 1
						end if
					end if
				next
				for i=0 to ubound(vetPosicaoNota4Bim)
					if vetPosicaoNota4Bim(i) <> "0" then
						strPos = ZeroLeft(vetPosicaoNota4Bim(i),2)
						if not isnull(RS("NOTA"& strPos)) then
							if trim(strPosicao) <> trim(strPos) then
								strNotaAcumulada4Bim = strNotaAcumulada4Bim + RS("NOTA"& strPos)
							end if
							intCont4Bim = intCont4Bim + 1
						end if
					end if
				next
				for i=0 to ubound(vetPosicaoNotaExameFinal)
					if vetPosicaoNotaExameFinal(i) <> "0" then
						strPos = ZeroLeft(vetPosicaoNotaExameFinal(i),2)
						if not isnull(RS("NOTA"& strPos)) then
							if trim(strPosicao) <> trim(strPos) then
								strNotaAcumuladaExameFinal = strNotaAcumuladaExameFinal + RS("NOTA"& strPos)
							end if
							intContExameFinal = intContExameFinal + 1
						end if
					end if
				next
				for i=0 to ubound(vetPosicaoNotaCC)
					if vetPosicaoNotaCC(i) <> "0" then
						strPos = ZeroLeft(vetPosicaoNotaCC(i),2)
						if not isnull(RS("NOTA"& strPos)) then
							if trim(strPosicao) <> trim(strPos) then
								strNotaAcumuladaCC = strNotaAcumuladaCC + RS("NOTA"& strPos)
							end if
							intContCC = intContCC + 1
						end if
					end if
				next
				
				'acumula notas
				strNota1Bim = strNotaAcumulada1Bim
				strNota2Bim = strNotaAcumulada2Bim
				strNota3Bim = strNotaAcumulada3Bim
				strNota4Bim = strNotaAcumulada4Bim
				strNotaEF   = strNotaAcumuladaExameFinal
				strNotaCC   = strNotaAcumuladaCC

				if strCodBimestre = 1 then
					strQuantNotas = intCont1Bim 
					intCont1Bim   = intCont1Bim - 1
				elseif strCodBimestre = 2 then
					strQuantNotas = intCont2Bim
					intCont2Bim   = intCont2Bim - 1
				elseif strCodBimestre = 3 then
					strQuantNotas = intCont3Bim
					intCont3Bim   = intCont3Bim - 1
				elseif strCodBimestre = 4 then
					strQuantNotas = intCont4Bim
					intCont4Bim   = intCont4Bim - 1
				elseif strCodBimestre = 5 then
					strQuantNotas = intContExameFinal
					intContExameFinal = intContExameFinal - 1
				elseif strCodBimestre = 6 then
					strQuantNotas = intContCC
					intContCC = intContCC - 1
				end if
				
				if intCont1Bim > 0 then
					strNota1Bim = strNotaAcumulada1Bim/intCont1Bim
				else
					strNota1Bim = ""
					if strNotaAcumulada1Bim > 0 then strNota1Bim = strNotaAcumulada1Bim
				end if
				if intCont2Bim > 0 then
					strNota2Bim = strNotaAcumulada2Bim/intCont2Bim
				else
					strNota2Bim = ""
					if strNotaAcumulada2Bim > 0 then strNota2Bim = strNotaAcumulada2Bim
				end if
				if intCont3Bim > 0 then
					strNota3Bim = strNotaAcumulada3Bim/intCont3Bim
				else
					strNota3Bim = ""
					if strNotaAcumulada3Bim > 0 then strNota3Bim = strNotaAcumulada3Bim
				end if
				if intCont4Bim > 0 then
					strNota4Bim = strNotaAcumulada4Bim/intCont4Bim
				else
					strNota4Bim = ""
					if strNotaAcumulada4Bim > 0 then strNota4Bim = strNotaAcumulada4Bim
				end if
				if intContExameFinal > 0 then
					strNotaEF = strNotaAcumuladaExameFinal/intContExameFinal
				else
					strNotaEF = ""
					if strNotaAcumuladaExameFinal > 0 then strNotaEF = strNotaAcumuladaExameFinal
				end if
				if intContCC > 0 then
					strNotaCC = strNotaAcumuladaCC/intContCC
				else
					strNotaCC = ""
					if strNotaAcumuladaCC > 0 then strNotaCC = strNotaAcumuladaCC
				end if
				strFormulaComposta = replace(strFormula,strBimestre1,strNota1Bim)
				strFormulaComposta = replace(strFormulaComposta,"x","*")
				strMediaFinal = rs("MEDIA")
				IF ISNULL(strMediaFinal) THEN strMediaFinal = ""

				strStyle = ""
				if strMediaFinal <> "" then 
					if cCur(strMediaFinal)<cCur(intMediaAprovacao) then
						strStyle = "style='color:#FF0000'"
						strSituacaoFinal = "RN"
					else
						strStyle = "style='color:#0000FF'"
						strSituacaoFinal = "AP"
					end if
				end if

				IF TRIM(RS("SITUACAO"))="RN" THEN
					strStyle = "style='color:#FF0000'"
					strSituacaoFinal = TRIM(RS("SITUACAO"))
				ELSEIF TRIM(RS("SITUACAO"))="AP" THEN
					strStyle = "style='color:#0000FF'"
					strSituacaoFinal = TRIM(RS("SITUACAO"))
				END IF
				strPodeFazerAvaliacao = ""
				strCorPodeFazerAvaliacao = ""
				if trim(strNotaDoTipoEF) = "S" then 
					if trim(strTipoFormulaFinal) = "EF" then
						'response.Write(strMediaFinal) & ">=" & strCondicaoEF_notaInicial & " and " & strMediaFinal & "< " & strCondicaoEF_notaFinal & "<-<br>"
						
						if strMediaFinal<>"" then
							if cCur(strMediaFinal)>=cCur(strCondicaoEF_notaInicial) and cCur(strMediaFinal) < cCur(strCondicaoEF_notaFinal) then
								'poderá fazer a avaliação de Exame final
								strPodeFazerAvaliacao = ""
								strCorPodeFazerAvaliacao = ""
							else
								'não pode fazer avaliação de exame final
								if trim(strNota) = "" or isnull(strNota) then
									strPodeFazerAvaliacao = "readonly"
									strCorPodeFazerAvaliacao = "bgcolor='#F5CBCB'"
								end if
							end if
						end if
					end if
				end if
			  
				IF TRIM(strGravarOnde) = "HISTORICO" THEN
					%>
					<input class="text" type="HIDDEN" name="txtCodHistoricoDisciplina_<%=contLanc%>" value="<%=strCodHistoricoDisciplina%>">
					<%
				END IF
				
				if CInt(intQtdeRegistros) = CInt(contLanc) then
					strProximoCampoNota = "txtFalta_" & contLanc
					strProximoCampoFalta = "btnSalvar"
				else
					strProximoCampoNota = "txtFalta_" & contLanc
					strProximoCampoFalta = "txtNota_" & contLanc+1
				end if
				
			  %>
			  <input class="text" type="HIDDEN" name="txtNota1_<%=contLanc%>" value="<%=strNota1Bim%>">
			  <input class="text" type="HIDDEN" name="txtNota2_<%=contLanc%>" value="<%=strNota2Bim%>">
			  <input class="text" type="HIDDEN" name="txtNota3_<%=contLanc%>" value="<%=strNota3Bim%>">
			  <input class="text" type="HIDDEN" name="txtNota4_<%=contLanc%>" value="<%=strNota4Bim%>">
			  <input class="text" type="HIDDEN" name="txtNota5_<%=contLanc%>" value="<%=strNotaEF%>">
			  <input class="text" type="HIDDEN" name="txtNota6_<%=contLanc%>" value="<%=strNotaCC%>">
			  <tr  <%=strCorPodeFazerAvaliacao%> onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)">
				<td class="celula" width="5%">&nbsp;<%=rs("SEQUENCIA")%><input type="hidden" name="txtCodAlunoNota_<%=contLanc%>" value="<%=rs("COD_NOTA")%>"></td>
				<td class="celula" width="10%">&nbsp;<%=rs("MATRICULA")%><input type="hidden" name="txtCodAluno_<%=contLanc%>" value="<%=rs("CODIGO")%>"></td>
				<td class="celula" width="49%">&nbsp;<%=rs("NOMEALUNO")%><br>
				<input type="hidden" name="txtAlunoDisciplina_<%=contLanc%>" value="<%=rs("COD_ALUNO_DISCIPLINA")%>"></td>
				<td class="celula" width="12%" align="center"  <%=strMostraNota%>><input  onKeyUp="return controlaFoco('<%=strProximoCampoNota%>')" onBlur="return validaNota(this.value, '<%=contLanc%>', '<%=intMediaAprovacao%>', '<%=intMediaAprovacaoFinal%>', '<%=strFormulaComposta%>', '<%=strPesos%>')" type="text" name="txtNota_<%=contLanc%>" value="<%=strNota%>" size="4" maxlength="4" onKeyPress="return formataCampo(this,6,4)" <%=strPodeFazerAvaliacao%> <%=strStyleDesablilitado%> <%=strPodeFazerAlteracao%>></td>
			    <td class="celula" width="13%" align="center"  <%=strMostraFalta%>><input onKeyUp="return controlaFoco('<%=strProximoCampoFalta%>')" <%=bloqueiaAcumuladaFalta%> type="text" class="textDesabilita" name="txtFalta_<%=contLanc%>" value="<%=strFalta%>" size="4" maxlength="4" onKeyPress="return formataCampo(this,2,2)" <%=strPodeFazerAvaliacao%>  <%=strStyle%>></td>
			    <td class="celula" width="11%" align="center"  <%=strMostraFalta%>><input readonly type="text" class="textDesabilita" name="txtMediaFinal_<%=contLanc%>" value="<%if strMediaFinal <> "" then response.Write formatNumber(strMediaFinal,1) %>" size="4" <%=strStyle%> ><input readonly type="hidden" class="textDesabilita" name="txtSituacaoFinal_<%=contLanc%>" value="<%=strSituacaoFinal%>" size="4" <%=strStyle%> ></td>
			    </tr>
			  <%

			  intCont1Bim = 0
			  intCont2Bim = 0
			  intCont3Bim = 0
			  intCont4Bim = 0
			  intContExameFinal	= 0
			  intContCC	= 0
			  strNotaAcumulada1Bim = 0
			  strNotaAcumulada2Bim = 0
			  strNotaAcumulada3Bim = 0
			  strNotaAcumulada4Bim = 0
			  strNotaAcumuladaExameFinal = 0
			  strNotaAcumuladaCC = 0
			  
			  
		  		rs.movenext
		  wend
		  rs.close
		  cnn.close
		  %>
        </table>
		  <p>
		    <input type="hidden" name="strQuantNotasBimAtual" value="<%=strQuantNotas%>">
		    <input type="hidden" name="qtdeAluno" value="<%=contLanc%>">
		    <input type="hidden" name="cmbPeriodo" value="<%=intCodPeriodo%>">
		    <input type="hidden" name="cmbSemestre" value="<%=intSemestre%>">
		    <input type="hidden" name="cmbDisciplinaProfessorHorario" value="<%=intCodDisciplina%>">
		    <input type="hidden" name="chkTipoNota" value="<%=intCodTipoNota%>">
		    <input type="hidden" name="cmbTurmaProfessor" value="<%=intCodTurma%>">
		    <input type="hidden" name="cmbTurno" value="<%=intCodTurno%>">
		    <input type="hidden" name="chkAluno" value="<%=strAlunos%>">
		    <input type="hidden" name="cmbTipoLancamento" value="<%=intCodTipoLancamento%>">
		    <input type="hidden" name="cmbCurso" value="<%=intCodCurso%>">
		    
		    <!--Armazena a média que o aluno deve alcançar para ser aprovado na disciplina-->
		     <input type="Hidden" name="txtHiddenMediaAprovacao" value="<%=intMediaAprovacao%>"> 
		     <!--Armazena a média que o aluno deve alcançar para ser aprovado na disciplina-->
		     <input type="Hidden" name="txtHiddenMediaAprovacaoFinal" value="<%=intMediaAprovacaoFinal%>"> 
		     <!--Armazena a média que o aluno deve alcançar para ser aprovado na disciplina-->
		     <input type="Hidden" name="txtHiddenTipoFormulaFinal" value="<%=strTipoFormulaFinal%>"> 
		     <!--Armazena a média que o aluno deve alcançar para ser aprovado na disciplina-->
		     <input type="Hidden" name="txtHiddenFreqMinima" value="<%=intFreqMinima%>"> 
		     <!--Verifica se possui recuperação-->
		     <input type="Hidden" name="txtHiddenRecuperacao" value="<%=strRecuperacao%>">	
		     <!--Verifica se possui recuperação-->
		     <input type="Hidden" name="txtHiddenConselho" value="<%=strConselho%>"> 
		     <!--Verifica quantas disciplinas o aluno pode ficar de recuperação-->
		     <input type="hidden" name="txtHiddenNumDisciplinaRec" value="<%=intNumDisciplinaRec%>"> 
		     <!--Verifica quantas disciplinas o aluno pode ficar de prog. parcial-->
		     <input type="hidden" name="txtHiddenNumDisciplinaProgParcial" value="<%=intNumDisciplinaProgParcial%>"> 
		     <!--Verifica se haverá reprovação por falta para a prog. parcial-->
		     <input type="hidden" name="txtHiddenReprovacaoFaltaProgParcial" value="<%=strReprovacaoFaltaProgParcial%>"> 
		     <!--Verifica se haverá reprovação por falta para a prog. parcial-->
		     <input type="hidden" name="txtHiddenNotaDoTipoEF" value="<%=strNotaDoTipoEF%>"> 	
		     <%
		
			strParametro = "NotasProf_con.asp?cmbPeriodo="&intCodPeriodo
			strParametro = strParametro & "&cmbSemestre="&intSemestre
			strParametro = strParametro & "&cmbDisciplinaTurma="&intCodDisciplina
			strParametro = strParametro & "&chkTipoNota="&intCodTipoNota
			strParametro = strParametro & "&cmbTurma="&intCodTurma
			strParametro = strParametro & "&chkAluno="&strAlunos
			strParametro = strParametro & "&cmbTurno="&intCodTurno
			strParametro = strParametro & "&cmbTipoLancamento="&intCodTipoLancamento	
			strParametro = strParametro & "&cmbCurso="&intCodCurso	
		
		%>
		  </p>
		  <p>
		    <input onClick="salvar('I')" name="btnSalvar" value=" Salvar Notas " type="button" class="botao">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		      <input onClick="window.location='<%=strParametro%>'" name="btnVoltar" value="<< Voltar " type="button" class="botao">
		    </p>
		  <table width="80%" border="1">
            <tr>
              <td><div align="center">ATEN&Ccedil;&Atilde;O! - Ao salvar suas NOTAS e FALTAS, as mesmas n&atilde;o mais poder&atilde;o ser alteradas. Altera&ccedil;&otilde;es somente na Secretaria Geral mediante a requerimento. </div>
                  </div></td>
            </tr>
          </table>
		  <p>&nbsp;</p>
		  <input type="hidden" name="txtAnoLetivo" value="<%=strAnoLetivo%>">
		  <input type="hidden" name="txtSemestre" value="<%=intSemestre%>">
          <input type="hidden" name="txtPaginaRetorno" value="NOTAPROF">
		</form>  		  
		</td>
      </tr>
    </table>
	</td>
  </tr>
</table>
<!--#include file="../rodape.asp"-->
<script>
	aguarde.style.display="none";
	document.all.txtNota_1.focus();
	document.all.txtNota_1.select();
</script>
</body>
</html>