// JavaScript Document
/*
*Adiciona um campo de usuário na tabela tblListaDeUsuarios caso o campo que está sendo editado
*seja o último campo da tabela.
*/
function adicionarCampoUsuario(cmp){
	var i = 0;
	var pos = null;
	var frm = document.frmEmprestimo;
	var tab = document.getElementById("tblEmprestimo");
	var novaLin;
	var posNovaLin;
	var colNome;
	var colText;
	var txtInput;

	//Adiciona uma nova linha na tabela se o número da linha do campo que está sendo alterado é 
	//igual ao número de linhas da tabela - 1
	if(cmp.parentElement.parentElement.rowIndex == tab.rows.length-1){
		posNovaLin = tab.rows.length;
		novaLin = tab.insertRow(posNovaLin);		//adiciona uma linha no final da tabela
		colText = novaLin.insertCell(0);			//adiciona a segunda coluna
		
		novaLin.cells[0].width = "15%";
		novaLin.cells[0].align = "center";
		novaLin.cells[0].className = "celula";
		txtInput = '<input type="text"';
		txtInput += 'class="text" maxlength="15" size="9" name="txtCodExemplar"';
		txtInput += 'onFocus="adicionarCampoUsuario(this)" ';
		txtInput += 'onBlur="consultaExemplar(this);excluirCampoVazio(this)" />&nbsp;';
        txtInput += '<input type="button" class="botao" value="OK" onClick="abreConsultaExemplar(this)" />'

		colText.innerHTML = txtInput;
		
		colText = novaLin.insertCell(1);	//adiciona a segunda coluna
		novaLin.cells[1].width = "6%";
		novaLin.cells[1].align = "center";
		novaLin.cells[1].className = "celula";
		txtInput = '<span id="Publicacao">&nbsp;</span>';
		colText.innerHTML = txtInput;
				
		colText = novaLin.insertCell(2);	//adiciona a segunda coluna
		novaLin.cells[2].width = "9%";
		novaLin.cells[2].align = "center";
		novaLin.cells[2].className = "celula";
		txtInput = '<span id="Autor">&nbsp;</span>';
		colText.innerHTML = txtInput;
		
		colText = novaLin.insertCell(3);	//adiciona a segunda coluna
		novaLin.cells[3].width = "7%";
		novaLin.cells[3].align = "center";
		novaLin.cells[3].className = "celula";
		txtInput = '<span id="Editora">&nbsp;</span>';
		colText.innerHTML = txtInput;
	
		colText = novaLin.insertCell(4);	//adiciona a segunda coluna
		novaLin.cells[4].width = "8%";
		novaLin.cells[4].align = "center";
		novaLin.cells[4].className = "celula";
		txtInput = '<span id="CDU">&nbsp;</span>';
		colText.innerHTML = txtInput;

		colText = novaLin.insertCell(5);	//adiciona a segunda coluna
		novaLin.cells[5].width = "19%";
		novaLin.cells[5].align = "left";
		novaLin.cells[5].className = "celula";
		txtInput = '<span id="Titulo">&nbsp;</span>';
		colText.innerHTML = txtInput;

		colText = novaLin.insertCell(6);	//adiciona a segunda coluna
		novaLin.cells[6].width = "8%";
		novaLin.cells[6].align = "center";
		novaLin.cells[6].className = "celula";
		txtInput = '<span id="ISBN">&nbsp;</span>';
		colText.innerHTML = txtInput;
		
		colText = novaLin.insertCell(7);	//adiciona a segunda coluna
		novaLin.cells[7].width = "7%";
		novaLin.cells[7].align = "center";
		novaLin.cells[7].className = "celula";
		txtInput = '<span id="Volume">&nbsp;</span>';
		colText.innerHTML = txtInput;

		colText = novaLin.insertCell(8);	//adiciona a segunda coluna
		novaLin.cells[8].width = "7%";
		novaLin.cells[8].align = "center";
		novaLin.cells[8].className = "celula";
		txtInput = '<span id="NPaginas">&nbsp;</span>';
		colText.innerHTML = txtInput;
		
		colText = novaLin.insertCell(9);	//adiciona a segunda coluna
		novaLin.cells[9].align = "center";
		colText.className = "celula";
		txtInput = '<input type="hidden" class="text" size="10" name="txtDataDevolucao" />&nbsp;';
		colText.innerHTML = txtInput;

	}
}


// Exclui uma linha da tabela tblListaDeUsuarios caso o conteúdo do campo texto desta linha esteja em branco
function excluirCampoVazio(cmp){
	
	var tab = document.getElementById("tblEmprestimo");
	var linha = cmp.parentElement.parentElement;
	var numLin = linha.rowIndex;
	
	if(cmp.value.trim().length == 0 && numLin != 0 && tab.rows.length - 1 != numLin)
	{
		var intCodExemplar = linha.childNodes(0).childNodes(0).value;
		if (intCodExemplar != '')
		{
			var txtCodExemplar = document.getElementById('txtCodExemplar');
		
			document.getElementById('cmdConfirmar').disabled = false;

			if (parseFloat(txtCodExemplar.value) == 0){
				document.getElementById('cmdConfirmar').disabled = false;
			}
		}
		tab.deleteRow(numLin);
	}
	
}

function consultaExemplar(cmp)
{
	var linha 				= cmp.parentElement.parentElement;
	var txtCodExemplar 		= linha.cells[0].childNodes(0);
	var txtTipoUsuario = document.getElementById('hdnTipoUsuario').value;
	var intQtdeExemplar = document.getElementById('hdnQtdeExemplar').value;
	
	if (txtCodExemplar.value == ''){
		return;
	}
	
	var tab = document.getElementById('tblEmprestimo');
	var NumLinhas = tab.rows.length -3;
	
	//Verifica se o Numero de emprestimo exede o limite cadastrado
	if (NumLinhas > intQtdeExemplar  ){
		txtCodExemplar.value = '';			
		alert('O Limite de Emprestimo Exedeu, Verifique!');
		txtCodExemplar.focus();
		return;
	}
	
	//Verifica se já existe exemplar informado na lista
	var tab = document.getElementById('tblEmprestimo');
	for (var i = 1; i < tab.rows.length; i++)
	{
		var CodExemplar = tab.rows[i].childNodes(0).childNodes(0).value;
		if (CodExemplar == txtCodExemplar.value && tab.rows[i] != linha)
		{
			txtCodExemplar.value = '';			
			alert('Exemplar já informado!');
			txtCodExemplar.focus();
			return;
		}
	}
	
	if (txtCodExemplar.value == '') 
		return;
		
	var func = function(xmlHttp){
		
		var xml = xmlHttp.responseXML;
		var publicacao = xml.getElementsByTagName('Publicacao')[0];
		
		for (var i=1; i<=8; i++)
		{
			linha.childNodes(i).innerHTML = '&nbsp;';	
		}
		
		if (publicacao == null)
		{
			alert(xmlHttp.responseText);
			txtCodExemplar.value = '';
			txtCodExemplar.focus();
			return;
		}
		
		var Publicacao = publicacao.getElementsByTagName('Publicacao')[0].text; 
		var Autor = publicacao.getElementsByTagName('Autor')[0].text; 
		var Editora = publicacao.getElementsByTagName('Editora')[0].text; 
		var CDU = publicacao.getElementsByTagName('CDU')[0].text; 
		var Titulo = publicacao.getElementsByTagName('Titulo')[0].text; 
		var SubTitulo = publicacao.getElementsByTagName('SubTitulo')[0].text; 
		var ISBN = publicacao.getElementsByTagName('ISBN')[0].text; 
		var Volume = publicacao.getElementsByTagName('Volume')[0].text; 
		var NPaginas = publicacao.getElementsByTagName('NPaginas')[0].text; 
		var DataDevolucao = publicacao.getElementsByTagName('DataDevolucao')[0].text; 
				
		linha.childNodes(1).innerText = Publicacao;
		linha.childNodes(2).innerText = Autor;
		linha.childNodes(3).innerText = Editora;
		linha.childNodes(4).innerText = CDU;
		linha.childNodes(5).innerText = Titulo;
		linha.childNodes(6).innerText = ISBN;
		linha.childNodes(7).innerText = Volume;
		linha.childNodes(8).innerText = NPaginas;
		linha.childNodes(9).childNodes(0).value = DataDevolucao;
		
		if (linha.childNodes(9).childNodes(1))
			linha.childNodes(9).childNodes(1).parentNode.removeChild(linha.childNodes(9).childNodes(1));
			linha.childNodes(9).innerHTML += DataDevolucao + '&nbsp;';
		
		document.getElementById('cmdConfirmar').disabled = false;
		
	}
	
	var destino = "GerarEmprestimo.xml.asp?CodExemplar=" + txtCodExemplar.value  + "&TipoUsuario=" + txtTipoUsuario;
	//ExecAjax('divRetorno',destino,'','Buscando...');
	ExecAjax(func, destino, '');
	
}
