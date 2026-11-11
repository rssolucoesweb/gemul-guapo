
		function calculaMedia(codigo_notas,aluno,disciplina,media_especial,intMediaAprovacao,strPesos,strRecuperacao, strConselho){
			var intMedia,X,Y,Z,W,R,C;
			var intPeso1Bim, intPeso2Bim, intPeso3Bim, intPeso4Bim, intPesoMA, intPesoMR;
			var vetPesos = strPesos.split(";");
			var vetCodigoNotas=codigo_notas.split(";");
			var vetMediaEspecial = media_especial.split(";");
			var objMediaFinal, objMediaAnual;
			var intDivisor=0;
			
			X = document.all["txtNota_" + aluno + "_" + disciplina + "_" + vetCodigoNotas[0]].value;    //1º bimestre
			Y = document.all["txtNota_" + aluno + "_" + disciplina + "_" + vetCodigoNotas[1]].value;    //2° bimestre
			Z = document.all["txtNota_" + aluno + "_" + disciplina + "_" + vetCodigoNotas[2]].value;    //3° bimestre
			W = document.all["txtNota_" + aluno + "_" + disciplina + "_" + vetCodigoNotas[3]].value;    //4º bimestre
			R = document.all["txtNota_" + aluno + "_" + disciplina + "_" + vetCodigoNotas[4]].value;    //PROVAFINAL (RECUPERAÇÃO)
			C = document.all["txtNota_" + aluno + "_" + disciplina + "_" + vetCodigoNotas[5]].value;    //CONSELHO			
			objMediaFinal = document.all["txtNota_" + aluno + "_" + disciplina + "_11"]; //média Final
			objMediaAnual = document.all["txtNota_" + aluno + "_" + disciplina + "_13"]; //média Anual
			
			if ((X=="") && (Y=="") && (Z=="") && (W=="") && (R=="") && (C=="")){
				intMedia = '';
				objMediaFinal.value = "";
				objMediaAnual.value = "";				
			}
				else{
				
				
				if (X=="") X = "0";
				if (Y=="") Y = "0";
				if (Z=="") Z = "0";
				if (W=="") W = "0";
				if (R=="") R = "-"; //se a nota da prova final não for informada colocar "-" para que não entre no calculo da média da recuperação
				if (C=="") C = "0";			
				
				//*****ARMAZENA O VALOR DOS PESOS NAS REPECTIVAS VARIÁVEIS
				intPeso1Bim = parseFloat(vetPesos[0]);
				intPeso2Bim = parseFloat(vetPesos[1]);
				intPeso3Bim = parseFloat(vetPesos[2]);
				intPeso4Bim = parseFloat(vetPesos[3]);
				intPesoMA = parseFloat(vetPesos[4]);
				intPesoMR = parseFloat(vetPesos[5]);
				//*****
				
				//VERIFICA SE O ALUNO POSSUI MÉDIA ESPECIAL. SE POSSUIR A NOTA DO BIMESTRE DEVE SER IGUAL A 0
				if (vetMediaEspecial[0] == "S")
					X = "0";
				else
					intDivisor = intDivisor + intPeso1Bim;
				
				if (vetMediaEspecial[1] == "S") 
					Y = "0";
				else
					intDivisor = intDivisor + intPeso2Bim;
									
				if (vetMediaEspecial[2] == "S") 
					Z = "0";
				else
					intDivisor = intDivisor + intPeso3Bim;
									
				if (vetMediaEspecial[3] == "S") 
					W = "0";
				else
					intDivisor = intDivisor + intPeso4Bim;				
				
				X = X.replace(",",".");
				Y = Y.replace(",",".");
				Z = Z.replace(",",".");
				W = W.replace(",",".");
				R = R.replace(",",".");
				C = C.replace(",",".");
	
				//alert(X + " - " + Y + " - " + Z + " - " + W + " - " + R + " - " + C);			
				
				X = parseFloat(X);
				Y = parseFloat(Y);
				Z = parseFloat(Z);
				W = parseFloat(W);
				if ((R != "-")) //Sem nota para a prova final (recuperação)
					R = parseFloat(R);			
					
				C = parseFloat(C);
				
				intMedia = Math.round(( ((X * intPeso1Bim) + (Y * intPeso2Bim) + (Z * intPeso3Bim) + (W * intPeso4Bim))/(intDivisor) )*100)/100;
				//intMedia = Math.round((<%=ucase(strFormula)%>)*100)/100;
				A = intMedia;
	
				objMediaAnual.value = calculaNota(A);
				
				if (strRecuperacao == "S"){
					if (R != "-"){
						//intMedia = Math.round((<%=ucase(strFormulaRecuperacao)%>)*100)/100;
						intMedia = Math.round(( ((A * intPesoMA) + (R * intPesoMR))/(intPesoMA+intPesoMR) )*100)/100;
					}
				}
				
				if (strConselho == "S"){
					intMedia = intMedia + C;
				}
				
				intMedia = calculaNota(intMedia); //função que ignora deixa somente 1 número após a víergula. Ex.: 6.86 para 6.8
				//alert(intMedia);
				
				if (intMedia<intMediaAprovacao){
					objMediaFinal.style.color = "#FF0000";
				}
				else{
					objMediaFinal.style.color = "#0000FF";				
				}
				
				objMediaFinal.value=intMedia;				
			}
			return intMedia;
		}

	
	function calculaNotaParaFechar(X,Y,Z,W,intMediaLegal,strPesos){
		var intParaFechar;
		var strParaFechar;
		var vetPesos = strPesos.split(";");
		var intDivisor;
		
		if (X=="-") X = "0";
		if (Y=="-") Y = "0";
		if (Z=="-") Z = "0";
		if (W=="-") W = "0";					
		
		X = X.replace(",",".");
		Y = Y.replace(",",".");
		Z = Z.replace(",",".");
		W = W.replace(",",".");
		
		X = parseFloat(X);
		Y = parseFloat(Y);
		Z = parseFloat(Z);
		W = parseFloat(W);					

		//*****ARMAZENA O VALOR DOS PESOS NAS REPECTIVAS VARIÁVEIS
		intPeso1Bim = parseFloat(vetPesos[0]);
		intPeso2Bim = parseFloat(vetPesos[1]);
		intPeso3Bim = parseFloat(vetPesos[2]);
		intPeso4Bim = parseFloat(vetPesos[3]);
		intPesoMA = parseFloat(vetPesos[4]);
		intPesoMR = parseFloat(vetPesos[5]);
		
		intDivisor = intPeso1Bim + intPeso2Bim + intPeso3Bim + intPeso4Bim;
		//*****		
		
		//intParaFechar = Math.round(((<%=intMediaLegal%> * <%=intDivisor%>) - (<%=strFormulaSemDivisor%>))*100)/100;
		intParaFechar = Math.round(((intMediaLegal * intDivisor) - ((X * intPeso1Bim) + (Y * intPeso2Bim) + (Z * intPeso3Bim) + (W * intPeso4Bim)))*100)/100;		
		intParaFechar = calculaNota(intParaFechar);
		
		if (intParaFechar < 0)
			intParaFechar=0
		
		strParaFechar = intParaFechar + "" //Converte pata string para trocar o "." por ","
		strParaFechar = strParaFechar.replace(".",",");
		
		return strParaFechar;		
	}