(function () {
  var state = {
    interval: 30000,
    running: false,
    handle: null
  };

  function fireReady() {
    try {
      Microsoft.Dynamics.NAV.InvokeExtensibilityMethod(
        'Ready',            // AL event name in your controladdin
        [],                 // args to AL
        false,              // runOnServer
        function onSuccess() { /* no-op */ },
        function onError(err) { /* optional logging/backoff */ }
      );
    } catch (e) { /* ignore */ }
  }

  function scheduleNext() {
    if (!state.running) return;
    state.handle = window.setTimeout(invokeTick, state.interval);
  }

  function invokeTick() {
    if (!state.running) return;
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod(
      'OnTick',            // AL event name
      [],                  // args to AL (add items here if needed)
      false,               // runOnServer
      function onSuccess() {
        // AL finished handling the tick → schedule the next one
        scheduleNext();
      },
      function onError(err) {
        // Optionally implement backoff/retry strategy here
        scheduleNext();    // still schedule the next tick
      }
    );
  }

  // Exposed to AL
  window.Start = function (ms) {
    if (typeof ms === 'number' && ms > 0) state.interval = ms;

    // restart cleanly
    window.Stop();
    state.running = true;

    // fire first tick immediately; subsequent ticks are scheduled after AL completes
    invokeTick();
  };

  // Exposed to AL
  window.Stop = function () {
    state.running = false;
    if (state.handle) {
      window.clearTimeout(state.handle);
      state.handle = null;
    }
  };

  // Announce readiness once the script is loaded
  fireReady();
})();