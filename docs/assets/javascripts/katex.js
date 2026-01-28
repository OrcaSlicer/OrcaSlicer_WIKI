if (typeof document$ !== 'undefined' && document$.subscribe) {
  document$.subscribe(({ body }) => {
    if (typeof renderMathInElement !== 'function') {
      return;
    }

    renderMathInElement(body, {
      delimiters: [
        { left: '$$', right: '$$', display: true },
        { left: '$', right: '$', display: false },
        { left: '\\(', right: '\\)', display: false },
        { left: '\\[', right: '\\]', display: true },
      ],
    });
  });
}
