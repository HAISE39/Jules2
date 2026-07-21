/* Overhauled JavaScript for Vellixao Premium Portfolio */

// --- Mobile Navigation Hamburg / Cancel ---
function hamburg() {
    const navbar = document.querySelector(".dropdown");
    if (navbar) navbar.classList.add("active");
}

function cancel() {
    const navbar = document.querySelector(".dropdown");
    if (navbar) navbar.classList.remove("active");
}

// --- High-Performance Typewriter Mechanism ---
const typewriterPhrases = [
    "DEVELOPER",
    "UI/UX DESIGNER",
    "SYSTEM ARCHITECT",
    "AUTOMATION SPECIALIST"
];

let phraseIndex = 0;
let charIndex = 0;
let isDeleting = false;
const typewriterTextElement = document.querySelector(".typewriter-text");

function type() {
    if (!typewriterTextElement) return;

    const currentPhrase = typewriterPhrases[phraseIndex];

    if (isDeleting) {
        typewriterTextElement.textContent = currentPhrase.substring(0, charIndex - 1);
        charIndex--;
    } else {
        typewriterTextElement.textContent = currentPhrase.substring(0, charIndex + 1);
        charIndex++;
    }

    let typingSpeed = isDeleting ? 40 : 100;

    if (!isDeleting && charIndex === currentPhrase.length) {
        typingSpeed = 2000; // Pause at full phrase
        isDeleting = true;
    } else if (isDeleting && charIndex === 0) {
        isDeleting = false;
        phraseIndex = (phraseIndex + 1) % typewriterPhrases.length;
        typingSpeed = 500; // Pause before typing next phrase
    }

    setTimeout(type, typingSpeed);
}

// Start typewriter on load
document.addEventListener("DOMContentLoaded", () => {
    setTimeout(type, 1000);
});


// --- Advanced Interactive Constellation Node Particles Network ---
const canvas = document.getElementById("constellation-canvas");
if (canvas) {
    const ctx = canvas.getContext("2d");
    let particles = [];
    const maxParticles = 65;
    const connectionDistance = 110;

    let mouse = {
        x: null,
        y: null,
        radius: 120
    };

    window.addEventListener("mousemove", (e) => {
        mouse.x = e.clientX;
        mouse.y = e.clientY;
    });

    window.addEventListener("mouseout", () => {
        mouse.x = null;
        mouse.y = null;
    });

    function resizeCanvas() {
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
    }
    window.addEventListener("resize", resizeCanvas);
    resizeCanvas();

    class Particle {
        constructor() {
            this.x = Math.random() * canvas.width;
            this.y = Math.random() * canvas.height;
            this.vx = (Math.random() - 0.5) * 0.8;
            this.vy = (Math.random() - 0.5) * 0.8;
            this.radius = Math.random() * 2 + 1.5;
            this.baseRadius = this.radius;
        }

        update() {
            // Screen boundaries
            if (this.x < 0 || this.x > canvas.width) this.vx *= -1;
            if (this.y < 0 || this.y > canvas.height) this.vy *= -1;

            this.x += this.vx;
            this.y += this.vy;

            // Mouse attraction / interaction
            if (mouse.x !== null && mouse.y !== null) {
                let dx = mouse.x - this.x;
                let dy = mouse.y - this.y;
                let dist = Math.sqrt(dx * dx + dy * dy);
                if (dist < mouse.radius) {
                    const force = (mouse.radius - dist) / mouse.radius;
                    this.x -= (dx / dist) * force * 1.5;
                    this.y -= (dy / dist) * force * 1.5;
                    this.radius = this.baseRadius * 1.8;
                } else {
                    if (this.radius > this.baseRadius) this.radius -= 0.1;
                }
            } else {
                if (this.radius > this.baseRadius) this.radius -= 0.1;
            }
        }

        draw() {
            ctx.beginPath();
            ctx.arc(this.x, this.y, this.radius, 0, Math.PI * 2);
            ctx.fillStyle = "rgba(0, 245, 212, 0.75)";
            ctx.fill();
        }
    }

    function initParticles() {
        particles = [];
        for (let i = 0; i < maxParticles; i++) {
            particles.push(new Particle());
        }
    }
    initParticles();

    function animateParticles() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);

        for (let i = 0; i < particles.length; i++) {
            particles[i].update();
            particles[i].draw();

            // Check distance to other particles and connect
            for (let j = i + 1; j < particles.length; j++) {
                let dx = particles[i].x - particles[j].x;
                let dy = particles[i].y - particles[j].y;
                let dist = Math.sqrt(dx * dx + dy * dy);

                if (dist < connectionDistance) {
                    const alpha = (1 - (dist / connectionDistance)) * 0.22;
                    ctx.beginPath();
                    ctx.moveTo(particles[i].x, particles[i].y);
                    ctx.lineTo(particles[j].x, particles[j].y);
                    ctx.strokeStyle = `rgba(157, 78, 221, ${alpha})`;
                    ctx.lineWidth = 0.8;
                    ctx.stroke();
                }
            }
        }
        requestAnimationFrame(animateParticles);
    }
    animateParticles();
}
