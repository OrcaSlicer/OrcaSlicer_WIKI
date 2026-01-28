/**
 * Client-side admonition renderer for GitHub Alerts
 * Converts GitHub alert syntax (> [!NOTE]) to styled HTML admonitions
 */

(function() {
    'use strict';

    const ADMONITION_TYPES = {
        'NOTE': { icon: 'ℹ️', title: 'Note', class: 'note' },
        'WARNING': { icon: '⚠️', title: 'Warning', class: 'warning' },
        'CAUTION': { icon: '⚠️', title: 'Caution', class: 'caution' },
        'TIP': { icon: '💡', title: 'Tip', class: 'tip' },
        'IMPORTANT': { icon: '❗', title: 'Important', class: 'important' },
        'INFO': { icon: 'ℹ️', title: 'Info', class: 'info' }
    };

    function parseAdmonitions() {
        console.log('Running parseAdmonitions...');
        
        // Find all blockquote elements that haven't been processed
        const blockquotes = document.querySelectorAll('blockquote:not([data-admonition-processed])');
        console.log(`Found ${blockquotes.length} unprocessed blockquotes`);
        
        blockquotes.forEach((blockquote, bqIndex) => {
            // Get all paragraphs in the blockquote
            const paragraphs = Array.from(blockquote.querySelectorAll('p'));
            console.log(`Blockquote ${bqIndex} has ${paragraphs.length} paragraphs`);
            
            if (paragraphs.length === 0) return;
            
            // Look for alert markers in any paragraph
            const alertParagraphs = [];
            paragraphs.forEach((p, index) => {
                const text = p.textContent.trim();
                console.log(`Paragraph ${index} text:`, text.substring(0, 50));
                
                // Match [!TYPE] at the start, with or without text after
                const match = text.match(/^\[!(NOTE|WARNING|CAUTION|TIP|IMPORTANT|INFO)\]/i);
                if (match) {
                    console.log(`Found alert type: ${match[1]}`);
                    // Get the text after [!TYPE] including newlines
                    const afterMarker = text.replace(/^\[!(NOTE|WARNING|CAUTION|TIP|IMPORTANT|INFO)\]\s*/i, '');
                    alertParagraphs.push({ 
                        index, 
                        element: p, 
                        type: match[1].toUpperCase(), 
                        content: afterMarker
                    });
                }
            });
            
            console.log(`Found ${alertParagraphs.length} alert paragraphs`);
            
            // If we found alert markers, process them
            if (alertParagraphs.length > 0) {
                const fragment = document.createDocumentFragment();
                
                alertParagraphs.forEach((alert) => {
                    const config = ADMONITION_TYPES[alert.type] || ADMONITION_TYPES['NOTE'];
                    
                    // Create admonition div
                    const admonition = document.createElement('div');
                    admonition.className = `admonition ${config.class}`;
                    
                    // Create title
                    const title = document.createElement('p');
                    title.className = 'admonition-title';
                    title.textContent = `${config.icon} ${config.title}`;
                    admonition.appendChild(title);
                    
                    // Add content - clone the paragraph and remove the alert marker
                    if (alert.content) {
                        const contentP = document.createElement('p');
                        // Get the HTML and remove the marker
                        const originalHTML = alert.element.innerHTML;
                        const cleanHTML = originalHTML.replace(/^\[!(NOTE|WARNING|CAUTION|TIP|IMPORTANT|INFO)\]\s*/i, '');
                        contentP.innerHTML = cleanHTML;
                        admonition.appendChild(contentP);
                    }
                    
                    fragment.appendChild(admonition);
                });
                
                // Mark as processed
                blockquote.dataset.admonitionProcessed = 'true';
                
                // Replace blockquote with the admonitions
                console.log('Replacing blockquote with admonitions');
                blockquote.parentNode.replaceChild(fragment, blockquote);
            }
        });
    }

    // Run immediately and set up observers
    function init() {
        console.log('Admonitions.js initialized');
        
        // Initial parse
        parseAdmonitions();
        
        // Set up mutation observer for dynamic content
        const observer = new MutationObserver((mutations) => {
            let shouldParse = false;
            mutations.forEach(mutation => {
                mutation.addedNodes.forEach(node => {
                    if (node.nodeType === 1 && (node.tagName === 'BLOCKQUOTE' || node.querySelector('blockquote'))) {
                        shouldParse = true;
                    }
                });
            });
            if (shouldParse) {
                console.log('Mutation detected, reparsing...');
                parseAdmonitions();
            }
        });
        
        // Observe the main content area
        const target = document.querySelector('.md-content__inner') || 
                      document.querySelector('main') || 
                      document.querySelector('.md-content') || 
                      document.body;
        
        console.log('Observing target:', target);
        observer.observe(target, {
            childList: true,
            subtree: true
        });
    }

    // Execute when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
    
    // Also run after delays to catch any late-loading content
    setTimeout(() => {
        console.log('Running delayed parse (100ms)');
        parseAdmonitions();
    }, 100);
    
    setTimeout(() => {
        console.log('Running delayed parse (500ms)');
        parseAdmonitions();
    }, 500);
})();
