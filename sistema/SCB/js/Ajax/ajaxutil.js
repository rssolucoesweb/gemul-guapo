// JavaScript Document
//Tenta criar o objeto xmlHTTP
try{
    xmlhttp = new XMLHttpRequest();
}catch(ee){
    try{
        xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
    }catch(e){
        try{
            xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
        }catch(E){
            xmlhttp = false;
        }
    }
}

//Fila de conexões
fila=[]
ifila=0


/*
Função ExecAjax(id,url,mensagem)                                                                    
parâmetros: id  -  pode ser um id de uma combo ou div ou pode ser passado no lugar dela uma função, 
				   onde a mesma deve possuir a seguinte assinatura: function funcao(httpxml);        
				   o parametro httpxml e um objeto o qual tem as seguintes propriedades:             
			       responseXML: obtem um objeto xml para manipulação;
				   responseText: obtem o conteudo retornado na forma de texto(string);               
				   
		   url  -  url ser enviada ao servidor, onde pode ser passados os parametros na mesma,
				   ex: Teste.asp , Teste.asp?id=1&nome=FULANO, ou no lugar de uma url passar um
				   formulário html(form), desta forma a função submete o formulário para a página
				   informada no atributo action do formulário e os parametros são capturados
				   automaticamente atraves dos campos constantes no form;
			
	   mensaem  -  este parametro é opcional, você pode ou não informá-lo, trata-se de uma mensagem
			       que será exibida em uma div ou em um combobox enquanto é aguardada a resposta
				   do servidor.						 
---------------------------------------------------------------------------------------------------------
**Observação**: Se vc quiser usá-la para preencher uma combobox o retorno, obrigatoriamente, deverá ser um documento xml
conforme o exemplo abaixo:
<alunos> //nó root do xml
	<aluno> //cada "aluno" vai se transformar depois em um 'option' do combobox
		<codigo> //será o value do combobox
			1
		</codigo>
		<nome> //o que irá aparecer na combo(propriedade 'text')
			Fulano
		</nome>
	</aluno>
	<aluno>
		<codigo>
			2
		</codigo>
		<nome>
			Beltrano
		</nome>
	</aluno>
</alunos>
*/
			       

function ExecAjax(id,url,mensagem, assync){
	var msg = mensagem == undefined ? 'Carregando...' : mensagem;	
	if (typeof id == 'string') {
		var obj = document.getElementById(id);
		if (obj.tagName.toLowerCase() == 'select') {			
			var option = document.createElement('option')
			option.setAttribute('id','ajax_load')
			option.value = 'ajax_load'
			option.text = msg
			obj.innerHTML = '';
			obj.options[0] = option;
		}
		else {						
			obj.innerHTML="<span class='carregando'>" + msg + "</span>";
		}
	}
	else {
		obj = id;
	}
	
    //Adiciona à fila
	//Verifica se a opção de sincronismo foi informada. Se não, o valor padrão é assincrono
	assync = assync == undefined ? true : assync;
	
    fila[fila.length]=[obj,url, assync]
    //Se não há conexões pendentes, executa
    if((ifila+1)==fila.length)ajaxRun()	
}

//Executa a próxima conexão da fila
function ajaxRun(){
	var url = typeof fila[ifila][1] == 'object' ? montaUrl(fila[ifila][1]) : fila[ifila][1];		
	xmlhttp.open("GET",url,fila[ifila][2]);	
    //Função para tratamento do retorno
    xmlhttp.onreadystatechange=function() {
        if (xmlhttp.readyState==4){
			if (typeof fila[ifila][0] == 'function') {
				fila[ifila][0](xmlhttp);
			}
			else //preenche a combobox ou div
			{
				if (fila[ifila][0].tagName.toLowerCase() == 'select') {
					preencheCombo(xmlhttp.responseXML,fila[ifila][0])		
				}
				else {
					//retorno=xmlhttp.responseText.replace(/\+/g," ")
					retorno=unescape(xmlhttp.responseText.replace(/\+/g," "))
					fila[ifila][0].innerHTML=retorno
				}
			}
            //Roda o próximo
            ifila++
            if(ifila<fila.length)setTimeout("ajaxRun()",20)
        }
    }
	//Muda o estado do xmlHttp para que o mesmo não armazene o seu conteúdo na cache
	//xmlhttp.setRequestHeader("Cache-Control","no-store, no-cache, must-revalidate");
	//xmlhttp.setRequestHeader("Cache-Control", "post-check=0, pre-check=0");
	//xmlhttp.setRequestHeader("Pragma", "no-cache");
    //Executa
    xmlhttp.send(null)
}

function preencheCombo(xml,combo) {
	var elementos = xml.getElementsByTagName(xml.documentElement.childNodes(0).tagName);
	var option;
	for(i=0;i<elementos.length;i++) {
		option = document.createElement('option');
		option.value = elementos[i].childNodes[0].text;
		option.text = elementos[i].childNodes[1].text;			
		combo.options.add(option);
	}
	combo.options.remove(0);
}

function montaUrl(form) {
	var url = form.action + '?';
	var vetElem = document.frm.elements;
	var elem;
	for(var i=0;i<vetElem.length;i++) {
		elem = vetElem[i];
		if (((elem.type == 'radio' || elem.type == 'checkbox') && elem.checked) || 
			(elem.type == 'text') || 
			(elem.type == 'select') ||
			(elem.type == 'textarea')) {
			url += elem.name + '=' + encodeURI(elem.value) + '&';				
		}
	}
	return url.substring(0,url.length-1);	
}