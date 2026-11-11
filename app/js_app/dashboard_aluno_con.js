vetColor = [];

$(document).ready(function () {

    vetColor.push("#FF4069");
    vetColor.push("#FFCD56");
    vetColor.push("#36A2EB");
    vetColor.push("#00ACAC");
    vetColor.push("#da6c39");
    vetColor.push("#da6c39");

	graficoPorModalidade();

    graficoAlunos();

});



function graficoPorModalidade () {

	$.get("dashboard_aluno_cod.asp", { acao: "porModalidade" }, function (data, status) {


		objJson = JSON.parse(data);

		vetModalidade = [];
		vetAluno = [];
        vetBackGround = [];



		var modalidade = "";
		for (var i = 0; i < objJson.length; i++) {
			if (modalidade !== objJson[i].descricao.trim()) {
				modalidade = objJson[i].descricao.trim();
				vetModalidade.push(modalidade)
                vetAluno.push(objJson[i].qtde)
                vetBackGround.push(vetColor[i])
			}
		}

		var color = Chart.helpers.color;
		var barChartData = {
			labels: vetModalidade,
			datasets: [{
				label: 'Quantidade de alunos por modalidade',
				backgroundColor: vetBackGround,
				borderColor: '#ffffff',
				borderWidth: 1,
				data: vetAluno
			}]

		};

		var ctx = document.getElementById('porModalidade').getContext('2d');
		window.myBar = new Chart(ctx, {
			type: 'bar',
			data: barChartData,
			options: {
				responsive: true,
				legend: {
					position: 'top',
				},
				title: {
					display: true,
					text: 'Por Modalidade de Ensino'
				}
			}
		});

	});

}

function graficoAlunos() {

    $.get("dashboard_aluno_cod.asp", { acao: "qtde" }, function (data, status) {


		objJson = JSON.parse(data);

        $("#qtdeAtendEsp").html(objJson[0].atendimentoEspecial)
        $("#qtdeDeficiencia").html(objJson[0].deficiencia)
        $("#qtdeTransporte").html(objJson[0].transporteEscolar)
		
	});    

}