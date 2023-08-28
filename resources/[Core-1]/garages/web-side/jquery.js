$(document).ready(function () {
	window.addEventListener("message", function (event) {
		switch (event.data.action) {
			case "openNUI":
				updateGarages();
				$("#displayHud").css("display", "block");
				break;

			case "closeNUI":
				$("#displayHud").css("display", "none");
				break;
		}
	});

	document.onkeyup = function (data) {
		if (data.which == 27) {
			$.post("http://garages/close");
		}
	};
});
/* --------------------------------------------------- */
const updateGarages = () => {
	$.post("http://garages/myVehicles", JSON.stringify({}), (data) => {
		const nameList = data.vehicles.sort((a, b) => (a.name2 > b.name2) ? 1 : -1);
		$("#displayHud").html(`
		<div id="buttons">
		<div class="spawnButtons" id="spawnVehicle"><b>Retirar</b>Veículo selecionado.</div>
		<div class="spawnButtons" id="storeVehicle"><b>Guardar</b>Veículo próximo.</div>
		</div>

			<div id="vehList">
				${nameList.map((item) => (`
				<div class="vehicle" data-name="${item.name}">
				<div id="vehicleName">${item.name2}</div>

				<div>
					<img src="http://131.196.196.167/garages/${item.name}.png"
						style="width: 100%; height: 9vw; object-fit: cover;">

					<div class="vehStatus">
						<div id="vehicleLegend">Motor:</div>
						<div id="vehicleBack">
							<div id="vehicleProgress" style="width: ${item.engine}%;"></div>
						</div>
					</div>
					<div class="vehStatus">
						<div id="vehicleLegend">Chassi:</div>
						<div id="vehicleBack">
							<div id="vehicleProgress" style="width: ${item.body}%;"></div>
						</div>
					</div>
					<div class="vehStatus">
						<div id="vehicleLegend">Gasolina:</div>
						<div id="vehicleBack">
							<div id="vehicleProgress" style="width: ${item.fuel}%;"></div>
						</div>
					</div>
				</div>
			</div>
				`)).join("")}
			</div>
		`);
	});
}
/* --------------------------------------------------- */
$(document).on("click", ".vehicle", function () {
	let $el = $(this);
	let isActive = $el.hasClass("active");
	$(".vehicle").removeClass("active");
	if (!isActive) $el.addClass("active");
});
/* --------------------------------------------------- */
$(document).on("click", "#spawnVehicle", debounce(function () {
	let $el = $(".vehicle.active").attr("data-name");
	if ($el) {
		$.post("http://garages/spawnVehicles", JSON.stringify({ name: $el }));
	}
}));
/* --------------------------------------------------- */
$(document).on("click", "#storeVehicle", function () {
	$.post("http://garages/deleteVehicles");
});
/* ----------DEBOUNCE---------- */
function debounce(func, immediate) {
	var timeout
	return function () {
		var context = this, args = arguments
		var later = function () {
			timeout = null
			if (!immediate) func.apply(context, args)
		}
		var callNow = immediate && !timeout
		clearTimeout(timeout)
		timeout = setTimeout(later, 200)
		if (callNow) func.apply(context, args)
	}
}