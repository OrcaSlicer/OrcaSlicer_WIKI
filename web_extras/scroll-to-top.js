/**
 * Custom scroll-to-top button with circular progress indicator
 * Shows user's reading progress and enables quick return to top
 */
(function () {
  'use strict';

  // Create the button structure
  const createButton = () => {
    const button = document.createElement('button');
    button.className = 'scroll-to-top';
    button.setAttribute('aria-label', 'Scroll to top');
    button.setAttribute('title', 'Back to top');
    
    // SVG for circular progress and arrow (using viewBox for proper scaling)
    button.innerHTML = `
      <svg class="progress-ring" viewBox="0 0 56 56">
        <circle class="progress-ring__background" 
          stroke="currentColor" 
          stroke-width="2" 
          fill="transparent" 
          r="24" 
          cx="28" 
          cy="28"/>
        <circle class="progress-ring__progress" 
          stroke="currentColor" 
          stroke-width="2" 
          fill="transparent" 
          r="24" 
          cx="28" 
          cy="28"/>
      </svg>
      <svg class="arrow-icon" viewBox="0 0 24 24" fill="none">
        <path d="M12 19V5M12 5L5 12M12 5L19 12" 
          stroke="currentColor" 
          stroke-width="2" 
          stroke-linecap="round" 
          stroke-linejoin="round"/>
      </svg>
    `;
    
    return button;
  };

  // Calculate scroll progress (0 to 1)
  const getScrollProgress = () => {
    const windowHeight = window.innerHeight;
    const documentHeight = document.documentElement.scrollHeight;
    const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
    
    // Maximum scrollable distance
    const maxScroll = documentHeight - windowHeight;
    
    // Avoid division by zero for short pages
    if (maxScroll <= 0) return 0;
    
    // Calculate progress (0 to 1)
    return Math.min(scrollTop / maxScroll, 1);
  };

  // Update the circular progress indicator
  const updateProgress = (button, progress) => {
    const circle = button.querySelector('.progress-ring__progress');
    
    // Get actual radius from the circle element (handles responsive sizing)
    const radius = parseFloat(circle.getAttribute('r')) || 24;
    const circumference = 2 * Math.PI * radius;
    
    // Calculate stroke offset (starts full, empties as we scroll)
    // We want it to fill as we scroll down, so invert the progress
    const offset = circumference * (1 - progress);
    
    circle.style.strokeDasharray = `${circumference} ${circumference}`;
    circle.style.strokeDashoffset = offset;
  };

  // Show/hide button based on scroll position
  const toggleVisibility = (button) => {
    const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
    
    // Show after scrolling down 300px
    if (scrollTop > 300) {
      button.classList.add('visible');
    } else {
      button.classList.remove('visible');
    }
  };

  // Smooth scroll to top
  const scrollToTop = () => {
    window.scrollTo({
      top: 0,
      behavior: 'smooth'
    });
  };

  // Handle scroll events
  const handleScroll = (button) => {
    const progress = getScrollProgress();
    updateProgress(button, progress);
    toggleVisibility(button);
  };

  // Initialize the button
  const init = () => {
    // Check if reduced motion is preferred
    const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    
    // Create and append button
    const button = createButton();
    document.body.appendChild(button);
    
    // Initialize progress
    updateProgress(button, 0);
    
    // Add click handler
    button.addEventListener('click', (e) => {
      e.preventDefault();
      scrollToTop();
    });
    
    // Add scroll handler with throttling for performance
    let ticking = false;
    window.addEventListener('scroll', () => {
      if (!ticking) {
        window.requestAnimationFrame(() => {
          handleScroll(button);
          ticking = false;
        });
        ticking = true;
      }
    }, { passive: true });
    
    // Initial check
    handleScroll(button);
    
    // Handle page navigation in instant loading mode
    if (window.document$ && typeof window.document$.subscribe === 'function') {
      window.document$.subscribe(() => {
        // Reset on page change
        setTimeout(() => handleScroll(button), 100);
      });
    }
  };

  // Initialize when DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init, { once: true });
  } else {
    init();
  }
})();
