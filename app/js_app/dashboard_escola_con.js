//vetColor = [];

$(document).ready(function () {

    // vetColor.push("#FF4069");
    // vetColor.push("#FFCD56");
    // vetColor.push("#36A2EB");
    // vetColor.push("#00ACAC");
    // vetColor.push("#da6c39");
    // vetColor.push("#da6c39");

    // vetColor.push("#FF4070");
    // vetColor.push("#FFCD57");
    // vetColor.push("#36A2EC");
    // vetColor.push("#00ACAD");
    // vetColor.push("#da6c40");

    // vetColor.push("#FF4071");
    // vetColor.push("#FFCD58");
    // vetColor.push("#36A2ED");
    // vetColor.push("#00ACAE");
    // vetColor.push("#da6c41");    

    // vetColor.push("#FF4072");
    // vetColor.push("#FFCD59");
    // vetColor.push("#36A2EE");
    // vetColor.push("#00ACAF");
    // vetColor.push("#da6c42");       
    
    

	// graficoVagas();
    graficoEscolas();
});



// function graficoVagas () {

// 	$.get("dashboard_escola_cod.asp", { acao: "vagas" }, function (data, status) {


// 		objJson = JSON.parse(data);

// 		vetVaga = [];
// 		vetQtde = [];
//         vetBackGround = [];
        
//         vetVaga.push("Capacidade total")
//         vetVaga.push("Vagas disponíveis")

//         vetQtde.push(objJson[0].capacidadeTotalVagas)
//         vetQtde.push(objJson[0].vagasDisponiveis)

//         vetBackGround.push(vetColor[0])
//         vetBackGround.push(vetColor[1])

// 		var barChartData = {
// 			labels: vetVaga,
// 			datasets: [{
// 				label: 'Controle de Vagas',
// 				backgroundColor: vetBackGround,
// 				borderColor: '#ffffff',
// 				borderWidth: 1,
// 				data: vetQtde
// 			}]

// 		};

// 		var ctx = document.getElementById('vagas').getContext('2d');
// 		window.myBar = new Chart(ctx, {
// 			type: 'doughnut',
// 			data: barChartData,
// 			options: {
// 				responsive: true,
// 				legend: {
// 					position: 'top',
// 				},
// 				title: {
// 					display: true,
// 					text: 'Por cargo'
// 				}
// 			}
// 		});

// 	});

// }

function graficoEscolas() {

    $.get("dashboard_escola_cod.asp", { acao: "escolas" }, function (data, status) {

		objJson = JSON.parse(data);

        $("#qtdeEscolas").html(totalEscolas(objJson))
        $("#qtdeEscolasMunicipais").html(totalEscolasMunicipais(objJson))
        $("#qtdeEscolasConveniadas").html(totalEscolasConveniadas(objJson))
		
		
		$("#qtdeCMEI").html(totalCMEI(objJson))
		$("#qtdeEMEI").html(totalEMEI(objJson))
		
		$("#qtdeEMEI_CMEI").html(totalEscolasMunicipais(objJson) - totalCMEI(objJson) - totalEMEI(objJson))
	});    

}

// Função que retorna o total de escolas
const totalEscolas = (dados) => {
	return dados.reduce((acc, escola) => acc + escola.escolas, 0);
  };
  
  // Função que retorna o total de escolas municipais (exceto cod_tipo_escola = 3)
  const totalEscolasMunicipais = (dados) => {
	return dados
	  .filter(escola => escola.cod_tipo_escola !== 3)
	  .reduce((acc, escola) => acc + escola.escolas, 0);
  };
  
  // Função que retorna o total de escolas conveniadas (cod_tipo_escola = 3)
  const totalEscolasConveniadas = (dados) => {
	return dados
	  .filter(escola => escola.cod_tipo_escola === 3)
	  .reduce((acc, escola) => acc + escola.escolas, 0);
  };
  
  // Função que retorna o total de escolas conveniadas (cod_tipo_escola = 3)
  const totalCMEI = (dados) => {
	return dados
	  .filter(escola => escola.cod_tipo_escola === 1)
	  .reduce((acc, escola) => acc + escola.escolas, 0);
  };
  
  // Função que retorna o total de escolas conveniadas (cod_tipo_escola = 3)
  const totalEMEI = (dados) => {
	return dados
	  .filter(escola => escola.cod_tipo_escola === 4)
	  .reduce((acc, escola) => acc + escola.escolas, 0);
  };
  
  
  