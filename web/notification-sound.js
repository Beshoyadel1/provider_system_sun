(() => {
  const AudioContext = window.AudioContext || window.webkitAudioContext;
  const soundUrl = new URL('assets/assets/sounds/notification.mp3', document.baseURI);
  const channels = new Map();
  let context;
  let buffer;

  function unlock(event) {
    if (!event.isTrusted || !AudioContext) return;
    context ??= new AudioContext();
    if (context.state !== 'running') {
      context.resume().catch((error) => console.debug('Notification audio:', error));
    }
  }

  // Resume in the browser's trusted event, including when Flutter restores a session.
  window.addEventListener('click', unlock, true);
  window.addEventListener('keydown', unlock, true);

  function loadSound() {
    buffer ??= fetch(soundUrl).then((response) => {
      if (!response.ok) throw new Error(`Notification audio HTTP ${response.status}`);
      return response.arrayBuffer();
    }).then((bytes) => context.decodeAudioData(bytes)).catch((error) => {
      buffer = undefined;
      throw error;
    });
    return buffer;
  }

  function stop(loop) {
    const source = channels.get(loop)?.source;
    channels.delete(loop);
    if (source) {
      source.onended = null;
      source.stop();
      source.disconnect();
    }
  }

  window.stopSunNotificationSound = stop;
  window.playSunNotificationSound = async (loop) => {
    if (!AudioContext) return;
    stop(loop);
    context ??= new AudioContext();
    const playback = {};
    channels.set(loop, playback);
    const audio = await loadSound();
    if (channels.get(loop) !== playback) return;

    const source = context.createBufferSource();
    source.buffer = audio;
    source.loop = loop;
    source.connect(context.destination);
    source.onended = () => {
      if (channels.get(loop) === playback) channels.delete(loop);
      source.disconnect();
    };
    source.start();
    playback.source = source;
  };
})();
