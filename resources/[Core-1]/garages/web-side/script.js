$(document).ready(function(){
	window.addEventListener('message',function(event){
		let item = event.data;
		switch(item.action){
			case 'openNUI':
				updateGarages();
				$('body').show();
			break;

			case 'closeNUI':
				$('body').hide();
				$('#background').removeClass('aberto')
			break;

			case 'updateGarages':
				updateGarages();
			break;
		}
	});

	document.onkeyup = function(data){
		if (data.which == 27){
			sendData("ButtonClick","exit")
			$('#background').removeClass('aberto')
		}
	};

	function doTruncarStr(str, size){
		if (str==undefined || str=='undefined' || str =='' || size==undefined || size=='undefined' || size ==''){
			return str;
		}
		 
		var shortText = str;
		if(str.length >= size+3){
			shortText = str.substring(0, size).concat('...');
		}
		return shortText;
	}  

	const updateGarages = () => {
		$.post('http://garages/myVehicles',JSON.stringify({}),(data) => {
			const nameList = data.vehicles.sort((a,b) => (a.name2 > b.name2) ? 1: -1);
			
			$('#scroll').html(`
				
				${nameList.map((item) => (`

				<div class="car" data-name="${item.name}" data-engine="${item.engine}" data-body="${item.body}" data-fuel="${item.fuel}">
                    <div class="nome"><h6>${doTruncarStr(item.name2,10)}</h6></div>
                    <div class="image" style="background-image: url('http://177.54.148.115/garages/${item.name}.png');></div>
                    <div class="line"></div>
                </div>
	
				`)).join('')}
			`);
	
		});
		

	}
});

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

const sendData = (name,data) => {
	$.post("http://garages/"+name,JSON.stringify(data),function(datab){});
}


$(document).on('click','.car',function(){
	let $el = $(this);
	let isActive = $el.hasClass('active');
	if (isActive) return;
	$('.car').removeClass('active');
    if(!isActive) $el.addClass('active');
    
	$('h1').html($(this).data('name'))
	console.log(' fuel: ', $(this).data('fuel') + ' motor: ', $(this).data('engine') + ' lataria: ', $(this).data('body'))
	$('#exposicao-image').css('background-image', 'url(' + `http://177.54.148.115/garages/${$(this).data('name')}.png` + ')');
});

$(document).on('click','#retirar-guardar',function(){
	let $el = $('.car.active');
	if($el) {
		$.post('http://garages/spawnVehicles',JSON.stringify({
			name: $el.attr('data-name')
		}));
		sendData("ButtonClick","exit")
		$('#background').removeClass('aberto')
	}
})

$(document).on('click','#guardar',function(){
	$.post('http://garages/deleteVehicles',JSON.stringify({}));
})

$(document).on('click','#button',function(){
	if($("#scroll").is(":visible")) {
		$('#background').addClass('fechado')
		$('#background').removeClass('aberto')
		$('#scroll').hide(1000)
	} else {
		$('#background').removeClass('fechado')
		$('#background').addClass('aberto')
		$('#scroll').show(1000)
	}
})

$(document).on('click','#bar',function(){
	$('#bar').css('background-image', 'url(' + `img/bar-open.svg` + ')');
})