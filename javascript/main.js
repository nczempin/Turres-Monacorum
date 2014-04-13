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
	context.drawImage(imgMiddleground, 0, 0);
	context.drawImage(imgLogo, 0, y);
	context.font = '18pt Calibri';
	context.fillStyle = 'white';
	context.fillText(mouseX + ", " + mouseY, 10, 25);
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
function writeMessage(canvas, message) {
	var context = canvas.getContext('2d');
	// context.clearRect(0, 0, canvas.width, canvas.height);
	context.font = '18pt Calibri';
	context.fillStyle = 'white';
	context.fillText(message, 10, 25);
}
function getMousePos(canvas, evt) {
	var rect = canvas.getBoundingClientRect();
	return {
		x : evt.clientX - rect.left,
		y : evt.clientY - rect.top
	};
}

var y = 0;
var dir = 1;
var mouseX = 0;
var mouseY = 0;
var imgLogo = new Image();
imgLogo.src = 'gfx/menu/logo.png';
var imgMiddleground = new Image();
imgMiddleground.src = "gfx/menu/menu_middleground.png";
var imgBackground = new Image();
imgBackground.src = "gfx/menu/menu_background.png";
var music = new Audio("sounds/music/Chiptune_2step_mp3.mp3");

main = function() {
	animate();
	var canvas = document.getElementById('myCanvas');
	var context = canvas.getContext('2d');
	canvas.addEventListener('mousemove', function(evt) {
		//update global mouse position. TODO: globals are bad
		var mousePos = getMousePos(canvas, evt);
		mouseX = mousePos.x;
		mouseY = mousePos.y;
	}, false);

	music.loop = true;
	music.volume = .25;
	music.load();
}
