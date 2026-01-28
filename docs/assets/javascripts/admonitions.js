/**
 * Client-side admonition renderer for Zensical
 * Converts !!! admonition syntax to HTML when Zensical doesn't support it natively
 */

(function() {
    'use strict';

    const ADMONITION_TYPES = {
        'note': { icon: 'ℹ️', title: 'Note' },
        'warning': { icon: '⚠️', title: 'Warning' },
        'caution': { icon: '⚠️', title: 'Caution' },
        'tip': { icon: '💡', title: 'Tip' },
        'important': { icon: '❗', title: 'Important' },
        'info': { icon: 'ℹ️', title: 'Info' }
    };

    function parseAdmonitions() {
        // Find all content blocks that might contain admonitions
        const contentBlocks = document.querySelectorAll('.md-content article, .md-content__inner');
        
        contentBlocks.forEach(block => {
            let html = block.innerHTML;
            
            // Pattern: !!! type\n    content (with proper indentation)
            const pattern = /^<p>!!!\s+(note|warning|caution|tip|important|info)\s*<\/p>\n<pre><code>(.+?)<\/code><\/pre>/gms;
            
            html = html.replace(pattern, (match, type, content) => {
                const config = ADMONITION_TYPES[type] || ADMONITION_TYPES['note'];
                const cleanContent = content
                    .replace(/&lt;/g, '<')
                    .replace(/&gt;/g, '>')
                    .replace(/&amp;/g, '&')
                    .trim();
                
                return `
                    <div class="admonition ${type}">
                        <p class="admonition-title">${config.icon} ${config.title}</p>
                        <p>${cleanContent}</p>
                    </div>
                `;
            });
            
            // Also handle inline format: <p>!!! type</p><p>content</p>
            html = html.replace(
                /<p>!!!\s+(note|warning|caution|tip|important|info)<\/p>\s*<p>(.+?)<\/p>/gs,
                (match, type, content) => {
                    const config = ADMONITION_TYPES[type] || ADMONITION_TYPES['note'];
                    return `
                        <div class="admonition ${type}">
                            <p class="admonition-title">${config.icon} ${config.title}</p>
                            <p>${content}</p>
                        </div>
                    `;
                }
            );
            
            block.innerHTML = html;
        });
    }

    // Run on page load
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', parseAdmonitions);
    } else {
        parseAdmonitions();
    }

    // Re-run on navigation for instant navigation feature
    if (window.MutationObserver) {
        const observer = new MutationObserver(() => {
            parseAdmonitions();
        });
        
        observer.observe(document.body, {
            childList: true,
            subtree: true
        });
    }
})();
