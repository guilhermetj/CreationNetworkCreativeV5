const app = new Vue({
	el: '#app',

  	data: {
		metric: "kmh",
		enabled: false,
		visible: false,
		RPM: 0,
		velocity: 0,
		gear: 0,
		handbrake: false,
  	},

	computed: {
		calculatedRPM: function() {
			return (this.RPM * 9).toFixed(2)
		},

		calculatedSpeed: function() {
			const speed = Math.floor(Math.min(999, this.metric == "kmh" ? this.velocity * 3.6 : this.velocity * 2.236936)).toString()

			if(speed >= 100)
				return [ speed.substr(0, 1), speed.substr(1, 1), speed.substr(2, 1) ]

			else if(speed >= 10)
				return [ 0, speed.substr(0, 1), speed.substr(1, 1) ]

			else
				return [ 0, 0, speed ]
		},

		gearDisplay: function() {
			if(this.manual)
				return this.gear
			else
				return this.gear === 0 ? "R" : this.gear
		},

		gearStyle: function() {
			if(this.gear === 0)
				return "color: #FFF; border-color:#FFF;"

			else if(this.calculatedRPM > 7.5)
				return "color: rgb(235,30,76); border-color:rgb(235,30,76);"

			else
				return ""
		},

		unitDisplay: function() {
			return this.metric == "kmh" ? "KMH" : "MPH"
		}
	}
})

var sendEvent = function(name, data = {}) {
    if(name === "exit") {
        refreshTooltips()
    }

    if(window.invokeNative) {
        fetch(`https://${GetParentResourceName()}/${name}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify(data)
        })
    } else {
        $("#app").removeAttr("style")
    }
}

$(function() {
	$("#app").removeAttr("style")

    window.addEventListener("message", function(event) {
        var item = event.data;

		if(item.type == "updateData") {
			app.RPM = item.RPM
			app.velocity = item.velocity
			app.gear = item.gear
			app.handbrake = item.handbrake
			app.fuel = item.fuel
			app.damage = item.damage
			app.seatbelt = item.seatbelt
			app.locked = item.locked
			app.nitro = item.nitro

			if (item.nitro > 0) {
				$("#nitroshow").css("display","block")						
				$(".nitrodisplay").css("display","block")
				$("#nitroshow").attr("data-value",item.nitro / 20)
			} else {
				$("#nitroshow").css("display","block")						
				$(".nitrodisplay").css("display","block")
				$("#nitroshow").attr("data-value",0)
			}

			if (item.fuel > 0) {
				$("#fuelshow").css("display","block")						
				$(".fueldisplay").css("display","block")
				$("#fuelshow").attr("data-value",item.fuel / 10)
			} else {
				$("#fuelshow").css("display","block")						
				$(".fueldisplay").css("display","block")
				$("#fuelshow").attr("data-value",0)
			}

			if (item.damage > 0) {
				$("#damageshow").css("display","block")						
				$(".damagedisplay").css("display","block")
				$("#damageshow").attr("data-value",item.damage / 100)
			} else {
				$("#damageshow").css("display","block")						
				$(".damagedisplay").css("display","block")
				$("#damageshow").attr("data-value",0)
			}

			if (item.seatbelt) {
				$(".seatbeltondisplay").css("display","block")
				$(".seatbeltdisplay").css("display","none")
			} else {
				$(".seatbeltdisplay").css("display","block")
				$(".seatbeltondisplay").css("display","none")
			}

			if (item.locked == 2){			
				$(".lockedondisplay").css("display","block")
				$(".lockeddisplay").css("display","none")
			} else {
				$(".lockedondisplay").css("display","none")
				$(".lockeddisplay").css("display","block")
			}

		} else if(item.type == "updateMetric") {
			app.metric = item.metric

		} else if(item.type == "setEnabled") {
			app.enabled = item.enabled

		} else if(item.type == "setVisible") {
			app.visible = item.visible
		}

		return
    });

	sendEvent("ready")
});