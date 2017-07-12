window._smartclip_amp = {};
window.context = {
	initialIntersection: {
		rootBounds: {x: 0, y: 0, width: parseInt(%f, 10), height: parseInt(%f, 10)}
	},
	requestResize: function() {},
	renderStart: function() {},
	observeIntersection: function(callback) {
		window.observeIntersectionCallback = callback;
	},
	onResizeDenied: function() {}
};
