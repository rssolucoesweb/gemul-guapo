	var aberto = false;
	var strAltura  = (screen.height);
	var strLargura = (screen.width);
	
	function mostraLinhaTr(id){
		var elemento = document.getElementById("tr" + id);
		if(elemento.style.display == ''){
			elemento.style.display = 'none';
		}else{
			elemento.style.display = '';
		}
	}
	
	function caminhoAplicacao(){
		var i;
		var strUrl = "http://" + window.location.host + "/";
		
		for (i=1; i<window.location.pathname.length; i++) {
			if (window.location.pathname.substr(i,1)=="/") {
				break;
			}
			strUrl = strUrl + window.location.pathname.substr(i,1);
		}
		return strUrl;
	}
	
	function fecharSubmit(){
		window.opener.frm.submit();
		window.close();		
	}
	
	function fechaHelp() {
		//função que verifica se a tela de help ainda já foi fechada
		//redimensiona a página principal
		if (help.closed) {
			parent.window.resizeTo(strLargura,strAltura-25);
			aberto = false;
		}
		else {
			setTimeout("fechaHelp()",100);
			aberto = true;
		}
	}

	function abreHelp(pagina) {
		var strCaminho;
		strCaminho = caminhoAplicacao();
		
		//Abre a tela de help e redimensiona a página
		if (pagina=="")
			pagina = "help/inicio_hlp.asp";
		
		if (!aberto) {
			strCaminho = strCaminho + "/help/hlp.asp?pagina=" + strCaminho + "/" + pagina;				
			parent.window.resizeTo((strLargura-300),(strAltura-25));
			help = window.open(strCaminho,"help","height=" + (strAltura-25) + ",width=300,menubar=no,toolbar=no,scrollbars=yes,status=yes,top=0,left=600");
			fechaHelp();
			
		} else {
			help.close();
		}
	}
	
	function paginaHelp(pagina){
		//Página de help a ser chamada a ser chamada. Caso não tenha passar "" (vazio)		
		if (parent.topo.frm.txtPaginaHelp){
			if (pagina=="")
				parent.topo.frm.txtPaginaHelp.value  = "";
			else
				parent.topo.frm.txtPaginaHelp.value  = pagina;
		}
			return true;
	}
	
	function tituloPagina(descricao){
		//preenche no topo.asp o título 
		if (parent.topo.titulo)
			parent.topo.titulo.innerText = descricao;
		return true;
	}	
	
	function reload(){
	
	 if(frm.txtCodEscolaSolicitante){frm.txtCodEscolaSolicitante.value=""}
		frm.submit();
		return true;	
	}
	
	function limpar(parametro){
		
		if (parametro!="") {
			window.navigate(parametro);
		}else{
		
			//limpa os campos do formulário
			var form = window.document.forms[0]
			var urlForm
			urlForm = location.href; //retorna a url da página
			
			//limpa os parametros da url
			urlForm = urlForm.substring(0, urlForm.indexOf("?"));
			
			for (var i = 0; i < form.elements.length; i++) {
				//verifica todos os checkbox
				
				if (form.elements[i].type == "checkbox"){
					form.elements[i].checked = false;			
				}	
				
				if (form.elements[i].type == "radio"){ //option button
					form.elements[i].value= "";			
				}	
				
				if (form.elements[i].type == "select-one") //combo
					form.elements[i].value=0;
				
				if (form.elements[i].type == "text") //text box
					form.elements[i].value="";
					
				if (form.elements[i].type == "hidden") //text box escondido
					form.elements[i].value="";				
				
				if (form.elements[i].type == "textarea")
					form.elements[i].value="";
			}
			form. urlForm;
			form.submit();
			return true;	
		}
	}	
	
	function principal(){
		var pagina;
		pagina = "http://" + window.location.host + "admim.asp";
		window.navigate(pagina);
	}		
	
	function trim(str) 
	{
		// Remove leading spaces and carriage returns	
		while ((str.substring(0,1) == ' ') || (s.substring(0,1) == '\n') || (s.substring(0,1) == '\r'))
		{
			str = str.substring(1,str.length);
		}
		// Remove trailing spaces and carriage returns
		while ((str.substring(str.length-1,str.length) == ' ') || (str.substring(str.length-1,str.length) == '\n') || (str.substring(str.length-1,str.length) == '\r'))
		{
			str = str.substring(0,str.length-1);
		}
		return str;
	}
		
	function abreConsulta(caminho){
		window.open(caminho,"abreConsulta","top=5,left=5,height=600,width=800,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}	
	function abreConsulta1(caminho){
		window.open(caminho,"consulta1","top=5,left=5,height=510,width=519,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}	
	
	function Consulta(pagina){
		window.open(pagina,"consulta", "top=0,left=0,height=600,width=778,menubar=no,toolbar=no,scrollbars=yes,status=yes");
		return true;
 	}

	function linhaMouseOverFoto(linha){
		linha.style.backgroundColor="#E1F0FF";
		return true;
	}
	
	function linhaMouseOver(linha){
		linha.style.backgroundColor="#E1F0FF";
		return true;
	}
	
	function linhaMouseOut(linha){
		linha.style.backgroundColor="";
		return true;
	}	
function currencyFormat(fld, e) { 
	var sep = 0; 
	var milSep='.';
	var decSep=',';
	var key = ''; 
	var i = j = 0; 
	var len = len2 = 0; 
	var strCheck = '0123456789'; 
	var aux = aux2 = ''; 
	var whichCode = (window.Event) ? e.which : e.keyCode; 
	
	if (whichCode == 13) return true;  // Enter 
	
	key = String.fromCharCode(whichCode);  // Get key value from key code 
	
	if (strCheck.indexOf(key) == -1) return false;  // Not a valid key 
	
	len = fld.value.length; 
	
	for(i = 0; i < len; i++) 
		if ((fld.value.charAt(i) != '0') && (fld.value.charAt(i) != decSep)) break; 
		
	aux = ''; 
	
	for(; i < len; i++) 
		if (strCheck.indexOf(fld.value.charAt(i))!=-1) aux += fld.value.charAt(i); 
		
	aux += key; 
	len = aux.length; 
	if (len == 0) fld.value = ''; 
	if (len == 1) fld.value = '0'+ decSep + '0' + aux; 
	if (len == 2) fld.value = '0'+ decSep + aux; 
	if (len > 2) { 
		aux2 = ''; 
		for (j = 0, i = len - 3; i >= 0; i--) { 
			if (j == 3) { 
				aux2 += milSep; 
				j = 0; 
			} 
			aux2 += aux.charAt(i); 
			j++; 
		} 
		fld.value = ''; 
		len2 = aux2.length; 
		for (i = len2 - 1; i >= 0; i--) 
			fld.value += aux2.charAt(i); 
			
		fld.value += decSep + aux.substr(len - 2, len); 
	} 
		return false; 
} 

/*
*****************************************
* Valor monetário com 4 casas decimais *
* Autor: Antonio Almeida (Evo Morales) *
*****************************************
*/
function currencyFormat4casas(objTextBox, SeparadorMilesimo, SeparadorDecimal, e){
var sep = 0;
var key = '';
var i = j = 0;
var len = len2 = 0;
var strCheck = '0123456789';
var aux = aux2 = '';
var whichCode = (window.Event) ? e.which : e.keyCode;
if (whichCode == 13 || whichCode == 8) return true;
key = String.fromCharCode(whichCode); // Valor para o código da Chave
if (strCheck.indexOf(key) == -1) return false; // Chave inválida
len = objTextBox.value.length;
//alert(len);
for(i = 0; i < len; i++)
if ((objTextBox.value.charAt(i) != '0') && (objTextBox.value.charAt(i) != SeparadorDecimal)) break;
aux = '';
for(; i < len; i++)
if (strCheck.indexOf(objTextBox.value.charAt(i))!=-1) aux += objTextBox.value.charAt(i);
aux += key;
len = aux.length;
// alert(len);
if (len == 12){
return false;
}
if (len == 0) objTextBox.value = '';
if (len == 1) objTextBox.value = '0'+ SeparadorDecimal + '0' + '0' + '0' + aux;
if (len == 2) objTextBox.value = '0'+ SeparadorDecimal + '0' + '0' + aux;
if (len == 3) objTextBox.value = '0'+ SeparadorDecimal + '0' + aux;
if (len == 4) objTextBox.value = '0'+ SeparadorDecimal + aux;
if (len > 4) {
aux2 = '';
for (j = 0, i = len - 5; i >= 0; i--) {
if (j == 3) {
aux2 += SeparadorMilesimo;
j = 0;
}
aux2 += aux.charAt(i);
//alert(aux2);
j++;
}
objTextBox.value = '';
//alert('1');
len2 = aux2.length;
//alert('2');
for (i = len2 - 1; i >= 0; i--)
	objTextBox.value += aux2.charAt(i);
	objTextBox.value += SeparadorDecimal + aux.substr(len - 4, len);
	//alert(aux.substr(len - 4, len));
	}
	return false;
} 

	function formataCampo(objCampo,intTipo,intTamanho,evt){
		//objCampo   = campo a ser formatado
		//intTipo    = 1 -> texto; intTipo = 2 -> número; intTipo = 3 -> data; intTipo=4 ->texto e numero; intTipo=5 ->CPF; 
		//intTipo    = 6 -> numero e virgula
		//intTipo    = 7 -> Data Referencia
		//intTipo    = 10 -> telefone na máscara ####-####
		//intTipo    = 11 -> cnpj
		//intTipo    = 12 -> CNAS e CEBAS
		//intTipo	 = 13 -> numero,virgula e dois pontos
		//intTamanho = Quantidade de caracteres que o campo poderá aceitar
		
		//verifica tecla pressionada
		var str=objCampo.value
		
        evt = evt || window.event;
        var charCode = (evt.which) ? evt.which : evt.keyCode;
		
		if(charCode == 8 || charCode == 46 || charCode == 9){ //para o backspace e o delete funcionarem no firefox
			return true	
		}	
		
		//Tamanho máximo permitido
		if (str.length>intTamanho-1){
			return false
		}		
		
		//Verifica o intTipo para barrar caracteres inválidos
		switch (intTipo)
		{
			case 1: //texto~
				if (charCode==13) {
					return false					
				}
				if (charCode==32) {
					//Nao permitir a digitacao de 2 espacos em branco
					if (str.substring(str.length-1,str.length)== ' '){			
						return false
					}
					return true
				}
				
				if (charCode==45) { // HÍFEN
					//Nao permitir a digitacao de 2 HÍFENS seguidos
					if (str.substring(str.length-1,str.length)== '-'){			
						return false
					}
					return true
				}				
				
				if (charCode>=97 && charCode<=122) {
					//charCode = charCode - 32
					return true	
				}
				if (charCode>=65 && charCode<=90) {
					return true
				}
				if (charCode>=123 && charCode<=255) {
					//charCode = charCode - 32
					return true
				}
				break
			case 2: //números
				if (charCode>=48 && charCode<=57){
					return true
				}
			case 3: //Data
				if (charCode<48 || charCode>57){
					return false
				}
				if (str.length==2){
					objCampo.value = objCampo.value + '/'
					return true
				}
				if (str.length==5){
					objCampo.value = objCampo.value + '/'

					return true
				}
				return true
			
			case 7: //Data Referencia 
				if (charCode<48 || charCode>57){
					return false
				}
				if (str.length==2){
					objCampo.value = objCampo.value + '/'
					return true
				}
				return true
				
			case 4: //Texto e numero
				if (charCode==32) {
					return true
				}
				if (charCode>=97 && charCode<=122) {
					charCode = charCode - 32
					return true	
				}
				if (charCode>=65 && charCode<=90) {
					return true
				}
				
				if (charCode>=48 && charCode<=57){
					return true
				}
			
			case 5: //cpf
				
				if (charCode<48 || charCode>57){
					return false
				}
				
				switch (str.length)
				{	
					case 3:
						if (str.length==3){
							objCampo.value = objCampo.value + '.'
							return true
						}						
						
					case 7:
					if (str.length==7){
						objCampo.value = objCampo.value + '.'
						return true
					}					
					case 11:				
						if (str.length==11){
							objCampo.value = objCampo.value + '-'
							return true
						}
				  default:
						return true	
				}
			case 6: //numero e virgula
				if (charCode==32) {
					return true
				}
				if (charCode==44) {
					return true	
				}
				//if (charCode>=65 && charCode<=90) {
				//	return true
				//}
				
				if (charCode>=48 && charCode<=57){
					return true
				}
			case 8: //números com -
				if (charCode>=45 && charCode<=57) {
					return true
				}
			case 9: //somente x e X
				if (charCode==120 || charCode==88) {
					return true
				}
			case 10: //telefone

				if (charCode>=48 && charCode<=57){

					formatarMascara(objCampo,"####-####")
					return true
				}	
			case 11: //cnpj
				
				if (charCode<48 || charCode>57){
					return false
				}
				
				
				switch (str.length)
				{	
					case 2:
						if (str.length==2){
							objCampo.value = objCampo.value + '.'
							return true
						}						
						
					case 6:
					if (str.length==6){
						objCampo.value = objCampo.value + '.'
						return true
					}					
					case 10:				
						if (str.length==10){
							objCampo.value = objCampo.value + '/'
							return true
						}
					case 15:				
						if (str.length==15){
							objCampo.value = objCampo.value + '-'
							return true
						}						
				  default:
						return true	
				}
			case 12: //CNAS e CEBAS
				if (charCode<48 || charCode>57){
					return false
				}
				
				switch (str.length)
				{	
					case 11:
						if (str.length==11){
							objCampo.value = objCampo.value + '/'
							return true
						}						
						
					case 14:
					if (str.length==14){
						objCampo.value = objCampo.value + '-'
						return true
					}					
				  default:
						return true	
				}
				
			case 13: //numero,virgula e dois pontos
			
				if (charCode==44) {
					return true	
				}				
				if (charCode>=48 && charCode<=58){
					return true
				}

			default:
				return false		
		}
		
		return false
	}
	
	function validaData(objCampo){
		//verifica se uma deterimnada data é válida ou não
		var strData = objCampo.value
		if (strData==""){
			return false;
		}
		var intDia = parseInt(strData.substring(0,2),10);
		var intMes = parseInt(strData.substring(3,5),10);
		var intAno = parseInt(strData.substring(6,10),10);
		
		var intDiaPrimeiraPosicao = strData.substring(0,1);

		if ( (intDiaPrimeiraPosicao == "1") || (intDiaPrimeiraPosicao == "2") || (intDiaPrimeiraPosicao == "3") || (intDiaPrimeiraPosicao == "4") || (intDiaPrimeiraPosicao == "5") || (intDiaPrimeiraPosicao == "6") || (intDiaPrimeiraPosicao == "7") || (intDiaPrimeiraPosicao == "8") || (intDiaPrimeiraPosicao == "9") || (intDiaPrimeiraPosicao == "0") ){
		} else {
			objCampo.value="";
			return false;
		}
		if (intDia <= 31 && intMes <=12 && intAno >= 1000){
		  if (strData.substring(0,1)=='0' && strData.substring(1,2) != '0' || strData.substring(0,1)!='0'){
		    if (strData.substring(2,3)=="/"){
		      if (strData.substring(3,4)=='0' && strData.substring(4,5)!='0' || strData.substring(3,4)!='0'){
		        if (strData.substring(5,6)=="/"){
		          if (strData.substring(6,7)== '0' || strData.substring(6,7)=='' && strData.substring(7,8)!='0'){
		            window.alert('Ano inexistente!');
					objCampo.value="";
	                objCampo.focus();
		            return false;
		          } 
		          else {
		            if (intMes == 2){
		              if ((intDia > 0 ) && (intDia <= 29)){
		                 if (intDia == 29){
		                    if ((intAno % 4) == 0){
		                      return true;
		                    }
		                    else {
		                      window.alert('Este dia não existe, digite novamente!');
							  objCampo.value="";
							  objCampo.focus();
		                      return false;
		                    }
		                 }
		              } 
		              else {
		                window.alert('Este dia não existe, digite novamente!');
						objCampo.value="";
		                objCampo.focus();
		                return false;
		              }
		            }
		            if ((intMes == 4)||(intMes == 6)||(intMes == 9)||(intMes ==11)){
		              if ((intDia > 0 ) && (intDia <= 30)){
		                return true;
		              }
		              else{
		                window.alert('Este dia não existe, digite novamente!');
						objCampo.value="";
						objCampo.focus();
		                return false;
		              }
		            }
		            if ((intMes == 1)||(intMes == 3)||(intMes == 5)||(intMes ==7)||(intMes ==8)||(intMes == 10)||(intMes == 12)) {
		              if ((intDia > 0) && (intDia <= 31)) {
		                return true;
		              }
		              else{
		                window.alert('Este dia não existe, digite novamente!');
						objCampo.value="";
						objCampo.focus();
		                return false;
		              }
		            }
		          }
		        }
		        else{
		          window.alert('A data digitada não está no formato padrão(dd/mm/aaaa)!');
					objCampo.value="";
	                objCampo.focus();
		          return false;
		        }
		      }
		      else{
		        window.alert('Mês inexistente!');
					objCampo.value="";
	                objCampo.focus();
		        return false;
		      }
		    }
		    else{
		      window.alert('A data digitada não está no formato padrão(dd/mm/aaaa)!');
					objCampo.value="";
	                objCampo.focus();
		      return false;
		    }
		  }
		  else{
		    window.alert('Dia inexistente!');
			objCampo.value="";
			objCampo.focus();
		    return false;
		  }
		}
		else {
		  window.alert('O dia e/ou o mês digitado não está no formato padrão (dd/mm/aaaa)!');
			objCampo.value="";
			objCampo.focus();
		  return false;
		}
	return true;
	}

	
	function FormataCNPJ(Campo, teclapres){

	   var tecla = teclapres.keyCode;
	
	   var vr = new String(Campo.value);
	   vr = vr.replace(".", "");
	   vr = vr.replace(".", "");
	   vr = vr.replace("/", "");
	   vr = vr.replace("-", "");
	
	   tam = vr.length + 1 ;
		   
	   if (tecla != 9 && tecla != 8){
		  if (tam > 2 && tam < 6)
			 Campo.value = vr.substr(0, 2) + '.' + vr.substr(2, tam);
		  if (tam >= 6 && tam < 9)
			 Campo.value = vr.substr(0,2) + '.' + vr.substr(2,3) + '.' + vr.substr(5,tam-5);
		  if (tam >= 9 && tam < 13)
			 Campo.value = vr.substr(0,2) + '.' + vr.substr(2,3) + '.' + vr.substr(5,3) + '/' + vr.substr(8,tam-8);
		  if (tam >= 13 && tam < 15)
			 Campo.value = vr.substr(0,2) + '.' + vr.substr(2,3) + '.' + vr.substr(5,3) + '/' + vr.substr(8,4)+ '-' + vr.substr(12,tam-12);
		}
	}
	
	function validaCPF(campo) {
		var pcpf=campo.value;
		
		pcpf = pcpf.replace(".","");
		pcpf = pcpf.replace(".","");
		pcpf = pcpf.replace("-","");
		
		if (pcpf != "") {
		
			if (pcpf.length != 11){
				sim=false;
			}
			else{
				sim=true;
			}
			
			if ( (pcpf==11111111111) || (pcpf==22222222222) ||
				(pcpf==33333333333) || (pcpf==44444444444) || (pcpf==55555555555) ||
				(pcpf==66666666666) || (pcpf==77777777777) || (pcpf==88888888888) ||
				(pcpf==99999999999) || (pcpf==00000000000) ){
					sim=false;
			}
			
			if(sim){
				for (i=0; i<=(pcpf.length-1) && sim; i++){
					val = pcpf.charAt(i);
					if((val!="9")&&(val!="0")&&(val!="1")&&(val!="2")&&(val!="3")&&(val!="4")&&( val!="5")&&(val!="6")&&(val!="7")&&(val!="8")){
						sim=false;
					}
				}
			
				if(sim){
					soma=0;
					for (i=0;i<=8;i++){
						val = eval(pcpf.charAt(i));
						soma = soma + (val*(i+1));
					}
				
					resto = soma % 11;
					
					if (resto>9)
						dig = resto -10;
					else
						dig = resto;
					
				
					if (dig != eval(pcpf.charAt(9))){
						sim=false
					}else{
						soma = 0
						for (i=0;i<=7;i++){
							val = eval(pcpf.charAt(i+1))
							soma = soma +	(val*(i+1))
						}
						soma = soma + (dig * 9)
						resto = soma % 11
						if (resto>9){
							dig = resto -10
						}else{
							dig = resto
						}
				
						if (dig != eval(pcpf.charAt(10))){
							sim = false
						}else{
							sim = true
						}
					}
				}
			}
			
			if (!sim){
				alert("CPF inválido!");
				campo.focus();
				campo.select();
			}
					
		}
	}
	
function calculaNota(valor){ //->função que ignora deixa somente 1 número após a víergula. Ex.: 6.86 para 6.8

	var qtde;
	var i;
	var VNota = "";
	var ponto = false;
	valor = "" + valor; //->converte para string
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
function MarcaTodos(valor){
	var form = window.document.forms[0];
	var i;
	
	
	for (var i = 0; i < form.elements.length; i++) {
		//verifica todos os checkbox
		if (form.elements[i].type == "checkbox"){
			//verifica se o checkbox está marcado
			if (form.chkAluno) {
				if (form.elements[i].name == "chkAluno"){
					//verifica se o checkbox está marcado
					if (form.elements[i].disabled==false) {
						form.elements[i].checked=valor;
					}
				}
			}
			else {
				form.elements[i].checked=valor;
			}
		}
	}
}	

function isNumeric(strString)
   //  check for valid numeric strings	
   {
   var strValidChars = "0123456789.-";
   var strChar;
   var blnResult = true;

   if (strString.length == 0) return false;

   //  test strString consists of valid characters listed above
   for (i = 0; i < strString.length && blnResult == true; i++)
      {
      strChar = strString.charAt(i);
      if (strValidChars.indexOf(strChar) == -1)
         {
         blnResult = false;
         }
      }
   return blnResult;
   }

	function funcCheckContaCorrente(campo){

		//formata aao digitar a conta corretne
		//verifica tecla pressionada
		var str=campo.value.replace("-","");
		var strConta
		var strContaDigito
		var tam = 1

		if (str.length == 1){
			tam = 0
		}
		strConta = str.substring(0,str.length-tam);
		strContaDigito = str.substring((str.length-tam),(str.length));
		if (str.length == 1) strContaDigito = "";
		if (str.length == 0){
			campo.value = "";
		}
		else{
			if (str.length == 1){
				campo.value = strConta;
			}else{
				campo.value = strConta + '-' + strContaDigito;
			}
		}
		return true
	}	
	
	function mascara(o,f){
		v_obj=o
		v_fun=f
		setTimeout("execmascara()",1)
	}
	
	function execmascara(){
		v_obj.value=v_fun(v_obj.value)
	}
	
	function telefone(v){
		v=v.replace(/\D/g,"")                 //Remove tudo o que não é dígito
		v=v.replace(/^(\d\d)(\d)/g,"($1) $2") //Coloca parênteses em volta dos dois primeiros dígitos
		v=v.replace(/(\d{5})(\d)/,"$1-$2")    //Coloca hífen entre o quarto e o quinto dígitos
		return v
	}
	function cep(v){
		v=v.replace(/D/g,"")                //Remove tudo o que não é dígito
		v=v.replace(/^(\d{5})(\d)/,"$1-$2") //Esse é tão fácil que não merece explicações
		return v
	}	
	function site(v){
		//Esse sem comentarios para que você entenda sozinho ;-)
		v=v.replace(/^http:\/\/?/,"")
		dominio=v
		caminho=""
		if(v.indexOf("/")>-1)
			dominio=v.split("/")[0]
			caminho=v.replace(/[^\/]*/,"")
		dominio=dominio.replace(/[^\w\.\+-:@]/g,"")
		caminho=caminho.replace(/[^\w\d\+-@:\?&=%\(\)\.]/g,"")
		caminho=caminho.replace(/([\?&])=/,"$1")
		if(caminho!="")dominio=dominio.replace(/\.+$/,"")
		v="http://"+dominio+caminho
		return v
	}	