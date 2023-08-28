var selectPage = "Prender";
var reversePage = "Prender";
/* ---------------------------------------------------------------------------------------------------------------- */
$(document).ready(function(){
	functionPrender();

	window.addEventListener("message",function(event){
		switch (event["data"]["action"]){
			case "openSystem":
				$("#mainPage").css("display","block");
			break;

			case "closeSystem":
				$("#mainPage").css("display","none");
			break;

			case "reloadPrison":
				functionPrender();
			break;

			case "reloadFine":
				functionMultar();
			break;

			case "reloadSearch":
				functionSearch(event["data"]["data"]);
			break;
		};
	});

	document.onkeyup = function(data){
		if (data["which"] == 27){
			$.post("http://police/closeSystem");
		};
	};
});
/* ---------------------------------------------------------------------------------------------------------------- */
$(document).on("click","#mainMenu li",function(){
	if (selectPage != reversePage){
		let isActive = $(this).hasClass('active');
		$('#mainMenu li').removeClass('active');
		if (!isActive){
			$(this).addClass('active');
			reversePage = selectPage;

			$("#content").css("height","414px");
			$("#content").css("margin","76px 30px 30px 30px");
		};
	};
});
/* ----------FUNCTIONSEARCH---------- */
const functionSearch = (passaporte) => {
	if (passaporte != ""){
		$.post("http://police/searchUser",JSON.stringify({ passaporte: parseInt(passaporte) }),(data) => {
			if(data["result"][0] == true){
				$('#content').html(`
					<div id="titleContent">${data["result"][1]}</div>
					<div id="pageLeftSearch">
						<div class="searchBox">
							<b>Passaporte:</b> ${formatarNumero(passaporte)}<br>
							<b>Nome:</b> ${data["result"][1]}<br>
							<b>Serial:</b> ${data["result"][6]}<br>
							<b>Telefone:</b> ${data["result"][2]}<br>
							<b>Multas:</b> $${formatarNumero(data["result"][3])}<br>
							<b>Porte:</b> ${data["result"][5] == 0 ? "Não":"Sim"} <update id="portSearch" data-id="${passaporte}">Atualizar</update><br>
							<b>Penal:</b> ${data["result"][7] == 0 ? "Não":"Sim"} <update id="penalSearch" data-id="${passaporte}">Atualizar</update>
						</div>

						${data["result"][4].map((data) => (`
							<div class="recordBox">
								<div class="fineSeachTitle">
									<span style="width: 250px; float: left;"><b>Policial:</b> ${data["police"]}</span>
									<span style="width: 125px; float: left;"><b>Serviços:</b> ${formatarNumero(data["services"])}</span>
									<span style="width: 110px; float: left;"><b>Multa:</b> $${formatarNumero(data["fines"])}</span>
									<span style="width: 150px; float: right; text-align: right;">${data["date"]}</span>
								</div>
								${data["text"]}
							</div>
						`)).join('')}
					</div>

					<div id="pageRight">
						<h2>OBSERVAÇÕES:</h2>
						<b>1:</b> Todas as informações encontradas são de uso exclusivo policial, tudo que for encontrado na mesma são informações em tempo real.<br><br>
						<b>2:</b> Nunca forneça qualquer informação dessa página para outra pessoa, apenas se a mesma for o proprietário ou o advogado do mesmo.
					</div>
				`);
			} else {
				$('#content').html(`
					<div id="titleContent">RESULTADO</div>
					Não foi encontrado informações sobre o passaporte procurado.
				`);
			}
		});
	}
}
/* ----------BUTTONSEARCH---------- */
$(document).on("click",".buttonSearch",function(e){
	const passaporte = $('#searchPassaporte').val();
	functionSearch(passaporte);
});
/* ----------CLICKBUY---------- */
$(document).on("click","#portSearch",function(e){
	$.post("http://police/updatePort",JSON.stringify({ passaporte: e["target"]["dataset"]["id"] }));
});
/* ----------CLICKBUY---------- */
$(document).on("click","#penalSearch",function(e){
	$.post("http://police/updatePenal",JSON.stringify({ passaporte: e["target"]["dataset"]["id"] }));
});
/* ---------------------------------------------------------------------------------------------------------------- */
const functionPrender = () => {
	selectPage = "Prender";

	$('#content').html(`
		<div id="titleContent">PRENDER</div>
		<div id="pageLeft">
			<input class="inputPrison" id="prenderPassaporte" type="number" onKeyPress="if(this.value.length==5) return false;" value="" placeholder="Passaporte."></input>
			<input class="inputPrison" id="prenderServices" type="number" onKeyPress="if(this.value.length==5) return false;" value="" placeholder="Serviços."></input>
			<input class="inputPrison2" id="prenderMultas" type="number" onKeyPress="if(this.value.length==7) return false;" value="" placeholder="Valor da multa."></input>
			<textarea class="textareaPrison" maxlength="500" id="prenderTexto" value="" placeholder="Todas as informações dos crimes."></textarea>
			<button class="buttonPrison">Prender</button>
		</div>

		<div id="pageRight">
			<h2>OBSERVAÇÕES:</h2>
			<b>1:</b> Antes de enviar o formulário verifique corretamente se todas as informações estão de acordo com o crime efetuado, você é responsável por todas as informações enviadas e salvas no sistema.<br><br>
			<b>2:</b> Ao preencher o campo de multas, verifique se o valor está correto, após enviar o formulário não será possível alterar ou remover a multa enviada.<br><br>
			<b>3:</b> Todas as prisões são salvas no sistema após o envio, então lembre-se que cada formulário enviado, o valor das multas, serviços e afins são somados com a ultima prisão caso o mesmo ainda esteja preso.
		</div>
	`);
};
/* ----------BUTTONPRISON---------- */
$(document).on("click",".buttonPrison",function(e){
	const passaporte = $('#prenderPassaporte').val()
	const servicos = $('#prenderServices').val()
	const multas = $('#prenderMultas').val()
	const texto = $('#prenderTexto').val()

	if (passaporte != "" && servicos != "" && multas != "" && texto != ""){
		$.post("http://police/initPrison",JSON.stringify({
			passaporte: parseInt(passaporte),
			servicos: parseInt(servicos),
			multas: parseInt(multas),
			texto: texto
		}));
	}
});
/* ---------------------------------------------------------------------------------------------------------------- */
const functionMultar = () => {
	selectPage = "Multar";

	$('#content').html(`
		<div id="titleContent">MULTAR</div>
		<div id="pageLeft">
			<input class="inputFine" id="multarPassaporte" type="number" onKeyPress="if(this.value.length==5) return false;" value="" placeholder="Passaporte."></input>
			<input class="inputFine2" id="multarMultas" type="number" onKeyPress="if(this.value.length==7) return false;" value="" placeholder="Valor da multa."></input>
			<textarea class="textareaFine" id="multarTexto" maxlength="500" value="" placeholder="Todas as informações da multa."></textarea>
			<button class="buttonFine">Multar</button>
		</div>

		<div id="pageRight">
			<h2>OBSERVAÇÕES:</h2>
			<b>1:</b> Antes de enviar o formulário verifique corretamente se todas as informações estão de acordo com a multa, você é responsável por todas as informações enviadas e salvas no sistema.<br><br>
			<b>2:</b> Ao preencher o campo de multas, verifique se o valor está correto, após enviar o formulário não será possível alterar ou remover a multa enviada.<br><br>
		</div>
	`);
};
/* ---------------------------------------------------------------------------------------------------------------- */
const functionPenal = () => {
	selectPage = "Penal";

	$('#content').html(`
	<div id='penalTitle01'>CRIMES</div>
	<div id='penalTitle02'>SERVIÇOS</div>
	<div id='penalTitle03'>MULTAS</div>
	<div id='penalTitle04'>OBSERVAÇÕES</div>

	<div id='penalContent01' class='black'>Ameaça</div>
	<div id='penalContent02' class='black'>10</div>
	<div id='penalContent03' class='black'>$1.500</div>
	<div id='penalContent04' class='black'>Ameaçar alguém por palavra, escrito ou gesto.</div>

	<div id='penalContent01' class='white'>Assalto a Cívil</div>
	<div id='penalContent02' class='white'>20</div>
	<div id='penalContent03' class='white'>$10.000</div>
	<div id='penalContent04' class='white'>Subtrair posses alheias, para si ou para outrem, mediante grave ameaça ou violência.</div>

	<div id='penalContent01' class='black'>Associação criminosa</div>
	<div id='penalContent02' class='black'>15</div>
	<div id='penalContent03' class='black'>$2.500</div>
	<div id='penalContent04' class='black'>Associarem-se 3 ou mais pessoas, para fim específico de cometer crimes.</div>

	<div id='penalContent01' class='white'>Corridas ilegais</div>
	<div id='penalContent02' class='white'>10</div>
	<div id='penalContent03' class='white'>$2.000</div>
	<div id='penalContent04' class='white'>Participar de corridas clandestinas.</div>

	<div id='penalContent01' class='black'>Conspiração</div>
	<div id='penalContent02' class='black'>10</div>
	<div id='penalContent03' class='black'>$1.000</div>
	<div id='penalContent04' class='black'>Planejar atividade ilegal.</div>

	<div id='penalContent01' class='white'>Corrupção</div>
	<div id='penalContent02' class='white'>50</div>
	<div id='penalContent03' class='white'>$50.000</div>
	<div id='penalContent04' class='white'>Solicitar, receber, obter ou utilizar para si ou para outrem, diretamente ou indiretamente.</div>

	<div id='penalContent01' class='black'>Comportamento Indisciplinar</div>
	<div id='penalContent02' class='black'>5</div>
	<div id='penalContent03' class='black'>$5.000</div>
	<div id='penalContent04' class='black'>Se comportar indevidamente com base no seu emprego.</div>

	<div id='penalContent01' class='white'>Dano ao Patrimônio</div>
	<div id='penalContent02' class='white'>10</div>
	<div id='penalContent03' class='white'>$1.500</div>
	<div id='penalContent04' class='white'>Danificar o bem de outra pessoa ou do estado.</div>

	<div id='penalContent01' class='black'>Denuncia caluniosa</div>
	<div id='penalContent02' class='black'>10</div>
	<div id='penalContent03' class='black'>$5.000</div>
	<div id='penalContent04' class='black'>Dar causa à instauração de investigação policial de processo judicial.</div>

	<div id='penalContent01' class='white'>Desacato</div>
	<div id='penalContent02' class='white'>10 + 5</div>
	<div id='penalContent03' class='white'>$2.000</div>
	<div id='penalContent04' class='white'>Desacatar funcionário público no exercício de sua função ou em razão dela.</div>

	<div id='penalContent01' class='black'>Desobediência</div>
	<div id='penalContent02' class='black'>20 + 5</div>
	<div id='penalContent03' class='black'>$5.000</div>
	<div id='penalContent04' class='black'>Desobedecer ordem de funcionário público.</div>

	<div id='penalContent01' class='white'>Dinheiro Ilícito</div>
	<div id='penalContent02' class='white'>5 / $20.000 CÉDULAS</div>
	<div id='penalContent03' class='white'>1.500</div>
	<div id='penalContent04' class='white'>Em roubos de grande porte a pena é dobrada.</div>

	<div id='penalContent01' class='black'>Estelionato</div>
	<div id='penalContent02' class='black'>15</div>
	<div id='penalContent03' class='black'>$3.000</div>
	<div id='penalContent04' class='black'>Obter para si ou para outrem vantagem ilícita em prejuízo alheio.</div>

	<div id='penalContent01' class='white'>Extorsão</div>
	<div id='penalContent02' class='white'>20</div>
	<div id='penalContent03' class='white'>$3.000</div>
	<div id='penalContent04' class='white'>Obrigar a tomar um determinado comportamento por meio de ameaça ou violência.</div>

	<div id='penalContent01' class='black'>Falsa Identidade</div>
	<div id='penalContent02' class='black'>25</div>
	<div id='penalContent03' class='black'>$5.000</div>
	<div id='penalContent04' class='black'>Atribuir-se ou atribuir a terceiro para obter vantagem em proveito próprio ou alheio.</div>

	<div id='penalContent01' class='white'>Falsidade ideologica</div>
	<div id='penalContent02' class='white'>25</div>
	<div id='penalContent03' class='white'>$10.000</div>
	<div id='penalContent04' class='white'>Atribuir à si ou a terceiros falsa identidade para obter vantagem em proveito alheio.</div>

	<div id='penalContent01' class='black'>Falso testemunho</div>
	<div id='penalContent02' class='black'>10</div>
	<div id='penalContent03' class='black'>$2.000</div>
	<div id='penalContent04' class='black'>Fazer afirmação falsa, negar ou calar a verdade.</div>

	<div id='penalContent01' class='white'>Fraude</div>
	<div id='penalContent02' class='white'>5</div>
	<div id='penalContent03' class='white'>$1.000</div>
	<div id='penalContent04' class='white'>Mentorar ou participar de esquema ilícito ou de má-fé visando obter vantagens.</div>

	<div id='penalContent01' class='black'>Fuga</div>
	<div id='penalContent02' class='black'>15</div>
	<div id='penalContent03' class='black'>$1.500</div>
	<div id='penalContent04' class='black'>Evadir-se da polícia.</div>

	<div id='penalContent01' class='white'>Furto</div>
	<div id='penalContent02' class='white'>12</div>
	<div id='penalContent03' class='white'>$1.000</div>
	<div id='penalContent04' class='white'>Subtrair, para si ou para outrem coisa móvel alheia.</div>

	<div id='penalContent01' class='black'>Injúria</div>
	<div id='penalContent02' class='black'>15</div>
	<div id='penalContent03' class='black'>$3.000</div>
	<div id='penalContent04' class='black'>Injuriar alguém, ofendendo-lhe a dignidade ou o decoro.</div>

	<div id='penalContent01' class='white'>Invasão</div>
	<div id='penalContent02' class='white'>15</div>
	<div id='penalContent03' class='white'>$1.000</div>
	<div id='penalContent04' class='white'>Invadir áreas privadas, ou públicas de acesso restrito.</div>

	<div id='penalContent01' class='black'>Latrocínio</div>
	<div id='penalContent02' class='black'>35</div>
	<div id='penalContent03' class='black'>$6.000</div>
	<div id='penalContent04' class='black'>Roubo seguido de morte.</div>

	<div id='penalContent01' class='white'>Lesão corporal</div>
	<div id='penalContent02' class='white'>10</div>
	<div id='penalContent03' class='white'>$2.000</div>
	<div id='penalContent04' class='white'>Ofender a integridade corporal ou a saúde de outrem.</div>

	<div id='penalContent01' class='black'>Multas não pagas</div>
	<div id='penalContent02' class='black'>4 / $1.000</div>
	<div id='penalContent03' class='black'>0</div>
	<div id='penalContent04' class='black'>Multas com atrasao de 24 horas no pagamento.</div>

	<div id='penalContent01' class='white'>Objetos roubados</div>
	<div id='penalContent02' class='white'>10</div>
	<div id='penalContent03' class='white'>$2.000</div>
	<div id='penalContent04' class='white'>Objetos subtraidos através de roubos.</div>

	<div id='penalContent01' class='black'>Obstrução da justiça</div>
	<div id='penalContent02' class='black'>15</div>
	<div id='penalContent03' class='black'>$3.000</div>
	<div id='penalContent04' class='black'>Cometer o impedimento ou qualquer forma que atrapalhe a investigação.</div>

	<div id='penalContent01' class='white'>Ocultação Facial</div>
	<div id='penalContent02' class='white'>15</div>
	<div id='penalContent03' class='white'>$15.000</div>
	<div id='penalContent04' class='white'>Utilização de adornos ou acessórios que ocultem totalmente ou parcialmente a face.</div>

	<div id='penalContent01' class='black'>Omissão de socorro</div>
	<div id='penalContent02' class='black'>10</div>
	<div id='penalContent03' class='black'>$2.000</div>
	<div id='penalContent04' class='black'>Deixar de prestar assistência, quando possível fazê-lo sem risco pessoal ou ferida.</div>

	<div id='penalContent01' class='white'>Perseguição</div>
	<div id='penalContent02' class='white'>20</div>
	<div id='penalContent03' class='white'>$2.000</div>
	<div id='penalContent04' class='white'>Seguir alguém, perseguir ou qualquer coisa do genero.</div>

	<div id='penalContent01' class='black'>Porte/Posse ilegal de armas classe 1</div>
	<div id='penalContent02' class='black'>20</div>
	<div id='penalContent03' class='black'>$5.000</div>
	<div id='penalContent04' class='black'>Porte / Posse ilegal de armas semi-automáticas.</div>

	<div id='penalContent01' class='white'>Porte/Posse ilegal de armas classe 2</div>
	<div id='penalContent02' class='white'>25</div>
	<div id='penalContent03' class='white'>$6.000</div>
	<div id='penalContent04' class='white'>Porte / Posse ilegal de armas automáticas.</div>

	<div id='penalContent01' class='black'>Produtos Ilícitos</div>
	<div id='penalContent02' class='black'>10</div>
	<div id='penalContent03' class='black'>$1.300</div>
	<div id='penalContent04' class='black'>Produto adquirido por roubos ou utilizado para crimes.</div>

	<div id='penalContent01' class='white'>Receptação</div>
	<div id='penalContent02' class='white'>10</div>
	<div id='penalContent03' class='white'>1.500</div>
	<div id='penalContent04' class='white'>Receptar, em proveito próprio ou alheio, coisa que se saiba ser produto de crime.</div>

	<div id='penalContent01' class='black'>Resistência</div>
	<div id='penalContent02' class='black'>15</div>
	<div id='penalContent03' class='black'>2.000</div>
	<div id='penalContent04' class='black'>Opor-se à execução de ato legal, mediante violência ou ameaça ao funcionário.</div>

	<div id='penalContent01' class='white'>Roubo</div>
	<div id='penalContent02' class='white'>10</div>
	<div id='penalContent03' class='white'>$3.000</div>
	<div id='penalContent04' class='white'>Subtrair posses alheias, para si ou para outrem, mediante grave ameaça ou violência.</div>

	<div id='penalContent01' class='black'>Roupas policiais</div>
	<div id='penalContent02' class='black'>30</div>
	<div id='penalContent03' class='black'>$10.000</div>
	<div id='penalContent04' class='black'>Utilizar qualquer utilitário exclusivo policial.</div>

	<div id='penalContent01' class='white'>Sequestro</div>
	<div id='penalContent02' class='white'>15</div>
	<div id='penalContent03' class='white'>$5.000</div>
	<div id='penalContent04' class='white'>Privar alguém de sua liberdade mediante sequestro ou cárcere privado.</div>

	<div id='penalContent01' class='black'>Suborno</div>
	<div id='penalContent02' class='black'>15</div>
	<div id='penalContent03' class='black'>$2.000</div>
	<div id='penalContent04' class='black'>Oferecer ou prometer vantagem indevida a funcionário público.</div>

	<div id='penalContent01' class='white'>Tentativa / Homicídio</div>
	<div id='penalContent02' class='white'>20 + 5</div>
	<div id='penalContent03' class='white'>$2.500</div>
	<div id='penalContent04' class='white'>Quando o suspeito quis o resultado e assumiu o risco de produzí-lo.</div>

	<div id='penalContent01' class='black'>Tentativa / Homicídio Oficial</div>
	<div id='penalContent02' class='black'>25 + 5</div>
	<div id='penalContent03' class='black'>$3.000</div>
	<div id='penalContent04' class='black'>Quando o suspeito quis o resultado e assumiu o risco de produzí-lo em um oficial do governo.</div>

	<div id='penalContent01' class='white'>Terrorismo</div>
	<div id='penalContent02' class='white'>50</div>
	<div id='penalContent03' class='white'>$20.000</div>
	<div id='penalContent04' class='white'>Cuja violência ilegítima passa a denominar-se terror.</div>

	<div id='penalContent01' class='black'>Tráfico</div>
    <div id='penalContent02' class='black'>1 a cada 5 drogas</div>
    <div id='penalContent03' class='black'>$2.000</div>
	<div id='penalContent04' class='black'></div>

	<div id="divContent"></div>

	<div id='penalTitle01'>INFRAÇÕES</div>
	<div id='penalTitle02'>SERVIÇOS</div>
	<div id='penalTitle03'>MULTAS</div>
	<div id='penalTitle04'>OBSERVAÇÕES</div>

	<div id='penalContent01' class='white'>Alta velocidade</div>
	<div id='penalContent02' class='white'>0</div>
	<div id='penalContent03' class='white'>$1.000</div>
	<div id='penalContent04' class='white'>Aumenta $300 dólares a cada 10mph.</div>

	<div id='penalContent01' class='black'>Direção imprudente</div>
	<div id='penalContent02' class='black'>0</div>
	<div id='penalContent03' class='black'>$1.000</div>
	<div id='penalContent04' class='black'>Conduta imprudente no transito utilizando um caminhão ou ônibus.</div>

	<div id='penalContent01' class='white'>Direção perigosa</div>
	<div id='penalContent02' class='white'>0</div>
	<div id='penalContent03' class='white'>$1.000</div>
	<div id='penalContent04' class='white'>Uso negligente ou imprudente de um veículo.</div>

	<div id='penalContent01' class='black'>Estacionar em local proibido</div>
	<div id='penalContent02' class='black'>0</div>
	<div id='penalContent03' class='black'>$10.000</div>
	<div id='penalContent04' class='black'>Deixar o veículo em local indevido.</div>

	<div id='penalContent01' class='white'>Pousar em local proibido ou sem designação</div>
	<div id='penalContent02' class='white'>0</div>
	<div id='penalContent03' class='white'>$5.000</div>
	<div id='penalContent04' class='white'>Pousar veículos aéreos fora de locais adequados e seguros.</div>

	<div id='penalContent01' class='black'>Veículo abandonado</div>
	<div id='penalContent02' class='black'>0</div>
	<div id='penalContent03' class='black'>$2.000</div>
	<div id='penalContent04' class='black'>Abandonar veículo em local indevido.</div>

	<div id="divContent"></div>

	<div id='titleContent'>OBSERVAÇÕES GERAIS</div>
	<div id='pageContent'>
		<b>1:</b> Posse legal de drogas é até 5 unidades, passando da quantidade legal o mesmo é indiciado pelo crime de receptação.<br>
		<b>2:</b> Veículos são apreendidos quando o condutor ou passageiro atenta contra a vida de um cidadão utilizando uma arma de fogo ou quando o veículo é jogado dentro do mar propositalmente.<br>
		<b>3:</b> Cada serviço pode ser convertido em $2.000 dólares, crimes que atentam contra a vida de outro cidadão não estão sujeitas a fiança.<br>
		<b>4:</b> Não há crime de cumplicidade, as pessoas que colaboram diretamente ou indiretamente para o crime receberão a mesma pena.<br>
		<b>5:</b> Conversas entre suspeitos e advogados são confidenciais, dê uma distância respeitosa para que os mesmos conversem sem interrupções.<br>
		<b>6:</b> Limite de velocidade dentro da cidade é de <b>90 mph</b>, veículos de grande porte o limite de velocidade é de <s>60mph</s>.
	</div>
`);
};
/* ----------BUTTONFINE---------- */
$(document).on("click",".buttonFine",function(e){
	const passaporte = $('#multarPassaporte').val()
	const multas = $('#multarMultas').val()
	const texto = $('#multarTexto').val()

	if (passaporte != "" != "" && multas != "" && texto != ""){
		$.post("http://police/initFine",JSON.stringify({
			passaporte: parseInt(passaporte),
			multas: parseInt(multas),
			texto: texto
		}));
	}
});
/* ----------FORMATARNUMERO---------- */
const formatarNumero = (n) => {
	var n = n.toString();
	var r = '';
	var x = 0;

	for (var i = n.length; i > 0; i--) {
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? '.' : '');
		x = x == 2 ? 0 : x + 1;
	}

	return r.split('').reverse().join('');
}