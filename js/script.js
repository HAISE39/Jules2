// Premium Smooth Mobile Navigation Menu Toggle

function hamburg() {
    const navbar = document.querySelector(".dropdown");
    navbar.classList.add("active");
}

function cancel() {
    const navbar = document.querySelector(".dropdown");
    navbar.classList.remove("active");
}

// Buttery Smooth Typewriter Animation Effect

const texts = [
    "DEVELOPER",
    "PROGRAMMER",
    "DESIGNER",
    "DIGITAL CREATOR"
];

let speed = 80;
const textElements = document.querySelector(".typewriter-text");
let textIndex = 0;
let characterIndex = 0;

function typeWriter() {
    if (!textElements) return; // Prevent errors on non-landing pages

    if (characterIndex < texts[textIndex].length) {
        textElements.innerHTML += texts[textIndex].charAt(characterIndex);
        characterIndex++;
        setTimeout(typeWriter, speed);
    } else {
        setTimeout(eraseText, 1800); // Wait longer before erasing to look premium
    }
}

function eraseText() {
    if (!textElements) return;

    if (textElements.innerHTML.length > 0) {
        textElements.innerHTML = textElements.innerHTML.slice(0, -1);
        setTimeout(eraseText, 40);
    } else {
        textIndex = (textIndex + 1) % texts.length;
        characterIndex = 0;
        setTimeout(typeWriter, 500);
    }
}

// Ensure the typewriter only loads once window is ready
window.addEventListener("DOMContentLoaded", () => {
    typeWriter();
});
