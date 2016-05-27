eggCrack = new Audio("crack.wav")
$('egg').click (e) ->
	egg = $(this)
	if egg.find('crack').length < 6
		$(this).append('<crack />').finish().effect("shake", {duration: 240, distance: 10, times: 2})
		eggCrack.currentTime = 0
		eggCrack.play()
	else
		egg.fadeOut()
		$('<img class="nugget" src="golden-nugget.png"/>').appendTo('ground')
		ga('send', 'event', 'Egg', 'nugget')

i = 0
changeTime = (e) ->
	i++
	$('sun').animate({
			top: if i % 4 == 0 then "0%" else if i % 2 then "50%" else "100%"
			left: if i % 4 == 3 then "0%" else if i % 2 then "100%" else "50%"
		}, {
			specialEasing: {
				top: if i % 2 then "easeInSine" else "easeOutSine" 
				left: if i % 2 then "easeOutSine" else "easeInSine"
			}
		})
	$('moon').animate({
		top: if i % 4 == 0 then "100%" else if i % 2 then "50%" else "0%"
		left: if i % 4 == 3 then "100%" else if i % 2 then "0%" else "50%"
		}, {
			specialEasing: {
				top: if i % 2 then "easeInSine" else "easeOutSine" 
				left: if i % 2 then "easeOutSine" else "easeInSine"
			}
		})
	$('sky').animate {
		backgroundColor: if i % 2 then "#FF4500" else if i % 4 == 0 then "#1D70B2" else "black"
	}

$('sun, moon').click changeTime
