/**
 * Custom TOC scroll observer - highlights based on natural reading position
 * instead of what's at the top of the screen
 */
(function() {
    'use strict';
    
    console.log('TOC-SCROLL-CONTROL: Initializing');
    
    // Run after page is ready
    function init() {
        // Wait a bit for Material to set up its observers
        setTimeout(() => {
            console.log('TOC-SCROLL-CONTROL: Starting setup');
            setupCustomObserver();
        }, 500);
    }
    
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
    
    function setupCustomObserver() {
        // Find all headers with IDs in the content area
        const headers = document.querySelectorAll('.md-content h1[id], .md-content h2[id], .md-content h3[id], .md-content h4[id], .md-content h5[id], .md-content h6[id]');
        const tocNav = document.querySelector('.md-nav--secondary');
        
        if (!tocNav) {
            console.log('TOC-SCROLL-CONTROL: No TOC nav found');
            return;
        }
        
        const tocLinks = tocNav.querySelectorAll('.md-nav__link');
        console.log('TOC-SCROLL-CONTROL: Found', headers.length, 'headers and', tocLinks.length, 'TOC links');
        
        if (headers.length === 0 || tocLinks.length === 0) {
            return;
        }
        
        // Try to disable Material's observer by removing the data attribute
        const tocSidebar = document.querySelector('[data-md-type="toc"]');
        if (tocSidebar) {
            tocSidebar.removeAttribute('data-md-type');
            tocSidebar.removeAttribute('data-md-component');
            console.log('TOC-SCROLL-CONTROL: Disabled Material TOC observer');
        }
        
        // Build map of IDs to links
        const idToLink = new Map();
        tocLinks.forEach(link => {
            const href = link.getAttribute('href');
            if (href && href.startsWith('#')) {
                idToLink.set(decodeURIComponent(href.substring(1)), link);
            }
        });
        
        // Track currently active link
        let currentActive = null;
        
        function setActive(link) {
            if (link === currentActive) return;
            
            // Remove all active classes
            tocLinks.forEach(l => l.classList.remove('md-nav__link--active'));
            
            // Set new active
            if (link) {
                link.classList.add('md-nav__link--active');
                currentActive = link;
                console.log('TOC-SCROLL-CONTROL: Activated', link.textContent.trim());
            }
        }
        
        // Use scroll event with debounce for more reliable detection
        let scrollTimeout;
        function onScroll() {
            clearTimeout(scrollTimeout);
            scrollTimeout = setTimeout(() => {
                // Find which header is in the "reading zone" (25% from top)
                const viewportHeight = window.innerHeight;
                const readingZoneTop = viewportHeight * 0.20;  // 20% from top
                const readingZoneBottom = viewportHeight * 0.60;  // 60% from top
                
                let bestHeader = null;
                let bestDistance = Infinity;
                
                headers.forEach(header => {
                    const rect = header.getBoundingClientRect();
                    
                    // Check if header is above the reading zone bottom (we've scrolled past it or it's in view)
                    if (rect.top <= readingZoneBottom) {
                        // Prefer headers closest to the reading zone center
                        const targetY = readingZoneTop + (readingZoneBottom - readingZoneTop) / 2;
                        const distance = Math.abs(rect.top - targetY);
                        
                        if (distance < bestDistance) {
                            bestDistance = distance;
                            bestHeader = header;
                        }
                    }
                });
                
                // Fallback: if nothing found, use the last header above viewport center
                if (!bestHeader) {
                    for (let i = headers.length - 1; i >= 0; i--) {
                        const rect = headers[i].getBoundingClientRect();
                        if (rect.top < viewportHeight / 2) {
                            bestHeader = headers[i];
                            break;
                        }
                    }
                }
                
                if (bestHeader) {
                    const link = idToLink.get(bestHeader.id);
                    if (link) {
                        setActive(link);
                    }
                }
            }, 10);
        }
        
        // Listen to scroll
        window.addEventListener('scroll', onScroll, { passive: true });
        
        // Initial check
        onScroll();
        
        console.log('TOC-SCROLL-CONTROL: Observer active');
    }
})();
