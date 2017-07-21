SmartPlay('#container', {
	uiLayout: 'overlay',

	adRequest: %@,
	
	debug: true,

	featureMatrix: {
		'endingScreen': {
			enabled: false
		},
		'bestFit': {
			enabled: false
		}
	},

	behaviourMatrix: {
		'init': { muted: false, collapsed: false },
		'onScreen': { muted: false },
		'onClick': { muted: false },
		'mouseOut': { muted: false }
	},

	onStartCallback: function() {
		try {
			webkit.messageHandlers.SCNative.postMessage("onStartCallback");
		} catch(err) {}
	},

	onEndCallback: function() {
		try {
			webkit.messageHandlers.SCNative.postMessage("onEndCallback");
		} catch(err) {}
	},

	onCappedCallback: function() {
		try {
			webkit.messageHandlers.SCNative.postMessage("onCappedCallback");
		} catch(err) {}
	},

	onPrefetchCompleteCallback: function() {
		try {
			webkit.messageHandlers.SCNative.postMessage("onPrefetchCompleteCallback");
		} catch(err) {}
	},

	prefetching: true
});
