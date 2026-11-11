<script>
function calculaMedia(codigo_notas,aluno,disciplina,media_especial,intMediaAprovacao){
	//notas - string que contém todas as notas separadas por virgula
	var intMedia,X,XS,XM,Y,YS,YM,Z,ZS,ZM,W,WS,WM,MS1,MS2,RS1,RS2,C,A,R;
	var objMS1, objMS2, objMF, objMA;
	var vetCodigoNotas=codigo_notas.split(";");
	
	//obs.: o simulado não está sendo mais cadastrado nas escolas militares
	XS=0;
	YS=0;
	ZS=0;
	WS=0;
	
	X   = document.all["txtNota_" + aluno + "_" + disciplina + "_" + vetCodigoNotas[0]].value;   //1º bimestre
	//XS  = document.all["txtNota_" + aluno + "_" + disciplina + "_" + vetCodigoNotas[1]].value;   //SIMULADO DO 1° bimestre
	Y   = document.all["txtNota_" + aluno + "_" + disciplina + "_" + vetCodigoNotas[2]].value;   //2° bimestre
	//YS  = document.all["txtNota_" + aluno + "_" + disciplina + "_" + vetCodigoNotas[3]].value;   //SIMULADO DO 2° bimestre
	Z   = document.all["txtNota_" + aluno + "_" + disciplina + "_" + vetCodigoNotas[4]].value;   //3° bimestre
	//ZS  = document.all["txtNota_" + aluno + "_" + disciplina + "_" + vetCodigoNotas[5]].value;   //SIMULADO DO 3° bimestre
	W   = document.all["txtNota_" + aluno + "_" + disciplina + "_" + vetCodigoNotas[6]].value;   //4º bimestre
	//WS  = document.all["txtNota_" + aluno + "_" + disciplina + "_" + vetCodigoNotas[7]].value;   //SIMULADO 4° bimestre
	R   = document.all["txtNota_" + aluno + "_" + disciplina + "_" + vetCodigoNotas[8]].value;   //PROVAFINAL (RECUPERAÇÃO)
	C   = document.all["txtNota_" + aluno + "_" + disciplina + "_" + vetCodigoNotas[9]].value;   //CONSELHO			
	RS1 = document.all["txtNota_" + aluno + "_" + disciplina + "_" + vetCodigoNotas[10]].value;  //RECUPERAÇÃO DO 1º SEMESTRE
	RS2 = document.all["txtNota_" + aluno + "_" + disciplina + "_" + vetCodigoNotas[11]].value;  //RECUPERAÇÃO DO 2º SEMESTRE					
	
	objMS1 = document.all["txtNota_" + aluno + "_" + disciplina + "_15"];
	objMS2 = document.all["txtNota_" + aluno + "_" + disciplina + "_16"];
	objMF  = document.all["txtNota_" + aluno + "_" + disciplina + "_11"];
	objMA  = document.all["txtNota_" + aluno + "_" + disciplina + "_13"];
	
	if (X=="") X = "0";
	if (XS=="") XS = "0";
	if (Y=="") Y = "0";
	if (YS=="") YS = "0";
	if (Z=="") Z = "0";			
	if (ZS=="") ZS = "0";
	if (W=="") W = "0";
	if (WS=="") WS = "0";
	if (RS1=="") RS1 = "-"; //se a nota da prova final não for informada colocar "-" para que não entre no calculo da média da recuperação
	if (RS2=="") RS2 = "-"; //se a nota da prova final não for informada colocar "-" para que não entre no calculo da média da recuperação
	if (R=="") R = "-"; //se a nota da prova final não for informada colocar "-" para que não entre no calculo da média da recuperação
	if (C=="") C = "0";
	
	X = X.replace(",",".");
	XS = XS.replace(",",".");
	Y = Y.replace(",",".");
	YS = YS.replace(",",".");
	Z = Z.replace(",",".");
	//ZS = ZS.replace(",",".");
	W = W.replace(",",".");
	WS = WS.replace(",",".");
	R = R.replace(",",".");
	C = C.replace(",",".");
	RS1 = RS1.replace(",",".");
	RS2 = RS2.replace(",",".");

	//alert(X + " - " + Y + " - " + Z + " - " + W + " - " + R + " - " + C);			
	
	X = parseFloat(X);
	XS = parseFloat(XS);
	Y = parseFloat(Y);
	YS = parseFloat(YS);
	Z = parseFloat(Z);
	ZS = parseFloat(ZS);
	W = parseFloat(W);
	WS = parseFloat(WS);
	
	if ((RS1 != "-")) //Sem nota para a prova final (recuperação)
		RS1 = parseFloat(RS1);
					
	if ((RS2 != "-")) //Sem nota para a prova final (recuperação)
		RS2 = parseFloat(RS2);										
		
	if ((R != "-")) //Sem nota para a prova final (recuperação)
		R = parseFloat(R);			
		
	C = parseFloat(C);
	
	//SUBSTITUI A MENOR NOTA DO 1º SEMESTRE PELA NOTA DA RECUPERAÇÃO DO 1º SEMESTRE 
	if (RS1 != "-"){
		if ( (X <= Y) && (X < RS1) )
			X = RS1;
		else if ((Y <= X) && (Y < RS1))
			Y = RS1;
	}
	
	//MÉDIA DO 1º BIMESTRE
	XM = X + XS; 
	if (XM > 10)
		XM = 10;
	
	//MÉDIA DO 2º BIMESTRE	
	YM = Y + YS;
	if (YM > 10)
		YM = 10;
		
	//SUBSTITUI A MENOR NOTA DO 2º SEMESTRE PELA NOTA DA RECUPERAÇÃO DO 2º SEMESTRE 
	if (RS2 != "-"){
		if ((Z <=W) && (Z < RS2) )
			Z = RS2;
		else if ((W <= Z) && (W < RS2))
			W = RS2;			
	}
	
	//MÉDIA DO 3º BIMESTRE		
	ZM = Z + ZS;
	if (ZM > 10)
		ZM = 10;
					
	//MÉDIA DO 4º BIMESTRE
	WM = W + WS;
	if (WM > 10)
		WM = 10;			
	
	//MÉDIA DOS SEMESTRES   
	// OBS.: A função rroundOff arredonda a nota. exemplo: 8.46 para 8.5
	MS1 = parseFloat(roundOff( Math.round( ( (XM + YM)/2 )*100) /100 , 1 )); 
	MS2 = parseFloat(roundOff( Math.round( ( (ZM + WM)/2 )*100) /100 , 1 ));
	
	objMS1.value = MS1;
	objMS2.value = MS2;

	//MÉDIA ANUAL
	intMedia = parseFloat(roundOff( Math.round(((MS1+MS2)/2 )*100)/100, 1 ));
	
	//alert("Disciplina -> " + disciplina + " Média 1º Sem -> " + MS1 + "| Média 2º Sem -> " + MS2 + "| Média ->" + intMedia);
	
	A = intMedia;
	objMA.value = A;
	
	//MÉDIA FINAL
	<%if strRecuperacao = "S" then%>
		if (R != "-"){
			intMedia = parseFloat(roundOff( Math.round( ((A+R)/2)*100 )/100 , 1 ));
		}
	<%end if%>
	
	<%if strConselho = "S" then%>
		intMedia = intMedia + C;
	<%end if%>
	
	intMedia = calculaNota(intMedia); //função que ignora deixa somente 1 número após a víergula. Ex.: 6.86 para 6.8
	
	if (intMedia<intMediaAprovacao){
		objMF.style.color = "#FF0000";
	}
	else{
		objMF.style.color = "#0000FF";				
	}	
	
	objMF.value = intMedia;
	//alert(intMedia);
	
	//alert("MS1 = " + MS1 + " -> MS2 = " + MS2 + " -> A = " + A + " -> intMedia = " + intMedia);
	
	//vetMedias = strMedias.split(";");
	
	//document.all["txtHiddenMedia" + aluno].value=intMedia;
	return intMedia;
}

<!--Função que calcula a nota que falta para o aluno passar-->
function calculaNotaParaFechar(XM,YM,ZM,WM){
	var intParaFechar;
	var strParaFechar;

	if (XM=="-") XM = "0";
	if (YM=="-") YM = "0";
	if (ZM=="-") ZM = "0";
	if (WM=="-") WM = "0";					
	
	XM = XM.replace(",",".");
	YM = YM.replace(",",".");
	ZM = ZM.replace(",",".");
	WM = WM.replace(",",".");
	
	XM = parseFloat(XM);
	YM = parseFloat(YM);
	ZM = parseFloat(ZM);
	WM = parseFloat(WM);					
	
	<%if intMediaLegal = "" then intMediaLegal=0%>
	intParaFechar = Math.round(((<%=intMediaLegal%> * 4) - (XM + YM + ZM + WM))*100)/100;
	intParaFechar = calculaNota(intParaFechar);
	
	if (intParaFechar < 0)
		intParaFechar=0
	
	strParaFechar = intParaFechar + "" //Converte pata string para trocar o "." por ","
	strParaFechar = strParaFechar.replace(".",",");
	
	return strParaFechar;		
}
</script>	