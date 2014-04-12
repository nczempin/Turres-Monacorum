function animate() {
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

