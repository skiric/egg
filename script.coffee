DURATION = 240

PHASES = ['full', 'waningGibbous', 'thirdQuarter', 'waningCrescent', 'new', 'waxingCrescent', 'firstQuarter', 'waxingGibbous']
SEASONS = ['spring', 'summer', 'autumn', 'winter']
TIMES = ['day', 'twilight', 'night', 'twilight']
POSITIONS = ['0%', '50%', '100%', '50%']
EASINGS = ['easeInSine', 'easeOutSine']
REWARDS =
	spring:
		day: 'chick'
		#twilight: 'bunny'
		#night: 'cricket'
	summer:
		day: 'beachball'
		#twilight: 'sunglasses'
		#night: 'firefly'
	autumn:
		day: 'pumpkin'
		#twilight: 'scarecrow'
		#night: 'ghost'
	winter:
		day: 'snowman'
		#twilight: 'sled'
		#night: 'ice'

eggCrackSound = new Audio("audio/crack.wav")

season = 0
phase = 0
time = 0

# Gets the current phase, or a future phase.
getPhase = (offset = 0) -> PHASES[(phase + offset) % 8]
# Gets the current season, or a future season.
getSeason = (offset = 0) -> SEASONS[(season + offset) % 4]
# Gets the current time, or a future time.
getTime = (offset = 0) -> TIMES[(time + offset) % 4]
# Gets a position based on a time (now or in the future).
getPosition = (offset = 0) -> POSITIONS[(time + offset) % 4]
# Gets the proper reward for the season and time.
getReward = () -> REWARDS[getSeason()][getTime()] || REWARDS[getSeason()].day

# Adds a crack to the egg.
crackEgg = (e) ->
	egg = $ this
	if egg.find('crack').length < 6
		$ this
			.append '<crack />'
			.effect "shake",
				duration: DURATION
				distance: 10
				times: 2
		#eggCrackSound.currentTime = 0
		eggCrackSound.play()
	else
		egg.hide()
		reward = getReward()
		$ "<img class='nugget' src='svg/#{reward}.svg'/>"
			.appendTo 'ground'
			.addClass TIMES[time % 4]
			.addClass SEASONS[season % 4]
		new Audio("audio/#{reward}.wav").play()
		ga 'send', 'event', 'Reward', "#{reward}"

# Advances the day cycle.
changeTime = (e) ->
	$('sky, ground, egg').switchClass getTime(), getTime(1), DURATION
	#$('cloud').switchClass(getTime(), getTime(1), DURATION).dequeue()
	time++

	options = 
		specialEasing:
			top: EASINGS[(time + 1) % 2]
			left: EASINGS[time % 2]
		duration: DURATION
	
	$('sun').animate
			top: getPosition()
			left: getPosition(1)
		, options

	options.complete = changePhase

	$('moon').animate
			top: getPosition(2)
			left: getPosition(3)
		, options

# Advances the moon cycle.
changePhase = () ->
	if time % 4 is 0
		phase++
		phaseName = getPhase()
		$('#moon').attr 'href', "svg/moon.svg##{phaseName}Moon"

# Advances the season cycle.
changeSeason = (e) ->
	if e.target is this
		$ground = $ this
			.switchClass getSeason(), getSeason(1), DURATION

		$groundTransition = $ '<ground />'
			.hide()
			.addClass getSeason(1)
			.addClass getTime()
			.prependTo $ground
			.toggle 'slide',
				duration: 2 * DURATION,
				complete: () ->
					$groundTransition.remove()
					season++

# Adds a cloud to the sky.
addCloud = () ->
	size = _.random 5, 10
	height = _.random -size + 1, 20 - size
	#size *=  if height <= 0 then 1 else (50-height) / 50
	$cloud = $ '<cloud />'
		.appendTo 'sky'
		.css
			width: size + "vw"
			height: size + "vw"
			left: -size + "vw"
			top: height + "vh"
		.animate left: (size + 100) + "vw"
		,
			duration: 30000
			easing: 'linear'
			complete: () -> $cloud.remove()

# Randomly adds clouds to the sky.
spawnClouds = () ->
	for i in [0..3]
		_.delay addCloud, _.random(i * 500, (i+1) * 500)
	_.delay spawnClouds, _.random 2000, 4000

$('egg').click _.throttle crackEgg, DURATION, trailing: false
$('sky').click _.throttle changeTime, DURATION, trailing: false
$('ground').click _.throttle changeSeason, 2 * DURATION, trailing: false

spawnClouds()
