DURATION = 240

eggCrackSound = new Audio("crack.wav")
crackEgg = (e) ->
	egg = $ this
	if egg.find('crack').length < 6
		$ this
			.append '<crack />'
			.effect("shake", {
				duration: DURATION
				distance: 10
				times: 2
				})
		eggCrackSound.currentTime = 0
		eggCrackSound.play()
	else
		egg.hide()
		$('<img class="nugget" src="golden-nugget.png"/>').appendTo('ground')
		ga('send', 'event', 'Egg', 'nugget')

$('egg').click _.throttle crackEgg, DURATION, {trailing: false}

TIMES = ['day', 'twilight', 'night', 'twilight']
POSITIONS = ['0%', '50%', '100%', '50%']
EASINGS = ['easeInSine', 'easeOutSine']
time = 0
changeTime = (e) ->

	$('sky, ground, egg, .egg').switchClass TIMES[time % 4], TIMES[(time + 1) % 4], DURATION
	time++
	
	options = {
		specialEasing: {
			top: EASINGS[(time + 1) % 2]
			left: EASINGS[time % 2]
		}
		duration: DURATION
	}
	
	$('sun').animate({
			top: POSITIONS[time % 4]
			left: POSITIONS[(time + 1) % 4]
		}, options)
	$('moon').animate({
			top: POSITIONS[(time + 2) % 4]
			left: POSITIONS[(time + 3) % 4]
		}, options)


$('sky').click _.throttle changeTime, DURATION, {trailing: false}

SEASONS = ['spring', 'summer', 'autumn', 'winter']
season = 0
changeSeason = (e) ->
	ground = $ this
	if (e.target == this)
		ground.switchClass SEASONS[season % 4], SEASONS[(season + 1) % 4], DURATION
		season++

$('ground').click _.throttle changeSeason, DURATION, {trailing: false}
