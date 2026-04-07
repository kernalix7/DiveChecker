/* ══════════════════════════════════════════════
   DiveChecker Landing Page — Script
   ══════════════════════════════════════════════ */

document.addEventListener('DOMContentLoaded', () => {
    // ── Nav scroll effect ──
    const nav = document.getElementById('nav');
    const onScroll = () => {
        nav.classList.toggle('scrolled', window.scrollY > 60);
    };
    window.addEventListener('scroll', onScroll, { passive: true });
    onScroll();

    // ── Mobile menu ──
    const hamburger = document.getElementById('hamburger');
    const mobileMenu = document.getElementById('mobileMenu');

    hamburger.addEventListener('click', () => {
        mobileMenu.classList.toggle('open');
        const spans = hamburger.querySelectorAll('span');
        if (mobileMenu.classList.contains('open')) {
            spans[0].style.transform = 'rotate(45deg) translate(5px, 5px)';
            spans[1].style.opacity = '0';
            spans[2].style.transform = 'rotate(-45deg) translate(5px, -5px)';
        } else {
            spans[0].style.transform = '';
            spans[1].style.opacity = '';
            spans[2].style.transform = '';
        }
    });

    // Close mobile menu on link click
    mobileMenu.querySelectorAll('a').forEach(link => {
        link.addEventListener('click', () => {
            mobileMenu.classList.remove('open');
            const spans = hamburger.querySelectorAll('span');
            spans[0].style.transform = '';
            spans[1].style.opacity = '';
            spans[2].style.transform = '';
        });
    });

    // ── Scroll reveal ──
    const revealElements = document.querySelectorAll('.reveal, .reveal-up');
    const revealObserver = new IntersectionObserver(
        (entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('visible');
                    revealObserver.unobserve(entry.target);
                }
            });
        },
        {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        }
    );

    revealElements.forEach(el => revealObserver.observe(el));

    // ── Smooth scroll for nav links ──
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', (e) => {
            const href = anchor.getAttribute('href');
            if (href === '#') return;
            e.preventDefault();
            const target = document.querySelector(href);
            if (target) {
                const navHeight = nav.offsetHeight;
                const targetPos = target.getBoundingClientRect().top + window.scrollY - navHeight - 20;
                window.scrollTo({ top: targetPos, behavior: 'smooth' });
            }
        });
    });

    // ── Floating particles (subtle) ──
    const particlesContainer = document.getElementById('particles');
    if (particlesContainer) {
        for (let i = 0; i < 30; i++) {
            const particle = document.createElement('div');
            particle.style.cssText = `
                position: absolute;
                width: ${Math.random() * 3 + 1}px;
                height: ${Math.random() * 3 + 1}px;
                background: rgba(77,184,255,${Math.random() * 0.15 + 0.05});
                border-radius: 50%;
                left: ${Math.random() * 100}%;
                top: ${Math.random() * 100}%;
                animation: particleFloat ${Math.random() * 20 + 15}s linear infinite;
                animation-delay: ${Math.random() * -20}s;
            `;
            particlesContainer.appendChild(particle);
        }

        // Add particle animation
        const style = document.createElement('style');
        style.textContent = `
            @keyframes particleFloat {
                0% { transform: translate(0, 0) scale(1); opacity: 0; }
                10% { opacity: 1; }
                90% { opacity: 1; }
                100% { transform: translate(${Math.random() > 0.5 ? '' : '-'}${Math.random() * 200 + 50}px, -${Math.random() * 300 + 100}px) scale(0); opacity: 0; }
            }
        `;
        document.head.appendChild(style);
    }

    // ── Counter animation for hero stats ──
    const animateCounter = (el, target, suffix = '') => {
        const duration = 2000;
        const start = performance.now();
        const isFloat = String(target).includes('.');

        const update = (now) => {
            const elapsed = now - start;
            const progress = Math.min(elapsed / duration, 1);
            const eased = 1 - Math.pow(1 - progress, 4);
            const current = isFloat
                ? (target * eased).toFixed(2)
                : Math.round(target * eased);
            el.textContent = current + suffix;
            if (progress < 1) requestAnimationFrame(update);
        };

        requestAnimationFrame(update);
    };

    // Observe hero stats for counter animation
    const heroStats = document.querySelectorAll('.hero-stat-num');
    const statsObserver = new IntersectionObserver(
        (entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const el = entry.target;
                    const text = el.textContent;
                    if (text === '100Hz') {
                        animateCounter(el, 100, 'Hz');
                    } else if (text === '0ms') {
                        el.textContent = '0ms';
                    } else if (text === '0.01') {
                        animateCounter(el, 0.01);
                    }
                    statsObserver.unobserve(el);
                }
            });
        },
        { threshold: 0.5 }
    );

    heroStats.forEach(stat => statsObserver.observe(stat));
});
