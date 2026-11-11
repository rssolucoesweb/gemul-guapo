$(document).ready(function () {
	definirMascaraCelular($("#txtFoneResidencial"));
	definirMascaraCelular($("#txtFonecelular"));
	definirMascaraCelular($("#txtFoneComercial"));
	definirMascaraCelular($("#txtPaifone"));
	definirMascaraCelular($("#txtMaefone"));
	definirMascaraCelular($("#txtResponsavelfone"));
	
	$("#txtCepresidencia").on("blur", function () {
	   var cep = $(this).val();
	   obterEndercoPorCEP(cep);			
   });
});

var obterEndercoPorCEP = function (numeroCEP) {
   $("#txtLogradouro").val("");
   $("#txtBairroaluno").val("");
   $("#cmbUFResidencia").val("9");
   $("#txtCidaderesidencia").val("");
   $("#txtComp_endereco").val("");

   var cep = numeroCEP.replace("-", "");
   //var url = "https://viacep.com.br/ws/" + cep + "/json/";
   var url = "https://opencep.com/v1/" + cep + ".json";

   $.getJSON(url, cep)
	.done(function (endereco) {
		if (endereco != null) {
			$("#txtLogradouro").val($.trim(endereco.logradouro));
			$("#txtBairroaluno").val(endereco.bairro);
			//$("#cmbUFResidencia").val(endereco.uf);
			$("#txtComp_endereco").val(endereco.complemento);
			$("#txtCidaderesidencia").val(endereco.localidade);
		}
	});;
};

var definirMascaraCelular = function (el) {
   $(el).keydown(function (event) {
	   var target, phone, element;
	   target = (event.currentTarget) ? event.currentTarget : event.srcElement;
	   phone = target.value.replace(/\D/g, '');
	   element = $(target);
	   element.unmask();
	   if (phone.length > 5 && (phone.substr(2, 1) == "9")) { //ele só vai colocar no formato de SP quando for ddd 11 e iniciar com 9.
		   element.mask("(00) 00000-0000");
	   } else {
		   element.mask("(00) 0000-0000");
	   }
   });
}

<!-- fim funções para cep e mascara telefone -->

function validaCPFAluno(campo) {
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
		   campo.value="";
		   campo.focus();
		   return false;
	   }
			   
   }
}


function validaDigitacaoBolsaFamilia(){
   var frm = document.getElementById("frm");
   if (frm.txtBolsaFamilia.value.length!=11 && frm.txtBolsaFamilia.value != "") {
	   alert("Número inválido!");
	   frm.txtBolsaFamilia.focus();
	   return false;
   }	
   frm.cmbPeriodo.value=0
}

function blocTexto(valor, id)
{
   quant = 500;
   total = valor.length;
   if(total <= quant)
   {
	   resto = quant - total;
	   document.getElementById('cont').innerHTML = resto;
   }
   else
   {
	   document.getElementById('txtResposta_'+id).value = valor.substr(0,quant);
   }
}



function carregaAluno(){
   if (frm.txtMatricula.value != ""){
	   frm.action="sca_aluno.asp"
	   frm.submit();
   }
}


function verificaMedicamento(){
   var frm = document.getElementById("frm");
   
   if (frm.MEDICAMENTO_CONTROLADO.value == "S"){
	   document.getElementById("coluna_medicamento").style.display = "table-row";
   }
   if (frm.MEDICAMENTO_CONTROLADO.value == "N"){
	   frm.MEDICAMENTO_CONTROLADO_QUAL.value="";
	   document.getElementById("coluna_medicamento").style.display = "none";
   }
}
function verificaOutroResponsavel(){
   var frm = document.getElementById("frm");
   if (frm.RESPONSAVEL_QUEM.value == "OUTRO" || frm.RESPONSAVEL_QUEM.value == "Outro"){
	   document.getElementById("coluna_outro_resposavel").style.display = "table-row";
   }
   if (frm.RESPONSAVEL_QUEM.value != "OUTRO" && frm.RESPONSAVEL_QUEM.value != "Outro"){
	   frm.RESPONSAVEL_GRAU_PARESTESCO.value="";
	   document.getElementById("coluna_outro_resposavel").style.display = "none";
   }
   if (frm.RESPONSAVEL_QUEM.value == "MAE" || frm.RESPONSAVEL_QUEM.value == "Mae"){
	   frm.txtResponsavel.value = frm.txtMae.value;
   }
   if (frm.RESPONSAVEL_QUEM.value == "PAI" || frm.RESPONSAVEL_QUEM.value == "Pai"){
	   frm.txtResponsavel.value = frm.txtPai.value;
   }
}

function verificaRestricao(){
   var frm = document.getElementById("frm");
   
   if (frm.RESTRICAO_ALIMENTAR.value == "S"){
	   document.getElementById("coluna_alimento").style.display = "table-row";
   }
   if (frm.RESTRICAO_ALIMENTAR.value == "N"){
	   frm.RESTRICAO_ALIMENTAR_QUAL.value="";
	   document.getElementById("coluna_alimento").style.display = "none";
   }
}
function verificaAlergia(){
   var frm = document.getElementById("frm");
   
   if (frm.ALERGIA.value == "S"){
	   document.getElementById("coluna_alergia").style.display = "table-row";
   }
   if (frm.ALERGIA.value == "N"){
	   frm.ALERGIA_QUAL.value="";
	   document.getElementById("coluna_alergia").style.display = "none";
   }
}
function resultadoConsulta(intCodigo){

   var frm = document.getElementById("frm");
   
   frm.txtCodigo.value=intCodigo;
   frm.submit();
}

function carregaTurma(){
   
   var frm = document.getElementById("frm");
   
   frm.action="sca_aluno.asp"
   frm.submit();
}
function verificar(){
   
   var frm = document.getElementById("frm");
   
   frm.action="sca_receber_aluno.asp"
   frm.submit();
}

function salvar(acao){
   
   var frm = document.getElementById("frm");
   
   if ((acao=="I") || (acao=="A")) {
	   
	   if (frm.txtNomealuno.value==""){
		   alert("O Nome do Aluno deve ser informado.")
		   frm.txtNomealuno.focus()
		   return false;
	   }

	   if (frm.txtDatamatricula.value==""){
		   alert("A Data de Matrícula deve ser informada.")
		   frm.txtDatamatricula.focus()
		   return false;
	   }
   
	   if (frm.txtDataNascimento.value==""){
		   alert("A Data de Nascimento deve ser informada.")
		   frm.txtDataNascimento.focus()
		   return false;
	   }

	   if (frm.txtcpf.value==""){
		   alert("O CPF do aluno deve ser informado.")
		   frm.txtcpf.focus()
		   return false;
	   }

	   if (frm.cmbSexo.value=="0"){
		   alert("O Sexo deve ser informado.")
		   frm.cmbSexo.focus()
		   return false;
	   }

	   if (frm.txtCidadenascimento.value==""){
		   alert("A Naturalidade do Aluno deve ser informada.")
		   frm.txtCidadenascimento.focus()
		   return false;
	   }
	   
	   if (frm.cmbTipoNacionalidade.value!="3"){
		   
		   if (frm.cmbUfnascimento.value=="0"){
			   alert("O UF da Naturalidade deve ser informada.")
			   frm.cmbUfnascimento.focus()
			   return false;
		   }
		   
	   }

	   if (frm.cmbNacionalidade.value=="0"){
		   alert("A Nacionalidade deve ser informada.")
		   frm.cmbUfnascimento.focus()
		   return false;
	   }

	   if (frm.cmbTipoNacionalidade.value=="0"){
		   alert("A Origem da Nacionalidade deve ser informada.")
		   frm.cmbTipoNacionalidade.focus()
		   return false;
	   }

	   if (frm.cmbProfissao.value=="0"){
		   alert("A Profissão deve ser informada.")
		   frm.cmbProfissao.focus()
		   return false;
	   }

	   if (frm.cmbEtnia.value=="0"){
		   alert("A Etnia deve ser informada.")
		   frm.cmbEtnia.focus()
		   return false;
	  }
	  
	  if (frm.cmbNecessidadeEspecial.value==frm.txtCodNecesEspecialAtual.value){
 
	  	if (frm.txtSitNecesEspecialAtual.value=="I"){
		   alert("Selecione uma necessidade especial ATIVA.")
		   return false;
	   	}
	   }

	   //bolsa familia
	   /*
	   if (frm.txtBolsaFamiliaAnterior.value!="") {
		   if ((frm.txtBolsaFamilia.value=="")){
			   alert("O númerio do Auxilio Brasil deve ser preenchido.")
			   frm.txtBolsaFamilia.focus()
			   return false;
		   }
	   }
	   */
	   
	   if ((frm.txtFoneResidencial.value=="") && (frm.txtFonecelular.value=="")){
		   alert("Pelo menos um telefone de contato deve ser informado.")
		   frm.txtFoneResidencial.focus()
		   return false;
	   }

	   if (frm.txtMae.value==""){
		   alert("O Nome da Mãe deve ser informado.")
		   frm.txtMae.focus()
		   return false;
	   }
	   
	   
	   
	   var turma = frm.cmbTurma.value;
	   var gradeNova = "";
	   gradeNova = turma.substring(9,17)

	   var turmaAtual = frm.txtCodTurmaAtual.value;
	   var gradeAtual = "";
	   gradeAtual = turmaAtual.substring(9,17)
	   
	   if (frm.cmbTurma.value != "0"){
		   if (gradeNova!=gradeAtual && gradeAtual !='00000000') {
			   var men = 'ATENÇÃO: \nA turma do aluno será alterada, caso a nova turma do aluno for diferente o curso/periodo (Grade Curricular), com esse procedimentos todos as lancamentos para a grade do aluno da turma serão zeradas, inclusive as notas. Deseja continuar com essa alteração?';
			   if (confirm(men)) {
				   frm.action="sca_aluno_cod.asp?acao=" + acao;
				   frm.submit();
			   } else {
				   return false;
			   }
		   }else{
			   frm.action="sca_aluno_cod.asp?acao=" + acao;
			   frm.submit();
			   return true;
		   }
	   }else{
		   if (frm.cmbTurma.value == "0"){
			  alert("A turma do aluno deve ser informada.");
			  //mostraDadosEscolares.style.display="table-row"
			 
			  frm.cmbTurma.focus();
		   return false;
	   }
	   
		   frm.action="sca_aluno_cod.asp?acao=" + acao;
		   frm.submit();
		   return true;
	   }	
	   
   }
   
   if (acao=="E"){
	   
	   var men = 'ATENÇÃO: Deseja realmente excluir este Aluno'
	   if (confirm(men)) {
		   frm.action="sca_aluno_cod.asp?acao=" + acao;
		   frm.submit();
	   } else {
		   return false;
	   }
   
   }	
		   
}
function renovar(){
   
   var frm = document.getElementById("frm");
	   
   if (frm.txtNomealuno.value==""){
	   alert("O Nome do Aluno deve ser informado.")
	   frm.txtNomealuno.focus()
	   return false;
   }

   if (frm.txtDatamatricula.value==""){
	   alert("A Data de Matrícula deve ser informada.")
	   frm.txtDatamatricula.focus()
	   return false;
   }

   if (frm.txtDataNascimento.value==""){
	   alert("A Data de Nascimento deve ser informada.")
	   frm.txtDataNascimento.focus()
	   return false;
   }

   if (frm.cmbSexo.value=="0"){
	   alert("O Sexo deve ser informado.")
	   frm.cmbSexo.focus()
	   return false;
   }

   if (frm.txtCidadenascimento.value==""){
	   alert("A Naturalidade do Aluno deve ser informada.")
	   frm.txtCidadenascimento.focus()
	   return false;
   }
   
   if (frm.cmbTipoNacionalidade.value!="3"){
	   
	   if (frm.cmbUfnascimento.value=="0"){
		   alert("O UF da Naturalidade deve ser informada.")
		   frm.cmbUfnascimento.focus()
		   return false;
	   }
	   
   }

   if (frm.cmbNacionalidade.value=="0"){
	   alert("A Nacionalidade deve ser informada.")
	   frm.cmbUfnascimento.focus()
	   return false;
   }

   if (frm.cmbTipoNacionalidade.value=="0"){
	   alert("A Origem da Nacionalidade deve ser informada.")
	   frm.cmbTipoNacionalidade.focus()
	   return false;
   }

   if (frm.cmbProfissao.value=="0"){
	   alert("A Profissão deve ser informada.")
	   frm.cmbProfissao.focus()
	   return false;
   }

   if (frm.cmbEtnia.value=="0"){
	   alert("A Etnia deve ser informada.")
	   frm.cmbEtnia.focus()
	   return false;
   }
   
   //bolsa familia
   if (frm.txtBolsaFamiliaAnterior.value!="") {
	   if ((frm.txtBolsaFamilia.value=="")){
		   alert("O númerio do cartão do bolsa família deve ser preenchido.")
		   frm.txtBolsaFamilia.focus()
		   return false;
	   }
   }
   
   if ((frm.txtFoneResidencial.value=="") && (frm.txtFonecelular.value=="")){
	   alert("Pelo menos um telefone de contato deve ser informado.")
	   frm.txtFoneResidencial.focus()
	   return false;
   }

   if (frm.txtMae.value==""){
	   alert("O Nome da Mãe deve ser informado.")
	   frm.txtMae.focus()
	   return false;
   }
   
   if (frm.cmbTurma.value == "0"){
	   alert("A turma do aluno deve ser informada.");
	   //mostraDadosEscolares.style.display="table-row"
	   
	   frm.cmbTurma.focus();
	   return false;
   }
   
   frm.action="sca_renovacao_aluno.asp";
   frm.submit();
   return true;
}


// Validação CNS
function validaCNS(vlrCNS) {
   if (vlrCNS.value!="") {
	   if ( (vlrCNS.substring(0,1) != "7")  && (vlrCNS.substring(0,1) != "8") && (vlrCNS.substring(0,1) != "9") )
		  {
		   // Formulário que contem o campo CNS
		   var soma = new Number;
		   var resto = new Number;
		   var dv = new Number;
		   var pis = new String;
		   var resultado = new String;
		   var tamCNS = vlrCNS.length;
		   if ((tamCNS) != 15) {
			   alert("Numero de CNS invalido...");
			   frm.txtCartaoSUS.value="";
			   return false;
		   }
		   pis = vlrCNS.substring(0,11);
		   soma = (((Number(pis.substring(0,1))) * 15) +   
				   ((Number(pis.substring(1,2))) * 14) +
				   ((Number(pis.substring(2,3))) * 13) +
				   ((Number(pis.substring(3,4))) * 12) +
				   ((Number(pis.substring(4,5))) * 11) +
				   ((Number(pis.substring(5,6))) * 10) +
				   ((Number(pis.substring(6,7))) * 9) +
				   ((Number(pis.substring(7,8))) * 8) +
				   ((Number(pis.substring(8,9))) * 7) +
				   ((Number(pis.substring(9,10))) * 6) +
				   ((Number(pis.substring(10,11))) * 5));
		   resto = soma % 11;
		   dv = 11 - resto;
		   if (dv == 11) {
			   dv = 0;
		   }
		   if (dv == 10) {
			   soma = (((Number(pis.substring(0,1))) * 15) +   
					   ((Number(pis.substring(1,2))) * 14) +
					   ((Number(pis.substring(2,3))) * 13) +
					   ((Number(pis.substring(3,4))) * 12) +
					   ((Number(pis.substring(4,5))) * 11) +
					   ((Number(pis.substring(5,6))) * 10) +
					   ((Number(pis.substring(6,7))) * 9) +
					   ((Number(pis.substring(7,8))) * 8) +
					   ((Number(pis.substring(8,9))) * 7) +
					   ((Number(pis.substring(9,10))) * 6) +
					   ((Number(pis.substring(10,11))) * 5) + 2);
			   resto = soma % 11;
			   dv = 11 - resto;
			   resultado = pis + "001" + String(dv);
		   } else { 
			   resultado = pis + "000" + String(dv);
		   }
		   if (vlrCNS != resultado) {
			   alert("Numero de CNS invalido.");
			   frm.txtCartaoSUS.value="";
			   return false;
		   } 
	   } else {
		   var pis;
		   var resto;
		   var dv;
		   var soma;
		   var resultado;
		   var result;
		   result = 0;
	   
		   pis = vlrCNS.substring(0,15);
	   
		   if (pis == "")
			  {
				 return false
			  }
			   
		   if ( (vlrCNS.substring(0,1) != "7")  && (vlrCNS.substring(0,1) != "8") && (vlrCNS.substring(0,1) != "9") )
			  {
					 alert("Atenção! Número Provisório inválido!");
					 return false
			  }
		
		   soma = (   (parseInt(pis.substring( 0, 1),10)) * 15)
				   + ((parseInt(pis.substring( 1, 2),10)) * 14)
				   + ((parseInt(pis.substring( 2, 3),10)) * 13)
				   + ((parseInt(pis.substring( 3, 4),10)) * 12)
				   + ((parseInt(pis.substring( 4, 5),10)) * 11)
				   + ((parseInt(pis.substring( 5, 6),10)) * 10)
				   + ((parseInt(pis.substring( 6, 7),10)) * 9)
				   + ((parseInt(pis.substring( 7, 8),10)) * 8)
				   + ((parseInt(pis.substring( 8, 9),10)) * 7)
				   + ((parseInt(pis.substring( 9,10),10)) * 6)
				   + ((parseInt(pis.substring(10,11),10)) * 5)
				   + ((parseInt(pis.substring(11,12),10)) * 4)
				   + ((parseInt(pis.substring(12,13),10)) * 3)
				   + ((parseInt(pis.substring(13,14),10)) * 2)
				   + ((parseInt(pis.substring(14,15),10)) * 1);
	   
		   resto = soma % 11;
		   
		   if (resto == 0)
			  {
				return true;
			  }
		   else
			  {
				alert("Atenção! Número Provisório inválido!");
				return false;  
			  }   
	   }
   }
}

function AlunoDocumentacoes(codAluno){
   if (codAluno == ""){
	   alert("O aluno deve ser informado.")
	   return false;		
   }else{
   
   frm.action = "sca_documentacao_aluno.asp";
   frm.submit();		
   }
}

function abreEditorFoto() {
   $("#modalEditorFoto").modal('show');
}

function limparFoto() {
    $("#txtFotoAlunoHidden").val("");
    $("#divFoto").html("<img src='img/aluno-sem-foto.jpg' style='border:1px solid #999999; width:120px; height:170px;'>");

}