animate = function() {
	var canvas = document.getElementById('myCanvas');
	var context = canvas.getContext('2d');

	// update
	y += dir;
	if (y > 600 - imgLogo.height || y < 0) {
		dir *= -1;
	}
	// clear
	// context.clearRect(0, 0, canvas.width, canvas.height);

	// draw stuff
	context.drawImage(imgBackground, 0, 0);
	context.drawImage(imgLogo, 0, y);
	context.drawImage(imgMiddleground, 0, 0);
	// request new frame
	requestAnimFrame(function() {
		animate();
	});
}
window.requestAnimFrame = (function(callback) {
	return window.requestAnimationFrame || window.webkitRequestAnimationFrame
			|| window.mozRequestAnimationFrame || window.oRequestAnimationFrame
			|| window.msRequestAnimationFrame || function(callback) {
				window.setTimeout(callback, 1000 / 60);
			};
})();
var y = 0;
var dir = 1;
var imgLogo = new Image();
imgLogo.src = 'gfx/menu/logo.png';
var imgMiddleground = new Image();
imgMiddleground.src = "gfx/menu/menu_middleground.png";
var imgBackground = new Image();
imgBackground.src = "gfx/menu/menu_background.png";
var music = new Audio("sounds/music/Chiptune_2step_mp3.mp3");

main = function() {
	animate();
	music.loop = true;
	music.volume = .25;
	music.load();
}
