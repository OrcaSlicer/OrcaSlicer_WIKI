(function () {
  const tracked = new Set();

  const ensureTracked = (img) => {
    if (img.dataset.lightSrc && img.dataset.darkSrc) {
      tracked.add(img);
      return;
    }

    const src = img.getAttribute('src') || '';
    const match = src.match(/^(.*)_dark(\.svg(?:\?.*)?)$/i);
    if (!match) return;

    img.dataset.darkSrc = src;
    img.dataset.lightSrc = `${match[1]}${match[2]}`;
    tracked.add(img);
  };

  const applyTheme = () => {
    const dark = (document.body?.dataset?.mdColorScheme || '').toLowerCase() === 'slate';
    tracked.forEach((img) => {
      const target = dark ? img.dataset.darkSrc : img.dataset.lightSrc;
      if (target && img.getAttribute('src') !== target) {
        img.setAttribute('src', target);
      }
    });
  };

  const refresh = () => {
    document.querySelectorAll('img').forEach(ensureTracked);
    applyTheme();
  };

  const onReady = () => refresh();

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', onReady, { once: true });
  } else {
    onReady();
  }

  if (window.document$ && typeof window.document$.subscribe === 'function') {
    window.document$.subscribe(onReady);
  }

  const observer = new MutationObserver((mutations) => {
    if (mutations.some((m) => m.attributeName === 'data-md-color-scheme')) {
      applyTheme();
    }
  });

  if (document.body) {
    observer.observe(document.body, { attributes: true, attributeFilter: ['data-md-color-scheme'] });
  }
})();
