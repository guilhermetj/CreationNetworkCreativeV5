var groupInContext = "";
/* ---------------------------------------------------------------------------------------------------------------- */
$(document).ready(function(){

	window.addEventListener("message",function(event){
		switch (event["data"]["action"]){
			case "openSystem":
				$("body").css("display","block");
				if ( event["data"]["group"] == "Police"|| event["data"]["group"] == "Policia"){
					groupInContext = "Policia"
				}
				else{groupInContext = event["data"]["group"]}
				requestMembers()
				requestMembersOn()
				requestMembersMax()
				groupMenssage()
			break;

			case "closeSystem":
				$("body").css("display","none");
			break;

			case "updateData":
				requestMembers()
				requestMembersOn()
				requestMembersMax()
				groupMenssage()
			break;
		
		};
	});

	document.onkeyup = function(data){
		if (data["which"] == 27){
			$.post("http://GroupFac/closeSystem");
		};
	};
});
/* ---------------------------------------------------------------------------------------------------------------- */
/* ----------Contratar----------- */
$(document).on("click",".img",function(){
	$("#wrapper").addClass("active");
	if (groupInContext == "Policia"){
	$("#wrapper").html(`
	
	<div class="close"></div> 
	<h1>Contratar</h1>
	<div id="seterContent">
		<input type="number" name="Passaport" id="userId" placeholder="Passaporte do jogador">
		
		<select name="Grupos" id="setTag">
					<option>Tenente Coronel</option>
					<Option>Major</Option>
					<option>Capitão</option>
					<Option>Tenente</Option>
					<option>Subtenente</option>
					<Option>1º Sargento</Option>
					<option>2º Sargento</option>
					<Option>3º Sargento</Option>
					<option>Cabo</option>
					<Option>Soldado</Option>
		</select>
	</div>

	<button type="submit" id="enviarContratar">Enviar</button>
	`);
	}
	else {
		$("#wrapper").html(`
	
		<div class="close"></div> 
		<h1>Contratar</h1>
		<div id="seterContent">
			<input type="number" name="Passaport" id="userId" placeholder="Passaporte do jogador">
			
			<select name="Grupos" id="setTag">
						<option>Gerente</option>
						<Option>Membro</Option>
			</select>
		</div>
	
		<button type="submit" id="enviarContratar">Enviar</button>
		`);
	}
});

$(document).on("click","#enviarContratar",function(e){
	const id = document.getElementById("userId").value
	const group = document.getElementById("setTag").value

	$.post("http://GroupFac/requestSetGroup",JSON.stringify({ id: id , set: group,group: groupInContext}));
	$("#wrapper").removeClass("active");
});
$(document).on("click",".close",function(){
	$("#wrapper").removeClass("active");
});
/* ----------***********----------- */

const requestMembers = () => {
	$.post("http://GroupFac/requestMembers",JSON.stringify({group: groupInContext}),(data) => {

		var nameList = data["result"]
		

	$("#member-content").html(`
		${nameList.map((item) => (`
		<div id="members" class="${item["status"]}">	
			<h1 id="member">${item["name"]}</h1>
			<h1 id="cargo_member">${item["cargo"]}</h1>
			<button class="edit" onclick="updateMember(${item["id"]})"></button>
			<button class="clean" onclick="deleteMember(${item["id"]},'${groupInContext}')"></button>
		</div>
		`)).join('')}
		`);
	});	
}

const requestMembersOn = () => {
	$.post("http://GroupFac/requestMembersOn",JSON.stringify({group: groupInContext}),(data) => {
		var nameList = data["result"]

		$(".membersOn").html(`
		${nameList.map((item) => (`${item["qtdOn"]}`)).join('')}`);
	});	
}


const requestMembersMax = () => {
	$.post("http://GroupFac/requestMembersMax",JSON.stringify({group: groupInContext}),(data) => {
		var nameList = data["result"]
				
		$(".membersQtd").html(`
		${nameList.map((item) => (`${item["qtd"]}`)).join('')}`);
		
		$(".slotMembers").html(`${nameList.map((item) => (`${item["maxQtd"] - item["qtd"]}`)).join('')}`);
	});	
}


const updateMember = (id) =>{
	
	$("#wrapper").addClass("active");

	if (groupInContext == "Policia"){
		$("#wrapper").html(`
		
		<div class="close"></div> 
		<h1>Editar cargo</h1>
		<div id="seterContent">
			<input type="number" name="Passaport" id="userId">
			<select name="Grupos" id="setTag">
						<option>Tenente Coronel</option>
						<Option>Major</Option>
						<option>Capitão</option>
						<Option>Tenente</Option>
						<option>Subtenente</option>
						<Option>1º Sargento</Option>
						<option>2º Sargento</option>
						<Option>3º Sargento</Option>
						<option>Cabo</option>
						<Option>Soldado</Option>
			</select>
		</div>
	
		<button type="submit" id="enviarUpdate">Enviar</button>
		`);
		const input = document.querySelector("#userId")
		document.getElementById('userId').value = id
		input.disabled=true;
		}
	else {
		$("#wrapper").html(`
		
		<div class="close"></div> 
		<h1>Editar cargo</h1>
		<div id="seterContent">
			<input type="number" name="Passaport" id="userId">
			
			<select name="Grupos" id="setTag">
						<option>Gerente</option>
						<Option>Membro</Option>
			</select>
		</div>

		<button type="submit" id="enviarUpdate">Enviar</button>
		`);
		const input = document.querySelector("#userId")
		document.getElementById('userId').value = id
		input.disabled=true;
		}
}
$(document).on("click","#enviarUpdate",function(e){
	const id = document.getElementById("userId").value
	const group = document.getElementById("setTag").value
	console.log(id,group)
	$.post("http://GroupFac/requestupdateMembers",JSON.stringify({ id: id , set: group}));
	$("#wrapper").removeClass("active");
	
});

const deleteMember = (id,group) =>{
	
	$("#wrapper").addClass("active");
	$("#wrapper").html(`
	
	<div class="close"></div> 
	<h4> Deseja mesmo remover o usuário?</h4>
	<div id="seterContent">
	</div>

	<button type="submit" id="enviarDelete" onclick="enviarDelete(${id},'${group}')">Sim</button>
	`);
	

}
const enviarDelete = (id,group)=>{
	$.post("http://GroupFac/requestdeleteMembers",JSON.stringify({ id: id,group: group}));
	$("#wrapper").removeClass("active");	
}

const groupMenssage = () =>{
	
	$.post("http://GroupFac/requestgroupMensage",JSON.stringify({group: groupInContext}),(data) => {
		var nameList = data["result"]
				
		$(".mensagem").html(`
		${nameList.map((item) => (`${item["msg"]}`)).join('')}`);
		
	});	
		
}


const SetGroupMsg = () => {
	$("#wrapper").addClass("active");
	$("#wrapper").html(`
		
		<div class="close"></div> 
		<h1>Mensagem</h1>
			<textarea id="text-edit" class="mensage" cols="30" rows="10"></textarea>
		<button type="submit" id="enviarMensage">Enviar</button>`
		)}

$(document).on("click","#enviarMensage",function(e){
	const msg = document.getElementById("text-edit").value

	$.post("http://GroupFac/requestSetGroupMensage",JSON.stringify({mensage: msg,group: groupInContext}),(data) => {
	});
	$("#wrapper").removeClass("active");
});


$(document).on("click","#enviarUpdate",function(e){
	const id = document.getElementById("userId").value
	const group = document.getElementById("setTag").value
	console.log(id,group)
	$.post("http://GroupFac/requestupdateMembers",JSON.stringify({ id: id , set: group}));
	$("#wrapper").removeClass("active");
	
});


$(document).on("click","#registerMember",function(e){
	$.post("http://tablet/requestBuy",JSON.stringify({ name: e["target"]["dataset"]["name"] }));
});

/* ----------FORMAT---------- */
const format = (n) => {
	var n = n.toString();
	var r = '';
	var x = 0;

	for (var i = n.length; i > 0; i--) {
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? '.' : '');
		x = x == 2 ? 0 : x + 1;
	}

	return r.split('').reverse().join('');
};
